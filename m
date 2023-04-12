Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83AA6DFB2F
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjDLQVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjDLQVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:21:39 -0400
Received: from mail-lj1-x262.google.com (mail-lj1-x262.google.com [IPv6:2a00:1450:4864:20::262])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8147298
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:21:29 -0700 (PDT)
Received: by mail-lj1-x262.google.com with SMTP id e20so12311479lji.6
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681316488; x=1683908488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8eN7Be/85uzfpyW2w/rr50iULiGv8D2Gnkfs37ktaYM=;
        b=iKVPaBauwu1vFSnDItMwiTT0PWIVGH1IhukyHZUJINyb3jTPxbwV72l4TQxgdRE80k
         S2TtdyAs214hWjxHl6wNQVN1CyXJ7TXWkUxKs95O83cQ9AkqzwdX/IBdydNTPlUmaTJE
         /V/GSVoE7Iou3+Czml55E8eBbbm+DzxTwairs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681316488; x=1683908488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8eN7Be/85uzfpyW2w/rr50iULiGv8D2Gnkfs37ktaYM=;
        b=DCoCTly+T53JDXTLPG/mGl1yA2gXyVuWUEWh6QV6PMILqPcAHhyB068u8d17K31jSB
         hq1Aze12GWiU5Ivwi+9EN14jm5vJY578QRaABWfZe8LVI1utDsWIFhfBj/nvFYgwDX5o
         VvuQJMMW/53uFJdCscKDsh0GGbj5ZM6XS7cMi3qAPT2eCidjF0ETBxYqwrUgV5t0Ho5u
         5jSu3IDi/hUqtIvf5f4wJXN0XZK/oC9eH8ZTEekAXabMm/he1PSIp8Y+9XweK695y6N+
         pAsTmDjhRFl0RkdGvtyb3+hBs0uj5wDwUboKtAZim6Wm8TEYy+nlP4BFWU3Q8yePpKCI
         +b8g==
X-Gm-Message-State: AAQBX9dlttvBHpdKNQLNbmuTbo1uYbqYszYfa2rvTi+ZP9vSgZXFBeYm
        gTOF6kobdjNR5pRKbAXiuKVnXATRGayWC3oKqxZWYmQ3KpSQ
X-Google-Smtp-Source: AKy350bXfD+qgr5S53CoNBQXvCEfUNx+ridAujSoVE5Bw02RPjB2fla8krpHFCTzrBYlgpeWoZlX4/GxhH47
X-Received: by 2002:a2e:3609:0:b0:29f:b199:5120 with SMTP id d9-20020a2e3609000000b0029fb1995120mr1842127lja.4.1681316487840;
        Wed, 12 Apr 2023 09:21:27 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id t19-20020a2e8e73000000b002a77614d960sm2108109ljk.62.2023.04.12.09.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 09:21:27 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 1/4] xsk: Use pool->dma_pages to check for DMA
Date:   Wed, 12 Apr 2023 18:21:11 +0200
Message-Id: <20230412162114.19389-2-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412162114.19389-1-kal.conley@dectris.com>
References: <20230412162114.19389-1-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compare pool->dma_pages instead of pool->dma_pages_cnt to check for an
active DMA mapping. pool->dma_pages needs to be read anyway to access
the map so this compiles to more efficient code.

Signed-off-by: Kal Conley <kal.conley@dectris.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
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

