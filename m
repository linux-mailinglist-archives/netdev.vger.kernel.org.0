Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E6A3B3559
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhFXSOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:14:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:28688 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232515AbhFXSOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:14:10 -0400
IronPort-SDR: 8XwvMGcKmwJ/XqxbZRyp6wJew+G53uI+BTrE3guLuKMR7yMbww4/WVuZ3kh1omQ7td16ISIiCI
 yx5a3lc6JAHg==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="271382699"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="271382699"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 11:11:48 -0700
IronPort-SDR: 20pLUcfojx2uBiTnTUjQDOOg2rDEHkoIwPyTz09WD3mb1eVn1ueYBvfsmATzkVaPmVCOs3UaNW
 k1TftmoK8Hsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="487866632"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 24 Jun 2021 11:11:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jan Sokolowski <jan.sokolowski@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 4/4] i40e: Fix missing rtnl locking when setting up pf switch
Date:   Thu, 24 Jun 2021 11:14:34 -0700
Message-Id: <20210624181434.751511-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210624181434.751511-1-anthony.l.nguyen@intel.com>
References: <20210624181434.751511-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski@intel.com>

A recent change that made i40e use new udp_tunnel infrastructure
uses a method that expects to be called under rtnl lock.

However, not all codepaths do the lock prior to calling
i40e_setup_pf_switch.

Fix that by adding additional rtnl locking and unlocking.

Fixes: 40a98cb6f01f ("i40e: convert to new udp_tunnel infrastructure")
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 526fa0a791ea..f9fe500d4ec4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -32,7 +32,7 @@ static void i40e_vsi_reinit_locked(struct i40e_vsi *vsi);
 static void i40e_handle_reset_warning(struct i40e_pf *pf, bool lock_acquired);
 static int i40e_add_vsi(struct i40e_vsi *vsi);
 static int i40e_add_veb(struct i40e_veb *veb, struct i40e_vsi *vsi);
-static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit);
+static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit, bool lock_acquired);
 static int i40e_setup_misc_vector(struct i40e_pf *pf);
 static void i40e_determine_queue_usage(struct i40e_pf *pf);
 static int i40e_setup_pf_filter_control(struct i40e_pf *pf);
@@ -10571,7 +10571,7 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 #endif /* CONFIG_I40E_DCB */
 	if (!lock_acquired)
 		rtnl_lock();
-	ret = i40e_setup_pf_switch(pf, reinit);
+	ret = i40e_setup_pf_switch(pf, reinit, true);
 	if (ret)
 		goto end_unlock;
 
@@ -14629,10 +14629,11 @@ int i40e_fetch_switch_configuration(struct i40e_pf *pf, bool printconfig)
  * i40e_setup_pf_switch - Setup the HW switch on startup or after reset
  * @pf: board private structure
  * @reinit: if the Main VSI needs to re-initialized.
+ * @lock_acquired: indicates whether or not the lock has been acquired
  *
  * Returns 0 on success, negative value on failure
  **/
-static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit)
+static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 {
 	u16 flags = 0;
 	int ret;
@@ -14734,9 +14735,15 @@ static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit)
 
 	i40e_ptp_init(pf);
 
+	if (!lock_acquired)
+		rtnl_lock();
+
 	/* repopulate tunnel port filters */
 	udp_tunnel_nic_reset_ntf(pf->vsi[pf->lan_vsi]->netdev);
 
+	if (!lock_acquired)
+		rtnl_unlock();
+
 	return ret;
 }
 
@@ -15530,7 +15537,7 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
 	}
 #endif
-	err = i40e_setup_pf_switch(pf, false);
+	err = i40e_setup_pf_switch(pf, false, false);
 	if (err) {
 		dev_info(&pdev->dev, "setup_pf_switch failed: %d\n", err);
 		goto err_vsis;
-- 
2.26.2

