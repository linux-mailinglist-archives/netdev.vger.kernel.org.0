Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368D22ABB30
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbgKINZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:25:19 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7069 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387441AbgKINZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:25:16 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CVBYq5x05zhjXm;
        Mon,  9 Nov 2020 21:25:03 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 21:25:01 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <krzk@kernel.org>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <madalin.bucur@nxp.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mperttunen@nvidia.com>,
        <tomeu.vizoso@collabora.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <netdev@vger.kernel.org>, <yukuai3@huawei.com>,
        <yi.zhang@huawei.com>
Subject: [PATCH V2] memory: tegra: add missing put_devcie() call in error path of tegra_emc_probe()
Date:   Mon, 9 Nov 2020 21:28:47 +0800
Message-ID: <20201109132847.1738010-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201102185216.GB13405@kozik-lap>
References: <20201102185216.GB13405@kozik-lap>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reference to device obtained with of_find_device_by_node() should
be dropped. Thus add jump target to fix the exception handling for this
function implementation.

Fixes: 73a7f0a90641("memory: tegra: Add EMC (external memory controller) driver")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/memory/tegra/tegra124-emc.c           | 21 +++++++++++++------
 .../net/ethernet/freescale/fman/fman_port.c   |  3 +--
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/memory/tegra/tegra124-emc.c b/drivers/memory/tegra/tegra124-emc.c
index 76ace42a688a..7d58a0e0a177 100644
--- a/drivers/memory/tegra/tegra124-emc.c
+++ b/drivers/memory/tegra/tegra124-emc.c
@@ -1207,8 +1207,10 @@ static int tegra_emc_probe(struct platform_device *pdev)
 		return -ENOENT;
 
 	emc->mc = platform_get_drvdata(mc);
-	if (!emc->mc)
-		return -EPROBE_DEFER;
+	if (!emc->mc) {
+		err = -EPROBE_DEFER;
+		goto put_device;
+	}
 
 	ram_code = tegra_read_ram_code();
 
@@ -1217,25 +1219,27 @@ static int tegra_emc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"no memory timings for RAM code %u found in DT\n",
 			ram_code);
-		return -ENOENT;
+		err = -ENOENT;
+		goto put_device;
 	}
 
 	err = tegra_emc_load_timings_from_dt(emc, np);
 	of_node_put(np);
 	if (err)
-		return err;
+		goto put_device;
 
 	if (emc->num_timings == 0) {
 		dev_err(&pdev->dev,
 			"no memory timings for RAM code %u registered\n",
 			ram_code);
-		return -ENOENT;
+		err = -ENOENT;
+		goto put_device;
 	}
 
 	err = emc_init(emc);
 	if (err) {
 		dev_err(&pdev->dev, "EMC initialization failed: %d\n", err);
-		return err;
+		goto put_device;
 	}
 
 	platform_set_drvdata(pdev, emc);
@@ -1244,6 +1248,11 @@ static int tegra_emc_probe(struct platform_device *pdev)
 		emc_debugfs_init(&pdev->dev, emc);
 
 	return 0;
+
+put_device:
+	put_device(&mc->dev);
+
+	return err;
 };
 
 static struct platform_driver tegra_emc_driver = {
diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index 9790e483241b..fcc59444df17 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1792,7 +1792,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	if (!fm_node) {
 		dev_err(port->dev, "%s: of_get_parent() failed\n", __func__);
 		err = -ENODEV;
-		goto free_port;
+		goto put_node;
 	}
 
 	fm_pdev = of_find_device_by_node(fm_node);
@@ -1899,7 +1899,6 @@ static int fman_port_probe(struct platform_device *of_dev)
 	put_device(&fm_pdev->dev);
 put_node:
 	of_node_put(port_node);
-free_port:
 	kfree(port);
 	return err;
 }
-- 
2.25.4

