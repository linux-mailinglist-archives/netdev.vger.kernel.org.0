Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3173C1437C2
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 08:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgAUHjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 02:39:07 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36752 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728709AbgAUHjH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 02:39:07 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 45E4E20533;
        Tue, 21 Jan 2020 08:39:05 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4b4TvroxI08N; Tue, 21 Jan 2020 08:39:04 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8B92520536;
        Tue, 21 Jan 2020 08:39:03 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 08:39:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4BD9A31802EA;
 Tue, 21 Jan 2020 08:39:03 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/6] esp4: prepare esp_input_done2 for non-UDP encapsulation
Date:   Tue, 21 Jan 2020 08:38:56 +0100
Message-ID: <20200121073858.31120-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121073858.31120-1-steffen.klassert@secunet.com>
References: <20200121073858.31120-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

For espintcp encapsulation, we will need to get the source port from the
TCP header instead of UDP. Introduce a variable to hold the port.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.17.1

