Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D5C4F099A
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358635AbiDCNKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358503AbiDCNK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:27 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9813393FD
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:21 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n63-20020a1c2742000000b0038d0c31db6eso4097087wmn.1
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wUEmFx91uw/Q5RHRXDGBiQki94Rhwniq9a+OnZPUQPQ=;
        b=Gggwz4tvUuiIfZvwMcDNkdjT4yQAAg6EJ8S6lKLlqdgeI2csZI919zItNmie876Cfg
         wJ6MzltEhscJgWzsB7ZHxfKTqWssbelza3vzjsiPRZ+NzOk3FMObxjsO8QU2ukQry1d/
         6olXxOy8l3QDSmeDJKOpZh1IYdHIYXSfQCHNkNitmLOnyVuzRpFIElttoqbRZgzoAOie
         Dk26p93sYvp8tpL/ldm5VTDS0cq+/876Z7YI5QBnQvH7bF8QtoYjDxpyflfhk0pZfM3H
         6Wg6yfwC1tgn3FBrpHwtiwgq3iZBGfsZWAFfVDRj+tQJG5lxQzopqVvUuB2RqL45jyeN
         EnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wUEmFx91uw/Q5RHRXDGBiQki94Rhwniq9a+OnZPUQPQ=;
        b=s9nwlr9L1RRw7PIkJ5iiw3xJOjcnmvtgsXuUpTlQFeX5bdJyPRLmywlMONBhth5mua
         y+dXthIrz2Th3b+UEg/HUtzYaH+oOLfLVN3/0Bx4+W8gOGCjLHp8n5pD7lfAa3MCUKmq
         i8q6Hhjyo9g2dyUJMqc0lnvnINwKe2PxP/fkywJ0HVKCggdiYI+m7v4t3/tS1dut9JNE
         Qxp+xoSWd3Zrt/pFFS89gPCtcC/siqztAaCeCqche17Ul7d9sVvXrST8CLwRuJzqQemV
         Z5FXeSXhEf4u/F9LFGYbQFc+9FYZDNx5z0o4rqya0I/HCyej7UJhTgmmF8d81GQySF25
         Mdug==
X-Gm-Message-State: AOAM5323PffP/oMvC25sUuFEkP2j3p+AeDcjHkz+e2jP3JAKxMo249ih
        iyuOsUu2cRAsyxMg2vNLz3xgt2nxeos=
X-Google-Smtp-Source: ABdhPJwFX/6Bsvd9ZOQWMHQ3nm68Nv84FzwFFEZN0hDFPf9i4EB7qJYR9eeUKLA+ipacLRxr90CEYQ==
X-Received: by 2002:a05:600c:3511:b0:38c:d035:cddb with SMTP id h17-20020a05600c351100b0038cd035cddbmr15714893wmq.74.1648991300170;
        Sun, 03 Apr 2022 06:08:20 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 08/27] skbuff: optimise alloc_skb_with_frags()
Date:   Sun,  3 Apr 2022 14:06:20 +0100
Message-Id: <6011c226ac8c8d3c178675dfc53ca1c5d84c1095.1648981571.git.asml.silence@gmail.com>
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

Some users of alloc_skb_with_frags() including UDP pass zero datalen,
Extract and inline the pure skb alloc part of it. We also save on
needlessly pre-setting errcode ptr and with other small refactorings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 41 ++++++++++++++++++++++++++++++++++++-----
 net/core/skbuff.c      | 31 ++++++++++++-------------------
 2 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 410850832b6a..ebc4ad36c3a2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1300,11 +1300,42 @@ static inline struct sk_buff *alloc_skb(unsigned int size,
 	return __alloc_skb(size, priority, 0, NUMA_NO_NODE);
 }
 
-struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
-				     unsigned long data_len,
-				     int max_page_order,
-				     int *errcode,
-				     gfp_t gfp_mask);
+struct sk_buff *alloc_skb_frags(struct sk_buff *skb,
+				unsigned long data_len,
+				int max_page_order,
+				int *errcode,
+				gfp_t gfp_mask);
+
+/**
+ * alloc_skb_with_frags - allocate skb with page frags
+ *
+ * @header_len: size of linear part
+ * @data_len: needed length in frags
+ * @max_page_order: max page order desired.
+ * @errcode: pointer to error code if any
+ * @gfp_mask: allocation mask
+ *
+ * This can be used to allocate a paged skb, given a maximal order for frags.
+ */
+static inline struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
+						   unsigned long data_len,
+						   int max_page_order,
+						   int *errcode,
+						   gfp_t gfp_mask)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(header_len, gfp_mask);
+	if (unlikely(!skb)) {
+		*errcode = -ENOBUFS;
+		return NULL;
+	}
+
+	if (!data_len)
+		return skb;
+	return alloc_skb_frags(skb, data_len, max_page_order, errcode, gfp_mask);
+}
+
 struct sk_buff *alloc_skb_for_msg(struct sk_buff *first);
 
 /* Layout of fast clones : [skb1][skb2][fclone_ref] */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f7842bfdd7ae..2c787d964a60 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5955,40 +5955,32 @@ int skb_mpls_dec_ttl(struct sk_buff *skb)
 EXPORT_SYMBOL_GPL(skb_mpls_dec_ttl);
 
 /**
- * alloc_skb_with_frags - allocate skb with page frags
+ * alloc_skb_frags - allocate page frags for skb
  *
- * @header_len: size of linear part
+ * @skb: buffer
  * @data_len: needed length in frags
  * @max_page_order: max page order desired.
  * @errcode: pointer to error code if any
  * @gfp_mask: allocation mask
  *
- * This can be used to allocate a paged skb, given a maximal order for frags.
+ * This can be used to allocate pages for skb, given a maximal order for frags.
  */
-struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
-				     unsigned long data_len,
-				     int max_page_order,
-				     int *errcode,
-				     gfp_t gfp_mask)
+struct sk_buff *alloc_skb_frags(struct sk_buff *skb,
+				unsigned long data_len,
+				int max_page_order,
+				int *errcode,
+				gfp_t gfp_mask)
 {
 	int npages = (data_len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
 	unsigned long chunk;
-	struct sk_buff *skb;
 	struct page *page;
 	int i;
 
-	*errcode = -EMSGSIZE;
 	/* Note this test could be relaxed, if we succeed to allocate
 	 * high order pages...
 	 */
-	if (npages > MAX_SKB_FRAGS)
-		return NULL;
-
-	*errcode = -ENOBUFS;
-	skb = alloc_skb(header_len, gfp_mask);
-	if (!skb)
-		return NULL;
-
+	if (unlikely(npages > MAX_SKB_FRAGS))
+		goto failure;
 	skb->truesize += npages << PAGE_SHIFT;
 
 	for (i = 0; npages > 0; i++) {
@@ -6022,9 +6014,10 @@ struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
 
 failure:
 	kfree_skb(skb);
+	*errcode = -EMSGSIZE;
 	return NULL;
 }
-EXPORT_SYMBOL(alloc_skb_with_frags);
+EXPORT_SYMBOL(alloc_skb_frags);
 
 /* carve out the first off bytes from skb when off < headlen */
 static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
-- 
2.35.1

