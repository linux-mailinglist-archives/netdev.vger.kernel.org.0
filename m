Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F752644150
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiLFKdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiLFKc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:32:59 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD6863AA
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:32:58 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NRGtv6F8MzmWJy;
        Tue,  6 Dec 2022 18:32:07 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 6 Dec
 2022 18:32:55 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <shshaikh@marvell.com>, <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <sucheta.chakraborty@qlogic.com>, <rajesh.borundia@qlogic.com>,
        <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH net] drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
Date:   Tue, 6 Dec 2022 10:30:31 +0000
Message-ID: <20221206103031.20609-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If vp alloc failed in qlcnic_sriov_init(), all previously allocated vp
needs to be freed.

Fixes: f197a7aa6288 ("qlcnic: VF-PF communication channel implementation")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 9282321c2e7f..d0470c62e1b2 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -222,6 +222,8 @@ int qlcnic_sriov_init(struct qlcnic_adapter *adapter, int num_vfs)
 
 qlcnic_destroy_async_wq:
 	destroy_workqueue(bc->bc_async_wq);
+	while (i--)
+		kfree(sriov->vf_info[i].vp);
 
 qlcnic_destroy_trans_wq:
 	destroy_workqueue(bc->bc_trans_wq);
-- 
2.17.1

