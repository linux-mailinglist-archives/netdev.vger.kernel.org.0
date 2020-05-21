Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC681DD92B
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbgEUVLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730638AbgEUVLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:11:09 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB119C05BD43
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:08 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id f13so7112301edr.13
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gfAmpoAK+70saBDUCv/DNe6j3cbIVcrSOVCUJ8rFE8Q=;
        b=ezp1c2qEW36qM305ql5VYIgBb7KpnhPWc50s8Zon6CdLFkaR+0HXojW4c0bCAvuhwd
         vklx8PLEviyHAEQyTX+yVuqC0/eYcmez1UMfyW0wKc3wjM2X2Tz+Gru7RcIPoeFhAU4y
         RQnDWT+Tz5YBtDQ5Ajq1XxW0iBqyWYIXw3hgQiRkKhU7IozWGrcmjLnCitrmlg596/xu
         gYfmRDNfzZkmhvvFfSNDA2PG4XgOkugUr609HUT0HZsPe/pF7N3+nc5jOPVQzLW8OOn+
         bDHrT6S6blMIUXBQG3+tX7l/QMl/lsX3gKvwKdpxmQdOrxpet6L7KpjYG6Jg9ApsM4Ic
         WUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gfAmpoAK+70saBDUCv/DNe6j3cbIVcrSOVCUJ8rFE8Q=;
        b=ekaXiH0oc//XAnqI6t8+bAjy6QDHn7iqALbxAa0vBItb+t5ZiHj7YLm922am3Xbwh+
         QJRJi3csTIank8kzGevuSB+Hj8mAzfVrCueT+BZvcu+5ienU1NJI1JnPE1ZnalWHLFJF
         HA5ddaGonT257eQDpSYYVyk3Y05Sjs+Zx5o77gEVuOqJDfXwVtz0KSwWwgDCXvlP+eCp
         b0Y6tAuEhvnRqRtsdjd5yUIhocCMNMeUFwjBF2bXqdnURadsmkY6HTIEMhCwkqDCokwL
         00ZeVuiSYUrA2wcMJNLHTcrkpU1b2jIMCuVWFrxvOtM8Ip/Gkm4OAwVDc2M5M20jpuDC
         uytQ==
X-Gm-Message-State: AOAM5321dgotKegQ+WnulS0ApHRkFfNzV4hXXm79WpdgxRGSISsajgf3
        W7OF4tmzpCh0iOQEsf0bLok=
X-Google-Smtp-Source: ABdhPJw8TpUcklt+Bb4wHhMc3/uHgLT6slAFpzxxVjpRszHeKBOz/cK+DsasWi10/eqDPx56N248Fg==
X-Received: by 2002:aa7:d850:: with SMTP id f16mr515502eds.365.1590095467453;
        Thu, 21 May 2020 14:11:07 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:11:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 13/13] net: dsa: wire up multicast IGMP snooping attribute notification
Date:   Fri, 22 May 2020 00:10:36 +0300
Message-Id: <20200521211036.668624-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

The bridge can at runtime be configured with or without IGMP snooping
enabled but we were not processing the switchdev attribute that notifies
about that toggle, do this now.

Drivers that support frame parsing up to IGMP/MLD should enable trapping
of those frames towards the CPU, while pure L2 switches should trap the
entire range of 01:00:5E:00:00:01 to 01:00:5E:00:00:FF.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  3 +++
 net/dsa/dsa_priv.h | 13 +++++++++++++
 net/dsa/port.c     | 47 +++++++++++++++++++++++++++++++++++++++++++++-
 net/dsa/slave.c    |  3 +++
 net/dsa/switch.c   | 36 +++++++++++++++++++++++++++++++++++
 5 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index c256467f1f4a..3f7c1f56908c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -205,6 +205,7 @@ struct dsa_port {
 	bool			mc_flood;
 	/* Knobs from bridge */
 	unsigned long		br_flags;
+	bool			mc_disabled;
 	bool			mrouter;
 
 	struct list_head list;
@@ -564,6 +565,8 @@ struct dsa_switch_ops {
 			     const struct switchdev_obj_port_mdb *mdb);
 	int	(*port_mdb_del)(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_mdb *mdb);
+	int	(*port_igmp_mld_snoop)(struct dsa_switch *ds, int port,
+				       bool enable);
 	/*
 	 * RXNFC
 	 */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 91cbaefc56b3..0761f2fff994 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -24,6 +24,7 @@ enum {
 	DSA_NOTIFIER_VLAN_ADD,
 	DSA_NOTIFIER_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
+	DSA_NOTIFIER_MC_DISABLED,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -72,6 +73,14 @@ struct dsa_notifier_mtu_info {
 	int mtu;
 };
 
+/* DSA_NOTIFIER_MC_DISABLED */
+struct dsa_notifier_mc_disabled_info {
+	int tree_index;
+	int sw_index;
+	struct net_device *br;
+	bool mc_disabled;
+};
+
 struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
@@ -150,6 +159,10 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct switchdev_trans *trans);
+int dsa_port_multicast_toggle(struct dsa_switch *ds, int port,
+			      bool mc_disabled);
+int dsa_port_mc_disabled(struct dsa_port *dp, bool mc_disabled,
+			 struct switchdev_trans *trans);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock,
 			 struct switchdev_trans *trans);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index b527740d03a8..962f25ee8cf2 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -144,6 +144,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 	};
 	int err;
 
+	dp->cpu_dp->mc_disabled = !br_multicast_enabled(br);
 	dp->cpu_dp->mrouter = br_multicast_router(br);
 
 	/* Here the interface is already bridged. Reflect the current
@@ -175,6 +176,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
 
+	dp->cpu_dp->mc_disabled = true;
 	dp->cpu_dp->mrouter = false;
 
 	/* Port is leaving the bridge, disable host flooding and enable
@@ -299,7 +301,17 @@ static int dsa_port_update_flooding(struct dsa_port *dp, int uc_flood_count,
 		return 0;
 
 	uc_flood = !!uc_flood_count;
-	mc_flood = dp->mrouter;
+	/* As explained in commit 8ecd4591e761 ("mlxsw: spectrum: Add an option
+	 * to flood mc by mc_router_port"), the decision whether to flood a
+	 * multicast packet to a port depends on 3 flags: mc_disabled,
+	 * mc_router_port, mc_flood.
+	 * If mc_disabled is on, the port will be flooded according to
+	 * mc_flood, otherwise, according to mc_router_port.
+	 */
+	if (dp->mc_disabled)
+		mc_flood = !!mc_flood_count;
+	else
+		mc_flood = dp->mrouter;
 
 	uc_flood_changed = dp->uc_flood ^ uc_flood;
 	mc_flood_changed = dp->mc_flood ^ mc_flood;
@@ -388,6 +400,39 @@ int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
 					dp->mc_flood_count);
 }
 
+int dsa_port_multicast_toggle(struct dsa_switch *ds, int port, bool mc_disabled)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	int err;
+
+	if (ds->ops->port_igmp_mld_snoop) {
+		err = ds->ops->port_igmp_mld_snoop(ds, port, !mc_disabled);
+		if (err)
+			return err;
+	}
+
+	dp->mc_disabled = mc_disabled;
+
+	return dsa_port_update_flooding(dp, dp->uc_flood_count,
+					dp->mc_flood_count);
+}
+
+int dsa_port_mc_disabled(struct dsa_port *dp, bool mc_disabled,
+			 struct switchdev_trans *trans)
+{
+	struct dsa_notifier_mc_disabled_info info = {
+		.tree_index = dp->ds->dst->index,
+		.sw_index = dp->ds->index,
+		.br = dp->bridge_dev,
+		.mc_disabled = mc_disabled,
+	};
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	return dsa_broadcast(DSA_NOTIFIER_MC_DISABLED, &info);
+}
+
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool propagate_upstream)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c023f1120736..c0929613f1b4 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -475,6 +475,9 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 		/* The local bridge is a multicast router */
 		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter, trans);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
+		ret = dsa_port_mc_disabled(dp, attr->u.mc_disabled, trans);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 86c8dc5c32a0..9d4f8fd9cf10 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -337,6 +337,39 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
 	return 0;
 }
 
+static bool
+dsa_switch_mc_disabled_match(struct dsa_switch *ds, int port,
+			     struct dsa_notifier_mc_disabled_info *info)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_switch_tree *dst = ds->dst;
+
+	if (dp->bridge_dev == info->br)
+		return true;
+
+	if (dst->index == info->tree_index && ds->index == info->sw_index)
+		return dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port);
+
+	return false;
+}
+
+static int dsa_switch_mc_disabled(struct dsa_switch *ds,
+				  struct dsa_notifier_mc_disabled_info *info)
+{
+	bool mc_disabled = info->mc_disabled;
+	int port, err;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_mc_disabled_match(ds, port, info)) {
+			err = dsa_port_multicast_toggle(ds, port, mc_disabled);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
 static int dsa_switch_event(struct notifier_block *nb,
 			    unsigned long event, void *info)
 {
@@ -374,6 +407,9 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_MTU:
 		err = dsa_switch_mtu(ds, info);
 		break;
+	case DSA_NOTIFIER_MC_DISABLED:
+		err = dsa_switch_mc_disabled(ds, info);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.25.1

