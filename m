Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B71A48A4FE
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346296AbiAKBZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346289AbiAKBZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:25:00 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A339C034001;
        Mon, 10 Jan 2022 17:24:57 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id r28so1717747wrc.3;
        Mon, 10 Jan 2022 17:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/NURB/5FWWBfbG+TKgRZPMIkRC+TZfJeR4s5cDZLj40=;
        b=YKteNh9VRvpLU0D49Yyc9iBZ9ms1N1Q1lbFMkySHT/m3mdPP+zEIGjhgT1/c0KrN2F
         a52P3MzGmmgLfctYbxgpQQXpVwCqaH4v+623ioHT9TjadUbF3MqK2GaQ86SqhhT2QROb
         H7fzSeMS2QxC3MeTHRhje+DOwBREihpuAbpQnxQUsFG1j1IOsaj5mNVNSyMeartxRJ7E
         IfLvL78K+deP1zIO0Ab7QIN5oex/3K9HihCOtUHTVeFEAsSDj/mA4dGA52JCO70sIImW
         cDWRx8XY65H2ZeklpMb3qLi/XcZifly1Y4Dl6teFdUwuIuE9EqwZPAvrnihJi0cu2/u8
         6htA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/NURB/5FWWBfbG+TKgRZPMIkRC+TZfJeR4s5cDZLj40=;
        b=czMRn3goU4r8KXb3hgry+qX4ZGbUBz0VfveQtZ37bcd9Q5KgNGcnNeZqopwyX+t0G2
         Evp3q13E4igZJbcqr1CeJ6xtqbzqbcliqMW94GSLJURq3BsHQSGp+70+9HH4wpABStgk
         qdjfdPsPgHznVMuoBK36tRjqTbkp56jpAQObnPSFzParPOoASsn9SxI6vRYAM6kC1ybK
         /4alMJMQPZC+93OIQoXOXCY90o+XB5C5HxxFUQdg5aOLV9+eYD2bcmlgKcbCXmElPzy9
         NGOKvWo/N2XeGm5CwK6iwPH96nQxPGsBc9XdDKtRjbE4BZf4RwZMlBg8QzSc1G2h3FRq
         Spcw==
X-Gm-Message-State: AOAM530gqfsSHFsHxe/vDMBWvNFrzVq2Bj5B1vfPC1qrP9HL+Oxmy2Ct
        Wu7brn2tO3DWXLxPMXqtu0YGO4BHQNU=
X-Google-Smtp-Source: ABdhPJzDmxRIhnN5EpCoFwAfvYWiP+8E7sayOOP0REBpL4YMU9CebM6CG8+DKyiiUSQA04Nw2VA7rw==
X-Received: by 2002:a5d:5988:: with SMTP id n8mr1753420wri.309.1641864295565;
        Mon, 10 Jan 2022 17:24:55 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 12/14] skbuff: optimise alloc_skb_with_frags()
Date:   Tue, 11 Jan 2022 01:21:45 +0000
Message-Id: <d98094be1435d5d8a98e0f7af26f175b64259d86.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many users of alloc_skb_with_frags() pass zero datalen, e.g.
all callers sock_alloc_send_skb() including udp. Extract and inline a
part of it doing skb allocation. BTW, do a minor cleanup, e.g. don't
set errcode in advance as it can't be optimised.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 41 ++++++++++++++++++++++++++++++++++++-----
 net/core/skbuff.c      | 31 ++++++++++++-------------------
 2 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7fd2b44aada0..8ea145101b56 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1130,11 +1130,42 @@ static inline struct sk_buff *alloc_skb(unsigned int size,
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
index a9b8ac38dc1a..7811dde22f26 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5922,40 +5922,32 @@ int skb_mpls_dec_ttl(struct sk_buff *skb)
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
@@ -5989,9 +5981,10 @@ struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
 
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
2.34.1

