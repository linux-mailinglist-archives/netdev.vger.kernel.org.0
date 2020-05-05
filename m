Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77A51C60F8
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgEETVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbgEETVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:21:11 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DA0C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 12:21:10 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z8so3172382wrw.3
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 12:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FaMC5o4hbNPhE/fIEXi5NfpSLWoVv9tFAm1YiK3049g=;
        b=hZlCVq4Z1Vji87MZv2HkPbmAxCV463gN07eNcFf4FqfB2ieJF2HgrTsowD8LwJWUlG
         ha049U7DSHgXpH4fO/dae7lr0oYztaJFt7SdAVGb/QbLEoJW+trLICstgwRx3obznCJG
         MoT2L7VXJ871wg1zOl6GnIv9+MM4jmoEFAMnDjWTXR4a3pQ1siQ7MQF8C9fU6J1Fm4qD
         NBlAiUZe2cxBJjyF4FYDxdBuBZ+LC1sNBicxun11J90f4vCfq8eqJTMnekNwdsvDXNHU
         tvyzzBrJUeD7l9N6CgLhgOzmUomt5Lgx6jNZJFjpkL7tuFC1QZ02P92z1u0LUYGZqhhm
         7/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FaMC5o4hbNPhE/fIEXi5NfpSLWoVv9tFAm1YiK3049g=;
        b=MsQJ07N+nqFZuS8DmCgFCq1b4QLsy9Y6fTV/5QJtBPAZIfYpJhKQu/rUtYmDTUyTNy
         YGcqrdm5OzWlX0f3uVRpjM3YwNXWDApM9piJToeMHpylIczuPlqTbZ3R5KxU63q/LYnI
         8d3cAgMcEI1E/wMcl+2XjD4Lc1P007EOTg+wWAoOqGnFWguzQJUcA3rbw/3HImApudF7
         t0Ie8RWWFIgxZh5NiA2wUl92bgxOaZ/mA1DODjBLQ4XZK8EptkBDJYWK3tfIbubqDwPx
         cX1315Xbz+omNrADaAqVeVuXjokCszHCvjKpqL55mfCO+6k5AZ0uVSHRCzl0xiO6sxbF
         6kpg==
X-Gm-Message-State: AGi0PuZXtqbHUO9RL/lLRdwpekGFcST2Y3WVBA8yptBWX3tpe3PCqsRW
        SzTgXoBBYq06VX/cDJMF9e/Hknms
X-Google-Smtp-Source: APiQypJ/ElAkl92A5liHQ3Ck90EoLoO1G7za0dUWZOED+tmtXBVtNnt5EmHelvnP3deiR5JNbeINLA==
X-Received: by 2002:adf:e408:: with SMTP id g8mr5754586wrm.363.1588706467817;
        Tue, 05 May 2020 12:21:07 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id z16sm5090681wrl.0.2020.05.05.12.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 12:21:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com
Subject: [PATCH v3 net-next 5/6] net: dsa: sja1105: implement tc-gate using time-triggered virtual links
Date:   Tue,  5 May 2020 22:20:56 +0300
Message-Id: <20200505192057.9086-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505192057.9086-1-olteanv@gmail.com>
References: <20200505192057.9086-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Restrict the TTEthernet hardware support on this switch to operate as
closely as possible to IEEE 802.1Qci as possible. This means that it can
perform PTP-time-based ingress admission control on streams identified
by {DMAC, VID, PCP}, which is useful when trying to ensure the
determinism of traffic scheduled via IEEE 802.1Qbv.

The oddity comes from the fact that in hardware (and in TTEthernet at
large), virtual links always need a full-blown action, including not
only the type of policing, but also the list of destination ports. So in
practice, a single tc-gate action will result in all packets getting
dropped. Additional actions (either "trap" or "redirect") need to be
specified in the same filter rule such that the conforming packets are
actually forwarded somewhere.

Apart from the VL Lookup, Policing and Forwarding tables which need to
be programmed for each flow (virtual link), the Schedule engine also
needs to be told to open/close the admission gates for each individual
virtual link. A fairly accurate (and detailed) description of how that
works is already present in sja1105_tas.c, since it is already used to
trigger the egress gates for the tc-taprio offload (IEEE 802.1Qbv). Key
point here, we remember that the schedule engine supports 8
"subschedules" (execution threads that iterate through the global
schedule in parallel, and that no 2 hardware threads must execute a
schedule entry at the same time). For tc-taprio, each egress port used
one of these 8 subschedules, leaving a total of 4 subschedules unused.
In principle we could have allocated 1 subschedule for the tc-gate
offload of each ingress port, but actually the schedules of all virtual
links installed on each ingress port would have needed to be merged
together, before they could have been programmed to hardware. So
simplify our life and just merge the entire tc-gate configuration, for
all virtual links on all ingress ports, into a single subschedule. Be
sure to check that against the usual hardware scheduling conflicts, and
program it to hardware alongside any tc-taprio subschedule that may be
present.

The following scenarios were tested:

1. Quantitative testing:

   tc qdisc add dev swp2 clsact
   tc filter add dev swp2 ingress flower skip_sw \
           dst_mac 42:be:24:9b:76:20 \
           action gate index 1 base-time 0 \
           sched-entry OPEN 1200 -1 -1 \
           sched-entry CLOSE 1200 -1 -1 \
           action trap

   ping 192.168.1.2 -f
   PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
   .............................
   --- 192.168.1.2 ping statistics ---
   948 packets transmitted, 467 received, 50.7384% packet loss, time 9671ms

2. Qualitative testing (with a phase-aligned schedule - the clocks are
   synchronized by ptp4l, not shown here):

   Receiver (sja1105):

   tc qdisc add dev swp2 clsact
   now=$(phc_ctl /dev/ptp1 get | awk '/clock time is/ {print $5}') && \
           sec=$(echo $now | awk -F. '{print $1}') && \
           base_time="$(((sec + 2) * 1000000000))" && \
           echo "base time ${base_time}"
   tc filter add dev swp2 ingress flower skip_sw \
           dst_mac 42:be:24:9b:76:20 \
           action gate base-time ${base_time} \
           sched-entry OPEN  60000 -1 -1 \
           sched-entry CLOSE 40000 -1 -1 \
           action trap

   Sender (enetc):
   now=$(phc_ctl /dev/ptp0 get | awk '/clock time is/ {print $5}') && \
           sec=$(echo $now | awk -F. '{print $1}') && \
           base_time="$(((sec + 2) * 1000000000))" && \
           echo "base time ${base_time}"
   tc qdisc add dev eno0 parent root taprio \
           num_tc 8 \
           map 0 1 2 3 4 5 6 7 \
           queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
           base-time ${base_time} \
           sched-entry S 01  50000 \
           sched-entry S 00  50000 \
           flags 2

   ping -A 192.168.1.1
   PING 192.168.1.1 (192.168.1.1): 56 data bytes
   ...
   ^C
   --- 192.168.1.1 ping statistics ---
   1425 packets transmitted, 1424 packets received, 0% packet loss
   round-trip min/avg/max = 0.322/0.361/0.990 ms

   And just for comparison, with the tc-taprio schedule deleted:

   ping -A 192.168.1.1
   PING 192.168.1.1 (192.168.1.1): 56 data bytes
   ...
   ^C
   --- 192.168.1.1 ping statistics ---
   33 packets transmitted, 19 packets received, 42% packet loss
   round-trip min/avg/max = 0.336/0.464/0.597 ms

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes from v2:
Provide a shim implementation of sja1105_init_scheduling.

Changes from v1:
None.

Changes from RFC:
* Deny gating actions in absence of any routing action. Without this
  check, the default behavior would be to drop everything, which is
  probably not what the user expects.
* Deny offloading IntervalOctetMax, which I initially mistook for meaning
  per-flow MTU. It actually means a sort of flow metering within each
  time slot. Not supported.

 drivers/net/dsa/sja1105/sja1105.h             |  13 +-
 drivers/net/dsa/sja1105/sja1105_flower.c      |  57 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |   1 +
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  13 +
 drivers/net/dsa/sja1105/sja1105_spi.c         |   2 +
 .../net/dsa/sja1105/sja1105_static_config.h   |   2 +
 drivers/net/dsa/sja1105/sja1105_tas.c         | 127 ++++-
 drivers/net/dsa/sja1105/sja1105_tas.h         |  36 ++
 drivers/net/dsa/sja1105/sja1105_vl.c          | 494 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_vl.h          |  31 ++
 10 files changed, 759 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 1756000f6936..8df2a5c53b02 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -36,6 +36,7 @@ struct sja1105_regs {
 	u64 status;
 	u64 port_control;
 	u64 rgu;
+	u64 vl_status;
 	u64 config;
 	u64 sgmii;
 	u64 rmii_pll1;
@@ -156,8 +157,16 @@ struct sja1105_rule {
 
 		/* SJA1105_RULE_VL */
 		struct {
-			unsigned long destports;
 			enum sja1105_vl_type type;
+			unsigned long destports;
+			int sharindx;
+			int maxlen;
+			int ipv;
+			u64 base_time;
+			u64 cycle_time;
+			int num_entries;
+			struct action_gate_entry *entries;
+			struct flow_stats stats;
 		} vl;
 	};
 };
@@ -304,6 +313,8 @@ int sja1105_cls_flower_del(struct dsa_switch *ds, int port,
 			   struct flow_cls_offload *cls, bool ingress);
 int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			   struct flow_cls_offload *cls, bool ingress);
+int sja1105_cls_flower_stats(struct dsa_switch *ds, int port,
+			     struct flow_cls_offload *cls, bool ingress);
 void sja1105_flower_setup(struct dsa_switch *ds);
 void sja1105_flower_teardown(struct dsa_switch *ds);
 struct sja1105_rule *sja1105_rule_find(struct sja1105_private *priv,
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 5f08eed0b1fc..9ee8968610cd 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -309,7 +309,9 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 	struct sja1105_private *priv = ds->priv;
 	const struct flow_action_entry *act;
 	unsigned long cookie = cls->cookie;
+	bool routing_rule = false;
 	struct sja1105_key key;
+	bool gate_rule = false;
 	bool vl_rule = false;
 	int rc, i;
 
@@ -332,6 +334,7 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 		case FLOW_ACTION_TRAP: {
 			int cpu = dsa_upstream_port(ds, port);
 
+			routing_rule = true;
 			vl_rule = true;
 
 			rc = sja1105_vl_redirect(priv, port, extack, cookie,
@@ -350,6 +353,7 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 				return -EOPNOTSUPP;
 			}
 
+			routing_rule = true;
 			vl_rule = true;
 
 			rc = sja1105_vl_redirect(priv, port, extack, cookie,
@@ -366,6 +370,21 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			if (rc)
 				goto out;
 			break;
+		case FLOW_ACTION_GATE:
+			gate_rule = true;
+			vl_rule = true;
+
+			rc = sja1105_vl_gate(priv, port, extack, cookie,
+					     &key, act->gate.index,
+					     act->gate.prio,
+					     act->gate.basetime,
+					     act->gate.cycletime,
+					     act->gate.cycletimeext,
+					     act->gate.num_entries,
+					     act->gate.entries);
+			if (rc)
+				goto out;
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Action not supported");
@@ -374,8 +393,23 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 		}
 	}
 
-	if (vl_rule && !rc)
+	if (vl_rule && !rc) {
+		/* Delay scheduling configuration until DESTPORTS has been
+		 * populated by all other actions.
+		 */
+		if (gate_rule) {
+			if (!routing_rule) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Can only offload gate action together with redirect or trap");
+				return -EOPNOTSUPP;
+			}
+			rc = sja1105_init_scheduling(priv);
+			if (rc)
+				goto out;
+		}
+
 		rc = sja1105_static_config_reload(priv, SJA1105_VIRTUAL_LINKS);
+	}
 
 out:
 	return rc;
@@ -421,6 +455,27 @@ int sja1105_cls_flower_del(struct dsa_switch *ds, int port,
 	return sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
 }
 
+int sja1105_cls_flower_stats(struct dsa_switch *ds, int port,
+			     struct flow_cls_offload *cls, bool ingress)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_rule *rule = sja1105_rule_find(priv, cls->cookie);
+	int rc;
+
+	if (!rule)
+		return 0;
+
+	if (rule->type != SJA1105_RULE_VL)
+		return 0;
+
+	rc = sja1105_vl_stats(priv, port, rule, &cls->stats,
+			      cls->common.extack);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
 void sja1105_flower_setup(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8bb104ee73d5..666e54565df0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2369,6 +2369,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_policer_del	= sja1105_port_policer_del,
 	.cls_flower_add		= sja1105_cls_flower_add,
 	.cls_flower_del		= sja1105_cls_flower_del,
+	.cls_flower_stats	= sja1105_cls_flower_stats,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 43480b24f1f0..6408d1158f2d 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -48,6 +48,19 @@ static inline s64 future_base_time(s64 base_time, s64 cycle_time, s64 now)
 	return base_time + n * cycle_time;
 }
 
+/* This is not a preprocessor macro because the "ns" argument may or may not be
+ * s64 at caller side. This ensures it is properly type-cast before div_s64.
+ */
+static inline s64 ns_to_sja1105_delta(s64 ns)
+{
+	return div_s64(ns, 200);
+}
+
+static inline s64 sja1105_delta_to_ns(s64 delta)
+{
+	return delta * 200;
+}
+
 struct sja1105_ptp_cmd {
 	u64 startptpcp;		/* start toggling PTP_CLK pin */
 	u64 stopptpcp;		/* stop toggling PTP_CLK pin */
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 43f14a5c2718..0be75c49e6c3 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -439,6 +439,7 @@ static struct sja1105_regs sja1105et_regs = {
 	.prod_id = 0x100BC3,
 	.status = 0x1,
 	.port_control = 0x11,
+	.vl_status = 0x10000,
 	.config = 0x020000,
 	.rgu = 0x100440,
 	/* UM10944.pdf, Table 86, ACU Register overview */
@@ -472,6 +473,7 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.prod_id = 0x100BC3,
 	.status = 0x1,
 	.port_control = 0x12,
+	.vl_status = 0x10000,
 	.config = 0x020000,
 	.rgu = 0x100440,
 	/* UM10944.pdf, Table 86, ACU Register overview */
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 1a8fcbbb57b6..b569e3de3590 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -302,6 +302,8 @@ struct sja1105_vl_lookup_entry {
 			u64 vlid;
 		};
 	};
+	/* Not part of hardware structure */
+	unsigned long flow_cookie;
 };
 
 struct sja1105_vl_policing_entry {
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
index 77e547b4cd89..3aa1a8b5f766 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.c
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -7,7 +7,6 @@
 #define SJA1105_TAS_CLKSRC_STANDALONE	1
 #define SJA1105_TAS_CLKSRC_AS6802	2
 #define SJA1105_TAS_CLKSRC_PTP		3
-#define SJA1105_TAS_MAX_DELTA		BIT(19)
 #define SJA1105_GATE_MASK		GENMASK_ULL(SJA1105_NUM_TC - 1, 0)
 
 #define work_to_sja1105_tas(d) \
@@ -15,22 +14,10 @@
 #define tas_to_sja1105(d) \
 	container_of((d), struct sja1105_private, tas_data)
 
-/* This is not a preprocessor macro because the "ns" argument may or may not be
- * s64 at caller side. This ensures it is properly type-cast before div_s64.
- */
-static s64 ns_to_sja1105_delta(s64 ns)
-{
-	return div_s64(ns, 200);
-}
-
-static s64 sja1105_delta_to_ns(s64 delta)
-{
-	return delta * 200;
-}
-
 static int sja1105_tas_set_runtime_params(struct sja1105_private *priv)
 {
 	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	struct sja1105_gating_config *gating_cfg = &tas_data->gating_cfg;
 	struct dsa_switch *ds = priv->ds;
 	s64 earliest_base_time = S64_MAX;
 	s64 latest_base_time = 0;
@@ -59,6 +46,19 @@ static int sja1105_tas_set_runtime_params(struct sja1105_private *priv)
 		}
 	}
 
+	if (!list_empty(&gating_cfg->entries)) {
+		tas_data->enabled = true;
+
+		if (max_cycle_time < gating_cfg->cycle_time)
+			max_cycle_time = gating_cfg->cycle_time;
+		if (latest_base_time < gating_cfg->base_time)
+			latest_base_time = gating_cfg->base_time;
+		if (earliest_base_time > gating_cfg->base_time) {
+			earliest_base_time = gating_cfg->base_time;
+			its_cycle_time = gating_cfg->cycle_time;
+		}
+	}
+
 	if (!tas_data->enabled)
 		return 0;
 
@@ -155,13 +155,14 @@ static int sja1105_tas_set_runtime_params(struct sja1105_private *priv)
  *  their "subschedule end index" (subscheind) equal to the last valid
  *  subschedule's end index (in this case 5).
  */
-static int sja1105_init_scheduling(struct sja1105_private *priv)
+int sja1105_init_scheduling(struct sja1105_private *priv)
 {
 	struct sja1105_schedule_entry_points_entry *schedule_entry_points;
 	struct sja1105_schedule_entry_points_params_entry
 					*schedule_entry_points_params;
 	struct sja1105_schedule_params_entry *schedule_params;
 	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	struct sja1105_gating_config *gating_cfg = &tas_data->gating_cfg;
 	struct sja1105_schedule_entry *schedule;
 	struct sja1105_table *table;
 	int schedule_start_idx;
@@ -213,6 +214,11 @@ static int sja1105_init_scheduling(struct sja1105_private *priv)
 		}
 	}
 
+	if (!list_empty(&gating_cfg->entries)) {
+		num_entries += gating_cfg->num_entries;
+		num_cycles++;
+	}
+
 	/* Nothing to do */
 	if (!num_cycles)
 		return 0;
@@ -312,6 +318,42 @@ static int sja1105_init_scheduling(struct sja1105_private *priv)
 		cycle++;
 	}
 
+	if (!list_empty(&gating_cfg->entries)) {
+		struct sja1105_gate_entry *e;
+
+		/* Relative base time */
+		s64 rbt;
+
+		schedule_start_idx = k;
+		schedule_end_idx = k + gating_cfg->num_entries - 1;
+		rbt = future_base_time(gating_cfg->base_time,
+				       gating_cfg->cycle_time,
+				       tas_data->earliest_base_time);
+		rbt -= tas_data->earliest_base_time;
+		entry_point_delta = ns_to_sja1105_delta(rbt) + 1;
+
+		schedule_entry_points[cycle].subschindx = cycle;
+		schedule_entry_points[cycle].delta = entry_point_delta;
+		schedule_entry_points[cycle].address = schedule_start_idx;
+
+		for (i = cycle; i < 8; i++)
+			schedule_params->subscheind[i] = schedule_end_idx;
+
+		list_for_each_entry(e, &gating_cfg->entries, list) {
+			schedule[k].delta = ns_to_sja1105_delta(e->interval);
+			schedule[k].destports = e->rule->vl.destports;
+			schedule[k].setvalid = true;
+			schedule[k].txen = true;
+			schedule[k].vlindex = e->rule->vl.sharindx;
+			schedule[k].winstindex = e->rule->vl.sharindx;
+			if (e->gate_state) /* Gate open */
+				schedule[k].winst = true;
+			else /* Gate closed */
+				schedule[k].winend = true;
+			k++;
+		}
+	}
+
 	return 0;
 }
 
@@ -415,6 +457,54 @@ sja1105_tas_check_conflicts(struct sja1105_private *priv, int port,
 	return false;
 }
 
+/* Check the tc-taprio configuration on @port for conflicts with the tc-gate
+ * global subschedule. If @port is -1, check it against all ports.
+ * To reuse the sja1105_tas_check_conflicts logic without refactoring it,
+ * convert the gating configuration to a dummy tc-taprio offload structure.
+ */
+bool sja1105_gating_check_conflicts(struct sja1105_private *priv, int port,
+				    struct netlink_ext_ack *extack)
+{
+	struct sja1105_gating_config *gating_cfg = &priv->tas_data.gating_cfg;
+	size_t num_entries = gating_cfg->num_entries;
+	struct tc_taprio_qopt_offload *dummy;
+	struct sja1105_gate_entry *e;
+	bool conflict;
+	int i = 0;
+
+	if (list_empty(&gating_cfg->entries))
+		return false;
+
+	dummy = kzalloc(sizeof(struct tc_taprio_sched_entry) * num_entries +
+			sizeof(struct tc_taprio_qopt_offload), GFP_KERNEL);
+	if (!dummy) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to allocate memory");
+		return true;
+	}
+
+	dummy->num_entries = num_entries;
+	dummy->base_time = gating_cfg->base_time;
+	dummy->cycle_time = gating_cfg->cycle_time;
+
+	list_for_each_entry(e, &gating_cfg->entries, list)
+		dummy->entries[i++].interval = e->interval;
+
+	if (port != -1) {
+		conflict = sja1105_tas_check_conflicts(priv, port, dummy);
+	} else {
+		for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+			conflict = sja1105_tas_check_conflicts(priv, port,
+							       dummy);
+			if (conflict)
+				break;
+		}
+	}
+
+	kfree(dummy);
+
+	return conflict;
+}
+
 int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 			    struct tc_taprio_qopt_offload *admin)
 {
@@ -473,6 +563,11 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 			return -ERANGE;
 	}
 
+	if (sja1105_gating_check_conflicts(priv, port, NULL)) {
+		dev_err(ds->dev, "Conflict with tc-gate schedule\n");
+		return -ERANGE;
+	}
+
 	tas_data->offload[port] = taprio_offload_get(admin);
 
 	rc = sja1105_init_scheduling(priv);
@@ -779,6 +874,8 @@ void sja1105_tas_setup(struct dsa_switch *ds)
 	INIT_WORK(&tas_data->tas_work, sja1105_tas_state_machine);
 	tas_data->state = SJA1105_TAS_STATE_DISABLED;
 	tas_data->last_op = SJA1105_PTP_NONE;
+
+	INIT_LIST_HEAD(&tas_data->gating_cfg.entries);
 }
 
 void sja1105_tas_teardown(struct dsa_switch *ds)
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.h b/drivers/net/dsa/sja1105/sja1105_tas.h
index b226c3dfd5b1..0c173ff51751 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.h
+++ b/drivers/net/dsa/sja1105/sja1105_tas.h
@@ -6,6 +6,10 @@
 
 #include <net/pkt_sched.h>
 
+#define SJA1105_TAS_MAX_DELTA		BIT(18)
+
+struct sja1105_private;
+
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_TAS)
 
 enum sja1105_tas_state {
@@ -20,8 +24,23 @@ enum sja1105_ptp_op {
 	SJA1105_PTP_ADJUSTFREQ,
 };
 
+struct sja1105_gate_entry {
+	struct list_head list;
+	struct sja1105_rule *rule;
+	s64 interval;
+	u8 gate_state;
+};
+
+struct sja1105_gating_config {
+	u64 cycle_time;
+	s64 base_time;
+	int num_entries;
+	struct list_head entries;
+};
+
 struct sja1105_tas_data {
 	struct tc_taprio_qopt_offload *offload[SJA1105_NUM_PORTS];
+	struct sja1105_gating_config gating_cfg;
 	enum sja1105_tas_state state;
 	enum sja1105_ptp_op last_op;
 	struct work_struct tas_work;
@@ -42,6 +61,11 @@ void sja1105_tas_clockstep(struct dsa_switch *ds);
 
 void sja1105_tas_adjfreq(struct dsa_switch *ds);
 
+bool sja1105_gating_check_conflicts(struct sja1105_private *priv, int port,
+				    struct netlink_ext_ack *extack);
+
+int sja1105_init_scheduling(struct sja1105_private *priv);
+
 #else
 
 /* C doesn't allow empty structures, bah! */
@@ -63,6 +87,18 @@ static inline void sja1105_tas_clockstep(struct dsa_switch *ds) { }
 
 static inline void sja1105_tas_adjfreq(struct dsa_switch *ds) { }
 
+static inline bool
+sja1105_gating_check_conflicts(struct dsa_switch *ds, int port,
+			       struct netlink_ext_ack *extack)
+{
+	return true;
+}
+
+static inline int sja1105_init_scheduling(struct sja1105_private *priv)
+{
+	return 0;
+}
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_TAS) */
 
 #endif /* _SJA1105_TAS_H */
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index c226779b8275..b52f1af6e7e7 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -1,9 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright 2020, NXP Semiconductors
  */
+#include <net/tc_act/tc_gate.h>
 #include <linux/dsa/8021q.h>
 #include "sja1105.h"
 
+#define SJA1105_VL_FRAME_MEMORY			100
+#define SJA1105_SIZE_VL_STATUS			8
+
 /* The switch flow classification core implements TTEthernet, which 'thinks' in
  * terms of Virtual Links (VL), a concept borrowed from ARINC 664 part 7.
  * However it also has one other operating mode (VLLUPFORMAT=0) where it acts
@@ -137,18 +141,33 @@ static bool sja1105_vl_key_lower(struct sja1105_vl_lookup_entry *a,
 static int sja1105_init_virtual_links(struct sja1105_private *priv,
 				      struct netlink_ext_ack *extack)
 {
+	struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
+	struct sja1105_vl_forwarding_params_entry *vl_fwd_params;
+	struct sja1105_vl_policing_entry *vl_policing;
+	struct sja1105_vl_forwarding_entry *vl_fwd;
 	struct sja1105_vl_lookup_entry *vl_lookup;
+	bool have_critical_virtual_links = false;
 	struct sja1105_table *table;
 	struct sja1105_rule *rule;
 	int num_virtual_links = 0;
+	int max_sharindx = 0;
 	int i, j, k;
 
+	table = &priv->static_config.tables[BLK_IDX_L2_FORWARDING_PARAMS];
+	l2_fwd_params = table->entries;
+	l2_fwd_params->part_spc[0] = SJA1105_MAX_FRAME_MEMORY;
+
 	/* Figure out the dimensioning of the problem */
 	list_for_each_entry(rule, &priv->flow_block.rules, list) {
 		if (rule->type != SJA1105_RULE_VL)
 			continue;
 		/* Each VL lookup entry matches on a single ingress port */
 		num_virtual_links += hweight_long(rule->port_mask);
+
+		if (rule->vl.type != SJA1105_VL_NONCRITICAL)
+			have_critical_virtual_links = true;
+		if (max_sharindx < rule->vl.sharindx)
+			max_sharindx = rule->vl.sharindx;
 	}
 
 	if (num_virtual_links > SJA1105_MAX_VL_LOOKUP_COUNT) {
@@ -156,6 +175,13 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 		return -ENOSPC;
 	}
 
+	if (max_sharindx + 1 > SJA1105_MAX_VL_LOOKUP_COUNT) {
+		NL_SET_ERR_MSG_MOD(extack, "Policer index out of range");
+		return -ENOSPC;
+	}
+
+	max_sharindx = max_t(int, num_virtual_links, max_sharindx) + 1;
+
 	/* Discard previous VL Lookup Table */
 	table = &priv->static_config.tables[BLK_IDX_VL_LOOKUP];
 	if (table->entry_count) {
@@ -163,6 +189,27 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 		table->entry_count = 0;
 	}
 
+	/* Discard previous VL Policing Table */
+	table = &priv->static_config.tables[BLK_IDX_VL_POLICING];
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	/* Discard previous VL Forwarding Table */
+	table = &priv->static_config.tables[BLK_IDX_VL_FORWARDING];
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	/* Discard previous VL Forwarding Parameters Table */
+	table = &priv->static_config.tables[BLK_IDX_VL_FORWARDING_PARAMS];
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
 	/* Nothing to do */
 	if (!num_virtual_links)
 		return 0;
@@ -208,6 +255,7 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 				vl_lookup[k].destports = rule->vl.destports;
 			else
 				vl_lookup[k].iscritical = true;
+			vl_lookup[k].flow_cookie = rule->cookie;
 			k++;
 		}
 	}
@@ -232,6 +280,68 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 		}
 	}
 
+	if (!have_critical_virtual_links)
+		return 0;
+
+	/* VL Policing Table */
+	table = &priv->static_config.tables[BLK_IDX_VL_POLICING];
+	table->entries = kcalloc(max_sharindx, table->ops->unpacked_entry_size,
+				 GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+	table->entry_count = max_sharindx;
+	vl_policing = table->entries;
+
+	/* VL Forwarding Table */
+	table = &priv->static_config.tables[BLK_IDX_VL_FORWARDING];
+	table->entries = kcalloc(max_sharindx, table->ops->unpacked_entry_size,
+				 GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+	table->entry_count = max_sharindx;
+	vl_fwd = table->entries;
+
+	/* VL Forwarding Parameters Table */
+	table = &priv->static_config.tables[BLK_IDX_VL_FORWARDING_PARAMS];
+	table->entries = kcalloc(1, table->ops->unpacked_entry_size,
+				 GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+	table->entry_count = 1;
+	vl_fwd_params = table->entries;
+
+	/* Reserve some frame buffer memory for the critical-traffic virtual
+	 * links (this needs to be done). At the moment, hardcode the value
+	 * at 100 blocks of 128 bytes of memory each. This leaves 829 blocks
+	 * remaining for best-effort traffic. TODO: figure out a more flexible
+	 * way to perform the frame buffer partitioning.
+	 */
+	l2_fwd_params->part_spc[0] = SJA1105_MAX_FRAME_MEMORY -
+				     SJA1105_VL_FRAME_MEMORY;
+	vl_fwd_params->partspc[0] = SJA1105_VL_FRAME_MEMORY;
+
+	for (i = 0; i < num_virtual_links; i++) {
+		unsigned long cookie = vl_lookup[i].flow_cookie;
+		struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
+
+		if (rule->vl.type == SJA1105_VL_NONCRITICAL)
+			continue;
+		if (rule->vl.type == SJA1105_VL_TIME_TRIGGERED) {
+			int sharindx = rule->vl.sharindx;
+
+			vl_policing[i].type = 1;
+			vl_policing[i].sharindx = sharindx;
+			vl_policing[i].maxlen = rule->vl.maxlen;
+			vl_policing[sharindx].type = 1;
+
+			vl_fwd[i].type = 1;
+			vl_fwd[sharindx].type = 1;
+			vl_fwd[sharindx].priority = rule->vl.ipv;
+			vl_fwd[sharindx].partition = 0;
+			vl_fwd[sharindx].destports = rule->vl.destports;
+		}
+	}
+
 	return 0;
 }
 
@@ -300,3 +410,387 @@ int sja1105_vl_delete(struct sja1105_private *priv, int port,
 
 	return sja1105_static_config_reload(priv, SJA1105_VIRTUAL_LINKS);
 }
+
+/* Insert into the global gate list, sorted by gate action time. */
+static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
+				     struct sja1105_rule *rule,
+				     u8 gate_state, s64 entry_time,
+				     struct netlink_ext_ack *extack)
+{
+	struct sja1105_gate_entry *e;
+	int rc;
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+
+	e->rule = rule;
+	e->gate_state = gate_state;
+	e->interval = entry_time;
+
+	if (list_empty(&gating_cfg->entries)) {
+		list_add(&e->list, &gating_cfg->entries);
+	} else {
+		struct sja1105_gate_entry *p;
+
+		list_for_each_entry(p, &gating_cfg->entries, list) {
+			if (p->interval == e->interval) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Gate conflict");
+				rc = -EBUSY;
+				goto err;
+			}
+
+			if (e->interval < p->interval)
+				break;
+		}
+		list_add(&e->list, p->list.prev);
+	}
+
+	gating_cfg->num_entries++;
+
+	return 0;
+err:
+	kfree(e);
+	return rc;
+}
+
+/* The gate entries contain absolute times in their e->interval field. Convert
+ * that to proper intervals (i.e. "0, 5, 10, 15" to "5, 5, 5, 5").
+ */
+static void
+sja1105_gating_cfg_time_to_interval(struct sja1105_gating_config *gating_cfg,
+				    u64 cycle_time)
+{
+	struct sja1105_gate_entry *last_e;
+	struct sja1105_gate_entry *e;
+	struct list_head *prev;
+	u32 prev_time = 0;
+
+	list_for_each_entry(e, &gating_cfg->entries, list) {
+		struct sja1105_gate_entry *p;
+
+		prev = e->list.prev;
+
+		if (prev == &gating_cfg->entries)
+			continue;
+
+		p = list_entry(prev, struct sja1105_gate_entry, list);
+		prev_time = e->interval;
+		p->interval = e->interval - p->interval;
+	}
+	last_e = list_last_entry(&gating_cfg->entries,
+				 struct sja1105_gate_entry, list);
+	if (last_e->list.prev != &gating_cfg->entries)
+		last_e->interval = cycle_time - last_e->interval;
+}
+
+static void sja1105_free_gating_config(struct sja1105_gating_config *gating_cfg)
+{
+	struct sja1105_gate_entry *e, *n;
+
+	list_for_each_entry_safe(e, n, &gating_cfg->entries, list) {
+		list_del(&e->list);
+		kfree(e);
+	}
+}
+
+static int sja1105_compose_gating_subschedule(struct sja1105_private *priv,
+					      struct netlink_ext_ack *extack)
+{
+	struct sja1105_gating_config *gating_cfg = &priv->tas_data.gating_cfg;
+	struct sja1105_rule *rule;
+	s64 max_cycle_time = 0;
+	s64 its_base_time = 0;
+	int i, rc = 0;
+
+	list_for_each_entry(rule, &priv->flow_block.rules, list) {
+		if (rule->type != SJA1105_RULE_VL)
+			continue;
+		if (rule->vl.type != SJA1105_VL_TIME_TRIGGERED)
+			continue;
+
+		if (max_cycle_time < rule->vl.cycle_time) {
+			max_cycle_time = rule->vl.cycle_time;
+			its_base_time = rule->vl.base_time;
+		}
+	}
+
+	if (!max_cycle_time)
+		return 0;
+
+	dev_dbg(priv->ds->dev, "max_cycle_time %lld its_base_time %lld\n",
+		max_cycle_time, its_base_time);
+
+	sja1105_free_gating_config(gating_cfg);
+
+	gating_cfg->base_time = its_base_time;
+	gating_cfg->cycle_time = max_cycle_time;
+	gating_cfg->num_entries = 0;
+
+	list_for_each_entry(rule, &priv->flow_block.rules, list) {
+		s64 time;
+		s64 rbt;
+
+		if (rule->type != SJA1105_RULE_VL)
+			continue;
+		if (rule->vl.type != SJA1105_VL_TIME_TRIGGERED)
+			continue;
+
+		/* Calculate the difference between this gating schedule's
+		 * base time, and the base time of the gating schedule with the
+		 * longest cycle time. We call it the relative base time (rbt).
+		 */
+		rbt = future_base_time(rule->vl.base_time, rule->vl.cycle_time,
+				       its_base_time);
+		rbt -= its_base_time;
+
+		time = rbt;
+
+		for (i = 0; i < rule->vl.num_entries; i++) {
+			u8 gate_state = rule->vl.entries[i].gate_state;
+			s64 entry_time = time;
+
+			while (entry_time < max_cycle_time) {
+				rc = sja1105_insert_gate_entry(gating_cfg, rule,
+							       gate_state,
+							       entry_time,
+							       extack);
+				if (rc)
+					goto err;
+
+				entry_time += rule->vl.cycle_time;
+			}
+			time += rule->vl.entries[i].interval;
+		}
+	}
+
+	sja1105_gating_cfg_time_to_interval(gating_cfg, max_cycle_time);
+
+	return 0;
+err:
+	sja1105_free_gating_config(gating_cfg);
+	return rc;
+}
+
+int sja1105_vl_gate(struct sja1105_private *priv, int port,
+		    struct netlink_ext_ack *extack, unsigned long cookie,
+		    struct sja1105_key *key, u32 index, s32 prio,
+		    u64 base_time, u64 cycle_time, u64 cycle_time_ext,
+		    u32 num_entries, struct action_gate_entry *entries)
+{
+	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
+	int ipv = -1;
+	int i, rc;
+	s32 rem;
+
+	if (cycle_time_ext) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cycle time extension not supported");
+		return -EOPNOTSUPP;
+	}
+
+	div_s64_rem(base_time, sja1105_delta_to_ns(1), &rem);
+	if (rem) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Base time must be multiple of 200 ns");
+		return -ERANGE;
+	}
+
+	div_s64_rem(cycle_time, sja1105_delta_to_ns(1), &rem);
+	if (rem) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cycle time must be multiple of 200 ns");
+		return -ERANGE;
+	}
+
+	if (dsa_port_is_vlan_filtering(dsa_to_port(priv->ds, port)) &&
+	    key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only gate based on {DMAC, VID, PCP}");
+		return -EOPNOTSUPP;
+	} else if (key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only gate based on DMAC");
+		return -EOPNOTSUPP;
+	}
+
+	if (!rule) {
+		rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+		if (!rule)
+			return -ENOMEM;
+
+		list_add(&rule->list, &priv->flow_block.rules);
+		rule->cookie = cookie;
+		rule->type = SJA1105_RULE_VL;
+		rule->key = *key;
+		rule->vl.type = SJA1105_VL_TIME_TRIGGERED;
+		rule->vl.sharindx = index;
+		rule->vl.base_time = base_time;
+		rule->vl.cycle_time = cycle_time;
+		rule->vl.num_entries = num_entries;
+		rule->vl.entries = kcalloc(num_entries,
+					   sizeof(struct action_gate_entry),
+					   GFP_KERNEL);
+		if (!rule->vl.entries) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		for (i = 0; i < num_entries; i++) {
+			div_s64_rem(entries[i].interval,
+				    sja1105_delta_to_ns(1), &rem);
+			if (rem) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Interval must be multiple of 200 ns");
+				rc = -ERANGE;
+				goto out;
+			}
+
+			if (!entries[i].interval) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Interval cannot be zero");
+				rc = -ERANGE;
+				goto out;
+			}
+
+			if (ns_to_sja1105_delta(entries[i].interval) >
+			    SJA1105_TAS_MAX_DELTA) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Maximum interval is 52 ms");
+				rc = -ERANGE;
+				goto out;
+			}
+
+			if (entries[i].maxoctets != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Cannot offload IntervalOctetMax");
+				rc = -EOPNOTSUPP;
+				goto out;
+			}
+
+			if (ipv == -1) {
+				ipv = entries[i].ipv;
+			} else if (ipv != entries[i].ipv) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Only support a single IPV per VL");
+				rc = -EOPNOTSUPP;
+				goto out;
+			}
+
+			rule->vl.entries[i] = entries[i];
+		}
+
+		if (ipv == -1) {
+			if (key->type == SJA1105_KEY_VLAN_AWARE_VL)
+				ipv = key->vl.pcp;
+			else
+				ipv = 0;
+		}
+
+		/* TODO: support per-flow MTU */
+		rule->vl.maxlen = VLAN_ETH_FRAME_LEN + ETH_FCS_LEN;
+		rule->vl.ipv = ipv;
+	}
+
+	rule->port_mask |= BIT(port);
+
+	rc = sja1105_compose_gating_subschedule(priv, extack);
+	if (rc)
+		goto out;
+
+	rc = sja1105_init_virtual_links(priv, extack);
+	if (rc)
+		goto out;
+
+	if (sja1105_gating_check_conflicts(priv, -1, extack)) {
+		NL_SET_ERR_MSG_MOD(extack, "Conflict with tc-taprio schedule");
+		rc = -ERANGE;
+		goto out;
+	}
+
+out:
+	if (rc) {
+		rule->port_mask &= ~BIT(port);
+		if (!rule->port_mask) {
+			list_del(&rule->list);
+			kfree(rule->vl.entries);
+			kfree(rule);
+		}
+	}
+
+	return rc;
+}
+
+static int sja1105_find_vlid(struct sja1105_private *priv, int port,
+			     struct sja1105_key *key)
+{
+	struct sja1105_vl_lookup_entry *vl_lookup;
+	struct sja1105_table *table;
+	int i;
+
+	if (WARN_ON(key->type != SJA1105_KEY_VLAN_AWARE_VL &&
+		    key->type != SJA1105_KEY_VLAN_UNAWARE_VL))
+		return -1;
+
+	table = &priv->static_config.tables[BLK_IDX_VL_LOOKUP];
+	vl_lookup = table->entries;
+
+	for (i = 0; i < table->entry_count; i++) {
+		if (key->type == SJA1105_KEY_VLAN_AWARE_VL) {
+			if (vl_lookup[i].port == port &&
+			    vl_lookup[i].macaddr == key->vl.dmac &&
+			    vl_lookup[i].vlanid == key->vl.vid &&
+			    vl_lookup[i].vlanprior == key->vl.pcp)
+				return i;
+		} else {
+			if (vl_lookup[i].port == port &&
+			    vl_lookup[i].macaddr == key->vl.dmac)
+				return i;
+		}
+	}
+
+	return -1;
+}
+
+int sja1105_vl_stats(struct sja1105_private *priv, int port,
+		     struct sja1105_rule *rule, struct flow_stats *stats,
+		     struct netlink_ext_ack *extack)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u8 buf[SJA1105_SIZE_VL_STATUS] = {0};
+	u64 unreleased;
+	u64 timingerr;
+	u64 lengtherr;
+	int vlid, rc;
+	u64 pkts;
+
+	if (rule->vl.type != SJA1105_VL_TIME_TRIGGERED)
+		return 0;
+
+	vlid = sja1105_find_vlid(priv, port, &rule->key);
+	if (vlid < 0)
+		return 0;
+
+	rc = sja1105_xfer_buf(priv, SPI_READ, regs->vl_status + 2 * vlid, buf,
+			      SJA1105_SIZE_VL_STATUS);
+	if (rc) {
+		NL_SET_ERR_MSG_MOD(extack, "SPI access failed");
+		return rc;
+	}
+
+	sja1105_unpack(buf, &timingerr,  31, 16, SJA1105_SIZE_VL_STATUS);
+	sja1105_unpack(buf, &unreleased, 15,  0, SJA1105_SIZE_VL_STATUS);
+	sja1105_unpack(buf, &lengtherr,  47, 32, SJA1105_SIZE_VL_STATUS);
+
+	pkts = timingerr + unreleased + lengtherr;
+
+	flow_stats_update(stats, 0, pkts - rule->vl.stats.pkts,
+			  jiffies - rule->vl.stats.lastused,
+			  FLOW_ACTION_HW_STATS_IMMEDIATE);
+
+	rule->vl.stats.pkts = pkts;
+	rule->vl.stats.lastused = jiffies;
+
+	return 0;
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.h b/drivers/net/dsa/sja1105/sja1105_vl.h
index 08ee5557b463..323fa0535af7 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.h
+++ b/drivers/net/dsa/sja1105/sja1105_vl.h
@@ -15,6 +15,16 @@ int sja1105_vl_delete(struct sja1105_private *priv, int port,
 		      struct sja1105_rule *rule,
 		      struct netlink_ext_ack *extack);
 
+int sja1105_vl_gate(struct sja1105_private *priv, int port,
+		    struct netlink_ext_ack *extack, unsigned long cookie,
+		    struct sja1105_key *key, u32 index, s32 prio,
+		    u64 base_time, u64 cycle_time, u64 cycle_time_ext,
+		    u32 num_entries, struct action_gate_entry *entries);
+
+int sja1105_vl_stats(struct sja1105_private *priv, int port,
+		     struct sja1105_rule *rule, struct flow_stats *stats,
+		     struct netlink_ext_ack *extack);
+
 #else
 
 static inline int sja1105_vl_redirect(struct sja1105_private *priv, int port,
@@ -36,6 +46,27 @@ static inline int sja1105_vl_delete(struct sja1105_private *priv,
 	return -EOPNOTSUPP;
 }
 
+static inline int sja1105_vl_gate(struct sja1105_private *priv, int port,
+				  struct netlink_ext_ack *extack,
+				  unsigned long cookie,
+				  struct sja1105_key *key, u32 index, s32 prio,
+				  u64 base_time, u64 cycle_time,
+				  u64 cycle_time_ext, u32 num_entries,
+				  struct action_gate_entry *entries)
+{
+	NL_SET_ERR_MSG_MOD(extack, "Virtual Links not compiled in");
+	return -EOPNOTSUPP;
+}
+
+static inline int sja1105_vl_stats(struct sja1105_private *priv, int port,
+				   struct sja1105_rule *rule,
+				   struct flow_stats *stats,
+				   struct netlink_ext_ack *extack)
+{
+	NL_SET_ERR_MSG_MOD(extack, "Virtual Links not compiled in");
+	return -EOPNOTSUPP;
+}
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_VL) */
 
 #endif /* _SJA1105_VL_H */
-- 
2.17.1

