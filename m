Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9112B5E777C
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiIWJnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiIWJmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:42:42 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529FE13198A;
        Fri, 23 Sep 2022 02:41:55 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MYnBH715Tz1P6tM;
        Fri, 23 Sep 2022 17:37:43 +0800 (CST)
Received: from huawei.com (10.67.175.83) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 23 Sep
 2022 17:41:52 +0800
From:   ruanjinjie <ruanjinjie@huawei.com>
To:     <aspriel@gmail.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <marcan@marcan.st>,
        <linus.walleij@linaro.org>, <rmk+kernel@armlinux.org.uk>,
        <soontak.lee@cypress.com>, <linux-wireless@vger.kernel.org>,
        <SHA-cyfmac-dev-list@infineon.com>,
        <brcm80211-dev-list.pdl@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next] wifi: brcmfmac: pcie: add missing pci_disable_device() in brcmf_pcie_get_resource()
Date:   Fri, 23 Sep 2022 17:38:06 +0800
Message-ID: <20220923093806.3108119-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.83]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing pci_disable_device() if brcmf_pcie_get_resource() fails.

Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index f98641bb1528..25fa69793d86 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1725,7 +1725,8 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 	if ((bar1_size == 0) || (bar1_addr == 0)) {
 		brcmf_err(bus, "BAR1 Not enabled, device size=%ld, addr=%#016llx\n",
 			  bar1_size, (unsigned long long)bar1_addr);
-		return -EINVAL;
+		err = -EINVAL;
+		goto err_disable;
 	}
 
 	devinfo->regs = ioremap(bar0_addr, BRCMF_PCIE_REG_MAP_SIZE);
@@ -1734,7 +1735,8 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 	if (!devinfo->regs || !devinfo->tcm) {
 		brcmf_err(bus, "ioremap() failed (%p,%p)\n", devinfo->regs,
 			  devinfo->tcm);
-		return -EINVAL;
+		err = -EINVAL;
+		goto err_disable;
 	}
 	brcmf_dbg(PCIE, "Phys addr : reg space = %p base addr %#016llx\n",
 		  devinfo->regs, (unsigned long long)bar0_addr);
@@ -1743,6 +1745,9 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 		  (unsigned int)bar1_size);
 
 	return 0;
+err_disable:
+	pci_disable_device(pdev);
+	return err;
 }
 
 
-- 
2.25.1

