Return-Path: <netdev+bounces-3152-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AFD5705CA8
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65A4A1C20D8F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A471517F6;
	Wed, 17 May 2023 01:50:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1381023A3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61182C4339E;
	Wed, 17 May 2023 01:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684288255;
	bh=8+IICJDjnvvAdgvHZ6THtzmcTnD9T7OFbNs7gEsVo3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfRzuUbeGlM3VCdSm74t6gCO7aHhx8UxWJ8ccJB+mojuck4nClaDF8/0aKkpXhaB7
	 zmtq/a/9VbZY+UW53wuurgc/CoT6TkWtwFj0JkRtCZCQhI5A1r5sdtphNMckEByfDe
	 M3aXBubmeF97zC6xc+6Vubf1AOClv5AqUIysPYFkeim4+DUTPdZevrcBHVoSO4lXv8
	 LjhXKeZwVRVfzKe0JBkHr/rDhCsyy4qf4OoXDYOWaAWmjruaX2b23zxayybPE6sBIQ
	 IUyw9/M2COGzgTe/+WwPvCD6oGAsgVeIEjZc0ErVL8DOzyGRoxP67ur32+re4j8D+u
	 9ebmwF7Ic3nXg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	borisp@nvidia.com,
	john.fastabend@gmail.com,
	tariqt@nvidia.com,
	Jakub Kicinski <kuba@kernel.org>,
	Shai Amiram <samiram@nvidia.com>
Subject: [PATCH net 5/7] tls: rx: strp: factor out copying skb data
Date: Tue, 16 May 2023 18:50:40 -0700
Message-Id: <20230517015042.1243644-6-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517015042.1243644-1-kuba@kernel.org>
References: <20230517015042.1243644-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We'll need to copy input skbs individually in the next patch.
Factor that code out (without assuming we're copying a full record).

Tested-by: Shai Amiram <samiram@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index e2e48217e7ac..61fbf84baf9e 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -34,31 +34,44 @@ static void tls_strp_anchor_free(struct tls_strparser *strp)
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
 	}
 
-	skb->len = strp->stm.full_len;
-	skb->data_len = strp->stm.full_len;
-	skb_copy_header(skb, strp->anchor);
+	skb->len = len;
+	skb->data_len = len;
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


