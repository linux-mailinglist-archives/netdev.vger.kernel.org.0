Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8AA47C2F1
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbhLUPgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239421AbhLUPf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:35:59 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF5AC061574;
        Tue, 21 Dec 2021 07:35:58 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id t26so27715373wrb.4;
        Tue, 21 Dec 2021 07:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fs4IKj4lluOFqbjUEotJFbASrWU7V0j1r6mW5rOPUoo=;
        b=GWu7nMAaTySQQD9M470qpyx7UgtutJgOOgAWLili50UWjwMDIBrP0ivnHgHshQBT9l
         7wnUclF5HzCwOVjKnRaKmHo21J1ccJ/UvtX688bHZ/dU5oncm1D6USE5QTIF/4P+zxJX
         pG+8CF+Ewlfh67imRkoENc8KXBGp4Jf0m4E4KpECmsvGrftKBuW9vZAbrZ5tfmxuPSz9
         K987Ez5ViihMw2S9eieb8El9A0+yyDWr3ZjSvdETysiBzoGQ2wOasepp03W7Z5vAbzGA
         hXV39g2Kpuy8TgrmzJtoA6HbZztvq/Clf4dQgYy8VcUsZwoPflGOrMg8XAlnoE/xPWEF
         F0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fs4IKj4lluOFqbjUEotJFbASrWU7V0j1r6mW5rOPUoo=;
        b=mnWhvXjbaRgyqnvqgyv35e8tCTxH5zyR5yBUaGQh+Gc8PaZjCK0O75voMC1JD4JXUE
         eap/cyQQ6RVZjMu9uH+b7/QgoWS41i8p2Nn5PXBlK+ZUV3lCq52MMOQJwNFwpvHYEzWE
         tPub0ZAI5DzufWI3jDlGdOPIKa7HvAixFPTdbkBiZxV/Bs3HHSaYuixHAplbhcAw/8LL
         ZHaanFewux8NbAkQfEPcaZHcVEu/I1sg2TuA1dvIxfxcZy76CI8IZbxX6BAZV1vGRyDZ
         eom9TkeLcny9VACT081g00h9DSl8i/Bx/K29lDbY+0VF9X+KJ769jRSyYPS6jJrI/sqi
         2nEg==
X-Gm-Message-State: AOAM530C2X30VfVMwrWJ+bOq1MUKvwgwytDpSCdt7SdvwDN9cZ3NDq3N
        DXM198fABq7h5X8HMdsBOJjJYAl50P0=
X-Google-Smtp-Source: ABdhPJyK3SX8Np6YQTRrCehwfr8yI5k+PhB1eh4XPCr1sDLMCK/3TXlOFvYoB1jqCfxEoHclwT+FPQ==
X-Received: by 2002:adf:f587:: with SMTP id f7mr3125766wro.671.1640100957177;
        Tue, 21 Dec 2021 07:35:57 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:35:56 -0800 (PST)
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
Subject: [RFC v2 05/19] net: don't track pfmemalloc for zc registered mem
Date:   Tue, 21 Dec 2021 15:35:27 +0000
Message-Id: <598860fe8307c120f07b4383b98cc51bde9cd531.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of zerocopy frags are filled with userspace allocated memory, we
shouldn't care about setting skb->pfmemalloc for them, and especially
when the buffers were somehow pre-registered (i.e. getting bvec from
io_uring). Remove the tracking from __zerocopy_sg_from_bvec().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 28 +++++++++++++++++-----------
 net/core/datagram.c    |  7 +++++--
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f6a6fd67e1ea..eef064fbf715 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2203,6 +2203,22 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
 	return skb_headlen(skb) + __skb_pagelen(skb);
 }
 
+static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
+					      int i, struct page *page,
+					      int off, int size)
+{
+	skb_frag_t *frag = &shinfo->frags[i];
+
+	/*
+	 * Propagate page pfmemalloc to the skb if we can. The problem is
+	 * that not all callers have unique ownership of the page but rely
+	 * on page_is_pfmemalloc doing the right thing(tm).
+	 */
+	frag->bv_page		  = page;
+	frag->bv_offset		  = off;
+	skb_frag_size_set(frag, size);
+}
+
 /**
  * __skb_fill_page_desc - initialise a paged fragment in an skb
  * @skb: buffer containing fragment to be initialised
@@ -2219,17 +2235,7 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
 static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 					struct page *page, int off, int size)
 {
-	skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-
-	/*
-	 * Propagate page pfmemalloc to the skb if we can. The problem is
-	 * that not all callers have unique ownership of the page but rely
-	 * on page_is_pfmemalloc doing the right thing(tm).
-	 */
-	frag->bv_page		  = page;
-	frag->bv_offset		  = off;
-	skb_frag_size_set(frag, size);
-
+	__skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size);
 	page = compound_head(page);
 	if (page_is_pfmemalloc(page))
 		skb->pfmemalloc	= true;
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 46526af40552..f8f147e14d1c 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -619,7 +619,8 @@ EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
 				   struct iov_iter *from, size_t length)
 {
-	int ret, frag = skb_shinfo(skb)->nr_frags;
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	int ret, frag = shinfo->nr_frags;
 	struct bvec_iter bi;
 	struct bio_vec v;
 	ssize_t copied = 0;
@@ -638,11 +639,13 @@ static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
 		v = mp_bvec_iter_bvec(from->bvec, bi);
 		copied += v.bv_len;
 		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
-		skb_fill_page_desc(skb, frag++, v.bv_page, v.bv_offset, v.bv_len);
+		__skb_fill_page_desc_noacc(shinfo, frag++, v.bv_page,
+					   v.bv_offset, v.bv_len);
 		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
 	}
 	ret = 0;
 out:
+	shinfo->nr_frags = frag;
 	skb->data_len += copied;
 	skb->len += copied;
 	skb->truesize += truesize;
-- 
2.34.1

