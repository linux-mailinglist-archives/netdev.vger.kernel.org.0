Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8347E65CEB5
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbjADIsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbjADIrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:47:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16611C913;
        Wed,  4 Jan 2023 00:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672821988; x=1704357988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gkLO0qV4ENffB04VX/UPVg3IcezVn542686Sutwp57M=;
  b=DBkx3hHVh+cy+JSpY7mI8wx9Ksps3PVVxvS01cP7eAwwLnxzNdUGPXQ6
   TmWi67E3TJ77n2m82s9WagZ8SC4LZ47hdUfMbygf/1Zx1HIFr9ftrRx9q
   /xOzIe7/kbsdjBQF+5EdGjBp3WL6jUeuA9VKZ34HgM7xKfSpqtUM59TrN
   qkuT2d7NUYpMycXxV32cVh1rqDnoXwEU9svZn6wOG3m/66YjCweSzKeRh
   tXzLmQMbma9uMa89YYvx19dV30uOm17o9JxEVh6/tm/1fj/Kk8oX+PpSD
   Kl3PG8BvLhkOlzxGHB2Y5k393etzdqU3eQgwYWNk+6U0a5YfI/jOKbB4E
   g==;
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="195343132"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2023 01:46:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 01:46:25 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 01:46:19 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v7 12/13] net: dsa: microchip: ptp: lan937x: add 2 step timestamping
Date:   Wed, 4 Jan 2023 14:13:15 +0530
Message-ID: <20230104084316.4281-13-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230104084316.4281-1-arun.ramadoss@microchip.com>
References: <20230104084316.4281-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN937x series of switches support 2 step timestamping mechanism. There
are timestamp correction calculation performed in ksz_rcv_timestamp and
ksz_xmit_timestamp which are applicable only for p2p1step. To check
whether the 2 step is enabled or not in tag_ksz.c introduced the helper
function in taggger_data to query it from ksz_ptp.c. Based on whether 2
step is enabled or not, timestamp calculation are performed.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
v6 -> v7
- s/1/true in hwtstamp_config()

v3 -> v4
- P2P_1step bit is set which is required for P2P. It is missed during
patch v3 regression.

v2 -> v3
- Reverted setting PTP_1Step bit as we are setting 802_1AS bit

v1 -> v2
- declard is_ptp_twostep as macro NULL for ptp disabled case
- Moved the patch in series to have continuity for lan937x updates 9/11
  to 12/13
- enable PTP_1STEP bit based on tx timestamping

Patch v1
- Patch is new.
---
 drivers/net/dsa/microchip/ksz_ptp.c | 43 +++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 03fbbe6493ed..3ba36d33e830 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -283,6 +283,9 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
 
 	ts->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ONESTEP_P2P);
 
+	if (is_lan937x(dev))
+		ts->tx_types |= BIT(HWTSTAMP_TX_ON);
+
 	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
 			 BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
 			 BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
@@ -310,6 +313,8 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
 				   struct ksz_port *prt,
 				   struct hwtstamp_config *config)
 {
+	int ret;
+
 	if (config->flags)
 		return -EINVAL;
 
@@ -325,6 +330,25 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
 		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = true;
 		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = false;
 		prt->hwts_tx_en = true;
+
+		ret = ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_1STEP, PTP_1STEP);
+		if (ret)
+			return ret;
+
+		break;
+	case HWTSTAMP_TX_ON:
+		if (!is_lan937x(dev))
+			return -ERANGE;
+
+		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = true;
+		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = true;
+		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = true;
+		prt->hwts_tx_en = true;
+
+		ret = ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_1STEP, 0);
+		if (ret)
+			return ret;
+
 		break;
 	default:
 		return -ERANGE;
@@ -412,14 +436,20 @@ bool ksz_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
 	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
 	struct ksz_device *dev = ds->priv;
 	struct ptp_header *ptp_hdr;
+	struct ksz_port *prt;
 	u8 ptp_msg_type;
 	ktime_t tstamp;
 	s64 correction;
 
+	prt = &dev->ports[port];
+
 	tstamp = KSZ_SKB_CB(skb)->tstamp;
 	memset(hwtstamps, 0, sizeof(*hwtstamps));
 	hwtstamps->hwtstamp = ksz_tstamp_reconstruct(dev, tstamp);
 
+	if (prt->tstamp_config.tx_type != HWTSTAMP_TX_ONESTEP_P2P)
+		goto out;
+
 	ptp_hdr = ptp_parse_header(skb, type);
 	if (!ptp_hdr)
 		goto out;
@@ -467,12 +497,19 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 	ptp_msg_type = ptp_get_msgtype(hdr, type);
 
 	switch (ptp_msg_type) {
+	case PTP_MSGTYPE_SYNC:
+		if (prt->tstamp_config.tx_type == HWTSTAMP_TX_ONESTEP_P2P)
+			return;
+		break;
 	case PTP_MSGTYPE_PDELAY_REQ:
 		break;
 	case PTP_MSGTYPE_PDELAY_RESP:
-		KSZ_SKB_CB(skb)->ptp_type = type;
-		KSZ_SKB_CB(skb)->update_correction = true;
-		return;
+		if (prt->tstamp_config.tx_type == HWTSTAMP_TX_ONESTEP_P2P) {
+			KSZ_SKB_CB(skb)->ptp_type = type;
+			KSZ_SKB_CB(skb)->update_correction = true;
+			return;
+		}
+		break;
 
 	default:
 		return;
-- 
2.36.1

