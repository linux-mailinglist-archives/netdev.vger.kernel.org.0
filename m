Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556522BBECE
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 12:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgKUL5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 06:57:17 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45950 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgKUL5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 06:57:17 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605959834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N+AddkRf4KTt7Rnmubz8YjqH9DWUvqrHdW8uU4FXDvo=;
        b=tG9WAlZJ5TrROvfd3bKZ8SBW2xWnUYkK/JqzIDmPGutf9eo2cErNpU4tH1/PnvJCo1qVBm
        bEYJXT1gBXqF9OPeehXH3GpQS261e5oIdAAvhwqCJp9M8+1JXw+ZVpTDvoHH+zzhiXQDO+
        brg7piyKgVk1QiaDdh3umxyfHZtPYTAfaUjV9shGs5QnSr1A+wkV+gBvDT4moJlE4yQrwd
        KeA1SOraUNsQBfq/KbWqDqpJC9PrHlctarX13aPGBi2WJh73ePhLK7HC6LOMDTqRnS5JCA
        NJcib1uK78WXC73xjF8e8s6m/FgBpqE/cpynkYBXNX7ERILowMNS16bnga2C4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605959834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N+AddkRf4KTt7Rnmubz8YjqH9DWUvqrHdW8uU4FXDvo=;
        b=9bLaFvb7rmrnyfEi2b3UQy1me4qyCQNEHKQuKZQHPfsIlfISn2vjx5Gm1o9JnE/ns6n4u3
        knpdUmX/z2QGByBg==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 1/1] net: dsa: hellcreek: Add TAPRIO offloading support
Date:   Sat, 21 Nov 2020 12:57:03 +0100
Message-Id: <20201121115703.23221-2-kurt@linutronix.de>
In-Reply-To: <20201121115703.23221-1-kurt@linutronix.de>
References: <20201121115703.23221-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 * Setup delayed work for starting the schedule

The hardware supports starting a schedule up to eight seconds in the future. The
TAPRIO interface provides an absolute base time. Therefore, periodic delayed
work is leveraged to check whether a schedule may be started or not.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 314 +++++++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h |  22 ++
 2 files changed, 336 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 6420b76ea37c..35514af1922a 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <net/dsa.h>
+#include <net/pkt_sched.h>
 
 #include "hellcreek.h"
 #include "hellcreek_ptp.h"
@@ -153,6 +154,13 @@ static void hellcreek_select_vlan(struct hellcreek *hellcreek, int vid,
 	hellcreek_write(hellcreek, val, HR_VIDCFG);
 }
 
+static void hellcreek_select_tgd(struct hellcreek *hellcreek, int port)
+{
+	u16 val = port << TR_TGDSEL_TDGSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, TR_TGDSEL);
+}
+
 static int hellcreek_wait_until_ready(struct hellcreek *hellcreek)
 {
 	u16 val;
@@ -1135,6 +1143,308 @@ hellcreek_port_prechangeupper(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
+				const struct hellcreek_schedule *schedule)
+{
+	size_t i;
+
+	for (i = 1; i <= schedule->num_entries; ++i) {
+		const struct hellcreek_gcl_entry *cur, *initial, *next;
+		u16 data;
+		u8 gates;
+
+		cur = &schedule->entries[i - 1];
+		initial = &schedule->entries[0];
+		next = &schedule->entries[i];
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
+static void hellcreek_set_cycle_time(struct hellcreek *hellcreek,
+				     const struct hellcreek_schedule *schedule)
+{
+	u32 cycle_time = schedule->cycle_time;
+
+	hellcreek_write(hellcreek, cycle_time & 0x0000ffff, TR_CTWRL);
+	hellcreek_write(hellcreek, (cycle_time & 0xffff0000) >> 16, TR_CTWRH);
+}
+
+static void hellcreek_switch_schedule(struct hellcreek *hellcreek,
+				      ktime_t start_time)
+{
+	struct timespec64 ts = ktime_to_timespec64(start_time);
+
+	/* Start can be up to eight seconds in the future */
+	ts.tv_sec %= 8;
+
+	/* Start schedule at this point of time */
+	hellcreek_write(hellcreek, ts.tv_nsec & 0x0000ffff, TR_ESTWRL);
+	hellcreek_write(hellcreek, (ts.tv_nsec & 0xffff0000) >> 16, TR_ESTWRH);
+
+	/* Arm timer, set seconds and switch schedule */
+	hellcreek_write(hellcreek, TR_ESTCMD_ESTARM | TR_ESTCMD_ESTSWCFG |
+			((ts.tv_sec & TR_ESTCMD_ESTSEC_MASK) <<
+			 TR_ESTCMD_ESTSEC_SHIFT), TR_ESTCMD);
+}
+
+static struct hellcreek_schedule *
+hellcreek_taprio_to_schedule(struct tc_taprio_qopt_offload *taprio)
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
+static void hellcreek_free_schedule(struct hellcreek *hellcreek, int port)
+{
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+
+	kfree(hellcreek_port->current_schedule->entries);
+	kfree(hellcreek_port->current_schedule);
+	hellcreek_port->current_schedule = NULL;
+}
+
+static bool hellcreek_schedule_startable(struct hellcreek *hellcreek, int port)
+{
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+	s64 base_time_ns, current_ns;
+
+	/* The switch allows a schedule to be started only eight seconds within
+	 * the future. Therefore, check the current PTP time if the schedule is
+	 * startable or not.
+	 */
+
+	/* Use the "cached" time. That should be alright, as it's updated quite
+	 * frequently in the PTP code.
+	 */
+	mutex_lock(&hellcreek->ptp_lock);
+	current_ns = hellcreek->seconds * NSEC_PER_SEC + hellcreek->last_ts;
+	mutex_unlock(&hellcreek->ptp_lock);
+
+	/* Calculate difference to admin base time */
+	base_time_ns = ktime_to_ns(hellcreek_port->current_schedule->base_time);
+
+	if (base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC)
+		return true;
+
+	return false;
+}
+
+static void hellcreek_start_schedule(struct hellcreek *hellcreek, int port)
+{
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+
+	/* First select port */
+	hellcreek_select_tgd(hellcreek, port);
+
+	/* Set admin base time and switch schedule */
+	hellcreek_switch_schedule(hellcreek,
+				  hellcreek_port->current_schedule->base_time);
+
+	hellcreek_free_schedule(hellcreek, port);
+
+	dev_dbg(hellcreek->dev, "ARMed EST timer for port %d\n",
+		hellcreek_port->port);
+}
+
+static void hellcreek_check_schedule(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct hellcreek_port *hellcreek_port;
+	struct hellcreek *hellcreek;
+	bool startable;
+
+	hellcreek_port = dw_to_hellcreek_port(dw);
+	hellcreek = hellcreek_port->hellcreek;
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	/* Check starting time */
+	startable = hellcreek_schedule_startable(hellcreek,
+						 hellcreek_port->port);
+	if (startable) {
+		hellcreek_start_schedule(hellcreek, hellcreek_port->port);
+		mutex_unlock(&hellcreek->reg_lock);
+		return;
+	}
+
+	mutex_unlock(&hellcreek->reg_lock);
+
+	/* Reschedule */
+	schedule_delayed_work(&hellcreek_port->schedule_work,
+			      HELLCREEK_SCHEDULE_PERIOD);
+}
+
+static int hellcreek_port_set_schedule(struct dsa_switch *ds, int port,
+				       struct tc_taprio_qopt_offload *taprio)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port;
+	struct hellcreek_schedule *schedule;
+	bool startable;
+	u16 ctrl;
+
+	hellcreek_port = &hellcreek->ports[port];
+
+	/* Convert taprio data to hellcreek schedule */
+	schedule = hellcreek_taprio_to_schedule(taprio);
+	if (IS_ERR(schedule))
+		return PTR_ERR(schedule);
+
+	dev_dbg(hellcreek->dev, "Configure traffic schedule on port %d\n",
+		port);
+
+	/* First cancel delayed work */
+	cancel_delayed_work_sync(&hellcreek_port->schedule_work);
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	if (hellcreek_port->current_schedule)
+		hellcreek_free_schedule(hellcreek, port);
+	hellcreek_port->current_schedule = schedule;
+
+	/* Then select port */
+	hellcreek_select_tgd(hellcreek, port);
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
+	hellcreek_setup_gcl(hellcreek, port, schedule);
+
+	/* Configure cycle time */
+	hellcreek_set_cycle_time(hellcreek, schedule);
+
+	/* Check starting time */
+	startable = hellcreek_schedule_startable(hellcreek, port);
+	if (startable) {
+		hellcreek_start_schedule(hellcreek, port);
+		mutex_unlock(&hellcreek->reg_lock);
+		return 0;
+	}
+
+	mutex_unlock(&hellcreek->reg_lock);
+
+	/* Schedule periodic schedule check */
+	schedule_delayed_work(&hellcreek_port->schedule_work,
+			      HELLCREEK_SCHEDULE_PERIOD);
+
+	return 0;
+}
+
+static int hellcreek_port_del_schedule(struct dsa_switch *ds, int port)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct hellcreek_port *hellcreek_port;
+
+	hellcreek_port = &hellcreek->ports[port];
+
+	dev_dbg(hellcreek->dev, "Remove traffic schedule on port %d\n", port);
+
+	/* First cancel delayed work */
+	cancel_delayed_work_sync(&hellcreek_port->schedule_work);
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	if (hellcreek_port->current_schedule)
+		hellcreek_free_schedule(hellcreek, port);
+
+	/* Then select port */
+	hellcreek_select_tgd(hellcreek, port);
+
+	/* Disable gating and return to regular switching flow */
+	hellcreek_write(hellcreek, 0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT,
+			TR_TGDCTRL);
+
+	mutex_unlock(&hellcreek->reg_lock);
+
+	return 0;
+}
+
+static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
+				   enum tc_setup_type type, void *type_data)
+{
+	struct tc_taprio_qopt_offload *taprio = type_data;
+	struct hellcreek *hellcreek = ds->priv;
+
+	if (type != TC_SETUP_QDISC_TAPRIO)
+		return -EOPNOTSUPP;
+
+	/* Does this hellcreek version support Qbv in hardware? */
+	if (!hellcreek->pdata->qbv_support)
+		return -EOPNOTSUPP;
+
+	if (taprio->enable)
+		return hellcreek_port_set_schedule(ds, port, taprio);
+
+	return hellcreek_port_del_schedule(ds, port);
+}
+
 static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.get_ethtool_stats   = hellcreek_get_ethtool_stats,
 	.get_sset_count	     = hellcreek_get_sset_count,
@@ -1153,6 +1463,7 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.port_hwtstamp_get   = hellcreek_port_hwtstamp_get,
 	.port_prechangeupper = hellcreek_port_prechangeupper,
 	.port_rxtstamp	     = hellcreek_port_rxtstamp,
+	.port_setup_tc	     = hellcreek_port_setup_tc,
 	.port_stp_state_set  = hellcreek_port_stp_state_set,
 	.port_txtstamp	     = hellcreek_port_txtstamp,
 	.port_vlan_add	     = hellcreek_vlan_add,
@@ -1208,6 +1519,9 @@ static int hellcreek_probe(struct platform_device *pdev)
 
 		port->hellcreek	= hellcreek;
 		port->port	= i;
+
+		INIT_DELAYED_WORK(&port->schedule_work,
+				  hellcreek_check_schedule);
 	}
 
 	mutex_init(&hellcreek->reg_lock);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index e81781ebc31c..7ffb1b33ff72 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -213,6 +213,20 @@ struct hellcreek_counter {
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
@@ -246,6 +260,10 @@ struct hellcreek_port {
 
 	/* Per-port timestamping resources */
 	struct hellcreek_port_hwtstamp port_hwtstamp;
+
+	/* Per-port Qbv schedule information */
+	struct hellcreek_schedule *current_schedule;
+	struct delayed_work schedule_work;
 };
 
 struct hellcreek_fdb_entry {
@@ -283,4 +301,8 @@ struct hellcreek {
 	size_t fdb_entries;
 };
 
+#define HELLCREEK_SCHEDULE_PERIOD	(2 * HZ)
+#define dw_to_hellcreek_port(dw)				\
+	container_of(dw, struct hellcreek_port, schedule_work)
+
 #endif /* _HELLCREEK_H_ */
-- 
2.20.1

