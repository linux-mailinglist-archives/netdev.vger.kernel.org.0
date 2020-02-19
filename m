Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72301644A4
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 13:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgBSMuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 07:50:06 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43163 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbgBSMuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 07:50:06 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from raeds@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 Feb 2020 14:50:03 +0200
Received: from dev-l-vrt-074.mtl.labs.mlnx (dev-l-vrt-074.mtl.labs.mlnx [10.134.74.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01JCo3Cj023842;
        Wed, 19 Feb 2020 14:50:03 +0200
From:   Raed Salem <raeds@mellanox.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, Raed Salem <raeds@mellanox.com>
Subject: [PATCH net-next] ESP: Export esp_output_fill_trailer function
Date:   Wed, 19 Feb 2020 14:49:57 +0200
Message-Id: <1582116597-23065-1-git-send-email-raeds@mellanox.com>
X-Mailer: git-send-email 1.9.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The esp fill trailer method is identical for both
IPv6 and IPv4.

Share the implementation for esp6 and esp to avoid
code duplication in addition it could be also used
at various drivers code.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/net/esp.h | 16 ++++++++++++++++
 net/ipv4/esp4.c   | 16 ----------------
 net/ipv6/esp6.c   | 16 ----------------
 3 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/include/net/esp.h b/include/net/esp.h
index 117652e..9c5637d 100644
--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -11,6 +11,22 @@ static inline struct ip_esp_hdr *ip_esp_hdr(const struct sk_buff *skb)
 	return (struct ip_esp_hdr *)skb_transport_header(skb);
 }
 
+static inline void esp_output_fill_trailer(u8 *tail, int tfclen, int plen, __u8 proto)
+{
+	/* Fill padding... */
+	if (tfclen) {
+		memset(tail, 0, tfclen);
+		tail += tfclen;
+	}
+	do {
+		int i;
+		for (i = 0; i < plen - 2; i++)
+			tail[i] = i + 1;
+	} while (0);
+	tail[plen - 2] = plen - 2;
+	tail[plen - 1] = proto;
+}
+
 struct esp_info {
 	struct	ip_esp_hdr *esph;
 	__be64	seqno;
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 103c7d5..8b07f3a 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -341,22 +341,6 @@ static void esp_output_done_esn(struct crypto_async_request *base, int err)
 	esp_output_done(base, err);
 }
 
-static void esp_output_fill_trailer(u8 *tail, int tfclen, int plen, __u8 proto)
-{
-	/* Fill padding... */
-	if (tfclen) {
-		memset(tail, 0, tfclen);
-		tail += tfclen;
-	}
-	do {
-		int i;
-		for (i = 0; i < plen - 2; i++)
-			tail[i] = i + 1;
-	} while (0);
-	tail[plen - 2] = plen - 2;
-	tail[plen - 1] = proto;
-}
-
 static struct ip_esp_hdr *esp_output_udp_encap(struct sk_buff *skb,
 					       int encap_type,
 					       struct esp_info *esp,
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index a3b403b..11143d0 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -207,22 +207,6 @@ static void esp_output_done_esn(struct crypto_async_request *base, int err)
 	esp_output_done(base, err);
 }
 
-static void esp_output_fill_trailer(u8 *tail, int tfclen, int plen, __u8 proto)
-{
-	/* Fill padding... */
-	if (tfclen) {
-		memset(tail, 0, tfclen);
-		tail += tfclen;
-	}
-	do {
-		int i;
-		for (i = 0; i < plen - 2; i++)
-			tail[i] = i + 1;
-	} while (0);
-	tail[plen - 2] = plen - 2;
-	tail[plen - 1] = proto;
-}
-
 int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	u8 *tail;
-- 
1.8.3.1

