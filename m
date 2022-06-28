Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2047655ED34
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbiF1TAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbiF1TAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:23 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE4B10FE7;
        Tue, 28 Jun 2022 12:00:02 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id fw3so37479ejc.10;
        Tue, 28 Jun 2022 12:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nt1evtlLqyE8dlHcYWIj2tMJ8whNRpAZNuITmbrrROw=;
        b=dXY006SLFZrYJ9IwScIIe2llnM0NV84sw7x6ypoVhNoS2ZJHIHeCreL61iuCxWQWi8
         vUBJ6Cc9hmulBY8M8cs4ADiZIpIghW/Ey8Cch1mFnGOAbZj73JMkmAHZdWj6C+Ws3h01
         HC+LgcQKVD/+Q9x9jwmE/yPPRlIZyjQQvbH7rAHdqN7+pxSONjfsX3ui2jV5WAbnFy9j
         pP0G+e13lLhLq0ZGD/4q3igVvqrzwC4zPJRsTRHVAyfDWUlDldoYLF0W0yZ36HEpLlDw
         gRtrddZ1A/BzD28yRljqN0Ey2BFQRvEADY0TnMsRQ2VFlUCqY9yzhPFzX2DIKZfwKd3o
         iIJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nt1evtlLqyE8dlHcYWIj2tMJ8whNRpAZNuITmbrrROw=;
        b=u81s213lS49LNGBpuRGUPYdjrJU+RAU3T6WNNpZz9EXDQ4eBwbvZCb1FOIygiHDOs0
         w+CitgLamGuCGjRjSlCuN5gj+/SmRF0K+VLAnTqOkC34c53bmJX8yoyVrDFVclwjOOF6
         xXqpKHllumLQSGSxBolqtWokxOv6S1/VPwEYsmfzAYmI1tLW50yNASmodatZTCCgtcxL
         hglWfhKn9eTQ+t1cVi1FKgZtKnVQYoYSrdFuYAzaUSbmYm5D/cKp/q5+43YBX3KxQZfS
         KeLn5JpuRwZWYLmCjfvAcTRz5ZfacL0U1k6PQIy2pu11b1xuMf7AKGMu/aVv9DOHGAqT
         HDZA==
X-Gm-Message-State: AJIora92BBvLy/qGTcGewkv0HQoDZpGXPFSUkO8lwyef/n+xl6Nxu+bU
        B5xvnLMnLnMvsYBGC4FLRzrRIIAgc+7y9g==
X-Google-Smtp-Source: AGRyM1t0iY1G882voOb2vPhB7UdFGBTcTIMEWUhoDGumeYntqH9sLAu7yTOSvdGrDge8ctQru7iVzw==
X-Received: by 2002:a17:907:6294:b0:6e1:ea4:74a3 with SMTP id nd20-20020a170907629400b006e10ea474a3mr19641396ejc.168.1656442800956;
        Tue, 28 Jun 2022 12:00:00 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.11.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 07/29] net: don't track pfmemalloc for managed frags
Date:   Tue, 28 Jun 2022 19:56:29 +0100
Message-Id: <5271342adcb77d39d148906bbbe215c1bbca3907.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Managed pages contain pinned userspace pages and controlled by upper
layers, there is no need in tracking skb->pfmemalloc for them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 28 +++++++++++++++++-----------
 net/core/datagram.c    |  7 +++++--
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5407cfd9cb89..6cca146be1f4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2549,6 +2549,22 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
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
@@ -2565,17 +2581,7 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
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
index a93c05156f56..3c913a6342ad 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -616,7 +616,8 @@ EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
 				   struct iov_iter *from, size_t length)
 {
-	int frag = skb_shinfo(skb)->nr_frags;
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	int frag = shinfo->nr_frags;
 	int ret = 0;
 	struct bvec_iter bi;
 	ssize_t copied = 0;
@@ -631,12 +632,14 @@ static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
 
 		copied += v.bv_len;
 		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
-		skb_fill_page_desc(skb, frag++, v.bv_page, v.bv_offset, v.bv_len);
+		__skb_fill_page_desc_noacc(shinfo, frag++, v.bv_page,
+					   v.bv_offset, v.bv_len);
 		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
 	}
 	if (bi.bi_size)
 		ret = -EMSGSIZE;
 
+	shinfo->nr_frags = frag;
 	from->bvec += bi.bi_idx;
 	from->nr_segs -= bi.bi_idx;
 	from->count = bi.bi_size;
-- 
2.36.1

