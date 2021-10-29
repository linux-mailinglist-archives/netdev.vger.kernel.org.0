Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276BA440458
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhJ2UuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:50:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:9541 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231401AbhJ2Utu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:49:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="291587519"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="291587519"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 13:47:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="448483305"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 29 Oct 2021 13:47:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Brett Creeley <brett.creeley@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 6/7] iavf: Add helper function to go from pci_dev to adapter
Date:   Fri, 29 Oct 2021 13:45:39 -0700
Message-Id: <20211029204540.3390007-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
References: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

Add helper function to go from pci_dev to adapter to make work simple -
to go from a pci_dev to the adapter structure and make netdev assignment
instead of having to go to the net_device then the adapter.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 24 +++++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 56956e449c97..469160346438 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -51,6 +51,15 @@ MODULE_LICENSE("GPL v2");
 static const struct net_device_ops iavf_netdev_ops;
 struct workqueue_struct *iavf_wq;
 
+/**
+ * iavf_pdev_to_adapter - go from pci_dev to adapter
+ * @pdev: pci_dev pointer
+ */
+static struct iavf_adapter *iavf_pdev_to_adapter(struct pci_dev *pdev)
+{
+	return netdev_priv(pci_get_drvdata(pdev));
+}
+
 /**
  * iavf_allocate_dma_mem_d - OS specific memory alloc for shared code
  * @hw:   pointer to the HW structure
@@ -3681,8 +3690,8 @@ int iavf_process_config(struct iavf_adapter *adapter)
  **/
 static void iavf_shutdown(struct pci_dev *pdev)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
+	struct net_device *netdev = adapter->netdev;
 
 	netif_device_detach(netdev);
 
@@ -3866,10 +3875,11 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 static int __maybe_unused iavf_resume(struct device *dev_d)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_d);
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_adapter *adapter;
 	u32 err;
 
+	adapter = iavf_pdev_to_adapter(pdev);
+
 	pci_set_master(pdev);
 
 	rtnl_lock();
@@ -3888,7 +3898,7 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 
 	queue_work(iavf_wq, &adapter->reset_task);
 
-	netif_device_attach(netdev);
+	netif_device_attach(adapter->netdev);
 
 	return err;
 }
@@ -3904,8 +3914,8 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
  **/
 static void iavf_remove(struct pci_dev *pdev)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
+	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
 	struct iavf_adv_rss *rss, *rsstmp;
-- 
2.31.1

