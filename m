Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970B060B665
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiJXS4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbiJXSzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:55:42 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50E116EA14
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:36:22 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MwxP11PKZzmVPc;
        Mon, 24 Oct 2022 21:53:25 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 21:58:15 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 21:58:15 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net] net: fealnx: fix missing pci_disable_device()
Date:   Mon, 24 Oct 2022 21:57:28 +0800
Message-ID: <20221024135728.2894863-1-yangyingliang@huawei.com>
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

pci_disable_device() need be called while module exiting, switch
to use pcim_enable(), pci_disable_device() and pci_release_regions()
will be called in pcim_release() while unbinding device.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/fealnx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index ed18450fd2cc..fb139f295b67 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -494,7 +494,7 @@ static int fealnx_init_one(struct pci_dev *pdev,
 
 	option = card_idx < MAX_UNITS ? options[card_idx] : 0;
 
-	i = pci_enable_device(pdev);
+	i = pcim_enable_device(pdev);
 	if (i) return i;
 	pci_set_master(pdev);
 
@@ -670,7 +670,6 @@ static int fealnx_init_one(struct pci_dev *pdev,
 err_out_unmap:
 	pci_iounmap(pdev, ioaddr);
 err_out_res:
-	pci_release_regions(pdev);
 	return err;
 }
 
@@ -689,7 +688,6 @@ static void fealnx_remove_one(struct pci_dev *pdev)
 		unregister_netdev(dev);
 		pci_iounmap(pdev, np->mem);
 		free_netdev(dev);
-		pci_release_regions(pdev);
 	} else
 		printk(KERN_ERR "fealnx: remove for unknown device\n");
 }
-- 
2.25.1

