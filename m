Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD829423608
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 04:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbhJFCo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 22:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhJFCoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 22:44:20 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6324FC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 19:42:28 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p2-20020a170902bd0200b0013da15f4ab0so672568pls.7
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 19:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cj5zQAm/sTRoem/w0xkgTlleUfiHyH3CS2fRbDdBAX0=;
        b=GKAPtRn6oDMChc4QvFlATrelBKnDigFva4fzSFmgSOmuBoljp7yBGOW5+tDsV30WMT
         1/xTjIQ+pDaCg8TYuCaGMLDVhiS07UapXrt/jPgvDdOHkQgVnPEhqzavhPoHSlIwkzE2
         eJVMPal4fgepWRr3DQTAXK58GvdZ8pYKGwY9H4gRIgONHhyS3wVNLmXRVW5U3iNC/FzT
         ObGZF9/RbZVLvx7GGH+71NpsomFjcc43mPPQAcOe6kf1Ss3RLxG51TBqHVOKdODLxUyN
         XjPW40jNkuXfZ8giN1j2PK3Rau7MYD/7IXZyjAkPKXttQrBFFfXiHVHFkwUUMOGUoIHN
         Tt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cj5zQAm/sTRoem/w0xkgTlleUfiHyH3CS2fRbDdBAX0=;
        b=iiU5PVEuknyjZ+EbbR7w7yCaOXKmUC2fUR5p4f4odGL/MpZMcFq3/JP1wC8GBVmles
         0y95/2gmNfIJwd3dFzF8xA84UpgNpMfBieDKL4AF3z/lTYb8gIYBYAjiKbbnAMrNSByr
         mJnhT2zY9ZO3BEAQR+hiipJQobuvGFOaPeqCe+AN64a4D4z/7907zIl8QkiI2FJRSKqh
         goaabbdm2kwikbRCTjnmbZecPsFnXdqXH7GxSgdfW1CPt5zN+bOn2c9k9jfQwdk3hFvz
         WR2wm8Ho0vAgTlHhOkxqTSwOgHNrcEbZznm7nnfxZ9zQIkaEimc81y7oRwBDSHXuYVZd
         MJqw==
X-Gm-Message-State: AOAM531+BuwJ38+iNK9cQtSgI5ORSljwDVL8YUbuH4wpxQLyc0D3zOOS
        +oTVJdNxac4MaWGiGFGUwNw4lwdgMcfsCUTEL6FMkP0mHw/ipMShvubR+tAFobXPePB3bh88vVR
        fcYIG9PBRxs5fDwlPvj23niCiAfbgtSwiGdHlNna2cu24+Kgto/1TC3oBkgNSgFHmTfg=
X-Google-Smtp-Source: ABdhPJxOs2MoZd4gHAID+UzlmLPOfiQBnWJ/QuszsHZvMJoUzTgtI+KNFgpbuePhaRZKeumAgyZwuc0iCMHdKQ==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:6a19:24ee:a05:add5])
 (user=jeroendb job=sendgmr) by 2002:a05:6a00:1141:b0:440:3c27:807c with SMTP
 id b1-20020a056a00114100b004403c27807cmr33553423pfm.71.1633488147700; Tue, 05
 Oct 2021 19:42:27 -0700 (PDT)
Date:   Tue,  5 Oct 2021 19:42:20 -0700
In-Reply-To: <20211006024221.1301628-1-jeroendb@google.com>
Message-Id: <20211006024221.1301628-2-jeroendb@google.com>
Mime-Version: 1.0
References: <20211006024221.1301628-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net v2 2/3] gve: Avoid freeing NULL pointer
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

v2: Removed empty line between Fixes and the other tags.
