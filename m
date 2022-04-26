Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210E650F7E6
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 11:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbiDZJKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 05:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347910AbiDZJGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 05:06:22 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85F981498;
        Tue, 26 Apr 2022 01:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1650962826; x=1682498826;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=77x/SKAlWFBqi/7E9TtIDrxxn2AWCICj8gfWfDCRvm0=;
  b=ZnRKVgIMLd2sgFXzgsSeSIzTh7qau1HMbBzStKuMVctQEUayRu8CDumg
   8gGlyABITH/7wEPt9xVSV+50xYbvEHdKFr9x2fgHhW9kQUZWWRNikPi2U
   H3I/zf3nIi7zJ9MFDyGrBxpcW0TCQ77F5Tsla4QqbjoKokY8GWYFFpUuf
   s=;
X-IronPort-AV: E=Sophos;i="5.90,290,1643673600"; 
   d="scan'208";a="190965779"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 26 Apr 2022 08:46:48 +0000
Received: from EX13D08EUB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com (Postfix) with ESMTPS id 8B583C0257;
        Tue, 26 Apr 2022 08:46:45 +0000 (UTC)
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08EUB002.ant.amazon.com (10.43.166.232) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 26 Apr 2022 08:46:44 +0000
Received: from dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (10.15.60.66)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.32 via Frontend Transport; Tue, 26 Apr 2022 08:46:43 +0000
Received: by dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id B698541131; Tue, 26 Apr 2022 08:46:42 +0000 (UTC)
From:   Maximilian Heyne <mheyne@amazon.de>
CC:     Maximilian Heyne <mheyne@amazon.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers, ixgbe: show VF statistics via ethtool
Date:   Tue, 26 Apr 2022 08:46:35 +0000
Message-ID: <20220426084636.31609-1-mheyne@amazon.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change exports network statistics for individual virtual functions
via ethtool.

The code is taken from the out-of-tree driver.  The feature was
introduced with version 2.0.75.7, so the diff between this version and
the previous version 2.0.72.4 was used to identify required changes.
I took commit c8d4725e985d ("intel: Update drivers to use
ethtool_sprintf") into account and fixed a few style issues.

Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 34 ++++++++++
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 26 ++++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 68 +++++++++++++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  7 ++
 4 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 921a4d977d65..48444ab9e0b1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -167,12 +167,46 @@ enum ixgbe_tx_flags {
 #define IXGBE_82599_VF_DEVICE_ID        0x10ED
 #define IXGBE_X540_VF_DEVICE_ID         0x1515
 
+#define UPDATE_VF_COUNTER_32bit(reg, last_counter, counter)	\
+	{							\
+		u32 current_counter = IXGBE_READ_REG(hw, reg);	\
+		if (current_counter < last_counter)		\
+			counter += 0x100000000LL;		\
+		last_counter = current_counter;			\
+		counter &= 0xFFFFFFFF00000000LL;		\
+		counter |= current_counter;			\
+	}
+
+#define UPDATE_VF_COUNTER_36bit(reg_lsb, reg_msb, last_counter, counter) \
+	{								 \
+		u64 current_counter_lsb = IXGBE_READ_REG(hw, reg_lsb);	 \
+		u64 current_counter_msb = IXGBE_READ_REG(hw, reg_msb);	 \
+		u64 current_counter = (current_counter_msb << 32) |	 \
+			current_counter_lsb;				 \
+		if (current_counter < last_counter)			 \
+			counter += 0x1000000000LL;			 \
+		last_counter = current_counter;				 \
+		counter &= 0xFFFFFFF000000000LL;			 \
+		counter |= current_counter;				 \
+	}
+
+struct vf_stats {
+	u64 gprc;
+	u64 gorc;
+	u64 gptc;
+	u64 gotc;
+	u64 mprc;
+};
+
 struct vf_data_storage {
 	struct pci_dev *vfdev;
 	unsigned char vf_mac_addresses[ETH_ALEN];
 	u16 vf_mc_hashes[IXGBE_MAX_VF_MC_ENTRIES];
 	u16 num_vf_mc_hashes;
 	bool clear_to_send;
+	struct vf_stats vfstats;
+	struct vf_stats last_vfstats;
+	struct vf_stats saved_rst_vfstats;
 	bool pf_set_mac;
 	u16 pf_vlan; /* When set, guest VLAN config not allowed. */
 	u16 pf_qos;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 628d0eb0599f..ae94d927bb46 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -122,9 +122,13 @@ static const struct ixgbe_stats ixgbe_gstrings_stats[] = {
 			 sizeof(((struct ixgbe_adapter *)0)->stats.pxoffrxc) + \
 			 sizeof(((struct ixgbe_adapter *)0)->stats.pxofftxc)) \
 			/ sizeof(u64))
+#define IXGBE_VF_STATS_LEN \
+	((((struct ixgbe_adapter *)netdev_priv(netdev))->num_vfs) * \
+	  (sizeof(struct vf_stats) / sizeof(u64)))
 #define IXGBE_STATS_LEN (IXGBE_GLOBAL_STATS_LEN + \
 			 IXGBE_PB_STATS_LEN + \
-			 IXGBE_QUEUE_STATS_LEN)
+			 IXGBE_QUEUE_STATS_LEN + \
+			 IXGBE_VF_STATS_LEN)
 
 static const char ixgbe_gstrings_test[][ETH_GSTRING_LEN] = {
 	"Register test  (offline)", "Eeprom test    (offline)",
@@ -1302,6 +1306,8 @@ static void ixgbe_get_ethtool_stats(struct net_device *netdev,
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct rtnl_link_stats64 temp;
 	const struct rtnl_link_stats64 *net_stats;
+	u64 *queue_stat;
+	int stat_count, k;
 	unsigned int start;
 	struct ixgbe_ring *ring;
 	int i, j;
@@ -1368,11 +1374,22 @@ static void ixgbe_get_ethtool_stats(struct net_device *netdev,
 		data[i++] = adapter->stats.pxonrxc[j];
 		data[i++] = adapter->stats.pxoffrxc[j];
 	}
+	stat_count = sizeof(struct vf_stats) / sizeof(u64);
+	for (j = 0; j < adapter->num_vfs; j++) {
+		queue_stat = (u64 *)&adapter->vfinfo[j].vfstats;
+		for (k = 0; k < stat_count; k++)
+			data[i + k] = queue_stat[k];
+		queue_stat = (u64 *)&adapter->vfinfo[j].saved_rst_vfstats;
+		for (k = 0; k < stat_count; k++)
+			data[i + k] += queue_stat[k];
+		i += k;
+	}
 }
 
 static void ixgbe_get_strings(struct net_device *netdev, u32 stringset,
 			      u8 *data)
 {
+	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	unsigned int i;
 	u8 *p = data;
 
@@ -1401,6 +1418,13 @@ static void ixgbe_get_strings(struct net_device *netdev, u32 stringset,
 			ethtool_sprintf(&p, "rx_pb_%u_pxon", i);
 			ethtool_sprintf(&p, "rx_pb_%u_pxoff", i);
 		}
+		for (i = 0; i < adapter->num_vfs; i++) {
+			ethtool_sprintf(&p, "VF %u Rx Packets", i);
+			ethtool_sprintf(&p, "VF %u Rx Bytes", i);
+			ethtool_sprintf(&p, "VF %u Tx Packets", i);
+			ethtool_sprintf(&p, "VF %u Tx Bytes", i);
+			ethtool_sprintf(&p, "VF %u MC Packets", i);
+		}
 		/* BUG_ON(p - data != IXGBE_STATS_LEN * ETH_GSTRING_LEN); */
 		break;
 	case ETH_SS_PRIV_FLAGS:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c4a4954aa317..26f6656077a6 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5548,6 +5548,47 @@ static int ixgbe_non_sfp_link_config(struct ixgbe_hw *hw)
 	return ret;
 }
 
+/**
+ * ixgbe_clear_vf_stats_counters - Clear out VF stats after reset
+ * @adapter: board private structure
+ *
+ * On a reset we need to clear out the VF stats or accounting gets
+ * messed up because they're not clear on read.
+ **/
+static void ixgbe_clear_vf_stats_counters(struct ixgbe_adapter *adapter)
+{
+	struct ixgbe_hw *hw = &adapter->hw;
+	int i;
+
+	for (i = 0; i < adapter->num_vfs; i++) {
+		adapter->vfinfo[i].last_vfstats.gprc =
+			IXGBE_READ_REG(hw, IXGBE_PVFGPRC(i));
+		adapter->vfinfo[i].saved_rst_vfstats.gprc +=
+			adapter->vfinfo[i].vfstats.gprc;
+		adapter->vfinfo[i].vfstats.gprc = 0;
+		adapter->vfinfo[i].last_vfstats.gptc =
+			IXGBE_READ_REG(hw, IXGBE_PVFGPTC(i));
+		adapter->vfinfo[i].saved_rst_vfstats.gptc +=
+			adapter->vfinfo[i].vfstats.gptc;
+		adapter->vfinfo[i].vfstats.gptc = 0;
+		adapter->vfinfo[i].last_vfstats.gorc =
+			IXGBE_READ_REG(hw, IXGBE_PVFGORC_LSB(i));
+		adapter->vfinfo[i].saved_rst_vfstats.gorc +=
+			adapter->vfinfo[i].vfstats.gorc;
+		adapter->vfinfo[i].vfstats.gorc = 0;
+		adapter->vfinfo[i].last_vfstats.gotc =
+			IXGBE_READ_REG(hw, IXGBE_PVFGOTC_LSB(i));
+		adapter->vfinfo[i].saved_rst_vfstats.gotc +=
+			adapter->vfinfo[i].vfstats.gotc;
+		adapter->vfinfo[i].vfstats.gotc = 0;
+		adapter->vfinfo[i].last_vfstats.mprc =
+			IXGBE_READ_REG(hw, IXGBE_PVFMPRC(i));
+		adapter->vfinfo[i].saved_rst_vfstats.mprc +=
+			adapter->vfinfo[i].vfstats.mprc;
+		adapter->vfinfo[i].vfstats.mprc = 0;
+	}
+}
+
 static void ixgbe_setup_gpie(struct ixgbe_adapter *adapter)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
@@ -5683,6 +5724,7 @@ static void ixgbe_up_complete(struct ixgbe_adapter *adapter)
 	adapter->link_check_timeout = jiffies;
 	mod_timer(&adapter->service_timer, jiffies);
 
+	ixgbe_clear_vf_stats_counters(adapter);
 	/* Set PF Reset Done bit so PF/VF Mail Ops can work */
 	ctrl_ext = IXGBE_READ_REG(hw, IXGBE_CTRL_EXT);
 	ctrl_ext |= IXGBE_CTRL_EXT_PFRSTD;
@@ -7270,6 +7312,32 @@ void ixgbe_update_stats(struct ixgbe_adapter *adapter)
 	netdev->stats.rx_length_errors = hwstats->rlec;
 	netdev->stats.rx_crc_errors = hwstats->crcerrs;
 	netdev->stats.rx_missed_errors = total_mpc;
+
+	/* VF Stats Collection - skip while resetting because these
+	 * are not clear on read and otherwise you'll sometimes get
+	 * crazy values.
+	 */
+	if (!test_bit(__IXGBE_RESETTING, &adapter->state)) {
+		for (i = 0; i < adapter->num_vfs; i++) {
+			UPDATE_VF_COUNTER_32bit(IXGBE_PVFGPRC(i),
+					adapter->vfinfo[i].last_vfstats.gprc,
+					adapter->vfinfo[i].vfstats.gprc);
+			UPDATE_VF_COUNTER_32bit(IXGBE_PVFGPTC(i),
+					adapter->vfinfo[i].last_vfstats.gptc,
+					adapter->vfinfo[i].vfstats.gptc);
+			UPDATE_VF_COUNTER_36bit(IXGBE_PVFGORC_LSB(i),
+					IXGBE_PVFGORC_MSB(i),
+					adapter->vfinfo[i].last_vfstats.gorc,
+					adapter->vfinfo[i].vfstats.gorc);
+			UPDATE_VF_COUNTER_36bit(IXGBE_PVFGOTC_LSB(i),
+					IXGBE_PVFGOTC_MSB(i),
+					adapter->vfinfo[i].last_vfstats.gotc,
+					adapter->vfinfo[i].vfstats.gotc);
+			UPDATE_VF_COUNTER_32bit(IXGBE_PVFMPRC(i),
+					adapter->vfinfo[i].last_vfstats.mprc,
+					adapter->vfinfo[i].vfstats.mprc);
+		}
+	}
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 6da9880d766a..7f7ea468ffa9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -2533,6 +2533,13 @@ enum {
 #define IXGBE_PVFTXDCTL(P)	(0x06028 + (0x40 * (P)))
 #define IXGBE_PVFTDWBAL(P)	(0x06038 + (0x40 * (P)))
 #define IXGBE_PVFTDWBAH(P)	(0x0603C + (0x40 * (P)))
+#define IXGBE_PVFGPRC(x)	(0x0101C + (0x40 * (x)))
+#define IXGBE_PVFGPTC(x)	(0x08300 + (0x04 * (x)))
+#define IXGBE_PVFGORC_LSB(x)	(0x01020 + (0x40 * (x)))
+#define IXGBE_PVFGORC_MSB(x)	(0x0D020 + (0x40 * (x)))
+#define IXGBE_PVFGOTC_LSB(x)	(0x08400 + (0x08 * (x)))
+#define IXGBE_PVFGOTC_MSB(x)	(0x08404 + (0x08 * (x)))
+#define IXGBE_PVFMPRC(x)	(0x0D01C + (0x40 * (x)))
 
 #define IXGBE_PVFTDWBALn(q_per_pool, vf_number, vf_q_index) \
 		(IXGBE_PVFTDWBAL((q_per_pool)*(vf_number) + (vf_q_index)))
-- 
2.32.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



