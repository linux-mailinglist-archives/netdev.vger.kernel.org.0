Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A5046B6BE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhLGJOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:14:18 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54035 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbhLGJOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:14:15 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id C9338E000F;
        Tue,  7 Dec 2021 09:10:42 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next v5 2/4] net: ocelot: add and export ocelot_ptp_rx_timestamp()
Date:   Tue,  7 Dec 2021 10:08:51 +0100
Message-Id: <20211207090853.308328-3-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211207090853.308328-1-clement.leger@bootlin.com>
References: <20211207090853.308328-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support PTP in FDMA, PTP handling code is needed. Since
this is the same as for register-based extraction, export it with
a new ocelot_ptp_rx_timestamp() function.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 41 +++++++++++++++++-------------
 include/soc/mscc/ocelot.h          |  2 ++
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b5ec8ce7f4dd..876a7ecf86eb 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1054,14 +1054,34 @@ static int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp, u32 *xfh)
 	return 0;
 }
 
-int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
+void ocelot_ptp_rx_timestamp(struct ocelot *ocelot, struct sk_buff *skb,
+			     u64 timestamp)
 {
 	struct skb_shared_hwtstamps *shhwtstamps;
 	u64 tod_in_ns, full_ts_in_ns;
+	struct timespec64 ts;
+
+	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
+
+	tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
+	if ((tod_in_ns & 0xffffffff) < timestamp)
+		full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
+				timestamp;
+	else
+		full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
+				timestamp;
+
+	shhwtstamps = skb_hwtstamps(skb);
+	memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
+	shhwtstamps->hwtstamp = full_ts_in_ns;
+}
+EXPORT_SYMBOL(ocelot_ptp_rx_timestamp);
+
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
+{
 	u64 timestamp, src_port, len;
 	u32 xfh[OCELOT_TAG_LEN / 4];
 	struct net_device *dev;
-	struct timespec64 ts;
 	struct sk_buff *skb;
 	int sz, buf_len;
 	u32 val, *buf;
@@ -1117,21 +1137,8 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 		*buf = val;
 	}
 
-	if (ocelot->ptp) {
-		ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
-
-		tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
-		if ((tod_in_ns & 0xffffffff) < timestamp)
-			full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
-					timestamp;
-		else
-			full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
-					timestamp;
-
-		shhwtstamps = skb_hwtstamps(skb);
-		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
-		shhwtstamps->hwtstamp = full_ts_in_ns;
-	}
+	if (ocelot->ptp)
+		ocelot_ptp_rx_timestamp(ocelot, skb, timestamp);
 
 	/* Everything we see on an interface that is in the HW bridge
 	 * has already been forwarded.
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9b99cfd39a59..f038062a97a9 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -797,6 +797,8 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 void ocelot_ifh_port_set(void *ifh, int port, u32 rew_op, u32 vlan_tag);
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
+void ocelot_ptp_rx_timestamp(struct ocelot *ocelot, struct sk_buff *skb,
+			     u64 timestamp);
 
 /* Hardware initialization */
 int ocelot_regfields_init(struct ocelot *ocelot,
-- 
2.34.1

