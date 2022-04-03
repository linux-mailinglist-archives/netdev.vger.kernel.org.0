Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E464F0999
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358768AbiDCNKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358477AbiDCNK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:27 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE01027154
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:20 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q19so3713807wrc.6
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KmKRZVdSh5FqmA1REwzHCTiq5E4GC2nAqX9kULvJvZU=;
        b=Cu8L3mnPMzui1x64BdWt4PsYpsr2zA9c6DkJosOJxgnmzUepCnTCZwPP0Q2mtQAkcr
         Cbin67FnEj60ccgXmDtetiPrVMMN+i4hDGOpTYVxJd/DD/XemhHM+3P2atwDob1EX5FI
         cOmgmJEhrNQxWLi5k/VfhNgP2vgOYYCdtym+oX5RsRUzHL7uXpPDhlEqjrENjEqg571I
         v0hNp16wypSOp84P5PVK73N6Ho20+VqFaXBx2dfIZJmj+ICGHqfavjlUAEv7MgviieSi
         3kchbfawhxqH+qRPhnc2CbtHQvZKADg+AfAhz6emBCBu6VbxD7Utp0CRMnFuZZC2JoIj
         QRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KmKRZVdSh5FqmA1REwzHCTiq5E4GC2nAqX9kULvJvZU=;
        b=4cIJNNWkW/E8N6usBH3KV4vZFvzZv4CWzledy49y0WfArD6QonCfBR4U3QWJzy01Mg
         wZJD+kcvVGF0UYEWDqRIKSc5gQ5ieeSP99DgDTTm9NMWX0V//Lz6QPNlGgg5Nkxr1NZh
         gJeMU7ssDfb5Rrh4ItM1RFhqXltsB4EF7DLzzO7a90PNJ5fgMuKtIAjgdjSC1HGbb5OD
         QEGpgou2EMBMr/IA5lSZx61GEsYE/qt+UbcCnXAVnp8IQIi218WnTRsYdDGSavgBqJ73
         zNvjlXScnFCe890F3WpXxpdUhSEDWqqphDhypsKSVKeqBgRvfk4/gCvyJM/iQP3alT/y
         VLYQ==
X-Gm-Message-State: AOAM531Xx3XatKcgwfM6BvDLHDt52QiG5/OkNlHAnTirfKby8+edoDQR
        kvnucN2xUZjXKH3LBVdIe1IOTrRkhDY=
X-Google-Smtp-Source: ABdhPJxfBtOGdTRtS5Q8J8UNaO4B68ZAkrwtnKarkic0oIXyxuj/Wsn49OfKuOppPgSrGeJNyoLwhQ==
X-Received: by 2002:a05:6000:186d:b0:204:110a:d832 with SMTP id d13-20020a056000186d00b00204110ad832mr13935618wri.47.1648991299105;
        Sun, 03 Apr 2022 06:08:19 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 07/27] skbuff: introduce skb_is_zcopy()
Date:   Sun,  3 Apr 2022 14:06:19 +0100
Message-Id: <3cf9407f8fa1b73845d0a23e2f7445b5633d626d.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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

Add a new helper function called skb_is_zcopy() for checking for an skb
zerocopy status. Before we were using skb_zcopy() for that, but it's
slightly heavier and generates extra code. Note: since the previous
patch we should have a ubuf set IFF an skb is SKBFL_ZEROCOPY_ENABLE
marked apart from nouarg cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 25 +++++++++++++++----------
 net/core/skbuff.c      | 15 +++++++--------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 10f94b1909da..410850832b6a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1647,11 +1647,14 @@ static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
 	return &skb_shinfo(skb)->hwtstamps;
 }
 
-static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
+static inline bool skb_is_zcopy(struct sk_buff *skb)
 {
-	bool is_zcopy = skb_shinfo(skb)->flags & SKBFL_ZEROCOPY_ENABLE;
+	return skb_shinfo(skb)->flags & SKBFL_ZEROCOPY_ENABLE;
+}
 
-	return is_zcopy ? skb_uarg(skb) : NULL;
+static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
+{
+	return skb_is_zcopy(skb) ? skb_uarg(skb) : NULL;
 }
 
 static inline bool skb_zcopy_pure(const struct sk_buff *skb)
@@ -1679,7 +1682,7 @@ static inline void skb_zcopy_init(struct sk_buff *skb, struct ubuf_info *uarg)
 static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 				 bool *have_ref)
 {
-	if (uarg && !skb_zcopy(skb)) {
+	if (uarg && !skb_is_zcopy(skb)) {
 		if (unlikely(have_ref && *have_ref))
 			*have_ref = false;
 		else
@@ -1723,11 +1726,13 @@ static inline void net_zcopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 /* Release a reference on a zerocopy structure */
 static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy_success)
 {
-	struct ubuf_info *uarg = skb_zcopy(skb);
 
-	if (uarg) {
-		if (!skb_zcopy_is_nouarg(skb))
+	if (skb_is_zcopy(skb)) {
+		if (!skb_zcopy_is_nouarg(skb)) {
+			struct ubuf_info *uarg = skb_zcopy(skb);
+
 			uarg->callback(skb, uarg, zerocopy_success);
+		}
 
 		skb_shinfo(skb)->flags &= ~SKBFL_ALL_ZEROCOPY;
 	}
@@ -3023,7 +3028,7 @@ static inline void skb_orphan(struct sk_buff *skb)
  */
 static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
 {
-	if (likely(!skb_zcopy(skb)))
+	if (likely(!skb_is_zcopy(skb)))
 		return 0;
 	if (!skb_zcopy_is_nouarg(skb) &&
 	    skb_uarg(skb)->callback == msg_zerocopy_callback)
@@ -3034,7 +3039,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
 /* Frags must be orphaned, even if refcounted, if skb might loop to rx path */
 static inline int skb_orphan_frags_rx(struct sk_buff *skb, gfp_t gfp_mask)
 {
-	if (likely(!skb_zcopy(skb)))
+	if (likely(!skb_is_zcopy(skb)))
 		return 0;
 	return skb_copy_ubufs(skb, gfp_mask);
 }
@@ -3591,7 +3596,7 @@ static inline int skb_add_data(struct sk_buff *skb,
 static inline bool skb_can_coalesce(struct sk_buff *skb, int i,
 				    const struct page *page, int off)
 {
-	if (skb_zcopy(skb))
+	if (skb_is_zcopy(skb))
 		return false;
 	if (i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7680314038b4..f7842bfdd7ae 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1350,14 +1350,13 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct msghdr *msg, int len,
 			     struct ubuf_info *uarg)
 {
-	struct ubuf_info *orig_uarg = skb_zcopy(skb);
 	struct iov_iter orig_iter = msg->msg_iter;
 	int err, orig_len = skb->len;
 
 	/* An skb can only point to one uarg. This edge case happens when
 	 * TCP appends to an skb, but zerocopy_realloc triggered a new alloc.
 	 */
-	if (orig_uarg && uarg != orig_uarg)
+	if (skb_is_zcopy(skb) && uarg != skb_zcopy(skb))
 		return -EEXIST;
 
 	err = __zerocopy_sg_from_iter(sk, skb, &msg->msg_iter, len);
@@ -1380,9 +1379,9 @@ EXPORT_SYMBOL_GPL(skb_zerocopy_iter_stream);
 static int skb_zerocopy_clone(struct sk_buff *nskb, struct sk_buff *orig,
 			      gfp_t gfp_mask)
 {
-	if (skb_zcopy(orig)) {
-		if (skb_zcopy(nskb)) {
-			/* !gfp_mask callers are verified to !skb_zcopy(nskb) */
+	if (skb_is_zcopy(orig)) {
+		if (skb_is_zcopy(nskb)) {
+			/* !gfp_mask callers are verified to !skb_is_zcopy(nskb) */
 			if (!gfp_mask) {
 				WARN_ON_ONCE(1);
 				return -ENOMEM;
@@ -1721,8 +1720,8 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	if (skb_cloned(skb)) {
 		if (skb_orphan_frags(skb, gfp_mask))
 			goto nofrags;
-		if (skb_zcopy(skb))
-			refcount_inc(&skb_uarg(skb)->refcnt);
+		if (skb_is_zcopy(skb))
+			net_zcopy_get(skb_uarg(skb));
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
 			skb_frag_ref(skb, i);
 
@@ -3535,7 +3534,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 	if (skb_headlen(skb))
 		return 0;
-	if (skb_zcopy(tgt) || skb_zcopy(skb))
+	if (skb_is_zcopy(tgt) || skb_is_zcopy(skb))
 		return 0;
 
 	todo = shiftlen;
-- 
2.35.1

