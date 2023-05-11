Return-Path: <netdev+bounces-1630-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53EF16FE94B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:21:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F29A28164D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310E5EC1;
	Thu, 11 May 2023 01:20:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE3E647
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31562C4339E;
	Thu, 11 May 2023 01:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683768043;
	bh=s/l0Tk72Bi3i9Q9DCHgfaezHk21X349lPs/q1XIi3Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgIZMajWc5/Fal3qEw5o8SrlHZ7VCXfZHSsVQcteXByo0b8lyzsmtgGoZbKHQ2UHE
	 u4tFatqLeK2Sd27ENvZ78HRv2TozkxaRNqXo0ZP4u4sZJpnMWBTrHHNGXrbPeC9Uqk
	 1yVNl+gXqWPmmMu15MsASL5vUtcovwEaxxoFmRQ0cNWnHLE0sciSP6gVhBTkuk6RxS
	 bFaqXkKyiTehLbezCXDgpeyg79YvGjAmYEe4ddiwaW6uohXeXGOBOwYFMxc9fldBmZ
	 7CU7PhOG87uK0uHaXJ7nskWeovIPVW04EorDezZE3Z7Z27IwVwbHFactI64NCG2NL4
	 Ae7yYvzrawibQ==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [RFC / RFT net 5/7] tls: rx: strp: factor out copying skb data
Date: Wed, 10 May 2023 18:20:32 -0700
Message-Id: <20230511012034.902782-6-kuba@kernel.org>
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

We'll need to copy input skbs individually in the next patch.
Factor that code out (without assuming we're copying a full record).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 7b0c8145ace6..61fbf84baf9e 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -34,23 +34,22 @@ static void tls_strp_anchor_free(struct tls_strparser *strp)
 	strp->anchor = NULL;
 }
 
-/* Create a new skb with the contents of input copied to its page frags */
-static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
+static struct sk_buff *
+tls_strp_skb_copy(struct tls_strparser *strp, struct sk_buff *in_skb,
+		  int offset, int len)
 {
-	struct strp_msg *rxm;
 	struct sk_buff *skb;
-	int i, err, offset;
+	int i, err;
 
-	skb = alloc_skb_with_frags(0, strp->stm.full_len, TLS_PAGE_ORDER,
+	skb = alloc_skb_with_frags(0, len, TLS_PAGE_ORDER,
 				   &err, strp->sk->sk_allocation);
 	if (!skb)
 		return NULL;
 
-	offset = strp->stm.offset;
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		WARN_ON_ONCE(skb_copy_bits(strp->anchor, offset,
+		WARN_ON_ONCE(skb_copy_bits(in_skb, offset,
 					   skb_frag_address(frag),
 					   skb_frag_size(frag)));
 		offset += skb_frag_size(frag);
@@ -58,7 +57,21 @@ static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
 
 	skb->len = len;
 	skb->data_len = len;
-	skb_copy_header(skb, strp->anchor);
+	skb_copy_header(skb, in_skb);
+	return skb;
+}
+
+/* Create a new skb with the contents of input copied to its page frags */
+static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
+{
+	struct strp_msg *rxm;
+	struct sk_buff *skb;
+
+	skb = tls_strp_skb_copy(strp, strp->anchor, strp->stm.offset,
+				strp->stm.full_len);
+	if (!skb)
+		return NULL;
+
 	rxm = strp_msg(skb);
 	rxm->offset = 0;
 	return skb;
-- 
2.40.1


