Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E964C4F14
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbiBYTqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbiBYTqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:46:46 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A4E210469
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645818374; x=1677354374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hUCJ5UVjKvfRNAjGbeOXPrjeZ5Si8waiX2Lit3XMemA=;
  b=mtBf0a7xrfz+ZMaF1IUWONC0VxdwmFD+Awar1YLbG9VLK263PlaR+GVB
   MaSy/40krx/hUfaTZqBvANk/J/tHJ8fcC3KjLcM7MkNqvOigrdTD2KcC5
   FkhIB79KiRqBBkx9SUY5lJyEp2pTVkYvDMF8B27yjaJ2gdivI3AQOHC/v
   AFBmyRszGQj/5HnTt9rLp37kwFuwIDe+RZGisu5WHjhdxkP2Z0EDvlWPn
   svM8ULUnN4S9uPAscV9mzTzNxvd9hk4EvP4TohG+sfJ2IqCS9dOjiOLy4
   KnVwE5g/UfTjKoLs4aQLt+w1dQ7RqXknHQ+F2nSLJ3jnOmf0DzRveYbcD
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="339004855"
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="339004855"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 11:46:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="707972170"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 25 Feb 2022 11:46:10 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Slawomir Laba <slawomirx.laba@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/8] iavf: Rework mutexes for better synchronisation
Date:   Fri, 25 Feb 2022 11:46:07 -0800
Message-Id: <20220225194614.136571-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
References: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

The driver used to crash in multiple spots when put to stress testing
of the init, reset and remove paths.

The user would experience call traces or hangs when creating,
resetting, removing VFs. Depending on the machines, the call traces
are happening in random spots, like reset restoring resources racing
with driver remove.

Make adapter->crit_lock mutex a mandatory lock for guarding the
operations performed on all workqueues and functions dealing with
resource allocation and disposal.

Make __IAVF_REMOVE a final state of the driver respected by
workqueues that shall not requeue, when they fail to obtain the
crit_lock.

Make the IRQ handler not to queue the new work for adminq_task
when the __IAVF_REMOVE state is set.

Fixes: 5ac49f3c2702 ("iavf: use mutexes for locking of critical sections")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c | 66 +++++++++++----------
 2 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 59806d1f7e79..44f83e06486d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -246,7 +246,6 @@ struct iavf_adapter {
 	struct list_head mac_filter_list;
 	struct mutex crit_lock;
 	struct mutex client_lock;
-	struct mutex remove_lock;
 	/* Lock to protect accesses to MAC and VLAN lists */
 	spinlock_t mac_vlan_list_lock;
 	char misc_vector_name[IFNAMSIZ + 9];
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 8125b9120615..84ae96e912d7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -302,8 +302,9 @@ static irqreturn_t iavf_msix_aq(int irq, void *data)
 	rd32(hw, IAVF_VFINT_ICR01);
 	rd32(hw, IAVF_VFINT_ICR0_ENA1);
 
-	/* schedule work on the private workqueue */
-	queue_work(iavf_wq, &adapter->adminq_task);
+	if (adapter->state != __IAVF_REMOVE)
+		/* schedule work on the private workqueue */
+		queue_work(iavf_wq, &adapter->adminq_task);
 
 	return IRQ_HANDLED;
 }
@@ -2374,8 +2375,12 @@ static void iavf_watchdog_task(struct work_struct *work)
 	struct iavf_hw *hw = &adapter->hw;
 	u32 reg_val;
 
-	if (!mutex_trylock(&adapter->crit_lock))
+	if (!mutex_trylock(&adapter->crit_lock)) {
+		if (adapter->state == __IAVF_REMOVE)
+			return;
+
 		goto restart_watchdog;
+	}
 
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		iavf_change_state(adapter, __IAVF_COMM_FAILED);
@@ -2601,13 +2606,13 @@ static void iavf_reset_task(struct work_struct *work)
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
-	if (mutex_is_locked(&adapter->remove_lock))
-		return;
+	if (!mutex_trylock(&adapter->crit_lock)) {
+		if (adapter->state != __IAVF_REMOVE)
+			queue_work(iavf_wq, &adapter->reset_task);
 
-	if (iavf_lock_timeout(&adapter->crit_lock, 200)) {
-		schedule_work(&adapter->reset_task);
 		return;
 	}
+
 	while (!mutex_trylock(&adapter->client_lock))
 		usleep_range(500, 1000);
 	if (CLIENT_ENABLED(adapter)) {
@@ -2826,13 +2831,19 @@ static void iavf_adminq_task(struct work_struct *work)
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		goto out;
 
+	if (!mutex_trylock(&adapter->crit_lock)) {
+		if (adapter->state == __IAVF_REMOVE)
+			return;
+
+		queue_work(iavf_wq, &adapter->adminq_task);
+		goto out;
+	}
+
 	event.buf_len = IAVF_MAX_AQ_BUF_SIZE;
 	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
 	if (!event.msg_buf)
 		goto out;
 
-	if (iavf_lock_timeout(&adapter->crit_lock, 200))
-		goto freedom;
 	do {
 		ret = iavf_clean_arq_element(hw, &event, &pending);
 		v_op = (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
@@ -3800,11 +3811,12 @@ static int iavf_close(struct net_device *netdev)
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	int status;
 
-	if (adapter->state <= __IAVF_DOWN_PENDING)
-		return 0;
+	mutex_lock(&adapter->crit_lock);
 
-	while (!mutex_trylock(&adapter->crit_lock))
-		usleep_range(500, 1000);
+	if (adapter->state <= __IAVF_DOWN_PENDING) {
+		mutex_unlock(&adapter->crit_lock);
+		return 0;
+	}
 
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 	if (CLIENT_ENABLED(adapter))
@@ -4431,7 +4443,6 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	mutex_init(&adapter->crit_lock);
 	mutex_init(&adapter->client_lock);
-	mutex_init(&adapter->remove_lock);
 	mutex_init(&hw->aq.asq_mutex);
 	mutex_init(&hw->aq.arq_mutex);
 
@@ -4556,11 +4567,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_cloud_filter *cf, *cftmp;
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
-	/* Indicate we are in remove and not to run reset_task */
-	mutex_lock(&adapter->remove_lock);
-	cancel_work_sync(&adapter->reset_task);
-	cancel_delayed_work_sync(&adapter->watchdog_task);
-	cancel_delayed_work_sync(&adapter->client_task);
+
 	if (adapter->netdev_registered) {
 		unregister_netdev(netdev);
 		adapter->netdev_registered = false;
@@ -4572,6 +4579,10 @@ static void iavf_remove(struct pci_dev *pdev)
 				 err);
 	}
 
+	mutex_lock(&adapter->crit_lock);
+	dev_info(&adapter->pdev->dev, "Remove device\n");
+	iavf_change_state(adapter, __IAVF_REMOVE);
+
 	iavf_request_reset(adapter);
 	msleep(50);
 	/* If the FW isn't responding, kick it once, but only once. */
@@ -4579,18 +4590,19 @@ static void iavf_remove(struct pci_dev *pdev)
 		iavf_request_reset(adapter);
 		msleep(50);
 	}
-	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 
-	dev_info(&adapter->pdev->dev, "Removing device\n");
+	iavf_misc_irq_disable(adapter);
 	/* Shut down all the garbage mashers on the detention level */
-	iavf_change_state(adapter, __IAVF_REMOVE);
+	cancel_work_sync(&adapter->reset_task);
+	cancel_delayed_work_sync(&adapter->watchdog_task);
+	cancel_work_sync(&adapter->adminq_task);
+	cancel_delayed_work_sync(&adapter->client_task);
+
 	adapter->aq_required = 0;
 	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
 
 	iavf_free_all_tx_resources(adapter);
 	iavf_free_all_rx_resources(adapter);
-	iavf_misc_irq_disable(adapter);
 	iavf_free_misc_irq(adapter);
 
 	/* In case we enter iavf_remove from erroneous state, free traffic irqs
@@ -4606,10 +4618,6 @@ static void iavf_remove(struct pci_dev *pdev)
 	iavf_reset_interrupt_capability(adapter);
 	iavf_free_q_vectors(adapter);
 
-	cancel_delayed_work_sync(&adapter->watchdog_task);
-
-	cancel_work_sync(&adapter->adminq_task);
-
 	iavf_free_rss(adapter);
 
 	if (hw->aq.asq.count)
@@ -4621,8 +4629,6 @@ static void iavf_remove(struct pci_dev *pdev)
 	mutex_destroy(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 	mutex_destroy(&adapter->crit_lock);
-	mutex_unlock(&adapter->remove_lock);
-	mutex_destroy(&adapter->remove_lock);
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
-- 
2.31.1

