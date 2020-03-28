Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC1BF1965C7
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 12:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgC1L3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 07:29:33 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33390 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgC1L3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 07:29:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B3E132026E;
        Sat, 28 Mar 2020 12:29:30 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ElJIu97PU8z1; Sat, 28 Mar 2020 12:29:30 +0100 (CET)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D789920533;
        Sat, 28 Mar 2020 12:29:29 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sat, 28 Mar
 2020 12:29:29 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5CBBF318026D; Sat, 28 Mar 2020 12:29:29 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/5] ESP: Export esp_output_fill_trailer function
Date:   Sat, 28 Mar 2020 12:29:21 +0100
Message-ID: <20200328112924.676-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328112924.676-1-steffen.klassert@secunet.com>
References: <20200328112924.676-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 cas-essen-01.secunet.de (10.53.40.201)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

The esp fill trailer method is identical for both
IPv6 and IPv4.

Share the implementation for esp6 and esp to avoid
code duplication in addition it could be also used
at various drivers code.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/esp.h | 16 ++++++++++++++++
 net/ipv4/esp4.c   | 16 ----------------
 net/ipv6/esp6.c   | 16 ----------------
 3 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/include/net/esp.h b/include/net/esp.h
index 117652eb6ea3..9c5637d41d95 100644
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
index 103c7d599a3c..8b07f3a4f2db 100644
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
index a3b403ba8f8f..11143d039f16 100644
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
2.17.1

