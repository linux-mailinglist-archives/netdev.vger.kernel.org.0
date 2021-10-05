Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D32423478
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 01:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbhJEXar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 19:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbhJEXar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 19:30:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99A2C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 16:28:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w11-20020a25ef4b000000b005b7151afcc4so815697ybm.22
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 16:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZkJlkYBRyN2l8fx9s8krQrLz+vZ/IsW0tc4DuRPVqEk=;
        b=MwNLSxHOLtWfxWPCCcrah6F7hmMAT4gkKQg6NFFfTkuSjQcTvgXMWNXmkcUT9tr/MA
         QhnHj2T8bd+txzEkDmk7D8cWIfzAUreJKoAJhKQnhvyEeNbMvUukf/U2k2THlZSO/01D
         wLtQNQgIfMzhR8Nl3xMR8lmIBlgNpPaAEXhufkxkFe96gQc0WGOPdNIi5j2kOJ2L84PD
         xUM8khXB5pgPtR48A9/pnjadcrMdGYi5HpLkwgNUazQZK/5d+bT7KOjuBOwwdrMiUR5u
         mzTA8zHnyIySHNlCjhF7ofT9jVhU0eaPviu5hGnBvfxg2EGYZ3eeUuuHtbpALNCIl54A
         YNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZkJlkYBRyN2l8fx9s8krQrLz+vZ/IsW0tc4DuRPVqEk=;
        b=ZABxsqrSs06QhaeOmhNZDs226xL+gN4tjjfbsUbArU6wxkKesB1WJGO3UV5I+Xe4eV
         ztB8f/65Hmr0McD1LioIK2lC0nY4IFfeuZs4KVZ3cTGEsW4uI05Rw7W1XDgbpYh6E7+z
         GztG0oShOa4296nD+5Rp4C6o5hnl7BgpNmWvbxW2SgBHDAx3IiTduFb0RC7CnlxpyAbz
         xyufJcDyxiGPmND7kiPD5/rXaveQXtr/QceMYGCCUpba81ov1EFgR6iYiPkz33v/69+z
         MYdlQ06lrI1yW2HujYGWRm8/DgBWNN45Q3voSNOgIIDJUj84vAmmxU1LY8tUeePdz/5E
         KgiA==
X-Gm-Message-State: AOAM531SR89AiqI8X16KslszCxD/egQg3CSAXGnmm7fzAZIfJ5OhisQj
        Y6mRkxfU3hEWY1cw0D9X+F5H4wwUSQbXAAWJR6SpnS305gR5O67LVTFtD1jVHxo1LQekjX2k6Ve
        wrNpNMSLRZgH6DesGat+9GEpmWSHLXiwMC696sXQT31Fc8IRmZc67u43YRYkL6gKA32U=
X-Google-Smtp-Source: ABdhPJxLn4zL4Nbb2akplrntsjUITvO2Lk0lWdHZZtdfs7INoDAGZZ/0EPHvfDGe8uJRTApuqXzxfBmCVgzbMg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:6a19:24ee:a05:add5])
 (user=jeroendb job=sendgmr) by 2002:a25:5205:: with SMTP id
 g5mr24051514ybb.292.1633476535184; Tue, 05 Oct 2021 16:28:55 -0700 (PDT)
Date:   Tue,  5 Oct 2021 16:28:22 -0700
In-Reply-To: <20211005232823.1285684-1-jeroendb@google.com>
Message-Id: <20211005232823.1285684-2-jeroendb@google.com>
Mime-Version: 1.0
References: <20211005232823.1285684-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net 2/3] gve: Avoid freeing NULL pointer
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Tao Liu <xliutaox@google.com>,
        Catherine Sully <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Liu <xliutaox@google.com>

Prevent possible crashes when cleaning up after unsuccessful
initializations.

Fixes: 893ce44df5658 ("gve: Add basic driver framework for Compute Engine Virtual NIC")

Signed-off-by: Tao Liu <xliutaox@google.com>
Signed-off-by: Catherine Sully <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 27 ++++++++++++++--------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 099a2bc5ae67..29c5f994f92e 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -82,6 +82,9 @@ static int gve_alloc_counter_array(struct gve_priv *priv)
 
 static void gve_free_counter_array(struct gve_priv *priv)
 {
+	if (!priv->counter_array)
+		return;
+
 	dma_free_coherent(&priv->pdev->dev,
 			  priv->num_event_counters *
 			  sizeof(*priv->counter_array),
@@ -142,6 +145,9 @@ static int gve_alloc_stats_report(struct gve_priv *priv)
 
 static void gve_free_stats_report(struct gve_priv *priv)
 {
+	if (!priv->stats_report)
+		return;
+
 	del_timer_sync(&priv->stats_report_timer);
 	dma_free_coherent(&priv->pdev->dev, priv->stats_report_len,
 			  priv->stats_report, priv->stats_report_bus);
@@ -370,18 +376,19 @@ static void gve_free_notify_blocks(struct gve_priv *priv)
 {
 	int i;
 
-	if (priv->msix_vectors) {
-		/* Free the irqs */
-		for (i = 0; i < priv->num_ntfy_blks; i++) {
-			struct gve_notify_block *block = &priv->ntfy_blocks[i];
-			int msix_idx = i;
+	if (!priv->msix_vectors)
+		return;
 
-			irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
-					      NULL);
-			free_irq(priv->msix_vectors[msix_idx].vector, block);
-		}
-		free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
+	/* Free the irqs */
+	for (i = 0; i < priv->num_ntfy_blks; i++) {
+		struct gve_notify_block *block = &priv->ntfy_blocks[i];
+		int msix_idx = i;
+
+		irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
+				      NULL);
+		free_irq(priv->msix_vectors[msix_idx].vector, block);
 	}
+	free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
 	dma_free_coherent(&priv->pdev->dev,
 			  priv->num_ntfy_blks * sizeof(*priv->ntfy_blocks),
 			  priv->ntfy_blocks, priv->ntfy_block_bus);
-- 
2.33.0.800.g4c38ced690-goog

