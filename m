Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194BF46F212
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbhLIRiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhLIRiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:38:02 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B59DC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 09:34:28 -0800 (PST)
Received: from p200300c1f71f60ea1ed6c9bb8cdd2799.dip0.t-ipconnect.de ([2003:c1:f71f:60ea:1ed6:c9bb:8cdd:2799] helo=localhost.localdomain); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1mvNJI-0000sc-JS; Thu, 09 Dec 2021 18:34:24 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
Date:   Thu,  9 Dec 2021 18:33:37 +0100
Message-Id: <20211209173337.24521-1-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1639071268;ad3ccae1;
X-HE-SMSGID: 1mvNJI-0000sc-JS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A time aware switch should trap PTP traffic to the management CPU. User space
daemons such as ptp4l will process these messages to implement Boundary (or
Transparent) Clocks.

At the moment the mv88e6xxx driver for mv88e6341 doesn't trap these messages
which leads to confusion when multiple end devices are connected to the
switch. Therefore, setup PTP traps. Leverage the already implemented policy
mechanism based on destination addresses. Configure the traps only if
timestamping is enabled so that non time aware use case is still functioning.

Introduce an additional PTP operation in case other devices need special
handling in regards to trapping as well.

Tested on Marvell Topaz (mv88e6341) switch with multiple end devices connected
like this:

|# DSA setup
|$ ip link set eth0 up
|$ ip link set lan0 up
|$ ip link set lan1 up
|$ ip link set lan2 up
|$ ip link add name br0 type bridge
|$ ip link set dev lan0 master br0
|$ ip link set dev lan1 master br0
|$ ip link set dev lan2 master br0
|$ ip link set lan0 up
|$ ip link set lan1 up
|$ ip link set lan2 up
|$ ip link set br0 up
|$ dhclient br0
|# Configure bridge routing
|$ ebtables --table broute --append BROUTING --protocol 0x88F7 --jump DROP
|# Start linuxptp
|$ ptp4l -H -2 -i lan0 -i lan1 -i lan2 --tx_timestamp_timeout=40 -m

Verified added policies with mv88e6xxx_dump.

Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 drivers/net/dsa/mv88e6xxx/chip.c     | 12 +++---
 drivers/net/dsa/mv88e6xxx/chip.h     |  5 +++
 drivers/net/dsa/mv88e6xxx/hwtstamp.c |  7 ++++
 drivers/net/dsa/mv88e6xxx/ptp.c      | 59 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/ptp.h      |  2 +
 5 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7fadbf987b23..ab50ebd85f1f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1816,8 +1816,8 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_g1_atu_loadpurge(chip, fid, &entry);
 }
 
-static int mv88e6xxx_policy_apply(struct mv88e6xxx_chip *chip, int port,
-				  const struct mv88e6xxx_policy *policy)
+int mv88e6xxx_policy_apply(struct mv88e6xxx_chip *chip, int port,
+			   const struct mv88e6xxx_policy *policy)
 {
 	enum mv88e6xxx_policy_mapping mapping = policy->mapping;
 	enum mv88e6xxx_policy_action action = policy->action;
@@ -1835,10 +1835,12 @@ static int mv88e6xxx_policy_apply(struct mv88e6xxx_chip *chip, int port,
 	case MV88E6XXX_POLICY_MAPPING_SA:
 		if (action == MV88E6XXX_POLICY_ACTION_NORMAL)
 			state = 0; /* Dissociate the port and address */
-		else if (action == MV88E6XXX_POLICY_ACTION_DISCARD &&
+		else if ((action == MV88E6XXX_POLICY_ACTION_DISCARD ||
+			  action == MV88E6XXX_POLICY_ACTION_TRAP) &&
 			 is_multicast_ether_addr(addr))
 			state = MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_POLICY;
-		else if (action == MV88E6XXX_POLICY_ACTION_DISCARD &&
+		else if ((action == MV88E6XXX_POLICY_ACTION_DISCARD ||
+			  action == MV88E6XXX_POLICY_ACTION_TRAP) &&
 			 is_unicast_ether_addr(addr))
 			state = MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_POLICY;
 		else
@@ -4589,7 +4591,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
-	.ptp_ops = &mv88e6352_ptp_ops,
+	.ptp_ops = &mv88e6341_ptp_ops,
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 8271b8aa7b71..795ae5a56834 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -673,6 +673,8 @@ struct mv88e6xxx_ptp_ops {
 	int (*port_disable)(struct mv88e6xxx_chip *chip, int port);
 	int (*global_enable)(struct mv88e6xxx_chip *chip);
 	int (*global_disable)(struct mv88e6xxx_chip *chip);
+	int (*setup_ptp_traps)(struct mv88e6xxx_chip *chip, int port,
+			       bool enable);
 	int n_ext_ts;
 	int arr0_sts_reg;
 	int arr1_sts_reg;
@@ -760,4 +762,7 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
 
 int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
 
+int mv88e6xxx_policy_apply(struct mv88e6xxx_chip *chip, int port,
+			   const struct mv88e6xxx_policy *policy);
+
 #endif /* _MV88E6XXX_CHIP_H */
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
index 8f74ffc7a279..617aeb6cbaac 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
@@ -94,6 +94,7 @@ static int mv88e6xxx_set_hwtstamp_config(struct mv88e6xxx_chip *chip, int port,
 	const struct mv88e6xxx_ptp_ops *ptp_ops = chip->info->ops->ptp_ops;
 	struct mv88e6xxx_port_hwtstamp *ps = &chip->port_hwtstamp[port];
 	bool tstamp_enable = false;
+	int ret;
 
 	/* Prevent the TX/RX paths from trying to interact with the
 	 * timestamp hardware while we reconfigure it.
@@ -161,6 +162,12 @@ static int mv88e6xxx_set_hwtstamp_config(struct mv88e6xxx_chip *chip, int port,
 		if (chip->enable_count == 0 && ptp_ops->global_disable)
 			ptp_ops->global_disable(chip);
 	}
+
+	if (ptp_ops->setup_ptp_traps) {
+		ret = ptp_ops->setup_ptp_traps(chip, port, tstamp_enable);
+		if (tstamp_enable && ret)
+			dev_warn(chip->dev, "Failed to setup PTP traps. PTP might not work as desired!\n");
+	}
 	mv88e6xxx_reg_unlock(chip);
 
 	/* Once hardware has been configured, enable timestamp checks
diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index d838c174dc0d..8d6ff03d37c8 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -345,6 +345,37 @@ static int mv88e6352_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 	return 0;
 }
 
+static int mv88e6341_setup_ptp_traps(struct mv88e6xxx_chip *chip, int port,
+				     bool enable)
+{
+	static const u8 ptp_destinations[][ETH_ALEN] = {
+		{ 0x01, 0x1b, 0x19, 0x00, 0x00, 0x00 }, /* L2 PTP */
+		{ 0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e }, /* L2 P2P */
+		{ 0x01, 0x00, 0x5e, 0x00, 0x01, 0x81 }, /* IPv4 PTP */
+		{ 0x01, 0x00, 0x5e, 0x00, 0x00, 0x6b }, /* IPv4 P2P */
+		{ 0x33, 0x33, 0x00, 0x00, 0x01, 0x81 }, /* IPv6 PTP */
+		{ 0x33, 0x33, 0x00, 0x00, 0x00, 0x6b }, /* IPv6 P2P */
+	};
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(ptp_destinations); ++i) {
+		struct mv88e6xxx_policy policy = { };
+
+		policy.mapping	= MV88E6XXX_POLICY_MAPPING_DA;
+		policy.action	= enable ? MV88E6XXX_POLICY_ACTION_TRAP :
+			MV88E6XXX_POLICY_ACTION_NORMAL;
+		policy.port	= port;
+		policy.vid	= 0;
+		ether_addr_copy(policy.addr, ptp_destinations[i]);
+
+		ret = mv88e6xxx_policy_apply(chip, port, &policy);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {
 	.clock_read = mv88e6165_ptp_clock_read,
 	.global_enable = mv88e6165_global_enable,
@@ -419,6 +450,34 @@ const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {
 	.cc_mult_dem = MV88E6XXX_CC_MULT_DEM,
 };
 
+const struct mv88e6xxx_ptp_ops mv88e6341_ptp_ops = {
+	.clock_read = mv88e6352_ptp_clock_read,
+	.ptp_enable = mv88e6352_ptp_enable,
+	.ptp_verify = mv88e6352_ptp_verify,
+	.event_work = mv88e6352_tai_event_work,
+	.port_enable = mv88e6352_hwtstamp_port_enable,
+	.port_disable = mv88e6352_hwtstamp_port_disable,
+	.setup_ptp_traps = mv88e6341_setup_ptp_traps,
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
diff --git a/drivers/net/dsa/mv88e6xxx/ptp.h b/drivers/net/dsa/mv88e6xxx/ptp.h
index 269d5d16a466..badcb72d10a6 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.h
+++ b/drivers/net/dsa/mv88e6xxx/ptp.h
@@ -151,6 +151,7 @@ void mv88e6xxx_ptp_free(struct mv88e6xxx_chip *chip);
 extern const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops;
 extern const struct mv88e6xxx_ptp_ops mv88e6250_ptp_ops;
 extern const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops;
+extern const struct mv88e6xxx_ptp_ops mv88e6341_ptp_ops;
 
 #else /* !CONFIG_NET_DSA_MV88E6XXX_PTP */
 
@@ -171,6 +172,7 @@ static inline void mv88e6xxx_ptp_free(struct mv88e6xxx_chip *chip)
 static const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {};
 static const struct mv88e6xxx_ptp_ops mv88e6250_ptp_ops = {};
 static const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {};
+static const struct mv88e6xxx_ptp_ops mv88e6341_ptp_ops = {};
 
 #endif /* CONFIG_NET_DSA_MV88E6XXX_PTP */
 
-- 
2.34.1

