Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC7B51FACC
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 13:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiEILIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 07:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiEILIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 07:08:02 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ED11F7E01;
        Mon,  9 May 2022 04:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1652094250; x=1683630250;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=075BsDc5HXl7kI8wpEo4V8pVRoj8X6Y+Wcpcup/WQ8Q=;
  b=UuNbkJpTadYJ2XUEMbZc+xccGI5rY3u6oufxdY3322NfZhg8iMOKFHtn
   REXRFtTnKXL6D2trS9L8iBHAiMN0iNCnhiZ7+x6vGwJvalyOazlZaRBf7
   /QjuGl9tTwYJGMTp2MZmqpEhorsI/JO83GiIt9EKL/c9Pi/jeHljGq8j+
   w=;
X-IronPort-AV: E=Sophos;i="5.91,211,1647302400"; 
   d="scan'208";a="86603329"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 09 May 2022 11:03:53 +0000
Received: from EX13D08EUB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com (Postfix) with ESMTPS id 2A3E88A98D;
        Mon,  9 May 2022 11:03:52 +0000 (UTC)
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08EUB002.ant.amazon.com (10.43.166.232) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Mon, 9 May 2022 11:03:50 +0000
Received: from dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (10.15.60.66)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.32 via Frontend Transport; Mon, 9 May 2022 11:03:49 +0000
Received: by dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id CA7E841131; Mon,  9 May 2022 11:03:48 +0000 (UTC)
From:   Maximilian Heyne <mheyne@amazon.de>
CC:     Maximilian Heyne <mheyne@amazon.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3] drivers, ixgbe: export vf statistics
Date:   Mon, 9 May 2022 11:03:39 +0000
Message-ID: <20220509110340.100814-1-mheyne@amazon.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change retrieves network metrics for virtual functions from the
device and exports them via the iproute2 interface.

The code for retrieving the statistics from the device is taken from the
out-of-tree driver.  The feature was introduced with version 2.0.75.7,
so the diff between this version and the previous version 2.0.72.4 was
used to identify required changes. The export via ethtool is omitted in
favor of using the standard ndo_get_vf_stats interface.

Per-VF statistics can now be printed, for instance, via

  ip --statistics link show dev eth0

Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
---
v2: implemented the ndo_get_vf_stats callback
v3: as per discussion, removed the ethtool changes

 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 34 ++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 86 +++++++++++++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  7 ++
 3 files changed, 127 insertions(+)

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
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c4a4954aa317..f60d8b425f61 100644
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
@@ -8995,6 +9063,23 @@ static void ixgbe_get_stats64(struct net_device *netdev,
 	stats->rx_missed_errors	= netdev->stats.rx_missed_errors;
 }
 
+static int ixgbe_ndo_get_vf_stats(struct net_device *netdev, int vf,
+				  struct ifla_vf_stats *vf_stats)
+{
+	struct ixgbe_adapter *adapter = netdev_priv(netdev);
+
+	if (vf < 0 || vf >= adapter->num_vfs)
+		return -EINVAL;
+
+	vf_stats->rx_packets = adapter->vfinfo[vf].vfstats.gprc;
+	vf_stats->rx_bytes   = adapter->vfinfo[vf].vfstats.gorc;
+	vf_stats->tx_packets = adapter->vfinfo[vf].vfstats.gptc;
+	vf_stats->tx_bytes   = adapter->vfinfo[vf].vfstats.gotc;
+	vf_stats->multicast  = adapter->vfinfo[vf].vfstats.mprc;
+
+	return 0;
+}
+
 #ifdef CONFIG_IXGBE_DCB
 /**
  * ixgbe_validate_rtr - verify 802.1Qp to Rx packet buffer mapping is valid.
@@ -10311,6 +10396,7 @@ static const struct net_device_ops ixgbe_netdev_ops = {
 	.ndo_set_vf_rss_query_en = ixgbe_ndo_set_vf_rss_query_en,
 	.ndo_set_vf_trust	= ixgbe_ndo_set_vf_trust,
 	.ndo_get_vf_config	= ixgbe_ndo_get_vf_config,
+	.ndo_get_vf_stats	= ixgbe_ndo_get_vf_stats,
 	.ndo_get_stats64	= ixgbe_get_stats64,
 	.ndo_setup_tc		= __ixgbe_setup_tc,
 #ifdef IXGBE_FCOE
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



