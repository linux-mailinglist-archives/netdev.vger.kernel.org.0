Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28750331CD9
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhCICRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbhCICRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 21:17:19 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89FEC06175F
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 18:17:18 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id c10so24412992ejx.9
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 18:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MwEUL3leO5vGNSGOykqxQ6pxQvePSNcDrkFy2vqfSik=;
        b=HpE3JQcIak2NGtZ54JMp0ET7lfDORbbV+6T5WU8Zv4y0YiHvKxuB6nTSu53W3RhzjA
         y0UJfexLD8hw2EBgEA5LHAilQpo8choFbsSvP2eSyHlLCblnKpw5P8CfGELF1rlOpzrl
         oDXkVk5rrWRhcDpci6tfuvqol9ci65n7XHDT/ua7CSop+87EmW3ok9WYw6h0Z61MQHER
         0lZ7QqxjzJalgcuCmMgxgisNBTqDi4m/FxVhHiqMJ6IqHnRlNY76otVnTmGFB1A08v7w
         GsemA1IPrANtltPRA3TSEfq8zGf8MSeoJWxhniQbo0VTaEeWTVFGy35SQw/jeXP+wlqW
         svrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MwEUL3leO5vGNSGOykqxQ6pxQvePSNcDrkFy2vqfSik=;
        b=Tnw0a/9Sl8AWNPpOfDOtpiOvJ8g0yR1+rSIX9Yw+0l1njhv+KItuQJzOEjtbYavQAH
         4li2X0cul23JwFvFzRHwZyZ5TkA0CHGiYFWt3KpQv9qgX4cdtoHnY+ZJgDhBUQhkAoEw
         bokdFWCBjb47XVUWi1gzPMFlYg/9w15FK4jF89CedEkJ3mc658LzBkvFhK7sBd5iscBf
         +pAZUI9wtvEPTqXGMK6/szNFAYdSMuewnmV57gIcaGfkMZHwKW/t/NxLrpBoTTvtW+y+
         6esRICqKe+aTGaS+eQCfY6e+LRnfIlc54PTuCLSMFddBgegXxmy2dtqV52Q7osRbIt5g
         uSGA==
X-Gm-Message-State: AOAM532jRoiJsYU5X6Kj+dQ5nwk1NR4jwe+wGqtcWCJBW0ZmzbBZ9PiT
        edYNe0ujXycDprX1/ivHOGSn3rpJNLQ=
X-Google-Smtp-Source: ABdhPJws/b9GemTV6ei1JmxuEtQXcba+PU87ROeHgvqXvQzGdvAdtcyMGeOui6KVYD+UsOTcpK1W/A==
X-Received: by 2002:a17:906:b884:: with SMTP id hb4mr17681721ejb.536.1615256237628;
        Mon, 08 Mar 2021 18:17:17 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id bj7sm4364902ejb.28.2021.03.08.18.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 18:17:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net 4/4] net: dsa: let drivers state that they need VLAN filtering while standalone
Date:   Tue,  9 Mar 2021 04:16:57 +0200
Message-Id: <20210309021657.3639745-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210309021657.3639745-1-olteanv@gmail.com>
References: <20210309021657.3639745-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As explained in the blamed patch, the hellcreek driver uses some tricks
to comply with the network stack expectations: it enforces port
separation in standalone mode using VLANs. For untagged traffic,
bridging between ports is prevented by using different PVIDs, and for
VLAN-tagged traffic, it never accepts 8021q uppers with the same VID on
two ports, so packets with one VLAN cannot leak from one port to another.

That is almost fine*, and has worked because hellcreek relied on an
implicit behavior of the DSA core that was changed by the previous
patch: the standalone ports declare the 'rx-vlan-filter' feature as 'on
[fixed]'. Since most of the DSA drivers are actually VLAN-unaware in
standalone mode, that feature was actually incorrectly reflecting the
hardware/driver state, so there was a desire to fix it. This leaves the
hellcreek driver in a situation where it has to explicitly request this
behavior from the DSA framework.

We configure the ports as follows:

- Standalone: 'rx-vlan-filter' is on. An 8021q upper on top of a
  standalone hellcreek port will go through dsa_slave_vlan_rx_add_vid
  and will add a VLAN to the hardware tables, giving the driver the
  opportunity to refuse it through .port_prechangeupper.

- Bridged with vlan_filtering=0: 'rx-vlan-filter' is off. An 8021q upper
  on top of a bridged hellcreek port will not go through
  dsa_slave_vlan_rx_add_vid, because there will not be any attempt to
  offload this VLAN. The driver already disables VLAN awareness, so that
  upper should receive the traffic it needs.

- Bridged with vlan_filtering=1: 'rx-vlan-filter' is on. An 8021q upper
  on top of a bridged hellcreek port will call dsa_slave_vlan_rx_add_vid,
  and can again be vetoed through .port_prechangeupper.

*It is not actually completely fine, because if I follow through
correctly, we can have the following situation:

ip link add br0 type bridge vlan_filtering 0
ip link set lan0 master br0 # lan0 now becomes VLAN-unaware
ip link set lan0 nomaster # lan0 fails to become VLAN-aware again, therefore breaking isolation

This patch fixes that by extending the DSA core logic, based on this
requested attribute, to change the VLAN awareness state of the switch
(port) when it leaves the bridge.

Fixes: e358bef7c392 ("net: dsa: Give drivers the chance to veto certain upper devices")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/hirschmann/hellcreek.c |  1 +
 include/net/dsa.h                      |  3 +++
 net/dsa/slave.c                        |  8 ++++++--
 net/dsa/switch.c                       | 20 +++++++++++++++-----
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 463137c39db2..b8112de24b3f 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1126,6 +1126,7 @@ static int hellcreek_setup(struct dsa_switch *ds)
 	 * filtering setups are not supported.
 	 */
 	ds->vlan_filtering_is_global = true;
+	ds->needs_standalone_vlan_filtering = true;
 
 	/* Intercept _all_ PTP multicast traffic */
 	ret = hellcreek_setup_fdb(hellcreek);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 83a933e563fe..58ce8089af9a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -355,6 +355,9 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering_is_global;
 
+	/* Keep VLAN filtering enabled on unbridged ports. */
+	bool			needs_standalone_vlan_filtering;
+
 	/* Pass .port_vlan_add and .port_vlan_del to drivers even for bridges
 	 * that have vlan_filtering=0. All drivers should ideally set this (and
 	 * then the option would get removed), but it is unknown whether this
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e5ca29df7605..c878fedb81d5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1395,9 +1395,11 @@ static int dsa_slave_clear_vlan(struct net_device *vdev, int vid, void *arg)
  *
  * - Standalone ports offload:
  *   - no VLAN (any 8021q upper is a software VLAN) if
- *     ds->vlan_filtering_is_global = false
+ *     ds->vlan_filtering_is_global = false and
+ *     ds->needs_standalone_vlan_filtering = false
  *   - the 8021q upper VLANs if ds->vlan_filtering_is_global = true and there
- *     are bridges spanning this switch chip which have vlan_filtering=1
+ *     are bridges spanning this switch chip which have vlan_filtering=1, or
+ *     ds->needs_standalone_vlan_filtering = true.
  *
  * - Ports under a vlan_filtering=0 bridge offload:
  *   - no VLAN if ds->configure_vlan_while_not_filtering = false (deprecated)
@@ -1903,6 +1905,8 @@ int dsa_slave_create(struct dsa_port *port)
 
 	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
 	slave_dev->hw_features |= NETIF_F_HW_TC;
+	if (ds->needs_standalone_vlan_filtering)
+		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	slave_dev->features |= NETIF_F_LLTX;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
 	if (!IS_ERR_OR_NULL(port->mac))
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 56ed31b0e636..9a02d24739e1 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -104,9 +104,10 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 				   struct dsa_notifier_bridge_info *info)
 {
-	bool unset_vlan_filtering = br_vlan_enabled(info->br);
 	struct dsa_switch_tree *dst = ds->dst;
 	struct netlink_ext_ack extack = {0};
+	bool change_vlan_filtering = false;
+	bool vlan_filtering;
 	int err, port;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
@@ -119,6 +120,15 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 						info->sw_index, info->port,
 						info->br);
 
+	if (ds->needs_standalone_vlan_filtering && !br_vlan_enabled(info->br)) {
+		change_vlan_filtering = true;
+		vlan_filtering = true;
+	} else if (!ds->needs_standalone_vlan_filtering &&
+		   br_vlan_enabled(info->br)) {
+		change_vlan_filtering = true;
+		vlan_filtering = false;
+	}
+
 	/* If the bridge was vlan_filtering, the bridge core doesn't trigger an
 	 * event for changing vlan_filtering setting upon slave ports leaving
 	 * it. That is a good thing, because that lets us handle it and also
@@ -127,21 +137,21 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	 * vlan_filtering callback is only when the last port the last
 	 * VLAN-aware bridge.
 	 */
-	if (unset_vlan_filtering && ds->vlan_filtering_is_global) {
+	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
 		for (port = 0; port < ds->num_ports; port++) {
 			struct net_device *bridge_dev;
 
 			bridge_dev = dsa_to_port(ds, port)->bridge_dev;
 
 			if (bridge_dev && br_vlan_enabled(bridge_dev)) {
-				unset_vlan_filtering = false;
+				change_vlan_filtering = false;
 				break;
 			}
 		}
 	}
-	if (unset_vlan_filtering) {
+	if (change_vlan_filtering) {
 		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
-					      false, &extack);
+					      vlan_filtering, &extack);
 		if (extack._msg)
 			dev_err(ds->dev, "port %d: %s\n", info->port,
 				extack._msg);
-- 
2.25.1

