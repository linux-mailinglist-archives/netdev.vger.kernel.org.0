Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3D34C4F12
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbiBYTqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbiBYTqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:46:46 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AEC21046A
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645818374; x=1677354374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C+1YlnQ5bkAOD8pP8a2/yiivMSFlKLM8tarivTeH2WM=;
  b=Ywcwba0pGOcN7iUyiLjbeR8gNbadrvOZI1FZv497jl7M0nvUdAEqtr7D
   zFn1aufL8tGcne2rL3evg+garCoSA6qTlCtvBZSONnLxWddKhRtpjIHbi
   ZzlUf0FNuFRw15EOpOTDU14HdJtrLUEL/KciCQ+/QFH+qSiQl0nxX9n6V
   xZIAHT2ojj9NuEne2AX8PxHJ/D2zeXi4TmrMj/mJDMPWD8uJk3+QECjoY
   xuHWF+gdhyHiwE+WiOMSUQIOH2JEl0QIvxPiF+NNOd8b72RXjqpNiZK0c
   7xD3vfKmruWw9vBoZvjw30SG9qM4Luvv40hk6rTpxJ83KcbnUEgdwaW0f
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="339004858"
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="339004858"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 11:46:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="707972173"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 25 Feb 2022 11:46:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Slawomir Laba <slawomirx.laba@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/8] iavf: Add waiting so the port is initialized in remove
Date:   Fri, 25 Feb 2022 11:46:08 -0800
Message-Id: <20220225194614.136571-3-anthony.l.nguyen@intel.com>
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

There exist races when port is being configured and remove is
triggered.

unregister_netdev is not and can't be called under crit_lock
mutex since it is calling ndo_stop -> iavf_close which requires
this lock. Depending on init state the netdev could be still
unregistered so unregister_netdev never cleans up, when shortly
after that the device could become registered.

Make iavf_remove wait until port finishes initialization.
All critical state changes are atomic (under crit_lock).
Crashes that come from iavf_reset_interrupt_capability and
iavf_free_traffic_irqs should now be solved in a graceful
manner.

Fixes: 605ca7c5c6707 ("iavf: Fix kernel BUG in free_msi_irqs")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 27 ++++++++++++---------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 84ae96e912d7..5e71b38e9154 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4558,7 +4558,6 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 static void iavf_remove(struct pci_dev *pdev)
 {
 	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
-	enum iavf_state_t prev_state = adapter->last_state;
 	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
@@ -4568,6 +4567,22 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
 
+	/* Wait until port initialization is complete.
+	 * There are flows where register/unregister netdev may race.
+	 */
+	while (1) {
+		mutex_lock(&adapter->crit_lock);
+		if (adapter->state == __IAVF_RUNNING ||
+		    adapter->state == __IAVF_DOWN) {
+			mutex_unlock(&adapter->crit_lock);
+			break;
+		}
+
+		mutex_unlock(&adapter->crit_lock);
+		usleep_range(500, 1000);
+	}
+	cancel_delayed_work_sync(&adapter->watchdog_task);
+
 	if (adapter->netdev_registered) {
 		unregister_netdev(netdev);
 		adapter->netdev_registered = false;
@@ -4605,16 +4620,6 @@ static void iavf_remove(struct pci_dev *pdev)
 	iavf_free_all_rx_resources(adapter);
 	iavf_free_misc_irq(adapter);
 
-	/* In case we enter iavf_remove from erroneous state, free traffic irqs
-	 * here, so as to not cause a kernel crash, when calling
-	 * iavf_reset_interrupt_capability.
-	 */
-	if ((adapter->last_state == __IAVF_RESETTING &&
-	     prev_state != __IAVF_DOWN) ||
-	    (adapter->last_state == __IAVF_RUNNING &&
-	     !(netdev->flags & IFF_UP)))
-		iavf_free_traffic_irqs(adapter);
-
 	iavf_reset_interrupt_capability(adapter);
 	iavf_free_q_vectors(adapter);
 
-- 
2.31.1

