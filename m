Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE5963844F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 08:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiKYHNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 02:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKYHNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 02:13:45 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8BA1B1F1
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 23:13:44 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NJR0N5HGNzmW9X;
        Fri, 25 Nov 2022 15:13:08 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 25 Nov
 2022 15:13:42 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <ecree.xilinx@gmail.com>,
        <habetsm.xilinx@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <pieter.jansen-van-vuuren@amd.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net] sfc: fix error process in efx_ef100_pci_sriov_enable()
Date:   Fri, 25 Nov 2022 15:19:58 +0800
Message-ID: <20221125071958.276454-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two issues in efx_ef100_pci_sriov_enable():
1. When it doesn't have MAE Privilege, it doesn't disable pci sriov.
2. When creating VF successfully, it should return vf nums instead of 0.
Compiled test only.

Fixes: 08135eecd07f ("sfc: add skeleton ef100 VF representors")
Fixes: 78a9b3c47bef ("sfc: add EF100 VF support via a write to sriov_numvfs")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/sfc/ef100_sriov.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_sriov.c b/drivers/net/ethernet/sfc/ef100_sriov.c
index 94bdbfcb47e8..adf7fb09940e 100644
--- a/drivers/net/ethernet/sfc/ef100_sriov.c
+++ b/drivers/net/ethernet/sfc/ef100_sriov.c
@@ -25,15 +25,17 @@ static int efx_ef100_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
 	if (rc)
 		goto fail1;
 
-	if (!nic_data->grp_mae)
+	if (!nic_data->grp_mae) {
+		pci_disable_sriov(dev);
 		return 0;
+	}
 
 	for (i = 0; i < num_vfs; i++) {
 		rc = efx_ef100_vfrep_create(efx, i);
 		if (rc)
 			goto fail2;
 	}
-	return 0;
+	return num_vfs;
 
 fail2:
 	list_for_each_entry_safe(efv, next, &efx->vf_reps, list)
-- 
2.17.1

