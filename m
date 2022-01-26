Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BA249C040
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbiAZAi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbiAZAiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:38:50 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC07AC061744
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 16:38:49 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 127-20020a250f85000000b00611ab6484abso44883892ybp.23
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 16:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lD25OHtF262jufdVJ+BN8sFTmMZ8AYHm0XXc7puf0aQ=;
        b=G8C5fvun53ix5VK3trk3c5uPU9BrSM3DuOPL6+tsl3hVXJ5j2SVgjUfdgutkww0P3a
         yGVs6pkGj5qY3C27GMuZ+6R9E6cvG6G9tu6aTElWD3Y3Ld61zudftr14sKJHiu5ClsrO
         HGIbrsYajmD3Tx8FBKFEkXOzHSUFfO59Mz7sfm6XEhvyQr709wNiekMpbUpV3tHb0fa0
         6i1oqG2PhwMeARYncBNRM0pbiFmXxKSYEXlPI24abK7cSEgnSRMTJIwpC7NvI5P8vvX0
         TTctgrPpgJMfl51oFtVP/y05M16PQ0h2nnCJWB8P36Ubfjy9OjsVZXEhlJVcbRbvPy9+
         3A7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lD25OHtF262jufdVJ+BN8sFTmMZ8AYHm0XXc7puf0aQ=;
        b=3/gwCUvHwnAkFws2KOEq0t0WabfGX0q77pBPVDZgCunH3dZ1oGb+vCBQTikKgOVCdD
         hOGne3KrPi8O8mg2a9b3tdIiRIIB9e8CF2fDkelfzBS/sicVu09lVoGarqlOMRYUD78r
         zYulQh7HqYa+rSyX8XChvONcYSIY/MjKL2VNYp9sdUhzu62HlPMCMHM7GT40zMgmNH0v
         WEQIHcUF0JOjdtYt1CnRT57cqeBLxlbSEaOpJbBfjif7Gv5x2Iv07G27TmvjJVCB1DGN
         hrfS2YX0lholD7Q/nxRoGSYrIUXNFFWouBqh5Rsa76ZiTlkSehh3WfQ79xczCjqn8jgy
         xzfw==
X-Gm-Message-State: AOAM5332swvrPnstUmtxOFKL9TaXe+2JyRnarw/2OVZmTo5NVjyF7eKA
        d8WxWhbR7pU5BrciQ57Im7kME19P5zJxCkOSVjFk6DgNN/OANVLn8uMpuNE0HGlWq/VflS06o7W
        V6xUYcgztw2idUvjk9Gff4YU951qQq4yUjdLga2cdL5FTX38nuvGlnCdrl/xh6soxta75ISQT
X-Google-Smtp-Source: ABdhPJyEzEO1I7Ry3VrE7VE8s1jDjCXUiyiM8nLr85dbBXaqo855WlQ9Yn/SAu5GqtPrVbMy0be1T0WXtnRSpTot
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:89e3:235:ddae:72e0])
 (user=awogbemila job=sendgmr) by 2002:a25:b748:: with SMTP id
 e8mr31576171ybm.313.1643157529026; Tue, 25 Jan 2022 16:38:49 -0800 (PST)
Date:   Tue, 25 Jan 2022 16:38:43 -0800
Message-Id: <20220126003843.3584521-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH net] gve: Fix GFP flags when allocing pages
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     jeroendb@google.com, Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Use GFP_ATOMIC when allocating pages out of the hotpath,
continue to use GFP_KERNEL when allocating pages during setup.

GFP_KERNEL will allow blocking which allows it to succeed
more often in a low memory enviornment but in the hotpath we do
not want to allow the allocation to block.

Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        | 2 +-
 drivers/net/ethernet/google/gve/gve_main.c   | 6 +++---
 drivers/net/ethernet/google/gve/gve_rx.c     | 3 ++-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 5f5d4f7aa813..160735484465 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -843,7 +843,7 @@ static inline bool gve_is_gqi(struct gve_priv *priv)
 /* buffers */
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
-		   enum dma_data_direction);
+		   enum dma_data_direction, gfp_t gfp_flags);
 void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		   enum dma_data_direction);
 /* tx handling */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index f7f65c4bf993..54e51c8221b8 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -766,9 +766,9 @@ static void gve_free_rings(struct gve_priv *priv)
 
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
-		   enum dma_data_direction dir)
+		   enum dma_data_direction dir, gfp_t gfp_flags)
 {
-	*page = alloc_page(GFP_KERNEL);
+	*page = alloc_page(gfp_flags);
 	if (!*page) {
 		priv->page_alloc_fail++;
 		return -ENOMEM;
@@ -811,7 +811,7 @@ static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
 	for (i = 0; i < pages; i++) {
 		err = gve_alloc_page(priv, &priv->pdev->dev, &qpl->pages[i],
 				     &qpl->page_buses[i],
-				     gve_qpl_dma_dir(priv, id));
+				     gve_qpl_dma_dir(priv, id), GFP_KERNEL);
 		/* caller handles clean up */
 		if (err)
 			return -ENOMEM;
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 9ddcc497f48e..2068199445bd 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -86,7 +86,8 @@ static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
 	dma_addr_t dma;
 	int err;
 
-	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE);
+	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE,
+			     GFP_ATOMIC);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index beb8bb079023..8c939628e2d8 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -157,7 +157,7 @@ static int gve_alloc_page_dqo(struct gve_priv *priv,
 	int err;
 
 	err = gve_alloc_page(priv, &priv->pdev->dev, &buf_state->page_info.page,
-			     &buf_state->addr, DMA_FROM_DEVICE);
+			     &buf_state->addr, DMA_FROM_DEVICE, GFP_KERNEL);
 	if (err)
 		return err;
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

