Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9254B620F6B
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbiKHLsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbiKHLsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:48:10 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E095712083
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:48:08 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N65vM1R8XzRp20;
        Tue,  8 Nov 2022 19:47:59 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 19:48:07 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 19:48:06 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <jiaxun.yang@flygoat.com>, <zhangqing@loongson.cn>,
        <liupeibao@loongson.cn>, <andrew@lunn.ch>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH net v2 2/3] stmmac: dwmac-loongson: fix missing pci_disable_device() in loongson_dwmac_probe()
Date:   Tue, 8 Nov 2022 19:46:46 +0800
Message-ID: <20221108114647.4144952-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221108114647.4144952-1-yangyingliang@huawei.com>
References: <20221108114647.4144952-1-yangyingliang@huawei.com>
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

Add missing pci_disable_device() in the error path in loongson_dwmac_probe().

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 16915b4d9505..2d480bc49c51 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -97,7 +97,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 			continue;
 		ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
 		if (ret)
-			return ret;
+			goto err_disable_device;
 		break;
 	}
 
@@ -108,7 +108,8 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	phy_mode = device_get_phy_mode(&pdev->dev);
 	if (phy_mode < 0) {
 		dev_err(&pdev->dev, "phy_mode not found\n");
-		return phy_mode;
+		ret = phy_mode;
+		goto err_disable_device;
 	}
 
 	plat->phy_interface = phy_mode;
@@ -149,6 +150,8 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 
 err_disable_msi:
 	pci_disable_msi(pdev);
+err_disable_device:
+	pci_disable_device(pdev);
 	return ret;
 }
 
-- 
2.25.1

