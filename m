Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1222410D6
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgHJTJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbgHJTJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92D1E22B45;
        Mon, 10 Aug 2020 19:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086567;
        bh=cBJbYSQY8TZQCT0eXnANmfIOvzV3nWmaS0vZYyZEUrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMkWFeqiTVD1ecgXFeu7i/Mw0rxC5eIZPn4H4ut2jMn4d4yB9AHzUDZsy2apozYCD
         hS5bSYRtkkKHMzqtWsfB8pEmqEA54y9LmAeIsJxuN2PfFmsWv9pIXQjH5iQaJDNWDI
         IGhCJZk+7YFcMP9IgOTQjiYQeXLfaUnzSEci+a0Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 20/64] ionic: rearrange reset and bus-master control
Date:   Mon, 10 Aug 2020 15:08:15 -0400
Message-Id: <20200810190859.3793319-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 6a6014e2fb276753d4dc9b803370e7af7f57e30b ]

We can prevent potential incorrect DMA access attempts from the
NIC by enabling bus-master after the reset, and by disabling
bus-master earlier in cleanup.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 2924cde440aa8..85c686c16741f 100644
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
2.25.1

