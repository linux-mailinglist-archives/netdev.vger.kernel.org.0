Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B24063701A
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 02:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiKXB4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 20:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiKXB4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 20:56:50 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405AF74AB5;
        Wed, 23 Nov 2022 17:56:49 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NHh161wlRzHw47;
        Thu, 24 Nov 2022 09:56:10 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 09:56:46 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <naveenm@marvell.com>, <rsaladi2@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 1/2] octeontx2-pf: Fix possible memory leak in otx2_probe()
Date:   Thu, 24 Nov 2022 09:56:43 +0800
Message-ID: <e024450cf08f469fb1e0153b78a04a54829dfddb.1669253985.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1669253985.git.william.xuanziyang@huawei.com>
References: <cover.1669253985.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In otx2_probe(), there are several possible memory leak bugs
in exception paths as follows:
1. Do not release pf->otx2_wq when excute otx2_init_tc() failed.
2. Do not shutdown tc when excute otx2_register_dl() failed.
3. Do not unregister devlink when initialize SR-IOV failed.

Fixes: 1d4d9e42c240 ("octeontx2-pf: Add tc flower hardware offload on ingress traffic")
Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 303930499a4c..8d7f2c3b0cfd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2900,7 +2900,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = otx2_register_dl(pf);
 	if (err)
-		goto err_mcam_flow_del;
+		goto err_register_dl;
 
 	/* Initialize SR-IOV resources */
 	err = otx2_sriov_vfcfg_init(pf);
@@ -2919,8 +2919,11 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_pf_sriov_init:
+	otx2_unregister_dl(pf);
+err_register_dl:
 	otx2_shutdown_tc(pf);
 err_mcam_flow_del:
+	destroy_workqueue(pf->otx2_wq);
 	otx2_mcam_flow_del(pf);
 err_unreg_netdev:
 	unregister_netdev(netdev);
-- 
2.25.1

