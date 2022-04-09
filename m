Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6624FA6E8
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 12:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241451AbiDILBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiDILBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:01:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EBF6D859;
        Sat,  9 Apr 2022 03:59:36 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KbBsl6rx5zgYLj;
        Sat,  9 Apr 2022 18:57:47 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 9 Apr
 2022 18:59:34 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        <s-vadapalli@ti.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] net: ethernet: ti: am65-cpsw: Fix build error without PHYLINK
Date:   Sat, 9 Apr 2022 18:59:31 +0800
Message-ID: <20220409105931.9080-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If PHYLINK is n, build fails:

drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_set_link_ksettings':
am65-cpsw-ethtool.c:(.text+0x118): undefined reference to `phylink_ethtool_ksettings_set'
drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_get_link_ksettings':
am65-cpsw-ethtool.c:(.text+0x138): undefined reference to `phylink_ethtool_ksettings_get'
drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_set_eee':
am65-cpsw-ethtool.c:(.text+0x158): undefined reference to `phylink_ethtool_set_eee'

Select PHYLINK for TI_K3_AM65_CPSW_NUSS to fix this.

Fixes: e8609e69470f ("net: ethernet: ti: am65-cpsw: Convert to PHYLINK")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/ti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index affcf92cd3aa..fb30bc5d56cb 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -94,6 +94,7 @@ config TI_K3_AM65_CPSW_NUSS
 	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
 	select NET_DEVLINK
 	select TI_DAVINCI_MDIO
+	select PHYLINK
 	imply PHY_TI_GMII_SEL
 	depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS
 	help
-- 
2.17.1

