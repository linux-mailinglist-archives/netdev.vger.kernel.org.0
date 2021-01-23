Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813193014BC
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 11:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbhAWKvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 05:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbhAWKre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 05:47:34 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3BBC061786;
        Sat, 23 Jan 2021 02:46:52 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 15so5592140pgx.7;
        Sat, 23 Jan 2021 02:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0woXL6TwKFZY+vCAgGomrBVuZafUkKOhiqwosyN4SZ4=;
        b=cxC08BrGmoZ8aFnlXu0TBeV2ZS6Ir/h35fWhhU54Cgm8BZC4yVf/E+upEB8IgQBIpp
         VooLSLEE5MKpTRMjUgzkMFHxniwbMgKcZKeEJ9uDIs466YhqY9dX/fVZdIOEJI/QvWdx
         lRiWVraO36tDjd0k6T+EYA5ZUHOvYes4Ov0k9jNJlFM2ABuExCGKcqyG8tjWkeXuTmgO
         C0iN53oA3CH4BKqoy0IHZEAeUSJkMVqwOF3hpXMN5l06/uSs9juItRgU6dgUYULfkVSX
         RfiUZbDpAOsjzhviYcSloP4scjjjCDmTp3xaaUwkAno7U38qQ/aX/IHu2hD0RIJmwe4a
         BNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0woXL6TwKFZY+vCAgGomrBVuZafUkKOhiqwosyN4SZ4=;
        b=cd2yUPuDxNRUFCQj5k53LCu0ISqbHRf4ae8bzdWys12G586aIB0wokeeeRA6k1SqUm
         sYWqoaC66khIKOPdvQyDVxigyyBhcNc0mZdWi5noAgs+pWCPIKUo//Oy7xS7KO4IjFJ0
         owIrYBAVceDw6akNu3IFPB9l9KYc+xw6TMjE/gZNBIcgmkOR6fh/EtUohGqAQQOt1WC+
         hqy335P8ijxbhZiXCKIq+QbTurN5DWvdAXbebXr8FyDuYADxgLYcn6MwQIsOk6i1PP2j
         N6iB0LZEvrwVRPMvTBSj1V01rzTu5NVHi+xYMLjvzNjsri3MkdAdUwLSmln3FcDv06BE
         njMw==
X-Gm-Message-State: AOAM530Xg0wwwHaTs33BT37SpGF0TxfEgAp149K1GwRndP18Tx/GlKTx
        XGhSlPs9vJ0Qyi+qP/Z3vIU=
X-Google-Smtp-Source: ABdhPJyeBiA/tH3PsHxnd66GIXunI9Egu/wbdZ3xMhy8DUUVhKMAukw25FvveJobdPlnw/xA2rYXEg==
X-Received: by 2002:aa7:8c12:0:b029:1b6:e47f:7458 with SMTP id c18-20020aa78c120000b02901b6e47f7458mr9543190pfd.67.1611398812052;
        Sat, 23 Jan 2021 02:46:52 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id 81sm11025209pfa.188.2021.01.23.02.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 02:46:51 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        GR-Linux-NIC-Dev@marvell.com, Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 3/8] staging: qlge: re-write qlge_init_device
Date:   Sat, 23 Jan 2021 18:46:08 +0800
Message-Id: <20210123104613.38359-4-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123104613.38359-1-coiby.xu@gmail.com>
References: <20210123104613.38359-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop calling ql_release_all in qlge_init_device and free things one step
at a time.

struct qlge_adapter *qdev is now a private structure of struct devlink
and memset is not necessary.

Link: https://lore.kernel.org/patchwork/patch/1321092/#1516928
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index bb9fc590d97b..2ec688d3d946 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4394,13 +4394,13 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 	err = pcie_set_readrq(pdev, 4096);
 	if (err) {
 		dev_err(&pdev->dev, "Set readrq failed.\n");
-		goto err_out1;
+		goto err_disable_pci;
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
 		dev_err(&pdev->dev, "PCI region request failed.\n");
-		return err;
+		goto err_disable_pci;
 	}
 
 	pci_set_master(pdev);
@@ -4416,7 +4416,7 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 
 	if (err) {
 		dev_err(&pdev->dev, "No usable DMA configuration.\n");
-		goto err_out2;
+		goto err_release_pci;
 	}
 
 	/* Set PCIe reset type for EEH to fundamental. */
@@ -4427,7 +4427,7 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 	if (!qdev->reg_base) {
 		dev_err(&pdev->dev, "Register mapping failed.\n");
 		err = -ENOMEM;
-		goto err_out2;
+		goto err_release_pci;
 	}
 
 	qdev->doorbell_area_size = pci_resource_len(pdev, 3);
@@ -4436,14 +4436,14 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 	if (!qdev->doorbell_area) {
 		dev_err(&pdev->dev, "Doorbell register mapping failed.\n");
 		err = -ENOMEM;
-		goto err_out2;
+		goto err_iounmap_base;
 	}
 
 	err = qlge_get_board_info(qdev);
 	if (err) {
 		dev_err(&pdev->dev, "Register access failed.\n");
 		err = -EIO;
-		goto err_out2;
+		goto err_iounmap_doorbell;
 	}
 	qdev->msg_enable = netif_msg_init(debug, default_msg);
 	spin_lock_init(&qdev->stats_lock);
@@ -4453,7 +4453,7 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 			vmalloc(sizeof(struct qlge_mpi_coredump));
 		if (!qdev->mpi_coredump) {
 			err = -ENOMEM;
-			goto err_out2;
+			goto err_iounmap_doorbell;
 		}
 		if (qlge_force_coredump)
 			set_bit(QL_FRC_COREDUMP, &qdev->flags);
@@ -4462,7 +4462,7 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 	err = qdev->nic_ops->get_flash(qdev);
 	if (err) {
 		dev_err(&pdev->dev, "Invalid FLASH.\n");
-		goto err_out2;
+		goto err_free_mpi_coredump;
 	}
 
 	/* Keep local copy of current mac address. */
@@ -4485,7 +4485,7 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 						  ndev->name);
 	if (!qdev->workqueue) {
 		err = -ENOMEM;
-		goto err_out2;
+		goto err_free_mpi_coredump;
 	}
 
 	INIT_DELAYED_WORK(&qdev->asic_reset_work, qlge_asic_reset_work);
@@ -4503,10 +4503,18 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 			 DRV_NAME, DRV_VERSION);
 	}
 	return 0;
-err_out2:
-	qlge_release_all(pdev);
-err_out1:
+
+err_free_mpi_coredump:
+	vfree(qdev->mpi_coredump);
+err_iounmap_doorbell:
+	iounmap(qdev->doorbell_area);
+err_iounmap_base:
+	iounmap(qdev->reg_base);
+err_release_pci:
+	pci_release_regions(pdev);
+err_disable_pci:
 	pci_disable_device(pdev);
+
 	return err;
 }
 
-- 
2.29.2

