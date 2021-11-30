Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBD84639DD
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbhK3PYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245058AbhK3PX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:27 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2904C061D62;
        Tue, 30 Nov 2021 07:19:25 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id q3so22359826wru.5;
        Tue, 30 Nov 2021 07:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OWPM4MjNj1xp6zI+XrQjzvvSmIGxLADJ0APTs0vw/kI=;
        b=CaPxPEyCe1kuXXrewNdN8vBO3EvThtstOp5TGI+D1wPozl5U5v1lLNrgxWIO4HDVJk
         ZbfWXNGMnU7w5/FdPooS7tvzLyQvemqC6/29nMG0Oqf00LBct2FMWOvubXLes8Z80s4p
         IMvcVylXTbYRpnLGR7sf37igl+PgUO8LjdhfL+b6H1hRWGRdum2lnhWXskwnnRE5hksH
         qIm01YV9LhuU79e2rW6Lnk5GCDZmHo7xCosxr0E3tiyP/td5vqBorwD8YEX4jt7Qg7Pd
         SzCUp7WgRTSQBw6ekQ6yUxTasPi7MQ8OB0Q6BKtojvOT/JhRJd2bvi0iZ85zi8BlJvyU
         9cPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OWPM4MjNj1xp6zI+XrQjzvvSmIGxLADJ0APTs0vw/kI=;
        b=x6SdiOkK6AJQKNkcniNtkOB/yomqXRpY/oLhb3bpqf9Euu/ZhG3JRAsEvauPrQoZUk
         0keocMorbPBDbjhJRmUtfDe3WRmV3nuw5fRNy0DM35JxAqTGDS3QNuRokGEuIOMaozix
         Ygvf9lwERVqktASvBzZFzFGg+6aBc7O9mzPwlLUJaEvf2tWpVnTWp2uYi1bIr7zDg2Y3
         MBqOya9CmpLwsyGGlj71tBfZ7FdLs80N8wEFUvR6e1iL0Ye+Gq1nLrlbLU7tkA9scHc/
         9Hm+OMxYbCm4VWfDKTrR3oBFoZiYUJa9cunWQT7f0Y/KQ9H2D7BI5Ju+akZbZEsQDZyc
         vu3Q==
X-Gm-Message-State: AOAM533KpXYcnEbYuzfTow6nD5GynNVD/zIbcYx1x8j9DMYX18srOAdQ
        P1mQzXigOBTCbrIgfSQoXWtPxd/CWU4=
X-Google-Smtp-Source: ABdhPJy+Tx1Ecnf83DrM4/PPgQ5HjYrcJGhemiadOImgqh0svuzJuhLdmncnX+MNa77ew358K1GU3w==
X-Received: by 2002:a05:6000:373:: with SMTP id f19mr40529601wrf.311.1638285564137;
        Tue, 30 Nov 2021 07:19:24 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC 05/12] net: optimise page get/free for bvec zc
Date:   Tue, 30 Nov 2021 15:18:53 +0000
Message-Id: <72608c13553a1372e7f6f7a32eb53d5d4b23a1fc.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_page() in __zerocopy_sg_from_bvec() and matching put_page()s are
expensive. However, we can avoid it if the caller can guarantee that
pages stay alive until the corresponding ubuf_info is not released.
In particular, it targets io_uring with fixed buffers following the
described contract.

Assuming that nobody yet uses bvec together with zerocopy, make all
calls with bvec iterators follow this model.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 10 +++++++++-
 net/core/datagram.c    |  9 +++++++--
 net/core/skbuff.c      | 16 +++++++++++++---
 net/ipv4/ip_output.c   |  4 ++++
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 750b7518d6e2..ebb12a7d386d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -461,6 +461,11 @@ enum {
 	SKBFL_PURE_ZEROCOPY = BIT(2),
 
 	SKBFL_DONT_ORPHAN = BIT(3),
+
+	/* page references are managed by the ubuf_info, so it's safe to
+	 * use frags only up until ubuf_info is released
+	 */
+	SKBFL_MANAGED_FRAGS = BIT(4),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
@@ -3154,7 +3159,10 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
  */
 static inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
-	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	if (!(shinfo->flags & SKBFL_MANAGED_FRAGS))
+		__skb_frag_unref(&shinfo->frags[f], skb->pp_recycle);
 }
 
 /**
diff --git a/net/core/datagram.c b/net/core/datagram.c
index e00f7e0a7a0a..5cf0672039d6 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -642,7 +642,6 @@ static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
 		v = mp_bvec_iter_bvec(from->bvec, bi);
 		copied += v.bv_len;
 		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
-		get_page(v.bv_page);
 		skb_fill_page_desc(skb, frag++, v.bv_page, v.bv_offset, v.bv_len);
 		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
 	}
@@ -671,9 +670,15 @@ int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 			    struct iov_iter *from, size_t length)
 {
 	int frag = skb_shinfo(skb)->nr_frags;
+	bool managed = skb_shinfo(skb)->flags & SKBFL_MANAGED_FRAGS;
 
-	if (iov_iter_is_bvec(from))
+	if (iov_iter_is_bvec(from) && (managed || frag == 0)) {
+		skb_shinfo(skb)->flags |= SKBFL_MANAGED_FRAGS;
 		return __zerocopy_sg_from_bvec(sk, skb, from, length);
+	}
+
+	if (managed)
+		return -EFAULT;
 
 	while (length && iov_iter_count(from)) {
 		struct page *pages[MAX_SKB_FRAGS];
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b23db60ea6f9..b7b087815539 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -666,10 +666,14 @@ static void skb_release_data(struct sk_buff *skb)
 			      &shinfo->dataref))
 		goto exit;
 
-	skb_zcopy_clear(skb, true);
+	if (!(shinfo->flags & SKBFL_MANAGED_FRAGS)) {
+		for (i = 0; i < shinfo->nr_frags; i++)
+			__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
+	} else {
+		shinfo->flags &= ~SKBFL_MANAGED_FRAGS;
+	}
 
-	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
+	skb_zcopy_clear(skb, true);
 
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
@@ -1471,6 +1475,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 	/* skb frags release userspace buffers */
 	for (i = 0; i < num_frags; i++)
 		skb_frag_unref(skb, i);
+	skb_shinfo(skb)->flags &= ~SKBFL_MANAGED_FRAGS;
 
 	/* skb frags point to kernel buffers */
 	for (i = 0; i < new_frags - 1; i++) {
@@ -1597,6 +1602,7 @@ struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t gfp_mask)
 	BUG_ON(skb_copy_bits(skb, -headerlen, n->head, headerlen + skb->len));
 
 	skb_copy_header(n, skb);
+	skb_shinfo(n)->flags &= ~SKBFL_MANAGED_FRAGS;
 	return n;
 }
 EXPORT_SYMBOL(skb_copy);
@@ -1653,6 +1659,7 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 			skb_frag_ref(skb, i);
 		}
 		skb_shinfo(n)->nr_frags = i;
+		skb_shinfo(n)->flags &= ~SKBFL_MANAGED_FRAGS;
 	}
 
 	if (skb_has_frag_list(skb)) {
@@ -1725,6 +1732,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 			refcount_inc(&skb_uarg(skb)->refcnt);
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
 			skb_frag_ref(skb, i);
+		skb_shinfo(skb)->flags &= ~SKBFL_MANAGED_FRAGS;
 
 		if (skb_has_frag_list(skb))
 			skb_clone_fraglist(skb);
@@ -3788,6 +3796,8 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	if (skb_can_coalesce(skb, i, page, offset)) {
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < MAX_SKB_FRAGS) {
+		if (skb_shinfo(skb)->flags & SKBFL_MANAGED_FRAGS)
+			return -EMSGSIZE;
 		get_page(page);
 		skb_fill_page_desc(skb, i, page, offset, size);
 	} else {
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index f9aab355d283..e6adf96e5530 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1194,6 +1194,10 @@ static int __ip_append_data(struct sock *sk,
 			err = -ENOMEM;
 			if (!sk_page_frag_refill(sk, pfrag))
 				goto error;
+			if (skb_shinfo(skb)->flags & SKBFL_MANAGED_FRAGS) {
+				err = -EMSGSIZE;
+				goto error;
+			}
 
 			if (!skb_can_coalesce(skb, i, pfrag->page,
 					      pfrag->offset)) {
-- 
2.34.0

