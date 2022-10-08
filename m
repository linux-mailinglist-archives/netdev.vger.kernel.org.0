Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFF55F8433
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 10:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiJHIKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 04:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiJHIKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 04:10:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD414D277
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 01:10:27 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MkyRc1twbzVhvJ;
        Sat,  8 Oct 2022 16:06:04 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 8 Oct 2022 16:10:24 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 8 Oct
 2022 16:10:24 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <sbhatta@marvell.com>, <sgoutham@marvell.com>,
        <davem@davemloft.net>
Subject: [PATCH net] octeontx2-pf: mcs: fix missing unlock in some error paths
Date:   Sat, 8 Oct 2022 16:26:50 +0800
Message-ID: <20221008082650.3074606-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing unlock in some error paths.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 64f3acd7f67b..097cb8664a62 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -284,7 +284,7 @@ static int cn10k_mcs_write_sc_cam(struct otx2_nic *pfvf,
 
 	sc_req = otx2_mbox_alloc_msg_mcs_rx_sc_cam_write(mbox);
 	if (!sc_req) {
-		return -ENOMEM;
+		ret = -ENOMEM;
 		goto fail;
 	}
 
@@ -594,7 +594,7 @@ static int cn10k_mcs_ena_dis_flowid(struct otx2_nic *pfvf, u16 hw_flow_id,
 
 	req = otx2_mbox_alloc_msg_mcs_flowid_ena_entry(mbox);
 	if (!req) {
-		return -ENOMEM;
+		ret = -ENOMEM;
 		goto fail;
 	}
 
@@ -1653,6 +1653,7 @@ int cn10k_mcs_init(struct otx2_nic *pfvf)
 	return 0;
 fail:
 	dev_err(pfvf->dev, "Cannot notify PN wrapped event\n");
+	mutex_unlock(&mbox->lock);
 	return 0;
 }
 
-- 
2.25.1

