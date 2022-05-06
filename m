Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C7F51D47E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 11:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390508AbiEFJcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 05:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348982AbiEFJcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 05:32:43 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B13D64BCE;
        Fri,  6 May 2022 02:29:00 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KvlWN1xJ8zVfqG;
        Fri,  6 May 2022 17:24:16 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 6 May 2022 17:28:58 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 6 May
 2022 17:28:57 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <netdev@vger.kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>
Subject: [PATCH] net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()
Date:   Fri, 6 May 2022 17:40:39 +0800
Message-ID: <20220506094039.3629649-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

Fix the missing pci_disable_device() before return
from stmmac_pci_probe() in the error handling case.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index fcf17d8a0494..02bddc05a34f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -194,7 +194,7 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 			continue;
 		ret = pcim_iomap_regions(pdev, BIT(i), pci_name(pdev));
 		if (ret)
-			return ret;
+			goto err_out_disable_device;
 		break;
 	}
 
@@ -202,7 +202,7 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 
 	ret = info->setup(pdev, plat);
 	if (ret)
-		return ret;
+		goto err_out_disable_device;
 
 	memset(&res, 0, sizeof(res));
 	res.addr = pcim_iomap_table(pdev)[i];
@@ -219,7 +219,16 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 	plat->safety_feat_cfg->prtyen = 1;
 	plat->safety_feat_cfg->tmouten = 1;
 
-	return stmmac_dvr_probe(&pdev->dev, plat, &res);
+	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
+	if (ret)
+		goto err_out_disable_device;
+
+	return 0;
+
+err_out_disable_device:
+	pci_disable_device(pdev);
+
+	return ret;
 }
 
 /**
-- 
2.25.1

