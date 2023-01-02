Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0195865AD29
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 06:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjABFKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 00:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjABFJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 00:09:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18FF2614;
        Sun,  1 Jan 2023 21:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672636098; x=1704172098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BsHOrPq13mxXcu/hutFr3b8J7KhpwyigNExjZ/OZMjk=;
  b=zJfAkLJjIwToha6GBOLOaRUJniXxQLjnl6ejjvoshB/otSTohV/tf9y0
   yoqkE/Kr4ux1i96rkNf+N/V/RlnUjqIkLyp+gic18AEiXU/hS1F6opLCB
   HsLgKFDmP1kY/7fHuWhjVfy8XHSb3/S+KTRwSBDT3VYPsUT/1OKWaJpbc
   8ppMJ5AbrmJAfQLJc4z6mhKURT+jP4pEzw3+JG9/SwEAwNcAHjmpt4+jn
   NZDc47iTztpwRyPvzy4y9sA93C08NioNdDxvZ1ssBIIljiyrWj7oN3Dw8
   fMa9INTzfHRWvpuv410wLeshJVYJD2fnU0m8goE+m20PnOuK1B6yv2+i5
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="130397803"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jan 2023 22:08:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 1 Jan 2023 22:08:10 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Sun, 1 Jan 2023 22:08:04 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>,
        <jacob.e.keller@intel.com>
Subject: [Patch net-next v6 12/13] net: dsa: microchip: ptp: lan937x: add 2 step timestamping
Date:   Mon, 2 Jan 2023 10:34:58 +0530
Message-ID: <20230102050459.31023-13-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230102050459.31023-1-arun.ramadoss@microchip.com>
References: <20230102050459.31023-1-arun.ramadoss@microchip.com>
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
 drivers/net/dsa/microchip/ksz_ptp.c | 37 ++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 2d52a3d4771e..c2d156002ee5 100644
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
 		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 1;
 		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 0;
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
+		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = 1;
+		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 1;
+		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 1;
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
@@ -468,6 +498,10 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 	ptp_msg_type = ptp_get_msgtype(hdr, type);
 
 	switch (ptp_msg_type) {
+	case PTP_MSGTYPE_SYNC:
+		if (prt->tstamp_config.tx_type == HWTSTAMP_TX_ONESTEP_P2P)
+			return;
+		 fallthrough;
 	case PTP_MSGTYPE_PDELAY_REQ:
 		 fallthrough;
 	case PTP_MSGTYPE_PDELAY_RESP:
@@ -484,7 +518,8 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 	/* caching the value to be used in tag_ksz.c */
 	KSZ_SKB_CB(skb)->clone = clone;
 	KSZ_SKB_CB(clone)->ptp_type = type;
-	if (ptp_msg_type == PTP_MSGTYPE_PDELAY_RESP)
+	if (ptp_msg_type == PTP_MSGTYPE_PDELAY_RESP &&
+	    prt->tstamp_config.tx_type == HWTSTAMP_TX_ONESTEP_P2P)
 		KSZ_SKB_CB(clone)->update_correction = true;
 }
 
-- 
2.36.1

