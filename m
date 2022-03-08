Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6164D1E3A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348621AbiCHRMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242400AbiCHRMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:12:40 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77A94578A
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646759503; x=1678295503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ukRZnW/VAMp79bClEh65HLmhjt+IT59ZO0eBmWECmHY=;
  b=X6srVXzSsq0wpXo/PURIuwRWIl3p8+tHSrZi5/V0CLfTunu0swfq48Nv
   ld05RqZksBocycCISWdqHWSVizkYfC8jt0w988O5KXtlqMzHT5/Cv5ITM
   uQKob29pSMuIkn8WMOT+ODv1PC3DMKn0/f/lQW3N6kXdwX+73WhvErgT7
   1fPstYmlxYx35ESPQTXc+2zq2cFlzDGX/8FL8P8uFUnpT7O8f4Sv5A711
   G4dSdE/7Hu0zn1bgWB9GyKN6hU6KizTuiWhciBRzUYjdsjPBdOd3xsyzn
   8Y9U4QnN5SvooY3Vqd+kq5Lj5SjZrCs2qMq3v/o103xz7Qu1u3pJbCI0P
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="317972885"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="317972885"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 09:11:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="611069474"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 08 Mar 2022 09:11:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Slawomir Mrozowicz <slawomirx.mrozowicz@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 2/3] ixgbe: add improvement for MDD response functionality
Date:   Tue,  8 Mar 2022 09:11:54 -0800
Message-Id: <20220308171155.408896-3-anthony.l.nguyen@intel.com>
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

The 82599 PF driver disable VF driver after a special MDD event occurs.
Adds the option for administrators to control whether VFs are
automatically disabled after several MDD events.
The automatically disabling is now the default mode for 82599 PF driver,
as it is more reliable.

This addresses CVE-2021-33061.

Signed-off-by: Slawomir Mrozowicz <slawomirx.mrozowicz@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  4 +++
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 21 ++++++++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 28 ++++++++++++++++++-
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index c9bf18086d9c..921a4d977d65 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -184,6 +184,7 @@ struct vf_data_storage {
 	u8 trusted;
 	int xcast_mode;
 	unsigned int vf_api;
+	u8 primary_abort_count;
 };
 
 enum ixgbevf_xcast_modes {
@@ -558,6 +559,8 @@ struct ixgbe_mac_addr {
 #define IXGBE_TRY_LINK_TIMEOUT (4 * HZ)
 #define IXGBE_SFP_POLL_JIFFIES (2 * HZ)	/* SFP poll every 2 seconds */
 
+#define IXGBE_PRIMARY_ABORT_LIMIT	5
+
 /* board specific private data structure */
 struct ixgbe_adapter {
 	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
@@ -616,6 +619,7 @@ struct ixgbe_adapter {
 #define IXGBE_FLAG2_RX_LEGACY			BIT(16)
 #define IXGBE_FLAG2_IPSEC_ENABLED		BIT(17)
 #define IXGBE_FLAG2_VF_IPSEC_ENABLED		BIT(18)
+#define IXGBE_FLAG2_AUTO_DISABLE_VF		BIT(19)
 
 	/* Tx fast path data */
 	int num_tx_queues;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index f70967c32116..628d0eb0599f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -138,6 +138,8 @@ static const char ixgbe_priv_flags_strings[][ETH_GSTRING_LEN] = {
 	"legacy-rx",
 #define IXGBE_PRIV_FLAGS_VF_IPSEC_EN	BIT(1)
 	"vf-ipsec",
+#define IXGBE_PRIV_FLAGS_AUTO_DISABLE_VF	BIT(2)
+	"mdd-disable-vf",
 };
 
 #define IXGBE_PRIV_FLAGS_STR_LEN ARRAY_SIZE(ixgbe_priv_flags_strings)
@@ -3510,6 +3512,9 @@ static u32 ixgbe_get_priv_flags(struct net_device *netdev)
 	if (adapter->flags2 & IXGBE_FLAG2_VF_IPSEC_ENABLED)
 		priv_flags |= IXGBE_PRIV_FLAGS_VF_IPSEC_EN;
 
+	if (adapter->flags2 & IXGBE_FLAG2_AUTO_DISABLE_VF)
+		priv_flags |= IXGBE_PRIV_FLAGS_AUTO_DISABLE_VF;
+
 	return priv_flags;
 }
 
@@ -3517,6 +3522,7 @@ static int ixgbe_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	unsigned int flags2 = adapter->flags2;
+	unsigned int i;
 
 	flags2 &= ~IXGBE_FLAG2_RX_LEGACY;
 	if (priv_flags & IXGBE_PRIV_FLAGS_LEGACY_RX)
@@ -3526,6 +3532,21 @@ static int ixgbe_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 	if (priv_flags & IXGBE_PRIV_FLAGS_VF_IPSEC_EN)
 		flags2 |= IXGBE_FLAG2_VF_IPSEC_ENABLED;
 
+	flags2 &= ~IXGBE_FLAG2_AUTO_DISABLE_VF;
+	if (priv_flags & IXGBE_PRIV_FLAGS_AUTO_DISABLE_VF) {
+		if (adapter->hw.mac.type == ixgbe_mac_82599EB) {
+			/* Reset primary abort counter */
+			for (i = 0; i < adapter->num_vfs; i++)
+				adapter->vfinfo[i].primary_abort_count = 0;
+
+			flags2 |= IXGBE_FLAG2_AUTO_DISABLE_VF;
+		} else {
+			e_info(probe,
+			       "Cannot set private flags: Operation not supported\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	if (flags2 != adapter->flags2) {
 		adapter->flags2 = flags2;
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 13df4e0f3796..c4a4954aa317 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7613,6 +7613,27 @@ static void ixgbe_watchdog_flush_tx(struct ixgbe_adapter *adapter)
 }
 
 #ifdef CONFIG_PCI_IOV
+static void ixgbe_bad_vf_abort(struct ixgbe_adapter *adapter, u32 vf)
+{
+	struct ixgbe_hw *hw = &adapter->hw;
+
+	if (adapter->hw.mac.type == ixgbe_mac_82599EB &&
+	    adapter->flags2 & IXGBE_FLAG2_AUTO_DISABLE_VF) {
+		adapter->vfinfo[vf].primary_abort_count++;
+		if (adapter->vfinfo[vf].primary_abort_count ==
+		    IXGBE_PRIMARY_ABORT_LIMIT) {
+			ixgbe_set_vf_link_state(adapter, vf,
+						IFLA_VF_LINK_STATE_DISABLE);
+			adapter->vfinfo[vf].primary_abort_count = 0;
+
+			e_info(drv,
+			       "Malicious Driver Detection event detected on PF %d VF %d MAC: %pM mdd-disable-vf=on",
+			       hw->bus.func, vf,
+			       adapter->vfinfo[vf].vf_mac_addresses);
+		}
+	}
+}
+
 static void ixgbe_check_for_bad_vf(struct ixgbe_adapter *adapter)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
@@ -7644,8 +7665,10 @@ static void ixgbe_check_for_bad_vf(struct ixgbe_adapter *adapter)
 			continue;
 		pci_read_config_word(vfdev, PCI_STATUS, &status_reg);
 		if (status_reg != IXGBE_FAILED_READ_CFG_WORD &&
-		    status_reg & PCI_STATUS_REC_MASTER_ABORT)
+		    status_reg & PCI_STATUS_REC_MASTER_ABORT) {
+			ixgbe_bad_vf_abort(adapter, vf);
 			pcie_flr(vfdev);
+		}
 	}
 }
 
@@ -10746,6 +10769,9 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
+	if (adapter->hw.mac.type == ixgbe_mac_82599EB)
+		adapter->flags2 |= IXGBE_FLAG2_AUTO_DISABLE_VF;
+
 	switch (adapter->hw.mac.type) {
 	case ixgbe_mac_X550:
 	case ixgbe_mac_X550EM_x:
-- 
2.31.1

