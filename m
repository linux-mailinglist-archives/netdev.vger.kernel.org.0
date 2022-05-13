Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CAD525BD8
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 08:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377500AbiEMGzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 02:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377491AbiEMGzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 02:55:35 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FAF2A3749;
        Thu, 12 May 2022 23:55:33 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Kzzsx3YygzgYlc;
        Fri, 13 May 2022 14:55:01 +0800 (CST)
Received: from huawei.com (10.175.127.227) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 14:55:31 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <zhengbin13@huawei.com>, <gaochao49@huawei.com>
Subject: [PATCH v2 -next] net: hinic: add missing destroy_workqueue in hinic_pf_to_mgmt_init
Date:   Fri, 13 May 2022 15:09:22 +0800
Message-ID: <20220513070922.3278070-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

hinic_pf_to_mgmt_init misses destroy_workqueue in error path,
this patch fixes that.

Fixes: 6dbb89014dc3 ("hinic: fix sending mailbox timeout in aeq event work")
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
v1->v2: add Fixes tag
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index ebc77771f5da..4aa1f433ed24 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -643,6 +643,7 @@ int hinic_pf_to_mgmt_init(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	err = alloc_msg_buf(pf_to_mgmt);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to allocate msg buffers\n");
+		destroy_workqueue(pf_to_mgmt->workq);
 		hinic_health_reporters_destroy(hwdev->devlink_dev);
 		return err;
 	}
@@ -650,6 +651,7 @@ int hinic_pf_to_mgmt_init(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	err = hinic_api_cmd_init(pf_to_mgmt->cmd_chain, hwif);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to initialize cmd chains\n");
+		destroy_workqueue(pf_to_mgmt->workq);
 		hinic_health_reporters_destroy(hwdev->devlink_dev);
 		return err;
 	}
--
2.31.1

