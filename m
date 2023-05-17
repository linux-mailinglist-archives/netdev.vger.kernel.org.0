Return-Path: <netdev+bounces-3149-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80418705CA4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64B0B1C20DAB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FF117D0;
	Wed, 17 May 2023 01:50:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE8517E0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543F4C433A1;
	Wed, 17 May 2023 01:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684288254;
	bh=cqyMGcZtEh+m9LNLdsccaQBZPyVp9t/mOxSk3m6fV9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbwstMt3Ymh2ADpdxr1H4vkaE2qxhrL5FkVbkWoUi0MZ8Rg+QBWN3RXAYXN+TGrHh
	 OUoHCju+OgzxyUT1vxMIi65FbN3m6OmczwWGa9DIXEGwMmzJSc1Vhza6Iu1g0Op33H
	 NFdIw7AnJTQQs3TfYw/WGtRr0dxZ7XKbSj76Lhb08ETvkGSwHkOmXqXz6u1UltDsPj
	 t90pKvlERbxaSSaQjdu1bbtXnMhfy6SAmEgi/xm/6zOvEVTA3LtPTk6KnNae0SwlON
	 ZAlVbzzZHtf5mGIQQLr2sMwhZEJVIAaOTG3W42Ya4CSAeNhE3RiDQK3N8RBQzVkJvK
	 z5Jg9UTEyyHfw==
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
Subject: [PATCH net 3/7] tls: rx: strp: force mixed decrypted records into copy mode
Date: Tue, 16 May 2023 18:50:38 -0700
Message-Id: <20230517015042.1243644-4-kuba@kernel.org>
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

If a record is partially decrypted we'll have to CoW it, anyway,
so go into copy mode and allocate a writable skb right away.

This will make subsequent fix simpler because we won't have to
teach tls_strp_msg_make_copy() how to copy skbs while preserving
decrypt status.

Tested-by: Shai Amiram <samiram@nvidia.com>
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
index 24016c865e00..2b6fa9855999 100644
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


