Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F084666DF6
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 10:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240024AbjALJXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 04:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjALJWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 04:22:33 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C8E5791E
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 01:12:48 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1673514767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=y1i0Aw71ugWlJN1rIa7zsVr4URw90R/dv4VPg3UpuMY=;
        b=fzsfLW+wJt4fcTVvzaxvKAIXrHfl67KzgVVlalCZhMCsl6xcdBK9ewA7erY3Mr+pXfOwCw
        yAxCKYrPSJAQTRX1hjU12d+o29VKwLkSAT+8CGkqXUPaBKqgZI6V6cWRkoswUNjlEpYtHJ
        Ft1MZg6PgXDsuGg9SjbEZi1F/8qiNVK/63QaJG+kkcmYSvHPjRelZRURynKYly4GQdRMlq
        PCJv0LfikGHjhsWRuQaNXJHxkQ7elc8TOns+LwkTdYJLI9oWhfWfxkrtlKs/h3fvWNTh+d
        H9eCZCXVRfFrb+T7VyEs+1RkbUDRWfe43ewCe21E88tcuFEc5p+fn2Q4VQMIEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1673514767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=y1i0Aw71ugWlJN1rIa7zsVr4URw90R/dv4VPg3UpuMY=;
        b=qgQQ7Ia6slBiAaAR45/l1hJyz7FbH3nyM4mXSiUxTQrPrWe8Q6HhEIv7QsOF4OaaVIC4NS
        sROcnz7Tkq3zqxDw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v2] net: dsa: mv88e6xxx: Enable PTP receive for mv88e6390
Date:   Thu, 12 Jan 2023 10:12:24 +0100
Message-Id: <20230112091224.43116-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch receives management traffic such as STP and LLDP. However, PTP
messages are not received, only transmitted.

Ideally, the switch would trap all PTP messages to the management CPU. This
particular switch has a PTP block which identifies PTP messages and traps them
to a dedicated port. There is a register to program this destination. This is
not used at the moment.

Therefore, program it to the same port as the MGMT traffic is trapped to. This
allows to receive PTP messages as soon as timestamping is enabled.

In addition, the datasheet mentions that this register is not valid e.g., for
6190 variants. So, add a new PTP operation which is only added for the both 6390
devices.

Tested simply like this on Marvell 88E6390, revision 1:

|/ # ptp4l -2 -i lan4 --tx_timestamp_timeout=40 -m
|[...]
|ptp4l[147.450]: master offset         56 s2 freq   +1262 path delay       413
|ptp4l[148.450]: master offset         22 s2 freq   +1244 path delay       434
|ptp4l[149.450]: master offset          5 s2 freq   +1234 path delay       446
|ptp4l[150.451]: master offset          3 s2 freq   +1233 path delay       451
|ptp4l[151.451]: master offset          1 s2 freq   +1232 path delay       451
|ptp4l[152.451]: master offset         -3 s2 freq   +1229 path delay       451
|ptp4l[153.451]: master offset          9 s2 freq   +1240 path delay       451

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---

Previous version:

 * https://lore.kernel.org/netdev/20230111080417.147231-1-kurt@linutronix.de/

Changes since v1:

 * Move the setting of PTP MGMT port to ptp_ops (Andrew)

 drivers/net/dsa/mv88e6xxx/chip.c    |  4 +--
 drivers/net/dsa/mv88e6xxx/chip.h    |  1 +
 drivers/net/dsa/mv88e6xxx/global1.c | 12 ++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |  2 ++
 drivers/net/dsa/mv88e6xxx/ptp.c     | 46 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/ptp.h     |  2 ++
 6 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1168ea75f5f5..7df13c1025f7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5470,7 +5470,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
-	.ptp_ops = &mv88e6352_ptp_ops,
+	.ptp_ops = &mv88e6390_ptp_ops,
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
@@ -5543,7 +5543,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
-	.ptp_ops = &mv88e6352_ptp_ops,
+	.ptp_ops = &mv88e6390_ptp_ops,
 	.phylink_get_caps = mv88e6390x_phylink_get_caps,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 945a6696ad72..da6e1339f809 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -715,6 +715,7 @@ struct mv88e6xxx_ptp_ops {
 	int (*port_disable)(struct mv88e6xxx_chip *chip, int port);
 	int (*global_enable)(struct mv88e6xxx_chip *chip);
 	int (*global_disable)(struct mv88e6xxx_chip *chip);
+	int (*set_ptp_cpu_port)(struct mv88e6xxx_chip *chip, int port);
 	int n_ext_ts;
 	int arr0_sts_reg;
 	int arr1_sts_reg;
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 5848112036b0..2fa55a643591 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -403,6 +403,18 @@ int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
 	return mv88e6390_g1_monitor_write(chip, ptr, port);
 }
 
+int mv88e6390_g1_set_ptp_cpu_port(struct mv88e6xxx_chip *chip, int port)
+{
+	u16 ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_PTP_CPU_DEST;
+
+	/* Use the default high priority for PTP frames sent to
+	 * the CPU.
+	 */
+	port |= MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI;
+
+	return mv88e6390_g1_monitor_write(chip, ptr, port);
+}
+
 int mv88e6390_g1_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip)
 {
 	u16 ptr;
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 65958b2a0d3a..c99ddd117fe6 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -214,6 +214,7 @@
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST		0x2000
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST		0x2100
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST		0x3000
+#define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_PTP_CPU_DEST		0x3200
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI	0x00e0
 #define MV88E6390_G1_MONITOR_MGMT_CTL_DATA_MASK			0x00ff
 
@@ -303,6 +304,7 @@ int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 				 int port);
 int mv88e6095_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port);
+int mv88e6390_g1_set_ptp_cpu_port(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g1_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
 
 int mv88e6085_g1_ip_pri_map(struct mv88e6xxx_chip *chip);
diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index d838c174dc0d..ea17231dc34e 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -11,6 +11,7 @@
  */
 
 #include "chip.h"
+#include "global1.h"
 #include "global2.h"
 #include "hwtstamp.h"
 #include "ptp.h"
@@ -419,6 +420,34 @@ const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {
 	.cc_mult_dem = MV88E6XXX_CC_MULT_DEM,
 };
 
+const struct mv88e6xxx_ptp_ops mv88e6390_ptp_ops = {
+	.clock_read = mv88e6352_ptp_clock_read,
+	.ptp_enable = mv88e6352_ptp_enable,
+	.ptp_verify = mv88e6352_ptp_verify,
+	.event_work = mv88e6352_tai_event_work,
+	.port_enable = mv88e6352_hwtstamp_port_enable,
+	.port_disable = mv88e6352_hwtstamp_port_disable,
+	.set_ptp_cpu_port = mv88e6390_g1_set_ptp_cpu_port,
+	.n_ext_ts = 1,
+	.arr0_sts_reg = MV88E6XXX_PORT_PTP_ARR0_STS,
+	.arr1_sts_reg = MV88E6XXX_PORT_PTP_ARR1_STS,
+	.dep_sts_reg = MV88E6XXX_PORT_PTP_DEP_STS,
+	.rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
+	.cc_shift = MV88E6XXX_CC_SHIFT,
+	.cc_mult = MV88E6XXX_CC_MULT,
+	.cc_mult_num = MV88E6XXX_CC_MULT_NUM,
+	.cc_mult_dem = MV88E6XXX_CC_MULT_DEM,
+};
+
 static u64 mv88e6xxx_ptp_clock_read(const struct cyclecounter *cc)
 {
 	struct mv88e6xxx_chip *chip = cc_to_chip(cc);
@@ -491,6 +520,23 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
 	chip->ptp_clock_info.verify	= ptp_ops->ptp_verify;
 	chip->ptp_clock_info.do_aux_work = mv88e6xxx_hwtstamp_work;
 
+	if (ptp_ops->set_ptp_cpu_port) {
+		struct dsa_port *dp;
+		int upstream = 0;
+		int err;
+
+		dsa_switch_for_each_user_port(dp, chip->ds) {
+			upstream = dsa_upstream_port(chip->ds, dp->index);
+			break;
+		}
+
+		err = ptp_ops->set_ptp_cpu_port(chip, upstream);
+		if (err) {
+			dev_err(chip->dev, "Failed to set PTP CPU destination port!\n");
+			return err;
+		}
+	}
+
 	chip->ptp_clock = ptp_clock_register(&chip->ptp_clock_info, chip->dev);
 	if (IS_ERR(chip->ptp_clock))
 		return PTR_ERR(chip->ptp_clock);
diff --git a/drivers/net/dsa/mv88e6xxx/ptp.h b/drivers/net/dsa/mv88e6xxx/ptp.h
index 269d5d16a466..6c4d09adc93c 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.h
+++ b/drivers/net/dsa/mv88e6xxx/ptp.h
@@ -151,6 +151,7 @@ void mv88e6xxx_ptp_free(struct mv88e6xxx_chip *chip);
 extern const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops;
 extern const struct mv88e6xxx_ptp_ops mv88e6250_ptp_ops;
 extern const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops;
+extern const struct mv88e6xxx_ptp_ops mv88e6390_ptp_ops;
 
 #else /* !CONFIG_NET_DSA_MV88E6XXX_PTP */
 
@@ -171,6 +172,7 @@ static inline void mv88e6xxx_ptp_free(struct mv88e6xxx_chip *chip)
 static const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {};
 static const struct mv88e6xxx_ptp_ops mv88e6250_ptp_ops = {};
 static const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {};
+static const struct mv88e6xxx_ptp_ops mv88e6390_ptp_ops = {};
 
 #endif /* CONFIG_NET_DSA_MV88E6XXX_PTP */
 
-- 
2.30.2

