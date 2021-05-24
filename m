Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9BB38E340
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhEXJ1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbhEXJ1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:27:08 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AF3C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:39 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y7so13596182eda.2
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kPM2Bmxiyg1VQQ11mVmf4X94gf6YVjwYR2FU4cIFRQk=;
        b=NkAYdO5/I4LgIpliRzgp1KWtB9mukcxewLTjJJ3RQNOB7so/U1qSqnd3OP3Fi0D+/T
         EGOWp7CFqLHPOp75JtOMeN8C4prnituSPf+9Vm5JgiSv3N6xQL4ryObIs23oIVLHvAnx
         LUJE/9SUP2z7TWoaBr83xzlm50G1YpAW9BPUmJjVUtH6kAELpgYpDefA7NzLEgNxk/Kl
         UF/MAHh60e8VlAoOaSSsqdhhnJ8/I/XGgx90q6cyoL8ky5GfQsTb6Iv4dLlfEA3LVmLW
         3VE9YdUjpLObHXxHPG/JaGbpHgSfHxbTx7Wt4pawsS5SZnspPVRgp1dXvWD+Ka/DfcD7
         S/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kPM2Bmxiyg1VQQ11mVmf4X94gf6YVjwYR2FU4cIFRQk=;
        b=nxJWHA59FijWTQP+z3tbcutHejkirCN8peRH02IAEC8es7vvgZrMd1DY4zEv93/J0d
         5xlWOHzZu+w+0scM6lPxlfaDUJ9hb7ZU8R4/lEU7pWQGTJg3OH5/otNzoXeBDC5qSY3a
         p5y+kyN20eM1tcVgUHT/85K8t7BPhrJ2reiKoPyzrJgTCYTDQO72zSNWQyGEo1M+ph2l
         dDaImpN2lE1+Z4BC9JAYV/h7XuWCvyMHuoSSTIHfrhQLOEXa7avggU5DpoOEOnyTRISy
         pxZBFXZ4Hi01Yb5vrv5BeYQCGnJ24s7fnjFQyYj6rb3Miema0H3aRhVg7hpxsj+aC63W
         Pi7A==
X-Gm-Message-State: AOAM533LsnJKoRmNuRkcZ1B2FeXLtmsRUhaf2JqHmq5phi2vKckHGizL
        RAW453c001XZyKby/yZ4H5g=
X-Google-Smtp-Source: ABdhPJzSHEseBlY56XvL6qwNhMRDxnvb+hgXBlgEym64d4XOWBDiIEuA3NDapZb2x+bDXwoepifudg==
X-Received: by 2002:aa7:d413:: with SMTP id z19mr24717307edq.37.1621848338190;
        Mon, 24 May 2021 02:25:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id yw9sm7553007ejb.91.2021.05.24.02.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 02:25:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 5/6] net: dsa: sja1105: use 4095 as the private VLAN for untagged traffic
Date:   Mon, 24 May 2021 12:25:26 +0300
Message-Id: <20210524092527.874479-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524092527.874479-1-olteanv@gmail.com>
References: <20210524092527.874479-1-olteanv@gmail.com>
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
 drivers/net/dsa/sja1105/sja1105_main.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 7f7e0424a442..dffa7dd83877 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -26,6 +26,7 @@
 #include "sja1105_tas.h"
 
 #define SJA1105_UNKNOWN_MULTICAST	0x010000000000ull
+#define SJA1105_DEFAULT_VLAN		(VLAN_N_VID - 1)
 
 static const struct dsa_switch_ops sja1105_switch_ops;
 
@@ -322,6 +323,13 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
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
@@ -331,17 +339,13 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
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
@@ -354,9 +358,6 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 
 	table->entry_count = 1;
 
-	/* VLAN 1: all DT-defined ports are members; no restrictions on
-	 * forwarding; always transmit as untagged.
-	 */
 	for (port = 0; port < ds->num_ports; port++) {
 		struct sja1105_bridge_vlan *v;
 
@@ -367,15 +368,12 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
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

