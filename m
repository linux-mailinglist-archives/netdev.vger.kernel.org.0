Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F06FA2BE7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfH3Axi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:53:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46393 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfH3Axh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:53:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id h7so3877045wrt.13
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ERj15wioKUQD5CM3OaVaGCasGTQT8/56tWM5U+vkYtk=;
        b=UVtyV/s/V3upBYxA4Hp+ml17k/GTHFpp2oFYhUhB0y2HneVakcvS0RrUjqImDXRBe/
         OYWRiXWAoIjhkJBuqVXzZ+lt3wewH9iUc1c6PEGI/sPYWN69+rtr/fTqE2V1C08T2Zk7
         Cwc1uu6dGsXlU6Sgvv3nm+HJnpVq7n4m4nOsVQVmg7kplvSe06NqXJFYOOlr/FNFyVEW
         iWTc5PVzoWtIQvp4v6vRm3ijW7cxQAwdPZWi538nA/YvtZK6aVbTpYVWB8flrf728GmI
         r+nM6eQrViymnBcOG721TDChmPQhT5A9lKpo2tR8tBBjabzM3XQubRQGdyvkpDPvpy8t
         Zj1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ERj15wioKUQD5CM3OaVaGCasGTQT8/56tWM5U+vkYtk=;
        b=rxAlcKsqI7ZfZ4862JUGhiLJD2kIfXLTD7E8IyJffBW0cw8NzQ/eKCEj2cMXBHn9+O
         yfBkH/1irkwu0UUd6c3mpv5Sqepwrw472UJBWWP6G94yPFe4eJ5VEGVve3xElNM94cYI
         vanAppBDDBLEy2skOYwjJaqJZUhX3rGmK18vMdj2HS279Iyqj9DBn8PtpcGGZGv8aV+Y
         MO1fawJE2MsuvQH5Wn1+wS8S7gzSmkNR+wyvF7SgFwEMUGXZ0LSdrzy0Np2Ge1gLKz45
         4TC/xLLERCIL0KaFiI24flGHTZmRFK3G6A6A/nZAECF+VJOjuQ441vyYbVgTjDryGOEL
         MgvA==
X-Gm-Message-State: APjAAAVmJNihCp2TvLUb+oWeTfjARl218DJatsz+G4hec6husXvf4P9o
        xbfnG5srfup+Lx+SWWtfJpo=
X-Google-Smtp-Source: APXvYqxNPe4RJgBlsCl1BMzkzrESsf+rimm+CGZju8Wh1mATGkK7f77HCq9NAklhGTZnDJQlAK0E9w==
X-Received: by 2002:a5d:66d0:: with SMTP id k16mr3433851wrw.333.1567126415090;
        Thu, 29 Aug 2019 17:53:35 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id w7sm4691669wrn.11.2019.08.29.17.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:53:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 2/2] net: dsa: tag_8021q: Restore bridge VLANs when enabling vlan_filtering
Date:   Fri, 30 Aug 2019 03:53:25 +0300
Message-Id: <20190830005325.26526-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830005325.26526-1-olteanv@gmail.com>
References: <20190830005325.26526-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge core assumes that enabling/disabling vlan_filtering will
translate into the simple toggling of a flag for switchdev drivers.

That is clearly not the case for sja1105, which alters the VLAN table
and the pvids in order to obtain port separation in standalone mode.

There are 2 parts to the issue.

First, tag_8021q changes the pvid to a unique per-port rx_vid for frame
identification. But we need to disable tag_8021q when vlan_filtering
kicks in, and at that point, the VLAN configured as pvid will have to be
removed from the filtering table of the ports. With an invalid pvid, the
ports will drop all traffic.  Since the bridge will not call any vlan
operation through switchdev after enabling vlan_filtering, we need to
ensure we're in a functional state ourselves. Hence read the pvid that
the bridge is aware of, and program that into our ports.

Secondly, tag_8021q uses the 1024-3071 range privately in
vlan_filtering=0 mode. Had the user installed one of these VLANs during
a previous vlan_filtering=1 session, then upon the next tag_8021q
cleanup for vlan_filtering to kick in again, VLANs in that range will
get deleted unconditionally, hence breaking user expectation. So when
deleting the VLANs, check if the bridge had knowledge about them, and if
it did, re-apply the settings. Wrap this logic inside a
dsa_8021q_vid_apply helper function to reduce code duplication.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes since v2:
- Don't error out in br_vlan_get_pvid
- Restore CPU port VID as well

 net/dsa/tag_8021q.c | 102 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 82 insertions(+), 20 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 67a1bc635a7b..9c1cc2482b68 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -93,6 +93,79 @@ int dsa_8021q_rx_source_port(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 
+static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
+{
+	struct bridge_vlan_info vinfo;
+	struct net_device *slave;
+	u16 pvid;
+	int err;
+
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
+	slave = ds->ports[port].slave;
+
+	err = br_vlan_get_pvid(slave, &pvid);
+	if (err < 0)
+		/* There is no pvid on the bridge for this port, which is
+		 * perfectly valid. Nothing to restore, bye-bye!
+		 */
+		return 0;
+
+	err = br_vlan_get_info(slave, pvid, &vinfo);
+	if (err < 0) {
+		dev_err(ds->dev, "Couldn't determine PVID attributes\n");
+		return err;
+	}
+
+	return dsa_port_vid_add(&ds->ports[port], pvid, vinfo.flags);
+}
+
+/* If @enabled is true, installs @vid with @flags into the switch port's HW
+ * filter.
+ * If @enabled is false, deletes @vid (ignores @flags) from the port. Had the
+ * user explicitly configured this @vid through the bridge core, then the @vid
+ * is installed again, but this time with the flags from the bridge layer.
+ */
+static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
+			       u16 flags, bool enabled)
+{
+	struct dsa_port *dp = &ds->ports[port];
+	struct bridge_vlan_info vinfo;
+	int err;
+
+	if (enabled)
+		return dsa_port_vid_add(dp, vid, flags);
+
+	err = dsa_port_vid_del(dp, vid);
+	if (err < 0)
+		return err;
+
+	/* Nothing to restore from the bridge for a non-user port.
+	 * The CPU port VLANs are restored implicitly with the user ports,
+	 * similar to how the bridge does in dsa_slave_vlan_add and
+	 * dsa_slave_vlan_del.
+	 */
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
+	err = br_vlan_get_info(dp->slave, vid, &vinfo);
+	/* Couldn't determine bridge attributes for this vid,
+	 * it means the bridge had not configured it.
+	 */
+	if (err < 0)
+		return 0;
+
+	/* Restore the VID from the bridge */
+	err = dsa_port_vid_add(dp, vid, vinfo.flags);
+	if (err < 0)
+		return err;
+
+	vinfo.flags &= ~BRIDGE_VLAN_INFO_PVID;
+
+	return dsa_port_vid_add(dp->cpu_dp, vid, vinfo.flags);
+}
+
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
  * front-panel switch port (here swp0).
  *
@@ -148,8 +221,6 @@ EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 {
 	int upstream = dsa_upstream_port(ds, port);
-	struct dsa_port *dp = &ds->ports[port];
-	struct dsa_port *upstream_dp = &ds->ports[upstream];
 	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
 	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
 	int i, err;
@@ -166,7 +237,6 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 	 * restrictions, so there are no concerns about leaking traffic.
 	 */
 	for (i = 0; i < ds->num_ports; i++) {
-		struct dsa_port *other_dp = &ds->ports[i];
 		u16 flags;
 
 		if (i == upstream)
@@ -179,10 +249,7 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 			/* The RX VID is a regular VLAN on all others */
 			flags = BRIDGE_VLAN_INFO_UNTAGGED;
 
-		if (enabled)
-			err = dsa_port_vid_add(other_dp, rx_vid, flags);
-		else
-			err = dsa_port_vid_del(other_dp, rx_vid);
+		err = dsa_8021q_vid_apply(ds, i, rx_vid, flags, enabled);
 		if (err) {
 			dev_err(ds->dev, "Failed to apply RX VID %d to port %d: %d\n",
 				rx_vid, port, err);
@@ -193,10 +260,7 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 	/* CPU port needs to see this port's RX VID
 	 * as tagged egress.
 	 */
-	if (enabled)
-		err = dsa_port_vid_add(upstream_dp, rx_vid, 0);
-	else
-		err = dsa_port_vid_del(upstream_dp, rx_vid);
+	err = dsa_8021q_vid_apply(ds, upstream, rx_vid, 0, enabled);
 	if (err) {
 		dev_err(ds->dev, "Failed to apply RX VID %d to port %d: %d\n",
 			rx_vid, port, err);
@@ -204,26 +268,24 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 	}
 
 	/* Finally apply the TX VID on this port and on the CPU port */
-	if (enabled)
-		err = dsa_port_vid_add(dp, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED);
-	else
-		err = dsa_port_vid_del(dp, tx_vid);
+	err = dsa_8021q_vid_apply(ds, port, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED,
+				  enabled);
 	if (err) {
 		dev_err(ds->dev, "Failed to apply TX VID %d on port %d: %d\n",
 			tx_vid, port, err);
 		return err;
 	}
-	if (enabled)
-		err = dsa_port_vid_add(upstream_dp, tx_vid, 0);
-	else
-		err = dsa_port_vid_del(upstream_dp, tx_vid);
+	err = dsa_8021q_vid_apply(ds, upstream, tx_vid, 0, enabled);
 	if (err) {
 		dev_err(ds->dev, "Failed to apply TX VID %d on port %d: %d\n",
 			tx_vid, upstream, err);
 		return err;
 	}
 
-	return 0;
+	if (!enabled)
+		err = dsa_8021q_restore_pvid(ds, port);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
 
-- 
2.17.1

