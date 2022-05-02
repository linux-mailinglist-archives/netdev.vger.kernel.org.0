Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A485173D9
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbiEBQNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241030AbiEBQNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:13:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FCADEFB;
        Mon,  2 May 2022 09:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651507793; x=1683043793;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UIm1NdDvCbc7IiWWXgtYHjd92d9j0g5Uaol19nZC4bU=;
  b=InrGMpzTXb/4tosFZ417yNUdLL/fcTieDR3GerrPdoT+8VHYXUaH7cDe
   zfskSpltJJE5TviBnYzb0OkbZydkKV8x6VjjLmVVSLMUbKX8px8Pe+Z6n
   ie41B96w0eaRgZW9AIE7xs3vmOfuvL94ZCvsgdGM3VNKtwE1npxFsrdvi
   MRwSnYhCqJfTPvdkDS2LXKdvloxIcFhCDxGT5iLrsNEftpHU7i/q0sbs/
   E5hVqW9dx/TqzhZb86zqBMVJ/UrvW81QysAK0JEvqJZKDhPelLaddoB7R
   KQPGZLIR2LDzIHJwjn1a+sHzT/IQE/H5NH+np8D5F7Z2ApvsakHOxrN6I
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="162442257"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2022 09:09:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 2 May 2022 09:09:51 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 2 May 2022 09:09:31 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [Patch net-next v12 10/13] net: dsa: microchip: add support for ethtool port counters
Date:   Mon, 2 May 2022 21:39:24 +0530
Message-ID: <20220502160924.7361-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

Added support for get_eth_**_stats() (phy/mac/ctrl) and
get_stats64()

Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
along with relevant lan937x hooks for KSZ common layer and added
support for get_strings()

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/lan937x_dev.c  | 107 +++++++++++++++++++++-
 drivers/net/dsa/microchip/lan937x_dev.h  |  47 ++++++++++
 drivers/net/dsa/microchip/lan937x_main.c | 109 +++++++++++++++++++++++
 3 files changed, 262 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
index 4612642e8f5e..b154bc52f64a 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.c
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -16,6 +16,45 @@
 #include "ksz_common.h"
 #include "lan937x_dev.h"
 
+const struct mib_names lan937x_mib_names[] = {
+	{ 0x00, "rx_hi" },
+	{ 0x01, "rx_undersize" },
+	{ 0x02, "rx_fragments" },
+	{ 0x03, "rx_oversize" },
+	{ 0x04, "rx_jabbers" },
+	{ 0x05, "rx_symbol_err" },
+	{ 0x06, "rx_crc_err" },
+	{ 0x07, "rx_align_err" },
+	{ 0x08, "rx_mac_ctrl" },
+	{ 0x09, "rx_pause" },
+	{ 0x0A, "rx_bcast" },
+	{ 0x0B, "rx_mcast" },
+	{ 0x0C, "rx_ucast" },
+	{ 0x0D, "rx_64_or_less" },
+	{ 0x0E, "rx_65_127" },
+	{ 0x0F, "rx_128_255" },
+	{ 0x10, "rx_256_511" },
+	{ 0x11, "rx_512_1023" },
+	{ 0x12, "rx_1024_1522" },
+	{ 0x13, "rx_1523_2000" },
+	{ 0x14, "rx_2001" },
+	{ 0x15, "tx_hi" },
+	{ 0x16, "tx_late_col" },
+	{ 0x17, "tx_pause" },
+	{ 0x18, "tx_bcast" },
+	{ 0x19, "tx_mcast" },
+	{ 0x1A, "tx_ucast" },
+	{ 0x1B, "tx_deferred" },
+	{ 0x1C, "tx_total_col" },
+	{ 0x1D, "tx_exc_col" },
+	{ 0x1E, "tx_single_col" },
+	{ 0x1F, "tx_mult_col" },
+	{ 0x80, "rx_total" },
+	{ 0x81, "tx_total" },
+	{ 0x82, "rx_discards" },
+	{ 0x83, "tx_discards" },
+};
+
 int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	return regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -93,6 +132,53 @@ static void lan937x_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
+static void lan937x_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
+			      u64 *cnt)
+{
+	unsigned int val;
+	u32 data;
+	int ret;
+
+	/* Enable MIB Counter read */
+	data = MIB_COUNTER_READ;
+	data |= (addr << MIB_COUNTER_INDEX_S);
+	lan937x_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT, data);
+
+	ret = regmap_read_poll_timeout(dev->regmap[2],
+				       PORT_CTRL_ADDR(port,
+						      REG_PORT_MIB_CTRL_STAT),
+				       val, !(val & MIB_COUNTER_READ),
+				       10, 1000);
+	if (ret) {
+		dev_err(dev->dev, "Failed to get MIB\n");
+		return;
+	}
+
+	/* count resets upon read */
+	lan937x_pread32(dev, port, REG_PORT_MIB_DATA, &data);
+	*cnt += data;
+}
+
+void lan937x_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+		       u64 *dropped, u64 *cnt)
+{
+	addr = lan937x_mib_names[addr].index;
+	lan937x_r_mib_cnt(dev, port, addr, cnt);
+}
+
+static void lan937x_port_init_cnt(struct ksz_device *dev, int port)
+{
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+
+	/* flush all enabled port MIB counters */
+	mutex_lock(&mib->cnt_mutex);
+	lan937x_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT,
+			 MIB_COUNTER_FLUSH_FREEZE);
+	ksz_write8(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FLUSH);
+	lan937x_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT, 0);
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 int lan937x_reset_switch(struct ksz_device *dev)
 {
 	u32 data32;
@@ -573,7 +659,7 @@ static int lan937x_mdio_register(struct ksz_device *dev)
 
 static int lan937x_switch_init(struct ksz_device *dev)
 {
-	int ret;
+	int i, ret;
 
 	dev->ds->ops = &lan937x_switch_ops;
 
@@ -584,12 +670,27 @@ static int lan937x_switch_init(struct ksz_device *dev)
 
 	dev->port_mask = (1 << dev->port_cnt) - 1;
 
+	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
+	dev->mib_cnt = ARRAY_SIZE(lan937x_mib_names);
+
 	dev->ports = devm_kzalloc(dev->dev,
 				  dev->port_cnt * sizeof(struct ksz_port),
 				  GFP_KERNEL);
 	if (!dev->ports)
 		return -ENOMEM;
 
+	for (i = 0; i < dev->port_cnt; i++) {
+		spin_lock_init(&dev->ports[i].mib.stats64_lock);
+		mutex_init(&dev->ports[i].mib.cnt_mutex);
+		dev->ports[i].mib.counters =
+			devm_kzalloc(dev->dev,
+				     sizeof(u64) * (dev->mib_cnt + 1),
+				     GFP_KERNEL);
+
+		if (!dev->ports[i].mib.counters)
+			return -ENOMEM;
+	}
+
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->port_cnt;
 	return 0;
@@ -626,6 +727,10 @@ const struct ksz_dev_ops lan937x_dev_ops = {
 	.cfg_port_member = lan937x_cfg_port_member,
 	.flush_dyn_mac_table = lan937x_flush_dyn_mac_table,
 	.port_setup = lan937x_port_setup,
+	.r_mib_cnt = lan937x_r_mib_cnt,
+	.r_mib_pkt = lan937x_r_mib_pkt,
+	.port_init_cnt = lan937x_port_init_cnt,
+	.r_mib_stat64 = ksz_r_mib_stats64,
 	.shutdown = lan937x_reset_switch,
 	.detect = lan937x_switch_detect,
 	.init = lan937x_init,
diff --git a/drivers/net/dsa/microchip/lan937x_dev.h b/drivers/net/dsa/microchip/lan937x_dev.h
index 0141d417c446..147800550162 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.h
+++ b/drivers/net/dsa/microchip/lan937x_dev.h
@@ -38,8 +38,55 @@ void lan937x_config_interface(struct ksz_device *dev, int port,
 			      bool tx_pause, bool rx_pause);
 void lan937x_mac_config(struct ksz_device *dev, int port,
 			phy_interface_t interface);
+void lan937x_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+		       u64 *dropped, u64 *cnt);
+
+struct mib_names {
+	int index;
+	char string[ETH_GSTRING_LEN];
+};
+
+enum lan937x_mib_list {
+	lan937x_mib_rx_hi_pri_byte = 0,
+	lan937x_mib_rx_undersize,
+	lan937x_mib_rx_fragments,
+	lan937x_mib_rx_oversize,
+	lan937x_mib_rx_jabbers,
+	lan937x_mib_rx_sym_err,
+	lan937x_mib_rx_crc_err,
+	lan937x_mib_rx_align_err,
+	lan937x_mib_rx_mac_ctrl,
+	lan937x_mib_rx_pause,
+	lan937x_mib_rx_bcast,
+	lan937x_mib_rx_mcast,
+	lan937x_mib_rx_ucast,
+	lan937x_mib_rx_64_or_less,
+	lan937x_mib_rx_65_127,
+	lan937x_mib_rx_128_255,
+	lan937x_mib_rx_256_511,
+	lan937x_mib_rx_512_1023,
+	lan937x_mib_rx_1024_1522,
+	lan937x_mib_rx_1523_2000,
+	lan937x_mib_rx_2001,
+	lan937x_mib_tx_hi_pri_byte,
+	lan937x_mib_tx_late_col,
+	lan937x_mib_tx_pause,
+	lan937x_mib_tx_bcast,
+	lan937x_mib_tx_mcast,
+	lan937x_mib_tx_ucast,
+	lan937x_mib_tx_deferred,
+	lan937x_mib_tx_total_col,
+	lan937x_mib_tx_exc_col,
+	lan937x_mib_tx_single_col,
+	lan937x_mib_tx_mult_col,
+	lan937x_mib_rx_total,
+	lan937x_mib_tx_total,
+	lan937x_mib_rx_discard,
+	lan937x_mib_tx_discard,
+};
 
 extern const struct dsa_switch_ops lan937x_switch_ops;
 extern const struct ksz_dev_ops lan937x_dev_ops;
+extern const struct mib_names lan937x_mib_names[];
 
 #endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 38d5311bf21f..6d0b0d62b8e1 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -45,6 +45,20 @@ static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
 	return lan937x_internal_phy_write(dev, addr, reg, val);
 }
 
+static void lan937x_get_strings(struct dsa_switch *ds, int port, u32 stringset,
+				u8 *buf)
+{
+	struct ksz_device *dev = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < dev->mib_cnt; i++)
+		memcpy(buf + i * ETH_GSTRING_LEN, lan937x_mib_names[i].string,
+		       ETH_GSTRING_LEN);
+}
+
 static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 				       u8 state)
 {
@@ -215,6 +229,8 @@ static int lan937x_setup(struct dsa_switch *ds)
 	/* start switch */
 	lan937x_cfg(dev, REG_SW_OPERATION, SW_START, true);
 
+	ksz_init_mib_timer(dev);
+
 	return 0;
 }
 
@@ -320,12 +336,105 @@ static void lan937x_phylink_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
+static void lan937x_get_eth_phy_stats(struct dsa_switch *ds, int port,
+				      struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *cnt;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[lan937x_mib_rx_sym_err];
+	lan937x_r_mib_pkt(dev, port, lan937x_mib_rx_sym_err, NULL, cnt);
+
+	phy_stats->SymbolErrorDuringCarrier = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
+static void lan937x_get_eth_mac_stats(struct dsa_switch *ds, int port,
+				      struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *ctr = mib->counters;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	while (mib->cnt_ptr < dev->mib_cnt) {
+		lan937x_r_mib_pkt(dev, port, mib->cnt_ptr,
+				  NULL, &mib->counters[mib->cnt_ptr]);
+		++mib->cnt_ptr;
+	}
+
+	mac_stats->FramesTransmittedOK = ctr[lan937x_mib_tx_mcast] +
+					 ctr[lan937x_mib_tx_bcast] +
+					 ctr[lan937x_mib_tx_ucast] +
+					 ctr[lan937x_mib_tx_pause];
+
+	mac_stats->SingleCollisionFrames = ctr[lan937x_mib_tx_single_col];
+	mac_stats->MultipleCollisionFrames = ctr[lan937x_mib_tx_mult_col];
+
+	mac_stats->FramesReceivedOK = ctr[lan937x_mib_rx_mcast] +
+				      ctr[lan937x_mib_rx_bcast] +
+				      ctr[lan937x_mib_rx_ucast] +
+				      ctr[lan937x_mib_rx_pause];
+
+	mac_stats->FrameCheckSequenceErrors = ctr[lan937x_mib_rx_crc_err];
+	mac_stats->AlignmentErrors = ctr[lan937x_mib_rx_align_err];
+	mac_stats->OctetsTransmittedOK = ctr[lan937x_mib_tx_total];
+	mac_stats->FramesWithDeferredXmissions = ctr[lan937x_mib_tx_deferred];
+	mac_stats->LateCollisions = ctr[lan937x_mib_tx_late_col];
+	mac_stats->FramesAbortedDueToXSColls = ctr[lan937x_mib_tx_exc_col];
+	mac_stats->FramesLostDueToIntMACXmitError = ctr[lan937x_mib_tx_discard];
+
+	mac_stats->OctetsReceivedOK = ctr[lan937x_mib_rx_total];
+	mac_stats->FramesLostDueToIntMACRcvError = ctr[lan937x_mib_rx_discard];
+	mac_stats->MulticastFramesXmittedOK = ctr[lan937x_mib_tx_mcast];
+	mac_stats->BroadcastFramesXmittedOK = ctr[lan937x_mib_tx_bcast];
+
+	mac_stats->MulticastFramesReceivedOK = ctr[lan937x_mib_rx_mcast];
+	mac_stats->BroadcastFramesReceivedOK = ctr[lan937x_mib_rx_bcast];
+	mac_stats->InRangeLengthErrors = ctr[lan937x_mib_rx_fragments];
+
+	mib->cnt_ptr = 0;
+	mutex_unlock(&mib->cnt_mutex);
+}
+
+static void lan937x_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
+				       struct ethtool_eth_ctrl_stats *ctrl_sts)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *cnt;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[lan937x_mib_rx_pause];
+	lan937x_r_mib_pkt(dev, port, lan937x_mib_rx_pause, NULL, cnt);
+	ctrl_sts->MACControlFramesReceived = *cnt;
+
+	cnt = &mib->counters[lan937x_mib_tx_pause];
+	lan937x_r_mib_pkt(dev, port, lan937x_mib_tx_pause, NULL, cnt);
+	ctrl_sts->MACControlFramesTransmitted = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 const struct dsa_switch_ops lan937x_switch_ops = {
 	.get_tag_protocol = lan937x_get_tag_protocol,
 	.setup = lan937x_setup,
 	.phy_read = lan937x_phy_read16,
 	.phy_write = lan937x_phy_write16,
 	.port_enable = ksz_enable_port,
+	.get_strings = lan937x_get_strings,
+	.get_ethtool_stats = ksz_get_ethtool_stats,
+	.get_sset_count = ksz_sset_count,
+	.get_eth_ctrl_stats = lan937x_get_eth_ctrl_stats,
+	.get_eth_mac_stats = lan937x_get_eth_mac_stats,
+	.get_eth_phy_stats = lan937x_get_eth_phy_stats,
+	.get_stats64 = ksz_get_stats64,
 	.port_bridge_join = ksz_port_bridge_join,
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
-- 
2.33.0

