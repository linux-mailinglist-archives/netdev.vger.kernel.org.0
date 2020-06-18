Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D795C1FEB8D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgFRGkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgFRGkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:40:46 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BAAC06174E;
        Wed, 17 Jun 2020 23:40:45 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=localhost.localdomain)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jloE6-0000xD-1F; Thu, 18 Jun 2020 08:40:42 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 5/9] net: dsa: hellcreek: Add TAPRIO offloading support
Date:   Thu, 18 Jun 2020 08:40:25 +0200
Message-Id: <20200618064029.32168-6-kurt@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200618064029.32168-1-kurt@linutronix.de>
References: <20200618064029.32168-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch has support for the 802.1Qbv Time Aware Shaper (TAS). Traffic
schedules may be configured individually on each front port. Each port has eight
egress queues. The traffic is mapped to a traffic class respectively via the PCP
field of a VLAN tagged frame.

The TAPRIO Qdisc already implements that. Therefore, this interface can simply
be reused. Add .port_setup_tc() accordingly.

The activation of a schedule on a port is split into two parts:

 * Programming the necessary gate control list (GCL)
 * Setup hrtimer for starting the schedule

The hardware supports starting a schedule up to eight seconds in the future. The
TAPRIO interface provides an absolute base time. Therefore, hrtimers are
leveraged.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 290 +++++++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h |  21 ++
 2 files changed, 311 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 138e72852b7d..7e678b298f99 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -22,7 +22,9 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/ktime.h>
+#include <linux/time.h>
 #include <net/dsa.h>
+#include <net/pkt_sched.h>
 
 #include "hellcreek.h"
 #include "hellcreek_ptp.h"
@@ -159,6 +161,15 @@ static void __hellcreek_select_vlan(struct hellcreek *hellcreek, int vid,
 	hellcreek_write(hellcreek, val, HR_VIDCFG);
 }
 
+static void __hellcreek_select_tgd(struct hellcreek *hellcreek, int port)
+{
+	u16 val = 0;
+
+	val |= port << TR_TGDSEL_TDGSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, TR_TGDSEL);
+}
+
 static int hellcreek_wait_until_ready(struct hellcreek *hellcreek)
 {
 	u16 val;
@@ -988,6 +999,24 @@ static void __hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
 	}
 }
 
+static void __hellcreek_setup_tc_mapping(struct hellcreek *hellcreek,
+					 struct net_device *netdev)
+{
+	int i, j;
+
+	/* Setup mapping between traffic classes and port queues. */
+	for (i = 0; i < netdev_get_num_tc(netdev); ++i) {
+		for (j = 0; j < netdev->tc_to_txq[i].count; ++j) {
+			const int queue = j + netdev->tc_to_txq[i].offset;
+
+			__hellcreek_select_prio(hellcreek, i);
+			hellcreek_write(hellcreek,
+					queue << HR_PRTCCFG_PCP_TC_MAP_SHIFT,
+					HR_PRTCCFG);
+		}
+	}
+}
+
 static void hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
 {
 	unsigned long flags;
@@ -1085,6 +1114,263 @@ static int hellcreek_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static void __hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
+				  const struct hellcreek_schedule *schedule)
+{
+	size_t i;
+
+	for (i = 1; i <= schedule->num_entries; ++i) {
+		const struct hellcreek_gcl_entry *cur, *initial, *next;
+		u16 data;
+		u8 gates;
+
+		cur	= &schedule->entries[i - 1];
+		initial = &schedule->entries[0];
+		next	= &schedule->entries[i];
+
+		if (i == schedule->num_entries)
+			gates = initial->gate_states ^
+				cur->gate_states;
+		else
+			gates = next->gate_states ^
+				cur->gate_states;
+
+		data = gates;
+		if (cur->overrun_ignore)
+			data |= TR_GCLDAT_GCLOVRI;
+
+		if (i == schedule->num_entries)
+			data |= TR_GCLDAT_GCLWRLAST;
+
+		/* Gates states */
+		hellcreek_write(hellcreek, data, TR_GCLDAT);
+
+		/* Time intervall */
+		hellcreek_write(hellcreek,
+				cur->interval & 0x0000ffff,
+				TR_GCLTIL);
+		hellcreek_write(hellcreek,
+				(cur->interval & 0xffff0000) >> 16,
+				TR_GCLTIH);
+
+		/* Commit entry */
+		data = ((i - 1) << TR_GCLCMD_GCLWRADR_SHIFT) |
+			(initial->gate_states <<
+			 TR_GCLCMD_INIT_GATE_STATES_SHIFT);
+		hellcreek_write(hellcreek, data, TR_GCLCMD);
+	}
+}
+
+static void __hellcreek_set_cycle_time(struct hellcreek *hellcreek,
+				       const struct hellcreek_schedule *schedule)
+{
+	u32 cycle_time = schedule->cycle_time;
+
+	hellcreek_write(hellcreek, cycle_time & 0x0000ffff, TR_CTWRL);
+	hellcreek_write(hellcreek, (cycle_time & 0xffff0000) >> 16, TR_CTWRH);
+}
+
+static void __hellcreek_start_schedule(struct hellcreek *hellcreek,
+				       ktime_t start_time)
+{
+	struct timespec64 ts = ktime_to_timespec64(start_time);
+
+	/* Start can be only 8 seconds in the future */
+	ts.tv_sec %= 8;
+
+	/* Start schedule at this point of time */
+	hellcreek_write(hellcreek, ts.tv_nsec & 0x0000ffff, TR_ESTWRL);
+	hellcreek_write(hellcreek, (ts.tv_nsec & 0xffff0000) >> 16, TR_ESTWRH);
+
+	/* Arm timer, set seconds and switch schedule */
+	hellcreek_write(hellcreek, TR_ESTCMD_ESTARM | TR_ESTCMD_ESTSWCFG |
+		     ((ts.tv_sec & TR_ESTCMD_ESTSEC_MASK) <<
+		      TR_ESTCMD_ESTSEC_SHIFT), TR_ESTCMD);
+}
+
+static struct hellcreek_schedule *hellcreek_taprio_to_schedule(
+	const struct tc_taprio_qopt_offload *taprio)
+{
+	struct hellcreek_schedule *schedule;
+	size_t i;
+
+	/* Allocate some memory first */
+	schedule = kzalloc(sizeof(*schedule), GFP_KERNEL);
+	if (!schedule)
+		return ERR_PTR(-ENOMEM);
+	schedule->entries = kcalloc(taprio->num_entries,
+				    sizeof(*schedule->entries),
+				    GFP_KERNEL);
+	if (!schedule->entries) {
+		kfree(schedule);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* Construct hellcreek schedule */
+	schedule->num_entries = taprio->num_entries;
+	schedule->base_time   = taprio->base_time;
+
+	for (i = 0; i < taprio->num_entries; ++i) {
+		const struct tc_taprio_sched_entry *t = &taprio->entries[i];
+		struct hellcreek_gcl_entry *k = &schedule->entries[i];
+
+		k->interval	  = t->interval;
+		k->gate_states	  = t->gate_mask;
+		k->overrun_ignore = 0;
+
+		/* Update complete cycle time */
+		schedule->cycle_time += t->interval;
+	}
+
+	return schedule;
+}
+
+static enum hrtimer_restart hellcreek_set_schedule(struct hrtimer *timer)
+{
+	struct hellcreek_port *hellcreek_port =
+		hrtimer_to_hellcreek_port(timer);
+	struct hellcreek *hellcreek = hellcreek_port->hellcreek;
+	struct hellcreek_schedule *schedule;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	/* First select port */
+	__hellcreek_select_tgd(hellcreek, hellcreek_port->port);
+
+	/* Set admin base time and switch schedule */
+	__hellcreek_start_schedule(hellcreek,
+				   hellcreek_port->current_schedule->base_time);
+
+	schedule = hellcreek_port->current_schedule;
+	hellcreek_port->current_schedule = NULL;
+
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	dev_info(hellcreek->dev, "ARMed EST timer for port %d\n",
+		 hellcreek_port->port);
+
+	/* Free resources */
+	kfree(schedule->entries);
+	kfree(schedule);
+
+	return HRTIMER_NORESTART;
+}
+
+static int hellcreek_port_set_schedule(struct dsa_switch *ds, int port,
+				       const struct tc_taprio_qopt_offload *taprio)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+	struct hellcreek_schedule *schedule;
+	struct net_device *netdev = dsa_to_port(ds, port)->slave;
+	unsigned long flags;
+	ktime_t start;
+	u16 ctrl;
+
+	/* Convert taprio data to hellcreek schedule */
+	schedule = hellcreek_taprio_to_schedule(taprio);
+	if (IS_ERR(schedule))
+		return PTR_ERR(schedule);
+
+	dev_info(hellcreek->dev, "Configure traffic schedule on port %d\n",
+		 port);
+
+	/* Cancel an in flight timer */
+	hrtimer_cancel(&hellcreek_port->cycle_start_timer);
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	if (hellcreek_port->current_schedule) {
+		kfree(hellcreek_port->current_schedule->entries);
+		kfree(hellcreek_port->current_schedule);
+	}
+
+	hellcreek_port->current_schedule = schedule;
+
+	/* First select port */
+	__hellcreek_select_tgd(hellcreek, port);
+
+	/* Setup traffic class <-> queue mapping */
+	__hellcreek_setup_tc_mapping(hellcreek, netdev);
+
+	/* Enable gating and set the admin state to forward everything in the
+	 * mean time
+	 */
+	ctrl = (0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT) | TR_TGDCTRL_GATE_EN;
+	hellcreek_write(hellcreek, ctrl, TR_TGDCTRL);
+
+	/* Cancel pending schedule */
+	hellcreek_write(hellcreek, 0x00, TR_ESTCMD);
+
+	/* Setup a new schedule */
+	__hellcreek_setup_gcl(hellcreek, port, schedule);
+
+	/* Configure cycle time */
+	__hellcreek_set_cycle_time(hellcreek, schedule);
+
+	/* Setup timer for schedule switch: The IP core only allows to set a
+	 * cycle start timer 8 seconds in the future. This is why we setup the
+	 * hritmer to base_time - 5 seconds. Then, we have enough time to
+	 * activate IP core's EST timer.
+	 */
+	start = ktime_sub_ns(schedule->base_time, (u64)5 * NSEC_PER_SEC);
+	hrtimer_start_range_ns(&hellcreek_port->cycle_start_timer, start,
+			       NSEC_PER_SEC, HRTIMER_MODE_ABS);
+
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	return 0;
+}
+
+static int hellcreek_port_del_schedule(struct dsa_switch *ds, int port)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+	unsigned long flags;
+
+	dev_info(hellcreek->dev, "Remove traffic schedule on port %d\n", port);
+
+	/* First cancel timer */
+	hrtimer_cancel(&hellcreek_port->cycle_start_timer);
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+
+	if (hellcreek_port->current_schedule) {
+		kfree(hellcreek_port->current_schedule->entries);
+		kfree(hellcreek_port->current_schedule);
+		hellcreek_port->current_schedule = NULL;
+	}
+
+	/* Then select port */
+	__hellcreek_select_tgd(hellcreek, port);
+
+	/* Revert tc mapping */
+	__hellcreek_setup_tc_identity_mapping(hellcreek);
+
+	/* Disable gating and return to regular switching flow */
+	hellcreek_write(hellcreek, 0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT,
+			TR_TGDCTRL);
+
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	return 0;
+}
+
+static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
+				   enum tc_setup_type type, void *type_data)
+{
+	const struct tc_taprio_qopt_offload *taprio = type_data;
+
+	if (type != TC_SETUP_QDISC_TAPRIO)
+		return -EOPNOTSUPP;
+
+	if (taprio->enable)
+		return hellcreek_port_set_schedule(ds, port, taprio);
+
+	return hellcreek_port_del_schedule(ds, port);
+}
+
 static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.get_tag_protocol    = hellcreek_get_tag_protocol,
 	.setup		     = hellcreek_setup,
@@ -1107,6 +1393,7 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.port_hwtstamp_get   = hellcreek_port_hwtstamp_get,
 	.port_txtstamp	     = hellcreek_port_txtstamp,
 	.port_rxtstamp	     = hellcreek_port_rxtstamp,
+	.port_setup_tc	     = hellcreek_port_setup_tc,
 	.get_ts_info	     = hellcreek_get_ts_info,
 };
 
@@ -1138,6 +1425,9 @@ static int hellcreek_probe(struct platform_device *pdev)
 		if (!port->counter_values)
 			return -ENOMEM;
 
+		hrtimer_init(&port->cycle_start_timer, CLOCK_TAI,
+			     HRTIMER_MODE_ABS);
+		port->cycle_start_timer.function = hellcreek_set_schedule;
 		port->hellcreek = hellcreek;
 		port->port	= i;
 	}
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index 1d3de72a48a5..d3d1a1144857 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -16,6 +16,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <linux/spinlock.h>
+#include <linux/hrtimer.h>
 #include <net/dsa.h>
 
 /* Ports:
@@ -210,6 +211,20 @@ struct hellcreek_counter {
 	const char *name;
 };
 
+struct hellcreek_gcl_entry {
+	u32 interval;
+	u8 gate_states;
+	bool overrun_ignore;
+};
+
+struct hellcreek_schedule {
+	struct hellcreek_gcl_entry *entries;
+	size_t num_entries;
+	ktime_t base_time;
+	u32 cycle_time;
+	int port;
+};
+
 struct hellcreek;
 
 /* State flags for hellcreek_port_hwtstamp::state */
@@ -236,6 +251,8 @@ struct hellcreek_port_hwtstamp {
 
 struct hellcreek_port {
 	struct hellcreek *hellcreek;
+	struct hellcreek_schedule *current_schedule;
+	struct hrtimer cycle_start_timer;
 	int port;
 	u16 ptcfg;		/* ptcfg shadow */
 	u64 *counter_values;
@@ -273,4 +290,8 @@ struct hellcreek {
 	size_t fdb_entries;
 };
 
+#define hrtimer_to_hellcreek_port(timer)		\
+	container_of(timer, struct hellcreek_port,	\
+		     cycle_start_timer)
+
 #endif /* _HELLCREEK_H_ */
-- 
2.20.1

