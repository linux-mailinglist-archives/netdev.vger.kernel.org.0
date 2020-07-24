Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F63C22C856
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgGXOqt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jul 2020 10:46:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48196 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726591AbgGXOqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 10:46:49 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-Sv6EjPSkPGGxpkP40Mj3KA-1; Fri, 24 Jul 2020 10:46:44 -0400
X-MC-Unique: Sv6EjPSkPGGxpkP40Mj3KA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07C058E2B41;
        Fri, 24 Jul 2020 14:46:41 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6F88712C0;
        Fri, 24 Jul 2020 14:46:38 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Paul Wouters <paul@nohats.ca>,
        Andrew Cagney <andrew.cagney@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Tobias Brunner <tobias@strongswan.org>
Subject: [RFC PATCH ipsec] xfrm: don't pass too short packets to userspace with ESPINUDP encap
Date:   Fri, 24 Jul 2020 16:46:07 +0200
Message-Id: <18a669995a73fefd70e179e6bc11b74e397e56ad.1595594449.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, any UDP-encapsulated packet of 8 bytes or less will be
passed to userspace, whether it starts with the non-ESP prefix or
not (except keepalives). This includes:
 - messages of 1, 2, 3 bytes
 - messages of 4 to 8 bytes not starting with 00 00 00 00

This patch changes that behavior, so that only properly-formed non-ESP
messages are passed to userspace. Messages of 8 bytes or less that
don't contain a full non-ESP prefix followed by some data (at least
one byte) will be dropped and counted as XfrmInHdrError.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv4/xfrm4_input.c | 9 +++++++--
 net/ipv6/xfrm6_input.c | 9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index ad2afeef4f10..2a2bb38ac798 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -114,9 +114,14 @@ int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
 		} else if (len > sizeof(struct ip_esp_hdr) && udpdata32[0] != 0) {
 			/* ESP Packet without Non-ESP header */
 			len = sizeof(struct udphdr);
-		} else
-			/* Must be an IKE packet.. pass it through */
+		} else if (len > 4 && udpdata32[0] == 0) {
+			/* IKE packet: pass it through */
 			return 1;
+		} else {
+			/* incomplete packet, drop */
+			XFRM_INC_STATS(dev_net(skb->dev), LINUX_MIB_XFRMINHDRERROR);
+			goto drop;
+		}
 		break;
 	case UDP_ENCAP_ESPINUDP_NON_IKE:
 		/* Check if this is a keepalive packet.  If so, eat it. */
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index 04cbeefd8982..7e14d59d55cb 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -110,9 +110,14 @@ int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
 		} else if (len > sizeof(struct ip_esp_hdr) && udpdata32[0] != 0) {
 			/* ESP Packet without Non-ESP header */
 			len = sizeof(struct udphdr);
-		} else
-			/* Must be an IKE packet.. pass it through */
+		} else if (len > 4 && udpdata32[0] == 0) {
+			/* IKE packet: pass it through */
 			return 1;
+		} else {
+			/* incomplete packet, drop */
+			XFRM_INC_STATS(dev_net(skb->dev), LINUX_MIB_XFRMINHDRERROR);
+			goto drop;
+		}
 		break;
 	case UDP_ENCAP_ESPINUDP_NON_IKE:
 		/* Check if this is a keepalive packet.  If so, eat it. */
-- 
2.27.0

