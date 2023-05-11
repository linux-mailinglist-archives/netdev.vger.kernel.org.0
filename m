Return-Path: <netdev+bounces-1632-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3142C6FE951
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 522CE1C20EB6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC2B1392;
	Thu, 11 May 2023 01:20:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AAA637
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BBDC4339B;
	Thu, 11 May 2023 01:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683768042;
	bh=TKN/jmlPXWQMOwRaWCS3lygosFVFukm3Kc61v05gvLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9QOd23+18XUMJG1oaqgN3OvrWTjxqjjMnKWGX2sRHHO7yUpazYPXJTe45BiSDS8M
	 yyQo4rI3SIMC+3CJTdzHA6TSsaRDGddWc9ComzDnpZM39Xwutk3UKJKxQUdh/3wOI0
	 jrwzIbpG6LozQxx4SVpQdCVOG19+Dy9mm0Imf9YMMlOcXH2yQwZwX2MeET16kvlAAb
	 Yjn3Xz0pHX41tEX59xsQ1SLMTaFCYkGL+AQ/eB20jT2uuS6k/XCTvIjdLEGQgg5I90
	 J0Vsn06Y8OtoePHZ10aEQnn5uf+t6PxwXm2eS3CGfPraEcqAFeDuYiT6/q/gmmvU0o
	 8QNnG4cI1I7sw==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [RFC / RFT net 3/7] tls: rx: strp: force mixed decrypted records into copy mode
Date: Wed, 10 May 2023 18:20:30 -0700
Message-Id: <20230511012034.902782-4-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511012034.902782-1-kuba@kernel.org>
References: <20230511012034.902782-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a record is partially decrypted we'll have to CoW it, anyway,
so go into copy mode and allocate a writable skb right away.

This will make subsequent fix simpler because we won't have to
teach tls_strp_msg_make_copy() how to copy skbs while preserving
decrypt status.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h | 10 ++++++++++
 net/tls/tls_strp.c     | 16 +++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 738776ab8838..0b40417457cd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1587,6 +1587,16 @@ static inline void skb_copy_hash(struct sk_buff *to, const struct sk_buff *from)
 	to->l4_hash = from->l4_hash;
 };
 
+static inline int skb_cmp_decrypted(const struct sk_buff *skb1,
+				    const struct sk_buff *skb2)
+{
+#ifdef CONFIG_TLS_DEVICE
+	return skb2->decrypted - skb1->decrypted;
+#else
+	return 0;
+#endif
+}
+
 static inline void skb_copy_decrypted(struct sk_buff *to,
 				      const struct sk_buff *from)
 {
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 90b220d1145c..9a125c28da88 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -317,15 +317,19 @@ static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
 	return 0;
 }
 
-static bool tls_strp_check_no_dup(struct tls_strparser *strp)
+static bool tls_strp_check_queue_ok(struct tls_strparser *strp)
 {
 	unsigned int len = strp->stm.offset + strp->stm.full_len;
-	struct sk_buff *skb;
+	struct sk_buff *first, *skb;
 	u32 seq;
 
-	skb = skb_shinfo(strp->anchor)->frag_list;
-	seq = TCP_SKB_CB(skb)->seq;
+	first = skb_shinfo(strp->anchor)->frag_list;
+	skb = first;
+	seq = TCP_SKB_CB(first)->seq;
 
+	/* Make sure there's no duplicate data in the queue,
+	 * and the decrypted status matches.
+	 */
 	while (skb->len < len) {
 		seq += skb->len;
 		len -= skb->len;
@@ -333,6 +337,8 @@ static bool tls_strp_check_no_dup(struct tls_strparser *strp)
 
 		if (TCP_SKB_CB(skb)->seq != seq)
 			return false;
+		if (skb_cmp_decrypted(first, skb))
+			return false;
 	}
 
 	return true;
@@ -413,7 +419,7 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 			return tls_strp_read_copy(strp, true);
 	}
 
-	if (!tls_strp_check_no_dup(strp))
+	if (!tls_strp_check_queue_ok(strp))
 		return tls_strp_read_copy(strp, false);
 
 	strp->msg_ready = 1;
-- 
2.40.1


