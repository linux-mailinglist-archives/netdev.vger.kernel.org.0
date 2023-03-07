Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF416AEFD4
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjCGS0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjCGSZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:25:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BC19F222;
        Tue,  7 Mar 2023 10:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BBA2B819BC;
        Tue,  7 Mar 2023 18:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B48C4339B;
        Tue,  7 Mar 2023 18:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213217;
        bh=tD/0BL32SiQcpNBmJHR6772uCW+5TraI1VbasTgz7rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbVVdSNDnyNV49AyShaP6RIuX1dc5dxxhIePy1arx73pACarVWRbwCfM1jfpqnXQu
         160kKUUktsg7XBwBwusGMhIyVMTuBc4j5yq8pknrVfUG7/g6+WzDlulcM56zHr1Fdd
         BZmfK0IGTd2iiQTrmZJZRxNI12ecHDoKgWt03lqBelb3xw0FZQRiwNAsJKGkrTbssp
         opCb+2SGJ2a5M/my0pxbUbT9Ln+2xNJffl0yj7MKKnSYnIF9p5rlxWol3NUNZc8isl
         D/tr/imA2CMJu2WJRxn7pHLTFvPeQ2TQAr0CfXZPXhKDCNxgliFqSbfC9Eeb8e/eFA
         gBfquTrK3fw5w==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>
Subject: [PATCH 11/28] qed: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:22 -0600
Message-Id: <20230307181940.868828-12-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

pci_enable_pcie_error_reporting() enables the device to send ERR_*
Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
native"), the PCI core does this for all devices during enumeration, so the
driver doesn't need to do it itself.

Remove the redundant pci_enable_pcie_error_reporting() call from the
driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
from the driver .remove() path.

Note that this only controls ERR_* Messages from the device.  An ERR_*
Message may cause the Root Port to generate an interrupt, depending on the
AER Root Error Command register managed by the AER service driver.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index c91898be7c03..f5af83342856 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -23,7 +23,6 @@
 #include <linux/qed/qed_if.h>
 #include <linux/qed/qed_ll2_if.h>
 #include <net/devlink.h>
-#include <linux/aer.h>
 #include <linux/phylink.h>
 
 #include "qed.h"
@@ -259,8 +258,6 @@ static void qed_free_pci(struct qed_dev *cdev)
 {
 	struct pci_dev *pdev = cdev->pdev;
 
-	pci_disable_pcie_error_reporting(pdev);
-
 	if (cdev->doorbells && cdev->db_size)
 		iounmap(cdev->doorbells);
 	if (cdev->regview)
@@ -366,12 +363,6 @@ static int qed_init_pci(struct qed_dev *cdev, struct pci_dev *pdev)
 		return -ENOMEM;
 	}
 
-	/* AER (Advanced Error reporting) configuration */
-	rc = pci_enable_pcie_error_reporting(pdev);
-	if (rc)
-		DP_VERBOSE(cdev, NETIF_MSG_DRV,
-			   "Failed to configure PCIe AER [%d]\n", rc);
-
 	return 0;
 
 err2:
-- 
2.25.1

