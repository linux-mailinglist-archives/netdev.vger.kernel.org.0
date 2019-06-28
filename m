Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2A35A725
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfF1WtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:49:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:51493 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfF1WtI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:49:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 15:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="338039158"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2019 15:49:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] i40e: Add macvlan support on i40e
Date:   Fri, 28 Jun 2019 15:49:30 -0700
Message-Id: <20190628224932.3389-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>

This patch enables macvlan offloads for i40e. The idea is to use
channels as macvlan interfaces. The channels are VSIs of
type VMDQ. When the first macvlan is created, the maximum number of
channels possible are created. From then on, as a macvlan interface
is created, a macvlan filter is added to these already created
channels (VSIs).

This patch utilizes subordinate device traffic classes to make queue
groups(channels) available for an upper device like a macvlan.

Steps to configure macvlan offloads:
1. ethtool -K ethx l2-fwd-offload on
2. ip link add link ethx name macvlan1 type macvlan
3. ip addr add <address> dev macvlan1
4. ip link set macvlan1 up

Signed-off-by: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      |  27 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c | 497 +++++++++++++++++++-
 2 files changed, 522 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 24e6ce6517a7..84bd06901014 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -27,6 +27,7 @@
 #include <net/ip6_checksum.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
+#include <linux/if_macvlan.h>
 #include <linux/if_bridge.h>
 #include <linux/clocksource.h>
 #include <linux/net_tstamp.h>
@@ -412,6 +413,11 @@ struct i40e_flex_pit {
 	u8 pit_index;
 };
 
+struct i40e_fwd_adapter {
+	struct net_device *netdev;
+	int bit_no;
+};
+
 struct i40e_channel {
 	struct list_head list;
 	bool initialized;
@@ -426,11 +432,25 @@ struct i40e_channel {
 	struct i40e_aqc_vsi_properties_data info;
 
 	u64 max_tx_rate;
+	struct i40e_fwd_adapter *fwd;
 
 	/* track this channel belongs to which VSI */
 	struct i40e_vsi *parent_vsi;
 };
 
+static inline bool i40e_is_channel_macvlan(struct i40e_channel *ch)
+{
+	return !!ch->fwd;
+}
+
+static inline u8 *i40e_channel_mac(struct i40e_channel *ch)
+{
+	if (i40e_is_channel_macvlan(ch))
+		return ch->fwd->netdev->dev_addr;
+	else
+		return NULL;
+}
+
 /* struct that defines the Ethernet device */
 struct i40e_pf {
 	struct pci_dev *pdev;
@@ -813,6 +833,13 @@ struct i40e_vsi {
 	struct list_head ch_list;
 	u16 tc_seid_map[I40E_MAX_TRAFFIC_CLASS];
 
+	/* macvlan fields */
+#define I40E_MAX_MACVLANS		128 /* Max HW vectors - 1 on FVL */
+#define I40E_MIN_MACVLAN_VECTORS	2   /* Min vectors to enable macvlans */
+	DECLARE_BITMAP(fwd_bitmask, I40E_MAX_MACVLANS);
+	struct list_head macvlan_list;
+	int macvlan_cnt;
+
 	void *priv;	/* client driver data reference. */
 
 	/* VSI specific handlers */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 8b0c29b7809b..5361c08328f7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5861,8 +5861,10 @@ static int i40e_add_channel(struct i40e_pf *pf, u16 uplink_seid,
 		return -ENOENT;
 	}
 
-	/* Success, update channel */
-	ch->enabled_tc = enabled_tc;
+	/* Success, update channel, set enabled_tc only if the channel
+	 * is not a macvlan
+	 */
+	ch->enabled_tc = !i40e_is_channel_macvlan(ch) && enabled_tc;
 	ch->seid = ctxt.seid;
 	ch->vsi_number = ctxt.vsi_number;
 	ch->stat_counter_idx = cpu_to_le16(ctxt.info.stat_counter_idx);
@@ -6911,6 +6913,489 @@ static void i40e_vsi_set_default_tc_config(struct i40e_vsi *vsi)
 	}
 }
 
+/**
+ * i40e_del_macvlan_filter
+ * @hw: pointer to the HW structure
+ * @seid: seid of the channel VSI
+ * @macaddr: the mac address to apply as a filter
+ * @aq_err: store the admin Q error
+ *
+ * This function deletes a mac filter on the channel VSI which serves as the
+ * macvlan. Returns 0 on success.
+ **/
+static i40e_status i40e_del_macvlan_filter(struct i40e_hw *hw, u16 seid,
+					   const u8 *macaddr, int *aq_err)
+{
+	struct i40e_aqc_remove_macvlan_element_data element;
+	i40e_status status;
+
+	memset(&element, 0, sizeof(element));
+	ether_addr_copy(element.mac_addr, macaddr);
+	element.vlan_tag = 0;
+	element.flags = I40E_AQC_MACVLAN_DEL_PERFECT_MATCH;
+	status = i40e_aq_remove_macvlan(hw, seid, &element, 1, NULL);
+	*aq_err = hw->aq.asq_last_status;
+
+	return status;
+}
+
+/**
+ * i40e_add_macvlan_filter
+ * @hw: pointer to the HW structure
+ * @seid: seid of the channel VSI
+ * @macaddr: the mac address to apply as a filter
+ * @aq_err: store the admin Q error
+ *
+ * This function adds a mac filter on the channel VSI which serves as the
+ * macvlan. Returns 0 on success.
+ **/
+static i40e_status i40e_add_macvlan_filter(struct i40e_hw *hw, u16 seid,
+					   const u8 *macaddr, int *aq_err)
+{
+	struct i40e_aqc_add_macvlan_element_data element;
+	i40e_status status;
+	u16 cmd_flags = 0;
+
+	ether_addr_copy(element.mac_addr, macaddr);
+	element.vlan_tag = 0;
+	element.queue_number = 0;
+	element.match_method = I40E_AQC_MM_ERR_NO_RES;
+	cmd_flags |= I40E_AQC_MACVLAN_ADD_PERFECT_MATCH;
+	element.flags = cpu_to_le16(cmd_flags);
+	status = i40e_aq_add_macvlan(hw, seid, &element, 1, NULL);
+	*aq_err = hw->aq.asq_last_status;
+
+	return status;
+}
+
+/**
+ * i40e_reset_ch_rings - Reset the queue contexts in a channel
+ * @vsi: the VSI we want to access
+ * @ch: the channel we want to access
+ */
+static void i40e_reset_ch_rings(struct i40e_vsi *vsi, struct i40e_channel *ch)
+{
+	struct i40e_ring *tx_ring, *rx_ring;
+	u16 pf_q;
+	int i;
+
+	for (i = 0; i < ch->num_queue_pairs; i++) {
+		pf_q = ch->base_queue + i;
+		tx_ring = vsi->tx_rings[pf_q];
+		tx_ring->ch = NULL;
+		rx_ring = vsi->rx_rings[pf_q];
+		rx_ring->ch = NULL;
+	}
+}
+
+/**
+ * i40e_free_macvlan_channels
+ * @vsi: the VSI we want to access
+ *
+ * This function frees the Qs of the channel VSI from
+ * the stack and also deletes the channel VSIs which
+ * serve as macvlans.
+ */
+static void i40e_free_macvlan_channels(struct i40e_vsi *vsi)
+{
+	struct i40e_channel *ch, *ch_tmp;
+	int ret;
+
+	if (list_empty(&vsi->macvlan_list))
+		return;
+
+	list_for_each_entry_safe(ch, ch_tmp, &vsi->macvlan_list, list) {
+		struct i40e_vsi *parent_vsi;
+
+		if (i40e_is_channel_macvlan(ch)) {
+			i40e_reset_ch_rings(vsi, ch);
+			clear_bit(ch->fwd->bit_no, vsi->fwd_bitmask);
+			netdev_unbind_sb_channel(vsi->netdev, ch->fwd->netdev);
+			netdev_set_sb_channel(ch->fwd->netdev, 0);
+			kfree(ch->fwd);
+			ch->fwd = NULL;
+		}
+
+		list_del(&ch->list);
+		parent_vsi = ch->parent_vsi;
+		if (!parent_vsi || !ch->initialized) {
+			kfree(ch);
+			continue;
+		}
+
+		/* remove the VSI */
+		ret = i40e_aq_delete_element(&vsi->back->hw, ch->seid,
+					     NULL);
+		if (ret)
+			dev_err(&vsi->back->pdev->dev,
+				"unable to remove channel (%d) for parent VSI(%d)\n",
+				ch->seid, parent_vsi->seid);
+		kfree(ch);
+	}
+	vsi->macvlan_cnt = 0;
+}
+
+/**
+ * i40e_fwd_ring_up - bring the macvlan device up
+ * @vsi: the VSI we want to access
+ * @vdev: macvlan netdevice
+ * @fwd: the private fwd structure
+ */
+static int i40e_fwd_ring_up(struct i40e_vsi *vsi, struct net_device *vdev,
+			    struct i40e_fwd_adapter *fwd)
+{
+	int ret = 0, num_tc = 1,  i, aq_err;
+	struct i40e_channel *ch, *ch_tmp;
+	struct i40e_pf *pf = vsi->back;
+	struct i40e_hw *hw = &pf->hw;
+
+	if (list_empty(&vsi->macvlan_list))
+		return -EINVAL;
+
+	/* Go through the list and find an available channel */
+	list_for_each_entry_safe(ch, ch_tmp, &vsi->macvlan_list, list) {
+		if (!i40e_is_channel_macvlan(ch)) {
+			ch->fwd = fwd;
+			/* record configuration for macvlan interface in vdev */
+			for (i = 0; i < num_tc; i++)
+				netdev_bind_sb_channel_queue(vsi->netdev, vdev,
+							     i,
+							     ch->num_queue_pairs,
+							     ch->base_queue);
+			for (i = 0; i < ch->num_queue_pairs; i++) {
+				struct i40e_ring *tx_ring, *rx_ring;
+				u16 pf_q;
+
+				pf_q = ch->base_queue + i;
+
+				/* Get to TX ring ptr */
+				tx_ring = vsi->tx_rings[pf_q];
+				tx_ring->ch = ch;
+
+				/* Get the RX ring ptr */
+				rx_ring = vsi->rx_rings[pf_q];
+				rx_ring->ch = ch;
+			}
+			break;
+		}
+	}
+
+	/* Guarantee all rings are updated before we update the
+	 * MAC address filter.
+	 */
+	wmb();
+
+	/* Add a mac filter */
+	ret = i40e_add_macvlan_filter(hw, ch->seid, vdev->dev_addr, &aq_err);
+	if (ret) {
+		/* if we cannot add the MAC rule then disable the offload */
+		macvlan_release_l2fw_offload(vdev);
+		for (i = 0; i < ch->num_queue_pairs; i++) {
+			struct i40e_ring *rx_ring;
+			u16 pf_q;
+
+			pf_q = ch->base_queue + i;
+			rx_ring = vsi->rx_rings[pf_q];
+			rx_ring->netdev = NULL;
+		}
+		dev_info(&pf->pdev->dev,
+			 "Error adding mac filter on macvlan err %s, aq_err %s\n",
+			  i40e_stat_str(hw, ret),
+			  i40e_aq_str(hw, aq_err));
+		netdev_err(vdev, "L2fwd offload disabled to L2 filter error\n");
+	}
+
+	return ret;
+}
+
+/**
+ * i40e_setup_macvlans - create the channels which will be macvlans
+ * @vsi: the VSI we want to access
+ * @macvlan_cnt: no. of macvlans to be setup
+ * @qcnt: no. of Qs per macvlan
+ * @vdev: macvlan netdevice
+ */
+static int i40e_setup_macvlans(struct i40e_vsi *vsi, u16 macvlan_cnt, u16 qcnt,
+			       struct net_device *vdev)
+{
+	struct i40e_pf *pf = vsi->back;
+	struct i40e_hw *hw = &pf->hw;
+	struct i40e_vsi_context ctxt;
+	u16 sections, qmap, num_qps;
+	struct i40e_channel *ch;
+	int i, pow, ret = 0;
+	u8 offset = 0;
+
+	if (vsi->type != I40E_VSI_MAIN || !macvlan_cnt)
+		return -EINVAL;
+
+	num_qps = vsi->num_queue_pairs - (macvlan_cnt * qcnt);
+
+	/* find the next higher power-of-2 of num queue pairs */
+	pow = fls(roundup_pow_of_two(num_qps) - 1);
+
+	qmap = (offset << I40E_AQ_VSI_TC_QUE_OFFSET_SHIFT) |
+		(pow << I40E_AQ_VSI_TC_QUE_NUMBER_SHIFT);
+
+	/* Setup context bits for the main VSI */
+	sections = I40E_AQ_VSI_PROP_QUEUE_MAP_VALID;
+	sections |= I40E_AQ_VSI_PROP_SCHED_VALID;
+	memset(&ctxt, 0, sizeof(ctxt));
+	ctxt.seid = vsi->seid;
+	ctxt.pf_num = vsi->back->hw.pf_id;
+	ctxt.vf_num = 0;
+	ctxt.uplink_seid = vsi->uplink_seid;
+	ctxt.info = vsi->info;
+	ctxt.info.tc_mapping[0] = cpu_to_le16(qmap);
+	ctxt.info.mapping_flags |= cpu_to_le16(I40E_AQ_VSI_QUE_MAP_CONTIG);
+	ctxt.info.queue_mapping[0] = cpu_to_le16(vsi->base_queue);
+	ctxt.info.valid_sections |= cpu_to_le16(sections);
+
+	/* Reconfigure RSS for main VSI with new max queue count */
+	vsi->rss_size = max_t(u16, num_qps, qcnt);
+	ret = i40e_vsi_config_rss(vsi);
+	if (ret) {
+		dev_info(&pf->pdev->dev,
+			 "Failed to reconfig RSS for num_queues (%u)\n",
+			 vsi->rss_size);
+		return ret;
+	}
+	vsi->reconfig_rss = true;
+	dev_dbg(&vsi->back->pdev->dev,
+		"Reconfigured RSS with num_queues (%u)\n", vsi->rss_size);
+	vsi->next_base_queue = num_qps;
+	vsi->cnt_q_avail = vsi->num_queue_pairs - num_qps;
+
+	/* Update the VSI after updating the VSI queue-mapping
+	 * information
+	 */
+	ret = i40e_aq_update_vsi_params(hw, &ctxt, NULL);
+	if (ret) {
+		dev_info(&pf->pdev->dev,
+			 "Update vsi tc config failed, err %s aq_err %s\n",
+			 i40e_stat_str(hw, ret),
+			 i40e_aq_str(hw, hw->aq.asq_last_status));
+		return ret;
+	}
+	/* update the local VSI info with updated queue map */
+	i40e_vsi_update_queue_map(vsi, &ctxt);
+	vsi->info.valid_sections = 0;
+
+	/* Create channels for macvlans */
+	INIT_LIST_HEAD(&vsi->macvlan_list);
+	for (i = 0; i < macvlan_cnt; i++) {
+		ch = kzalloc(sizeof(*ch), GFP_KERNEL);
+		if (!ch) {
+			ret = -ENOMEM;
+			goto err_free;
+		}
+		INIT_LIST_HEAD(&ch->list);
+		ch->num_queue_pairs = qcnt;
+		if (!i40e_setup_channel(pf, vsi, ch)) {
+			ret = -EINVAL;
+			goto err_free;
+		}
+		ch->parent_vsi = vsi;
+		vsi->cnt_q_avail -= ch->num_queue_pairs;
+		vsi->macvlan_cnt++;
+		list_add_tail(&ch->list, &vsi->macvlan_list);
+	}
+
+	return ret;
+
+err_free:
+	dev_info(&pf->pdev->dev, "Failed to setup macvlans\n");
+	i40e_free_macvlan_channels(vsi);
+
+	return ret;
+}
+
+/**
+ * i40e_fwd_add - configure macvlans
+ * @netdev: net device to configure
+ * @vdev: macvlan netdevice
+ **/
+static void *i40e_fwd_add(struct net_device *netdev, struct net_device *vdev)
+{
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+	u16 q_per_macvlan = 0, macvlan_cnt = 0, vectors;
+	struct i40e_vsi *vsi = np->vsi;
+	struct i40e_pf *pf = vsi->back;
+	struct i40e_fwd_adapter *fwd;
+	int avail_macvlan, ret;
+
+	if ((pf->flags & I40E_FLAG_DCB_ENABLED)) {
+		netdev_info(netdev, "Macvlans are not supported when DCB is enabled\n");
+		return ERR_PTR(-EINVAL);
+	}
+	if ((pf->flags & I40E_FLAG_TC_MQPRIO)) {
+		netdev_info(netdev, "Macvlans are not supported when HW TC offload is on\n");
+		return ERR_PTR(-EINVAL);
+	}
+	if (pf->num_lan_msix < I40E_MIN_MACVLAN_VECTORS) {
+		netdev_info(netdev, "Not enough vectors available to support macvlans\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* The macvlan device has to be a single Q device so that the
+	 * tc_to_txq field can be reused to pick the tx queue.
+	 */
+	if (netif_is_multiqueue(vdev))
+		return ERR_PTR(-ERANGE);
+
+	if (!vsi->macvlan_cnt) {
+		/* reserve bit 0 for the pf device */
+		set_bit(0, vsi->fwd_bitmask);
+
+		/* Try to reserve as many queues as possible for macvlans. First
+		 * reserve 3/4th of max vectors, then half, then quarter and
+		 * calculate Qs per macvlan as you go
+		 */
+		vectors = pf->num_lan_msix;
+		if (vectors <= I40E_MAX_MACVLANS && vectors > 64) {
+			/* allocate 4 Qs per macvlan and 32 Qs to the PF*/
+			q_per_macvlan = 4;
+			macvlan_cnt = (vectors - 32) / 4;
+		} else if (vectors <= 64 && vectors > 32) {
+			/* allocate 2 Qs per macvlan and 16 Qs to the PF*/
+			q_per_macvlan = 2;
+			macvlan_cnt = (vectors - 16) / 2;
+		} else if (vectors <= 32 && vectors > 16) {
+			/* allocate 1 Q per macvlan and 16 Qs to the PF*/
+			q_per_macvlan = 1;
+			macvlan_cnt = vectors - 16;
+		} else if (vectors <= 16 && vectors > 8) {
+			/* allocate 1 Q per macvlan and 8 Qs to the PF */
+			q_per_macvlan = 1;
+			macvlan_cnt = vectors - 8;
+		} else {
+			/* allocate 1 Q per macvlan and 1 Q to the PF */
+			q_per_macvlan = 1;
+			macvlan_cnt = vectors - 1;
+		}
+
+		if (macvlan_cnt == 0)
+			return ERR_PTR(-EBUSY);
+
+		/* Quiesce VSI queues */
+		i40e_quiesce_vsi(vsi);
+
+		/* sets up the macvlans but does not "enable" them */
+		ret = i40e_setup_macvlans(vsi, macvlan_cnt, q_per_macvlan,
+					  vdev);
+		if (ret)
+			return ERR_PTR(ret);
+
+		/* Unquiesce VSI */
+		i40e_unquiesce_vsi(vsi);
+	}
+	avail_macvlan = find_first_zero_bit(vsi->fwd_bitmask,
+					    vsi->macvlan_cnt);
+	if (avail_macvlan >= I40E_MAX_MACVLANS)
+		return ERR_PTR(-EBUSY);
+
+	/* create the fwd struct */
+	fwd = kzalloc(sizeof(*fwd), GFP_KERNEL);
+	if (!fwd)
+		return ERR_PTR(-ENOMEM);
+
+	set_bit(avail_macvlan, vsi->fwd_bitmask);
+	fwd->bit_no = avail_macvlan;
+	netdev_set_sb_channel(vdev, avail_macvlan);
+	fwd->netdev = vdev;
+
+	if (!netif_running(netdev))
+		return fwd;
+
+	/* Set fwd ring up */
+	ret = i40e_fwd_ring_up(vsi, vdev, fwd);
+	if (ret) {
+		/* unbind the queues and drop the subordinate channel config */
+		netdev_unbind_sb_channel(netdev, vdev);
+		netdev_set_sb_channel(vdev, 0);
+
+		kfree(fwd);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return fwd;
+}
+
+/**
+ * i40e_del_all_macvlans - Delete all the mac filters on the channels
+ * @vsi: the VSI we want to access
+ */
+static void i40e_del_all_macvlans(struct i40e_vsi *vsi)
+{
+	struct i40e_channel *ch, *ch_tmp;
+	struct i40e_pf *pf = vsi->back;
+	struct i40e_hw *hw = &pf->hw;
+	int aq_err, ret = 0;
+
+	if (list_empty(&vsi->macvlan_list))
+		return;
+
+	list_for_each_entry_safe(ch, ch_tmp, &vsi->macvlan_list, list) {
+		if (i40e_is_channel_macvlan(ch)) {
+			ret = i40e_del_macvlan_filter(hw, ch->seid,
+						      i40e_channel_mac(ch),
+						      &aq_err);
+			if (!ret) {
+				/* Reset queue contexts */
+				i40e_reset_ch_rings(vsi, ch);
+				clear_bit(ch->fwd->bit_no, vsi->fwd_bitmask);
+				netdev_unbind_sb_channel(vsi->netdev,
+							 ch->fwd->netdev);
+				netdev_set_sb_channel(ch->fwd->netdev, 0);
+				kfree(ch->fwd);
+				ch->fwd = NULL;
+			}
+		}
+	}
+}
+
+/**
+ * i40e_fwd_del - delete macvlan interfaces
+ * @netdev: net device to configure
+ * @vdev: macvlan netdevice
+ */
+static void i40e_fwd_del(struct net_device *netdev, void *vdev)
+{
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+	struct i40e_fwd_adapter *fwd = vdev;
+	struct i40e_channel *ch, *ch_tmp;
+	struct i40e_vsi *vsi = np->vsi;
+	struct i40e_pf *pf = vsi->back;
+	struct i40e_hw *hw = &pf->hw;
+	int aq_err, ret = 0;
+
+	/* Find the channel associated with the macvlan and del mac filter */
+	list_for_each_entry_safe(ch, ch_tmp, &vsi->macvlan_list, list) {
+		if (i40e_is_channel_macvlan(ch) &&
+		    ether_addr_equal(i40e_channel_mac(ch),
+				     fwd->netdev->dev_addr)) {
+			ret = i40e_del_macvlan_filter(hw, ch->seid,
+						      i40e_channel_mac(ch),
+						      &aq_err);
+			if (!ret) {
+				/* Reset queue contexts */
+				i40e_reset_ch_rings(vsi, ch);
+				clear_bit(ch->fwd->bit_no, vsi->fwd_bitmask);
+				netdev_unbind_sb_channel(netdev, fwd->netdev);
+				netdev_set_sb_channel(fwd->netdev, 0);
+				kfree(ch->fwd);
+				ch->fwd = NULL;
+			} else {
+				dev_info(&pf->pdev->dev,
+					 "Error deleting mac filter on macvlan err %s, aq_err %s\n",
+					  i40e_stat_str(hw, ret),
+					  i40e_aq_str(hw, aq_err));
+			}
+			break;
+		}
+	}
+}
+
 /**
  * i40e_setup_tc - configure multiple traffic classes
  * @netdev: net device to configure
@@ -11665,6 +12150,9 @@ static int i40e_set_features(struct net_device *netdev,
 		return -EINVAL;
 	}
 
+	if (!(features & NETIF_F_HW_L2FW_DOFFLOAD) && vsi->macvlan_cnt)
+		i40e_del_all_macvlans(vsi);
+
 	need_reset = i40e_set_ntuple(pf, features);
 
 	if (need_reset)
@@ -12409,6 +12897,8 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_bpf		= i40e_xdp,
 	.ndo_xdp_xmit		= i40e_xdp_xmit,
 	.ndo_xsk_async_xmit	= i40e_xsk_async_xmit,
+	.ndo_dfwd_add_station	= i40e_fwd_add,
+	.ndo_dfwd_del_station	= i40e_fwd_del,
 };
 
 /**
@@ -12468,6 +12958,9 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	/* record features VLANs can make use of */
 	netdev->vlan_features |= hw_enc_features | NETIF_F_TSO_MANGLEID;
 
+	/* enable macvlan offloads */
+	netdev->hw_features |= NETIF_F_HW_L2FW_DOFFLOAD;
+
 	hw_features = hw_enc_features		|
 		      NETIF_F_HW_VLAN_CTAG_TX	|
 		      NETIF_F_HW_VLAN_CTAG_RX;
-- 
2.21.0

