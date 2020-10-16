Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5982904A1
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407146AbgJPMDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407139AbgJPMDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 08:03:14 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1F0C061755;
        Fri, 16 Oct 2020 05:03:14 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 10so1379796pfp.5;
        Fri, 16 Oct 2020 05:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x2GKJTo2qYsyHZMoxqFD1/J59i+y20zftI8/n7N//F0=;
        b=RmbZ2QKUprB3PBmJAZOZZfwjhQKeTGd75WF4P2jdtkzSHB7UJ59b249sN1RJsdxssq
         h6TL/AotkWcLakctndRkGIQpjdwfMBaKqusNShq0vKl4DAqPUaP/E98tpiHF55+pXzlA
         YwkQrr7OkDTRfow21Lyv/ZwllhlaDf/lCaLQ9WV95aHZC1f3rV7nt36fPRzY7mSFYf2/
         ivIN9mExJmCJGAiW3CpdHfGHimRV2xzfE323b8tIaTXSrQ0PYTlOsUT8YjLeMfOjlKky
         iZG7weTLGewxRhSUxela9k63qYFAMK2Medu5y1ZMGSQTj1aAmEAkKU8fRh2/AreRXIMf
         rcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x2GKJTo2qYsyHZMoxqFD1/J59i+y20zftI8/n7N//F0=;
        b=uHH3mWA78JGTZyYT868zzggWRZF6BBfVUU7J5hsvrNl7D+5mkHTrbMwVw87T0hJUZZ
         jU08i7RbSBPtXJbNDYc2tTfjEJzDcsMRKy1teFl6aKAKCyKYiflxuVOR8jBH1aZPxEVX
         pOYFPNiB0m9TDVnDmrVmTJ1pJH418XQIItet6/KH1RcTsTbEBxDtX2Mz29HEzxkwSGD5
         2iw6Wc0np55CokdZYXHiOcNAtkRHlQq7/BH6hWyEJl5WX7zxPHhaE/fxkQLawfKLaZwL
         Lb2VvumbK1eBEnYK/Vk8dRN8M36GUsebjqRAjJqBKydt3lF4owW5NQcRtzJm64aTS5KG
         pL3g==
X-Gm-Message-State: AOAM530aD8N85q507aOKiRFEx4bKx/U1wXGL6/ZUJPiAjRH3oqvUR4Ox
        ReOA330cmnFDrnR1FHlO3+Q=
X-Google-Smtp-Source: ABdhPJwXAsxYVZ5Efyh6fsHCFxax3jlgu8lAuipqYii9srQrDlSAxoFyU7g5bQ3W2of2q+2us7y/dA==
X-Received: by 2002:a63:5405:: with SMTP id i5mr2720197pgb.438.1602849793915;
        Fri, 16 Oct 2020 05:03:13 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id js21sm2850802pjb.14.2020.10.16.05.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 05:03:13 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 3/8] staging: qlge: re-write qlge_init_device
Date:   Fri, 16 Oct 2020 19:54:02 +0800
Message-Id: <20201016115407.170821-4-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016115407.170821-1-coiby.xu@gmail.com>
References: <20201016115407.170821-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop calling ql_release_all in qlge_init_device and free things one step
at a time.

Link: https://lore.kernel.org/patchwork/patch/1321092/#1516928
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 888179fbf98c..c081aa1bb43d 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4403,13 +4403,13 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
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
@@ -4425,7 +4425,7 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 
 	if (err) {
 		dev_err(&pdev->dev, "No usable DMA configuration.\n");
-		goto err_out2;
+		goto err_release_pci;
 	}
 
 	/* Set PCIe reset type for EEH to fundamental. */
@@ -4436,7 +4436,7 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 	if (!qdev->reg_base) {
 		dev_err(&pdev->dev, "Register mapping failed.\n");
 		err = -ENOMEM;
-		goto err_out2;
+		goto err_release_pci;
 	}
 
 	qdev->doorbell_area_size = pci_resource_len(pdev, 3);
@@ -4445,14 +4445,14 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
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
@@ -4462,7 +4462,7 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 			vmalloc(sizeof(struct qlge_mpi_coredump));
 		if (!qdev->mpi_coredump) {
 			err = -ENOMEM;
-			goto err_out2;
+			goto err_iounmap_doorbell;
 		}
 		if (qlge_force_coredump)
 			set_bit(QL_FRC_COREDUMP, &qdev->flags);
@@ -4471,7 +4471,7 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 	err = qdev->nic_ops->get_flash(qdev);
 	if (err) {
 		dev_err(&pdev->dev, "Invalid FLASH.\n");
-		goto err_out2;
+		goto err_free_mpi_coredump;
 	}
 
 	/* Keep local copy of current mac address. */
@@ -4494,7 +4494,7 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 						  ndev->name);
 	if (!qdev->workqueue) {
 		err = -ENOMEM;
-		goto err_out2;
+		goto err_free_mpi_coredump;
 	}
 
 	INIT_DELAYED_WORK(&qdev->asic_reset_work, qlge_asic_reset_work);
@@ -4512,10 +4512,18 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
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
2.28.0

