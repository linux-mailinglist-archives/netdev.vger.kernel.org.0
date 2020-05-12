Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1E21CFBF8
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgELRUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730083AbgELRUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:20:48 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1673C061A0C;
        Tue, 12 May 2020 10:20:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id w7so16523487wre.13;
        Tue, 12 May 2020 10:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zs2KCCPbWFJ5KPRGeDvzehmmeOcMn4PR9pSIwaMke0k=;
        b=h9cfQdPvJ0LLYQFauKf4X958ixztZuWuen8Rc5FL9sDZMwl1g3AxCGqJ6WbdZWhaaj
         79eGadiOI4T9eFdubJ2dXF2RZQuuYGytPv2wdElRR2MUkdlZY+zZIXO9I1RCCAtmcH16
         F3SrE+e+fWxv0gU9lkfcl7SO8wvcGsUvKVG8AZLTh1tKW1EmNOJ63eJQxfrpfi0dzHM3
         gTIMxRaG1OUQFlWZ987yPh/T2GeDZ1Af38BXiZVjUVsvybeDedS8kPcGKy5Eh4x4sCxx
         bRt+yyZ3p8QdU+C54kv2cKWLEy5YN8czybCBNNA7TJ+/pDACvm1nM74uM7Bveqv8OmKK
         cxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zs2KCCPbWFJ5KPRGeDvzehmmeOcMn4PR9pSIwaMke0k=;
        b=Unc/7mXoduostcCxbuUtxvGBfRSTTvmAcSRytTOKbX+hpj6E5woEtK0qtYtzOFHFly
         TueWy7YLrww55Y6OJ9ZbjJfYWvbuDs07vs0lV1dlfGwGOL6+eEmn202JPDniEKOMrTEp
         D/IEWt5S7vjTeG9MV/opAkgXzpX0u7EGd1DkH9nvZdgRIRDfmee5FHrjgjCBc7ta8FRX
         u7XFKMNXZZ5ytBVLeraIRXBzu69Yt6TKFo2Bg7TZ4CP09lKRyBNe53iywj90j5mVUZ7a
         i11ZO3H35pivDgG4nV30CvRKsAV8E18PBDfsxJL3gYCjdnuWyiJ6gA85UFIbP2nHHdYY
         g6NA==
X-Gm-Message-State: AGi0PuaR5Npv+ZSopjNsGxtTL6Xe7OlCGdhSOLR46uX2RiEyQooufgtR
        8EirnvDE+fbJRhyLU2Ai9yXVf/wT
X-Google-Smtp-Source: APiQypIiYiOTbWrLpbhnbs5Fa64YShxgoZBImJMiLpdGNz6Y1ij60ZorlpMOsaITDIDjMrWFOxOwwg==
X-Received: by 2002:a5d:514b:: with SMTP id u11mr26694000wrt.53.1589304045151;
        Tue, 12 May 2020 10:20:45 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id a15sm23999743wrw.56.2020.05.12.10.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:20:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 01/15] net: dsa: provide an option for drivers to always receive bridge VLANs
Date:   Tue, 12 May 2020 20:20:25 +0300
Message-Id: <20200512172039.14136-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512172039.14136-1-olteanv@gmail.com>
References: <20200512172039.14136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

DSA assumes that a bridge which has vlan filtering disabled is not
vlan aware, and ignores all vlan configuration. However, the kernel
software bridge code allows configuration in this state.

This causes the kernel's idea of the bridge vlan state and the
hardware state to disagree, so "bridge vlan show" indicates a correct
configuration but the hardware lacks all configuration. Even worse,
enabling vlan filtering on a DSA bridge immediately blocks all traffic
which, given the output of "bridge vlan show", is very confusing.

Provide an option that drivers can set to indicate they want to receive
vlan configuration even when vlan filtering is disabled. At the very
least, this is safe for Marvell DSA bridges, which do not look up
ingress traffic in the VTU if the port is in 8021Q disabled state. It is
also safe for the Ocelot switch family. Whether this change is suitable
for all DSA bridges is not known.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
Rename again to configure_vlan_while_not_filtering, and add a helper
function for skipping VLAN configuration.

Changes in v2:
Rename variable from vlan_bridge_vtu to configure_vlans_while_disabled.

 include/net/dsa.h  |  7 +++++++
 net/dsa/dsa_priv.h |  1 +
 net/dsa/port.c     | 14 ++++++++++++++
 net/dsa/slave.c    |  8 ++++----
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 312c2f067e65..50389772c597 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -282,6 +282,13 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering_is_global;
 
+	/* Pass .port_vlan_add and .port_vlan_del to drivers even for bridges
+	 * that have vlan_filtering=0. All drivers should ideally set this (and
+	 * then the option would get removed), but it is unknown whether this
+	 * would break things or not.
+	 */
+	bool			configure_vlan_while_not_filtering;
+
 	/* In case vlan_filtering_is_global is set, the VLAN awareness state
 	 * should be retrieved from here and not from the per-port settings.
 	 */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a1a0ae242012..adecf73bd608 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -138,6 +138,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct switchdev_trans *trans);
+bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock,
 			 struct switchdev_trans *trans);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index ebc8d6cbd1d4..e23ece229c7e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -257,6 +257,20 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 	return 0;
 }
 
+/* This enforces legacy behavior for switch drivers which assume they can't
+ * receive VLAN configuration when enslaved to a bridge with vlan_filtering=0
+ */
+bool dsa_port_skip_vlan_configuration(struct dsa_port *dp)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (!dp->bridge_dev)
+		return false;
+
+	return (!ds->configure_vlan_while_not_filtering &&
+		!br_vlan_enabled(dp->bridge_dev));
+}
+
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock,
 			 struct switchdev_trans *trans)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 61b0de52040a..886490fb203d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -314,7 +314,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -381,7 +381,7 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
 	/* Do not deprogram the CPU port as it may be shared with other user
@@ -1240,7 +1240,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (!br_vlan_enabled(dp->bridge_dev))
+		if (dsa_port_skip_vlan_configuration(dp))
 			return 0;
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
@@ -1274,7 +1274,7 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (!br_vlan_enabled(dp->bridge_dev))
+		if (dsa_port_skip_vlan_configuration(dp))
 			return 0;
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-- 
2.17.1

