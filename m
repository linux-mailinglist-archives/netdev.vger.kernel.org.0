Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61FC5727DF
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbiGLUxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiGLUxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:42 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CDCCEBBD;
        Tue, 12 Jul 2022 13:53:17 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id r129-20020a1c4487000000b003a2d053adcbso82369wma.4;
        Tue, 12 Jul 2022 13:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YjVAy/XzqYSepr6pCaF7TexnaeT3/z2JRP6ZUmYU4No=;
        b=Y0UrfsORwJyIQSf0p6ap/9rJypqa+lWdMkdHizOo9KK634pPoRnhuBR/mDKXNT016U
         DLX6w4onOIS9F5xidKNElZQ+/xsw1JcXJwG/GZuR89XS/x5TxDpw2+vcB3GKHqXZFl/E
         4ZsNVvuBgsZDoU1xgjaWX2muDOrzOPZUYh+gIZSbXit7st1E75yWEnOMIOJpX0w7j2my
         linNL/BipzgF6ogKTuSF48NM9mCefG6QgfJ1H9mbQRbYW4KFi2Q7qwg7oNcvQcxqT9/t
         vi+FRgu2c4JoZYfY8qmBERIhVYgmDCOZXLTxZVPgS8p6RGpuseyEA8ZgP/11wlqvAcPb
         OGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YjVAy/XzqYSepr6pCaF7TexnaeT3/z2JRP6ZUmYU4No=;
        b=FSOQHmhlg6ip0CV+37zpxqJH8AHsQsX/nuxc4shkCBhL0hhJTii4Ggbj9lNFR1xliS
         lN3vXW1N7KYuODNHPvHGHt0lUf2OjTsrJPsaUMaSRQnDVsGfaFX3WDN427I5jTLBv10G
         1aCu+fQu6POj/AByx5mYMd3ZaJg/PEbRHsH2eZeNfZOpmVTJgeF7WAA+RiPTl4RnZMFN
         rEtiPnppg8rPw4NQCtaVWUZYbm6+aPLQ22tJYMe3U/qEphItRWikI1UtihBLDW6ZyUW5
         J/7d35TSEe5IAakVQrc5ax4DIHYxCq53L/E1wmfJVrZPmLkGaZojxYNYbN02A6m3iWJV
         IXOQ==
X-Gm-Message-State: AJIora+Xfukz4zV0eAoXOsuUwvRZbviH8v8Z7+WCDKKLTGl2LC+nFk5A
        nMTZE9r2iOr+YANt+zv9NTdcTQCit4E=
X-Google-Smtp-Source: AGRyM1vtfqtujdE4oHDsalKfLY3I3h7DqcDOQRZ+6iyuI6QAlAEibyZe67mYwPrKFC82bzEcoqrJSg==
X-Received: by 2002:a1c:f208:0:b0:3a2:dc06:f3fe with SMTP id s8-20020a1cf208000000b003a2dc06f3femr5921709wmc.119.1657659195698;
        Tue, 12 Jul 2022 13:53:15 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 07/27] net: introduce managed frags infrastructure
Date:   Tue, 12 Jul 2022 21:52:31 +0100
Message-Id: <83c1d2b77aa4fa2a2b1666e57fae931e7ca8e933.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
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

Some users like io_uring can do page pinning more efficiently, so we
want a way to delegate referencing to other subsystems. For that add
a new flag called SKBFL_MANAGED_FRAG_REFS. When set, skb doesn't hold
page references and upper layers are responsivle to managing page
lifetime.

It's allowed to convert skbs from managed to normal by calling
skb_zcopy_downgrade_managed(). The function will take all needed
page references and clear the flag. It's needed, for instance,
to avoid mixing managed modes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 25 +++++++++++++++++++++++--
 net/core/skbuff.c      | 29 +++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a8a2dd4cfdfd..07004593d7ca 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -688,11 +688,16 @@ enum {
 	SKBFL_PURE_ZEROCOPY = BIT(2),
 
 	SKBFL_DONT_ORPHAN = BIT(3),
+
+	/* page references are managed by the ubuf_info, so it's safe to
+	 * use frags only up until ubuf_info is released
+	 */
+	SKBFL_MANAGED_FRAG_REFS = BIT(4),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
 #define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY | \
-				 SKBFL_DONT_ORPHAN)
+				 SKBFL_DONT_ORPHAN | SKBFL_MANAGED_FRAG_REFS)
 
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
@@ -1810,6 +1815,11 @@ static inline bool skb_zcopy_pure(const struct sk_buff *skb)
 	return skb_shinfo(skb)->flags & SKBFL_PURE_ZEROCOPY;
 }
 
+static inline bool skb_zcopy_managed(const struct sk_buff *skb)
+{
+	return skb_shinfo(skb)->flags & SKBFL_MANAGED_FRAG_REFS;
+}
+
 static inline bool skb_pure_zcopy_same(const struct sk_buff *skb1,
 				       const struct sk_buff *skb2)
 {
@@ -1884,6 +1894,14 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy_success)
 	}
 }
 
+void __skb_zcopy_downgrade_managed(struct sk_buff *skb);
+
+static inline void skb_zcopy_downgrade_managed(struct sk_buff *skb)
+{
+	if (unlikely(skb_zcopy_managed(skb)))
+		__skb_zcopy_downgrade_managed(skb);
+}
+
 static inline void skb_mark_not_on_list(struct sk_buff *skb)
 {
 	skb->next = NULL;
@@ -3499,7 +3517,10 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
  */
 static inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
-	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	if (!skb_zcopy_managed(skb))
+		__skb_frag_unref(&shinfo->frags[f], skb->pp_recycle);
 }
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f5a3ebbc1f7e..cf4107d80bc4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -666,11 +666,18 @@ static void skb_release_data(struct sk_buff *skb)
 			      &shinfo->dataref))
 		goto exit;
 
-	skb_zcopy_clear(skb, true);
+	if (skb_zcopy(skb)) {
+		bool skip_unref = shinfo->flags & SKBFL_MANAGED_FRAG_REFS;
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
 
@@ -895,7 +902,10 @@ EXPORT_SYMBOL(skb_dump);
  */
 void skb_tx_error(struct sk_buff *skb)
 {
-	skb_zcopy_clear(skb, true);
+	if (skb) {
+		skb_zcopy_downgrade_managed(skb);
+		skb_zcopy_clear(skb, true);
+	}
 }
 EXPORT_SYMBOL(skb_tx_error);
 
@@ -1375,6 +1385,16 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy_iter_stream);
 
+void __skb_zcopy_downgrade_managed(struct sk_buff *skb)
+{
+	int i;
+
+	skb_shinfo(skb)->flags &= ~SKBFL_MANAGED_FRAG_REFS;
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
+		skb_frag_ref(skb, i);
+}
+EXPORT_SYMBOL_GPL(__skb_zcopy_downgrade_managed);
+
 static int skb_zerocopy_clone(struct sk_buff *nskb, struct sk_buff *orig,
 			      gfp_t gfp_mask)
 {
@@ -1692,6 +1712,8 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 
 	BUG_ON(skb_shared(skb));
 
+	skb_zcopy_downgrade_managed(skb);
+
 	size = SKB_DATA_ALIGN(size);
 
 	if (skb_pfmemalloc(skb))
@@ -3488,6 +3510,8 @@ void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len)
 	int pos = skb_headlen(skb);
 	const int zc_flags = SKBFL_SHARED_FRAG | SKBFL_PURE_ZEROCOPY;
 
+	skb_zcopy_downgrade_managed(skb);
+
 	skb_shinfo(skb1)->flags |= skb_shinfo(skb)->flags & zc_flags;
 	skb_zerocopy_clone(skb1, skb, 0);
 	if (len < pos)	/* Split line is inside header. */
@@ -3841,6 +3865,7 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	if (skb_can_coalesce(skb, i, page, offset)) {
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < MAX_SKB_FRAGS) {
+		skb_zcopy_downgrade_managed(skb);
 		get_page(page);
 		skb_fill_page_desc(skb, i, page, offset, size);
 	} else {
-- 
2.37.0

