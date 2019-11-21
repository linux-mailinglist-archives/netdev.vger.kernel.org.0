Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A09105054
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKUKSr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Nov 2019 05:18:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48846 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726197AbfKUKSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:18:46 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-mR6hwgN0NriBnyxl6_9_Vw-1; Thu, 21 Nov 2019 05:18:42 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7EC3801E5B;
        Thu, 21 Nov 2019 10:18:41 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-31.ams2.redhat.com [10.36.116.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F3FC6FDCE;
        Thu, 21 Nov 2019 10:18:40 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH ipsec-next v6 4/6] esp4: prepare esp_input_done2 for non-UDP encapsulation
Date:   Thu, 21 Nov 2019 11:18:26 +0100
Message-Id: <d5487f6b72778252558fdef7ba83e151a4d14bd2.1574329035.git.sd@queasysnail.net>
In-Reply-To: <cover.1574329035.git.sd@queasysnail.net>
References: <cover.1574329035.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: mR6hwgN0NriBnyxl6_9_Vw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For espintcp encapsulation, we will need to get the source port from the
TCP header instead of UDP. Introduce a variable to hold the port.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/esp4.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 5c967764041f..c5d826642229 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -601,6 +601,18 @@ int esp_input_done2(struct sk_buff *skb, int err)
 	if (x->encap) {
 		struct xfrm_encap_tmpl *encap = x->encap;
 		struct udphdr *uh = (void *)(skb_network_header(skb) + ihl);
+		__be16 source;
+
+		switch (x->encap->encap_type) {
+		case UDP_ENCAP_ESPINUDP:
+		case UDP_ENCAP_ESPINUDP_NON_IKE:
+			source = uh->source;
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			err = -EINVAL;
+			goto out;
+		}
 
 		/*
 		 * 1) if the NAT-T peer's IP or port changed then
@@ -609,11 +621,11 @@ int esp_input_done2(struct sk_buff *skb, int err)
 		 *    SRC ports.
 		 */
 		if (iph->saddr != x->props.saddr.a4 ||
-		    uh->source != encap->encap_sport) {
+		    source != encap->encap_sport) {
 			xfrm_address_t ipaddr;
 
 			ipaddr.a4 = iph->saddr;
-			km_new_mapping(x, &ipaddr, uh->source);
+			km_new_mapping(x, &ipaddr, source);
 
 			/* XXX: perhaps add an extra
 			 * policy check here, to see
-- 
2.23.0

