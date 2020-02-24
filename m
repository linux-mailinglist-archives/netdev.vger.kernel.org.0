Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89ACF16B2A7
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgBXVfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:35:12 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34162 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBXVfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:35:11 -0500
Received: by mail-wm1-f66.google.com with SMTP id s144so787632wme.1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lqi1XAA8kRKS66+35NFIW6yfCAd1jAfHIU3MuhFHj3A=;
        b=Ig0auK5RLD5muJBXfviYYCTTT/MicuWkIseyQsZHH7z5prQz6eWDPoknjI2vD53/mQ
         LvWOMItvTSKqtjgj03AKUqCUfwpjC2TOQZ2N9UosK7+RF9ZH9+FCdBpZwtE3qKL04Zs/
         KENBaCa0haUlbJESzIANSWilVSyJN4Yr5v3XyWcUY1hgC5+FwoQlwe8BNYi1XRgGBGc6
         sv2FNRESD4ZYoZc+6fALLpCdGCl5DqrL9kvSjNhD1WKo+MDJxF1CJ9ad2Ew5qpEAvG88
         8Huq1TxpKxhbyVGUDWNPAoTVUZwzai73mTQFfK2DOA59egtKhcWQwmo2/UVj+j46Ep2+
         Bszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lqi1XAA8kRKS66+35NFIW6yfCAd1jAfHIU3MuhFHj3A=;
        b=kEfCXwadA0mtMH2KnNSVRRCj0G6XQL32lBPYPAVtYaR7mb0Vpwwhw+S7gWBBrykON7
         YEjsE2YD4pNPbtgLuiWNJ+bJSsSe+Batz57S8Z3NWO9Wfd1/UcwLDttIEqmp6SxXZWer
         NNX50nfRfWhZXtAV8z71HfildsSJxXs3K4X1gVgfpmubZyyLB/lu9xva0kIrya8FcWPG
         hsjsJTGRxQJ8l6LkmvLKpECtpbctAivHlPltXv/wkJkEEc+qonZlC9uV652WmYgTQA+L
         XGMEiYqdKlD9uRrMrN8llXx/+9LRfirDwDV7PbD/hMDELKCh9B6thPe9VMqOmystdyX+
         STxQ==
X-Gm-Message-State: APjAAAVUHxKVikCKy4uikq1a2lds7sTp6nWMtpJbsgrS3zb/zukkTOJI
        9Aerw7FEAqSV1u9etqmt4Z8=
X-Google-Smtp-Source: APXvYqxStZnfJuuZIdUyjY930JYIYerOwAz/S/bX9vvBdUdrtJ10WYpUbSs8UTXXzVSLf1exqxeFDQ==
X-Received: by 2002:a7b:c216:: with SMTP id x22mr1012679wmi.51.1582580108422;
        Mon, 24 Feb 2020 13:35:08 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n3sm1001069wmc.27.2020.02.24.13.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:35:07 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 2/2] net: dsa: felix: Allow unknown unicast traffic towards the CPU port module
Date:   Mon, 24 Feb 2020 23:34:58 +0200
Message-Id: <20200224213458.32451-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224213458.32451-1-olteanv@gmail.com>
References: <20200224213458.32451-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Compared to other DSA switches, in the Ocelot cores, the RX filtering is
a much more important concern.

Firstly, the primary use case for Ocelot is non-DSA, so there isn't any
secondary Ethernet MAC [the DSA master's one] to implicitly drop frames
having a DMAC we are not interested in.  So the switch driver itself
needs to install FDB entries towards the CPU port module (PGID_CPU) for
the MAC address of each switch port, in each VLAN installed on the port.
Every address that is not whitelisted is implicitly dropped. This is in
order to achieve a behavior similar to N standalone net devices.

Secondly, even in the secondary use case of DSA, such as illustrated by
Felix with the NPI port mode, that secondary Ethernet MAC is present,
but its RX filter is bypassed. This is because the DSA tags themselves
are placed before Ethernet, so the DMAC that the switch ports see is
not seen by the DSA master too (since it's shifter to the right).

So RX filtering is pretty important. A good RX filter won't bother the
CPU in case the switch port receives a frame that it's not interested
in, and there exists no other line of defense.

Ocelot is pretty strict when it comes to RX filtering: non-IP multicast
and broadcast traffic is allowed to go to the CPU port module, but
unknown unicast isn't. This means that traffic reception for any other
MAC addresses than the ones configured on each switch port net device
won't work. This includes use cases such as macvlan or bridging with a
non-Ocelot (so-called "foreign") interface. But this seems to be fine
for the scenarios that the Linux system embedded inside an Ocelot switch
is intended for - it is simply not interested in unknown unicast
traffic, as explained in Allan Nielsen's presentation [0].

On the other hand, the Felix DSA switch is integrated in more
general-purpose Linux systems, so it can't afford to drop that sort of
traffic in hardware, even if it will end up doing so later, in software.

Actually, unknown unicast means more for Felix than it does for Ocelot.
Felix doesn't attempt to perform the whitelisting of switch port MAC
addresses towards PGID_CPU at all, mainly because it is too complicated
to be feasible: while the MAC addresses are unique in Ocelot, by default
in DSA all ports are equal and inherited from the DSA master. This adds
into account the question of reference counting MAC addresses (delayed
ocelot_mact_forget), not to mention reference counting for the VLAN IDs
that those MAC addresses are installed in. This reference counting
should be done in the DSA core, and the fact that it wasn't needed so
far is due to the fact that the other DSA switches don't have the DSA
tag placed before Ethernet, so the DSA master is able to whitelist the
MAC addresses in hardware.

So this means that even regular traffic termination on a Felix switch
port happens through flooding (because neither Felix nor Ocelot learn
source MAC addresses from CPU-injected frames).

So far we've explained that whitelisting towards PGID_CPU:
- helps to reduce the likelihood of spamming the CPU with frames it
  won't process very far anyway
- is implemented in the ocelot driver
- is sufficient for the ocelot use cases
- is not feasible in DSA
- breaks use cases in DSA, in the current status (whitelisting enabled
  but no MAC address whitelisted)

So the proposed patch allows unknown unicast frames to be sent to the
CPU port module. This is done for the Felix DSA driver only, as Ocelot
seems to be happy without it.

[0]: https://www.youtube.com/watch?v=B1HhxEcU7Jg

Suggested-by: Allan W. Nielsen <allan.nielsen@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     |  9 +++++
 drivers/net/ethernet/mscc/ocelot.h | 10 -----
 include/soc/mscc/ocelot.h          | 60 ++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 17f84c636c8f..5088d40e3cfb 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -517,6 +517,15 @@ static int felix_setup(struct dsa_switch *ds)
 					     OCELOT_TAG_PREFIX_LONG);
 	}
 
+	/* Include the CPU port module in the forwarding mask for unknown
+	 * unicast - the hardware default value for ANA_FLOODING_FLD_UNICAST
+	 * excludes BIT(ocelot->num_phys_ports), and so does ocelot_init, since
+	 * Ocelot relies on whitelisting MAC addresses towards PGID_CPU.
+	 */
+	ocelot_write_rix(ocelot,
+			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
+			 ANA_PGID_PGID, PGID_UC);
+
 	/* It looks like the MAC/PCS interrupt register - PM0_IEVENT (0x8040)
 	 * isn't instantiated for the Felix PF.
 	 * In-band AN may take a few ms to complete, so we need to poll.
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 04372ba72fec..e34ef8380eb3 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -28,16 +28,6 @@
 #include "ocelot_tc.h"
 #include "ocelot_ptp.h"
 
-#define PGID_AGGR    64
-#define PGID_SRC     80
-
-/* Reserved PGIDs */
-#define PGID_CPU     (PGID_AGGR - 5)
-#define PGID_UC      (PGID_AGGR - 4)
-#define PGID_MC      (PGID_AGGR - 3)
-#define PGID_MCIPV4  (PGID_AGGR - 2)
-#define PGID_MCIPV6  (PGID_AGGR - 1)
-
 #define OCELOT_BUFFER_CELL_SZ 60
 
 #define OCELOT_STATS_CHECK_DELAY (2 * HZ)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index abe912715b54..745d3f46ca60 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -11,6 +11,66 @@
 #include <linux/regmap.h>
 #include <net/dsa.h>
 
+/* Port Group IDs (PGID) are masks of destination ports.
+ *
+ * For L2 forwarding, the switch performs 3 lookups in the PGID table for each
+ * frame, and forwards the frame to the ports that are present in the logical
+ * AND of all 3 PGIDs.
+ *
+ * These PGID lookups are:
+ * - In one of PGID[0-63]: for the destination masks. There are 2 paths by
+ *   which the switch selects a destination PGID:
+ *     - The {DMAC, VID} is present in the MAC table. In that case, the
+ *       destination PGID is given by the DEST_IDX field of the MAC table entry
+ *       that matched.
+ *     - The {DMAC, VID} is not present in the MAC table (it is unknown). The
+ *       frame is disseminated as being either unicast, multicast or broadcast,
+ *       and according to that, the destination PGID is chosen as being the
+ *       value contained by ANA_FLOODING_FLD_UNICAST,
+ *       ANA_FLOODING_FLD_MULTICAST or ANA_FLOODING_FLD_BROADCAST.
+ *   The destination PGID can be an unicast set: the first PGIDs, 0 to
+ *   ocelot->num_phys_ports - 1, or a multicast set: the PGIDs from
+ *   ocelot->num_phys_ports to 63. By convention, a unicast PGID corresponds to
+ *   a physical port and has a single bit set in the destination ports mask:
+ *   that corresponding to the port number itself. In contrast, a multicast
+ *   PGID will have potentially more than one single bit set in the destination
+ *   ports mask.
+ * - In one of PGID[64-79]: for the aggregation mask. The switch classifier
+ *   dissects each frame and generates a 4-bit Link Aggregation Code which is
+ *   used for this second PGID table lookup. The goal of link aggregation is to
+ *   hash multiple flows within the same LAG on to different destination ports.
+ *   The first lookup will result in a PGID with all the LAG members present in
+ *   the destination ports mask, and the second lookup, by Link Aggregation
+ *   Code, will ensure that each flow gets forwarded only to a single port out
+ *   of that mask (there are no duplicates).
+ * - In one of PGID[80-90]: for the source mask. The third time, the PGID table
+ *   is indexed with the ingress port (plus 80). These PGIDs answer the
+ *   question "is port i allowed to forward traffic to port j?" If yes, then
+ *   BIT(j) of PGID 80+i will be found set. The third PGID lookup can be used
+ *   to enforce the L2 forwarding matrix imposed by e.g. a Linux bridge.
+ */
+
+/* Reserve some destination PGIDs at the end of the range:
+ * PGID_CPU: used for whitelisting certain MAC addresses, such as the addresses
+ *           of the switch port net devices, towards the CPU port module.
+ * PGID_UC: the flooding destinations for unknown unicast traffic.
+ * PGID_MC: the flooding destinations for broadcast and non-IP multicast
+ *          traffic.
+ * PGID_MCIPV4: the flooding destinations for IPv4 multicast traffic.
+ * PGID_MCIPV6: the flooding destinations for IPv6 multicast traffic.
+ */
+#define PGID_CPU			59
+#define PGID_UC				60
+#define PGID_MC				61
+#define PGID_MCIPV4			62
+#define PGID_MCIPV6			63
+
+/* Aggregation PGIDs, one per Link Aggregation Code */
+#define PGID_AGGR			64
+
+/* Source PGIDs, one per physical port */
+#define PGID_SRC			80
+
 #define IFH_INJ_BYPASS			BIT(31)
 #define IFH_INJ_POP_CNT_DISABLE		(3 << 28)
 
-- 
2.17.1

