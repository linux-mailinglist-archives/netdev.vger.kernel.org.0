Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF01F626820
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 09:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiKLIVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 03:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbiKLIVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 03:21:01 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7ACE1E
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 00:20:59 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N8T6K3RP6z15MY1;
        Sat, 12 Nov 2022 16:20:41 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 12 Nov 2022 16:20:57 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 12 Nov 2022 16:20:57 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <lanhao@huawei.com>, <lipeng321@huawei.com>,
        <shenjian15@huawei.com>, <linyunsheng@huawei.com>,
        <liuyonglong@huawei.com>, <chenhao418@huawei.com>,
        <wangjie125@huawei.com>, <huangguangbin2@huawei.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <xiaojiantao1@h-partners.com>
Subject: [PATCH net 3/3] net: hns3: fix setting incorrect phy link ksettings for firmware in resetting process
Date:   Sat, 12 Nov 2022 16:21:18 +0800
Message-ID: <20221112082118.57844-4-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221112082118.57844-1-lanhao@huawei.com>
References: <20221112082118.57844-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Currently, if driver is in phy-imp(phy controlled by imp firmware) mode, as
driver did not update phy link ksettings after initialization process or
not update advertising when getting phy link ksettings from firmware, it
may set incorrect phy link ksettings for firmware in resetting process.

So fix it.
Fixes: f5f2b3e4dcc0 ("net: hns3: add support for imp-controlled PHYs")
Fixes: c5ef83cbb1e9 ("net: hns3: fix for phy_addr error in hclge_mac_mdio_config")
Fixes: 2312e050f42b ("net: hns3: Fix for deadlock problem occurring when unregistering ae_algo")

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e34ac9c5900e..4e54f91f7a6c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3443,6 +3443,7 @@ static int hclge_update_tp_port_info(struct hclge_dev *hdev)
 	hdev->hw.mac.autoneg = cmd.base.autoneg;
 	hdev->hw.mac.speed = cmd.base.speed;
 	hdev->hw.mac.duplex = cmd.base.duplex;
+	linkmode_copy(hdev->hw.mac.advertising, cmd.link_modes.advertising);
 
 	return 0;
 }
@@ -11586,9 +11587,12 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_msi_irq_uninit;
 
-	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER &&
-	    !hnae3_dev_phy_imp_supported(hdev)) {
-		ret = hclge_mac_mdio_config(hdev);
+	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER) {
+		if (hnae3_dev_phy_imp_supported(hdev))
+			ret = hclge_update_tp_port_info(hdev);
+		else
+			ret = hclge_mac_mdio_config(hdev);
+
 		if (ret)
 			goto err_msi_irq_uninit;
 	}
-- 
2.30.0

