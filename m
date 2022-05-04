Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FC9519BD6
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347528AbiEDJgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347182AbiEDJf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:35:57 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC6326120;
        Wed,  4 May 2022 02:31:42 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1A1FF4000F;
        Wed,  4 May 2022 09:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651656701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vv9EtNZTY/sEXKVDMMtP9kiIX0iRyUSPJ5FRMJSzwfM=;
        b=jGnWHirHuXMYa345eCGHs62TYXEmRiKZhmV7oeToFPUe8SZPV1d3VkQoAeqqOTb2DWk5bX
        +In3QqLTJfGlmJ3s5KxOxeWJjp809b/JDSWcjPZ0/oeKFizxcxD1dwf6xZfG78Hdj3jBdS
        LRpKTzEcX4KFHGsMKxmVyh0cHFC5TEHqIIkWaigI4MnzaWH6o6bP4KxBLozSkoJXXYspQG
        q1f2KOoI7itaigsjBNZ4wBzHenO8NfXUIcij13bFpezbV9js1qRtTOFvSYGbDA0asuDhuM
        bi0LD5paTLNbAS2I58CvCaxyC5PwHgTf2uoXdBFAG1vxRAGwhVnQbVRMm+ZFsA==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 07/12] net: dsa: rzn1-a5psw: add statistics support
Date:   Wed,  4 May 2022 11:29:55 +0200
Message-Id: <20220504093000.132579-8-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220504093000.132579-1-clement.leger@bootlin.com>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add statistics support to the rzn1-a5psw driver by implementing the
following dsa_switch_ops callbacks:
- get_sset_count()
- get_strings()
- get_ethtool_stats()
- get_eth_mac_stats()
- get_eth_ctrl_stats()
- get_rmon_stats()

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/dsa/rzn1_a5psw.c | 178 +++++++++++++++++++++++++++++++++++
 drivers/net/dsa/rzn1_a5psw.h |  46 ++++++++-
 2 files changed, 223 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index b413e9ad7050..7268bfbea26d 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -16,6 +16,61 @@
 
 #include "rzn1_a5psw.h"
 
+struct a5psw_stats {
+	u16 offset;
+	const char name[ETH_GSTRING_LEN];
+};
+
+#define STAT_DESC(_offset, _name) {.offset = _offset, .name = _name}
+
+static const struct a5psw_stats a5psw_stats[] = {
+	STAT_DESC(A5PSW_aFramesTransmittedOK, "aFrameTransmittedOK"),
+	STAT_DESC(A5PSW_aFramesReceivedOK, "aFrameReceivedOK"),
+	STAT_DESC(A5PSW_aFrameCheckSequenceErrors, "aFrameCheckSequenceErrors"),
+	STAT_DESC(A5PSW_aAlignmentErrors, "aAlignmentErrors"),
+	STAT_DESC(A5PSW_aOctetsTransmittedOK, "aOctetsTransmittedOK"),
+	STAT_DESC(A5PSW_aOctetsReceivedOK, "aOctetsReceivedOK"),
+	STAT_DESC(A5PSW_aTxPAUSEMACCtrlFrames, "aTxPAUSEMACCtrlFrames"),
+	STAT_DESC(A5PSW_aRxPAUSEMACCtrlFrames, "aRxPAUSEMACCtrlFrames"),
+	STAT_DESC(A5PSW_ifInErrors, "ifInErrors"),
+	STAT_DESC(A5PSW_ifOutErrors, "ifOutErrors"),
+	STAT_DESC(A5PSW_ifInUcastPkts, "ifInUcastPkts"),
+	STAT_DESC(A5PSW_ifInMulticastPkts, "ifInMulticastPkts"),
+	STAT_DESC(A5PSW_ifInBroadcastPkts, "ifInBroadcastPkts"),
+	STAT_DESC(A5PSW_ifOutDiscards, "ifOutDiscards"),
+	STAT_DESC(A5PSW_ifOutUcastPkts, "ifOutUcastPkts"),
+	STAT_DESC(A5PSW_ifOutMulticastPkts, "ifOutMulticastPkts"),
+	STAT_DESC(A5PSW_ifOutBroadcastPkts, "ifOutBroadcastPkts"),
+	STAT_DESC(A5PSW_etherStatsDropEvents, "etherStatsDropEvents"),
+	STAT_DESC(A5PSW_etherStatsOctets, "etherStatsOctets"),
+	STAT_DESC(A5PSW_etherStatsPkts, "etherStatsPkts"),
+	STAT_DESC(A5PSW_etherStatsUndersizePkts, "etherStatsUndersizePkts"),
+	STAT_DESC(A5PSW_etherStatsOversizePkts, "etherStatsOversizePkts"),
+	STAT_DESC(A5PSW_etherStatsPkts64Octets, "etherStatsPkts64Octets"),
+	STAT_DESC(A5PSW_etherStatsPkts65to127Octets,
+		  "etherStatsPkts65to127Octets"),
+	STAT_DESC(A5PSW_etherStatsPkts128to255Octets,
+		  "etherStatsPkts128to255Octets"),
+	STAT_DESC(A5PSW_etherStatsPkts256to511Octets,
+		  "etherStatsPkts256to511Octets"),
+	STAT_DESC(A5PSW_etherStatsPkts512to1023Octets,
+		  "etherStatsPkts512to1023Octets"),
+	STAT_DESC(A5PSW_etherStatsPkts1024to1518Octets,
+		  "etherStatsPkts1024to1518Octets"),
+	STAT_DESC(A5PSW_etherStatsPkts1519toXOctets,
+		  "etherStatsPkts1519toXOctets"),
+	STAT_DESC(A5PSW_etherStatsJabbers, "etherStatsJabbers"),
+	STAT_DESC(A5PSW_etherStatsFragments, "etherStatsFragments"),
+	STAT_DESC(A5PSW_VLANReceived, "VLANReceived"),
+	STAT_DESC(A5PSW_VLANTransmitted, "VLANTransmitted"),
+	STAT_DESC(A5PSW_aDeferred, "aDeferred"),
+	STAT_DESC(A5PSW_aMultipleCollisions, "aMultipleCollisions"),
+	STAT_DESC(A5PSW_aSingleCollisions, "aSingleCollisions"),
+	STAT_DESC(A5PSW_aLateCollisions, "aLateCollisions"),
+	STAT_DESC(A5PSW_aExcessiveCollisions, "aExcessiveCollisions"),
+	STAT_DESC(A5PSW_aCarrierSenseErrors, "aCarrierSenseErrors"),
+};
+
 static void a5psw_reg_writel(struct a5psw *a5psw, int offset, u32 value)
 {
 	writel(value, a5psw->base + offset);
@@ -322,6 +377,123 @@ static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
 	a5psw_port_fdb_flush(a5psw, port);
 }
 
+static u64 a5psw_read_stat(struct a5psw *a5psw, u32 offset, int port)
+{
+	u32 reg_lo, reg_hi;
+
+	reg_lo = a5psw_reg_readl(a5psw, offset + A5PSW_PORT_OFFSET(port));
+	/* A5PSW_STATS_HIWORD is latched on stat read */
+	reg_hi = a5psw_reg_readl(a5psw, A5PSW_STATS_HIWORD);
+
+	return ((u64)reg_hi << 32) | reg_lo;
+}
+
+static void a5psw_get_strings(struct dsa_switch *ds, int port, u32 stringset,
+			      uint8_t *data)
+{
+	unsigned int u;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (u = 0; u < ARRAY_SIZE(a5psw_stats); u++) {
+		memcpy(data + u * ETH_GSTRING_LEN, a5psw_stats[u].name,
+		       ETH_GSTRING_LEN);
+	}
+}
+
+static void a5psw_get_ethtool_stats(struct dsa_switch *ds, int port,
+				    uint64_t *data)
+{
+	struct a5psw *a5psw = ds->priv;
+	unsigned int u;
+
+	for (u = 0; u < ARRAY_SIZE(a5psw_stats); u++)
+		data[u] = a5psw_read_stat(a5psw, a5psw_stats[u].offset, port);
+}
+
+static int a5psw_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	return ARRAY_SIZE(a5psw_stats);
+}
+
+static void a5psw_get_eth_mac_stats(struct dsa_switch *ds, int port,
+				    struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct a5psw *a5psw = ds->priv;
+
+#define RD(name) a5psw_read_stat(a5psw, A5PSW_##name, port)
+	mac_stats->FramesTransmittedOK = RD(aFramesTransmittedOK);
+	mac_stats->SingleCollisionFrames = RD(aSingleCollisions);
+	mac_stats->MultipleCollisionFrames = RD(aMultipleCollisions);
+	mac_stats->FramesReceivedOK = RD(aFramesReceivedOK);
+	mac_stats->FrameCheckSequenceErrors = RD(aFrameCheckSequenceErrors);
+	mac_stats->AlignmentErrors = RD(aAlignmentErrors);
+	mac_stats->OctetsTransmittedOK = RD(aOctetsTransmittedOK);
+	mac_stats->FramesWithDeferredXmissions = RD(aDeferred);
+	mac_stats->LateCollisions = RD(aLateCollisions);
+	mac_stats->FramesAbortedDueToXSColls = RD(aExcessiveCollisions);
+	mac_stats->FramesLostDueToIntMACXmitError = RD(ifOutErrors);
+	mac_stats->CarrierSenseErrors = RD(aCarrierSenseErrors);
+	mac_stats->OctetsReceivedOK = RD(aOctetsReceivedOK);
+	mac_stats->FramesLostDueToIntMACRcvError = RD(ifInErrors);
+	mac_stats->MulticastFramesXmittedOK = RD(ifOutMulticastPkts);
+	mac_stats->BroadcastFramesXmittedOK = RD(ifOutBroadcastPkts);
+	mac_stats->FramesWithExcessiveDeferral = RD(aDeferred);
+	mac_stats->MulticastFramesReceivedOK = RD(ifInMulticastPkts);
+	mac_stats->BroadcastFramesReceivedOK = RD(ifInBroadcastPkts);
+#undef RD
+}
+
+static const struct ethtool_rmon_hist_range a5psw_rmon_ranges[] = {
+	{ 0, 64 },
+	{ 65, 127 },
+	{ 128, 255 },
+	{ 256, 511 },
+	{ 512, 1023 },
+	{ 1024, 1518 },
+	{ 1519, A5PSW_MAX_MTU },
+	{}
+};
+
+static void a5psw_get_rmon_stats(struct dsa_switch *ds, int port,
+				 struct ethtool_rmon_stats *rmon_stats,
+				 const struct ethtool_rmon_hist_range **ranges)
+{
+	struct a5psw *a5psw = ds->priv;
+
+#define RD(name) a5psw_read_stat(a5psw, A5PSW_##name, port)
+	rmon_stats->undersize_pkts = RD(etherStatsUndersizePkts);
+	rmon_stats->oversize_pkts = RD(etherStatsOversizePkts);
+	rmon_stats->fragments = RD(etherStatsFragments);
+	rmon_stats->jabbers = RD(etherStatsJabbers);
+	rmon_stats->hist[0] = RD(etherStatsPkts64Octets);
+	rmon_stats->hist[1] = RD(etherStatsPkts65to127Octets);
+	rmon_stats->hist[2] = RD(etherStatsPkts128to255Octets);
+	rmon_stats->hist[3] = RD(etherStatsPkts256to511Octets);
+	rmon_stats->hist[4] = RD(etherStatsPkts512to1023Octets);
+	rmon_stats->hist[5] = RD(etherStatsPkts1024to1518Octets);
+	rmon_stats->hist[6] = RD(etherStatsPkts1519toXOctets);
+#undef RD
+
+	*ranges = a5psw_rmon_ranges;
+}
+
+static void a5psw_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
+				     struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct a5psw *a5psw = ds->priv;
+	u64 stat;
+
+	stat = a5psw_read_stat(a5psw, A5PSW_aTxPAUSEMACCtrlFrames, port);
+	ctrl_stats->MACControlFramesTransmitted = stat;
+	stat = a5psw_read_stat(a5psw, A5PSW_aRxPAUSEMACCtrlFrames, port);
+	ctrl_stats->MACControlFramesReceived = stat;
+}
+
 static int a5psw_setup(struct dsa_switch *ds)
 {
 	struct a5psw *a5psw = ds->priv;
@@ -410,6 +582,12 @@ static const struct dsa_switch_ops a5psw_switch_ops = {
 	.phylink_mac_link_up = a5psw_phylink_mac_link_up,
 	.port_change_mtu = a5psw_port_change_mtu,
 	.port_max_mtu = a5psw_port_max_mtu,
+	.get_sset_count = a5psw_get_sset_count,
+	.get_strings = a5psw_get_strings,
+	.get_ethtool_stats = a5psw_get_ethtool_stats,
+	.get_eth_mac_stats = a5psw_get_eth_mac_stats,
+	.get_eth_ctrl_stats = a5psw_get_eth_ctrl_stats,
+	.get_rmon_stats = a5psw_get_rmon_stats,
 	.set_ageing_time = a5psw_set_ageing_time,
 	.port_bridge_join = a5psw_port_bridge_join,
 	.port_bridge_leave = a5psw_port_bridge_leave,
diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
index fd3cff2cf1de..149fa82b19e1 100644
--- a/drivers/net/dsa/rzn1_a5psw.h
+++ b/drivers/net/dsa/rzn1_a5psw.h
@@ -146,7 +146,50 @@
 
 #define A5PSW_STATS_HIWORD		0x900
 
-#define A5PSW_DUMMY_WORKAROUND		0x5000
+/* Stats */
+#define A5PSW_aFramesTransmittedOK		0x868
+#define A5PSW_aFramesReceivedOK			0x86C
+#define A5PSW_aFrameCheckSequenceErrors		0x870
+#define A5PSW_aAlignmentErrors			0x874
+#define A5PSW_aOctetsTransmittedOK		0x878
+#define A5PSW_aOctetsReceivedOK			0x87C
+#define A5PSW_aTxPAUSEMACCtrlFrames		0x880
+#define A5PSW_aRxPAUSEMACCtrlFrames		0x884
+	/* If */
+#define A5PSW_ifInErrors			0x888
+#define A5PSW_ifOutErrors			0x88C
+#define A5PSW_ifInUcastPkts			0x890
+#define A5PSW_ifInMulticastPkts			0x894
+#define A5PSW_ifInBroadcastPkts			0x898
+#define A5PSW_ifOutDiscards			0x89C
+#define A5PSW_ifOutUcastPkts			0x8A0
+#define A5PSW_ifOutMulticastPkts		0x8A4
+#define A5PSW_ifOutBroadcastPkts		0x8A8
+	/* Ether */
+#define A5PSW_etherStatsDropEvents		0x8AC
+#define A5PSW_etherStatsOctets			0x8B0
+#define A5PSW_etherStatsPkts			0x8B4
+#define A5PSW_etherStatsUndersizePkts		0x8B8
+#define A5PSW_etherStatsOversizePkts		0x8BC
+#define A5PSW_etherStatsPkts64Octets		0x8C0
+#define A5PSW_etherStatsPkts65to127Octets	0x8C4
+#define A5PSW_etherStatsPkts128to255Octets	0x8C8
+#define A5PSW_etherStatsPkts256to511Octets	0x8CC
+#define A5PSW_etherStatsPkts512to1023Octets	0x8D0
+#define A5PSW_etherStatsPkts1024to1518Octets	0x8D4
+#define A5PSW_etherStatsPkts1519toXOctets	0x8D8
+#define A5PSW_etherStatsJabbers			0x8DC
+#define A5PSW_etherStatsFragments		0x8E0
+
+#define A5PSW_VLANReceived			0x8E8
+#define A5PSW_VLANTransmitted			0x8EC
+
+#define A5PSW_aDeferred				0x910
+#define A5PSW_aMultipleCollisions		0x914
+#define A5PSW_aSingleCollisions			0x918
+#define A5PSW_aLateCollisions			0x91C
+#define A5PSW_aExcessiveCollisions		0x920
+#define A5PSW_aCarrierSenseErrors		0x924
 
 #define A5PSW_VLAN_TAG(prio, id)	(((prio) << 12) | (id))
 #define A5PSW_PORTS_NUM			5
@@ -179,6 +222,7 @@
  * @mdio_freq: MDIO bus frequency requested
  * @pcs: Array of PCS connected to the switch ports (not for the CPU)
  * @ds: DSA switch struct
+ * @stats_lock: lock to access statistics (shared HI counter)
  * @lk_lock: Lock for the lookup table
  * @reg_lock: Lock for register read-modify-write operation
  * @bridged_ports: List of ports that are bridged and should be flooded
-- 
2.34.1

