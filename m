Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2466DC68B
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjDJMIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjDJMH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:07:58 -0400
Received: from mail-ej1-x661.google.com (mail-ej1-x661.google.com [IPv6:2a00:1450:4864:20::661])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E9559C8
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:07:56 -0700 (PDT)
Received: by mail-ej1-x661.google.com with SMTP id sg7so23415250ejc.9
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681128475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOPjxEcfLVsIAdwWOo4TRGdlXCCfnhRjeta1axyXm4Q=;
        b=DThPq+9oUNJ8egsR9bfIy4/4kIhHduzWkXx9wA78bE7Xs8+sUuVR+b7laqS2pLqGfo
         Obgs8Cwi8Wlg2gGSiluZkkAdw31JOZ0v5e8TFZg8tHhmbugRldO8Orv9YHv/GRPA1/Yp
         Pv/MVnV3KTScwJQBIxpdBQG16zoRhcUNThd0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681128475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DOPjxEcfLVsIAdwWOo4TRGdlXCCfnhRjeta1axyXm4Q=;
        b=Jtq3/aPwyzpA1BgSr9HcqRg7JISqXjdftx/6kjiVF330t9hPagKJX5iKzEsDWLz93r
         jEPRB7XxlWQ8wXlqETEA6Uj153ZeK0B7NXxxeXt3gCYuan89oDYLxvvRagEjc/scAVRw
         Oxg0IEER2rc8HrDF2GyjdQOGYHTKo53BriiYgVOF+tXRYJ5uG4PMxO/R94/ndxki9T+z
         vIQflDJxtAxgUC5Q6MLQp+sAdSGiAa2g5mOu5YT0GE9BYnIAKx1W0Y2nS4s+oQhdNqtL
         3lb4zxdfMlWAWuZ0fGBLeVpeKAoNSfS4D9JDq0s/s4QEoZqzueXi02fLE4JNGbgrd7Ut
         3HRQ==
X-Gm-Message-State: AAQBX9fDuNzUqWSEQc/RGjKDkjC9n78zK6K1hMQY49Q3GBdJ1V+zXCyr
        3QGceLZTqKwEN/a/ZDgYZOdrSjnIqljOW25EPIL6Jb7VFm9Y
X-Google-Smtp-Source: AKy350YtSHWD1gr86TVtqITsxWTRI7Ge4dTzrbgBtz2vqBIq5KsAHsDIrtDnBCYnJPb/np+SALaeA5hFltkz
X-Received: by 2002:a17:906:e5b:b0:94a:845c:3528 with SMTP id q27-20020a1709060e5b00b0094a845c3528mr3056395eji.45.1681128474950;
        Mon, 10 Apr 2023 05:07:54 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id nb39-20020a1709071ca700b008b1fc5abd08sm2089769ejc.56.2023.04.10.05.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 05:07:54 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 1/4] xsk: Use pool->dma_pages to check for DMA
Date:   Mon, 10 Apr 2023 14:06:26 +0200
Message-Id: <20230410120629.642955-2-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230410120629.642955-1-kal.conley@dectris.com>
References: <20230410120629.642955-1-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read pool->dma_pages instead of pool->dma_pages_cnt to check for an
active DMA mapping. pool->dma_pages needs to be read anyway to access
the map so this compiles to more efficient code.

Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 include/net/xsk_buff_pool.h | 2 +-
 net/xdp/xsk_buff_pool.c     | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index d318c769b445..a8d7b8a3688a 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -180,7 +180,7 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 	if (likely(!cross_pg))
 		return false;
 
-	return pool->dma_pages_cnt &&
+	return pool->dma_pages &&
 	       !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
 }
 
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index b2df1e0f8153..26f6d304451e 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -350,7 +350,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 {
 	struct xsk_dma_map *dma_map;
 
-	if (pool->dma_pages_cnt == 0)
+	if (!pool->dma_pages)
 		return;
 
 	dma_map = xp_find_dma_map(pool);
@@ -364,6 +364,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 
 	__xp_dma_unmap(dma_map, attrs);
 	kvfree(pool->dma_pages);
+	pool->dma_pages = NULL;
 	pool->dma_pages_cnt = 0;
 	pool->dev = NULL;
 }
@@ -503,7 +504,7 @@ static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
 	if (pool->unaligned) {
 		xskb = pool->free_heads[--pool->free_heads_cnt];
 		xp_init_xskb_addr(xskb, pool, addr);
-		if (pool->dma_pages_cnt)
+		if (pool->dma_pages)
 			xp_init_xskb_dma(xskb, pool, pool->dma_pages, addr);
 	} else {
 		xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
@@ -569,7 +570,7 @@ static u32 xp_alloc_new_from_fq(struct xsk_buff_pool *pool, struct xdp_buff **xd
 		if (pool->unaligned) {
 			xskb = pool->free_heads[--pool->free_heads_cnt];
 			xp_init_xskb_addr(xskb, pool, addr);
-			if (pool->dma_pages_cnt)
+			if (pool->dma_pages)
 				xp_init_xskb_dma(xskb, pool, pool->dma_pages, addr);
 		} else {
 			xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
-- 
2.39.2

