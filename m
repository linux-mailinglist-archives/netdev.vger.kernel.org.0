Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863D2643FA2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbiLFJRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiLFJRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:17:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2BF209B9;
        Tue,  6 Dec 2022 01:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670318215; x=1701854215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9P6lUpYRndzs0KeFuie6uAlnS7WtAwh8LsJWCdKzIas=;
  b=LZ6El4I7O7NSdPV6GcnzaChlZ0qQQ5niw1z8blWo9N04byCFurGRrMVp
   +sd/AUvn9PZBPJpEcrsEMrSsHuyOJJrpJeCJRAoD1C54vNaneKrSc3EmA
   7RCRqtD70mLBeBSPOjjpuZoQY8DK4vjYlIRY1IpT9cj8lFQCbQV0n57eR
   lmUtvXY8eHmbCV/Pr101SYooLt8/CiuH+0nQ8P6TunFOqwmRXJX+XAwRh
   nbokwhaKntN9f+YsRcC1h/2DzZLOp+woNvRbs//MUdahZmLuWeSHrsSV8
   kHkungmp57I5wn//AjmSBh7l/PuMhTqQewspVTm7jXmjka52KvrDoIS+t
   A==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="202773064"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 02:16:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 02:16:54 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 02:16:48 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v2 12/13] net: dsa: microchip: ptp: lan937x: add 2 step timestamping
Date:   Tue, 6 Dec 2022 14:44:27 +0530
Message-ID: <20221206091428.28285-13-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221206091428.28285-1-arun.ramadoss@microchip.com>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
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
v1 -> v2
- declard is_ptp_twostep as macro NULL for ptp disabled case
- Moved the patch in series to have continuity for lan937x updates 9/11
  to 12/13
- enable PTP_1STEP bit based on tx timestamping

Patch v1
- Patch is new.
---
 drivers/net/dsa/microchip/ksz_common.c |  1 +
 drivers/net/dsa/microchip/ksz_ptp.c    | 36 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h    |  3 +++
 include/linux/dsa/ksz_common.h         |  1 +
 net/dsa/tag_ksz.c                      | 14 ++++++++++
 5 files changed, 55 insertions(+)

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
index 25b0f09753ce..8392962311e2 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -329,6 +329,9 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
 
 	ts->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ONESTEP_P2P);
 
+	if (is_lan937x(dev))
+		ts->tx_types |= BIT(HWTSTAMP_TX_ON);
+
 	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
 			 BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
 			 BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
@@ -356,6 +359,8 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
 				   struct ksz_port *prt,
 				   struct hwtstamp_config *config)
 {
+	int ret;
+
 	if (config->flags)
 		return -EINVAL;
 
@@ -371,6 +376,25 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
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
@@ -403,6 +427,14 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
 	return ksz_ptp_enable_mode(dev);
 }
 
+bool ksz_is_ptp_twostep(struct dsa_switch *ds, unsigned int port)
+{
+	struct ksz_device *dev	= ds->priv;
+	struct ksz_port *prt = &dev->ports[port];
+
+	return (prt->tstamp_config.tx_type == HWTSTAMP_TX_ON);
+}
+
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 {
 	struct ksz_device *dev = ds->priv;
@@ -451,6 +483,10 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 	ptp_msg_type = ptp_get_msgtype(hdr, type);
 
 	switch (ptp_msg_type) {
+	case PTP_MSGTYPE_SYNC:
+		if (prt->tstamp_config.tx_type == HWTSTAMP_TX_ONESTEP_P2P)
+			return;
+		 fallthrough;
 	case PTP_MSGTYPE_PDELAY_REQ:
 		 fallthrough;
 	case PTP_MSGTYPE_PDELAY_RESP:
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 5a71c826c7d8..abad072b7032 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -46,6 +46,7 @@ int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
 void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
 void ksz_port_deferred_xmit(struct kthread_work *work);
 ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp);
+bool ksz_is_ptp_twostep(struct dsa_switch *ds, unsigned int port);
 
 #else
 
@@ -80,6 +81,8 @@ static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
 
 #define ksz_port_deferred_xmit NULL
 
+#define ksz_is_ptp_twostep NULL
+
 #endif	/* End of CONFIG_NET_DSA_MICROCHIP_KSZ_PTP */
 
 #endif
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index b180eb3429bd..be1a850c82fb 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -33,6 +33,7 @@ struct ksz_tagger_data {
 	void (*xmit_work_fn)(struct kthread_work *work);
 	void (*hwtstamp_set_state)(struct dsa_switch *ds, bool on);
 	ktime_t (*meta_tstamp_handler)(struct dsa_switch *ds, ktime_t tstamp);
+	bool (*is_ptp_twostep)(struct dsa_switch *ds, unsigned int port);
 };
 
 struct ksz_skb_cb {
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index e57066f3947e..e2aa438437a0 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -216,6 +216,12 @@ static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
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
@@ -237,6 +243,7 @@ static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
 static void ksz_xmit_timestamp(struct dsa_port *dp, struct sk_buff *skb)
 {
 	struct sk_buff *clone = KSZ_SKB_CB(skb)->clone;
+	struct ksz_tagger_data *tagger_data;
 	struct ksz_tagger_private *priv;
 	struct ptp_header *ptp_hdr;
 	unsigned int ptp_type;
@@ -252,6 +259,13 @@ static void ksz_xmit_timestamp(struct dsa_port *dp, struct sk_buff *skb)
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

