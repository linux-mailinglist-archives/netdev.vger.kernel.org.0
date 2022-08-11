Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3701A5901C0
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbiHKPxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236697AbiHKPwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:52:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D1849B67;
        Thu, 11 Aug 2022 08:44:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE88C616C6;
        Thu, 11 Aug 2022 15:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA5CC433C1;
        Thu, 11 Aug 2022 15:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232648;
        bh=JpWJuc87JdE7l8Oa/B1+9XhhPK7XEBMFR4T7SWPH+Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqTpBtJdIUA6YGpnRGA+ZLbxB8+eHwv27H0SnRVScYA5aB0qbcQuGTf0CMUeJXWiq
         nNHolWtkFbz1pXGQ2Ob62NEvIlmLo040vSmu3uPkFHDcmQZtw1r5OpRjnOmBhsaSuv
         qxbDp7oGuTNfPrG5gbxicp22HoSE7il1jdgUuJVssR+2lUmLvU74jM0qR+aLNiqHhS
         XctGJlmldQ7fT0PU+V4tXuwZPEPrqbeBKHIuLpx6m24Lh/zXpM6yVloxyA2ciuyMzV
         I0z4UA5yHXdMngKZd2YL5NrUuyciffaCNE8TkDaXmiijLHdGPIkN0ALuVueUq+Cbh1
         +adwd+vu3Cohw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>, jesse.brandeburg@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 15/93] iavf: Add waiting for response from PF in set mac
Date:   Thu, 11 Aug 2022 11:41:09 -0400
Message-Id: <20220811154237.1531313-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit 35a2443d0910fdd6ce29d4f724447ad7029e8f23 ]

Make iavf_set_mac synchronous by waiting for a response
from a PF. Without this iavf_set_mac is always returning
success even though set_mac can be rejected by a PF.
This ensures that when set_mac exits netdev MAC is updated.
This is needed for sending ARPs with correct MAC after
changing VF's MAC. This is also needed by bonding module.

Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |   7 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 127 +++++++++++++++---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  61 ++++++++-
 3 files changed, 174 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 0ea0361cd86b..69703801d1b0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -145,7 +145,8 @@ struct iavf_mac_filter {
 		u8 remove:1;        /* filter needs to be removed */
 		u8 add:1;           /* filter needs to be added */
 		u8 is_primary:1;    /* filter is a default VF MAC */
-		u8 padding:4;
+		u8 add_handled:1;   /* received response for filter add */
+		u8 padding:3;
 	};
 };
 
@@ -251,6 +252,7 @@ struct iavf_adapter {
 	struct work_struct adminq_task;
 	struct delayed_work client_task;
 	wait_queue_head_t down_waitqueue;
+	wait_queue_head_t vc_waitqueue;
 	struct iavf_q_vector *q_vectors;
 	struct list_head vlan_filter_list;
 	struct list_head mac_filter_list;
@@ -295,6 +297,7 @@ struct iavf_adapter {
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
 #define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
 #define IAVF_FLAG_REINIT_MSIX_NEEDED		BIT(20)
+#define IAVF_FLAG_INITIAL_MAC_SET		BIT(23)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
 	/* flags for admin queue service task */
@@ -567,6 +570,8 @@ void iavf_enable_vlan_stripping_v2(struct iavf_adapter *adapter, u16 tpid);
 void iavf_disable_vlan_stripping_v2(struct iavf_adapter *adapter, u16 tpid);
 void iavf_enable_vlan_insertion_v2(struct iavf_adapter *adapter, u16 tpid);
 void iavf_disable_vlan_insertion_v2(struct iavf_adapter *adapter, u16 tpid);
+int iavf_replace_primary_mac(struct iavf_adapter *adapter,
+			     const u8 *new_mac);
 void
 iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
 			       netdev_features_t prev_features,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2e2c153ce46a..2ec3ebb397f3 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -978,6 +978,7 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 
 		list_add_tail(&f->list, &adapter->mac_filter_list);
 		f->add = true;
+		f->add_handled = false;
 		f->is_new_mac = true;
 		f->is_primary = ether_addr_equal(macaddr, adapter->hw.mac.addr);
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
@@ -989,47 +990,132 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 }
 
 /**
- * iavf_set_mac - NDO callback to set port mac address
- * @netdev: network interface device structure
- * @p: pointer to an address structure
+ * iavf_replace_primary_mac - Replace current primary address
+ * @adapter: board private structure
+ * @new_mac: new MAC address to be applied
  *
- * Returns 0 on success, negative on failure
+ * Replace current dev_addr and send request to PF for removal of previous
+ * primary MAC address filter and addition of new primary MAC filter.
+ * Return 0 for success, -ENOMEM for failure.
+ *
+ * Do not call this with mac_vlan_list_lock!
  **/
-static int iavf_set_mac(struct net_device *netdev, void *p)
+int iavf_replace_primary_mac(struct iavf_adapter *adapter,
+			     const u8 *new_mac)
 {
-	struct iavf_adapter *adapter = netdev_priv(netdev);
 	struct iavf_hw *hw = &adapter->hw;
 	struct iavf_mac_filter *f;
-	struct sockaddr *addr = p;
-
-	if (!is_valid_ether_addr(addr->sa_data))
-		return -EADDRNOTAVAIL;
-
-	if (ether_addr_equal(netdev->dev_addr, addr->sa_data))
-		return 0;
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 
+	list_for_each_entry(f, &adapter->mac_filter_list, list) {
+		f->is_primary = false;
+	}
+
 	f = iavf_find_filter(adapter, hw->mac.addr);
 	if (f) {
 		f->remove = true;
-		f->is_primary = true;
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_MAC_FILTER;
 	}
 
-	f = iavf_add_filter(adapter, addr->sa_data);
+	f = iavf_add_filter(adapter, new_mac);
+
 	if (f) {
+		/* Always send the request to add if changing primary MAC
+		 * even if filter is already present on the list
+		 */
 		f->is_primary = true;
-		ether_addr_copy(hw->mac.addr, addr->sa_data);
+		f->add = true;
+		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
+		ether_addr_copy(hw->mac.addr, new_mac);
 	}
 
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 
 	/* schedule the watchdog task to immediately process the request */
-	if (f)
+	if (f) {
 		queue_work(iavf_wq, &adapter->watchdog_task.work);
+		return 0;
+	}
+	return -ENOMEM;
+}
+
+/**
+ * iavf_is_mac_set_handled - wait for a response to set MAC from PF
+ * @netdev: network interface device structure
+ * @macaddr: MAC address to set
+ *
+ * Returns true on success, false on failure
+ */
+static bool iavf_is_mac_set_handled(struct net_device *netdev,
+				    const u8 *macaddr)
+{
+	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_mac_filter *f;
+	bool ret = false;
+
+	spin_lock_bh(&adapter->mac_vlan_list_lock);
+
+	f = iavf_find_filter(adapter, macaddr);
 
-	return (f == NULL) ? -ENOMEM : 0;
+	if (!f || (!f->add && f->add_handled))
+		ret = true;
+
+	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+
+	return ret;
+}
+
+/**
+ * iavf_set_mac - NDO callback to set port MAC address
+ * @netdev: network interface device structure
+ * @p: pointer to an address structure
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int iavf_set_mac(struct net_device *netdev, void *p)
+{
+	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct sockaddr *addr = p;
+	bool handle_mac = iavf_is_mac_set_handled(netdev, addr->sa_data);
+	int ret;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	ret = iavf_replace_primary_mac(adapter, addr->sa_data);
+
+	if (ret)
+		return ret;
+
+	/* If this is an initial set MAC during VF spawn do not wait */
+	if (adapter->flags & IAVF_FLAG_INITIAL_MAC_SET) {
+		adapter->flags &= ~IAVF_FLAG_INITIAL_MAC_SET;
+		return 0;
+	}
+
+	if (handle_mac)
+		goto done;
+
+	ret = wait_event_interruptible_timeout(adapter->vc_waitqueue, false, msecs_to_jiffies(2500));
+
+	/* If ret < 0 then it means wait was interrupted.
+	 * If ret == 0 then it means we got a timeout.
+	 * else it means we got response for set MAC from PF,
+	 * check if netdev MAC was updated to requested MAC,
+	 * if yes then set MAC succeeded otherwise it failed return -EACCES
+	 */
+	if (ret < 0)
+		return ret;
+
+	if (!ret)
+		return -EAGAIN;
+
+done:
+	if (!ether_addr_equal(netdev->dev_addr, addr->sa_data))
+		return -EACCES;
+
+	return 0;
 }
 
 /**
@@ -2445,6 +2531,8 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 		ether_addr_copy(netdev->perm_addr, adapter->hw.mac.addr);
 	}
 
+	adapter->flags |= IAVF_FLAG_INITIAL_MAC_SET;
+
 	adapter->tx_desc_count = IAVF_DEFAULT_TXD;
 	adapter->rx_desc_count = IAVF_DEFAULT_RXD;
 	err = iavf_init_interrupt_scheme(adapter);
@@ -4678,6 +4766,9 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Setup the wait queue for indicating transition to down status */
 	init_waitqueue_head(&adapter->down_waitqueue);
 
+	/* Setup the wait queue for indicating virtchannel events */
+	init_waitqueue_head(&adapter->vc_waitqueue);
+
 	return 0;
 
 err_ioremap:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 1603e99bae4a..7c98ac1fe458 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -598,6 +598,8 @@ static void iavf_mac_add_ok(struct iavf_adapter *adapter)
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 	list_for_each_entry_safe(f, ftmp, &adapter->mac_filter_list, list) {
 		f->is_new_mac = false;
+		if (!f->add && !f->add_handled)
+			f->add_handled = true;
 	}
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 }
@@ -618,6 +620,9 @@ static void iavf_mac_add_reject(struct iavf_adapter *adapter)
 		if (f->remove && ether_addr_equal(f->macaddr, netdev->dev_addr))
 			f->remove = false;
 
+		if (!f->add && !f->add_handled)
+			f->add_handled = true;
+
 		if (f->is_new_mac) {
 			list_del(&f->list);
 			kfree(f);
@@ -1970,6 +1975,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			iavf_mac_add_reject(adapter);
 			/* restore administratively set MAC address */
 			ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
+			wake_up(&adapter->vc_waitqueue);
 			break;
 		case VIRTCHNL_OP_DEL_VLAN:
 			dev_err(&adapter->pdev->dev, "Failed to delete VLAN filter, error %s\n",
@@ -2134,7 +2140,13 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		if (!v_retval)
 			iavf_mac_add_ok(adapter);
 		if (!ether_addr_equal(netdev->dev_addr, adapter->hw.mac.addr))
-			eth_hw_addr_set(netdev, adapter->hw.mac.addr);
+			if (!ether_addr_equal(netdev->dev_addr,
+					      adapter->hw.mac.addr)) {
+				netif_addr_lock_bh(netdev);
+				eth_hw_addr_set(netdev, adapter->hw.mac.addr);
+				netif_addr_unlock_bh(netdev);
+			}
+		wake_up(&adapter->vc_waitqueue);
 		break;
 	case VIRTCHNL_OP_GET_STATS: {
 		struct iavf_eth_stats *stats =
@@ -2164,10 +2176,11 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			/* restore current mac address */
 			ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
 		} else {
+			netif_addr_lock_bh(netdev);
 			/* refresh current mac address if changed */
-			eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 			ether_addr_copy(netdev->perm_addr,
 					adapter->hw.mac.addr);
+			netif_addr_unlock_bh(netdev);
 		}
 		spin_lock_bh(&adapter->mac_vlan_list_lock);
 		iavf_add_filter(adapter, adapter->hw.mac.addr);
@@ -2203,6 +2216,10 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		}
 		fallthrough;
 	case VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS: {
+		struct iavf_mac_filter *f;
+		bool was_mac_changed;
+		u64 aq_required = 0;
+
 		if (v_opcode == VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS)
 			memcpy(&adapter->vlan_v2_caps, msg,
 			       min_t(u16, msglen,
@@ -2210,6 +2227,46 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		iavf_process_config(adapter);
 		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
+		was_mac_changed = !ether_addr_equal(netdev->dev_addr,
+						    adapter->hw.mac.addr);
+
+		spin_lock_bh(&adapter->mac_vlan_list_lock);
+
+		/* re-add all MAC filters */
+		list_for_each_entry(f, &adapter->mac_filter_list, list) {
+			if (was_mac_changed &&
+			    ether_addr_equal(netdev->dev_addr, f->macaddr))
+				ether_addr_copy(f->macaddr,
+						adapter->hw.mac.addr);
+
+			f->is_new_mac = true;
+			f->add = true;
+			f->add_handled = false;
+			f->remove = false;
+		}
+
+		/* re-add all VLAN filters */
+		if (VLAN_FILTERING_ALLOWED(adapter)) {
+			struct iavf_vlan_filter *vlf;
+
+			if (!list_empty(&adapter->vlan_filter_list)) {
+				list_for_each_entry(vlf,
+						    &adapter->vlan_filter_list,
+						    list)
+					vlf->add = true;
+
+				aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
+			}
+		}
+
+		spin_unlock_bh(&adapter->mac_vlan_list_lock);
+
+		netif_addr_lock_bh(netdev);
+		eth_hw_addr_set(netdev, adapter->hw.mac.addr);
+		netif_addr_unlock_bh(netdev);
+
+		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER |
+			aq_required;
 		}
 		break;
 	case VIRTCHNL_OP_ENABLE_QUEUES:
-- 
2.35.1

