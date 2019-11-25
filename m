Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937E3108F35
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 14:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfKYNt6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Nov 2019 08:49:58 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32006 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727842AbfKYNt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 08:49:58 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-cKTqXZxGMZOd577UPDSFfA-1; Mon, 25 Nov 2019 08:49:49 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D45DF9A6A2;
        Mon, 25 Nov 2019 13:49:47 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-31.ams2.redhat.com [10.36.116.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77F28600C6;
        Mon, 25 Nov 2019 13:49:46 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH ipsec-next v7 4/6] esp4: prepare esp_input_done2 for non-UDP encapsulation
Date:   Mon, 25 Nov 2019 14:49:00 +0100
Message-Id: <d5487f6b72778252558fdef7ba83e151a4d14bd2.1574685542.git.sd@queasysnail.net>
In-Reply-To: <cover.1574685542.git.sd@queasysnail.net>
References: <cover.1574685542.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: cKTqXZxGMZOd577UPDSFfA-1
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

