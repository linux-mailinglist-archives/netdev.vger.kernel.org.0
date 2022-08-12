Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C40059101A
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbiHLLda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237291AbiHLLd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:33:29 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFAFAED80;
        Fri, 12 Aug 2022 04:33:26 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id b21-20020a05600c4e1500b003a32bc8612fso402156wmq.3;
        Fri, 12 Aug 2022 04:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ZNPz8EsVwSSSThSIC0h9EQVjF2F3JLK+jajnfnPNzyY=;
        b=fnNYoaRrZjQ8pfrBz/z2dHhEePVoQ1Sd0Z0B6tM/a8ZTutO7Fslpx3Hom2qF857KFd
         46d6xwdVqlh2ywO5AzK/AXoI+uI5PqrypwoK2OmUWyjleO+hedRZju4DAljSFP01nhz8
         /Dge3NBaNJkbfbDAamppoXnYJrXfftJNJpXIYik9YR+74iCh9fD6BbmMtC5Tyg62zr5P
         G+v9uKIBveR0VRbWsZuFsCmzUCmOBdbRyLgbP767QbN2CY8w63PzVGhwC3Oyy+zMncRg
         Q3biaKpmwiGjdRZyVMvwj2tIEKmLl199HFPQX1yeDIaPxQxlDB+JOxmYsSXHDt1a/B1D
         E8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ZNPz8EsVwSSSThSIC0h9EQVjF2F3JLK+jajnfnPNzyY=;
        b=w19Qfec0wGKn4nIR9ZVtJmfg7Vo5oM471rEg6BrpqqyEYI85uFwV+k6Le/Mhbc5t1t
         egSJlsV4L+xXSEt524FnWGS8HD7Tw+/U4QUfRyeq0WyNUFvSOs/YIQAGAb47IM9KouoU
         OL4jvu0mK7Ql/UHvucWVnUMo4/b59SAzvkAM1drFFxpoWUouAzpRVIyebYqqAYvn10Sh
         X6O/KGyofv0YhAalzMR9Jt2a1/nbULqkZTwKa6GBuRrwSxqr+SECgrAYo0S1j1Jv/YUv
         L4AyXAvlh7u887SOzJHP2rb8trffLsvrHIvs3cWs67wVa0b5GzYq5jeXVR5NO+61j19X
         8CfA==
X-Gm-Message-State: ACgBeo1RzpB1QSPAgQqXrqTw3GbKkB/STqeHRPZTfLr/qMJhKxc3P4Tn
        aUsebCkYShobaGqCh+4gyvFTuR92L5r6AUKF
X-Google-Smtp-Source: AA6agR4GaZ5LW9rSGag7qWb6m2bwdliUnkxFYdbc41iZbMU8HE6bbpAweiUgTYp4tkHmfSXVwrvyGg==
X-Received: by 2002:a1c:2985:0:b0:3a5:15d6:f71e with SMTP id p127-20020a1c2985000000b003a515d6f71emr2407913wmp.119.1660304005438;
        Fri, 12 Aug 2022 04:33:25 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id a18-20020a05600c069200b003a32490c95dsm8743461wmn.35.2022.08.12.04.33.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Aug 2022 04:33:24 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        Alasdair McWilliam <alasdair.mcwilliam@outlook.com>,
        Intrusion Shield Team <dnevil@intrusion.com>
Subject: [PATCH bpf] xsk: fix corrupted packets for XDP_SHARED_UMEM
Date:   Fri, 12 Aug 2022 13:32:59 +0200
Message-Id: <20220812113259.531-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix an issue in XDP_SHARED_UMEM mode together with aligned mode were
packets are corrupted for the second and any further sockets bound to
the same umem. In other words, this does not affect the first socket
bound to the umem. The culprit for this bug is that the initialization
of the DMA addresses for the pre-populated xsk buffer pool entries was
not performed for any socket but the first one bound to the umem. Only
the linear array of DMA addresses was populated. Fix this by
populating the DMA addresses in the xsk buffer pool for every socket
bound to the same umem.

Fixes: 94033cd8e73b8 ("xsk: Optimize for aligned case")
Reported-by: Alasdair McWilliam <alasdair.mcwilliam@outlook.com>
Reported-by: Intrusion Shield Team <dnevil@intrusion.com>
Tested-by: Alasdair McWilliam <alasdair.mcwilliam@outlook.com>
Link: https://lore.kernel.org/xdp-newbies/6205E10C-292E-4995-9D10-409649354226@outlook.com/
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_buff_pool.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index f70112176b7c..a71a8c6edf55 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -379,6 +379,16 @@ static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
 
 static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map)
 {
+	if (!pool->unaligned) {
+		u32 i;
+
+		for (i = 0; i < pool->heads_cnt; i++) {
+			struct xdp_buff_xsk *xskb = &pool->heads[i];
+
+			xp_init_xskb_dma(xskb, pool, dma_map->dma_pages, xskb->orig_addr);
+		}
+	}
+
 	pool->dma_pages = kvcalloc(dma_map->dma_pages_cnt, sizeof(*pool->dma_pages), GFP_KERNEL);
 	if (!pool->dma_pages)
 		return -ENOMEM;
@@ -428,12 +438,6 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 
 	if (pool->unaligned)
 		xp_check_dma_contiguity(dma_map);
-	else
-		for (i = 0; i < pool->heads_cnt; i++) {
-			struct xdp_buff_xsk *xskb = &pool->heads[i];
-
-			xp_init_xskb_dma(xskb, pool, dma_map->dma_pages, xskb->orig_addr);
-		}
 
 	err = xp_init_dma_info(pool, dma_map);
 	if (err) {

base-commit: 4e4588f1c4d2e67c993208f0550ef3fae33abce4
-- 
2.34.1

