Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4F23014CA
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 11:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbhAWK5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 05:57:34 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59666 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbhAWK53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 05:57:29 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611399404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vXSqfABGZxua2UA7SQhjw9EgSZBsCEOAHRv33mO1Lo4=;
        b=1AFZpZc/nnW9H+6N91zrr4D1RH1bJoxTaVFOZAZU9LucKEebxzns2tKvldHlLD+l2v3boB
        cPtFAMs1K3YXfJbBLEXfd50XDqAdrq2o8N80NC1kjNCWAva2s3taaK13tcHo5BjZuwtR0n
        O0dXcr36TvIEPDlBQu0O3ggR5LN4Rr3+cSB4ibx6tc76TU/YZwpioMRfI71te1MlI1F6Oq
        PhAmDoSRjjux/loaXoKdXBuTMsAIHwEGV3Cz6Zd5fr2ucwYlnppP0YdGlmVkWPunxVCYDi
        AJkcpXguxQ+BfJbjjd4Zwcr9Gt7ptLXejC3tj6rzrJSps0at7zsPCVk2/XZM3Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611399404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vXSqfABGZxua2UA7SQhjw9EgSZBsCEOAHRv33mO1Lo4=;
        b=5ekg1oMVhwqKqrwMXVZ1xngXp0NrQt7MJ23oCoq22/01PzAKsH/2w7b5BK+4REuq1Nlo/B
        ENA1HwtNxkg9d2AA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 1/1] net: dsa: hellcreek: Add TAPRIO offloading support
Date:   Sat, 23 Jan 2021 11:56:33 +0100
Message-Id: <20210123105633.16753-2-kurt@linutronix.de>
In-Reply-To: <20210123105633.16753-1-kurt@linutronix.de>
References: <20210123105633.16753-1-kurt@linutronix.de>
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 303 ++++++++++++++++++++++++-
 drivers/net/dsa/hirschmann/hellcreek.h |  17 +-
 2 files changed, 318 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 9a1921e653e8..4cc51fb37e67 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -3,7 +3,7 @@
  * DSA driver for:
  * Hirschmann Hellcreek TSN switch.
  *
- * Copyright (C) 2019,2020 Linutronix GmbH
+ * Copyright (C) 2019-2021 Linutronix GmbH
  * Author Kurt Kanzenbach <kurt@linutronix.de>
  */
 
@@ -153,6 +153,13 @@ static void hellcreek_select_vlan(struct hellcreek *hellcreek, int vid,
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
@@ -1125,6 +1132,296 @@ hellcreek_port_prechangeupper(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
+				const struct tc_taprio_qopt_offload *schedule)
+{
+	const struct tc_taprio_sched_entry *cur, *initial, *next;
+	size_t i;
+
+	cur = initial = &schedule->entries[0];
+	next = cur + 1;
+
+	for (i = 1; i <= schedule->num_entries; ++i) {
+		u16 data;
+		u8 gates;
+
+		cur++;
+		next++;
+
+		if (i == schedule->num_entries)
+			gates = initial->gate_mask ^
+				cur->gate_mask;
+		else
+			gates = next->gate_mask ^
+				cur->gate_mask;
+
+		data = gates;
+
+		if (i == schedule->num_entries)
+			data |= TR_GCLDAT_GCLWRLAST;
+
+		/* Gates states */
+		hellcreek_write(hellcreek, data, TR_GCLDAT);
+
+		/* Time interval */
+		hellcreek_write(hellcreek,
+				cur->interval & 0x0000ffff,
+				TR_GCLTIL);
+		hellcreek_write(hellcreek,
+				(cur->interval & 0xffff0000) >> 16,
+				TR_GCLTIH);
+
+		/* Commit entry */
+		data = ((i - 1) << TR_GCLCMD_GCLWRADR_SHIFT) |
+			(initial->gate_mask <<
+			 TR_GCLCMD_INIT_GATE_STATES_SHIFT);
+		hellcreek_write(hellcreek, data, TR_GCLCMD);
+	}
+}
+
+static void hellcreek_set_cycle_time(struct hellcreek *hellcreek,
+				     const struct tc_taprio_qopt_offload *schedule)
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
+	return base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC;
+}
+
+static void hellcreek_start_schedule(struct hellcreek *hellcreek, int port)
+{
+	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
+	ktime_t base_time, current_time;
+	s64 current_ns;
+	u32 cycle_time;
+
+	/* First select port */
+	hellcreek_select_tgd(hellcreek, port);
+
+	/* Forward base time into the future if needed */
+	mutex_lock(&hellcreek->ptp_lock);
+	current_ns = hellcreek->seconds * NSEC_PER_SEC + hellcreek->last_ts;
+	mutex_unlock(&hellcreek->ptp_lock);
+
+	current_time = ns_to_ktime(current_ns);
+	base_time    = hellcreek_port->current_schedule->base_time;
+	cycle_time   = hellcreek_port->current_schedule->cycle_time;
+
+	if (ktime_compare(current_time, base_time) > 0) {
+		s64 n;
+
+		n = div64_s64(ktime_sub_ns(current_time, base_time),
+			      cycle_time);
+		base_time = ktime_add_ns(base_time, (n + 1) * cycle_time);
+	}
+
+	/* Set admin base time and switch schedule */
+	hellcreek_switch_schedule(hellcreek, base_time);
+
+	taprio_offload_free(hellcreek_port->current_schedule);
+	hellcreek_port->current_schedule = NULL;
+
+	dev_dbg(hellcreek->dev, "Armed EST timer for port %d\n",
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
+	bool startable;
+	u16 ctrl;
+
+	hellcreek_port = &hellcreek->ports[port];
+
+	dev_dbg(hellcreek->dev, "Configure traffic schedule on port %d\n",
+		port);
+
+	/* First cancel delayed work */
+	cancel_delayed_work_sync(&hellcreek_port->schedule_work);
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	if (hellcreek_port->current_schedule) {
+		taprio_offload_free(hellcreek_port->current_schedule);
+		hellcreek_port->current_schedule = NULL;
+	}
+	hellcreek_port->current_schedule = taprio_offload_get(taprio);
+
+	/* Then select port */
+	hellcreek_select_tgd(hellcreek, port);
+
+	/* Enable gating and keep defaults */
+	ctrl = (0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT) | TR_TGDCTRL_GATE_EN;
+	hellcreek_write(hellcreek, ctrl, TR_TGDCTRL);
+
+	/* Cancel pending schedule */
+	hellcreek_write(hellcreek, 0x00, TR_ESTCMD);
+
+	/* Setup a new schedule */
+	hellcreek_setup_gcl(hellcreek, port, hellcreek_port->current_schedule);
+
+	/* Configure cycle time */
+	hellcreek_set_cycle_time(hellcreek, hellcreek_port->current_schedule);
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
+	if (hellcreek_port->current_schedule) {
+		taprio_offload_free(hellcreek_port->current_schedule);
+		hellcreek_port->current_schedule = NULL;
+	}
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
+static bool hellcreek_validate_schedule(struct hellcreek *hellcreek,
+					struct tc_taprio_qopt_offload *schedule)
+{
+	size_t i;
+
+	/* Does this hellcreek version support Qbv in hardware? */
+	if (!hellcreek->pdata->qbv_support)
+		return false;
+
+	/* cycle time can only be 32bit */
+	if (schedule->cycle_time > (u32)-1)
+		return false;
+
+	/* cycle time extension is not supported */
+	if (schedule->cycle_time_extension)
+		return false;
+
+	/* Only set command is supported */
+	for (i = 0; i < schedule->num_entries; ++i)
+		if (schedule->entries[i].command != TC_TAPRIO_CMD_SET_GATES)
+			return false;
+
+	return true;
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
+	if (!hellcreek_validate_schedule(hellcreek, taprio))
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
@@ -1143,6 +1440,7 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.port_hwtstamp_get   = hellcreek_port_hwtstamp_get,
 	.port_prechangeupper = hellcreek_port_prechangeupper,
 	.port_rxtstamp	     = hellcreek_port_rxtstamp,
+	.port_setup_tc	     = hellcreek_port_setup_tc,
 	.port_stp_state_set  = hellcreek_port_stp_state_set,
 	.port_txtstamp	     = hellcreek_port_txtstamp,
 	.port_vlan_add	     = hellcreek_vlan_add,
@@ -1197,6 +1495,9 @@ static int hellcreek_probe(struct platform_device *pdev)
 
 		port->hellcreek	= hellcreek;
 		port->port	= i;
+
+		INIT_DELAYED_WORK(&port->schedule_work,
+				  hellcreek_check_schedule);
 	}
 
 	mutex_init(&hellcreek->reg_lock);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index e81781ebc31c..854639f87247 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -3,7 +3,7 @@
  * DSA driver for:
  * Hirschmann Hellcreek TSN switch.
  *
- * Copyright (C) 2019,2020 Linutronix GmbH
+ * Copyright (C) 2019-2021 Linutronix GmbH
  * Author Kurt Kanzenbach <kurt@linutronix.de>
  */
 
@@ -21,6 +21,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <net/dsa.h>
+#include <net/pkt_sched.h>
 
 /* Ports:
  *  - 0: CPU
@@ -246,6 +247,10 @@ struct hellcreek_port {
 
 	/* Per-port timestamping resources */
 	struct hellcreek_port_hwtstamp port_hwtstamp;
+
+	/* Per-port Qbv schedule information */
+	struct tc_taprio_qopt_offload *current_schedule;
+	struct delayed_work schedule_work;
 };
 
 struct hellcreek_fdb_entry {
@@ -283,4 +288,14 @@ struct hellcreek {
 	size_t fdb_entries;
 };
 
+/* A Qbv schedule can only started up to 8 seconds in the future. If the delta
+ * between the base time and the current ptp time is larger than 8 seconds, then
+ * use periodic work to check for the schedule to be started. The delayed work
+ * cannot be armed directly to $base_time - 8 + X, because for large deltas the
+ * PTP frequency matters.
+ */
+#define HELLCREEK_SCHEDULE_PERIOD	(2 * HZ)
+#define dw_to_hellcreek_port(dw)				\
+	container_of(dw, struct hellcreek_port, schedule_work)
+
 #endif /* _HELLCREEK_H_ */
-- 
2.20.1

