Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE8D47C2E9
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbhLUPf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239420AbhLUPf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:35:58 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E62DC061747;
        Tue, 21 Dec 2021 07:35:57 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id s1so27793280wrg.1;
        Tue, 21 Dec 2021 07:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EYHUVcpIu0swfI0JH2FwIPOXk5xlkPfb/IJYJ57JPRE=;
        b=qn4VnChreXPJGgvHM24IqFtDLmHI8pS47UnpUQsQ3rI0N87Kp5KjmWR45HfiBEP/WL
         abAkoxjT5MU76uFovkrMIfx6Y6wBIt2/SFB3HOMYMSmZmHaiZsyRVdb0cTqzgGXbtgyi
         5iHjzVPLLytWdDd+WBx7MRp6Jr0lQPhip9Hdr0GBa4joJV2eBQrPzjo6sidG2V+LdoST
         wYlNKbo2Z2lQSOjQXY2qZGtN9pF9Gdogi1rx2jFGDzChVw0fFxfMnNyzR2EazxUipRta
         0ChqXlLrLmSKkwpGjtysHIWsod0jZRVcTTPU/oZcbhdWkIVO9md54INQOZUmo6DplZDJ
         sjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EYHUVcpIu0swfI0JH2FwIPOXk5xlkPfb/IJYJ57JPRE=;
        b=JbXsDNJ9ehYMXNSyPqrSiEPiJAtdO41YhpV/JixA+zX/J6g6U0MErKoLm4sr9PNifJ
         BxjvhS67y6GYXBHmzioQlefxcabKd4FAGsBoHWgLBbZq82TVxzDh6p9yCaeZZYPOX9QL
         OVtRFmdAL4EP2a7SU5/0QTf1TkuqOaC5yjn9l5eRsXqxt/6fUD721y23anDdnnYBXt9f
         ntabgvDIzIUoX8aZmtDuI8xJ7izcGJbostsywqkI7ELkmXpNCwUFxYHHgYTkKdcLGiMm
         v9hmG2cJQUn+LWvj1bbgCzc2wTU1AC2tPwf6bNKvpM0vMee6lB8M5MU/7+fpIh3/GJLR
         Fd/Q==
X-Gm-Message-State: AOAM53345cxxJVhIYYRm0k9Q6AbuhOxxuUs3oMV/wsjmJGsXf8zeYcTg
        03W1YqUc+e5HHFjUfpFq4RhupWD5QyE=
X-Google-Smtp-Source: ABdhPJyqSJ2OkBCbas7NOVZowmBQrV9i/fXnYTk6C2yykkVbqmiI5QCmhzYb1PwIuF5pFJSCxJBpLw==
X-Received: by 2002:a5d:6289:: with SMTP id k9mr3025425wru.501.1640100956018;
        Tue, 21 Dec 2021 07:35:56 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:35:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 04/19] net: optimise page get/free for bvec zc
Date:   Tue, 21 Dec 2021 15:35:26 +0000
Message-Id: <6bea8a32471c7a4e849d64cf5b6122236b6a38dd.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
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
 include/linux/skbuff.h | 12 ++++++++++--
 net/core/datagram.c    |  9 +++++++--
 net/core/skbuff.c      | 14 +++++++++++++-
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b80944a9ce8f..f6a6fd67e1ea 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -461,11 +461,16 @@ enum {
 	SKBFL_PURE_ZEROCOPY = BIT(2),
 
 	SKBFL_DONT_ORPHAN = BIT(3),
+
+	/* page references are managed by the ubuf_info, so it's safe to
+	 * use frags only up until ubuf_info is released
+	 */
+	SKBFL_MANAGED_FRAGS = BIT(4),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
 #define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY | \
-				 SKBFL_DONT_ORPHAN)
+				 SKBFL_DONT_ORPHAN | SKBFL_MANAGED_FRAGS)
 
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
@@ -3155,7 +3160,10 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
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
index cb1e34fbcd44..46526af40552 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -638,7 +638,6 @@ static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
 		v = mp_bvec_iter_bvec(from->bvec, bi);
 		copied += v.bv_len;
 		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
-		get_page(v.bv_page);
 		skb_fill_page_desc(skb, frag++, v.bv_page, v.bv_offset, v.bv_len);
 		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
 	}
@@ -667,9 +666,15 @@ int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
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
index b23db60ea6f9..10cdcb99d34b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -666,11 +666,18 @@ static void skb_release_data(struct sk_buff *skb)
 			      &shinfo->dataref))
 		goto exit;
 
-	skb_zcopy_clear(skb, true);
+	if (skb_zcopy(skb)) {
+		bool skip_unref = shinfo->flags & SKBFL_MANAGED_FRAGS;
+
+		skb_zcopy_clear(skb, true);
+		if (skip_unref)
+			goto free_head;
+	}
 
 	for (i = 0; i < shinfo->nr_frags; i++)
 		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
 
+free_head:
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
 
@@ -1597,6 +1604,7 @@ struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t gfp_mask)
 	BUG_ON(skb_copy_bits(skb, -headerlen, n->head, headerlen + skb->len));
 
 	skb_copy_header(n, skb);
+	skb_shinfo(n)->flags &= ~SKBFL_MANAGED_FRAGS;
 	return n;
 }
 EXPORT_SYMBOL(skb_copy);
@@ -1653,6 +1661,7 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 			skb_frag_ref(skb, i);
 		}
 		skb_shinfo(n)->nr_frags = i;
+		skb_shinfo(n)->flags &= ~SKBFL_MANAGED_FRAGS;
 	}
 
 	if (skb_has_frag_list(skb)) {
@@ -1725,6 +1734,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 			refcount_inc(&skb_uarg(skb)->refcnt);
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
 			skb_frag_ref(skb, i);
+		skb_shinfo(skb)->flags &= ~SKBFL_MANAGED_FRAGS;
 
 		if (skb_has_frag_list(skb))
 			skb_clone_fraglist(skb);
@@ -3788,6 +3798,8 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	if (skb_can_coalesce(skb, i, page, offset)) {
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < MAX_SKB_FRAGS) {
+		if (skb_shinfo(skb)->flags & SKBFL_MANAGED_FRAGS)
+			return -EMSGSIZE;
 		get_page(page);
 		skb_fill_page_desc(skb, i, page, offset, size);
 	} else {
-- 
2.34.1

