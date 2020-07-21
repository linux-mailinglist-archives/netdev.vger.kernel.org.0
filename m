Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3DB2289FA
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbgGUUeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730830AbgGUUeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:34:20 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF78BC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:20 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q17so1553pfu.8
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bb4/u6aH3Ltg2xV3fnnX4+gNGBdiu9JP2ZbDXCCeFtc=;
        b=Z8O50KOxKDVEq5jAWsseGsYOi5Mqt4BgtDbbheLdYqS+dxDAsITyELX4YsKnx/o+OO
         TR7FAhmTjf1p98I6KZnv71VHzq6G0AlvqqIG0YEmXHY3M2b2k1LamV2eQXFxBPd1a1+R
         5eC5EkPE1qpByIxp8J89unx1hONP2LAlpgFMFCVQfZ7l6r5EW2DRBpIhOTHYgyRWkaLt
         L7jKZL8Q1N/W41ephXLRvbuJ1/CySpPqoXJVzNl2KpEk7wWyzSooEYMoMeJGD29xkzML
         MtH1vyw9kCZOOmPXT+Uy/LOEmqIIgdRzMuSAXGBds6dRTCSF/WsIqsJHx2q+xDeld4ya
         pyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bb4/u6aH3Ltg2xV3fnnX4+gNGBdiu9JP2ZbDXCCeFtc=;
        b=YhSzsHUBNm1qse1SZSIPqBM2UuB+zKSy6uhzluPWW8N/ClRWtLiEzp3HQodnI2ATWE
         PO9Krb3ecZj3Y400ri7UIt1H1VQZzl74VAHT0ZrwObKOqSpevPTz1C1b4so5XI98Rjy2
         m2irjqUsyMb0myGKATD591TgtFL8ekUYDLB4EDw2XZay2GT2MhjpzrM8397NKBNM367k
         hhzYjFYhTgqat0e4ACX2VOdXWX2qAsJNPHV6FEKbVZ+rv/WZdJYucs1t1/N81atpFg9Q
         Mt60sCEOahAfLlnq+GZKDbjVVU3WrTUlu93hAQuu/rFo3/usBR/bX/elJzbgkApKCzr2
         EMkw==
X-Gm-Message-State: AOAM530rS3Vt2wbQ8KshQgahjQ/FINy1z56a4QX10BXwpIoygXv9JUFU
        xb5HCL+QXWj1ZOG7IIRplxcZXo8v9Bw=
X-Google-Smtp-Source: ABdhPJzaVkUUZwRIJv+Cqjw2vjMKFV/2QFPMEgCzoFo+sC4uTisv2yXCkXuOehgWDFbZR35pAvfMIQ==
X-Received: by 2002:a65:63c8:: with SMTP id n8mr23975092pgv.232.1595363660123;
        Tue, 21 Jul 2020 13:34:20 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p11sm4075107pjb.3.2020.07.21.13.34.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 13:34:19 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/6] ionic: rearrange reset and bus-master control
Date:   Tue, 21 Jul 2020 13:34:08 -0700
Message-Id: <20200721203409.3432-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721203409.3432-1-snelson@pensando.io>
References: <20200721203409.3432-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can prevent potential incorrect DMA access attempts from the
NIC by enabling bus-master after the reset, and by disabling
bus-master earlier in cleanup.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 2924cde440aa..85c686c16741 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -247,12 +247,11 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_pci_disable_device;
 	}
 
-	pci_set_master(pdev);
 	pcie_print_link_status(pdev);
 
 	err = ionic_map_bars(ionic);
 	if (err)
-		goto err_out_pci_clear_master;
+		goto err_out_pci_disable_device;
 
 	/* Configure the device */
 	err = ionic_setup(ionic);
@@ -260,6 +259,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(dev, "Cannot setup device: %d, aborting\n", err);
 		goto err_out_unmap_bars;
 	}
+	pci_set_master(pdev);
 
 	err = ionic_identify(ionic);
 	if (err) {
@@ -350,6 +350,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ionic_reset(ionic);
 err_out_teardown:
 	ionic_dev_teardown(ionic);
+	pci_clear_master(pdev);
 	/* Don't fail the probe for these errors, keep
 	 * the hw interface around for inspection
 	 */
@@ -358,8 +359,6 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_unmap_bars:
 	ionic_unmap_bars(ionic);
 	pci_release_regions(pdev);
-err_out_pci_clear_master:
-	pci_clear_master(pdev);
 err_out_pci_disable_device:
 	pci_disable_device(pdev);
 err_out_debugfs_del_dev:
@@ -389,9 +388,9 @@ static void ionic_remove(struct pci_dev *pdev)
 	ionic_port_reset(ionic);
 	ionic_reset(ionic);
 	ionic_dev_teardown(ionic);
+	pci_clear_master(pdev);
 	ionic_unmap_bars(ionic);
 	pci_release_regions(pdev);
-	pci_clear_master(pdev);
 	pci_disable_device(pdev);
 	ionic_debugfs_del_dev(ionic);
 	mutex_destroy(&ionic->dev_cmd_lock);
-- 
2.17.1

