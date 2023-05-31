Return-Path: <netdev+bounces-6804-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC7D8718266
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 489701C20E91
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF7B14AA9;
	Wed, 31 May 2023 13:42:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2072614A95
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 13:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9CFC433EF;
	Wed, 31 May 2023 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685540555;
	bh=GtDbHWdKmdUUwhylbaW4bc50LtsQ1B8f++9Cuk8Vkqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKSu5EBqCazpKHZppRTRF3BVAOphs3J20OmQ4vR692VKVRnpBDLNcdoYavUoiRhtU
	 BjxRBFA+TLk4etop01t+RlXbp3jl/THYWAAwLfron7xysIKNmhqirbxf3mJKfPVtIy
	 egz35J/evRhng1o6BWzDKnItChSmuiqQrcTfDYL/kMDimje0KssmxXSshAC1kr15li
	 2feijqHzgF9XtHp0qWalUgEyN4jY1GuchyeYsu/PXhQX2VHoDp/RHSLOzx7uinfawj
	 eWhOSNrYtHd9MBppnwiPPl9LcnBplDaSKU5KJFxlvkxqQu39aHlwq9UcE3V2Y2smdu
	 Vt10l7/rZjyFA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Shai Amiram <samiram@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S . Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	borisp@nvidia.com,
	john.fastabend@gmail.com,
	edumazet@google.com,
	pabeni@redhat.com,
	asml.silence@gmail.com,
	richardbgobert@gmail.com,
	imagedong@tencent.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 19/33] tls: rx: strp: force mixed decrypted records into copy mode
Date: Wed, 31 May 2023 09:41:45 -0400
Message-Id: <20230531134159.3383703-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230531134159.3383703-1-sashal@kernel.org>
References: <20230531134159.3383703-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 14c4be92ebb3e36e392aa9dd8f314038a9f96f3c ]

If a record is partially decrypted we'll have to CoW it, anyway,
so go into copy mode and allocate a writable skb right away.

This will make subsequent fix simpler because we won't have to
teach tls_strp_msg_make_copy() how to copy skbs while preserving
decrypt status.

Tested-by: Shai Amiram <samiram@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 10 ++++++++++
 net/tls/tls_strp.c     | 16 +++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 20ca1613f2e3e..cc5ed2cf25f65 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1567,6 +1567,16 @@ static inline void skb_copy_hash(struct sk_buff *to, const struct sk_buff *from)
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
index 955ac3e0bf4d3..445543d92ac5c 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -315,15 +315,19 @@ static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
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
@@ -331,6 +335,8 @@ static bool tls_strp_check_no_dup(struct tls_strparser *strp)
 
 		if (TCP_SKB_CB(skb)->seq != seq)
 			return false;
+		if (skb_cmp_decrypted(first, skb))
+			return false;
 	}
 
 	return true;
@@ -411,7 +417,7 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 			return tls_strp_read_copy(strp, true);
 	}
 
-	if (!tls_strp_check_no_dup(strp))
+	if (!tls_strp_check_queue_ok(strp))
 		return tls_strp_read_copy(strp, false);
 
 	strp->msg_ready = 1;
-- 
2.39.2


