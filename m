Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88006B44D
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 04:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfGQCFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 22:05:35 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34288 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfGQCFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 22:05:34 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so11098343plt.1;
        Tue, 16 Jul 2019 19:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yyCnAAqk50QuA4BIBmrwpAsydgjX7XlHlK6JOx65DDw=;
        b=COaxmAt/1rYE2V0bO3fOwcy9AOu6ZItqgt7z0yJFcIToBFN7WR2IOKBaEsRG6f2oV/
         7jNihXSPC/Fgw3SAM+JpTFvKs8bUzW1JTgrMg8ahJpn79fg0NFLde9ksQvOYv03GOK//
         10h6wtCrDCWCTzVAhxYF3KdL2If6V9oWyNGLZclYY7CGLUMTXWn8GO4X/BCuA8p/49fM
         MTfmesbcmL+rT90NrxCsfXB1Y9qszpcKWR5lC/DIE8lFbyG/wtHvQR4w9LGq2Z+aCjAG
         cfxsXiWv9R9VmHxxeTAu4PFIG12pNt/eGwEhzTpiE2Wqx3kFeCGJXPlv/bg1j9/Wg+Zz
         QGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yyCnAAqk50QuA4BIBmrwpAsydgjX7XlHlK6JOx65DDw=;
        b=pGXtlOISGzvLhNDBC9wiJTXK3qL2ah3hVMuOVgyFE/0kNMnNWZjDb2+tEB2yMuE+2R
         x7rcCsy9M0HIjH1JwiFTs1Hoa9zc326FNYDDIKolaOsbtVp7XfULPTaX8DajbwOgPIhM
         2u2N1l9NTy8E8M7x2gb+w/2kt1hzr6Q2uoiMH5fAn4RMZ2qiUjhrD5D/2jNYgnqfNvj8
         ryNhWgQMiROdrT339ivp4CPmITNJ9o63oRTPBei91H2KKTXgZ0xeYgFM8qcoKdAoK3++
         eV6AZxR2hTUXS8lJviVJEasScZBd7GCjJsjQTBXq5vCeEW+AzPYggvxvedxxyXHcLkGz
         dVGA==
X-Gm-Message-State: APjAAAWZBSWiBmZ012X+2g+uo7Osr2R8tBfwgYWtY3W8LT8fbDApjxMR
        OdjcD/EdAeyKUf1OTbmqnLU=
X-Google-Smtp-Source: APXvYqziOjUBLqVm7Ljn+gX0qv1m7k7hAhtfNX3S6c2+q6+5FyjgHUQz2dLeQN/U+ijm7WsOVtPlsQ==
X-Received: by 2002:a17:902:f089:: with SMTP id go9mr39500527plb.81.1563329134078;
        Tue, 16 Jul 2019 19:05:34 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id g2sm29161025pfb.95.2019.07.16.19.05.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 19:05:33 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Catherine Sullivan <csully@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] gve: replace kfree with kvfree
Date:   Wed, 17 Jul 2019 10:05:11 +0800
Message-Id: <20190717020510.4548-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variables allocated by kvzalloc should not be freed by kfree.
Because they may be allocated by vmalloc.
So we replace kfree with kvfree here.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 22 +++++++++++-----------
 drivers/net/ethernet/google/gve/gve_rx.c   |  4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 24f16e3368cd..10b8e9720c32 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -232,7 +232,7 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 abort_with_msix_enabled:
 	pci_disable_msix(priv->pdev);
 abort_with_msix_vectors:
-	kfree(priv->msix_vectors);
+	kvfree(priv->msix_vectors);
 	priv->msix_vectors = NULL;
 	return err;
 }
@@ -256,7 +256,7 @@ static void gve_free_notify_blocks(struct gve_priv *priv)
 	priv->ntfy_blocks = NULL;
 	free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
 	pci_disable_msix(priv->pdev);
-	kfree(priv->msix_vectors);
+	kvfree(priv->msix_vectors);
 	priv->msix_vectors = NULL;
 }
 
@@ -445,12 +445,12 @@ static int gve_alloc_rings(struct gve_priv *priv)
 	return 0;
 
 free_rx:
-	kfree(priv->rx);
+	kvfree(priv->rx);
 	priv->rx = NULL;
 free_tx_queue:
 	gve_tx_free_rings(priv);
 free_tx:
-	kfree(priv->tx);
+	kvfree(priv->tx);
 	priv->tx = NULL;
 	return err;
 }
@@ -500,7 +500,7 @@ static void gve_free_rings(struct gve_priv *priv)
 			gve_remove_napi(priv, ntfy_idx);
 		}
 		gve_tx_free_rings(priv);
-		kfree(priv->tx);
+		kvfree(priv->tx);
 		priv->tx = NULL;
 	}
 	if (priv->rx) {
@@ -509,7 +509,7 @@ static void gve_free_rings(struct gve_priv *priv)
 			gve_remove_napi(priv, ntfy_idx);
 		}
 		gve_rx_free_rings(priv);
-		kfree(priv->rx);
+		kvfree(priv->rx);
 		priv->rx = NULL;
 	}
 }
@@ -592,9 +592,9 @@ static void gve_free_queue_page_list(struct gve_priv *priv,
 		gve_free_page(&priv->pdev->dev, qpl->pages[i],
 			      qpl->page_buses[i], gve_qpl_dma_dir(priv, id));
 
-	kfree(qpl->page_buses);
+	kvfree(qpl->page_buses);
 free_pages:
-	kfree(qpl->pages);
+	kvfree(qpl->pages);
 	priv->num_registered_pages -= qpl->num_entries;
 }
 
@@ -635,7 +635,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 free_qpls:
 	for (j = 0; j <= i; j++)
 		gve_free_queue_page_list(priv, j);
-	kfree(priv->qpls);
+	kvfree(priv->qpls);
 	return err;
 }
 
@@ -644,12 +644,12 @@ static void gve_free_qpls(struct gve_priv *priv)
 	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
 	int i;
 
-	kfree(priv->qpl_cfg.qpl_id_map);
+	kvfree(priv->qpl_cfg.qpl_id_map);
 
 	for (i = 0; i < num_qpls; i++)
 		gve_free_queue_page_list(priv, i);
 
-	kfree(priv->qpls);
+	kvfree(priv->qpls);
 }
 
 /* Use this to schedule a reset when the device is capable of continuing
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index c1aeabd1c594..1914b8350da7 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -35,7 +35,7 @@ static void gve_rx_free_ring(struct gve_priv *priv, int idx)
 
 	gve_unassign_qpl(priv, rx->data.qpl->id);
 	rx->data.qpl = NULL;
-	kfree(rx->data.page_info);
+	kvfree(rx->data.page_info);
 
 	slots = rx->data.mask + 1;
 	bytes = sizeof(*rx->data.data_ring) * slots;
@@ -168,7 +168,7 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 			  rx->q_resources, rx->q_resources_bus);
 	rx->q_resources = NULL;
 abort_filled:
-	kfree(rx->data.page_info);
+	kvfree(rx->data.page_info);
 abort_with_slots:
 	bytes = sizeof(*rx->data.data_ring) * slots;
 	dma_free_coherent(hdev, bytes, rx->data.data_ring, rx->data.data_bus);
-- 
2.20.1

