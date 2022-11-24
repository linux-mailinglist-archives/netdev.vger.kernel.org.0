Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E86263701C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 02:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKXB5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 20:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiKXB5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 20:57:03 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F00E0743;
        Wed, 23 Nov 2022 17:57:02 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NHh1M6rGhzHw5L;
        Thu, 24 Nov 2022 09:56:23 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 09:57:00 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <naveenm@marvell.com>, <rsaladi2@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 2/2] octeontx2-vf: Fix possible memory leak in otx2vf_probe()
Date:   Thu, 24 Nov 2022 09:56:56 +0800
Message-ID: <3828ba413173643c0e04d33f09754eec03c43cfc.1669253985.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1669253985.git.william.xuanziyang@huawei.com>
References: <cover.1669253985.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In otx2vf_probe(), there are several possible memory leak bugs
in exception paths as follows:
1. Do not release vf->otx2_wq when excute otx2vf_mcam_flow_init() and
   otx2_init_tc() failed.
2. Do not unregister devlink when excute otx2_dcbnl_set_ops() failed.

Fixes: 4b0385bc8e6a ("octeontx2-pf: Add TC feature for VFs")
Fixes: 8e67558177f8 ("octeontx2-pf: PFC config support with DCBx")
Fixes: 3cffaed2136c ("octeontx2-pf: Ntuple filters support for VF netdev")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 86653bb8e403..f1b47fecd379 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -684,11 +684,11 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = otx2vf_mcam_flow_init(vf);
 	if (err)
-		goto err_unreg_netdev;
+		goto err_destroy_wq;
 
 	err = otx2_init_tc(vf);
 	if (err)
-		goto err_unreg_netdev;
+		goto err_destroy_wq;
 
 	err = otx2_register_dl(vf);
 	if (err)
@@ -697,13 +697,19 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 #ifdef CONFIG_DCB
 	err = otx2_dcbnl_set_ops(netdev);
 	if (err)
-		goto err_shutdown_tc;
+		goto err_unreg_dl;
 #endif
 
 	return 0;
 
+#ifdef CONFIG_DCB
+err_unreg_dl:
+	otx2_unregister_dl(vf);
+#endif
 err_shutdown_tc:
 	otx2_shutdown_tc(vf);
+err_destroy_wq:
+	destroy_workqueue(vf->otx2_wq);
 err_unreg_netdev:
 	unregister_netdev(netdev);
 err_ptp_destroy:
-- 
2.25.1

