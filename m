Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664912A1554
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgJaKud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:50:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7023 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgJaKud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 06:50:33 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CNbYh3qb1zhYxr;
        Sat, 31 Oct 2020 18:50:32 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sat, 31 Oct 2020
 18:50:21 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <madalin.bucur@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <florinel.iordache@nxp.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH] fsl/fman: add missing put_devcie() call in fman_port_probe()
Date:   Sat, 31 Oct 2020 18:54:18 +0800
Message-ID: <20201031105418.2304011-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.25.4
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
 drivers/net/ethernet/freescale/fman/fman_port.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index d9baac0dbc7d..576ce6df3fce 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1799,13 +1799,13 @@ static int fman_port_probe(struct platform_device *of_dev)
 	of_node_put(fm_node);
 	if (!fm_pdev) {
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	fman = dev_get_drvdata(&fm_pdev->dev);
 	if (!fman) {
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	err = of_property_read_u32(port_node, "cell-index", &val);
@@ -1813,7 +1813,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: reading cell-index for %pOF failed\n",
 			__func__, port_node);
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 	port_id = (u8)val;
 	port->dts_params.id = port_id;
@@ -1847,7 +1847,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	}  else {
 		dev_err(port->dev, "%s: Illegal port type\n", __func__);
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	port->dts_params.type = port_type;
@@ -1861,7 +1861,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 			dev_err(port->dev, "%s: incorrect qman-channel-id\n",
 				__func__);
 			err = -EINVAL;
-			goto return_err;
+			goto put_device;
 		}
 		port->dts_params.qman_channel_id = qman_channel_id;
 	}
@@ -1871,7 +1871,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: of_address_to_resource() failed\n",
 			__func__);
 		err = -ENOMEM;
-		goto return_err;
+		goto put_device;
 	}
 
 	port->dts_params.fman = fman;
@@ -1898,6 +1898,8 @@ static int fman_port_probe(struct platform_device *of_dev)
 
 return_err:
 	of_node_put(port_node);
+put_device:
+	put_device(&fm_pdev->dev);
 free_port:
 	kfree(port);
 	return err;
-- 
2.25.4

