Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682594C93B5
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiCATAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237184AbiCATAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:00:11 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8AC10D1
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646161168; x=1677697168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eo+IdaHJ5g/pumcgglQEAvPph1+7+Sl3+WLaYq4vMNI=;
  b=YH8/g3m+JWUXab3zFdi0zsyK/sdy6wbIwk6Yo3gk2gfkWQHlSrgVV5/C
   7+H3hIkodq8qjwTA7Kbk2Ei5qkkukPEfslqTf0M5pCbmUTgE0HKDdKAy3
   NNVMnIQzL/PNZm64LtfnfYLRt09Bj4R6s4qnX+toTHX6p846KM2gP76S/
   LgttuU67kt4myLXdcIfmBMtA4wR5P8xDeAjr68AO5xIXyuFNxRRKbOliW
   d69QclYX0PNtlfTHgIvw1chL6GUHY3lPorUOXunYhzNMqk0Rgzy3C0Htq
   d1m1gWr/IFC5xcMiErh1J0TFxwNInffBcP0hoBFc3UK12f7WtPLpTZuoM
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="252042318"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252042318"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 10:59:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="507908258"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 10:59:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 2/7] iavf: refactor processing of VLAN V2 capability message
Date:   Tue,  1 Mar 2022 10:59:34 -0800
Message-Id: <20220301185939.3005116-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
References: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

In order to handle the capability exchange necessary for
VIRTCHNL_VF_OFFLOAD_VLAN_V2, the driver must send
a VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS message. This must occur prior to
__IAVF_CONFIG_ADAPTER, and the driver must wait for the response from
the PF.

To handle this, the __IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS state was
introduced. This state is intended to process the response from the VLAN
V2 caps message. This works ok, but is difficult to extend to adding
more extended capability exchange.

Existing (and future) AVF features are relying more and more on these
sort of extended ops for processing additional capabilities. Just like
VLAN V2, this exchange must happen prior to __IAVF_CONFIG_ADPATER.

Since we only send one outstanding AQ message at a time during init, it
is not clear where to place this state. Adding more capability specific
states becomes a mess. Instead of having the "previous" state send
a message and then transition into a capability-specific state,
introduce __IAVF_EXTENDED_CAPS state. This state will use a list of
extended_caps that determines what messages to send and receive. As long
as there are extended_caps bits still set, the driver will remain in
this state performing one send or one receive per state machine loop.

Refactor the VLAN V2 negotiation to use this new state, and remove the
capability-specific state. This makes it significantly easier to add
a new similar capability exchange going forward.

Extended capabilities are processed by having an associated SEND and
RECV extended capability bit. During __IAVF_EXTENDED_CAPS, the
driver checks these bits in order by feature, first the send bit for
a feature, then the recv bit for a feature. Each send flag will call
a function that sends the necessary response, while each receive flag
will wait for the response from the PF. If a given feature can't be
negotiated with the PF, the associated flags will be cleared in
order to skip processing of that feature.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  17 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c | 108 ++++++++++++++------
 2 files changed, 95 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 59806d1f7e79..16cd06feed31 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -188,7 +188,7 @@ enum iavf_state_t {
 	__IAVF_REMOVE,		/* driver is being unloaded */
 	__IAVF_INIT_VERSION_CHECK,	/* aq msg sent, awaiting reply */
 	__IAVF_INIT_GET_RESOURCES,	/* aq msg sent, awaiting reply */
-	__IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS,
+	__IAVF_INIT_EXTENDED_CAPS,	/* process extended caps which require aq msg exchange */
 	__IAVF_INIT_CONFIG_ADAPTER,
 	__IAVF_INIT_SW,		/* got resources, setting up structs */
 	__IAVF_INIT_FAILED,	/* init failed, restarting procedure */
@@ -329,6 +329,21 @@ struct iavf_adapter {
 #define IAVF_FLAG_AQ_ENABLE_STAG_VLAN_INSERTION		BIT_ULL(37)
 #define IAVF_FLAG_AQ_DISABLE_STAG_VLAN_INSERTION	BIT_ULL(38)
 
+	/* flags for processing extended capability messages during
+	 * __IAVF_INIT_EXTENDED_CAPS. Each capability exchange requires
+	 * both a SEND and a RECV step, which must be processed in sequence.
+	 *
+	 * During the __IAVF_INIT_EXTENDED_CAPS state, the driver will
+	 * process one flag at a time during each state loop.
+	 */
+	u64 extended_caps;
+#define IAVF_EXTENDED_CAP_SEND_VLAN_V2			BIT_ULL(0)
+#define IAVF_EXTENDED_CAP_RECV_VLAN_V2			BIT_ULL(1)
+
+#define IAVF_EXTENDED_CAPS				\
+	(IAVF_EXTENDED_CAP_SEND_VLAN_V2 |		\
+	 IAVF_EXTENDED_CAP_RECV_VLAN_V2)
+
 	/* OS defined structs */
 	struct net_device *netdev;
 	struct pci_dev *pdev;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index b0bd95c85480..450a98196235 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2189,26 +2189,18 @@ static void iavf_init_get_resources(struct iavf_adapter *adapter)
 	}
 
 	err = iavf_parse_vf_resource_msg(adapter);
-	if (err)
-		goto err_alloc;
-
-	err = iavf_send_vf_offload_vlan_v2_msg(adapter);
-	if (err == -EOPNOTSUPP) {
-		/* underlying PF doesn't support VIRTCHNL_VF_OFFLOAD_VLAN_V2, so
-		 * go directly to finishing initialization
-		 */
-		iavf_change_state(adapter, __IAVF_INIT_CONFIG_ADAPTER);
-		return;
-	} else if (err) {
-		dev_err(&pdev->dev, "Unable to send offload vlan v2 request (%d)\n",
+	if (err) {
+		dev_err(&pdev->dev, "Failed to parse VF resource message from PF (%d)\n",
 			err);
 		goto err_alloc;
 	}
-
-	/* underlying PF supports VIRTCHNL_VF_OFFLOAD_VLAN_V2, so update the
-	 * state accordingly
+	/* Some features require additional messages to negotiate extended
+	 * capabilities. These are processed in sequence by the
+	 * __IAVF_INIT_EXTENDED_CAPS driver state.
 	 */
-	iavf_change_state(adapter, __IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS);
+	adapter->extended_caps = IAVF_EXTENDED_CAPS;
+
+	iavf_change_state(adapter, __IAVF_INIT_EXTENDED_CAPS);
 	return;
 
 err_alloc:
@@ -2219,34 +2211,92 @@ static void iavf_init_get_resources(struct iavf_adapter *adapter)
 }
 
 /**
- * iavf_init_get_offload_vlan_v2_caps - part of driver startup
+ * iavf_init_send_offload_vlan_v2_caps - part of initializing VLAN V2 caps
+ * @adapter: board private structure
+ *
+ * Function processes send of the extended VLAN V2 capability message to the
+ * PF. Must clear IAVF_EXTENDED_CAP_RECV_VLAN_V2 if the message is not sent,
+ * e.g. due to PF not negotiating VIRTCHNL_VF_OFFLOAD_VLAN_V2.
+ */
+static void iavf_init_send_offload_vlan_v2_caps(struct iavf_adapter *adapter)
+{
+	int ret;
+
+	WARN_ON(!(adapter->extended_caps & IAVF_EXTENDED_CAP_SEND_VLAN_V2));
+
+	ret = iavf_send_vf_offload_vlan_v2_msg(adapter);
+	if (ret && ret == -EOPNOTSUPP) {
+		/* PF does not support VIRTCHNL_VF_OFFLOAD_V2. In this case,
+		 * we did not send the capability exchange message and do not
+		 * expect a response.
+		 */
+		adapter->extended_caps &= ~IAVF_EXTENDED_CAP_RECV_VLAN_V2;
+	}
+
+	/* We sent the message, so move on to the next step */
+	adapter->extended_caps &= ~IAVF_EXTENDED_CAP_SEND_VLAN_V2;
+}
+
+/**
+ * iavf_init_recv_offload_vlan_v2_caps - part of initializing VLAN V2 caps
  * @adapter: board private structure
  *
- * Function processes __IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS driver state if the
- * VF negotiates VIRTCHNL_VF_OFFLOAD_VLAN_V2. If VIRTCHNL_VF_OFFLOAD_VLAN_V2 is
- * not negotiated, then this state will never be entered.
+ * Function processes receipt of the extended VLAN V2 capability message from
+ * the PF.
  **/
-static void iavf_init_get_offload_vlan_v2_caps(struct iavf_adapter *adapter)
+static void iavf_init_recv_offload_vlan_v2_caps(struct iavf_adapter *adapter)
 {
 	int ret;
 
-	WARN_ON(adapter->state != __IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS);
+	WARN_ON(!(adapter->extended_caps & IAVF_EXTENDED_CAP_RECV_VLAN_V2));
 
 	memset(&adapter->vlan_v2_caps, 0, sizeof(adapter->vlan_v2_caps));
 
 	ret = iavf_get_vf_vlan_v2_caps(adapter);
-	if (ret) {
-		if (ret == IAVF_ERR_ADMIN_QUEUE_NO_WORK)
-			iavf_send_vf_offload_vlan_v2_msg(adapter);
+	if (ret)
 		goto err;
-	}
 
-	iavf_change_state(adapter, __IAVF_INIT_CONFIG_ADAPTER);
+	/* We've processed receipt of the VLAN V2 caps message */
+	adapter->extended_caps &= ~IAVF_EXTENDED_CAP_RECV_VLAN_V2;
 	return;
 err:
+	/* We didn't receive a reply. Make sure we try sending again when
+	 * __IAVF_INIT_FAILED attempts to recover.
+	 */
+	adapter->extended_caps |= IAVF_EXTENDED_CAP_SEND_VLAN_V2;
 	iavf_change_state(adapter, __IAVF_INIT_FAILED);
 }
 
+/**
+ * iavf_init_process_extended_caps - Part of driver startup
+ * @adapter: board private structure
+ *
+ * Function processes __IAVF_INIT_EXTENDED_CAPS driver state. This state
+ * handles negotiating capabilities for features which require an additional
+ * message.
+ *
+ * Once all extended capabilities exchanges are finished, the driver will
+ * transition into __IAVF_INIT_CONFIG_ADAPTER.
+ */
+static void iavf_init_process_extended_caps(struct iavf_adapter *adapter)
+{
+	WARN_ON(adapter->state != __IAVF_INIT_EXTENDED_CAPS);
+
+	/* Process capability exchange for VLAN V2 */
+	if (adapter->extended_caps & IAVF_EXTENDED_CAP_SEND_VLAN_V2) {
+		iavf_init_send_offload_vlan_v2_caps(adapter);
+		return;
+	} else if (adapter->extended_caps & IAVF_EXTENDED_CAP_RECV_VLAN_V2) {
+		iavf_init_recv_offload_vlan_v2_caps(adapter);
+		return;
+	}
+
+	/* When we reach here, no further extended capabilities exchanges are
+	 * necessary, so we finally transition into __IAVF_INIT_CONFIG_ADAPTER
+	 */
+	iavf_change_state(adapter, __IAVF_INIT_CONFIG_ADAPTER);
+}
+
 /**
  * iavf_init_config_adapter - last part of driver startup
  * @adapter: board private structure
@@ -2406,8 +2456,8 @@ static void iavf_watchdog_task(struct work_struct *work)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
-	case __IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS:
-		iavf_init_get_offload_vlan_v2_caps(adapter);
+	case __IAVF_INIT_EXTENDED_CAPS:
+		iavf_init_process_extended_caps(adapter);
 		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
-- 
2.31.1

