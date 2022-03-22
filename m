Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5494E470E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 20:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiCVT5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 15:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbiCVT5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 15:57:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DF94ECCA;
        Tue, 22 Mar 2022 12:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647978949; x=1679514949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X7ECDYnJ4KU3fMPTtb68Clefey+0lZdfZ5b6r0T7tZY=;
  b=VNfXsQ0pNnqrBFVRQRZq9cYqCJCskzxoUVCAxGlwuGhhYCC0Qh8vSLVr
   O5QipLZKzjwmtZmm054BRtdfJcLJwGGry4CcCSKe/U12EmZp7uOZgpMal
   dQZ6FQsmxYQ2olj00zRfla/iU9SL0It4Ga62xXfmbFO//23hhU5d04gwf
   Xq0qbU9E47AoWXgVJ5+TmbXqwHfF6CEqq4QSibst9WfVkB+6HhOTcNrlO
   DllUq7IFHMT84k+POrBUdbhd7HcYPMKafOtD9Kpk5IBGyeG3YSkowpdKd
   39/T+yUkd/FjoLTc17a4bhdFF9OWL15ThjmB/H+PpjG1f0fWf2cBtAkPI
   g==;
X-IronPort-AV: E=Sophos;i="5.90,202,1643698800"; 
   d="scan'208";a="157797688"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2022 12:55:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 22 Mar 2022 12:55:48 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 22 Mar 2022 12:55:42 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH v10 net-next 07/10] net: dsa: microchip: add support for ethtool port counters
Date:   Wed, 23 Mar 2022 01:24:52 +0530
Message-ID: <20220322195455.703921-8-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220322195455.703921-1-prasanna.vengateshan@microchip.com>
References: <20220322195455.703921-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for get_eth_**_stats() (phy/mac/ctrl) and
get_stats64()

Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
along with relevant lan937x hooks for KSZ common layer and added
support for get_strings()

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 118 +++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index c7b7b9b373d7..51640234dda6 100644
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
@@ -357,12 +371,116 @@ static void lan937x_phylink_get_caps(struct dsa_switch *ds, int port,
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
+static void lan937x_get_stats64(struct dsa_switch *ds, int port,
+				struct rtnl_link_stats64 *s)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+
+	spin_lock(&mib->stats64_lock);
+	memcpy(s, &mib->stats64, sizeof(*s));
+	spin_unlock(&mib->stats64_lock);
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
+	.get_stats64 = lan937x_get_stats64,
 	.port_bridge_join = ksz_port_bridge_join,
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
-- 
2.30.2

