Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDC05532C3
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 15:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351118AbiFUNAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 09:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351022AbiFUNA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 09:00:28 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9702C119;
        Tue, 21 Jun 2022 05:59:57 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LS6334vNNzSgwV;
        Tue, 21 Jun 2022 20:56:31 +0800 (CST)
Received: from huawei.com (10.175.127.227) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 21 Jun
 2022 20:59:54 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <boon.leong.ong@intel.com>,
        <rmk+kernel@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <zhengbin13@huawei.com>, <gaochao49@huawei.com>
Subject: [PATCH -next] net: pcs: pcs-xpcs: Fix build error when CONFIG_PCS_XPCS=y && CONFIG_PHYLINK=m
Date:   Tue, 21 Jun 2022 21:12:51 +0800
Message-ID: <20220621131251.3357104-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_PCS_XPCS=y, CONFIG_PHYLINK=m, bulding fails:

drivers/net/pcs/pcs-xpcs.o: in function `xpcs_do_config':
pcs-xpcs.c:(.text+0x64f): undefined reference to `phylink_mii_c22_pcs_encode_advertisement'
drivers/net/pcs/pcs-xpcs.o: in function `xpcs_get_state':
pcs-xpcs.c:(.text+0x10f8): undefined reference to `phylink_mii_c22_pcs_decode_state

Make PCS_XPCS depends on PHYLINK to fix this.

Fixes: b47aec885bcd ("net: pcs: xpcs: add CL37 1000BASE-X AN support")
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/pcs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..faec931b1e65 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -8,6 +8,7 @@ menu "PCS device drivers"
 config PCS_XPCS
 	tristate "Synopsys DesignWare XPCS controller"
 	depends on MDIO_DEVICE && MDIO_BUS
+	depends on PHYLINK
 	help
 	  This module provides helper functions for Synopsys DesignWare XPCS
 	  controllers.
--
2.31.1

