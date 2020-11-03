Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893F92A43F3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 12:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgKCLTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 06:19:40 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7452 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbgKCLTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 06:19:39 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CQS3r0QSJzhf94;
        Tue,  3 Nov 2020 19:19:36 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Tue, 3 Nov 2020
 19:19:29 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <madalin.bucur@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <florinel.iordache@nxp.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH V2] fsl/fman: add missing put_devcie() call in fman_port_probe()
Date:   Tue, 3 Nov 2020 19:23:23 +0800
Message-ID: <20201103112323.1077040-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201031105418.2304011-1-yukuai3@huawei.com>
References: <20201031105418.2304011-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if of_find_device_by_node() succeed, fman_port_probe() doesn't have a
corresponding put_device(). Thus add jump target to fix the exception
handling for this function implementation.

Fixes: 0572054617f3 ("fsl/fman: fix dereference null return value")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 .../net/ethernet/freescale/fman/fman_port.c   | 23 +++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index d9baac0dbc7d..4ae5d844d1f5 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1792,20 +1792,21 @@ static int fman_port_probe(struct platform_device *of_dev)
 	if (!fm_node) {
 		dev_err(port->dev, "%s: of_get_parent() failed\n", __func__);
 		err = -ENODEV;
-		goto return_err;
+		goto free_port;
 	}
 
+	of_node_put(port_node);
 	fm_pdev = of_find_device_by_node(fm_node);
 	of_node_put(fm_node);
 	if (!fm_pdev) {
 		err = -EINVAL;
-		goto return_err;
+		goto free_port;
 	}
 
 	fman = dev_get_drvdata(&fm_pdev->dev);
 	if (!fman) {
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	err = of_property_read_u32(port_node, "cell-index", &val);
@@ -1813,7 +1814,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: reading cell-index for %pOF failed\n",
 			__func__, port_node);
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 	port_id = (u8)val;
 	port->dts_params.id = port_id;
@@ -1847,7 +1848,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	}  else {
 		dev_err(port->dev, "%s: Illegal port type\n", __func__);
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	port->dts_params.type = port_type;
@@ -1861,7 +1862,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 			dev_err(port->dev, "%s: incorrect qman-channel-id\n",
 				__func__);
 			err = -EINVAL;
-			goto return_err;
+			goto put_device;
 		}
 		port->dts_params.qman_channel_id = qman_channel_id;
 	}
@@ -1871,20 +1872,18 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: of_address_to_resource() failed\n",
 			__func__);
 		err = -ENOMEM;
-		goto return_err;
+		goto put_device;
 	}
 
 	port->dts_params.fman = fman;
 
-	of_node_put(port_node);
-
 	dev_res = __devm_request_region(port->dev, &res, res.start,
 					resource_size(&res), "fman-port");
 	if (!dev_res) {
 		dev_err(port->dev, "%s: __devm_request_region() failed\n",
 			__func__);
 		err = -EINVAL;
-		goto free_port;
+		goto put_device;
 	}
 
 	port->dts_params.base_addr = devm_ioremap(port->dev, res.start,
@@ -1896,8 +1895,8 @@ static int fman_port_probe(struct platform_device *of_dev)
 
 	return 0;
 
-return_err:
-	of_node_put(port_node);
+put_device:
+	put_device(&fm_pdev->dev);
 free_port:
 	kfree(port);
 	return err;
-- 
2.25.4

