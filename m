Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A827E63FFC5
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 06:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiLBFPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 00:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiLBFPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 00:15:43 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABA6D67A1;
        Thu,  1 Dec 2022 21:15:42 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NNh2p04sMzRpYx;
        Fri,  2 Dec 2022 13:14:58 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 13:15:40 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <aspriel@gmail.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <arend@broadcom.com>, Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH v2] wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()
Date:   Fri, 2 Dec 2022 13:35:42 +0800
Message-ID: <1669959342-27144-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code instead of 0 when
brcmf_chip_set_active() fails. In addition, change the return
value for brcmf_pcie_exit_download_state() to keep consistent.

Fixes: d380ebc9b6fb ("brcmfmac: rename chip download functions")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
v2: change the error code from EINVAL to EIO, as Arend suggessted

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 80083f9..aaf8e12 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -726,7 +726,7 @@ static int brcmf_pcie_exit_download_state(struct brcmf_pciedev_info *devinfo,
 	}
 
 	if (!brcmf_chip_set_active(devinfo->ci, resetintr))
-		return -EINVAL;
+		return -EIO;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 465d95d..e265a2e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3414,6 +3414,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	/* Take arm out of reset */
 	if (!brcmf_chip_set_active(bus->ci, rstvec)) {
 		brcmf_err("error getting out of ARM core reset\n");
+		bcmerror = -EIO;
 		goto err;
 	}
 
-- 
1.8.3.1

