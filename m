Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8915A6F57
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 23:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiH3Vnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 17:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbiH3Vn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 17:43:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DE68B9BD
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 14:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661895797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zFRR0acvkckiwuQhdIkt5k47ZpuUerQuvus48A9VabU=;
        b=hyRbIDMt22mqiDUTTIjnkGonGdV2nfsap+SYsGKQbvoVm608iFGb18kvLP1xS/AnA8FXOB
        ucbI8hiXoaWBv/reqyDiqyHPUbyQyDFdy0Bp1Vb+y919F400OnAluieG08DsCeF/mrrtug
        sft+OfumPmro8VS1Aw/eH/sS2yrJTiQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-4uKP6pM4O_uYQBQbLLyfJA-1; Tue, 30 Aug 2022 17:43:14 -0400
X-MC-Unique: 4uKP6pM4O_uYQBQbLLyfJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF57429AB3FF;
        Tue, 30 Aug 2022 21:43:13 +0000 (UTC)
Received: from swamp.redhat.com (unknown [10.40.194.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6946C1415117;
        Tue, 30 Aug 2022 21:43:12 +0000 (UTC)
From:   Petr Oros <poros@redhat.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Revert "iavf: Add waiting for response from PF in set mac"
Date:   Tue, 30 Aug 2022 23:43:09 +0200
Message-Id: <20220830214309.3813378-2-poros@redhat.com>
In-Reply-To: <20220830214309.3813378-1-poros@redhat.com>
References: <20220830214309.3813378-1-poros@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change caused a regressions with MAC address changing.
It is not possible to simple fix issues caused by this patch.
It is better revert/rework it.

[root@host ~]# ethtool -i enp65s0f0
driver: ice
version: 5.19.4-200.fc36.x86_64
firmware-version: 3.20 0x8000d83e 1.3146.0

- Change MAC for VF
[root@host ~]# echo 1 > /sys/class/net/enp65s0f0/device/sriov_numvfs
[root@host ~]# ip link set enp65s0f0v0 up
[root@host ~]# ip link set enp65s0f0v0 addr 00:11:22:33:44:55
RTNETLINK answers: Permission denied

- Add VF to bond
[root@host ~]# echo 2 > /sys/class/net/enp65s0f0/device/sriov_numvfs
[root@host ~]# ip link add bond0 type bond
[root@host ~]# ip link set enp65s0f0v0 down
[root@host ~]# ip link set enp65s0f0v1 down
[root@host ~]# ip link set enp65s0f0v0 master bond0
RTNETLINK answers: Permission denied
dmesg:
bond0: (slave enp65s0f0v1): Error -13 calling set_mac_address

This reverts commit 35a2443d0910fdd6ce29d4f724447ad7029e8f23.

Signed-off-by: Petr Oros <poros@redhat.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |   7 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 127 +++---------------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  61 +--------
 3 files changed, 21 insertions(+), 174 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 3f6187c164240f..a988c08e906f1e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -146,8 +146,7 @@ struct iavf_mac_filter {
 		u8 remove:1;        /* filter needs to be removed */
 		u8 add:1;           /* filter needs to be added */
 		u8 is_primary:1;    /* filter is a default VF MAC */
-		u8 add_handled:1;   /* received response for filter add */
-		u8 padding:3;
+		u8 padding:4;
 	};
 };
 
@@ -253,7 +252,6 @@ struct iavf_adapter {
 	struct work_struct adminq_task;
 	struct delayed_work client_task;
 	wait_queue_head_t down_waitqueue;
-	wait_queue_head_t vc_waitqueue;
 	struct iavf_q_vector *q_vectors;
 	struct list_head vlan_filter_list;
 	struct list_head mac_filter_list;
@@ -298,7 +296,6 @@ struct iavf_adapter {
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
 #define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
 #define IAVF_FLAG_REINIT_MSIX_NEEDED		BIT(20)
-#define IAVF_FLAG_INITIAL_MAC_SET		BIT(23)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
 	/* flags for admin queue service task */
@@ -576,8 +573,6 @@ void iavf_enable_vlan_stripping_v2(struct iavf_adapter *adapter, u16 tpid);
 void iavf_disable_vlan_stripping_v2(struct iavf_adapter *adapter, u16 tpid);
 void iavf_enable_vlan_insertion_v2(struct iavf_adapter *adapter, u16 tpid);
 void iavf_disable_vlan_insertion_v2(struct iavf_adapter *adapter, u16 tpid);
-int iavf_replace_primary_mac(struct iavf_adapter *adapter,
-			     const u8 *new_mac);
 void
 iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
 			       netdev_features_t prev_features,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f39440ad5c50d6..aa280c892d1b99 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -978,7 +978,6 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 
 		list_add_tail(&f->list, &adapter->mac_filter_list);
 		f->add = true;
-		f->add_handled = false;
 		f->is_new_mac = true;
 		f->is_primary = ether_addr_equal(macaddr, adapter->hw.mac.addr);
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
@@ -990,132 +989,47 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 }
 
 /**
- * iavf_replace_primary_mac - Replace current primary address
- * @adapter: board private structure
- * @new_mac: new MAC address to be applied
- *
- * Replace current dev_addr and send request to PF for removal of previous
- * primary MAC address filter and addition of new primary MAC filter.
- * Return 0 for success, -ENOMEM for failure.
+ * iavf_set_mac - NDO callback to set port mac address
+ * @netdev: network interface device structure
+ * @p: pointer to an address structure
  *
- * Do not call this with mac_vlan_list_lock!
+ * Returns 0 on success, negative on failure
  **/
-int iavf_replace_primary_mac(struct iavf_adapter *adapter,
-			     const u8 *new_mac)
+static int iavf_set_mac(struct net_device *netdev, void *p)
 {
+	struct iavf_adapter *adapter = netdev_priv(netdev);
 	struct iavf_hw *hw = &adapter->hw;
 	struct iavf_mac_filter *f;
+	struct sockaddr *addr = p;
 
-	spin_lock_bh(&adapter->mac_vlan_list_lock);
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
 
-	list_for_each_entry(f, &adapter->mac_filter_list, list) {
-		f->is_primary = false;
-	}
+	if (ether_addr_equal(netdev->dev_addr, addr->sa_data))
+		return 0;
+
+	spin_lock_bh(&adapter->mac_vlan_list_lock);
 
 	f = iavf_find_filter(adapter, hw->mac.addr);
 	if (f) {
 		f->remove = true;
+		f->is_primary = true;
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_MAC_FILTER;
 	}
 
-	f = iavf_add_filter(adapter, new_mac);
-
+	f = iavf_add_filter(adapter, addr->sa_data);
 	if (f) {
-		/* Always send the request to add if changing primary MAC
-		 * even if filter is already present on the list
-		 */
 		f->is_primary = true;
-		f->add = true;
-		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
-		ether_addr_copy(hw->mac.addr, new_mac);
+		ether_addr_copy(hw->mac.addr, addr->sa_data);
 	}
 
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 
 	/* schedule the watchdog task to immediately process the request */
-	if (f) {
+	if (f)
 		queue_work(iavf_wq, &adapter->watchdog_task.work);
-		return 0;
-	}
-	return -ENOMEM;
-}
-
-/**
- * iavf_is_mac_set_handled - wait for a response to set MAC from PF
- * @netdev: network interface device structure
- * @macaddr: MAC address to set
- *
- * Returns true on success, false on failure
- */
-static bool iavf_is_mac_set_handled(struct net_device *netdev,
-				    const u8 *macaddr)
-{
-	struct iavf_adapter *adapter = netdev_priv(netdev);
-	struct iavf_mac_filter *f;
-	bool ret = false;
-
-	spin_lock_bh(&adapter->mac_vlan_list_lock);
-
-	f = iavf_find_filter(adapter, macaddr);
 
-	if (!f || (!f->add && f->add_handled))
-		ret = true;
-
-	spin_unlock_bh(&adapter->mac_vlan_list_lock);
-
-	return ret;
-}
-
-/**
- * iavf_set_mac - NDO callback to set port MAC address
- * @netdev: network interface device structure
- * @p: pointer to an address structure
- *
- * Returns 0 on success, negative on failure
- */
-static int iavf_set_mac(struct net_device *netdev, void *p)
-{
-	struct iavf_adapter *adapter = netdev_priv(netdev);
-	struct sockaddr *addr = p;
-	bool handle_mac = iavf_is_mac_set_handled(netdev, addr->sa_data);
-	int ret;
-
-	if (!is_valid_ether_addr(addr->sa_data))
-		return -EADDRNOTAVAIL;
-
-	ret = iavf_replace_primary_mac(adapter, addr->sa_data);
-
-	if (ret)
-		return ret;
-
-	/* If this is an initial set MAC during VF spawn do not wait */
-	if (adapter->flags & IAVF_FLAG_INITIAL_MAC_SET) {
-		adapter->flags &= ~IAVF_FLAG_INITIAL_MAC_SET;
-		return 0;
-	}
-
-	if (handle_mac)
-		goto done;
-
-	ret = wait_event_interruptible_timeout(adapter->vc_waitqueue, false, msecs_to_jiffies(2500));
-
-	/* If ret < 0 then it means wait was interrupted.
-	 * If ret == 0 then it means we got a timeout.
-	 * else it means we got response for set MAC from PF,
-	 * check if netdev MAC was updated to requested MAC,
-	 * if yes then set MAC succeeded otherwise it failed return -EACCES
-	 */
-	if (ret < 0)
-		return ret;
-
-	if (!ret)
-		return -EAGAIN;
-
-done:
-	if (!ether_addr_equal(netdev->dev_addr, addr->sa_data))
-		return -EACCES;
-
-	return 0;
+	return (f == NULL) ? -ENOMEM : 0;
 }
 
 /**
@@ -2531,8 +2445,6 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 		ether_addr_copy(netdev->perm_addr, adapter->hw.mac.addr);
 	}
 
-	adapter->flags |= IAVF_FLAG_INITIAL_MAC_SET;
-
 	adapter->tx_desc_count = IAVF_DEFAULT_TXD;
 	adapter->rx_desc_count = IAVF_DEFAULT_RXD;
 	err = iavf_init_interrupt_scheme(adapter);
@@ -4831,9 +4743,6 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Setup the wait queue for indicating transition to down status */
 	init_waitqueue_head(&adapter->down_waitqueue);
 
-	/* Setup the wait queue for indicating virtchannel events */
-	init_waitqueue_head(&adapter->vc_waitqueue);
-
 	return 0;
 
 err_ioremap:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 15ee85dc33bd81..0265eaeb100a57 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -594,8 +594,6 @@ static void iavf_mac_add_ok(struct iavf_adapter *adapter)
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 	list_for_each_entry_safe(f, ftmp, &adapter->mac_filter_list, list) {
 		f->is_new_mac = false;
-		if (!f->add && !f->add_handled)
-			f->add_handled = true;
 	}
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 }
@@ -616,9 +614,6 @@ static void iavf_mac_add_reject(struct iavf_adapter *adapter)
 		if (f->remove && ether_addr_equal(f->macaddr, netdev->dev_addr))
 			f->remove = false;
 
-		if (!f->add && !f->add_handled)
-			f->add_handled = true;
-
 		if (f->is_new_mac) {
 			list_del(&f->list);
 			kfree(f);
@@ -1971,7 +1966,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			iavf_mac_add_reject(adapter);
 			/* restore administratively set MAC address */
 			ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
-			wake_up(&adapter->vc_waitqueue);
 			break;
 		case VIRTCHNL_OP_DEL_VLAN:
 			dev_err(&adapter->pdev->dev, "Failed to delete VLAN filter, error %s\n",
@@ -2136,13 +2130,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		if (!v_retval)
 			iavf_mac_add_ok(adapter);
 		if (!ether_addr_equal(netdev->dev_addr, adapter->hw.mac.addr))
-			if (!ether_addr_equal(netdev->dev_addr,
-					      adapter->hw.mac.addr)) {
-				netif_addr_lock_bh(netdev);
-				eth_hw_addr_set(netdev, adapter->hw.mac.addr);
-				netif_addr_unlock_bh(netdev);
-			}
-		wake_up(&adapter->vc_waitqueue);
+			eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 		break;
 	case VIRTCHNL_OP_GET_STATS: {
 		struct iavf_eth_stats *stats =
@@ -2172,11 +2160,10 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			/* restore current mac address */
 			ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
 		} else {
-			netif_addr_lock_bh(netdev);
 			/* refresh current mac address if changed */
+			eth_hw_addr_set(netdev, adapter->hw.mac.addr);
 			ether_addr_copy(netdev->perm_addr,
 					adapter->hw.mac.addr);
-			netif_addr_unlock_bh(netdev);
 		}
 		spin_lock_bh(&adapter->mac_vlan_list_lock);
 		iavf_add_filter(adapter, adapter->hw.mac.addr);
@@ -2212,10 +2199,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		}
 		fallthrough;
 	case VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS: {
-		struct iavf_mac_filter *f;
-		bool was_mac_changed;
-		u64 aq_required = 0;
-
 		if (v_opcode == VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS)
 			memcpy(&adapter->vlan_v2_caps, msg,
 			       min_t(u16, msglen,
@@ -2223,46 +2206,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		iavf_process_config(adapter);
 		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
-		was_mac_changed = !ether_addr_equal(netdev->dev_addr,
-						    adapter->hw.mac.addr);
-
-		spin_lock_bh(&adapter->mac_vlan_list_lock);
-
-		/* re-add all MAC filters */
-		list_for_each_entry(f, &adapter->mac_filter_list, list) {
-			if (was_mac_changed &&
-			    ether_addr_equal(netdev->dev_addr, f->macaddr))
-				ether_addr_copy(f->macaddr,
-						adapter->hw.mac.addr);
-
-			f->is_new_mac = true;
-			f->add = true;
-			f->add_handled = false;
-			f->remove = false;
-		}
-
-		/* re-add all VLAN filters */
-		if (VLAN_FILTERING_ALLOWED(adapter)) {
-			struct iavf_vlan_filter *vlf;
-
-			if (!list_empty(&adapter->vlan_filter_list)) {
-				list_for_each_entry(vlf,
-						    &adapter->vlan_filter_list,
-						    list)
-					vlf->add = true;
-
-				aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
-			}
-		}
-
-		spin_unlock_bh(&adapter->mac_vlan_list_lock);
-
-		netif_addr_lock_bh(netdev);
-		eth_hw_addr_set(netdev, adapter->hw.mac.addr);
-		netif_addr_unlock_bh(netdev);
-
-		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER |
-			aq_required;
 		}
 		break;
 	case VIRTCHNL_OP_ENABLE_QUEUES:
-- 
2.37.2

