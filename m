Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603904D1E3D
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237619AbiCHRMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348606AbiCHRMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:12:41 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCAA4C428
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646759504; x=1678295504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C3IfuYK1cwwBXbpNHExzoGd3lzVIhzCotVgayzudtBE=;
  b=BID6u6BQxZklSJJLJHvCXcuHnEXgK5iIUqbHSzEYWRQRtyCeVipBk9Cq
   8FXijEWwnMBD7BCkRRZfnpCIinnECwmgwWYCzCjZKgZQWzcCywprWrLSp
   nKbRUxpmitaC5QIVwr1heOVmfK612Ezk0XJ+G8ePS8EdJIHeymoT+CR7S
   T6opaHIc3JpQNWr3NSLJ+33t48K0HdqShdUW3JFazW71GoKhGCYyNjx20
   kPXBpLCy1s68u9+RKngU91pu/rc8+EUlvK6q6pU8GcipCdNLam7F/FExn
   49WA3f3Q48Agbkp36ltYZjqxGHXEAODTD0SsTMYhbfFKq9ZGaaeoZtejI
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="317972888"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="317972888"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 09:11:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="611069479"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 08 Mar 2022 09:11:43 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Slawomir Mrozowicz <slawomirx.mrozowicz@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 3/3] ixgbevf: add disable link state
Date:   Tue,  8 Mar 2022 09:11:55 -0800
Message-Id: <20220308171155.408896-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308171155.408896-1-anthony.l.nguyen@intel.com>
References: <20220308171155.408896-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Slawomir Mrozowicz <slawomirx.mrozowicz@intel.com>

Add possibility to disable link state if it is administratively
disabled in PF.

It is part of the general functionality that allows the PF driver
to control the state of the virtual link VF devices.

Signed-off-by: Slawomir Mrozowicz <slawomirx.mrozowicz@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h  |  2 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 11 ++++-
 drivers/net/ethernet/intel/ixgbevf/mbx.h      |  2 +
 drivers/net/ethernet/intel/ixgbevf/vf.c       | 42 +++++++++++++++++++
 drivers/net/ethernet/intel/ixgbevf/vf.h       |  1 +
 5 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
index e257390a4f6a..149c733fcc2b 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
@@ -387,6 +387,8 @@ struct ixgbevf_adapter {
 	u32 *rss_key;
 	u8 rss_indir_tbl[IXGBEVF_X550_VFRETA_SIZE];
 	u32 flags;
+	bool link_state;
+
 #define IXGBEVF_FLAGS_LEGACY_RX		BIT(1)
 
 #ifdef CONFIG_XFRM
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 84222ec2393c..55b87bc3a938 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2298,7 +2298,9 @@ static void ixgbevf_negotiate_api(struct ixgbevf_adapter *adapter)
 static void ixgbevf_up_complete(struct ixgbevf_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
+	struct pci_dev *pdev = adapter->pdev;
 	struct ixgbe_hw *hw = &adapter->hw;
+	bool state;
 
 	ixgbevf_configure_msix(adapter);
 
@@ -2311,6 +2313,11 @@ static void ixgbevf_up_complete(struct ixgbevf_adapter *adapter)
 
 	spin_unlock_bh(&adapter->mbx_lock);
 
+	state = adapter->link_state;
+	hw->mac.ops.get_link_state(hw, &adapter->link_state);
+	if (state && state != adapter->link_state)
+		dev_info(&pdev->dev, "VF is administratively disabled\n");
+
 	smp_mb__before_atomic();
 	clear_bit(__IXGBEVF_DOWN, &adapter->state);
 	ixgbevf_napi_enable_all(adapter);
@@ -3081,6 +3088,8 @@ static int ixgbevf_sw_init(struct ixgbevf_adapter *adapter)
 	adapter->tx_ring_count = IXGBEVF_DEFAULT_TXD;
 	adapter->rx_ring_count = IXGBEVF_DEFAULT_RXD;
 
+	adapter->link_state = true;
+
 	set_bit(__IXGBEVF_DOWN, &adapter->state);
 	return 0;
 
@@ -3313,7 +3322,7 @@ static void ixgbevf_watchdog_subtask(struct ixgbevf_adapter *adapter)
 
 	ixgbevf_watchdog_update_link(adapter);
 
-	if (adapter->link_up)
+	if (adapter->link_up && adapter->link_state)
 		ixgbevf_watchdog_link_is_up(adapter);
 	else
 		ixgbevf_watchdog_link_is_down(adapter);
diff --git a/drivers/net/ethernet/intel/ixgbevf/mbx.h b/drivers/net/ethernet/intel/ixgbevf/mbx.h
index 7346ccf014a5..835bbcc5cc8e 100644
--- a/drivers/net/ethernet/intel/ixgbevf/mbx.h
+++ b/drivers/net/ethernet/intel/ixgbevf/mbx.h
@@ -100,6 +100,8 @@ enum ixgbe_pfvf_api_rev {
 #define IXGBE_VF_IPSEC_ADD	0x0d
 #define IXGBE_VF_IPSEC_DEL	0x0e
 
+#define IXGBE_VF_GET_LINK_STATE 0x10 /* get vf link state */
+
 /* length of permanent address message returned from PF */
 #define IXGBE_VF_PERMADDR_MSG_LEN	4
 /* word in permanent address message with the current multicast type */
diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/ethernet/intel/ixgbevf/vf.c
index 61d8970c6d1d..68fc32e36e88 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.c
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.c
@@ -584,6 +584,46 @@ static s32 ixgbevf_hv_update_xcast_mode(struct ixgbe_hw *hw, int xcast_mode)
 	return -EOPNOTSUPP;
 }
 
+/**
+ * ixgbevf_get_link_state_vf - Get VF link state from PF
+ * @hw: pointer to the HW structure
+ * @link_state: link state storage
+ *
+ * Returns state of the operation error or success.
+ */
+static s32 ixgbevf_get_link_state_vf(struct ixgbe_hw *hw, bool *link_state)
+{
+	u32 msgbuf[2];
+	s32 ret_val;
+	s32 err;
+
+	msgbuf[0] = IXGBE_VF_GET_LINK_STATE;
+	msgbuf[1] = 0x0;
+
+	err = ixgbevf_write_msg_read_ack(hw, msgbuf, msgbuf, 2);
+
+	if (err || (msgbuf[0] & IXGBE_VT_MSGTYPE_FAILURE)) {
+		ret_val = IXGBE_ERR_MBX;
+	} else {
+		ret_val = 0;
+		*link_state = msgbuf[1];
+	}
+
+	return ret_val;
+}
+
+/**
+ * ixgbevf_hv_get_link_state_vf - * Hyper-V variant - just a stub.
+ * @hw: unused
+ * @link_state: unused
+ *
+ * Hyper-V variant; there is no mailbox communication.
+ */
+static s32 ixgbevf_hv_get_link_state_vf(struct ixgbe_hw *hw, bool *link_state)
+{
+	return -EOPNOTSUPP;
+}
+
 /**
  *  ixgbevf_set_vfta_vf - Set/Unset VLAN filter table address
  *  @hw: pointer to the HW structure
@@ -968,6 +1008,7 @@ static const struct ixgbe_mac_operations ixgbevf_mac_ops = {
 	.set_rar		= ixgbevf_set_rar_vf,
 	.update_mc_addr_list	= ixgbevf_update_mc_addr_list_vf,
 	.update_xcast_mode	= ixgbevf_update_xcast_mode,
+	.get_link_state		= ixgbevf_get_link_state_vf,
 	.set_uc_addr		= ixgbevf_set_uc_addr_vf,
 	.set_vfta		= ixgbevf_set_vfta_vf,
 	.set_rlpml		= ixgbevf_set_rlpml_vf,
@@ -985,6 +1026,7 @@ static const struct ixgbe_mac_operations ixgbevf_hv_mac_ops = {
 	.set_rar		= ixgbevf_hv_set_rar_vf,
 	.update_mc_addr_list	= ixgbevf_hv_update_mc_addr_list_vf,
 	.update_xcast_mode	= ixgbevf_hv_update_xcast_mode,
+	.get_link_state		= ixgbevf_hv_get_link_state_vf,
 	.set_uc_addr		= ixgbevf_hv_set_uc_addr_vf,
 	.set_vfta		= ixgbevf_hv_set_vfta_vf,
 	.set_rlpml		= ixgbevf_hv_set_rlpml_vf,
diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.h b/drivers/net/ethernet/intel/ixgbevf/vf.h
index 54158dac8707..b4eef5b6c172 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.h
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.h
@@ -39,6 +39,7 @@ struct ixgbe_mac_operations {
 	s32 (*init_rx_addrs)(struct ixgbe_hw *);
 	s32 (*update_mc_addr_list)(struct ixgbe_hw *, struct net_device *);
 	s32 (*update_xcast_mode)(struct ixgbe_hw *, int);
+	s32 (*get_link_state)(struct ixgbe_hw *hw, bool *link_state);
 	s32 (*enable_mc)(struct ixgbe_hw *);
 	s32 (*disable_mc)(struct ixgbe_hw *);
 	s32 (*clear_vfta)(struct ixgbe_hw *);
-- 
2.31.1

