Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAA81DD92A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbgEUVLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730629AbgEUVLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:11:06 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56898C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:06 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id yc10so10496607ejb.12
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XfeIlbPMvfl48ZJdzb2qJI/UmnPjkgbWlWaOp9Lgfqw=;
        b=aADDdK9Zq8YEivkVtecVd8Y9yD3lVGG0KuVm5pHnKZOp+sVJgeen7kAPLz5SNkXDgo
         xFJ6nvDqbcCecDvBn5LKD0FDCk8wbH0aF2DT077EKisI4FEhlYUDGanVFKBLlF8WkNVt
         LBtLiMBnWEIvaGn4rJZlvAq1F16cqOxPrsj/M88X7+d9N3bHWHbUH/EYdEU6nDrDMz4l
         fLIbIIWxolwQ1gZG/cDNHpek+I5KT5TnRxyAAhtCazOw13TNmB407fH9gr/g0ECwAGlM
         pAdmzI7YoZtC1gmSzHmZtOvBnUtIwRMpuKIkTDEGOcQR7OkutNmQ1ysyIAO5yW8f4bC7
         hQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XfeIlbPMvfl48ZJdzb2qJI/UmnPjkgbWlWaOp9Lgfqw=;
        b=YZS6xYc5izf626AdGr8eRel0DUpXyTLePwQybqWGTVyx5joMyH07IH9j4WEfJWjSQq
         nvWUZSi38TtdUm231rl4G+VcNcu1P1r2G3DGoc0VrsfwjHLCFcCt2XnXp8swaWWk//IX
         tCWxCsVs8Md0bAc6Szuhwk31PUFwVPvOCXAbOZf8iAOyo9HjZBiWOf6392oMfKiNEp50
         oS+1Xa6OCXOZ8ciZF+aBihN/YBoQrdGLztu+I2zrravM7okK75N7a4cfscErTdzuNxgy
         fYXt6u92sW6Te6FAS/FmS2YLR1R7AQ5mmVbuHlh9xSdt8ro3jPlVFlQkDH6m/NMi2uzu
         cl/A==
X-Gm-Message-State: AOAM531b/V7F7bUuySMS626RpiRYwMq4yjUlMRhqhXUxoCgunF6RNSDW
        XNfFk9taOSHuZcBbsBXl/n0=
X-Google-Smtp-Source: ABdhPJzCRDkTx2q7yucZfiYL8/zNCHtT4usKaHLIaXgaUXQgEWF0OtQCZcQjwLW9k9wMYMz6P7kMsQ==
X-Received: by 2002:a17:906:70c2:: with SMTP id g2mr5215796ejk.207.1590095465033;
        Thu, 21 May 2020 14:11:05 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:11:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 11/13] net: dsa: deal with new flooding port attributes from bridge
Date:   Fri, 22 May 2020 00:10:34 +0300
Message-Id: <20200521211036.668624-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This refactors the DSA core handling of flooding attributes, since 3
more have been introduced (related to host flooding). In DSA, actually
host flooding is the same as egress flooding of the CPU port.

Note that there are some switches where flooding is a decision taken per
{source port, destination port}. In DSA, it is only per egress port. For
now, let's keep it that way, which means that we need to implement a
"flood count" for the CPU port (keep it in flooding while there is at
least one user port with the BR_HOST_FLOOD flag set).

With this patch, RX filtering can be done for switch ports operating in
standalone mode and in bridge mode with no foreign interfaces. When
bridging with other net devices in the system, all unknown destinations
are allowed to go to the CPU, where they continue to be forwarded in
software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |   8 ++++
 net/dsa/dsa_priv.h |   2 +-
 net/dsa/port.c     | 113 +++++++++++++++++++++++++++++++++------------
 3 files changed, 93 insertions(+), 30 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 7aa78884a5f2..c256467f1f4a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -198,6 +198,14 @@ struct dsa_port {
 	struct devlink_port	devlink_port;
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
+	/* Operational state of flooding */
+	int			uc_flood_count;
+	int			mc_flood_count;
+	bool			uc_flood;
+	bool			mc_flood;
+	/* Knobs from bridge */
+	unsigned long		br_flags;
+	bool			mrouter;
 
 	struct list_head list;
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 001668007efd..91cbaefc56b3 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -167,7 +167,7 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 			      struct switchdev_trans *trans);
-int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
+int dsa_port_bridge_flags(struct dsa_port *dp, unsigned long flags,
 			  struct switchdev_trans *trans);
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
 		     struct switchdev_trans *trans);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c4032f79225a..b527740d03a8 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -144,10 +144,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 	};
 	int err;
 
-	/* Set the flooding mode before joining the port in the switch */
-	err = dsa_port_bridge_flags(dp, BR_FLOOD | BR_MCAST_FLOOD, NULL);
-	if (err)
-		return err;
+	dp->cpu_dp->mrouter = br_multicast_router(br);
 
 	/* Here the interface is already bridged. Reflect the current
 	 * configuration so that drivers can program their chips accordingly.
@@ -156,12 +153,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN, &info);
 
-	/* The bridging is rolled back on error */
-	if (err) {
-		dsa_port_bridge_flags(dp, 0, NULL);
-		dp->bridge_dev = NULL;
-	}
-
 	return err;
 }
 
@@ -184,8 +175,12 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
 
-	/* Port is leaving the bridge, disable flooding */
-	dsa_port_bridge_flags(dp, 0, NULL);
+	dp->cpu_dp->mrouter = false;
+
+	/* Port is leaving the bridge, disable host flooding and enable
+	 * egress flooding
+	 */
+	dsa_port_bridge_flags(dp, BR_FLOOD | BR_MCAST_FLOOD, NULL);
 
 	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
 	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
@@ -289,48 +284,108 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock,
 	return dsa_port_notify(dp, DSA_NOTIFIER_AGEING_TIME, &info);
 }
 
+static int dsa_port_update_flooding(struct dsa_port *dp, int uc_flood_count,
+				    int mc_flood_count)
+{
+	struct dsa_switch *ds = dp->ds;
+	bool uc_flood_changed;
+	bool mc_flood_changed;
+	int port = dp->index;
+	bool uc_flood;
+	bool mc_flood;
+	int err;
+
+	if (!ds->ops->port_egress_floods)
+		return 0;
+
+	uc_flood = !!uc_flood_count;
+	mc_flood = dp->mrouter;
+
+	uc_flood_changed = dp->uc_flood ^ uc_flood;
+	mc_flood_changed = dp->mc_flood ^ mc_flood;
+
+	if (uc_flood_changed || mc_flood_changed) {
+		err = ds->ops->port_egress_floods(ds, port, uc_flood, mc_flood);
+		if (err)
+			return err;
+	}
+
+	dp->uc_flood_count = uc_flood_count;
+	dp->mc_flood_count = mc_flood_count;
+	dp->uc_flood = uc_flood;
+	dp->mc_flood = mc_flood;
+
+	return 0;
+}
+
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 			      struct switchdev_trans *trans)
 {
+	const unsigned long mask = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD |
+				   BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD |
+				   BR_HOST_BCAST_FLOOD;
 	struct dsa_switch *ds = dp->ds;
 
-	if (!ds->ops->port_egress_floods ||
-	    (flags & ~(BR_FLOOD | BR_MCAST_FLOOD)))
-		return -EINVAL;
+	if (!ds->ops->port_egress_floods || (flags & ~mask))
+		return -EOPNOTSUPP;
 
 	return 0;
 }
 
-int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
+int dsa_port_bridge_flags(struct dsa_port *dp, unsigned long flags,
 			  struct switchdev_trans *trans)
 {
-	struct dsa_switch *ds = dp->ds;
-	int port = dp->index;
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int cpu_uc_flood_count;
+	int cpu_mc_flood_count;
+	unsigned long changed;
+	int uc_flood_count;
+	int mc_flood_count;
 	int err = 0;
 
 	if (switchdev_trans_ph_prepare(trans))
 		return 0;
 
-	if (ds->ops->port_egress_floods)
-		err = ds->ops->port_egress_floods(ds, port, flags & BR_FLOOD,
-						  flags & BR_MCAST_FLOOD);
+	uc_flood_count = dp->uc_flood_count;
+	mc_flood_count = dp->mc_flood_count;
+	cpu_uc_flood_count = cpu_dp->uc_flood_count;
+	cpu_mc_flood_count = cpu_dp->mc_flood_count;
 
-	return err;
+	changed = dp->br_flags ^ flags;
+
+	if (changed & BR_FLOOD)
+		uc_flood_count += (flags & BR_FLOOD) ? 1 : -1;
+	if (changed & BR_MCAST_FLOOD)
+		mc_flood_count += (flags & BR_MCAST_FLOOD) ? 1 : -1;
+	if (changed & BR_HOST_FLOOD)
+		cpu_uc_flood_count += (flags & BR_HOST_FLOOD) ? 1 : -1;
+	if (changed & BR_HOST_MCAST_FLOOD)
+		cpu_mc_flood_count += (flags & BR_HOST_MCAST_FLOOD) ? 1 : -1;
+
+	err = dsa_port_update_flooding(dp, uc_flood_count, mc_flood_count);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = dsa_port_update_flooding(cpu_dp, cpu_uc_flood_count,
+				       cpu_mc_flood_count);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	dp->br_flags = flags;
+
+	return 0;
 }
 
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
 		     struct switchdev_trans *trans)
 {
-	struct dsa_switch *ds = dp->ds;
-	int port = dp->index;
-
-	if (!ds->ops->port_egress_floods)
-		return -EOPNOTSUPP;
-
 	if (switchdev_trans_ph_prepare(trans))
 		return 0;
 
-	return ds->ops->port_egress_floods(ds, port, true, mrouter);
+	dp->mrouter = mrouter;
+
+	return dsa_port_update_flooding(dp, dp->uc_flood_count,
+					dp->mc_flood_count);
 }
 
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
-- 
2.25.1

