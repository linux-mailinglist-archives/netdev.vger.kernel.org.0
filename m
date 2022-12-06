Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FE26444CE
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiLFNoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiLFNoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:44:15 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1A629822
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:44:13 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NRM3j75HZzqSXw;
        Tue,  6 Dec 2022 21:40:01 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 6 Dec
 2022 21:44:10 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <alice.michael@intel.com>,
        <piotr.marczak@intel.com>, <jeffrey.t.kirsher@intel.com>,
        <leon@kernel.org>, <jiri@resnulli.us>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH net v3] intel/i40e: Fix potential memory leak in i40e_init_recovery_mode()
Date:   Tue, 6 Dec 2022 13:41:46 +0000
Message-ID: <20221206134146.36465-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error handling path of i40e_init_recovery_mode() does not handle the
vsi->netdev and pf->vsi, and resource leak can happen if error occurs.

In the meantime, the i40e_probe() returns directly without release
pf->qp_pile when i40e_init_recovery_mode() failed.

Fix by properly releasing vsi->netdev in the error handling path of
i40e_init_recovery_mode() and relying on the error handling path of
i40e_probe() to release pf->vsi and pf->qp_pile if anything goes wrong.

Fixes: 4ff0ee1af016 ("i40e: Introduce recovery mode support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
Changes in v3:
- Introduce more error handling path to handle vsi->netdev
- Rely on error path of i40e_probe() instead of do all cleanup in
  i40e_init_recovery_mode() to make sure pf->qp_pile is not leaked

Changes in v2:
- Add net in patch title
- Add Leon Romanovsky's reviewed by

 drivers/net/ethernet/intel/i40e/i40e_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b5dcd15ced36..d1aadd298ea7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15511,13 +15511,13 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
 		goto err_switch_setup;
 	err = register_netdev(vsi->netdev);
 	if (err)
-		goto err_switch_setup;
+		goto free_netdev;
 	vsi->netdev_registered = true;
 	i40e_dbg_pf_init(pf);
 
 	err = i40e_setup_misc_vector_for_recovery_mode(pf);
 	if (err)
-		goto err_switch_setup;
+		goto unreg_netdev;
 
 	/* tell the firmware that we're starting */
 	i40e_send_version(pf);
@@ -15528,15 +15528,15 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
 
 	return 0;
 
+unreg_netdev:
+	unregister_netdev(vsi->netdev);
+free_netdev:
+	free_netdev(vsi->netdev);
 err_switch_setup:
 	i40e_reset_interrupt_capability(pf);
 	del_timer_sync(&pf->service_timer);
 	i40e_shutdown_adminq(hw);
-	iounmap(hw->hw_addr);
-	pci_disable_pcie_error_reporting(pf->pdev);
-	pci_release_mem_regions(pf->pdev);
-	pci_disable_device(pf->pdev);
-	kfree(pf);
+	kfree(pf->vsi);
 
 	return err;
 }
@@ -15789,8 +15789,11 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_sw_init;
 	}
 
-	if (test_bit(__I40E_RECOVERY_MODE, pf->state))
-		return i40e_init_recovery_mode(pf, hw);
+	if (test_bit(__I40E_RECOVERY_MODE, pf->state)) {
+		err = i40e_init_recovery_mode(pf, hw);
+		if (err)
+			goto err_init_lan_hmc;
+	}
 
 	err = i40e_init_lan_hmc(hw, hw->func_caps.num_tx_qp,
 				hw->func_caps.num_rx_qp, 0, 0);
-- 
2.17.1

