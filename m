Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB88363A636
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiK1Kfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiK1Keh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:34:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80041AF2D;
        Mon, 28 Nov 2022 02:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669631662; x=1701167662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ididD8hOsLOrjFCIWEdnmkh5wnH/n+EBu8dA7Ljne/Q=;
  b=c6w4oEd7qOdnIERNMIIrdogjWpwE/1Q7rUzDXg/xVWGPkIvaUCQY0Fky
   oyKbk73Oy37fWAtO0SSnH4K89ULkRfd/wTZUAsIyMawZrc9HIhxcfaeNF
   mceur/5tG40Ep/jckppeL9WAD9+RzDOyyV3zlT1uktBEXT+ev1E4Pudm/
   PgljE/uoS4VpYfOSI904jmqg8ctrRGXj4GvGnjJg9FXILbiQh42uNST2l
   loG+aV4+0XutIFhCVICIVkje3dMRRX3kV/4DRVau3ziJyr4BgMedKQQJ6
   kDNg1ocuqSARcLIUBNfMQtgXDqVA75PQWqJljKk8q9hG/cn8sGmEuLh1v
   A==;
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="201649643"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 03:34:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 03:34:21 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 28 Nov 2022 03:34:16 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v1 10/12] net: dsa: microchip: ptp: add 2 step timestamping for LAN937x
Date:   Mon, 28 Nov 2022 16:02:25 +0530
Message-ID: <20221128103227.23171-11-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221128103227.23171-1-arun.ramadoss@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
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
Patch v1
- Patch is new.
---
 drivers/net/dsa/microchip/ksz_common.c |  1 +
 drivers/net/dsa/microchip/ksz_ptp.c    | 23 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h    |  6 ++++++
 include/linux/dsa/ksz_common.h         |  1 +
 net/dsa/tag_ksz.c                      | 14 ++++++++++++++
 5 files changed, 45 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 3b578a4a33de..91f998fab231 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2462,6 +2462,7 @@ static int ksz_connect_tag_protocol(struct dsa_switch *ds,
 	tagger_data = ksz_tagger_data(ds);
 	tagger_data->xmit_work_fn = ksz_port_deferred_xmit;
 	tagger_data->meta_tstamp_handler = ksz_tstamp_reconstruct;
+	tagger_data->is_ptp_twostep = ksz_is_ptp_twostep;
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index f0b7fcca045b..79ed31fd1398 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -62,6 +62,9 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
 
 	ts->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ONESTEP_P2P);
 
+	if (is_lan937x(dev))
+		ts->tx_types |= BIT(HWTSTAMP_TX_ON);
+
 	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
 
 	ts->phc_index = ptp_clock_index(ptp_data->clock);
@@ -111,6 +114,15 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
 		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 0;
 		prt->hwts_tx_en = HWTSTAMP_TX_ONESTEP_P2P;
 		break;
+	case HWTSTAMP_TX_ON:
+		if (!is_lan937x(dev))
+			return -ERANGE;
+
+		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = 1;
+		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 1;
+		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 1;
+		prt->hwts_tx_en = HWTSTAMP_TX_ON;
+		break;
 	default:
 		return -ERANGE;
 	}
@@ -129,6 +141,14 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
 	return ksz_ptp_enable_mode(dev, rx_on);
 }
 
+bool ksz_is_ptp_twostep(struct dsa_switch *ds, unsigned int port)
+{
+	struct ksz_device *dev	= ds->priv;
+	struct ksz_port *prt = &dev->ports[port];
+
+	return (prt->hwts_tx_en == HWTSTAMP_TX_ON);
+}
+
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 {
 	struct ksz_device *dev = ds->priv;
@@ -181,6 +201,9 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 	ptp_msg_type = ptp_get_msgtype(hdr, type);
 
 	switch (ptp_msg_type) {
+	case PTP_MSGTYPE_SYNC:
+		if (prt->hwts_tx_en == HWTSTAMP_TX_ONESTEP_P2P)
+			return;
 	case PTP_MSGTYPE_PDELAY_REQ:
 	case PTP_MSGTYPE_PDELAY_RESP:
 		break;
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 8bcdd4c413a8..ff169d119169 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -33,6 +33,7 @@ int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
 void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
 void ksz_port_deferred_xmit(struct kthread_work *work);
 ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp);
+bool ksz_is_ptp_twostep(struct dsa_switch *ds, unsigned int port);
 
 #else
 
@@ -79,6 +80,11 @@ static inline ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tsta
 	return 0;
 }
 
+static inline bool ksz_is_ptp_twostep(struct dsa_switch *ds, unsigned int port)
+{
+	return 0;
+}
+
 #endif	/* End of CONFIG_NET_DSA_MICROCHIP_KSZ_PTP */
 
 #endif
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index 370ce9b56902..45f347c2b4d4 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -34,6 +34,7 @@ struct ksz_tagger_data {
 	bool (*hwtstamp_get_state)(struct dsa_switch *ds);
 	void (*hwtstamp_set_state)(struct dsa_switch *ds, bool on);
 	ktime_t (*meta_tstamp_handler)(struct dsa_switch *ds, ktime_t tstamp);
+	bool (*is_ptp_twostep)(struct dsa_switch *ds, unsigned int port);
 };
 
 struct ksz_skb_cb {
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 2a08e48f41f8..561fab7d19c4 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -223,6 +223,12 @@ static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
 	if (!ptp_hdr)
 		return;
 
+	if (!tagger_data->is_ptp_twostep)
+		return;
+
+	if (tagger_data->is_ptp_twostep(ds, port))
+		return;
+
 	ptp_msg_type = ptp_get_msgtype(ptp_hdr, ptp_type);
 	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_REQ)
 		return;
@@ -242,6 +248,7 @@ static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
 static void ksz_xmit_timestamp(struct dsa_port *dp, struct sk_buff *skb)
 {
 	struct sk_buff *clone = KSZ_SKB_CB(skb)->clone;
+	struct ksz_tagger_data *tagger_data;
 	struct ksz_tagger_private *priv;
 	struct ptp_header *ptp_hdr;
 	unsigned int ptp_type;
@@ -257,6 +264,13 @@ static void ksz_xmit_timestamp(struct dsa_port *dp, struct sk_buff *skb)
 	if (!clone)
 		goto output_tag;
 
+	tagger_data = ksz_tagger_data(dp->ds);
+	if (!tagger_data->is_ptp_twostep)
+		goto output_tag;
+
+	if (tagger_data->is_ptp_twostep(dp->ds, dp->index))
+		goto output_tag;
+
 	ptp_type = KSZ_SKB_CB(clone)->ptp_type;
 	if (ptp_type == PTP_CLASS_NONE)
 		goto output_tag;
-- 
2.36.1

