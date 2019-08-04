Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4573280CF4
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfHDWja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:39:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33957 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfHDWj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:39:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so5383028wmd.1
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 15:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HdwjQUD1T/VU6QmwwHke/DqeQdZdXqm8zo56NLHeqJM=;
        b=cn8H8TzL7R6BVgTligoHxABicdtPVQQ3r8/FAo0zPGHAKgDIiecsR+g2X28fwdSoN8
         RDqx6Z6kQ2QtqiEFuQKhGryxBn6t/QxHORIuLxhPxEpiTqjFFygQFMyVjAoaAC6FP5ss
         CT0pmfSQ4aWSn/WcVTYpF0EWzHEIZu/gdnUwzcKIhFUWgTLzM9sBMsu8NnuquVYiDGoj
         HJyuz8YZFFT5GvE73Wr1xxS4Gk6DBWBmGZEEOAkVLBNqkSGVvOR52JW8kxK+KlJ3dNEW
         7f3Gek1CRVz0K9sU04AtvopTajsN4ZoDje3nkHmxAkrbzai3xvZ2y9R+ust/MFUWzTCT
         5jwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HdwjQUD1T/VU6QmwwHke/DqeQdZdXqm8zo56NLHeqJM=;
        b=eJtyD8TwWWK8CBiNhjTnWnek+F+WT2XCDG0aGmtTezNEf8urJohHqZK+VLswb88NVS
         +dpIauFE8Ttx6X/d8unElvN8h5kxGBfN07fmMbDd4sHgCmyp4W4CqV/VBHPRwFQcTI5Z
         4yqrnvkxj7fOt6n+zrmh1+V5ObrcQIly1PvIhmTloyw8b+dKcqFxP4C1kdhm1/I8UOna
         sCy614axKHvT7Y8BGBlcwDMkKa9+0+iMu32kCCyP/7cBXkRTSOqDVy3jLc22xn/pngEt
         88j6Zpqk4mpKgHK5j5p9Pf3EKi8JYtZBZknESva/y/KCqVamNEetdCGojilJQ4RFq0ZJ
         JnSg==
X-Gm-Message-State: APjAAAVnePk7q5WdT7CaHySufEsPB3zmrTu5DUlbFBNEi9Hfcj+bxRC4
        eKfocliXRjkj89769T2H7HnTllSx/Rc=
X-Google-Smtp-Source: APXvYqytKfR7/cBbeKihs9uIFkoeUXTyZ2SlOPW9OkPb+DxXwBS237vCvblB8yDZ4WfB6PLElo3ByQ==
X-Received: by 2002:a1c:e90d:: with SMTP id q13mr15569818wmc.89.1564958363047;
        Sun, 04 Aug 2019 15:39:23 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id j33sm187795615wre.42.2019.08.04.15.39.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:39:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Georg Waibel <georg.waibel@sensor-technik.de>
Subject: [PATCH net 1/5] net: dsa: sja1105: Fix broken learning with vlan_filtering disabled
Date:   Mon,  5 Aug 2019 01:38:44 +0300
Message-Id: <20190804223848.31676-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190804223848.31676-1-olteanv@gmail.com>
References: <20190804223848.31676-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When put under a bridge with vlan_filtering 0, the SJA1105 ports will
flood all traffic as if learning was broken. This is because learning
interferes with the rx_vid's configured by dsa_8021q as unique pvid's.

So learning technically still *does* work, it's just that the learnt
entries never get matched due to their unique VLAN ID.

The setting that saves the day is Shared VLAN Learning, which on this
switch family works exactly as desired: VLAN tagging still works
(untagged traffic gets the correct pvid) and FDB entries are still
populated with the correct contents including VID. Also, a frame cannot
violate the forwarding domain restrictions enforced by its classified
VLAN. It is just that the VID is ignored when looking up the FDB for
taking a forwarding decision (selecting the egress port).

This patch activates SVL, and the result is that frames with a learnt
DMAC are no longer flooded in the scenario described above.

Now exactly *because* SVL works as desired, we have to revisit some
earlier patches:

- It is no longer necessary to manipulate the VID of the 'bridge fdb
  {add,del}' command when vlan_filtering is off. This is because now,
  SVL is enabled for that case, so the actual VID does not matter*.

- It is still desirable to hide dsa_8021q VID's in the FDB dump
  callback. But right now the dump callback should no longer hide
  duplicates (one per each front panel port's pvid, plus one for the
  VLAN that the CPU port is going to tag a TX frame with), because there
  shouldn't be any (the switch will match a single FDB entry no matter
  its VID anyway).

* Not really... It's no longer necessary to transform a 'bridge fdb add'
  into 5 fdb add operations, but the user might still add a fdb entry with
  any vid, and all of them would appear as duplicates in 'bridge fdb
  show'. So force a 'bridge fdb add' to insert the VID of 0**, so that we
  can prune the duplicates at insertion time.

** The VID of 0 is better than 1 because it is always guaranteed to be
   in the ports' hardware filter. DSA also avoids putting the VID inside
   the netlink response message towards the bridge driver when we return
   this particular VID, which makes it suitable for FDB entries learnt
   with vlan_filtering off.

Fixes: 227d07a07ef1 ("net: dsa: sja1105: Add support for traffic through standalone ports")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Georg Waibel <georg.waibel@sensor-technik.de>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 121 +++++++++++--------------
 1 file changed, 55 insertions(+), 66 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 32bf3a7cc3b6..dc6ab834f0cc 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -218,7 +218,7 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 		/* This selects between Independent VLAN Learning (IVL) and
 		 * Shared VLAN Learning (SVL)
 		 */
-		.shared_learn = false,
+		.shared_learn = true,
 		/* Don't discard management traffic based on ENFPORT -
 		 * we don't perform SMAC port enforcement anyway, so
 		 * what we are setting here doesn't matter.
@@ -1089,8 +1089,13 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	l2_lookup.mask_vlanid = VLAN_VID_MASK;
-	l2_lookup.mask_iotag = BIT(0);
+	if (dsa_port_is_vlan_filtering(&ds->ports[port])) {
+		l2_lookup.mask_vlanid = VLAN_VID_MASK;
+		l2_lookup.mask_iotag = BIT(0);
+	} else {
+		l2_lookup.mask_vlanid = 0;
+		l2_lookup.mask_iotag = 0;
+	}
 	l2_lookup.destports = BIT(port);
 
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
@@ -1147,8 +1152,13 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	l2_lookup.mask_vlanid = VLAN_VID_MASK;
-	l2_lookup.mask_iotag = BIT(0);
+	if (dsa_port_is_vlan_filtering(&ds->ports[port])) {
+		l2_lookup.mask_vlanid = VLAN_VID_MASK;
+		l2_lookup.mask_iotag = BIT(0);
+	} else {
+		l2_lookup.mask_vlanid = 0;
+		l2_lookup.mask_iotag = 0;
+	}
 	l2_lookup.destports = BIT(port);
 
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
@@ -1178,60 +1188,31 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid)
 {
 	struct sja1105_private *priv = ds->priv;
-	u16 rx_vid, tx_vid;
-	int rc, i;
 
-	if (dsa_port_is_vlan_filtering(&ds->ports[port]))
-		return priv->info->fdb_add_cmd(ds, port, addr, vid);
-
-	/* Since we make use of VLANs even when the bridge core doesn't tell us
-	 * to, translate these FDB entries into the correct dsa_8021q ones.
-	 * The basic idea (also repeats for removal below) is:
-	 * - Each of the other front-panel ports needs to be able to forward a
-	 *   pvid-tagged (aka tagged with their rx_vid) frame that matches this
-	 *   DMAC.
-	 * - The CPU port (aka the tx_vid of this port) needs to be able to
-	 *   send a frame matching this DMAC to the specified port.
-	 * For a better picture see net/dsa/tag_8021q.c.
+	/* dsa_8021q is in effect when the bridge's vlan_filtering isn't,
+	 * so the switch still does some VLAN processing internally.
+	 * But Shared VLAN Learning (SVL) is also active, and it will take
+	 * care of autonomous forwarding between the unique pvid's of each
+	 * port.  Here we just make sure that users can't add duplicate FDB
+	 * entries when in this mode - the actual VID doesn't matter except
+	 * for what gets printed in 'bridge fdb show'.  In the case of zero,
+	 * no VID gets printed at all.
 	 */
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-		if (i == port)
-			continue;
-		if (i == dsa_upstream_port(priv->ds, port))
-			continue;
+	if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
+		vid = 0;
 
-		rx_vid = dsa_8021q_rx_vid(ds, i);
-		rc = priv->info->fdb_add_cmd(ds, port, addr, rx_vid);
-		if (rc < 0)
-			return rc;
-	}
-	tx_vid = dsa_8021q_tx_vid(ds, port);
-	return priv->info->fdb_add_cmd(ds, port, addr, tx_vid);
+	return priv->info->fdb_add_cmd(ds, port, addr, vid);
 }
 
 static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid)
 {
 	struct sja1105_private *priv = ds->priv;
-	u16 rx_vid, tx_vid;
-	int rc, i;
 
-	if (dsa_port_is_vlan_filtering(&ds->ports[port]))
-		return priv->info->fdb_del_cmd(ds, port, addr, vid);
+	if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
+		vid = 0;
 
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-		if (i == port)
-			continue;
-		if (i == dsa_upstream_port(priv->ds, port))
-			continue;
-
-		rx_vid = dsa_8021q_rx_vid(ds, i);
-		rc = priv->info->fdb_del_cmd(ds, port, addr, rx_vid);
-		if (rc < 0)
-			return rc;
-	}
-	tx_vid = dsa_8021q_tx_vid(ds, port);
-	return priv->info->fdb_del_cmd(ds, port, addr, tx_vid);
+	return priv->info->fdb_del_cmd(ds, port, addr, vid);
 }
 
 static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
@@ -1285,24 +1266,9 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 			l2_lookup.lockeds = (match >= 0);
 		}
 
-		/* We need to hide the dsa_8021q VLANs from the user. This
-		 * basically means hiding the duplicates and only showing
-		 * the pvid that is supposed to be active in standalone and
-		 * non-vlan_filtering modes (aka 1).
-		 * - For statically added FDB entries (bridge fdb add), we
-		 *   can convert the TX VID (coming from the CPU port) into the
-		 *   pvid and ignore the RX VIDs of the other ports.
-		 * - For dynamically learned FDB entries, a single entry with
-		 *   no duplicates is learned - that which has the real port's
-		 *   pvid, aka RX VID.
-		 */
-		if (!dsa_port_is_vlan_filtering(&ds->ports[port])) {
-			if (l2_lookup.vlanid == tx_vid ||
-			    l2_lookup.vlanid == rx_vid)
-				l2_lookup.vlanid = 1;
-			else
-				continue;
-		}
+		/* We need to hide the dsa_8021q VLANs from the user. */
+		if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
+			l2_lookup.vlanid = 0;
 		cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
 	}
 	return 0;
@@ -1594,6 +1560,7 @@ static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
  */
 static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 {
+	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_table *table;
@@ -1622,6 +1589,28 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	general_params->incl_srcpt1 = enabled;
 	general_params->incl_srcpt0 = enabled;
 
+	/* VLAN filtering => independent VLAN learning.
+	 * No VLAN filtering => shared VLAN learning.
+	 *
+	 * In shared VLAN learning mode, untagged traffic still gets
+	 * pvid-tagged, and the FDB table gets populated with entries
+	 * containing the "real" (pvid or from VLAN tag) VLAN ID.
+	 * However the switch performs a masked L2 lookup in the FDB,
+	 * effectively only looking up a frame's DMAC (and not VID) for the
+	 * forwarding decision.
+	 *
+	 * This is extremely convenient for us, because in modes with
+	 * vlan_filtering=0, dsa_8021q actually installs unique pvid's into
+	 * each front panel port. This is good for identification but breaks
+	 * learning badly - the VID of the learnt FDB entry is unique, aka
+	 * no frames coming from any other port are going to have it. So
+	 * for forwarding purposes, this is as though learning was broken
+	 * (all frames get flooded).
+	 */
+	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
+	l2_lookup_params = table->entries;
+	l2_lookup_params->shared_learn = !enabled;
+
 	rc = sja1105_static_config_reload(priv);
 	if (rc)
 		dev_err(ds->dev, "Failed to change VLAN Ethertype\n");
-- 
2.17.1

