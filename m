Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973BAAFE66
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfIKONC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:13:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727946AbfIKONA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 10:13:00 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E43402CD7E5;
        Wed, 11 Sep 2019 14:12:59 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.205.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C527C5DD6C;
        Wed, 11 Sep 2019 14:12:58 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next v2 4/6] esp4: prepare esp_input_done2 for non-UDP encapsulation
Date:   Wed, 11 Sep 2019 16:13:05 +0200
Message-Id: <ae712bf388cf57336fe22677209b3c79d0fa6a74.1568192824.git.sd@queasysnail.net>
In-Reply-To: <cover.1568192824.git.sd@queasysnail.net>
References: <cover.1568192824.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 11 Sep 2019 14:13:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For espintcp encapsulation, we will need to get the source port from the
TCP header instead of UDP. Introduce a variable to hold the port.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.22.0

