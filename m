Return-Path: <netdev+bounces-9565-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3BD4729C96
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AC651C20F05
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839C7182D2;
	Fri,  9 Jun 2023 14:18:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ED7182B5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:18:22 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E8B30FA;
	Fri,  9 Jun 2023 07:18:17 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686320296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b39bYWGKkS87Qxp1JUHAqabHNNEbNwI74c/phbn31+I=;
	b=byMhOSIVwIq6RrEKs4zYdzD9eigsgnGZkUQyJ4z9mb6bVKhZbFQ8NhgI7iOjSapeebQxZT
	LUZdQG/ItC9f1X7v59MXhOQd6lXaD+dhTZ2Z+wPtINu/j1JSNkZHqMgCn1symqj7BecWDG
	LPJzumjYfHkh4tUJFcY8z4DLwKdARMwEU5Pkl66Z4LpNk4wKh280ILfEubs/SEB08QWFjL
	VIV+9M2389h3VdP3UbPhCR18QQaOGikPjHkbA9gFBVWTLLm5ge4ZPBSQV8Y44TEN6wwcXO
	2BM8DayNULsaDkSCpphplsD1/S9vI17AcQ+hkKPh3CTD2dBNhQjboyfIJ4JIEA==
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 494F12000C;
	Fri,  9 Jun 2023 14:18:15 +0000 (UTC)
From: alexis.lothore@bootlin.com
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org ,
	netdev@vger.kernel.org ,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com ,
	scott.roberts@telus.com 
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: implement egress tbf qdisc for 6393x family
Date: Fri,  9 Jun 2023 16:18:12 +0200
Message-ID: <20230609141812.297521-3-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230609141812.297521-1-alexis.lothore@bootlin.com>
References: <20230609141812.297521-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

The 6393x switches family has a basic, per-port egress rate limit
capability. This feature allows to configure any rate limit between 64kbps
and 10Gbps. This rate limit is said to be "burstless"
The switch offers the following controls, per port:
- count mode: frames, L1 bytes, L2 bytes, L3 bytes
- egress rate: recommended fixed values to be programmed, depending on
  actually targeted rate:
  - 64 kbps for rate between 64kbps and 1Mbps
  - 1 Mbps for rate between 1Mbps and 100Mbps
  - 10 Mbps for rate between 100Mbps and 1Gbps
  - 100Mbps for rate between 1Gbps and 10Gbps
- egress decrement rate, as number of steps programmed in egress rate
- an optional frame overhead count(0 to 60), which will be added to counted
  bytes to adjust (decrease) rate limiting. Could be used for example to
  avoid saturating a receiving side which add more encapsulation to frames

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |   1 +
 drivers/net/dsa/mv88e6xxx/port.c | 104 +++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  17 ++++-
 3 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0f1ae2aeaf00..901698513f26 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5633,6 +5633,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.port_set_cmode = mv88e6393x_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.port_set_upstream_port = mv88e6393x_port_set_upstream_port,
+	.port_setup_tc = mv88e6393x_port_setup_tc,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index dd66ec902d4c..b2f0087807ad 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -12,12 +12,16 @@
 #include <linux/if_bridge.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
+#include <net/pkt_cls.h>
 
 #include "chip.h"
 #include "global2.h"
 #include "port.h"
 #include "serdes.h"
 
+#define MBPS_TO_KBPS(x)	((x) * 1000)
+#define GBPS_TO_KBPS(x)	(MBPS_TO_KBPS(x) * 1000)
+
 int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
 			u16 *val)
 {
@@ -1497,6 +1501,106 @@ int mv88e6393x_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6393x_port_policy_write(chip, port, ptr, data);
 }
 
+int mv88e6393x_tbf_add(struct mv88e6xxx_chip *chip, int port,
+		       struct tc_tbf_qopt_offload_replace_params *replace_params)
+{
+	int rate_kbps = DIV_ROUND_UP(replace_params->rate.rate_bytes_ps * 8, 1000);
+	int overhead = DIV_ROUND_UP(replace_params->rate.overhead, 4);
+	int rate_step, decrement_rate, err;
+	u16 val;
+
+	if (rate_kbps < MV88E6393X_PORT_EGRESS_RATE_MIN_KBPS ||
+	    rate_kbps >= MV88E6393X_PORT_EGRESS_RATE_MAX_KBPS)
+		return -EOPNOTSUPP;
+
+	if (replace_params->rate.overhead > MV88E6393X_PORT_EGRESS_MAX_OVERHEAD)
+		return -EOPNOTSUPP;
+
+	/* Switch supports only max rate configuration. There is no
+	 * configurable burst/max size nor latency.
+	 * Formula defining registers value is:
+	 * EgressRate = 8 * EgressDec / (16ns * desired Rate)
+	 * EgressRate is a set of fixed values depending of targeted range
+	 */
+	if (rate_kbps < MBPS_TO_KBPS(1)) {
+		decrement_rate = rate_kbps / 64;
+		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_64_KBPS;
+	} else if (rate_kbps < MBPS_TO_KBPS(100)) {
+		decrement_rate = rate_kbps / MBPS_TO_KBPS(1);
+		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_1_MBPS;
+	} else if (rate_kbps < GBPS_TO_KBPS(1)) {
+		decrement_rate = rate_kbps / MBPS_TO_KBPS(10);
+		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_10_MBPS;
+	} else {
+		decrement_rate = rate_kbps / MBPS_TO_KBPS(100);
+		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_100_MBPS;
+	}
+
+	dev_dbg(chip->dev, "p%d: adding egress tbf qdisc with %dkbps rate",
+		port, rate_kbps);
+	val = decrement_rate;
+	val |= (overhead << MV88E6XXX_PORT_EGRESS_RATE_CTL1_FRAME_OVERHEAD_SHIFT);
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
+				   val);
+	if (err)
+		return err;
+
+	val = rate_step;
+	/* Configure mode to bits per second mode, on layer 1 */
+	val |= MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_L1_BYTES;
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
+				   val);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int mv88e6393x_tbf_del(struct mv88e6xxx_chip *chip, int port)
+{
+	int err;
+
+	dev_dbg(chip->dev, "p%d: removing tbf qdisc", port);
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
+				   0x0000);
+	if (err)
+		return err;
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
+				    0x0001);
+}
+
+static int mv88e6393x_tc_setup_qdisc_tbf(struct mv88e6xxx_chip *chip, int port,
+					 struct tc_tbf_qopt_offload *qopt)
+{
+	/* Device only supports per-port egress rate limiting */
+	if (qopt->parent != TC_H_ROOT)
+		return -EOPNOTSUPP;
+
+	switch (qopt->command) {
+	case TC_TBF_REPLACE:
+		return mv88e6393x_tbf_add(chip, port, &qopt->replace_params);
+	case TC_TBF_DESTROY:
+		return mv88e6393x_tbf_del(chip, port);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+int mv88e6393x_port_setup_tc(struct dsa_switch *ds, int port,
+			     enum tc_setup_type type, void *type_data)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	switch (type) {
+	case TC_SETUP_QDISC_TBF:
+		return mv88e6393x_tc_setup_qdisc_tbf(chip, port, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int mv88e6393x_port_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip)
 {
 	u16 ptr;
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 86deeb347cbc..791ad335b647 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -222,10 +222,21 @@
 #define MV88E6095_PORT_CTL2_CPU_PORT_MASK		0x000f
 
 /* Offset 0x09: Egress Rate Control */
-#define MV88E6XXX_PORT_EGRESS_RATE_CTL1		0x09
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL1				0x09
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_64_KBPS		0x1E84
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_1_MBPS		0x01F4
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_10_MBPS		0x0032
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_100_MBPS		0x0005
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_FRAME_OVERHEAD_SHIFT	8
+#define MV88E6393X_PORT_EGRESS_RATE_MIN_KBPS			64
+#define MV88E6393X_PORT_EGRESS_RATE_MAX_KBPS			10000000
+#define MV88E6393X_PORT_EGRESS_MAX_OVERHEAD			60
 
 /* Offset 0x0A: Egress Rate Control 2 */
-#define MV88E6XXX_PORT_EGRESS_RATE_CTL2		0x0a
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2				0x0a
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_L1_BYTES		0x4000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_L2_BYTES		0x8000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_L3_BYTES		0xC000
 
 /* Offset 0x0B: Port Association Vector */
 #define MV88E6XXX_PORT_ASSOC_VECTOR			0x0b
@@ -415,6 +426,8 @@ int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
 			       int port);
 int mv88e6393x_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 				      int upstream_port);
+int mv88e6393x_port_setup_tc(struct dsa_switch *ds, int port,
+			     enum tc_setup_type type, void *type_data);
 int mv88e6393x_port_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
 int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
 				   u16 etype);
-- 
2.41.0


