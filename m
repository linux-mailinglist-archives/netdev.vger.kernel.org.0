Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B8138D558
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 12:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhEVKz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 06:55:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5740 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhEVKzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 06:55:20 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnKxn682HzqV7g;
        Sat, 22 May 2021 18:50:21 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 18:53:54 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 22 May
 2021 18:53:54 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>
Subject: [PATCH -next 2/2] ath10k: add missing error return code in ath10k_pci_probe()
Date:   Sat, 22 May 2021 18:58:22 +0800
Message-ID: <20210522105822.1091848-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210522105822.1091848-1-yangyingliang@huawei.com>
References: <20210522105822.1091848-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When chip_id is not supported, the resources will be freed
on path err_unsupported, these resources will also be freed
when calling ath10k_pci_remove(), it will cause double free,
so return -ENODEV when it doesn't support the device with wrong
chip_id.

Fixes: c0c378f9907c ("ath10k: remove target soc ps code")
Fixes: 7505f7c3ec1d ("ath10k: create a chip revision whitelist")
Fixes: f8914a14623a ("ath10k: restore QCA9880-AR1A (v1) detection")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 463cf3f8f8a5..71878ab35b93 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3685,8 +3685,10 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 			ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 		if (bus_params.chip_id != 0xffffffff) {
 			if (!ath10k_pci_chip_is_supported(pdev->device,
-							  bus_params.chip_id))
+							  bus_params.chip_id)) {
+				ret = -ENODEV;
 				goto err_unsupported;
+			}
 		}
 	}
 
@@ -3697,11 +3699,15 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	}
 
 	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
-	if (bus_params.chip_id == 0xffffffff)
+	if (bus_params.chip_id == 0xffffffff) {
+		ret = -ENODEV;
 		goto err_unsupported;
+	}
 
-	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id))
+	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id)) {
+		ret = -ENODEV;
 		goto err_unsupported;
+	}
 
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
-- 
2.25.1

