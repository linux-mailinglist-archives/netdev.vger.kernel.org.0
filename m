Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C325BFDEE
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiIUMct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiIUMcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:32:32 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820D685A8E;
        Wed, 21 Sep 2022 05:32:31 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXd461kTxzlWjr;
        Wed, 21 Sep 2022 20:28:22 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 20:32:29 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH -next, v3 07/10] net: hinic: change hinic_deinit_vf_hw() to void
Date:   Wed, 21 Sep 2022 20:33:55 +0800
Message-ID: <20220921123358.63442-8-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220921123358.63442-1-shaozhengchao@huawei.com>
References: <20220921123358.63442-1-shaozhengchao@huawei.com>
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

When hinic_pci_sriov_disable() calls hinic_deinit_vf_hw(), it doesn't
care about the return value of hinic_deinit_vf_hw(). Also
hinic_deinit_vf_hw() is return 0, so change it to void.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index 00a66e6e3060..d54ccef467e7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -1131,8 +1131,8 @@ static void hinic_clear_vf_infos(struct hinic_dev *nic_dev, u16 vf_id)
 	hinic_init_vf_infos(&nic_dev->hwdev->func_to_io, HW_VF_ID_TO_OS(vf_id));
 }
 
-static int hinic_deinit_vf_hw(struct hinic_sriov_info *sriov_info,
-			      u16 start_vf_id, u16 end_vf_id)
+static void hinic_deinit_vf_hw(struct hinic_sriov_info *sriov_info,
+			       u16 start_vf_id, u16 end_vf_id)
 {
 	struct hinic_dev *nic_dev;
 	u16 func_idx, idx;
@@ -1145,8 +1145,6 @@ static int hinic_deinit_vf_hw(struct hinic_sriov_info *sriov_info,
 				       HINIC_HW_WQ_PAGE_SIZE);
 		hinic_clear_vf_infos(nic_dev, idx);
 	}
-
-	return 0;
 }
 
 int hinic_vf_func_init(struct hinic_hwdev *hwdev)
-- 
2.17.1

