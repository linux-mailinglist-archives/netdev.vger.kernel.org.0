Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9266F158B31
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 09:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgBKIUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 03:20:24 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44434 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727613AbgBKIUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 03:20:24 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from raeds@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Feb 2020 10:20:21 +0200
Received: from dev-l-vrt-074.mtl.labs.mlnx (dev-l-vrt-074.mtl.labs.mlnx [10.134.74.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01B8KL87013094;
        Tue, 11 Feb 2020 10:20:21 +0200
From:   Raed Salem <raeds@mellanox.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, Raed Salem <raeds@mellanox.com>
Subject: [PATCH net-next] ESP: Export esp_output_fill_trailer function
Date:   Tue, 11 Feb 2020 10:20:02 +0200
Message-Id: <1581409202-23654-1-git-send-email-raeds@mellanox.com>
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

Change-Id: Iebb4325fe12ef655a5cd6cb896cf9eed68033979
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
index 5c96776..2c7f391 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -209,22 +209,6 @@ static void esp_output_done_esn(struct crypto_async_request *base, int err)
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
 static int esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	int encap_type;
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
1.9.4

