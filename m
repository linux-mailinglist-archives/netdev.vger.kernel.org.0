Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BCF5727E1
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbiGLUx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiGLUxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:44 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64243CEB94;
        Tue, 12 Jul 2022 13:53:19 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v67-20020a1cac46000000b003a1888b9d36so112606wme.0;
        Tue, 12 Jul 2022 13:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GKMfDsz3ncRIFfRnqejiNLX2DyehkKru80XLdiaCkUE=;
        b=RgCPTWd4uK4sLGJmlktxUWB5eHkAaMwBuqAi5yAP0tRVSE0e49D9eFXJ7lXjvhUz0V
         OfgVvRaimWYIIzVXCPXDFmxm+9Xq+vxgVOxYT0a5BHmlTCCDZe+sj7V2VEGhLey6xF/I
         EK1pfcsmt2XaxDymzzu2DjGUlle6MQNB7jy2tw9N7fkJRqrjkxgCKizy73xdRd+d7Bdi
         5gfb1huCMwnQ3Co3r2DQcQiKdNOQZn5adr+wSd/UEaFn/OLk4hvhHr/LOzmqk04hyIp7
         dn2EuoKgcb0aM5HzQr5YeGdNMNMgcXqIkbSzZ2lNdwa4VkGCbCn73vLtuT3seuk1uqfn
         e+ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GKMfDsz3ncRIFfRnqejiNLX2DyehkKru80XLdiaCkUE=;
        b=GPpoijbSPgFbSin9mtd921f0so2nSwVr0kjPD5IrkuI7LssAXav9GiZQwkyf+rrTOD
         WcFbNWc9Q3ejqqpuVGLAsZe2q+t3Asp0plehI3wPz8K1g6LKdtkmwOKaocSkSyYr5D/Q
         2YjJPaKLttObkptB25rtI0kn6yuEys76Sk7gcS0C/1h9Z15cuH0QVnc0NyiSgT22lDWA
         p4feXcDL7VhUr0A8FnIc44Aiy367a8T2FmctXJCnhKuG/0ua/sPJE7YS/vs3Pmc9l3JP
         DciSu4N0JmGes8QSXSJl0KddFsSDgWPVZHOqDEqPj1pCoWfSs7/3fnfh17V5c7rZK2rD
         niWg==
X-Gm-Message-State: AJIora+uYJDOTUzhdg1pFuKjEmHYLkz1UivRhdTmMMRsKJJCfrJJYTTO
        EzdvPFH73lr9WAyIXCVeYmGrChkfk5Y=
X-Google-Smtp-Source: AGRyM1sVlcAUo5UVbD3xERHem11AAK2I0GUI2uEzBIl6tcuBLMrFWIBt8sGwjutEfjhv1lH8oyBp5Q==
X-Received: by 2002:a05:600c:4e16:b0:3a2:ef34:dbe3 with SMTP id b22-20020a05600c4e1600b003a2ef34dbe3mr4824648wmq.71.1657659196932;
        Tue, 12 Jul 2022 13:53:16 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 08/27] net: introduce __skb_fill_page_desc_noacc
Date:   Tue, 12 Jul 2022 21:52:32 +0100
Message-Id: <99bdf93fa51edfbef709ad41f9985d855998fe38.1657643355.git.asml.silence@gmail.com>
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
2.37.0

