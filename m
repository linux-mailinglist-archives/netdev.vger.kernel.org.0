Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FBA386BFA
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244752AbhEQVJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237515AbhEQVJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 17:09:52 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD13C061756
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id e24-20020a17090a4a18b029015cf3cf9e80so346805pjh.5
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1lUQLzPDwnKTUcsNfTf5V58axQYgpS34L5HvUx6TgFw=;
        b=K2372snREGN2FjhHb9Z54tSfwfrBNTCnSP9A8f2NV8+iCFfrIispQp0idTiL0ueEmC
         UNp311W5Mfo1yClTt7r2CXr6Db4aKugCm7MzhzGZ1OcEFDrwIUi+1vk+W0YLkoQZ1jow
         l3D9Pvaa+ihwKx1eQiw4syq2W1jsF9ALun0M5JojpJfJF+q2WXQnHeQwmYyVYxtzX6b5
         pzl8oypMzu1VccDplIacBQPkO38aBxaYPibsMZyUBPt1pdLFsB5sM9l82Z/e9ftigNgy
         9F+A+wyT32jA06d3YXJhoTZWnn+ljt8GqmsDfl69AtikIRT1p5rF8mu2Jkt52EUUBkJP
         aFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1lUQLzPDwnKTUcsNfTf5V58axQYgpS34L5HvUx6TgFw=;
        b=NtJ9Wv6I3d//akFxl4zhK0E6eTYo7Oo1jcuMXX5TO06xnKYHbPhmq6a6bTEPqp23/6
         asjIYQmsVT5AlluqZeQ7AgHvnQyHBWqeX0jlux4UKRWLFkFxZU02h6o6OjecE6MohNNe
         PzxgCkbkCp5/KCL6fQFz1D5xcPpeELJHsE8Xk6FTNMCDQnwBBSIViwfcgP0w5fwSVcNP
         /O/iRRBPKmrRA20PV1WRMTEWMAZpNGnCSUH5P1TmoRrH5Ce8H6SSlCDt9XKwtZ6s8+8r
         BHeSWNROTc/7HIfrmKLaPJcbBn/VPv9IqKDOJsttfXzXROPOHlPvAGbcAPN2LuqfeywJ
         EcGg==
X-Gm-Message-State: AOAM530EHTvQAn4YVSh49Hn2D/wHT4SfHaVC+8i2Y4weszJfJfx69SB+
        B49A08OxuaB8jL1s1C0B4LDHuvx1FbnsGwD/rDT0OqACVb9PskNTBl3xnEjCAVW1MaHYjZeLJzW
        Juh9KoJa1T5ENW6DL946Uby67SbZi3xGSMghhrJc3mDlWeG7gEfWV/PFQSg0LIDmNZ9kxOcVN
X-Google-Smtp-Source: ABdhPJzFi0Eui4zTrT3zOOo123ZzSk579ou6a/3e5Bc3ZzJteydRA243A7ppcldyX7DBt1ErSPipOpLT5rVL4euU
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:ba72:1464:177a:c6d4])
 (user=awogbemila job=sendgmr) by 2002:a17:90a:7306:: with SMTP id
 m6mr1066249pjk.217.1621285715569; Mon, 17 May 2021 14:08:35 -0700 (PDT)
Date:   Mon, 17 May 2021 14:08:13 -0700
In-Reply-To: <20210517210815.3751286-1-awogbemila@google.com>
Message-Id: <20210517210815.3751286-4-awogbemila@google.com>
Mime-Version: 1.0
References: <20210517210815.3751286-1-awogbemila@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH net 3/5] gve: Add NULL pointer checks when freeing irqs.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>,
        Willem de Brujin <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When freeing notification blocks, we index priv->msix_vectors.
If we failed to allocate priv->msix_vectors (see abort_with_msix_vectors)
this could lead to a NULL pointer dereference if the driver is unloaded.

Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: David Awogbemila <awogbemila@google.com>
Acked-by: Willem de Brujin <willemb@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 64192942ca53..21a5d058dab4 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -301,20 +301,22 @@ static void gve_free_notify_blocks(struct gve_priv *priv)
 {
 	int i;
 
-	/* Free the irqs */
-	for (i = 0; i < priv->num_ntfy_blks; i++) {
-		struct gve_notify_block *block = &priv->ntfy_blocks[i];
-		int msix_idx = i;
-
-		irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
-				      NULL);
-		free_irq(priv->msix_vectors[msix_idx].vector, block);
+	if (priv->msix_vectors) {
+		/* Free the irqs */
+		for (i = 0; i < priv->num_ntfy_blks; i++) {
+			struct gve_notify_block *block = &priv->ntfy_blocks[i];
+			int msix_idx = i;
+
+			irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
+					      NULL);
+			free_irq(priv->msix_vectors[msix_idx].vector, block);
+		}
+		free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
 	}
 	dma_free_coherent(&priv->pdev->dev,
 			  priv->num_ntfy_blks * sizeof(*priv->ntfy_blocks),
 			  priv->ntfy_blocks, priv->ntfy_block_bus);
 	priv->ntfy_blocks = NULL;
-	free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
 	pci_disable_msix(priv->pdev);
 	kvfree(priv->msix_vectors);
 	priv->msix_vectors = NULL;
-- 
2.31.1.751.gd2f1c929bd-goog

