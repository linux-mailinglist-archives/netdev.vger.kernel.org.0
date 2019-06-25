Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0109055C71
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfFYXkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33472 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfFYXkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so543712wru.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y15xIaPRN2i7lpYegf5nqDOBGzwuV3UKmJeMpFDow4U=;
        b=vB9IOjajLUslCJmlknpzVV1ugzTVJCiGijlo2uA2aXhPbL0DIdKwN8uZTwzh7NHpww
         q6AMPWh2zP20aa0/QPPmQhJnJy66Ki8IXlJOK7dWJP0aeD5zGi9kj2shNCVkpiPlH7zE
         ftMCX4/pkcQZ9pTvfnDAs50fUbDVmaYMNvkpfopHoHKvi+2ZcrQpe2MvDfQ0rDSesgol
         19kR3fc5+1aNSu8GpLKoV/BKHW8yEy5nldWspcbhZamOcdZ3ySnlaV/ABAMFhgBZZUV1
         bAG+fZ7tMyDXTTFCUUERtfccFb981oo54EQBC84BvZNPdvPVtjfAzmOvPpgBHHVASQsQ
         pBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y15xIaPRN2i7lpYegf5nqDOBGzwuV3UKmJeMpFDow4U=;
        b=UTPJvHiAlYlPcS6e/1COy0JH9rnC0fQtw9k59TtJf/hpSjAOJAWuVS9x8Mdt+EgGdc
         NgQ6rkm4EVYUDiDiwPioTVaB3T9bFbODDhvd7rNJ0lM/ehGXlHoL8+P0/cHD9RnwZykn
         B4Bykc06oRetVJL0z5jicaxITAfltZgbvMNXLgoWvGDvrSkeCxydtVLkRBQKbwxPeZWS
         ZlJIJYWrscGO9ntNtGcyBVksjHqT68WfNKYShQDumLOPYHATc2xoWL8RuJFcpWTLg9dX
         wQgS1SfaYhQuErzCmlP1723ZNS1vowhXm8Yj+L5+Aq2UpYDpFtySMkOgcsKsQghkI0q0
         hdnQ==
X-Gm-Message-State: APjAAAVaF+KevyFn7QKNS3q6VqCGiTCQq75lhx4Q0buCxj7DePT2ZaOS
        VCv8wpvDsAGyWY4HthbQXEQ=
X-Google-Smtp-Source: APXvYqzC2xenrETbT5HRrnFje0PTuG5Qov5lhULDp13UvOK1/UHh4vyH8V8KM9/MLITCs5g/yZAKkg==
X-Received: by 2002:a5d:4752:: with SMTP id o18mr493213wrs.74.1561506011929;
        Tue, 25 Jun 2019 16:40:11 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 09/10] net: dsa: sja1105: Use correct dsa_8021q VIDs for FDB commands
Date:   Wed, 26 Jun 2019 02:39:41 +0300
Message-Id: <20190625233942.1946-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A FDB entry means that "frames that match this VID and DMAC must be
forwarded to this port".

In the case of dsa_8021q however, the VID is not a single one (and
neither two, as my previous patch assumed). The VID can be set either by
the CPU port (1 tx_vid), or by any of the other front-panel port (n-1
rx_vid's).

Fixes: 93647594d8f5 ("net: dsa: sja1105: Hide the dsa_8021q VLANs from the bridge fdb command")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 82 ++++++++++++++++++--------
 1 file changed, 56 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ed0b721c794e..cadee7694935 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1126,44 +1126,60 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid)
 {
 	struct sja1105_private *priv = ds->priv;
-	int rc;
+	u16 rx_vid, tx_vid;
+	int rc, i;
+
+	if (dsa_port_is_vlan_filtering(&ds->ports[port]))
+		return priv->info->fdb_add_cmd(ds, port, addr, vid);
 
 	/* Since we make use of VLANs even when the bridge core doesn't tell us
 	 * to, translate these FDB entries into the correct dsa_8021q ones.
+	 * The basic idea (also repeats for removal below) is:
+	 * - Each of the other front-panel ports needs to be able to forward a
+	 *   pvid-tagged (aka tagged with their rx_vid) frame that matches this
+	 *   DMAC.
+	 * - The CPU port (aka the tx_vid of this port) needs to be able to
+	 *   send a frame matching this DMAC to the specified port.
+	 * For a better picture see net/dsa/tag_8021q.c.
 	 */
-	if (!dsa_port_is_vlan_filtering(&ds->ports[port])) {
-		unsigned int upstream = dsa_upstream_port(priv->ds, port);
-		u16 tx_vid = dsa_8021q_tx_vid(ds, port);
-		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+		if (i == port)
+			continue;
+		if (i == dsa_upstream_port(priv->ds, port))
+			continue;
 
-		rc = priv->info->fdb_add_cmd(ds, port, addr, tx_vid);
+		rx_vid = dsa_8021q_rx_vid(ds, i);
+		rc = priv->info->fdb_add_cmd(ds, port, addr, rx_vid);
 		if (rc < 0)
 			return rc;
-		return priv->info->fdb_add_cmd(ds, upstream, addr, rx_vid);
 	}
-	return priv->info->fdb_add_cmd(ds, port, addr, vid);
+	tx_vid = dsa_8021q_tx_vid(ds, port);
+	return priv->info->fdb_add_cmd(ds, port, addr, tx_vid);
 }
 
 static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid)
 {
 	struct sja1105_private *priv = ds->priv;
-	int rc;
+	u16 rx_vid, tx_vid;
+	int rc, i;
 
-	/* Since we make use of VLANs even when the bridge core doesn't tell us
-	 * to, translate these FDB entries into the correct dsa_8021q ones.
-	 */
-	if (!dsa_port_is_vlan_filtering(&ds->ports[port])) {
-		unsigned int upstream = dsa_upstream_port(priv->ds, port);
-		u16 tx_vid = dsa_8021q_tx_vid(ds, port);
-		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	if (dsa_port_is_vlan_filtering(&ds->ports[port]))
+		return priv->info->fdb_del_cmd(ds, port, addr, vid);
 
-		rc = priv->info->fdb_del_cmd(ds, port, addr, tx_vid);
+	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+		if (i == port)
+			continue;
+		if (i == dsa_upstream_port(priv->ds, port))
+			continue;
+
+		rx_vid = dsa_8021q_rx_vid(ds, i);
+		rc = priv->info->fdb_del_cmd(ds, port, addr, rx_vid);
 		if (rc < 0)
 			return rc;
-		return priv->info->fdb_del_cmd(ds, upstream, addr, rx_vid);
 	}
-	return priv->info->fdb_del_cmd(ds, port, addr, vid);
+	tx_vid = dsa_8021q_tx_vid(ds, port);
+	return priv->info->fdb_del_cmd(ds, port, addr, tx_vid);
 }
 
 static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
@@ -1171,8 +1187,12 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct device *dev = ds->dev;
+	u16 rx_vid, tx_vid;
 	int i;
 
+	rx_vid = dsa_8021q_rx_vid(ds, port);
+	tx_vid = dsa_8021q_tx_vid(ds, port);
+
 	for (i = 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
 		struct sja1105_l2_lookup_entry l2_lookup = {0};
 		u8 macaddr[ETH_ALEN];
@@ -1198,14 +1218,24 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 			continue;
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
-		/* We need to hide the dsa_8021q VLAN from the user.
-		 * Convert the TX VID into the pvid that is active in
-		 * standalone and non-vlan_filtering modes, aka 1.
-		 * The RX VID is applied on the CPU port, which is not seen by
-		 * the bridge core anyway, so there's nothing to hide.
+		/* We need to hide the dsa_8021q VLANs from the user. This
+		 * basically means hiding the duplicates and only showing
+		 * the pvid that is supposed to be active in standalone and
+		 * non-vlan_filtering modes (aka 1).
+		 * - For statically added FDB entries (bridge fdb add), we
+		 *   can convert the TX VID (coming from the CPU port) into the
+		 *   pvid and ignore the RX VIDs of the other ports.
+		 * - For dynamically learned FDB entries, a single entry with
+		 *   no duplicates is learned - that which has the real port's
+		 *   pvid, aka RX VID.
 		 */
-		if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
-			l2_lookup.vlanid = 1;
+		if (!dsa_port_is_vlan_filtering(&ds->ports[port])) {
+			if (l2_lookup.vlanid == tx_vid ||
+			    l2_lookup.vlanid == rx_vid)
+				l2_lookup.vlanid = 1;
+			else
+				continue;
+		}
 		cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
 	}
 	return 0;
-- 
2.17.1

