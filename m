Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E8F60CD00
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 15:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiJYNJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 09:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbiJYNJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 09:09:04 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319A26171A
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 06:09:01 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MxXFn49WFzVj2d;
        Tue, 25 Oct 2022 21:04:13 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 21:08:59 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 25 Oct
 2022 21:08:59 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <leon@kernel.org>
Subject: [PATCH net v2] net: fealnx: fix missing pci_disable_device()
Date:   Tue, 25 Oct 2022 21:07:51 +0800
Message-ID: <20221025130751.1075684-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing pci_disable_device() in error path of probe() and remove() path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v1 -> v2:
  Don't use pcim_enable_device(), call pci_disable_device() directly.
---
 drivers/net/ethernet/fealnx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index ed18450fd2cc..d72256391d49 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -502,7 +502,8 @@ static int fealnx_init_one(struct pci_dev *pdev,
 	if (len < MIN_REGION_SIZE) {
 		dev_err(&pdev->dev,
 			   "region size %ld too small, aborting\n", len);
-		return -ENODEV;
+		err = -ENODEV;
+		goto err_out_disable;
 	}
 
 	i = pci_request_regions(pdev, boardname);
@@ -671,6 +672,8 @@ static int fealnx_init_one(struct pci_dev *pdev,
 	pci_iounmap(pdev, ioaddr);
 err_out_res:
 	pci_release_regions(pdev);
+err_out_disable:
+	pci_disable_device(pdev);
 	return err;
 }
 
@@ -690,6 +693,7 @@ static void fealnx_remove_one(struct pci_dev *pdev)
 		pci_iounmap(pdev, np->mem);
 		free_netdev(dev);
 		pci_release_regions(pdev);
+		pci_disable_device(pdev);
 	} else
 		printk(KERN_ERR "fealnx: remove for unknown device\n");
 }
-- 
2.25.1

