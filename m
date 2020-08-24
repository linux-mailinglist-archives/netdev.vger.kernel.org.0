Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0337D25068E
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgHXRfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:35:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:29869 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgHXRfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 13:35:02 -0400
IronPort-SDR: Ickmqah2ffhjEdSFrPeC4J1ttgRmwywjUmztT6dQF8ofvIhTG2XCLzC+1MwjWctYR3ZQjJW2vO
 u7lHhsveFfMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="157008603"
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="157008603"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:33:27 -0700
IronPort-SDR: I2hPt4ds6lNO8GB2lgsLNTbytUxSO42B6kSE4TS5u5XNl69jlC576HtrQcerqZmrT0R0Y5dste
 B3N49SrYlh2A==
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="336245374"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:33:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: [net-next v5 13/15] iecm: Add ethtool
Date:   Mon, 24 Aug 2020 10:33:04 -0700
Message-Id: <20200824173306.3178343-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Implement ethtool interface for the common module.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/iecm/iecm_ethtool.c    | 1034 ++++++++++++++++-
 drivers/net/ethernet/intel/iecm/iecm_lib.c    |  143 ++-
 2 files changed, 1173 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iecm/iecm_ethtool.c b/drivers/net/ethernet/intel/iecm/iecm_ethtool.c
index a6532592f2f4..9b23541f81c4 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_ethtool.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_ethtool.c
@@ -3,6 +3,1038 @@
 
 #include <linux/net/intel/iecm.h>
 
+/**
+ * iecm_get_rxnfc - command to get RX flow classification rules
+ * @netdev: network interface device structure
+ * @cmd: ethtool rxnfc command
+ * @rule_locs: pointer to store rule locations
+ *
+ * Returns Success if the command is supported.
+ */
+static int iecm_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
+			  u32 __always_unused *rule_locs)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	int ret = -EOPNOTSUPP;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXRINGS:
+		cmd->data = vport->num_rxq;
+		ret = 0;
+		break;
+	case ETHTOOL_GRXFH:
+		netdev_info(netdev, "RSS hash info is not available\n");
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * iecm_get_rxfh_key_size - get the RSS hash key size
+ * @netdev: network interface device structure
+ *
+ * Returns the table size.
+ */
+static u32 iecm_get_rxfh_key_size(struct net_device *netdev)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+
+	if (!iecm_is_cap_ena(vport->adapter, VIRTCHNL_CAP_RSS)) {
+		dev_info(&vport->adapter->pdev->dev, "RSS is not supported on this device\n");
+		return 0;
+	}
+
+	return vport->adapter->rss_data.rss_key_size;
+}
+
+/**
+ * iecm_get_rxfh_indir_size - get the Rx flow hash indirection table size
+ * @netdev: network interface device structure
+ *
+ * Returns the table size.
+ */
+static u32 iecm_get_rxfh_indir_size(struct net_device *netdev)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+
+	if (!iecm_is_cap_ena(vport->adapter, VIRTCHNL_CAP_RSS)) {
+		dev_info(&vport->adapter->pdev->dev, "RSS is not supported on this device\n");
+		return 0;
+	}
+
+	return vport->adapter->rss_data.rss_lut_size;
+}
+
+/**
+ * iecm_find_virtual_qid - Finds the virtual RX qid from the absolute RX qid
+ * @vport: virtual port structure
+ * @qid_list: List of the RX qid's
+ * @abs_rx_qid: absolute RX qid
+ *
+ * Returns the virtual RX QID.
+ */
+static u32 iecm_find_virtual_qid(struct iecm_vport *vport, u16 *qid_list,
+				 u32 abs_rx_qid)
+{
+	u32 i;
+
+	for (i = 0; i < vport->num_rxq; i++)
+		if ((u32)qid_list[i] == abs_rx_qid)
+			break;
+	return i;
+}
+
+/**
+ * iecm_get_rxfh - get the Rx flow hash indirection table
+ * @netdev: network interface device structure
+ * @indir: indirection table
+ * @key: hash key
+ * @hfunc: hash function in use
+ *
+ * Reads the indirection table directly from the hardware. Always returns 0.
+ */
+static int iecm_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
+			 u8 *hfunc)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	struct iecm_adapter *adapter;
+	u16 i, *qid_list;
+	u32 abs_qid;
+
+	adapter = vport->adapter;
+
+	if (!iecm_is_cap_ena(adapter, VIRTCHNL_CAP_RSS)) {
+		dev_info(&vport->adapter->pdev->dev, "RSS is not supported on this device\n");
+		return 0;
+	}
+
+	if (adapter->state != __IECM_UP)
+		return 0;
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+
+	if (key)
+		memcpy(key, adapter->rss_data.rss_key,
+		       adapter->rss_data.rss_key_size);
+
+	qid_list = kcalloc(vport->num_rxq, sizeof(u16), GFP_KERNEL);
+	if (!qid_list)
+		return -ENOMEM;
+
+	iecm_get_rx_qid_list(vport, qid_list);
+
+	if (indir)
+		/* Each 32 bits pointed by 'indir' is stored with a lut entry */
+		for (i = 0; i < adapter->rss_data.rss_lut_size; i++) {
+			abs_qid = (u32)adapter->rss_data.rss_lut[i];
+			indir[i] = iecm_find_virtual_qid(vport, qid_list,
+							 abs_qid);
+		}
+
+	kfree(qid_list);
+
+	return 0;
+}
+
+/**
+ * iecm_set_rxfh - set the Rx flow hash indirection table
+ * @netdev: network interface device structure
+ * @indir: indirection table
+ * @key: hash key
+ * @hfunc: hash function to use
+ *
+ * Returns -EINVAL if the table specifies an invalid queue id, otherwise
+ * returns 0 after programming the table.
+ */
+static int iecm_set_rxfh(struct net_device *netdev, const u32 *indir,
+			 const u8 *key, const u8 hfunc)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	struct iecm_adapter *adapter;
+	u16 *qid_list;
+	u16 lut;
+
+	adapter = vport->adapter;
+
+	if (!iecm_is_cap_ena(adapter, VIRTCHNL_CAP_RSS)) {
+		dev_info(&adapter->pdev->dev, "RSS is not supported on this device\n");
+		return 0;
+	}
+	if (adapter->state != __IECM_UP)
+		return 0;
+
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
+	if (key)
+		memcpy(adapter->rss_data.rss_key, key,
+		       adapter->rss_data.rss_key_size);
+
+	qid_list = kcalloc(vport->num_rxq, sizeof(u16), GFP_KERNEL);
+	if (!qid_list)
+		return -ENOMEM;
+
+	iecm_get_rx_qid_list(vport, qid_list);
+
+	if (indir) {
+		for (lut = 0; lut < adapter->rss_data.rss_lut_size; lut++) {
+			int index = indir[lut];
+
+			adapter->rss_data.rss_lut[lut] = qid_list[index];
+		}
+	}
+
+	kfree(qid_list);
+
+	return iecm_config_rss(vport);
+}
+
+/**
+ * iecm_get_channels: get the number of channels supported by the device
+ * @netdev: network interface device structure
+ * @ch: channel information structure
+ *
+ * Report maximum of TX and RX. Report one extra channel to match our mailbox
+ * Queue.
+ */
+static void iecm_get_channels(struct net_device *netdev,
+			      struct ethtool_channels *ch)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	unsigned int combined;
+
+	combined = min(vport->num_txq, vport->num_rxq);
+
+	/* Report maximum channels */
+	ch->max_combined = IECM_MAX_Q;
+
+	ch->max_other = IECM_MAX_NONQ;
+	ch->other_count = IECM_MAX_NONQ;
+
+	ch->combined_count = combined;
+	ch->rx_count = vport->num_rxq - combined;
+	ch->tx_count = vport->num_txq - combined;
+}
+
+/**
+ * iecm_set_channels: set the new channel count
+ * @netdev: network interface device structure
+ * @ch: channel information structure
+ *
+ * Negotiate a new number of channels with CP. Returns 0 on success, negative
+ * on failure.
+ */
+static int iecm_set_channels(struct net_device *netdev,
+			     struct ethtool_channels *ch)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	int num_req_q = ch->combined_count;
+
+	if (num_req_q == max(vport->num_txq, vport->num_rxq))
+		return 0;
+
+	vport->adapter->config_data.num_req_qs = num_req_q;
+
+	return iecm_initiate_soft_reset(vport, __IECM_SR_Q_CHANGE);
+}
+
+/**
+ * iecm_get_ringparam - Get ring parameters
+ * @netdev: network interface device structure
+ * @ring: ethtool ringparam structure
+ *
+ * Returns current ring parameters. TX and RX rings are reported separately,
+ * but the number of rings is not reported.
+ */
+static void iecm_get_ringparam(struct net_device *netdev,
+			       struct ethtool_ringparam *ring)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+
+	ring->rx_max_pending = IECM_MAX_RXQ_DESC;
+	ring->tx_max_pending = IECM_MAX_TXQ_DESC;
+	ring->rx_pending = vport->rxq_desc_count;
+	ring->tx_pending = vport->txq_desc_count;
+}
+
+/**
+ * iecm_set_ringparam - Set ring parameters
+ * @netdev: network interface device structure
+ * @ring: ethtool ringparam structure
+ *
+ * Sets ring parameters. TX and RX rings are controlled separately, but the
+ * number of rings is not specified, so all rings get the same settings.
+ */
+static int iecm_set_ringparam(struct net_device *netdev,
+			      struct ethtool_ringparam *ring)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	u32 new_rx_count, new_tx_count;
+
+	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
+		return -EINVAL;
+
+	new_tx_count = ALIGN(ring->tx_pending, IECM_REQ_DESC_MULTIPLE);
+	new_rx_count = ALIGN(ring->rx_pending, IECM_REQ_DESC_MULTIPLE);
+
+	/* if nothing to do return success */
+	if (new_tx_count == vport->txq_desc_count &&
+	    new_rx_count == vport->rxq_desc_count)
+		return 0;
+
+	vport->adapter->config_data.num_req_txq_desc = new_tx_count;
+	vport->adapter->config_data.num_req_rxq_desc = new_rx_count;
+
+	return iecm_initiate_soft_reset(vport, __IECM_SR_Q_DESC_CHANGE);
+}
+
+/**
+ * struct iecm_stats - definition for an ethtool statistic
+ * @stat_string: statistic name to display in ethtool -S output
+ * @sizeof_stat: the sizeof() the stat, must be no greater than sizeof(u64)
+ * @stat_offset: offsetof() the stat from a base pointer
+ *
+ * This structure defines a statistic to be added to the ethtool stats buffer.
+ * It defines a statistic as offset from a common base pointer. Stats should
+ * be defined in constant arrays using the IECM_STAT macro, with every element
+ * of the array using the same _type for calculating the sizeof_stat and
+ * stat_offset.
+ *
+ * The @sizeof_stat is expected to be sizeof(u8), sizeof(u16), sizeof(u32) or
+ * sizeof(u64). Other sizes are not expected and will produce a WARN_ONCE from
+ * the iecm_add_ethtool_stat() helper function.
+ *
+ * The @stat_string is interpreted as a format string, allowing formatted
+ * values to be inserted while looping over multiple structures for a given
+ * statistics array. Thus, every statistic string in an array should have the
+ * same type and number of format specifiers, to be formatted by variadic
+ * arguments to the iecm_add_stat_string() helper function.
+ */
+struct iecm_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	int sizeof_stat;
+	int stat_offset;
+};
+
+/* Helper macro to define an iecm_stat structure with proper size and type.
+ * Use this when defining constant statistics arrays. Note that @_type expects
+ * only a type name and is used multiple times.
+ */
+#define IECM_STAT(_type, _name, _stat) { \
+	.stat_string = _name, \
+	.sizeof_stat = sizeof_field(_type, _stat), \
+	.stat_offset = offsetof(_type, _stat) \
+}
+
+/* Helper macro for defining some statistics related to queues */
+#define IECM_QUEUE_STAT(_name, _stat) \
+	IECM_STAT(struct iecm_queue, _name, _stat)
+
+/* Stats associated with a Tx queue */
+static const struct iecm_stats iecm_gstrings_tx_queue_stats[] = {
+	IECM_QUEUE_STAT("packets", q_stats.tx.packets),
+	IECM_QUEUE_STAT("bytes", q_stats.tx.bytes),
+};
+
+/* Stats associated with an Rx queue */
+static const struct iecm_stats iecm_gstrings_rx_queue_stats[] = {
+	IECM_QUEUE_STAT("packets", q_stats.rx.packets),
+	IECM_QUEUE_STAT("bytes", q_stats.rx.bytes),
+	IECM_QUEUE_STAT("csum_complete", q_stats.rx.csum_complete),
+	IECM_QUEUE_STAT("csum_unnecessary", q_stats.rx.csum_unnecessary),
+	IECM_QUEUE_STAT("csum_err", q_stats.rx.csum_err),
+	IECM_QUEUE_STAT("hsplit", q_stats.rx.hsplit),
+	IECM_QUEUE_STAT("hsplit_buf_overflow", q_stats.rx.hsplit_hbo),
+};
+
+#define IECM_TX_QUEUE_STATS_LEN		ARRAY_SIZE(iecm_gstrings_tx_queue_stats)
+#define IECM_RX_QUEUE_STATS_LEN		ARRAY_SIZE(iecm_gstrings_rx_queue_stats)
+
+/**
+ * __iecm_add_stat_strings - copy stat strings into ethtool buffer
+ * @p: ethtool supplied buffer
+ * @stats: stat definitions array
+ * @size: size of the stats array
+ * @type: stat type
+ * @idx: stat index
+ *
+ * Format and copy the strings described by stats into the buffer pointed at
+ * by p.
+ */
+static void __iecm_add_stat_strings(u8 **p, const struct iecm_stats stats[],
+				    const unsigned int size, const char *type,
+				    unsigned int idx)
+{
+	unsigned int i;
+
+	for (i = 0; i < size; i++) {
+		snprintf((char *)*p, ETH_GSTRING_LEN,
+			 "%.2s-%10u.%.17s", type, idx, stats[i].stat_string);
+		*p += ETH_GSTRING_LEN;
+	}
+}
+
+/**
+ * iecm_add_stat_strings - copy stat strings into ethtool buffer
+ * @p: ethtool supplied buffer
+ * @stats: stat definitions array
+ * @type: stat type
+ * @idx: stat idx
+ *
+ * Format and copy the strings described by the const static stats value into
+ * the buffer pointed at by p.
+ *
+ * The parameter @stats is evaluated twice, so parameters with side effects
+ * should be avoided. Additionally, stats must be an array such that
+ * ARRAY_SIZE can be called on it.
+ */
+#define iecm_add_stat_strings(p, stats, type, idx) \
+	__iecm_add_stat_strings(p, stats, ARRAY_SIZE(stats), type, idx)
+
+/**
+ * iecm_get_stat_strings - Get stat strings
+ * @netdev: network interface device structure
+ * @data: buffer for string data
+ *
+ * Builds the statistics string table
+ */
+static void iecm_get_stat_strings(struct net_device __always_unused *netdev,
+				  u8 *data)
+{
+	unsigned int i;
+
+	/* It's critical that we always report a constant number of strings and
+	 * that the strings are reported in the same order regardless of how
+	 * many queues are actually in use.
+	 */
+	for (i = 0; i < IECM_MAX_Q; i++)
+		iecm_add_stat_strings(&data, iecm_gstrings_tx_queue_stats,
+				      "tx", i);
+	for (i = 0; i < IECM_MAX_Q; i++)
+		iecm_add_stat_strings(&data, iecm_gstrings_rx_queue_stats,
+				      "rx", i);
+}
+
+/**
+ * iecm_get_strings - Get string set
+ * @netdev: network interface device structure
+ * @sset: id of string set
+ * @data: buffer for string data
+ *
+ * Builds string tables for various string sets
+ */
+static void iecm_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		iecm_get_stat_strings(netdev, data);
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * iecm_get_sset_count - Get length of string set
+ * @netdev: network interface device structure
+ * @sset: id of string set
+ *
+ * Reports size of various string tables.
+ */
+static int iecm_get_sset_count(struct net_device __always_unused *netdev, int sset)
+{
+	if (sset == ETH_SS_STATS)
+		/* This size reported back here *must* be constant throughout
+		 * the lifecycle of the netdevice, i.e. we must report the
+		 * maximum length even for queues that don't technically exist.
+		 * This is due to the fact that this userspace API uses three
+		 * separate ioctl calls to get stats data but has no way to
+		 * communicate back to userspace when that size has changed,
+		 * which can typically happen as a result of changing number of
+		 * queues. If the number/order of stats change in the middle of
+		 * this call chain it will lead to userspace crashing/accessing
+		 * bad data through buffer under/overflow.
+		 */
+		return (IECM_TX_QUEUE_STATS_LEN * IECM_MAX_Q) +
+			(IECM_RX_QUEUE_STATS_LEN * IECM_MAX_Q);
+	else
+		return -EINVAL;
+}
+
+/**
+ * iecm_add_one_ethtool_stat - copy the stat into the supplied buffer
+ * @data: location to store the stat value
+ * @pstat: old stat pointer to copy from
+ * @stat: the stat definition
+ *
+ * Copies the stat data defined by the pointer and stat structure pair into
+ * the memory supplied as data. Used to implement iecm_add_ethtool_stats and
+ * iecm_add_queue_stats. If the pointer is null, data will be zero'd.
+ */
+static void
+iecm_add_one_ethtool_stat(u64 *data, void *pstat,
+			  const struct iecm_stats *stat)
+{
+	char *p;
+
+	if (!pstat) {
+		/* ensure that the ethtool data buffer is zero'd for any stats
+		 * which don't have a valid pointer.
+		 */
+		*data = 0;
+		return;
+	}
+
+	p = (char *)pstat + stat->stat_offset;
+	switch (stat->sizeof_stat) {
+	case sizeof(u64):
+		*data = *((u64 *)p);
+		break;
+	case sizeof(u32):
+		*data = *((u32 *)p);
+		break;
+	case sizeof(u16):
+		*data = *((u16 *)p);
+		break;
+	case sizeof(u8):
+		*data = *((u8 *)p);
+		break;
+	default:
+		WARN_ONCE(1, "unexpected stat size for %s",
+			  stat->stat_string);
+		*data = 0;
+	}
+}
+
+/**
+ * iecm_add_queue_stats - copy queue statistics into supplied buffer
+ * @data: ethtool stats buffer
+ * @q: the queue to copy
+ *
+ * Queue statistics must be copied while protected by
+ * u64_stats_fetch_begin_irq, so we can't directly use iecm_add_ethtool_stats.
+ * Assumes that queue stats are defined in iecm_gstrings_queue_stats. If the
+ * queue pointer is null, zero out the queue stat values and update the data
+ * pointer. Otherwise safely copy the stats from the queue into the supplied
+ * buffer and update the data pointer when finished.
+ *
+ * This function expects to be called while under rcu_read_lock().
+ */
+static void
+iecm_add_queue_stats(u64 **data, struct iecm_queue *q)
+{
+	const struct iecm_stats *stats;
+	unsigned int start;
+	unsigned int size;
+	unsigned int i;
+
+	if (q->q_type == VIRTCHNL_QUEUE_TYPE_RX) {
+		size = IECM_RX_QUEUE_STATS_LEN;
+		stats = iecm_gstrings_rx_queue_stats;
+	} else {
+		size = IECM_TX_QUEUE_STATS_LEN;
+		stats = iecm_gstrings_tx_queue_stats;
+	}
+
+	/* To avoid invalid statistics values, ensure that we keep retrying
+	 * the copy until we get a consistent value according to
+	 * u64_stats_fetch_retry_irq. But first, make sure our queue is
+	 * non-null before attempting to access its syncp.
+	 */
+	do {
+		start = u64_stats_fetch_begin_irq(&q->stats_sync);
+		for (i = 0; i < size; i++)
+			iecm_add_one_ethtool_stat(&(*data)[i], q, &stats[i]);
+	} while (u64_stats_fetch_retry_irq(&q->stats_sync, start));
+
+	/* Once we successfully copy the stats in, update the data pointer */
+	*data += size;
+}
+
+/**
+ * iecm_add_empty_queue_stats - Add stats for a non-existent queue
+ * @data: pointer to data buffer
+ * @qtype: type of data queue
+ *
+ * We must report a constant length of stats back to userspace regardless of
+ * how many queues are actually in use because stats collection happens over
+ * three separate ioctls and there's no way to notify userspace the size
+ * changed between those calls. This adds empty to data to the stats since we
+ * don't have a real queue to refer to for this stats slot.
+ */
+static void
+iecm_add_empty_queue_stats(u64 **data, enum virtchnl_queue_type qtype)
+{
+	unsigned int i;
+	int stats_len;
+
+	if (qtype == VIRTCHNL_QUEUE_TYPE_RX)
+		stats_len = IECM_RX_QUEUE_STATS_LEN;
+	else
+		stats_len = IECM_TX_QUEUE_STATS_LEN;
+
+	for (i = 0; i < stats_len; i++)
+		(*data)[i] = 0;
+	*data += stats_len;
+}
+
+/**
+ * iecm_get_ethtool_stats - report device statistics
+ * @netdev: network interface device structure
+ * @stats: ethtool statistics structure
+ * @data: pointer to data buffer
+ *
+ * All statistics are added to the data buffer as an array of u64.
+ */
+static void iecm_get_ethtool_stats(struct net_device *netdev,
+				   struct ethtool_stats __always_unused *stats,
+				   u64 *data)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	enum virtchnl_queue_type qtype;
+	unsigned int total = 0;
+	unsigned int i, j;
+
+	if (vport->adapter->state != __IECM_UP)
+		return;
+
+	rcu_read_lock();
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		struct iecm_txq_group *txq_grp = &vport->txq_grps[i];
+
+		qtype = VIRTCHNL_QUEUE_TYPE_TX;
+
+		for (j = 0; j < txq_grp->num_txq; j++, total++) {
+			struct iecm_queue *txq = &txq_grp->txqs[j];
+
+			if (!txq)
+				iecm_add_empty_queue_stats(&data, qtype);
+			else
+				iecm_add_queue_stats(&data, txq);
+		}
+	}
+	/* It is critical we provide a constant number of stats back to
+	 * userspace regardless of how many queues are actually in use because
+	 * there is no way to inform userspace the size has changed between
+	 * ioctl calls. This will fill in any missing stats with zero.
+	 */
+	for (; total < IECM_MAX_Q; total++)
+		iecm_add_empty_queue_stats(&data, VIRTCHNL_QUEUE_TYPE_TX);
+	total = 0;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct iecm_rxq_group *rxq_grp = &vport->rxq_grps[i];
+		int num_rxq;
+
+		qtype = VIRTCHNL_QUEUE_TYPE_RX;
+
+		if (iecm_is_queue_model_split(vport->rxq_model))
+			num_rxq = rxq_grp->splitq.num_rxq_sets;
+		else
+			num_rxq = rxq_grp->singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++, total++) {
+			struct iecm_queue *rxq;
+
+			if (iecm_is_queue_model_split(vport->rxq_model))
+				rxq = &rxq_grp->splitq.rxq_sets[j].rxq;
+			else
+				rxq = &rxq_grp->singleq.rxqs[j];
+			if (!rxq)
+				iecm_add_empty_queue_stats(&data, qtype);
+			else
+				iecm_add_queue_stats(&data, rxq);
+		}
+	}
+	for (; total < IECM_MAX_Q; total++)
+		iecm_add_empty_queue_stats(&data, VIRTCHNL_QUEUE_TYPE_RX);
+	rcu_read_unlock();
+}
+
+/**
+ * iecm_find_rxq - find rxq from q index
+ * @vport: virtual port associated to queue
+ * @q_num: q index used to find queue
+ *
+ * returns pointer to Rx queue
+ */
+static struct iecm_queue *
+iecm_find_rxq(struct iecm_vport *vport, int q_num)
+{
+	struct iecm_queue *rxq;
+	int q_grp, q_idx;
+
+	if (iecm_is_queue_model_split(vport->rxq_model)) {
+		q_grp = q_num / IECM_DFLT_SPLITQ_RXQ_PER_GROUP;
+		q_idx = q_num % IECM_DFLT_SPLITQ_RXQ_PER_GROUP;
+
+		rxq = &vport->rxq_grps[q_grp].splitq.rxq_sets[q_idx].rxq;
+	} else {
+		q_grp = q_num / IECM_DFLT_SINGLEQ_RXQ_PER_GROUP;
+		q_idx = q_num % IECM_DFLT_SINGLEQ_RXQ_PER_GROUP;
+
+		rxq = &vport->rxq_grps[q_grp].singleq.rxqs[q_idx];
+	}
+
+	return rxq;
+}
+
+/**
+ * iecm_find_txq - find txq from q index
+ * @vport: virtual port associated to queue
+ * @q_num: q index used to find queue
+ *
+ * returns pointer to Tx queue
+ */
+static struct iecm_queue *
+iecm_find_txq(struct iecm_vport *vport, int q_num)
+{
+	struct iecm_queue *txq;
+
+	if (iecm_is_queue_model_split(vport->txq_model)) {
+		int q_grp = q_num / IECM_DFLT_SPLITQ_TXQ_PER_GROUP;
+
+		txq = vport->txq_grps[q_grp].complq;
+	} else {
+		txq = vport->txqs[q_num];
+	}
+
+	return txq;
+}
+
+/**
+ * __iecm_get_q_coalesce - get ITR values for specific queue
+ * @ec: ethtool structure to fill with driver's coalesce settings
+ * @q: queue of Rx or Tx
+ */
+static void
+__iecm_get_q_coalesce(struct ethtool_coalesce *ec, struct iecm_queue *q)
+{
+	u16 itr_setting;
+	bool dyn_ena;
+
+	itr_setting = IECM_ITR_SETTING(q->itr.target_itr);
+	dyn_ena = IECM_ITR_IS_DYNAMIC(q->itr.target_itr);
+	if (q->q_type == VIRTCHNL_QUEUE_TYPE_RX) {
+		ec->use_adaptive_rx_coalesce = dyn_ena;
+		ec->rx_coalesce_usecs = itr_setting;
+	} else {
+		ec->use_adaptive_tx_coalesce = dyn_ena;
+		ec->tx_coalesce_usecs = itr_setting;
+	}
+}
+
+/**
+ * iecm_get_q_coalesce - get ITR values for specific queue
+ * @netdev: pointer to the netdev associated with this query
+ * @ec: coalesce settings to program the device with
+ * @q_num: update ITR/INTRL (coalesce) settings for this queue number/index
+ *
+ * Return 0 on success, and negative on failure
+ */
+static int
+iecm_get_q_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
+		    u32 q_num)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+
+	if (vport->adapter->state != __IECM_UP)
+		return 0;
+
+	if (q_num >= vport->num_rxq && q_num >= vport->num_txq)
+		return -EINVAL;
+
+	if (q_num < vport->num_rxq) {
+		struct iecm_queue *rxq = iecm_find_rxq(vport, q_num);
+
+		__iecm_get_q_coalesce(ec, rxq);
+	}
+
+	if (q_num < vport->num_txq) {
+		struct iecm_queue *txq = iecm_find_txq(vport, q_num);
+
+		__iecm_get_q_coalesce(ec, txq);
+	}
+
+	return 0;
+}
+
+/**
+ * iecm_get_coalesce - get ITR values as requested by user
+ * @netdev: pointer to the netdev associated with this query
+ * @ec: coalesce settings to be filled
+ *
+ * Return 0 on success, and negative on failure
+ */
+static int
+iecm_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
+{
+	/* Return coalesce based on queue number zero */
+	return iecm_get_q_coalesce(netdev, ec, 0);
+}
+
+/**
+ * iecm_get_per_q_coalesce - get ITR values as requested by user
+ * @netdev: pointer to the netdev associated with this query
+ * @q_num: queue for which the ITR values has to retrieved
+ * @ec: coalesce settings to be filled
+ *
+ * Return 0 on success, and negative on failure
+ */
+
+static int
+iecm_get_per_q_coalesce(struct net_device *netdev, u32 q_num,
+			struct ethtool_coalesce *ec)
+{
+	return iecm_get_q_coalesce(netdev, ec, q_num);
+}
+
+/**
+ * __iecm_set_q_coalesce - set ITR values for specific queue
+ * @ec: ethtool structure from user to update ITR settings
+ * @q: queue for which ITR values has to be set
+ *
+ * Returns 0 on success, negative otherwise.
+ */
+static int
+__iecm_set_q_coalesce(struct ethtool_coalesce *ec, struct iecm_queue *q)
+{
+	const char *q_type_str = (q->q_type == VIRTCHNL_QUEUE_TYPE_RX)
+				  ? "Rx" : "Tx";
+	u32 use_adaptive_coalesce, coalesce_usecs;
+	struct iecm_vport *vport;
+	u16 itr_setting;
+
+	itr_setting = IECM_ITR_SETTING(q->itr.target_itr);
+	vport = q->vport;
+	if (q->q_type == VIRTCHNL_QUEUE_TYPE_RX) {
+		use_adaptive_coalesce = ec->use_adaptive_rx_coalesce;
+		coalesce_usecs = ec->rx_coalesce_usecs;
+	} else {
+		use_adaptive_coalesce = ec->use_adaptive_tx_coalesce;
+		coalesce_usecs = ec->tx_coalesce_usecs;
+	}
+
+	if (itr_setting != coalesce_usecs && use_adaptive_coalesce) {
+		netdev_info(vport->netdev, "%s ITR cannot be changed if adaptive-%s is enabled\n",
+			    q_type_str, q_type_str);
+		return -EINVAL;
+	}
+
+	if (coalesce_usecs > IECM_ITR_MAX) {
+		netdev_info(vport->netdev,
+			    "Invalid value, %d-usecs range is 0-%d\n",
+			    coalesce_usecs, IECM_ITR_MAX);
+		return -EINVAL;
+	}
+
+	if (coalesce_usecs % 2 != 0) {
+		coalesce_usecs = coalesce_usecs & 0xFFFFFFFE;
+		netdev_info(vport->netdev, "HW only supports even ITR values, ITR rounded to %d\n",
+			    coalesce_usecs);
+	}
+
+	q->itr.target_itr = coalesce_usecs;
+	if (use_adaptive_coalesce)
+		q->itr.target_itr |= IECM_ITR_DYNAMIC;
+	/* Update of static/dynamic ITR will be taken care when interrupt is
+	 * fired
+	 */
+	return 0;
+}
+
+/**
+ * iecm_set_q_coalesce - set ITR values for specific queue
+ * @vport: vport associated to the queue that need updating
+ * @ec: coalesce settings to program the device with
+ * @q_num: update ITR/INTRL (coalesce) settings for this queue number/index
+ * @is_rxq: is queue type Rx
+ *
+ * Return 0 on success, and negative on failure
+ */
+static int
+iecm_set_q_coalesce(struct iecm_vport *vport, struct ethtool_coalesce *ec,
+		    int q_num, bool is_rxq)
+{
+	struct iecm_queue *q;
+
+	if (is_rxq)
+		q = iecm_find_rxq(vport, q_num);
+	else
+		q = iecm_find_txq(vport, q_num);
+
+	if (q && __iecm_set_q_coalesce(ec, q))
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * iecm_set_coalesce - set ITR values as requested by user
+ * @netdev: pointer to the netdev associated with this query
+ * @ec: coalesce settings to program the device with
+ *
+ * Return 0 on success, and negative on failure
+ */
+static int
+iecm_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	int i, err = 0;
+
+	for (i = 0; i < vport->num_txq; i++) {
+		err = iecm_set_q_coalesce(vport, ec, i, false);
+		if (err)
+			return err;
+	}
+
+	for (i = 0; i < vport->num_rxq; i++) {
+		err = iecm_set_q_coalesce(vport, ec, i, true);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+/**
+ * iecm_set_per_q_coalesce - set ITR values as requested by user
+ * @netdev: pointer to the netdev associated with this query
+ * @q_num: queue for which the ITR values has to be set
+ * @ec: coalesce settings to program the device with
+ *
+ * Return 0 on success, and negative on failure
+ */
+static int
+iecm_set_per_q_coalesce(struct net_device *netdev, u32 q_num,
+			struct ethtool_coalesce *ec)
+{
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	int err;
+
+	err = iecm_set_q_coalesce(vport, ec, q_num, false);
+	if (!err)
+		err = iecm_set_q_coalesce(vport, ec, q_num, true);
+
+	return err;
+}
+
+/**
+ * iecm_get_msglevel - Get debug message level
+ * @netdev: network interface device structure
+ *
+ * Returns current debug message level.
+ */
+static u32 iecm_get_msglevel(struct net_device *netdev)
+{
+	struct iecm_adapter *adapter = iecm_netdev_to_adapter(netdev);
+
+	return adapter->msg_enable;
+}
+
+/**
+ * iecm_set_msglevel - Set debug message level
+ * @netdev: network interface device structure
+ * @data: message level
+ *
+ * Set current debug message level. Higher values cause the driver to
+ * be noisier.
+ */
+static void iecm_set_msglevel(struct net_device *netdev, u32 data)
+{
+	struct iecm_adapter *adapter = iecm_netdev_to_adapter(netdev);
+
+	adapter->msg_enable = data;
+}
+
+/**
+ * iecm_get_link_ksettings - Get Link Speed and Duplex settings
+ * @netdev: network interface device structure
+ * @cmd: ethtool command
+ *
+ * Reports speed/duplex settings.
+ **/
+static int iecm_get_link_ksettings(struct net_device *netdev,
+				   struct ethtool_link_ksettings *cmd)
+{
+	struct iecm_netdev_priv *np = netdev_priv(netdev);
+	struct iecm_adapter *adapter = np->vport->adapter;
+
+	ethtool_link_ksettings_zero_link_mode(cmd, supported);
+	cmd->base.autoneg = AUTONEG_DISABLE;
+	cmd->base.port = PORT_NONE;
+	/* Set speed and duplex */
+	switch (adapter->link_speed) {
+	case VIRTCHNL_LINK_SPEED_40GB:
+		cmd->base.speed = SPEED_40000;
+		break;
+	case VIRTCHNL_LINK_SPEED_25GB:
+		cmd->base.speed = SPEED_25000;
+		break;
+	case VIRTCHNL_LINK_SPEED_20GB:
+		cmd->base.speed = SPEED_20000;
+		break;
+	case VIRTCHNL_LINK_SPEED_10GB:
+		cmd->base.speed = SPEED_10000;
+		break;
+	case VIRTCHNL_LINK_SPEED_1GB:
+		cmd->base.speed = SPEED_1000;
+		break;
+	case VIRTCHNL_LINK_SPEED_100MB:
+		cmd->base.speed = SPEED_100;
+		break;
+	default:
+		break;
+	}
+	cmd->base.duplex = DUPLEX_FULL;
+
+	return 0;
+}
+
+/**
+ * iecm_get_drvinfo - Get driver info
+ * @netdev: network interface device structure
+ * @drvinfo: ethtool driver info structure
+ *
+ * Returns information about the driver and device for display to the user.
+ */
+static void iecm_get_drvinfo(struct net_device *netdev,
+			     struct ethtool_drvinfo *drvinfo)
+{
+	struct iecm_adapter *adapter = iecm_netdev_to_adapter(netdev);
+
+	strlcpy(drvinfo->driver, iecm_drv_name, 32);
+	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev), 32);
+}
+
+static const struct ethtool_ops iecm_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
+	.get_drvinfo		= iecm_get_drvinfo,
+	.get_msglevel		= iecm_get_msglevel,
+	.set_msglevel		= iecm_set_msglevel,
+	.get_coalesce		= iecm_get_coalesce,
+	.set_coalesce		= iecm_set_coalesce,
+	.get_per_queue_coalesce	= iecm_get_per_q_coalesce,
+	.set_per_queue_coalesce	= iecm_set_per_q_coalesce,
+	.get_ethtool_stats	= iecm_get_ethtool_stats,
+	.get_strings		= iecm_get_strings,
+	.get_sset_count		= iecm_get_sset_count,
+	.get_rxnfc		= iecm_get_rxnfc,
+	.get_rxfh_key_size	= iecm_get_rxfh_key_size,
+	.get_rxfh_indir_size	= iecm_get_rxfh_indir_size,
+	.get_rxfh		= iecm_get_rxfh,
+	.set_rxfh		= iecm_set_rxfh,
+	.get_channels		= iecm_get_channels,
+	.set_channels		= iecm_set_channels,
+	.get_ringparam		= iecm_get_ringparam,
+	.set_ringparam		= iecm_set_ringparam,
+	.get_link_ksettings	= iecm_get_link_ksettings,
+};
+
 /**
  * iecm_set_ethtool_ops - Initialize ethtool ops struct
  * @netdev: network interface device structure
@@ -12,5 +1044,5 @@
  */
 void iecm_set_ethtool_ops(struct net_device *netdev)
 {
-	/* stub */
+	netdev->ethtool_ops = &iecm_ethtool_ops;
 }
diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c b/drivers/net/ethernet/intel/iecm/iecm_lib.c
index 16f92dc4c77a..1a8968c4070c 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_lib.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_lib.c
@@ -840,7 +840,37 @@ static void iecm_deinit_task(struct iecm_adapter *adapter)
  */
 static int iecm_init_hard_reset(struct iecm_adapter *adapter)
 {
-	/* stub */
+	int err = 0;
+
+	/* Prepare for reset */
+	if (test_bit(__IECM_HR_FUNC_RESET, adapter->flags)) {
+		iecm_deinit_task(adapter);
+		adapter->dev_ops.reg_ops.trigger_reset(adapter,
+						       __IECM_HR_FUNC_RESET);
+		set_bit(__IECM_UP_REQUESTED, adapter->flags);
+		clear_bit(__IECM_HR_FUNC_RESET, adapter->flags);
+	} else if (test_bit(__IECM_HR_CORE_RESET, adapter->flags)) {
+		if (adapter->state == __IECM_UP)
+			set_bit(__IECM_UP_REQUESTED, adapter->flags);
+		iecm_deinit_task(adapter);
+		clear_bit(__IECM_HR_CORE_RESET, adapter->flags);
+	} else if (test_and_clear_bit(__IECM_HR_DRV_LOAD, adapter->flags)) {
+	/* Trigger reset */
+	} else {
+		dev_err(&adapter->pdev->dev, "Unhandled hard reset cause\n");
+		err = -EBADRQC;
+		goto handle_err;
+	}
+
+	/* Reset is complete and so start building the driver resources again */
+	err = iecm_init_dflt_mbx(adapter);
+	if (err) {
+		dev_err(&adapter->pdev->dev, "Failed to initialize default mailbox: %d\n",
+			err);
+	}
+handle_err:
+	mutex_unlock(&adapter->reset_lock);
+	return err;
 }
 
 /**
@@ -869,7 +899,109 @@ static void iecm_vc_event_task(struct work_struct *work)
 int iecm_initiate_soft_reset(struct iecm_vport *vport,
 			     enum iecm_flags reset_cause)
 {
-	/* stub */
+	enum iecm_state current_state = vport->adapter->state;
+	struct iecm_adapter *adapter = vport->adapter;
+	struct iecm_vport *old_vport;
+	int err = 0;
+
+	/* make sure we do not end up in initiating multiple resets */
+	mutex_lock(&adapter->reset_lock);
+
+	/* If the system is low on memory, we can end up in bad state if we
+	 * free all the memory for queue resources and try to allocate them
+	 * again. Instead, we can pre-allocate the new resources before doing
+	 * anything and bailing if the alloc fails.
+	 *
+	 * Here we make a clone to act as a handle to old resources, then do a
+	 * new alloc. If successful then we'll stop the clone, free the old
+	 * resources, and continue with reset on new vport resources. On error
+	 * copy clone back to vport to get back to a good state and return
+	 * error.
+	 *
+	 * We also want to be careful we don't invalidate any pre-existing
+	 * pointers to vports prior to calling this.
+	 */
+	old_vport = kzalloc(sizeof(*vport), GFP_KERNEL);
+	if (!old_vport) {
+		mutex_unlock(&adapter->reset_lock);
+		return -ENOMEM;
+	}
+	memcpy(old_vport, vport, sizeof(*vport));
+
+	/* Adjust resource parameters prior to reallocating resources */
+	switch (reset_cause) {
+	case __IECM_SR_Q_CHANGE:
+		adapter->dev_ops.vc_ops.adjust_qs(vport);
+		break;
+	case __IECM_SR_Q_DESC_CHANGE:
+		/* Update queue parameters before allocating resources */
+		iecm_vport_calc_num_q_desc(vport);
+		break;
+	case __IECM_SR_Q_SCH_CHANGE:
+	case __IECM_SR_MTU_CHANGE:
+		break;
+	default:
+		dev_err(&adapter->pdev->dev, "Unhandled soft reset cause\n");
+		err = -EINVAL;
+		goto err_reset;
+	}
+
+	/* It's important we pass in the vport pointer so that when
+	 * back-pointers are setup in queue allocs, they get the right pointer.
+	 */
+	err = iecm_vport_res_alloc(vport);
+	if (err)
+		goto err_mem_alloc;
+
+	if (!test_bit(__IECM_NO_EXTENDED_CAPS, adapter->flags)) {
+		if (current_state <= __IECM_DOWN) {
+			iecm_send_delete_queues_msg(old_vport);
+		} else {
+			set_bit(__IECM_DEL_QUEUES, adapter->flags);
+			iecm_vport_stop(old_vport);
+		}
+
+		iecm_deinit_rss(old_vport);
+		err = iecm_send_add_queues_msg(vport, vport->num_txq,
+					       vport->num_complq,
+					       vport->num_rxq,
+					       vport->num_bufq);
+		if (err)
+			goto err_reset;
+	}
+
+	/* Post resource allocation reset */
+	switch (reset_cause) {
+	case __IECM_SR_Q_CHANGE:
+		iecm_intr_rel(adapter);
+		iecm_intr_req(adapter);
+		break;
+	case __IECM_SR_Q_DESC_CHANGE:
+	case __IECM_SR_Q_SCH_CHANGE:
+	case __IECM_SR_MTU_CHANGE:
+		iecm_vport_stop(old_vport);
+		break;
+	default:
+		dev_err(&adapter->pdev->dev, "Unhandled soft reset cause\n");
+		err = -EINVAL;
+		goto err_reset;
+	}
+
+	/* free the old resources */
+	iecm_vport_res_free(old_vport);
+	kfree(old_vport);
+
+	if (current_state == __IECM_UP)
+		err = iecm_vport_open(vport);
+	mutex_unlock(&adapter->reset_lock);
+	return err;
+err_reset:
+	iecm_vport_res_free(vport);
+err_mem_alloc:
+	memcpy(vport, old_vport, sizeof(*vport));
+	kfree(old_vport);
+	mutex_unlock(&adapter->reset_lock);
+	return err;
 }
 
 /**
@@ -961,6 +1093,7 @@ int iecm_probe(struct pci_dev *pdev,
 	INIT_DELAYED_WORK(&adapter->init_task, iecm_init_task);
 	INIT_DELAYED_WORK(&adapter->vc_event_task, iecm_vc_event_task);
 
+	adapter->dev_ops.reg_ops.reset_reg_init(&adapter->reset_reg);
 	mutex_lock(&adapter->reset_lock);
 	set_bit(__IECM_HR_DRV_LOAD, adapter->flags);
 	err = iecm_init_hard_reset(adapter);
@@ -1054,7 +1187,11 @@ static int iecm_open(struct net_device *netdev)
  */
 static int iecm_change_mtu(struct net_device *netdev, int new_mtu)
 {
-	/* stub */
+	struct iecm_vport *vport =  iecm_netdev_to_vport(netdev);
+
+	netdev->mtu = new_mtu;
+
+	return iecm_initiate_soft_reset(vport, __IECM_SR_MTU_CHANGE);
 }
 
 void *iecm_alloc_dma_mem(struct iecm_hw *hw, struct iecm_dma_mem *mem, u64 size)
-- 
2.26.2

