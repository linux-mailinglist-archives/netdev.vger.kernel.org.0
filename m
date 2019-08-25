Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361699C59D
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 20:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbfHYSqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 14:46:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39192 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbfHYSqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 14:46:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so13208768wra.6
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 11:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QyhAEUKiKKQnXabtMKaxVuADOtRa4cfIrsKNU/6HgfY=;
        b=biVtuhQu5LOA9dS0PXHXda3mImWO4SOW/FD0yuMlF54VIobIAAadONq4uFjxh6UE9t
         9G2dQ84rur1vom3BqQidMok+U0HCDH1bRO8FEDSiKMUNcoHSYz2TYRAjOA0/NOnUxpXE
         jVX9Pi2J3HE/ecMwyYK3UWSw63J4AyXcFg/gI7UbtMqURbsBIL35EoMCb2WZhxYZBOut
         70gwIU/lD71HaC2HFGxu8QuZj6oO5EW5oRsT2RS39GyFGEMVRM/dRaF5P6W+6Jtfve1p
         rzNwRw+R5D+wUeL8rdWh+xS29XdhkoK3xaaButYERQUvvzffvrLsW29vQSzrDBWbWsY9
         6R3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QyhAEUKiKKQnXabtMKaxVuADOtRa4cfIrsKNU/6HgfY=;
        b=G+BrPR/exYK5ExZlMmQDO8OapVPqk77SEJWKJXWcZ4FE7etBauPP+uQFRJU9KrTZcF
         05P64uNo5UMt7kynahKpmgNs19gdhNPEy301i6fj05EhOhaZ0F0wQ5YhPgopcCDcvMMR
         oUd1YlrPd8MrMuUWXj+11dJe98DkECkYQdOSwPbfsVkiB7i2ZOo9QKEZ2cm5dbu6Aq+1
         ERJUkwfsXbcqubvlIRTX16cS3KYrOIW8a4y9cpamILUdKJDZsQUMrhXpH3D4yUsfGaPW
         sImVaICOFiEIF6C8gGdTz/csQ8BrL3o9l7UVBGjbOBXsKZ8d5GdS+NxXftnCP7bLI9qJ
         tdeA==
X-Gm-Message-State: APjAAAWiYpSw6HMDlFYR1EmCNLMNN78KKo59tfQxzQrEhKDCDH1T30Jd
        2Lre2iC7Q0cV3vPpyVhNGI8=
X-Google-Smtp-Source: APXvYqykK4yUnmkEReTrj8TsWg+yPpM7kjMbyB/XGHocP/qV9utGJ5NIe3M+EgS/at6KYSpepbd+Qg==
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr15947894wru.27.1566758764144;
        Sun, 25 Aug 2019 11:46:04 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id b136sm25603112wme.18.2019.08.25.11.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 11:46:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 2/2] net: dsa: tag_8021q: Restore bridge VLANs when enabling vlan_filtering
Date:   Sun, 25 Aug 2019 21:44:54 +0300
Message-Id: <20190825184454.14678-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190825184454.14678-1-olteanv@gmail.com>
References: <20190825184454.14678-1-olteanv@gmail.com>
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
 net/dsa/tag_8021q.c | 91 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 71 insertions(+), 20 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 67a1bc635a7b..81f943e365b9 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -93,6 +93,68 @@ int dsa_8021q_rx_source_port(u16 vid)
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
+	if (err < 0) {
+		dev_err(ds->dev, "Couldn't determine bridge PVID\n");
+		return err;
+	}
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
+	/* Nothing to restore from the bridge for a non-user port */
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
+	return dsa_port_vid_add(dp, vid, vinfo.flags);
+}
+
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
  * front-panel switch port (here swp0).
  *
@@ -148,8 +210,6 @@ EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 {
 	int upstream = dsa_upstream_port(ds, port);
-	struct dsa_port *dp = &ds->ports[port];
-	struct dsa_port *upstream_dp = &ds->ports[upstream];
 	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
 	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
 	int i, err;
@@ -166,7 +226,6 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 	 * restrictions, so there are no concerns about leaking traffic.
 	 */
 	for (i = 0; i < ds->num_ports; i++) {
-		struct dsa_port *other_dp = &ds->ports[i];
 		u16 flags;
 
 		if (i == upstream)
@@ -179,10 +238,7 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
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
@@ -193,10 +249,7 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
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
@@ -204,26 +257,24 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
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

