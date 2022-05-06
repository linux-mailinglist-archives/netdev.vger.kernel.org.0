Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335E651CF6F
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 05:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388561AbiEFDco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 23:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388539AbiEFDcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 23:32:43 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECA8644C8;
        Thu,  5 May 2022 20:29:02 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KvbZJ6RLrzGpVl;
        Fri,  6 May 2022 11:26:16 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 6 May 2022 11:29:01 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 6 May
 2022 11:29:00 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <snelson@pensando.io>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH] ionic: fix missing pci_release_regions() on error in ionic_probe()
Date:   Fri, 6 May 2022 11:40:40 +0800
Message-ID: <20220506034040.2614129-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ionic_map_bars() fails, pci_release_regions() need be called.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 6ffc62c41165..0a7a757494bc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -256,7 +256,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = ionic_map_bars(ionic);
 	if (err)
-		goto err_out_pci_disable_device;
+		goto err_out_pci_release_regions;
 
 	/* Configure the device */
 	err = ionic_setup(ionic);
@@ -360,6 +360,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_unmap_bars:
 	ionic_unmap_bars(ionic);
+err_out_pci_release_regions:
 	pci_release_regions(pdev);
 err_out_pci_disable_device:
 	pci_disable_device(pdev);
-- 
2.25.1

