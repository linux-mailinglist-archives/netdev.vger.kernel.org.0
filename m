Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4755671FC
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiGEPCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiGEPB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:01:57 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F98D15A1A;
        Tue,  5 Jul 2022 08:01:56 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id r81-20020a1c4454000000b003a0297a61ddso9891184wma.2;
        Tue, 05 Jul 2022 08:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4t5Kscu3D6yj1DZiiNE3gVRmP9uRlouDzttfwtsAkPk=;
        b=LNPM6yQHjSKJHWhNedHDAbtXAlc5YgSwH6KNwhC2sg5oL401iUwpZM8lQE/Fpz9fuD
         AI122A0OO/qOeJBgYzq5A2P5xBDQgmJq9Sp1whhazWqEkdEwH0C0wTpkXV2lJzzjeKSm
         +vG672hdlLqP1JpTZ89CJK5OIbCNABURob3aSlDhz9f49g80Xc/CNcJuer93sxfw3TD5
         1Q1Hz4xpYufAQCr9E5v0B7okuC7x21CR6Rarut1GXBTfJIoZStzx8e/3e+LTmvMuZMkv
         mTyojYhLtigVuARAtuUJ07D/LIvLdiTkPWeRXbkwj+6kdU2E+QB7hJz3x9Ju+ly3+soz
         EO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4t5Kscu3D6yj1DZiiNE3gVRmP9uRlouDzttfwtsAkPk=;
        b=EKBqmKx0lZh1q4cJBAniQJsVEN0mb/eGYH1QKI+xTtDgptB0T6Zn7ZOWudrIXfoJWG
         weUI5ostThPzdXBa1HDK+ttKWTBq1z0sQPOP/YxwyF7pBhHhZyKawLTr3xiy6CBgB88W
         zVotFhB2NhagW5Au44/EGrv8ww0MIgrF2wn/davc/x5oar4W7h/ChBUnvQdyaFQZQSX0
         +RkikzNru5Ly8+zC2kL+FdKI8T4D16FxjshVNWDuJPyZN7wnpPaog8+CVsFBW7XC+fPv
         WdkufWxv+XNwC+BXilfTG9j3DhPaMB6cQlRI/pxNZUEP7AOT3je9LKf2IA+9RYh1rED4
         Raiw==
X-Gm-Message-State: AJIora/52YSuqgy4RL8GGcahRcQdNIEVAoRWgtVn7o09PZSbNFltJ2Xk
        l/kHAg5OAVRe3Y04PJaYxKm/fqf9zmsdlg==
X-Google-Smtp-Source: AGRyM1vPbCLDD79OYBhTdh3jBLGyfugpcOftgr5OEHSbzmbkKsnqhG5bUBXeH0jXviHsODsqsOc0Hg==
X-Received: by 2002:a05:600c:35cf:b0:3a0:49c1:f991 with SMTP id r15-20020a05600c35cf00b003a049c1f991mr37448421wmq.95.1657033314447;
        Tue, 05 Jul 2022 08:01:54 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 06/25] net: optimise bvec-based zc page referencing
Date:   Tue,  5 Jul 2022 16:01:06 +0100
Message-Id: <255398d582d4956871d0c35c929da158ef72b781.1656318994.git.asml.silence@gmail.com>
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

Some users like io_uring can pass a bvec iterator to send and also can
implement page pinning more efficiently. Add a ->msg_managed_data toogle
in msghdr. When set, data pages are "managed" by upper layers, i.e.
refcounted and pinned by the caller and will live at least until
->msg_ubuf is released. msghdr has to have non-NULL ->msg_ubuf and
->msg_iter should point to a bvec.

Protocols supporting the feature will propagate it by setting
SKBFL_MANAGED_FRAG_REFS, which means that the skb doesn't hold refs to
its frag pages and only rely on ubuf_info lifetime gurantees. It should
only be used with zerocopy skbs with ubuf_info set.

It's allowed to convert skbs from managed to normal by calling
skb_zcopy_downgrade_managed(). The function will take all needed
page references and clear the flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 25 +++++++++++++++++++++++--
 net/core/datagram.c    |  7 ++++---
 net/core/skbuff.c      | 29 +++++++++++++++++++++++++++--
 3 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8e12b3b9ad6c..712168c21736 100644
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
@@ -1809,6 +1814,11 @@ static inline bool skb_zcopy_pure(const struct sk_buff *skb)
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
@@ -1883,6 +1893,14 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy_success)
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
@@ -3498,7 +3516,10 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
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
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 5237cb533bb4..a93c05156f56 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -631,7 +631,6 @@ static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
 
 		copied += v.bv_len;
 		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
-		get_page(v.bv_page);
 		skb_fill_page_desc(skb, frag++, v.bv_page, v.bv_offset, v.bv_len);
 		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
 	}
@@ -660,11 +659,13 @@ static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
 int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 			    struct iov_iter *from, size_t length)
 {
-	int frag = skb_shinfo(skb)->nr_frags;
+	int frag;
 
-	if (iov_iter_is_bvec(from))
+	if (skb_zcopy_managed(skb))
 		return __zerocopy_sg_from_bvec(sk, skb, from, length);
 
+	frag = skb_shinfo(skb)->nr_frags;
+
 	while (length && iov_iter_count(from)) {
 		struct page *pages[MAX_SKB_FRAGS];
 		struct page *last_head = NULL;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5b35791064d1..71870def129c 100644
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
 
@@ -1371,6 +1381,16 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
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
@@ -1688,6 +1708,8 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 
 	BUG_ON(skb_shared(skb));
 
+	skb_zcopy_downgrade_managed(skb);
+
 	size = SKB_DATA_ALIGN(size);
 
 	if (skb_pfmemalloc(skb))
@@ -3484,6 +3506,8 @@ void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len)
 	int pos = skb_headlen(skb);
 	const int zc_flags = SKBFL_SHARED_FRAG | SKBFL_PURE_ZEROCOPY;
 
+	skb_zcopy_downgrade_managed(skb);
+
 	skb_shinfo(skb1)->flags |= skb_shinfo(skb)->flags & zc_flags;
 	skb_zerocopy_clone(skb1, skb, 0);
 	if (len < pos)	/* Split line is inside header. */
@@ -3837,6 +3861,7 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	if (skb_can_coalesce(skb, i, page, offset)) {
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < MAX_SKB_FRAGS) {
+		skb_zcopy_downgrade_managed(skb);
 		get_page(page);
 		skb_fill_page_desc(skb, i, page, offset, size);
 	} else {
-- 
2.36.1

