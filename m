Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CD9502084
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 04:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348684AbiDOCdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 22:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348680AbiDOCds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 22:33:48 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381163153C;
        Thu, 14 Apr 2022 19:31:21 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KfgKs4kLqz1HBVc;
        Fri, 15 Apr 2022 10:30:41 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 15 Apr 2022 10:31:19 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 15 Apr
 2022 10:31:19 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <vburru@marvell.com>, <aayarekar@marvell.com>,
        <sburla@marvell.com>, <davem@davemloft.net>
Subject: [PATCH -next] octeon_ep: fix error return code in octep_probe()
Date:   Fri, 15 Apr 2022 10:39:57 +0800
Message-ID: <20220415023957.1117879-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If register_netdev() fails , it should return error
code in octep_probe().

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 5d39c857ea41..f2af5ebffcf1 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1071,7 +1071,8 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
 	eth_hw_addr_set(netdev, octep_dev->mac_addr);
 
-	if (register_netdev(netdev)) {
+	err = register_netdev(netdev);
+	if (err) {
 		dev_err(&pdev->dev, "Failed to register netdev\n");
 		goto register_dev_err;
 	}
-- 
2.25.1

