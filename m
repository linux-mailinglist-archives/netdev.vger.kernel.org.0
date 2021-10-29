Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED33440457
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhJ2UuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:50:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:9544 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231409AbhJ2Utu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:49:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="291587520"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="291587520"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 13:47:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="448483307"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 29 Oct 2021 13:47:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 7/7] iavf: Fix kernel BUG in free_msi_irqs
Date:   Fri, 29 Oct 2021 13:45:40 -0700
Message-Id: <20211029204540.3390007-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
References: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Fix driver not freeing VF's traffic irqs, prior to calling
pci_disable_msix in iavf_remove.
There were possible 2 erroneous states in which, iavf_close would
not be called.
One erroneous state is fixed by allowing netdev to register, when state
is already running. It was possible for VF adapter to enter state loop
from running to resetting, where iavf_open would subsequently fail.
If user would then unload driver/remove VF pci, iavf_close would not be
called, as the netdev was not registered, leaving traffic pcis still
allocated.
Fixed this by breaking loop, allowing netdev to open device when adapter
state is __IAVF_RUNNING and it is not explicitily downed.
Other possiblity is entering to iavf_remove from __IAVF_RESETTING state,
where iavf_close would not free irqs, but just return 0.
Fixed this by checking for last adapter state and then removing irqs.

Kernel panic:
[ 2773.628585] kernel BUG at drivers/pci/msi.c:375!
...
[ 2773.631567] RIP: 0010:free_msi_irqs+0x180/0x1b0
...
[ 2773.640939] Call Trace:
[ 2773.641572]  pci_disable_msix+0xf7/0x120
[ 2773.642224]  iavf_reset_interrupt_capability.part.41+0x15/0x30 [iavf]
[ 2773.642897]  iavf_remove+0x12e/0x500 [iavf]
[ 2773.643578]  pci_device_remove+0x3b/0xc0
[ 2773.644266]  device_release_driver_internal+0x103/0x1f0
[ 2773.644948]  pci_stop_bus_device+0x69/0x90
[ 2773.645576]  pci_stop_and_remove_bus_device+0xe/0x20
[ 2773.646215]  pci_iov_remove_virtfn+0xba/0x120
[ 2773.646862]  sriov_disable+0x2f/0xe0
[ 2773.647531]  ice_free_vfs+0x2f8/0x350 [ice]
[ 2773.648207]  ice_sriov_configure+0x94/0x960 [ice]
[ 2773.648883]  ? _kstrtoull+0x3b/0x90
[ 2773.649560]  sriov_numvfs_store+0x10a/0x190
[ 2773.650249]  kernfs_fop_write+0x116/0x190
[ 2773.650948]  vfs_write+0xa5/0x1a0
[ 2773.651651]  ksys_write+0x4f/0xb0
[ 2773.652358]  do_syscall_64+0x5b/0x1a0
[ 2773.653075]  entry_SYSCALL_64_after_hwframe+0x65/0xca

Fixes: 22ead37f8af8 ("i40evf: Add longer wait after remove module")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
This is for net-next as it relies on changes not on net.

 drivers/net/ethernet/intel/iavf/iavf.h      | 36 +++++++++++++++++++++
 drivers/net/ethernet/intel/iavf/iavf_main.c | 20 ++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index e0b88ff76466..e6e7c1da47fb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -394,6 +394,38 @@ struct iavf_device {
 extern char iavf_driver_name[];
 extern struct workqueue_struct *iavf_wq;
 
+static inline const char *iavf_state_str(enum iavf_state_t state)
+{
+	switch (state) {
+	case __IAVF_STARTUP:
+		return "__IAVF_STARTUP";
+	case __IAVF_REMOVE:
+		return "__IAVF_REMOVE";
+	case __IAVF_INIT_VERSION_CHECK:
+		return "__IAVF_INIT_VERSION_CHECK";
+	case __IAVF_INIT_GET_RESOURCES:
+		return "__IAVF_INIT_GET_RESOURCES";
+	case __IAVF_INIT_SW:
+		return "__IAVF_INIT_SW";
+	case __IAVF_INIT_FAILED:
+		return "__IAVF_INIT_FAILED";
+	case __IAVF_RESETTING:
+		return "__IAVF_RESETTING";
+	case __IAVF_COMM_FAILED:
+		return "__IAVF_COMM_FAILED";
+	case __IAVF_DOWN:
+		return "__IAVF_DOWN";
+	case __IAVF_DOWN_PENDING:
+		return "__IAVF_DOWN_PENDING";
+	case __IAVF_TESTING:
+		return "__IAVF_TESTING";
+	case __IAVF_RUNNING:
+		return "__IAVF_RUNNING";
+	default:
+		return "__IAVF_UNKNOWN_STATE";
+	}
+}
+
 static inline void iavf_change_state(struct iavf_adapter *adapter,
 				     enum iavf_state_t state)
 {
@@ -401,6 +433,10 @@ static inline void iavf_change_state(struct iavf_adapter *adapter,
 		adapter->last_state = adapter->state;
 		adapter->state = state;
 	}
+	dev_dbg(&adapter->pdev->dev,
+		"state transition from:%s to:%s\n",
+		iavf_state_str(adapter->last_state),
+		iavf_state_str(adapter->state));
 }
 
 int iavf_up(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 469160346438..847d67e32a54 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3280,6 +3280,13 @@ static int iavf_open(struct net_device *netdev)
 		goto err_unlock;
 	}
 
+	if (adapter->state == __IAVF_RUNNING &&
+	    !test_bit(__IAVF_VSI_DOWN, adapter->vsi.state)) {
+		dev_dbg(&adapter->pdev->dev, "VF is already open.\n");
+		err = 0;
+		goto err_unlock;
+	}
+
 	/* allocate transmit descriptors */
 	err = iavf_setup_all_tx_resources(adapter);
 	if (err)
@@ -3915,6 +3922,7 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 static void iavf_remove(struct pci_dev *pdev)
 {
 	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
+	enum iavf_state_t prev_state = adapter->last_state;
 	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
@@ -3953,10 +3961,22 @@ static void iavf_remove(struct pci_dev *pdev)
 	iavf_change_state(adapter, __IAVF_REMOVE);
 	adapter->aq_required = 0;
 	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
+
 	iavf_free_all_tx_resources(adapter);
 	iavf_free_all_rx_resources(adapter);
 	iavf_misc_irq_disable(adapter);
 	iavf_free_misc_irq(adapter);
+
+	/* In case we enter iavf_remove from erroneous state, free traffic irqs
+	 * here, so as to not cause a kernel crash, when calling
+	 * iavf_reset_interrupt_capability.
+	 */
+	if ((adapter->last_state == __IAVF_RESETTING &&
+	     prev_state != __IAVF_DOWN) ||
+	    (adapter->last_state == __IAVF_RUNNING &&
+	     !(netdev->flags & IFF_UP)))
+		iavf_free_traffic_irqs(adapter);
+
 	iavf_reset_interrupt_capability(adapter);
 	iavf_free_q_vectors(adapter);
 
-- 
2.31.1

