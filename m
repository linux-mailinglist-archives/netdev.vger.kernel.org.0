Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927A25671F0
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiGEPCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiGEPB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:01:59 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C968C1582D;
        Tue,  5 Jul 2022 08:01:57 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n185so7199349wmn.4;
        Tue, 05 Jul 2022 08:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=444AasoIjcG70+nERpDu52ztpjjLs2LzhKg2x6YMB6U=;
        b=f3gYRqX5nVoGRNzWh42VpCUHEYoASYcoraNM09PKq6uUpWC9LdJswEjuKG53v22GKc
         0MD49/dzwvF+CAOQsekNj1dcL5MDACaemPMHzz6D5rgPdwnRFo2wjIQiM66uCzwvjcGh
         HfgLyfjcABeWpJxSxMD3bil1SaCjh3KOg+l5iXvTww88RivKqTMjCQpIovk6PUOYDf2x
         8PV5LdZrCobG59M7poitj8tsmRrwzkcSsA9/qPHLKe/XxB1tCB6shw5XIH1V34NEx0cT
         tZOhON6kHJKwEsCTwHU0hFzC4YzNfcT+MgGGbneke+PguecXnA0SSAhV0oJsxlyIhlBT
         2Y5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=444AasoIjcG70+nERpDu52ztpjjLs2LzhKg2x6YMB6U=;
        b=4b7/APf9reJsiclwiaTDg0KAvgHz4Rw8/veBtQF13yXlutpOINmTIHGDxaqEmwHlHU
         mwM329UL+zpJVLTOvrUOHikCo5jZGzMfw/QLpXyS7rdRf4QZNEcocskByMpymjfx5+GU
         y234opE0TpdiluYbbAYmExMMKSm89KnKWjt3fpZTZRxtdq+ZMqwE352CEcgYlZPnd1fW
         sbRX57ThgoSwfAQ6ODUwIvOA1kLdUyna8v73xLt7KOuPUgyCndmPSXd6aJ/M/MY2KRSS
         6flCtRLji36s6XZC5fm03om4wKp5lNPkeAR1NiZ10pvUvZuQ3Ing/xwBrVvsAhXIdUkL
         wGEg==
X-Gm-Message-State: AJIora+yO/H6xtd7zNoxptfBPzoYyQR7t3rDaTWcha/2MVSIJE7yiCKY
        z3aZKwb+vffQESWZJlB4cFcE9AOBPex9Qg==
X-Google-Smtp-Source: AGRyM1tl+xxus7ISOtrStGl5Jb6Id/jUsAT5Gel6Db0EkOREXG4KiRAHmpLu+nTNrx6XF+EnDRmDqw==
X-Received: by 2002:a05:600c:3ca2:b0:3a0:1825:2e6b with SMTP id bg34-20020a05600c3ca200b003a018252e6bmr38704300wmb.132.1657033315746;
        Tue, 05 Jul 2022 08:01:55 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 07/25] net: don't track pfmemalloc for managed frags
Date:   Tue,  5 Jul 2022 16:01:07 +0100
Message-Id: <2f699cf7f534df23ed1fe51f88bf832706f215f2.1656318994.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
References: <cover.1656318994.git.asml.silence@gmail.com>
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
index 712168c21736..2d5badd4b9ff 100644
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

