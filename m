Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4F16BD72B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjCPRdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCPRdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:33:40 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126CF65120
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 10:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678988018; x=1710524018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NtYYhaI+Og5h86Cxj4rGJ0pn0jpBIsoLx30YDGOcZ3Y=;
  b=klwTW+RF2ihzQwPRd7VEuYhjdsL5e1W5QOSwZ2YxkpvJEQtDs/E6V5Lg
   Bp0uwI3DNBAt00JaAfh7wo/0zXssBYe7uXxtdODuhX+VmiKVKPe/VJPPk
   I9iXtkP7rV2cbHtYxOEuE+ECUdab+fYSF13tNSOF7x8F7GnA+EOzg3sE0
   H5fRjfAdkybsddcAVBbv6PZmChiivsLE15fsJrJEtIZ7ZoLxgvPqCDqLY
   T+ybrcuft7/JEYfs1zCEGrkeKwmZgB+cItA+2CRebRTAEU5ihsG7c8ENM
   RnyivS735L6ByzAEal63G5cTnifj49sZ90Zz8OPex3hW8gEpE4aev6Bic
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="402948292"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="402948292"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 10:33:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="679982476"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679982476"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 10:33:20 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Akihiko Odaki <akihiko.odaki@daynix.com>,
        anthony.l.nguyen@intel.com, Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net 2/5] igb: Enable SR-IOV after reinit
Date:   Thu, 16 Mar 2023 10:31:41 -0700
Message-Id: <20230316173144.2003469-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230316173144.2003469-1-anthony.l.nguyen@intel.com>
References: <20230316173144.2003469-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akihiko Odaki <akihiko.odaki@daynix.com>

Enabling SR-IOV causes the virtual functions to make requests to the
PF via the mailbox. Notably, E1000_VF_RESET request will happen during
the initialization of the VF. However, unless the reinit is done, the
VMMB interrupt, which delivers mailbox interrupt from VF to PF will be
kept masked and such requests will be silently ignored.

Enable SR-IOV at the very end of the procedure to configure the device
for SR-IOV so that the PF is configured properly for SR-IOV when a VF is
activated.

Fixes: fa44f2f185f7 ("igb: Enable SR-IOV configuration via PCI sysfs interface")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 135 ++++++++++------------
 1 file changed, 58 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5532361b0e94..274c781b5547 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -109,6 +109,7 @@ static void igb_free_all_rx_resources(struct igb_adapter *);
 static void igb_setup_mrqc(struct igb_adapter *);
 static int igb_probe(struct pci_dev *, const struct pci_device_id *);
 static void igb_remove(struct pci_dev *pdev);
+static void igb_init_queue_configuration(struct igb_adapter *adapter);
 static int igb_sw_init(struct igb_adapter *);
 int igb_open(struct net_device *);
 int igb_close(struct net_device *);
@@ -175,9 +176,7 @@ static void igb_nfc_filter_restore(struct igb_adapter *adapter);
 
 #ifdef CONFIG_PCI_IOV
 static int igb_vf_configure(struct igb_adapter *adapter, int vf);
-static int igb_pci_enable_sriov(struct pci_dev *dev, int num_vfs);
-static int igb_disable_sriov(struct pci_dev *dev);
-static int igb_pci_disable_sriov(struct pci_dev *dev);
+static int igb_disable_sriov(struct pci_dev *dev, bool reinit);
 #endif
 
 static int igb_suspend(struct device *);
@@ -3665,7 +3664,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	kfree(adapter->shadow_vfta);
 	igb_clear_interrupt_scheme(adapter);
 #ifdef CONFIG_PCI_IOV
-	igb_disable_sriov(pdev);
+	igb_disable_sriov(pdev, false);
 #endif
 	pci_iounmap(pdev, adapter->io_addr);
 err_ioremap:
@@ -3679,7 +3678,38 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 }
 
 #ifdef CONFIG_PCI_IOV
-static int igb_disable_sriov(struct pci_dev *pdev)
+static int igb_sriov_reinit(struct pci_dev *dev)
+{
+	struct net_device *netdev = pci_get_drvdata(dev);
+	struct igb_adapter *adapter = netdev_priv(netdev);
+	struct pci_dev *pdev = adapter->pdev;
+
+	rtnl_lock();
+
+	if (netif_running(netdev))
+		igb_close(netdev);
+	else
+		igb_reset(adapter);
+
+	igb_clear_interrupt_scheme(adapter);
+
+	igb_init_queue_configuration(adapter);
+
+	if (igb_init_interrupt_scheme(adapter, true)) {
+		rtnl_unlock();
+		dev_err(&pdev->dev, "Unable to allocate memory for queues\n");
+		return -ENOMEM;
+	}
+
+	if (netif_running(netdev))
+		igb_open(netdev);
+
+	rtnl_unlock();
+
+	return 0;
+}
+
+static int igb_disable_sriov(struct pci_dev *pdev, bool reinit)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
@@ -3713,10 +3743,10 @@ static int igb_disable_sriov(struct pci_dev *pdev)
 		adapter->flags |= IGB_FLAG_DMAC;
 	}
 
-	return 0;
+	return reinit ? igb_sriov_reinit(pdev) : 0;
 }
 
-static int igb_enable_sriov(struct pci_dev *pdev, int num_vfs)
+static int igb_enable_sriov(struct pci_dev *pdev, int num_vfs, bool reinit)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
@@ -3781,12 +3811,6 @@ static int igb_enable_sriov(struct pci_dev *pdev, int num_vfs)
 			"Unable to allocate memory for VF MAC filter list\n");
 	}
 
-	/* only call pci_enable_sriov() if no VFs are allocated already */
-	if (!old_vfs) {
-		err = pci_enable_sriov(pdev, adapter->vfs_allocated_count);
-		if (err)
-			goto err_out;
-	}
 	dev_info(&pdev->dev, "%d VFs allocated\n",
 		 adapter->vfs_allocated_count);
 	for (i = 0; i < adapter->vfs_allocated_count; i++)
@@ -3794,6 +3818,17 @@ static int igb_enable_sriov(struct pci_dev *pdev, int num_vfs)
 
 	/* DMA Coalescing is not supported in IOV mode. */
 	adapter->flags &= ~IGB_FLAG_DMAC;
+
+	if (reinit) {
+		err = igb_sriov_reinit(pdev);
+		if (err)
+			goto err_out;
+	}
+
+	/* only call pci_enable_sriov() if no VFs are allocated already */
+	if (!old_vfs)
+		err = pci_enable_sriov(pdev, adapter->vfs_allocated_count);
+
 	goto out;
 
 err_out:
@@ -3863,7 +3898,7 @@ static void igb_remove(struct pci_dev *pdev)
 	igb_release_hw_control(adapter);
 
 #ifdef CONFIG_PCI_IOV
-	igb_disable_sriov(pdev);
+	igb_disable_sriov(pdev, false);
 #endif
 
 	unregister_netdev(netdev);
@@ -3909,7 +3944,7 @@ static void igb_probe_vfs(struct igb_adapter *adapter)
 	igb_reset_interrupt_capability(adapter);
 
 	pci_sriov_set_totalvfs(pdev, 7);
-	igb_enable_sriov(pdev, max_vfs);
+	igb_enable_sriov(pdev, max_vfs, false);
 
 #endif /* CONFIG_PCI_IOV */
 }
@@ -9518,71 +9553,17 @@ static void igb_shutdown(struct pci_dev *pdev)
 	}
 }
 
-#ifdef CONFIG_PCI_IOV
-static int igb_sriov_reinit(struct pci_dev *dev)
-{
-	struct net_device *netdev = pci_get_drvdata(dev);
-	struct igb_adapter *adapter = netdev_priv(netdev);
-	struct pci_dev *pdev = adapter->pdev;
-
-	rtnl_lock();
-
-	if (netif_running(netdev))
-		igb_close(netdev);
-	else
-		igb_reset(adapter);
-
-	igb_clear_interrupt_scheme(adapter);
-
-	igb_init_queue_configuration(adapter);
-
-	if (igb_init_interrupt_scheme(adapter, true)) {
-		rtnl_unlock();
-		dev_err(&pdev->dev, "Unable to allocate memory for queues\n");
-		return -ENOMEM;
-	}
-
-	if (netif_running(netdev))
-		igb_open(netdev);
-
-	rtnl_unlock();
-
-	return 0;
-}
-
-static int igb_pci_disable_sriov(struct pci_dev *dev)
-{
-	int err = igb_disable_sriov(dev);
-
-	if (!err)
-		err = igb_sriov_reinit(dev);
-
-	return err;
-}
-
-static int igb_pci_enable_sriov(struct pci_dev *dev, int num_vfs)
-{
-	int err = igb_enable_sriov(dev, num_vfs);
-
-	if (err)
-		goto out;
-
-	err = igb_sriov_reinit(dev);
-	if (!err)
-		return num_vfs;
-
-out:
-	return err;
-}
-
-#endif
 static int igb_pci_sriov_configure(struct pci_dev *dev, int num_vfs)
 {
 #ifdef CONFIG_PCI_IOV
-	if (num_vfs == 0)
-		return igb_pci_disable_sriov(dev);
-	else
-		return igb_pci_enable_sriov(dev, num_vfs);
+	int err;
+
+	if (num_vfs == 0) {
+		return igb_disable_sriov(dev, true);
+	} else {
+		err = igb_enable_sriov(dev, num_vfs, true);
+		return err ? err : num_vfs;
+	}
 #endif
 	return 0;
 }
-- 
2.38.1

