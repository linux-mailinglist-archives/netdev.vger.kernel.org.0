Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F1B6B39D2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCJJNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCJJNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:13:11 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A494A115659
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:08:26 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1paYjV-0000YI-Ht; Fri, 10 Mar 2023 10:08:13 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1paYjU-0038wu-3c; Fri, 10 Mar 2023 10:08:12 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1paYjS-000vRv-RN; Fri, 10 Mar 2023 10:08:10 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v3 2/2] net: dsa: microchip: add ETS Qdisc support for KSZ9477 series
Date:   Fri, 10 Mar 2023 10:08:09 +0100
Message-Id: <20230310090809.220764-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230310090809.220764-1-o.rempel@pengutronix.de>
References: <20230310090809.220764-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ETS Qdisc support for KSZ9477 of switches. Current implementation is
limited to strict priority mode.

Tested on KSZ8563R with following configuration:
tc qdisc replace dev lan2 root handle 1: ets strict 4 \
  priomap 3 3 2 2 1 1 0 0
ip link add link lan2 name v1 type vlan id 1 \
  egress-qos-map 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7

and patched iperf3 version:
https://github.com/esnet/iperf/pull/1476
iperf3 -c 172.17.0.1 -b100M  -l1472 -t100 -u -R --sock-prio 2

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 218 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  12 ++
 2 files changed, 230 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index ae05fe0b0a81..54d75ec22ef0 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1087,6 +1087,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 3,
 		.num_tx_queues = 4,
 		.tc_cbs_supported = true,
+		.tc_ets_supported = true,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1227,6 +1228,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 4,
 		.num_tx_queues = 4,
 		.tc_cbs_supported = true,
+		.tc_ets_supported = true,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1352,6 +1354,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 3,
 		.num_tx_queues = 4,
 		.tc_cbs_supported = true,
+		.tc_ets_supported = true,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1379,6 +1382,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 3,
 		.num_tx_queues = 4,
 		.tc_cbs_supported = true,
+		.tc_ets_supported = true,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1411,6 +1415,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 6,
 		.num_tx_queues = 8,
 		.tc_cbs_supported = true,
+		.tc_ets_supported = true,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1437,6 +1442,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 6,
 		.num_tx_queues = 8,
 		.tc_cbs_supported = true,
+		.tc_ets_supported = true,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1463,6 +1469,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 6,
 		.num_tx_queues = 8,
 		.tc_cbs_supported = true,
+		.tc_ets_supported = true,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1493,6 +1500,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 6,
 		.num_tx_queues = 8,
 		.tc_cbs_supported = true,
+		.tc_ets_supported = true,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1523,6 +1531,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 6,
 		.num_tx_queues = 8,
 		.tc_cbs_supported = true,
+		.tc_ets_supported = true,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -3172,12 +3181,221 @@ static int ksz_setup_tc_cbs(struct dsa_switch *ds, int port,
 				 MTI_SHAPING_SRP);
 }
 
+static int ksz_disable_egress_rate_limit(struct ksz_device *dev, int port)
+{
+	int queue, ret;
+
+	/* Configuration will not take effect until the last Port Queue X
+	 * Egress Limit Control Register is written.
+	 */
+	for (queue = 0; queue < dev->info->num_tx_queues; queue++) {
+		ret = ksz_pwrite8(dev, port, KSZ9477_REG_PORT_OUT_RATE_0 + queue,
+				  KSZ9477_OUT_RATE_NO_LIMIT);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int ksz_ets_band_to_queue(struct tc_ets_qopt_offload_replace_params *p,
+				 int band)
+{
+	/* Compared to queues, bands prioritize packets differently. In strict
+	 * priority mode, the lowest priority is assigned to Queue 0 while the
+	 * highest priority is given to Band 0.
+	 */
+	return p->bands - 1 - band;
+}
+
+static int ksz_queue_set_strict(struct ksz_device *dev, int port, int queue)
+{
+	int ret;
+
+	ret = ksz_pwrite32(dev, port, REG_PORT_MTI_QUEUE_INDEX__4, queue);
+	if (ret)
+		return ret;
+
+	return ksz_setup_tc_mode(dev, port, MTI_SCHEDULE_STRICT_PRIO,
+				 MTI_SHAPING_OFF);
+}
+
+static int ksz_queue_set_wrr(struct ksz_device *dev, int port, int queue,
+			     int weight)
+{
+	int ret;
+
+	ret = ksz_pwrite32(dev, port, REG_PORT_MTI_QUEUE_INDEX__4, queue);
+	if (ret)
+		return ret;
+
+	ret = ksz_setup_tc_mode(dev, port, MTI_SCHEDULE_WRR,
+				MTI_SHAPING_OFF);
+	if (ret)
+		return ret;
+
+	return ksz_pwrite8(dev, port, KSZ9477_PORT_MTI_QUEUE_CTRL_1, weight);
+}
+
+static int ksz_tc_ets_add(struct ksz_device *dev, int port,
+			  struct tc_ets_qopt_offload_replace_params *p)
+{
+	int ret, band, tc_prio;
+	u32 queue_map = 0;
+
+	/* In order to ensure proper prioritization, it is necessary to set the
+	 * rate limit for the related queue to zero. Otherwise strict priority
+	 * or WRR mode will not work. This is a hardware limitation.
+	 */
+	ret = ksz_disable_egress_rate_limit(dev, port);
+	if (ret)
+		return ret;
+
+	/* Configure queue scheduling mode for all bands. Currently only strict
+	 * prio mode is supported.
+	 */
+	for (band = 0; band < p->bands; band++) {
+		int queue = ksz_ets_band_to_queue(p, band);
+
+		ret = ksz_queue_set_strict(dev, port, queue);
+		if (ret)
+			return ret;
+	}
+
+	/* Configure the mapping between traffic classes and queues. Note:
+	 * priomap variable support 16 traffic classes, but the chip can handle
+	 * only 8 classes.
+	 */
+	for (tc_prio = 0; tc_prio < ARRAY_SIZE(p->priomap); tc_prio++) {
+		int queue;
+
+		if (tc_prio > KSZ9477_MAX_TC_PRIO)
+			break;
+
+		queue = ksz_ets_band_to_queue(p, p->priomap[tc_prio]);
+		queue_map |= queue << (tc_prio * KSZ9477_PORT_TC_MAP_S);
+	}
+
+	return ksz_pwrite32(dev, port, KSZ9477_PORT_MRI_TC_MAP__4, queue_map);
+}
+
+static int ksz_tc_ets_del(struct ksz_device *dev, int port)
+{
+	int ret, queue, tc_prio, s;
+	u32 queue_map = 0;
+
+	/* To restore the default chip configuration, set all queues to use the
+	 * WRR scheduler with a weight of 1.
+	 */
+	for (queue = 0; queue < dev->info->num_tx_queues; queue++) {
+		ret = ksz_queue_set_wrr(dev, port, queue,
+					KSZ9477_DEFAULT_WRR_WEIGHT);
+		if (ret)
+			return ret;
+	}
+
+	switch (dev->info->num_tx_queues) {
+	case 2:
+		s = 2;
+		break;
+	case 4:
+		s = 1;
+		break;
+	case 8:
+		s = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Revert the queue mapping for TC-priority to its default setting on
+	 * the chip.
+	 */
+	for (tc_prio = 0; tc_prio <= KSZ9477_MAX_TC_PRIO; tc_prio++) {
+		int queue;
+
+		queue = tc_prio >> s;
+		queue_map |= queue << (tc_prio * KSZ9477_PORT_TC_MAP_S);
+	}
+
+	return ksz_pwrite32(dev, port, KSZ9477_PORT_MRI_TC_MAP__4, queue_map);
+}
+
+static int ksz_tc_ets_validate(struct ksz_device *dev, int port,
+			       struct tc_ets_qopt_offload_replace_params *p)
+{
+	int band;
+
+	/* Since it is not feasible to share one port among multiple qdisc,
+	 * the user must configure all available queues appropriately.
+	 */
+	if (p->bands != dev->info->num_tx_queues) {
+		dev_err(dev->dev, "Not supported amount of bands. It should be %d\n",
+			dev->info->num_tx_queues);
+		return -EOPNOTSUPP;
+	}
+
+	for (band = 0; band < p->bands; ++band) {
+		/* The KSZ switches utilize a weighted round robin configuration
+		 * where a certain number of packets can be transmitted from a
+		 * queue before the next queue is serviced. For more information
+		 * on this, refer to section 5.2.8.4 of the KSZ8565R
+		 * documentation on the Port Transmit Queue Control 1 Register.
+		 * However, the current ETS Qdisc implementation (as of February
+		 * 2023) assigns a weight to each queue based on the number of
+		 * bytes or extrapolated bandwidth in percentages. Since this
+		 * differs from the KSZ switches' method and we don't want to
+		 * fake support by converting bytes to packets, it is better to
+		 * return an error instead.
+		 */
+		if (p->quanta[band]) {
+			dev_err(dev->dev, "Quanta/weights configuration is not supported.\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return 0;
+}
+
+static int ksz_tc_setup_qdisc_ets(struct dsa_switch *ds, int port,
+				  struct tc_ets_qopt_offload *qopt)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret;
+
+	if (!dev->info->tc_ets_supported)
+		return -EOPNOTSUPP;
+
+	if (qopt->parent != TC_H_ROOT) {
+		dev_err(dev->dev, "Parent should be \"root\"\n");
+		return -EOPNOTSUPP;
+	}
+
+	switch (qopt->command) {
+	case TC_ETS_REPLACE:
+		ret = ksz_tc_ets_validate(dev, port, &qopt->replace_params);
+		if (ret)
+			return ret;
+
+		return ksz_tc_ets_add(dev, port, &qopt->replace_params);
+	case TC_ETS_DESTROY:
+		return ksz_tc_ets_del(dev, port);
+	case TC_ETS_STATS:
+	case TC_ETS_GRAFT:
+		return -EOPNOTSUPP;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int ksz_setup_tc(struct dsa_switch *ds, int port,
 			enum tc_setup_type type, void *type_data)
 {
 	switch (type) {
 	case TC_SETUP_QDISC_CBS:
 		return ksz_setup_tc_cbs(ds, port, type_data);
+	case TC_SETUP_QDISC_ETS:
+		return ksz_tc_setup_qdisc_ets(ds, port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f53834bbe896..20e5da47ac7b 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -51,6 +51,7 @@ struct ksz_chip_data {
 	u8 port_nirqs;
 	u8 num_tx_queues;
 	bool tc_cbs_supported;
+	bool tc_ets_supported;
 	const struct ksz_dev_ops *ops;
 	bool phy_errata_9477;
 	bool ksz87xx_eee_link_erratum;
@@ -657,6 +658,14 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define KSZ8_LEGAL_PACKET_SIZE		1518
 #define KSZ9477_MAX_FRAME_SIZE		9000
 
+#define KSZ9477_REG_PORT_OUT_RATE_0	0x0420
+#define KSZ9477_OUT_RATE_NO_LIMIT	0
+
+#define KSZ9477_PORT_MRI_TC_MAP__4	0x0808
+
+#define KSZ9477_PORT_TC_MAP_S		4
+#define KSZ9477_MAX_TC_PRIO		7
+
 /* CBS related registers */
 #define REG_PORT_MTI_QUEUE_INDEX__4	0x0900
 
@@ -670,6 +679,9 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define MTI_SHAPING_SRP			1
 #define MTI_SHAPING_TIME_AWARE		2
 
+#define KSZ9477_PORT_MTI_QUEUE_CTRL_1	0x0915
+#define KSZ9477_DEFAULT_WRR_WEIGHT	1
+
 #define REG_PORT_MTI_HI_WATER_MARK	0x0916
 #define REG_PORT_MTI_LO_WATER_MARK	0x0918
 
-- 
2.30.2

