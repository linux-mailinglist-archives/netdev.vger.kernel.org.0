Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C10856A15A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbiGGLwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235390AbiGGLwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:03 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E001253D2C;
        Thu,  7 Jul 2022 04:51:57 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id f2so20573581wrr.6;
        Thu, 07 Jul 2022 04:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=38y10vFv9/dzfeTS95yhvVY4RWynqtjJymBn4qotNoc=;
        b=cC51W+cZKEiMnrVGBLB0kFFWKPZFRmY+7e4J+MuRyiVShB3JHlXRoSwxggZXRqnybp
         +qoYnDfJRKQoSkpUUntaebh32yzd9VrAyA/DVuMd8dgcC034wD06zEiRvqvzRpdP00S3
         IZOisFgjCs8rks8JUSWyNqowv+WUbxGGynTeQUOMikvKrOYMVnOIJ9ayz6T2ccJyLJ68
         WiAes3MaXgFhXzuRwujmv6hhX/hFfHxjt+Xj72FQ2bjcGGflUhuCgTF1cRW+qkS1/MJX
         MrH3vfwi29sMGMWHPHzfzUs556ODGqva0C9sEHbQcG91CTeQDlYxlYdIRT1RG8RSj+YQ
         4oTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=38y10vFv9/dzfeTS95yhvVY4RWynqtjJymBn4qotNoc=;
        b=HL0uc80I8IGyUNWg0xmti3YlmuW/3gcEr+OBKD3emE2YHnRcaWnhtq3DbpDF1uhmZ7
         HDCgqmo/kopcYUtDC3DuXePL3aCFCO93xl/gQwfMqhC1P3K02pEUS7MlHXpwtPhQ8qMf
         NEK07JMbbnVIEPi4vT6HPrPYk7fsiGfiN/iOtdoti3cJYQMQfWWE3O7kvC9v/vVrqIVD
         uHbE1dyxsPZiavt1lAv7LbeH2vvidMUGS1HtdvQVUyxSDoGmYCOBZJqIAwufV2syatrI
         cIH4+zZcXQPIE92E1KRIyPUQAVIimVlWX9Qm/tAFryt63pF3RAGB4stN7sG9FdG9HI0t
         /MVw==
X-Gm-Message-State: AJIora8CAcS/VH+g8Xi51fIYxc30OfouyT66VOWHl4rvoZ2SomU132O9
        lokU4eOy0uG6o4PDiffITeZsJsxZaJKqAPl7ccU=
X-Google-Smtp-Source: AGRyM1vRn+ca2TImFjbeECRSRwiJaUDhfShVRS1O4cCXWgIrrdl/8rTXI9U4IesXPwgYCt9OpkyX7A==
X-Received: by 2002:adf:e786:0:b0:21d:6ec1:ee5c with SMTP id n6-20020adfe786000000b0021d6ec1ee5cmr15305282wrm.285.1657194716136;
        Thu, 07 Jul 2022 04:51:56 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 08/27] net: introduce __skb_fill_page_desc_noacc
Date:   Thu,  7 Jul 2022 12:49:39 +0100
Message-Id: <48fb9ca4f207a31b69ef47a92f6c0c28d390af33.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
References: <cover.1657194434.git.asml.silence@gmail.com>
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
layers, there is no need in tracking skb->pfmemalloc for them. Introduce
a helper for filling frags but ignoring page tracking, it'll be needed
later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 07004593d7ca..1111adefd906 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2550,6 +2550,22 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
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
@@ -2566,17 +2582,7 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
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
-- 
2.36.1

