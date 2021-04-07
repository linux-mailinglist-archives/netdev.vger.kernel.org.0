Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8993575B2
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356025AbhDGUP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356005AbhDGUPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 16:15:18 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323FAC061763
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 13:15:08 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id n2so23505211ejy.7
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 13:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GJGR2lOMPgsB29g63zztM9Xya0VPGAs0djUgnFKB4N0=;
        b=ayMplVA1UziszesDpM9qZMtGTrFqg/faZ5181wQcRSTZKSCp5Q4DWJR2t7mVhxw2bS
         V8jNz/gpEwvBinVW9WKXTLMGV+Y5qTHKeK1Roc1ms++AcHfqLabteJuRG8Ky6cDV2Rki
         Q880JyACqocdCuzh5kCgDx9k+IFNfMCRN5extw1TVhqFDKY5RT4s9OcSm9uSeand9UiC
         eDziHV7ll6R9g9aapnRLoGVmp/oubhFgiTxlLpbjaUtJ7Y7m1pQcUuLkD5N8Ce7uHV7r
         vubHLUpYNaC5+RUvqlOD9i6C9Ov6wozf2pfQkfkK0mSPvVJ7QDXrbMcGg245gOrIBfub
         hnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GJGR2lOMPgsB29g63zztM9Xya0VPGAs0djUgnFKB4N0=;
        b=FMlH/3iCNr4xQUV5h2fnHxsi/HuSkYqHUmk56YuqRa4WHFdfOLRZMayzjKpzJ7V9hD
         pePLq4j1Vp5nM0TRNE4IpD6ezJ2o9/5vP7vEIDSB72QpZ21TD2ZAoB5VTpq4vwWGEg0g
         ULSdwtyiUwsPojKTHzL9LKcME0I7jiw/LGV19rCBy03CDAZvO7QPjAtwrH4Nm5canmYX
         Y/mE65EXHtlARZhr9XqR28GEAOUaHZy2p2aKZzLIu3COmf3T9aCorGDVq7oV2NgXM1Bz
         SdGcVeag1LYlx49WvFga03qh7ifJa2AhntwkzEBg4UlvoP6RU2Sb/DSFmkHdzbR2BiTy
         +Jeg==
X-Gm-Message-State: AOAM532WKWQTTZmy7ruvuQ0snoZZOuBFulUaY6ZSqiEzGH/8cV0pgL6K
        D8OpaqnW0PKQmGJR6wBROD8=
X-Google-Smtp-Source: ABdhPJzyPU1T7dl3VSgev4qfUlE1WfUKCAY6dAwoJesyGGJj23VBgeZrCRNUPEQ4NslLxzewcu21HQ==
X-Received: by 2002:a17:906:32da:: with SMTP id k26mr5756199ejk.483.1617826506906;
        Wed, 07 Apr 2021 13:15:06 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r26sm4982892edc.43.2021.04.07.13.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 13:15:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 2/3] net: dsa: sja1105: use 4095 as the private VLAN for untagged traffic
Date:   Wed,  7 Apr 2021 23:14:51 +0300
Message-Id: <20210407201452.1703261-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210407201452.1703261-1-olteanv@gmail.com>
References: <20210407201452.1703261-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

One thing became visible when writing the blamed commit, and that was
that STP and PTP frames injected by net/dsa/tag_sja1105.c using the
deferred xmit mechanism are always classified to the pvid of the CPU
port, regardless of whatever VLAN there might be in these packets.

So a decision needed to be taken regarding the mechanism through which
we should ensure that delivery of STP and PTP traffic is possible when
we are in a VLAN awareness mode that involves tag_8021q. This is because
tag_8021q is not concerned with managing the pvid of the CPU port, since
as far as tag_8021q is concerned, no traffic should be sent as untagged
from the CPU port. So we end up not actually having a pvid on the CPU
port if we only listen to tag_8021q, and unless we do something about it.

The decision taken at the time was to keep VLAN 1 in the list of
priv->dsa_8021q_vlans, and make it a pvid of the CPU port. This ensures
that STP and PTP frames can always be sent to the outside world.

However there is a problem. If we do the following while we are in
the best_effort_vlan_filtering=true mode:

ip link add br0 type bridge vlan_filtering 1
ip link set swp2 master br0
bridge vlan del dev swp2 vid 1

Then untagged and pvid-tagged frames should be dropped. But we observe
that they aren't, and this is because of the precaution we took that VID
1 is always installed on all ports.

So clearly VLAN 1 is not good for this purpose. What about VLAN 0?
Well, VLAN 0 is managed by the 8021q module, and that module wants to
ensure that 802.1p tagged frames are always received by a port, and are
always transmitted as VLAN-tagged (with VLAN ID 0). Whereas we want our
STP and PTP frames to be untagged if the stack sent them as untagged -
we don't want the driver to just decide out of the blue that it adds
VID 0 to some packets.

So what to do?

Well, there is one other VLAN that is reserved, and that is 4095:
$ ip link add link swp2 name swp2.4095 type vlan id 4095
Error: 8021q: Invalid VLAN id.
$ bridge vlan add dev swp2 vid 4095
Error: bridge: Vlan id is invalid.

After we made this change, VLAN 1 is indeed forwarded and/or dropped
according to the bridge VLAN table, there are no further alterations
done by the sja1105 driver.

Fixes: ec5ae61076d0 ("net: dsa: sja1105: save/restore VLANs using a delta commit method")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 21 +++++++++------------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index f9e87fb33da0..6957cb853a70 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include "sja1105_static_config.h"
 
+#define SJA1105_DEFAULT_VLAN		(VLAN_N_VID - 1)
 #define SJA1105_NUM_PORTS		5
 #define SJA1105_NUM_TC			8
 #define SJA1105ET_FDB_BIN_SIZE		4
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8b380ccd95cf..61133098f588 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -321,6 +321,13 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 	return 0;
 }
 
+/* Set up a default VLAN for untagged traffic injected from the CPU
+ * using management routes (e.g. STP, PTP) as opposed to tag_8021q.
+ * All DT-defined ports are members of this VLAN, and there are no
+ * restrictions on forwarding (since the CPU selects the destination).
+ * Frames from this VLAN will always be transmitted as untagged, and
+ * neither the bridge nor the 8021q module cannot create this VLAN ID.
+ */
 static int sja1105_init_static_vlan(struct sja1105_private *priv)
 {
 	struct sja1105_table *table;
@@ -330,17 +337,13 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 		.vmemb_port = 0,
 		.vlan_bc = 0,
 		.tag_port = 0,
-		.vlanid = 1,
+		.vlanid = SJA1105_DEFAULT_VLAN,
 	};
 	struct dsa_switch *ds = priv->ds;
 	int port;
 
 	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
 
-	/* The static VLAN table will only contain the initial pvid of 1.
-	 * All other VLANs are to be configured through dynamic entries,
-	 * and kept in the static configuration table as backing memory.
-	 */
 	if (table->entry_count) {
 		kfree(table->entries);
 		table->entry_count = 0;
@@ -353,9 +356,6 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 
 	table->entry_count = 1;
 
-	/* VLAN 1: all DT-defined ports are members; no restrictions on
-	 * forwarding; always transmit as untagged.
-	 */
 	for (port = 0; port < ds->num_ports; port++) {
 		struct sja1105_bridge_vlan *v;
 
@@ -366,15 +366,12 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 		pvid.vlan_bc |= BIT(port);
 		pvid.tag_port &= ~BIT(port);
 
-		/* Let traffic that don't need dsa_8021q (e.g. STP, PTP) be
-		 * transmitted as untagged.
-		 */
 		v = kzalloc(sizeof(*v), GFP_KERNEL);
 		if (!v)
 			return -ENOMEM;
 
 		v->port = port;
-		v->vid = 1;
+		v->vid = SJA1105_DEFAULT_VLAN;
 		v->untagged = true;
 		if (dsa_is_cpu_port(ds, port))
 			v->pvid = true;
-- 
2.25.1

