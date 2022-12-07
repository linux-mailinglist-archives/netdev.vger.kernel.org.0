Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60F76455DC
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLGI5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiLGI5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:57:42 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD1710FF4
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 00:57:31 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NRrgB4PWfzJp8c;
        Wed,  7 Dec 2022 16:53:58 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 7 Dec
 2022 16:56:36 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <shshaikh@marvell.com>, <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <rajesh.borundia@qlogic.com>, <sucheta.chakraborty@qlogic.com>,
        <leon@kernel.org>, <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH net v2] drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
Date:   Wed, 7 Dec 2022 08:54:10 +0000
Message-ID: <20221207085410.123938-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
Changes in v2:
- free all vp before destroy_workqueue(bc->bc_trans_wq)

 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 9282321c2e7f..f9dd50152b1e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -221,6 +221,8 @@ int qlcnic_sriov_init(struct qlcnic_adapter *adapter, int num_vfs)
 	return 0;
 
 qlcnic_destroy_async_wq:
+	while (i--)
+		kfree(sriov->vf_info[i].vp);
 	destroy_workqueue(bc->bc_async_wq);
 
 qlcnic_destroy_trans_wq:
-- 
2.17.1

