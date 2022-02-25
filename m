Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C834C4F19
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbiBYTqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbiBYTqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:46:47 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0904921046D
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645818374; x=1677354374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TTdbyLEuLm+ZCIa7L1mvwlLWz8bQtfmKmH4EfQQlAhc=;
  b=UJsy5HIFDB0vcgCbsPAuGccHwx9SAOyjoHcla/1ZSDmB+NffrLUr75Uh
   SB/IqTR2It0lciCS1s1VhmVufTz6UXssUXeh8IqHFx1CBbvihTyD5vooH
   MtBp3RWKyl8doLHTh+KbVoXFhjIzuI7G19gVfkJkAZklUcK5+BAASZ2KM
   k9s1jMFR8BEryk52InB/xQb+Udc871uN0C5+treu/mt6aoSo0gzjLeyCv
   LdNfqCsLjvDAVpLs6G/vYLZ6VVoMvIiNpA3Dj6ojrBwrvMkZ3v01aMtd3
   EJ5GJgQqTh2zDm8YqOj9GtCVCGYSxlUAeDCip+vbL39uwfIfGh/ThJxzD
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="339004862"
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="339004862"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 11:46:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="707972179"
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
Subject: [PATCH net 4/8] iavf: Fix locking for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS
Date:   Fri, 25 Feb 2022 11:46:10 -0800
Message-Id: <20220225194614.136571-5-anthony.l.nguyen@intel.com>
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

iavf_virtchnl_completion is called under crit_lock but when
the code for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS is called,
this lock is released in order to obtain rtnl_lock to avoid
ABBA deadlock with unregister_netdev.

Along with the new way iavf_remove behaves, there exist
many risks related to the lock release and attmepts to regrab
it. The driver faces crashes related to races between
unregister_netdev and netdev_update_features. Yet another
risk is that the driver could already obtain the crit_lock
in order to destroy it and iavf_virtchnl_completion could
crash or block forever.

Make iavf_virtchnl_completion never relock crit_lock in it's
call paths.

Extract rtnl_lock locking logic to the driver for
unregister_netdev in order to set the netdev_registered flag
inside the lock.

Introduce a new flag that will inform adminq_task to perform
the code from VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS right after
it finishes processing messages. Guard this code with remove
flags so it's never called when the driver is in remove state.

Fixes: 5951a2b9812d ("iavf: Fix VLAN feature flags after VFR")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 22 ++++++++++++++++-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 24 +------------------
 3 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index f259fd517b2c..89423947ee65 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -287,6 +287,7 @@ struct iavf_adapter {
 #define IAVF_FLAG_LEGACY_RX			BIT(15)
 #define IAVF_FLAG_REINIT_ITR_NEEDED		BIT(16)
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
+#define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
 	/* flags for admin queue service task */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index be51da978e7c..67349d24dc90 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2879,6 +2879,24 @@ static void iavf_adminq_task(struct work_struct *work)
 	} while (pending);
 	mutex_unlock(&adapter->crit_lock);
 
+	if ((adapter->flags & IAVF_FLAG_SETUP_NETDEV_FEATURES)) {
+		if (adapter->netdev_registered ||
+		    !test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section)) {
+			struct net_device *netdev = adapter->netdev;
+
+			rtnl_lock();
+			netdev_update_features(netdev);
+			rtnl_unlock();
+			/* Request VLAN offload settings */
+			if (VLAN_V2_ALLOWED(adapter))
+				iavf_set_vlan_offload_features
+					(adapter, 0, netdev->features);
+
+			iavf_set_queue_vlan_tag_loc(adapter);
+		}
+
+		adapter->flags &= ~IAVF_FLAG_SETUP_NETDEV_FEATURES;
+	}
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
 	    adapter->state == __IAVF_RESETTING)
@@ -4606,8 +4624,10 @@ static void iavf_remove(struct pci_dev *pdev)
 	cancel_delayed_work_sync(&adapter->watchdog_task);
 
 	if (adapter->netdev_registered) {
-		unregister_netdev(netdev);
+		rtnl_lock();
+		unregister_netdevice(netdev);
 		adapter->netdev_registered = false;
+		rtnl_unlock();
 	}
 	if (CLIENT_ALLOWED(adapter)) {
 		err = iavf_lan_del_device(adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 5ee1d118fd30..88844d68e150 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2146,29 +2146,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 				     sizeof(adapter->vlan_v2_caps)));
 
 		iavf_process_config(adapter);
-
-		/* unlock crit_lock before acquiring rtnl_lock as other
-		 * processes holding rtnl_lock could be waiting for the same
-		 * crit_lock
-		 */
-		mutex_unlock(&adapter->crit_lock);
-		/* VLAN capabilities can change during VFR, so make sure to
-		 * update the netdev features with the new capabilities
-		 */
-		rtnl_lock();
-		netdev_update_features(netdev);
-		rtnl_unlock();
-		if (iavf_lock_timeout(&adapter->crit_lock, 10000))
-			dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n",
-				 __FUNCTION__);
-
-		/* Request VLAN offload settings */
-		if (VLAN_V2_ALLOWED(adapter))
-			iavf_set_vlan_offload_features(adapter, 0,
-						       netdev->features);
-
-		iavf_set_queue_vlan_tag_loc(adapter);
-
+		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
 		}
 		break;
 	case VIRTCHNL_OP_ENABLE_QUEUES:
-- 
2.31.1

