Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD1634303E
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 00:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhCTXAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 19:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhCTW7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:59:50 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F62C061762
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:59:48 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l4so15316957ejc.10
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=41S/75ZBbiqBX6RwoO7CyOxzhDmC/IHHi5beUKC5sM0=;
        b=frRPtSF2JP9Y3cQCeXeHTmlUpT1+GgHrW8S1TycQQ2ftIIbBFXxX6JEhT3rmqXjGWX
         Lf6F/wYfGBKbpCJtttKpyH6VAE4UuS9ZLYi8JsPYwECedAuq+qkJK3M8HTnencnHqMTj
         2Xd4wBQk+KYsDUWuPZxuaEJorgDp007nQldlsC2P7MUrWT1/qx5+11v8vDPeAB99dBaK
         30GdkwN8779qVVXds9fYFWbFi1zYloUROivOjKmnrbV+Cslb2qFgA3CfOzbGEfqqNcVY
         ObFgKyInBbJhNJLEMEUIj92ZyVmZ+GrNKXVPUU13j7fwR6QialjOpS5Tt0QVEztlyICy
         5oGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=41S/75ZBbiqBX6RwoO7CyOxzhDmC/IHHi5beUKC5sM0=;
        b=avHl+qK4fwlx+kXiMVKbjhP8Sm2aTHX6i4+tx38593wF5e/9BIXQwguV/ZCh6O4Xe9
         p0YLs6lFkE63Wn/gVdx3KQoUPC9AEzbmHTpJFP/eAXauDJpIz8rel7+UtTHFMNRGkNLJ
         79LNOvNZI278DdQSk0tHiL3A+f+1M4pDOgp0deKBenUTLcALxvr9ZrGlQ740+01+14YV
         AQs9KUh8UXNqBa0Nt//je8c/gJXBmYHzUcArpYkeJqp3PfZQUYejh0uR2KknaWthAvPa
         l+kK7qjBnXzWCnwbKWRW8Y9LIp9FOAxMkUwOKZ1sFPom2w/+1cZaZTfxVmKiFTiilb8o
         qv4Q==
X-Gm-Message-State: AOAM533Q953G1a7M6pIhCoHDpkd2Jr37m9SVoF1Zobote/3Tw+BysNv3
        +waEG8jCp37o3vVxHIRQPXk=
X-Google-Smtp-Source: ABdhPJwuANHOLC8n22bd9XsvXo3b9GaFu/5QCk2T2kvgvgA6UeW2EhPpteZ0I6cDqUqAVQt1rYYT1A==
X-Received: by 2002:a17:906:d8d3:: with SMTP id re19mr11767729ejb.440.1616281187602;
        Sat, 20 Mar 2021 15:59:47 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a3sm6101517ejv.40.2021.03.20.15.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:59:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net 3/3] net: dsa: let drivers state that they need VLAN filtering while standalone
Date:   Sun, 21 Mar 2021 00:59:28 +0200
Message-Id: <20210320225928.2481575-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320225928.2481575-1-olteanv@gmail.com>
References: <20210320225928.2481575-1-olteanv@gmail.com>
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
index 64a73dd045c0..f0f8aad8b5f3 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1327,6 +1327,7 @@ static int hellcreek_setup(struct dsa_switch *ds)
 	 * filtering setups are not supported.
 	 */
 	ds->vlan_filtering_is_global = true;
+	ds->needs_standalone_vlan_filtering = true;
 
 	/* Intercept _all_ PTP multicast traffic */
 	ret = hellcreek_setup_fdb(hellcreek);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 57b2c49f72f4..d5167275d9fd 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -357,6 +357,9 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering_is_global;
 
+	/* Keep VLAN filtering enabled on unbridged ports. */
+	bool			needs_standalone_vlan_filtering;
+
 	/* Pass .port_vlan_add and .port_vlan_del to drivers even for bridges
 	 * that have vlan_filtering=0. All drivers should ideally set this (and
 	 * then the option would get removed), but it is unknown whether this
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6d06d13cdf3a..55f862050976 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1406,9 +1406,11 @@ static int dsa_slave_clear_vlan(struct net_device *vdev, int vid, void *arg)
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
@@ -1914,6 +1916,8 @@ int dsa_slave_create(struct dsa_port *port)
 
 	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
 	slave_dev->hw_features |= NETIF_F_HW_TC;
+	if (ds->needs_standalone_vlan_filtering)
+		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	slave_dev->features |= NETIF_F_LLTX;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
 	if (!IS_ERR_OR_NULL(port->mac))
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 32963276452f..8b3a2b846789 100644
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
 	 * vlan_filtering callback is only when the last port leaves the last
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

