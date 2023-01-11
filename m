Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD6C6655B2
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjAKIFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjAKIF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:05:26 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDA6BEE
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:05:25 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1673424323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ozuvmRheVB494UIpU2qw0ow0H021tS+BDG+QqqGobX4=;
        b=Yu1xIMrHI1GVB89oAndCAilVgNHXhfK3K2iawQdrmIxJxNUXubDnvB/Z7bV+AJwT2GrQF3
        1EWUiDZ4QIUE5Ij822BEP7QTQrHEpUgayzs/ADKAldxu0Rd8RtS6w8mqjAN0guHOvMr52p
        eklhot4joPAlgVqb/dr1/IpLXDRZhQ+2klyAvNyOl1dje7RCPj+xqf0nlH6Mta9CwLPKM0
        8U/sCCe1nuhC4AtOFbZOZFlLNMMkTrDIcztXSJGae98rs0hGOd/AclMVT9lgmI24aQaStR
        +ve/BQ/CYVfSzDJcgnK68ZLq+Ppyu3xUCCwjZOKjyYov7mrLxoLl1NAUXbDS7w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1673424323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ozuvmRheVB494UIpU2qw0ow0H021tS+BDG+QqqGobX4=;
        b=w62LerRm/i2jzO5z1QvjzYbmVwoOhBEwMoXfe/7M0qO2xK03EF01/zRR7/VOYTNbM0on+K
        OjMJhL3uop81rEAA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Enable PTP receive for mv88e6390
Date:   Wed, 11 Jan 2023 09:04:17 +0100
Message-Id: <20230111080417.147231-1-kurt@linutronix.de>
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

In addition, the datasheet mentions that this register is not valid e.g. for
6190 variants. So, add a new cpu port method for 6390 which programs the MGTM
and PTP destination.

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

Note, This might be related:

https://lore.kernel.org/netdev/CAFSKS=PJBpvtRJxrR4sG1hyxpnUnQpiHg4SrUNzAhkWnyt9ivg@mail.gmail.com/

 drivers/net/dsa/mv88e6xxx/chip.c    | 12 ++++++------
 drivers/net/dsa/mv88e6xxx/global1.c | 19 ++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/global1.h |  2 ++
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1168ea75f5f5..5762a24dc061 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4348,7 +4348,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
-	.set_cpu_port = mv88e6390_g1_set_cpu_port,
+	.set_cpu_port = mv88e6190_g1_set_cpu_port,
 	.set_egress_port = mv88e6390_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu =  mv88e6390_g1_mgmt_rsvd2cpu,
@@ -4753,7 +4753,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
-	.set_cpu_port = mv88e6390_g1_set_cpu_port,
+	.set_cpu_port = mv88e6190_g1_set_cpu_port,
 	.set_egress_port = mv88e6390_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
@@ -4818,7 +4818,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
-	.set_cpu_port = mv88e6390_g1_set_cpu_port,
+	.set_cpu_port = mv88e6190_g1_set_cpu_port,
 	.set_egress_port = mv88e6390_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
@@ -4881,7 +4881,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
-	.set_cpu_port = mv88e6390_g1_set_cpu_port,
+	.set_cpu_port = mv88e6190_g1_set_cpu_port,
 	.set_egress_port = mv88e6390_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
@@ -5053,7 +5053,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
-	.set_cpu_port = mv88e6390_g1_set_cpu_port,
+	.set_cpu_port = mv88e6190_g1_set_cpu_port,
 	.set_egress_port = mv88e6390_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6390_g1_mgmt_rsvd2cpu,
@@ -5214,7 +5214,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
-	.set_cpu_port = mv88e6390_g1_set_cpu_port,
+	.set_cpu_port = mv88e6190_g1_set_cpu_port,
 	.set_egress_port = mv88e6390_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu =  mv88e6390_g1_mgmt_rsvd2cpu,
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 5848112036b0..ad2d8d07fef5 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -391,7 +391,7 @@ int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 	return mv88e6390_g1_monitor_write(chip, ptr, port);
 }
 
-int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
+int mv88e6190_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
 {
 	u16 ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST;
 
@@ -403,6 +403,23 @@ int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
 	return mv88e6390_g1_monitor_write(chip, ptr, port);
 }
 
+int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
+{
+	u16 ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_PTP_CPU_DEST;
+	int ret;
+
+	ret = mv88e6190_g1_set_cpu_port(chip, port);
+	if (ret)
+		return ret;
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
index 65958b2a0d3a..f0b303f38764 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -214,6 +214,7 @@
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST		0x2000
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST		0x2100
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST		0x3000
+#define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_PTP_CPU_DEST		0x3200
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI	0x00e0
 #define MV88E6390_G1_MONITOR_MGMT_CTL_DATA_MASK			0x00ff
 
@@ -302,6 +303,7 @@ int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 				 enum mv88e6xxx_egress_direction direction,
 				 int port);
 int mv88e6095_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port);
+int mv88e6190_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g1_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
 
-- 
2.30.2

