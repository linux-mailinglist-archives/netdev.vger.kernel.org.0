Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9108649BF8F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiAYXbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234817AbiAYXbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:31:13 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01B5C06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 15:31:13 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 19-20020a17090a001300b001b480b09680so13236456pja.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 15:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HpjWin1DH8UBNh1LETr1Xp2GlBQmPbNLxZODD4SqDmI=;
        b=G87XdBSzh5ZrwAEWXj663AGXCwWdcT+pOPmo8tRQBvmcQ+yOf3Hi4PrA6x70IphPcm
         1392ORG3M38D3yjgSOhVQ5rrMxmzUQU1OmDNcRgBDP/ojkmfehRJAkE2HHItDNLVXDPx
         KiWgbh7QHggrshPnid+FrRYtsCTS+cGvhzQOZZvOANPcP4756vP0LgE8xy2w3Ckpvr6g
         PXJTetR1/MlRHUdQkcCnKElJgAmuMRMePlc+CcXzaSAGxVkTb97qQm521z0ju49eTH0d
         +C1QzDn79nmmjiS3R3NkQ/xMb6/yiucgiwNW4m1ebc0ILYKzpo9hrGZPbSi77ksx5LMY
         cxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HpjWin1DH8UBNh1LETr1Xp2GlBQmPbNLxZODD4SqDmI=;
        b=tOfJXVqNPxMTBi9dg/KkzxSd8wSsysjW3bPIjPP3dkJDsRFGzUU2yrvTlWFD55E6xU
         gCl8R8XR3I3a1sDiH7CBcP1lSm7Q//iI4P7UVKFqkL+iSSJz5S4NNW9Fpc9sD8mvPzv3
         IY/mm0f2SHMLOJUHFj4vq8Jcm+TCyRUlZKMHblQcTxSvGyC5dQPtTlVjzvsfgROwUpQ0
         JlvF1kMIEbPT8qdTb/pLgn7O82WqaMs2I/+rbil1PrcEPp9kB6+Ok8qZDg26VQt9vfcy
         875uh+/9re5lZWSmwCR2wfbsxOvpYcsZIqLvZHgiKjcWJvgLx2jYRsDRwQpK9F54IXtj
         UcXA==
X-Gm-Message-State: AOAM532xtKFbVzPX5ZAP7iMa6pIMSWbfQHqLpkiAIBxJ8QFJo8SKLVue
        c2UqoICDcm0KCQx6609fD7BfIKAOohlqWmOO4rCKJ2OvSCPQVkoeUOVzz3MTJfBhWW0X+ZHToZj
        bjXBn9fuZIUNikGPMxJUqwPtufoD4z5uIINxUzGmzfwgXhoox1spY0Grj57KwbTOEs/Mv0snL
X-Google-Smtp-Source: ABdhPJz8rbgxJSkXZnfw48eIoK8DoVODsfeYBt3DDSQ2B9O69lYuqVWIZl5PfyjHv9o5dCt7Zzzl1IuAiNPrWSHP
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:89e3:235:ddae:72e0])
 (user=awogbemila job=sendgmr) by 2002:a17:90a:bc84:: with SMTP id
 x4mr5912841pjr.230.1643153473052; Tue, 25 Jan 2022 15:31:13 -0800 (PST)
Date:   Tue, 25 Jan 2022 13:59:10 -0800
In-Reply-To: <20220125215910.3551874-1-awogbemila@google.com>
Message-Id: <20220125215910.3551874-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20220125215910.3551874-1-awogbemila@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH net-next] gve: Fix GFP flags when allocing pages
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

