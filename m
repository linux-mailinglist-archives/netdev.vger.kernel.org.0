Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9033615B7
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbhDOWxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237559AbhDOWxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F08EC61152;
        Thu, 15 Apr 2021 22:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618527202;
        bh=AvQVmxkxWQmipxtl89GCWuepM4N152Iszu4EMoLzltE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzuYxNZgiNY1ErAvrNfHobzK8UWMV9NJMPMUHuQAZ5He8jzt3VICkx3/xyXi0+WCO
         xpMiOy3Y8ccDS0eAhIDNXQsGuS5ajfFsGGzlOCoaJ5ht3KPND5Zw/IWbL376kLLBTB
         Yg8Wt8tt3Z5k1qDklvvxcY34Xfpsim6xOfs9XjTI4zorKIi4c9xzYBROMze+MlXzRk
         MhhpmHV5clh0KK+U9myYPDhtYnfXnAYZuQ5lA2R8mal5fTdVw69JIZPQcz4nWmXYhP
         ruklk4NXNBU93HaH1BZkBXVrj5OYOj5VpBEgG3KdY+iC7sckq3VXTn0l6vUzNrppKu
         JNHUHw35+DVQg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/6] ethtool: add FEC statistics
Date:   Thu, 15 Apr 2021 15:53:15 -0700
Message-Id: <20210415225318.2726095-4-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415225318.2726095-1-kuba@kernel.org>
References: <20210415225318.2726095-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to pause statistics add stats for FEC.

The IEEE standard mandates two sets of counters:
 - 30.5.1.1.17 aFECCorrectedBlocks
 - 30.5.1.1.18 aFECUncorrectableBlocks
where block is a block of bits FEC operates on.
Each of these counters is defined per lane (PCS instance).

Multiple vendors provide number of corrected _bits_ rather
than/as well as blocks.

This set adds the 2 standard-based block counters and a extra
one for corrected bits.

Counters are exposed to user space via netlink in new attributes.
Each attribute carries an array of u64s, first element is
the total count, and the following ones are a per-lane break down.

Much like with pause stats the operation will not fail when driver
does not implement the get_fec_stats callback (nor can the driver
fail the operation by returning an error). If stats can't be
reported the relevant attributes will be empty.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst | 21 ++++++
 Documentation/networking/statistics.rst      |  2 +
 include/linux/ethtool.h                      | 40 +++++++++++
 include/uapi/linux/ethtool_netlink.h         | 14 ++++
 net/ethtool/fec.c                            | 73 +++++++++++++++++++-
 5 files changed, 149 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index bbecffc7b11a..f8219e2f489e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1302,6 +1302,7 @@ Gets FEC configuration and state like ``ETHTOOL_GFECPARAM`` ioctl request.
   ``ETHTOOL_A_FEC_MODES``                bitset  configured modes
   ``ETHTOOL_A_FEC_AUTO``                 bool    FEC mode auto selection
   ``ETHTOOL_A_FEC_ACTIVE``               u32     index of active FEC mode
+  ``ETHTOOL_A_FEC_STATS``                nested  FEC statistics
   =====================================  ======  ==========================
 
 ``ETHTOOL_A_FEC_ACTIVE`` is the bit index of the FEC link mode currently
@@ -1315,6 +1316,26 @@ This is equivalent to the ``ETHTOOL_FEC_AUTO`` bit of the ioctl interface.
 ``ETHTOOL_A_FEC_MODES`` carry the current FEC configuration using link mode
 bits (rather than old ``ETHTOOL_FEC_*`` bits).
 
+``ETHTOOL_A_FEC_STATS`` are reported if ``ETHTOOL_FLAG_STATS`` was set in
+``ETHTOOL_A_HEADER_FLAGS``.
+Each attribute carries an array of 64bit statistics. First entry in the array
+contains the total number of events on the port, while the following entries
+are counters corresponding to lanes/PCS instances. The number of entries in
+the array will be:
+
++--------------+---------------------------------------------+
+| `0`          | device does not support FEC statistics      |
++--------------+---------------------------------------------+
+| `1`          | device does not support per-lane break down |
++--------------+---------------------------------------------+
+| `1 + #lanes` | device has full support for FEC stats       |
++--------------+---------------------------------------------+
+
+Drivers fill in the statistics in the following structure:
+
+.. kernel-doc:: include/linux/ethtool.h
+    :identifiers: ethtool_fec_stats
+
 FEC_SET
 =======
 
diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index 234abedc29b2..b748fe44ee02 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -130,6 +130,7 @@ the `ETHTOOL_FLAG_STATS` flag in `ETHTOOL_A_HEADER_FLAGS`. Currently
 statistics are supported in the following commands:
 
   - `ETHTOOL_MSG_PAUSE_GET`
+  - `ETHTOOL_MSG_FEC_GET`
 
 debugfs
 -------
@@ -176,3 +177,4 @@ translated to netlink attributes when dumped. Drivers must not overwrite
 the statistics they don't report with 0.
 
 - ethtool_pause_stats()
+- ethtool_fec_stats()
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 069100b252bd..112a85b57f1f 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -269,6 +269,39 @@ struct ethtool_pause_stats {
 	u64 rx_pause_frames;
 };
 
+#define ETHTOOL_MAX_LANES	8
+
+/**
+ * struct ethtool_fec_stats - statistics for IEEE 802.3 FEC
+ * @corrected_blocks: number of received blocks corrected by FEC
+ *	Reported to user space as %ETHTOOL_A_FEC_STAT_CORRECTED.
+ *
+ *	Equivalent to `30.5.1.1.17 aFECCorrectedBlocks` from the standard.
+ *
+ * @uncorrectable_blocks: number of received blocks FEC was not able to correct
+ *	Reported to user space as %ETHTOOL_A_FEC_STAT_UNCORR.
+ *
+ *	Equivalent to `30.5.1.1.18 aFECUncorrectableBlocks` from the standard.
+ *
+ * @corrected_bits: number of bits corrected by FEC
+ *	Similar to @corrected_blocks but counts individual bit changes,
+ *	not entire FEC data blocks. This is a non-standard statistic.
+ *	Reported to user space as %ETHTOOL_A_FEC_STAT_CORR_BITS.
+ *
+ * @lane: per-lane/PCS-instance counts as defined by the standard
+ * @total: error counts for the entire port, for drivers incapable of reporting
+ *	per-lane stats
+ *
+ * Drivers should fill in either only total or per-lane statistics, core
+ * will take care of adding lane values up to produce the total.
+ */
+struct ethtool_fec_stats {
+	struct ethtool_fec_stat {
+		u64 total;
+		u64 lanes[ETHTOOL_MAX_LANES];
+	} corrected_blocks, uncorrectable_blocks, corrected_bits;
+};
+
 #define ETH_MODULE_EEPROM_PAGE_LEN	128
 #define ETH_MODULE_MAX_I2C_ADDRESS	0x7f
 
@@ -439,6 +472,11 @@ struct ethtool_module_eeprom {
  *	ignored (use %__ETHTOOL_LINK_MODE_MASK_NBITS instead of the latter),
  *	any change to them will be overwritten by kernel. Returns a negative
  *	error code or zero.
+ * @get_fec_stats: Report FEC statistics.
+ *	Core will sum up per-lane stats to get the total.
+ *	Drivers must not zero statistics which they don't report. The stats
+ *	structure is initialized to ETHTOOL_STAT_NOT_SET indicating driver does
+ *	not report statistics.
  * @get_fecparam: Get the network device Forward Error Correction parameters.
  * @set_fecparam: Set the network device Forward Error Correction parameters.
  * @get_ethtool_phy_stats: Return extended statistics about the PHY device.
@@ -544,6 +582,8 @@ struct ethtool_ops {
 				      struct ethtool_link_ksettings *);
 	int	(*set_link_ksettings)(struct net_device *,
 				      const struct ethtool_link_ksettings *);
+	void	(*get_fec_stats)(struct net_device *dev,
+				 struct ethtool_fec_stats *fec_stats);
 	int	(*get_fecparam)(struct net_device *,
 				      struct ethtool_fecparam *);
 	int	(*set_fecparam)(struct net_device *,
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 9612dcd48a6a..3a2b31ccbc5b 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -643,11 +643,25 @@ enum {
 	ETHTOOL_A_FEC_MODES,				/* bitset */
 	ETHTOOL_A_FEC_AUTO,				/* u8 */
 	ETHTOOL_A_FEC_ACTIVE,				/* u32 */
+	ETHTOOL_A_FEC_STATS,				/* nest - _A_FEC_STAT */
 
 	__ETHTOOL_A_FEC_CNT,
 	ETHTOOL_A_FEC_MAX = (__ETHTOOL_A_FEC_CNT - 1)
 };
 
+enum {
+	ETHTOOL_A_FEC_STAT_UNSPEC,
+	ETHTOOL_A_FEC_STAT_PAD,
+
+	ETHTOOL_A_FEC_STAT_CORRECTED,			/* array, u64 */
+	ETHTOOL_A_FEC_STAT_UNCORR,			/* array, u64 */
+	ETHTOOL_A_FEC_STAT_CORR_BITS,			/* array, u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_FEC_STAT_CNT,
+	ETHTOOL_A_FEC_STAT_MAX = (__ETHTOOL_A_FEC_STAT_CNT - 1)
+};
+
 /* MODULE EEPROM */
 
 enum {
diff --git a/net/ethtool/fec.c b/net/ethtool/fec.c
index 3e7d091ee7aa..8738dafd5417 100644
--- a/net/ethtool/fec.c
+++ b/net/ethtool/fec.c
@@ -13,6 +13,10 @@ struct fec_reply_data {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(fec_link_modes);
 	u32 active_fec;
 	u8 fec_auto;
+	struct fec_stat_grp {
+		u64 stats[1 + ETHTOOL_MAX_LANES];
+		u8 cnt;
+	} corr, uncorr, corr_bits;
 };
 
 #define FEC_REPDATA(__reply_base) \
@@ -21,7 +25,7 @@ struct fec_reply_data {
 #define ETHTOOL_FEC_MASK	((ETHTOOL_FEC_LLRS << 1) - 1)
 
 const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1] = {
-	[ETHTOOL_A_FEC_HEADER]	= NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_FEC_HEADER]	= NLA_POLICY_NESTED(ethnl_header_policy_stats),
 };
 
 static void
@@ -64,6 +68,28 @@ ethtool_link_modes_to_fecparam(struct ethtool_fecparam *fec,
 	return 0;
 }
 
+static void
+fec_stats_recalc(struct fec_stat_grp *grp, struct ethtool_fec_stat *stats)
+{
+	int i;
+
+	if (stats->lanes[0] == ETHTOOL_STAT_NOT_SET) {
+		grp->stats[0] = stats->total;
+		grp->cnt = stats->total != ETHTOOL_STAT_NOT_SET;
+		return;
+	}
+
+	grp->cnt = 1;
+	grp->stats[0] = 0;
+	for (i = 0; i < ETHTOOL_MAX_LANES; i++) {
+		if (stats->lanes[i] == ETHTOOL_STAT_NOT_SET)
+			break;
+
+		grp->stats[0] += stats->lanes[i];
+		grp->stats[grp->cnt++] = stats->lanes[i];
+	}
+}
+
 static int fec_prepare_data(const struct ethnl_req_info *req_base,
 			    struct ethnl_reply_data *reply_base,
 			    struct genl_info *info)
@@ -82,6 +108,17 @@ static int fec_prepare_data(const struct ethnl_req_info *req_base,
 	ret = dev->ethtool_ops->get_fecparam(dev, &fec);
 	if (ret)
 		goto out_complete;
+	if (req_base->flags & ETHTOOL_FLAG_STATS &&
+	    dev->ethtool_ops->get_fec_stats) {
+		struct ethtool_fec_stats stats;
+
+		ethtool_stats_init((u64 *)&stats, sizeof(stats) / 8);
+		dev->ethtool_ops->get_fec_stats(dev, &stats);
+
+		fec_stats_recalc(&data->corr, &stats.corrected_blocks);
+		fec_stats_recalc(&data->uncorr, &stats.uncorrectable_blocks);
+		fec_stats_recalc(&data->corr_bits, &stats.corrected_bits);
+	}
 
 	WARN_ON_ONCE(fec.reserved);
 
@@ -120,9 +157,40 @@ static int fec_reply_size(const struct ethnl_req_info *req_base,
 	len += nla_total_size(sizeof(u8)) +	/* _FEC_AUTO */
 	       nla_total_size(sizeof(u32));	/* _FEC_ACTIVE */
 
+	if (req_base->flags & ETHTOOL_FLAG_STATS)
+		len += 3 * nla_total_size_64bit(sizeof(u64) *
+						(1 + ETHTOOL_MAX_LANES));
+
 	return len;
 }
 
+static int fec_put_stats(struct sk_buff *skb, const struct fec_reply_data *data)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_FEC_STATS);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_64bit(skb, ETHTOOL_A_FEC_STAT_CORRECTED,
+			  sizeof(u64) * data->corr.cnt,
+			  data->corr.stats, ETHTOOL_A_FEC_STAT_PAD) ||
+	    nla_put_64bit(skb, ETHTOOL_A_FEC_STAT_UNCORR,
+			  sizeof(u64) * data->uncorr.cnt,
+			  data->uncorr.stats, ETHTOOL_A_FEC_STAT_PAD) ||
+	    nla_put_64bit(skb, ETHTOOL_A_FEC_STAT_CORR_BITS,
+			  sizeof(u64) * data->corr_bits.cnt,
+			  data->corr_bits.stats, ETHTOOL_A_FEC_STAT_PAD))
+		goto err_cancel;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static int fec_fill_reply(struct sk_buff *skb,
 			  const struct ethnl_req_info *req_base,
 			  const struct ethnl_reply_data *reply_base)
@@ -143,6 +211,9 @@ static int fec_fill_reply(struct sk_buff *skb,
 	     nla_put_u32(skb, ETHTOOL_A_FEC_ACTIVE, data->active_fec)))
 		return -EMSGSIZE;
 
+	if (req_base->flags & ETHTOOL_FLAG_STATS && fec_put_stats(skb, data))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
-- 
2.30.2

