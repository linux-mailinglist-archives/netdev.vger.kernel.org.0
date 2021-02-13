Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A2831A8B0
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhBMAQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbhBMAPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:50 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78CFC06178C
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:35 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id p20so2040829ejb.6
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XeAaTfrWImMIRyQ4CVXzv5Dx/23GomV92kpaxWh3CTs=;
        b=rDVHvLrRlE6Kg/Bbm64kXSKFiBimi556gjyNGJjM70IK/cu8nRWSVuqekWv3fXgWCD
         QXKsxYp38s/jLGY4S/WLs8mJdn/yYAOjND24eTCl3bzWeY/hiaI0lfge6jipN5L5mlur
         JV7bpjYozpkdGZHeqQEMVLAlCE3ppEy58eZmjBMSx6Rge5AlMZVu0e1rjGqxgImGjv3k
         Xfe+FRe3BcZ3fnGAE8d+ZOoSNwLvcLBcdxuBz6dLJFXXhbD574iHWpEhyO9MvWbqUXEt
         EmyYyZa1yaNxa/yDsreHLqXmTBmqiX4kP3eLz0TwbiIH9Ro6AWZkKq3WnusyieFOYFkq
         RaLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XeAaTfrWImMIRyQ4CVXzv5Dx/23GomV92kpaxWh3CTs=;
        b=lzPb+4jUxrHhf3GKY3yy2nhjeJqZDkuA0lReDZeqH/QfItHFfxFX26h4pBDyJf25NV
         4pWhmTO24kEUkkcM22BTy+YvL6DdgbXdbFreKLmgOg3kAggMtEb6xy1zL6nli1AwLwAt
         0zojOM5TVSCDdKwUNmcQDvXXcNqf3oxtJABka8UQBp3DSoW50ftJuxNGWy4XmNSQ8zqH
         hQN6u760CKKwwtpzydJQVfNu2cwDh0f98aNWvHlt2VVP3+M2nuFklNy3NE24PoobD6NZ
         fLxOQFZsR71mvN9aU4cZLjSueN5br/uS8E+WE557MxCyZqd0RptwlRuJ/Y8/vFYxjt10
         iZWw==
X-Gm-Message-State: AOAM531WmCTQfIjNEaiw1bEcPOrMNKfc18B209RDTPKdCXSbe/85BzcZ
        /SEkgTVgiq0cNgylws7C+jg=
X-Google-Smtp-Source: ABdhPJx8JLftAM69/GXjOuVSzCX32hEY7Qyo7AHX3EgD8ArqmIyNFsqi59Irbcr2wZ19D+jmJNQeZA==
X-Received: by 2002:a17:906:7fc4:: with SMTP id r4mr4446495ejs.81.1613175274487;
        Fri, 12 Feb 2021 16:14:34 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:33 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 07/12] net: mscc: ocelot: use common tag parsing code with DSA
Date:   Sat, 13 Feb 2021 02:14:07 +0200
Message-Id: <20210213001412.4154051-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213001412.4154051-1-olteanv@gmail.com>
References: <20210213001412.4154051-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Injection Frame Header and Extraction Frame Header that the switch
prepends to frames over the NPI port is also prepended to frames
delivered over the CPU port module's queues.

Let's unify the handling of the frame headers by making the ocelot
driver call some helpers exported by the DSA tagger. Among other things,
this allows us to get rid of the strange cpu_to_be32 when transmitting
the Injection Frame Header on ocelot, since the packing API uses
network byte order natively (when "quirks" is 0).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c             |   6 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   2 +-
 drivers/net/ethernet/mscc/ocelot.c         |  38 +---
 drivers/net/ethernet/mscc/ocelot.h         |   9 -
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  54 ++----
 include/linux/dsa/ocelot.h                 | 208 +++++++++++++++++++++
 include/soc/mscc/ocelot.h                  |   7 -
 net/dsa/tag_ocelot.c                       | 147 +--------------
 9 files changed, 246 insertions(+), 227 deletions(-)
 create mode 100644 include/linux/dsa/ocelot.h

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 1ae94e392145..4af1187f4d69 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -14,8 +14,8 @@
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/dsa/8021q.h>
+#include <linux/dsa/ocelot.h>
 #include <linux/platform_device.h>
-#include <linux/packing.h>
 #include <linux/module.h>
 #include <linux/of_net.h>
 #include <linux/pci.h>
@@ -1171,9 +1171,9 @@ static int felix_hwtstamp_set(struct dsa_switch *ds, int port,
 static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 			   struct sk_buff *skb, unsigned int type)
 {
+	u8 *extraction = skb->data - ETH_HLEN - OCELOT_TAG_LEN;
 	struct skb_shared_hwtstamps *shhwtstamps;
 	struct ocelot *ocelot = ds->priv;
-	u8 *extraction = skb->data - ETH_HLEN - OCELOT_TAG_LEN;
 	u32 tstamp_lo, tstamp_hi;
 	struct timespec64 ts;
 	u64 tstamp, val;
@@ -1181,7 +1181,7 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
 	tstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
 
-	packing(extraction, &val,  116, 85, OCELOT_TAG_LEN, UNPACK, 0);
+	ocelot_xfh_get_rew_val(extraction, &val);
 	tstamp_lo = (u32)val;
 
 	tstamp_hi = tstamp >> 32;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index e944868cc120..cacc6f9c0113 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -8,7 +8,7 @@
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
-#include <linux/packing.h>
+#include <linux/dsa/ocelot.h>
 #include <linux/pcs-lynx.h>
 #include <net/pkt_sched.h>
 #include <linux/iopoll.h>
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 512f677a6c1c..d7348ea4831e 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -8,7 +8,7 @@
 #include <soc/mscc/ocelot.h>
 #include <linux/of_platform.h>
 #include <linux/pcs-lynx.h>
-#include <linux/packing.h>
+#include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
 #include "felix.h"
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7106d9ee534a..699b0c1c1780 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -4,6 +4,7 @@
  *
  * Copyright (c) 2017 Microsemi Corporation
  */
+#include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
@@ -628,26 +629,6 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 }
 EXPORT_SYMBOL(ocelot_get_txtstamp);
 
-/* Generate the IFH for frame injection
- *
- * The IFH is a 128bit-value
- * bit 127: bypass the analyzer processing
- * bit 56-67: destination mask
- * bit 28-29: pop_cnt: 3 disables all rewriting of the frame
- * bit 20-27: cpu extraction queue mask
- * bit 16: tag type 0: C-tag, 1: S-tag
- * bit 0-11: VID
- */
-static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
-{
-	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
-	ifh[1] = (0xf00 & info->port) >> 8;
-	ifh[2] = (0xff & info->port) << 24;
-	ifh[3] = (info->tag_type << 16) | info->vid;
-
-	return 0;
-}
-
 bool ocelot_can_inject(struct ocelot *ocelot, int grp)
 {
 	u32 val = ocelot_read(ocelot, QS_INJ_STATUS);
@@ -664,23 +645,20 @@ EXPORT_SYMBOL(ocelot_can_inject);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb)
 {
-	struct frame_info info = {};
-	u32 ifh[OCELOT_TAG_LEN / 4];
+	u32 ifh[OCELOT_TAG_LEN / 4] = {0};
 	unsigned int i, count, last;
 
 	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
 			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
 
-	info.port = BIT(port);
-	info.tag_type = IFH_TAG_TYPE_C;
-	info.vid = skb_vlan_tag_get(skb);
-	info.rew_op = rew_op;
-
-	ocelot_gen_ifh(ifh, &info);
+	ocelot_ifh_set_bypass(ifh, 1);
+	ocelot_ifh_set_dest(ifh, BIT(port));
+	ocelot_ifh_set_tag_type(ifh, IFH_TAG_TYPE_C);
+	ocelot_ifh_set_vid(ifh, skb_vlan_tag_get(skb));
+	ocelot_ifh_set_rew_op(ifh, rew_op);
 
 	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
-		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
-				 QS_INJ_WR, grp);
+		ocelot_write_rix(ocelot, ifh[i], QS_INJ_WR, grp);
 
 	count = DIV_ROUND_UP(skb->len, 4);
 	last = skb->len % 4;
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index c485795c606b..db6b1a4c3926 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -32,15 +32,6 @@
 
 #define OCELOT_PTP_QUEUE_SZ	128
 
-struct frame_info {
-	u32 len;
-	u16 port;
-	u16 vid;
-	u8 tag_type;
-	u16 rew_op;
-	u32 timestamp;	/* rew_val */
-};
-
 struct ocelot_port_tc {
 	bool block_shared;
 	unsigned long offload_cnt;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index b075dc13354a..fe0f8d6a32ce 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -4,6 +4,7 @@
  *
  * Copyright (c) 2017 Microsemi Corporation
  */
+#include <linux/dsa/ocelot.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of_net.h>
@@ -18,8 +19,6 @@
 #include <soc/mscc/ocelot_hsio.h>
 #include "ocelot.h"
 
-#define IFH_EXTRACT_BITFIELD64(x, o, w) (((x) >> (o)) & GENMASK_ULL((w) - 1, 0))
-
 static const u32 ocelot_ana_regmap[] = {
 	REG(ANA_ADVLEARN,				0x009000),
 	REG(ANA_VLANMASK,				0x009004),
@@ -532,29 +531,6 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	return 0;
 }
 
-static int ocelot_parse_ifh(u32 *_ifh, struct frame_info *info)
-{
-	u8 llen, wlen;
-	u64 ifh[2];
-
-	ifh[0] = be64_to_cpu(((__force __be64 *)_ifh)[0]);
-	ifh[1] = be64_to_cpu(((__force __be64 *)_ifh)[1]);
-
-	wlen = IFH_EXTRACT_BITFIELD64(ifh[0], 7,  8);
-	llen = IFH_EXTRACT_BITFIELD64(ifh[0], 15,  6);
-
-	info->len = OCELOT_BUFFER_CELL_SZ * wlen + llen - 80;
-
-	info->timestamp = IFH_EXTRACT_BITFIELD64(ifh[0], 21, 32);
-
-	info->port = IFH_EXTRACT_BITFIELD64(ifh[1], 43, 4);
-
-	info->tag_type = IFH_EXTRACT_BITFIELD64(ifh[1], 16,  1);
-	info->vid = IFH_EXTRACT_BITFIELD64(ifh[1], 0,  12);
-
-	return 0;
-}
-
 static int ocelot_rx_frame_word(struct ocelot *ocelot, u8 grp, bool ifh,
 				u32 *rval)
 {
@@ -609,20 +585,20 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
 		u64 tod_in_ns, full_ts_in_ns;
-		struct frame_info info = {};
+		u64 src_port, len, timestamp;
 		struct net_device *dev;
-		u32 ifh[4], val, *buf;
+		u32 xfh[4], val, *buf;
 		struct timespec64 ts;
-		int sz, len, buf_len;
 		struct sk_buff *skb;
+		int sz, buf_len;
 
 		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
-			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
+			err = ocelot_rx_frame_word(ocelot, grp, true, &xfh[i]);
 			if (err != 4)
 				goto out;
 		}
 
-		/* At this point the IFH was read correctly, so it is safe to
+		/* At this point the XFH was read correctly, so it is safe to
 		 * presume that there is no error. The err needs to be reset
 		 * otherwise a frame could come in CPU queue between the while
 		 * condition and the check for error later on. And in that case
@@ -630,21 +606,23 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		 */
 		err = 0;
 
-		ocelot_parse_ifh(ifh, &info);
+		ocelot_xfh_get_src_port(xfh, &src_port);
+		ocelot_xfh_get_len(xfh, &len);
+		ocelot_xfh_get_rew_val(xfh, &timestamp);
 
-		ocelot_port = ocelot->ports[info.port];
+		ocelot_port = ocelot->ports[src_port];
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
 		dev = priv->dev;
 
-		skb = netdev_alloc_skb(dev, info.len);
+		skb = netdev_alloc_skb(dev, len);
 
 		if (unlikely(!skb)) {
 			netdev_err(dev, "Unable to allocate sk_buff\n");
 			err = -ENOMEM;
 			goto out;
 		}
-		buf_len = info.len - ETH_FCS_LEN;
+		buf_len = len - ETH_FCS_LEN;
 		buf = (u32 *)skb_put(skb, buf_len);
 
 		len = 0;
@@ -677,12 +655,12 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 			ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
 
 			tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
-			if ((tod_in_ns & 0xffffffff) < info.timestamp)
+			if ((tod_in_ns & 0xffffffff) < timestamp)
 				full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
-						info.timestamp;
+						timestamp;
 			else
 				full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
-						info.timestamp;
+						timestamp;
 
 			shhwtstamps = skb_hwtstamps(skb);
 			memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
@@ -692,7 +670,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		/* Everything we see on an interface that is in the HW bridge
 		 * has already been forwarded.
 		 */
-		if (ocelot->bridge_mask & BIT(info.port))
+		if (ocelot->bridge_mask & BIT(src_port))
 			skb->offload_fwd_mark = 1;
 
 		skb->protocol = eth_type_trans(skb, dev);
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
new file mode 100644
index 000000000000..add2b38a2c76
--- /dev/null
+++ b/include/linux/dsa/ocelot.h
@@ -0,0 +1,208 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright 2019-2021 NXP Semiconductors
+ */
+
+#ifndef _NET_DSA_TAG_OCELOT_H
+#define _NET_DSA_TAG_OCELOT_H
+
+#include <linux/packing.h>
+
+#define OCELOT_TAG_LEN			16
+#define OCELOT_SHORT_PREFIX_LEN		4
+#define OCELOT_LONG_PREFIX_LEN		16
+#define OCELOT_TOTAL_TAG_LEN	(OCELOT_SHORT_PREFIX_LEN + OCELOT_TAG_LEN)
+
+/* The CPU injection header and the CPU extraction header can have 3 types of
+ * prefixes: long, short and no prefix. The format of the header itself is the
+ * same in all 3 cases.
+ *
+ * Extraction with long prefix:
+ *
+ * +-------------------+-------------------+------+------+------------+-------+
+ * | ff:ff:ff:ff:ff:ff | ff:ff:ff:ff:ff:fe | 8880 | 000a | extraction | frame |
+ * |                   |                   |      |      |   header   |       |
+ * +-------------------+-------------------+------+------+------------+-------+
+ *        48 bits             48 bits      16 bits 16 bits  128 bits
+ *
+ * Extraction with short prefix:
+ *
+ *                                         +------+------+------------+-------+
+ *                                         | 8880 | 000a | extraction | frame |
+ *                                         |      |      |   header   |       |
+ *                                         +------+------+------------+-------+
+ *                                         16 bits 16 bits  128 bits
+ *
+ * Extraction with no prefix:
+ *
+ *                                                       +------------+-------+
+ *                                                       | extraction | frame |
+ *                                                       |   header   |       |
+ *                                                       +------------+-------+
+ *                                                          128 bits
+ *
+ *
+ * Injection with long prefix:
+ *
+ * +-------------------+-------------------+------+------+------------+-------+
+ * |      any dmac     |      any smac     | 8880 | 000a | injection  | frame |
+ * |                   |                   |      |      |   header   |       |
+ * +-------------------+-------------------+------+------+------------+-------+
+ *        48 bits             48 bits      16 bits 16 bits  128 bits
+ *
+ * Injection with short prefix:
+ *
+ *                                         +------+------+------------+-------+
+ *                                         | 8880 | 000a | injection  | frame |
+ *                                         |      |      |   header   |       |
+ *                                         +------+------+------------+-------+
+ *                                         16 bits 16 bits  128 bits
+ *
+ * Injection with no prefix:
+ *
+ *                                                       +------------+-------+
+ *                                                       | injection  | frame |
+ *                                                       |   header   |       |
+ *                                                       +------------+-------+
+ *                                                          128 bits
+ *
+ * The injection header looks like this (network byte order, bit 127
+ * is part of lowest address byte in memory, bit 0 is part of highest
+ * address byte):
+ *
+ *         +------+------+------+------+------+------+------+------+
+ * 127:120 |BYPASS| MASQ |          MASQ_PORT        |REW_OP|REW_OP|
+ *         +------+------+------+------+------+------+------+------+
+ * 119:112 |                         REW_OP                        |
+ *         +------+------+------+------+------+------+------+------+
+ * 111:104 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ * 103: 96 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  95: 88 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  87: 80 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  79: 72 |                          RSV                          |
+ *         +------+------+------+------+------+------+------+------+
+ *  71: 64 |            RSV            |           DEST            |
+ *         +------+------+------+------+------+------+------+------+
+ *  63: 56 |                         DEST                          |
+ *         +------+------+------+------+------+------+------+------+
+ *  55: 48 |                          RSV                          |
+ *         +------+------+------+------+------+------+------+------+
+ *  47: 40 |  RSV |         SRC_PORT          |     RSV     |TFRM_TIMER|
+ *         +------+------+------+------+------+------+------+------+
+ *  39: 32 |     TFRM_TIMER     |               RSV                |
+ *         +------+------+------+------+------+------+------+------+
+ *  31: 24 |  RSV |  DP  |   POP_CNT   |           CPUQ            |
+ *         +------+------+------+------+------+------+------+------+
+ *  23: 16 |           CPUQ            |      QOS_CLASS     |TAG_TYPE|
+ *         +------+------+------+------+------+------+------+------+
+ *  15:  8 |         PCP        |  DEI |            VID            |
+ *         +------+------+------+------+------+------+------+------+
+ *   7:  0 |                          VID                          |
+ *         +------+------+------+------+------+------+------+------+
+ *
+ * And the extraction header looks like this:
+ *
+ *         +------+------+------+------+------+------+------+------+
+ * 127:120 |  RSV |                  REW_OP                        |
+ *         +------+------+------+------+------+------+------+------+
+ * 119:112 |       REW_OP       |              REW_VAL             |
+ *         +------+------+------+------+------+------+------+------+
+ * 111:104 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ * 103: 96 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  95: 88 |                         REW_VAL                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  87: 80 |       REW_VAL      |               LLEN               |
+ *         +------+------+------+------+------+------+------+------+
+ *  79: 72 | LLEN |                      WLEN                      |
+ *         +------+------+------+------+------+------+------+------+
+ *  71: 64 | WLEN |                      RSV                       |
+ *         +------+------+------+------+------+------+------+------+
+ *  63: 56 |                          RSV                          |
+ *         +------+------+------+------+------+------+------+------+
+ *  55: 48 |                          RSV                          |
+ *         +------+------+------+------+------+------+------+------+
+ *  47: 40 | RSV  |          SRC_PORT         |       ACL_ID       |
+ *         +------+------+------+------+------+------+------+------+
+ *  39: 32 |       ACL_ID       |  RSV |         SFLOW_ID          |
+ *         +------+------+------+------+------+------+------+------+
+ *  31: 24 |ACL_HIT| DP  |  LRN_FLAGS  |           CPUQ            |
+ *         +------+------+------+------+------+------+------+------+
+ *  23: 16 |           CPUQ            |      QOS_CLASS     |TAG_TYPE|
+ *         +------+------+------+------+------+------+------+------+
+ *  15:  8 |         PCP        |  DEI |            VID            |
+ *         +------+------+------+------+------+------+------+------+
+ *   7:  0 |                          VID                          |
+ *         +------+------+------+------+------+------+------+------+
+ */
+
+static inline void ocelot_xfh_get_rew_val(void *extraction, u64 *rew_val)
+{
+	packing(extraction, rew_val, 116, 85, OCELOT_TAG_LEN, UNPACK, 0);
+}
+
+static inline void ocelot_xfh_get_len(void *extraction, u64 *len)
+{
+	u64 llen, wlen;
+
+	packing(extraction, &llen, 84, 79, OCELOT_TAG_LEN, UNPACK, 0);
+	packing(extraction, &wlen, 78, 71, OCELOT_TAG_LEN, UNPACK, 0);
+
+	*len = 60 * wlen + llen - 80;
+}
+
+static inline void ocelot_xfh_get_src_port(void *extraction, u64 *src_port)
+{
+	packing(extraction, src_port, 46, 43, OCELOT_TAG_LEN, UNPACK, 0);
+}
+
+static inline void ocelot_xfh_get_qos_class(void *extraction, u64 *qos_class)
+{
+	packing(extraction, qos_class, 19, 17, OCELOT_TAG_LEN, UNPACK, 0);
+}
+
+static inline void ocelot_xfh_get_tag_type(void *extraction, u64 *tag_type)
+{
+	packing(extraction, tag_type, 16, 16, OCELOT_TAG_LEN, UNPACK, 0);
+}
+
+static inline void ocelot_xfh_get_vlan_tci(void *extraction, u64 *vlan_tci)
+{
+	packing(extraction, vlan_tci, 15, 0, OCELOT_TAG_LEN, UNPACK, 0);
+}
+
+static inline void ocelot_ifh_set_bypass(void *injection, u64 bypass)
+{
+	packing(injection, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
+}
+
+static inline void ocelot_ifh_set_rew_op(void *injection, u64 rew_op)
+{
+	packing(injection, &rew_op, 125, 117, OCELOT_TAG_LEN, PACK, 0);
+}
+
+static inline void ocelot_ifh_set_dest(void *injection, u64 dest)
+{
+	packing(injection, &dest, 67, 56, OCELOT_TAG_LEN, PACK, 0);
+}
+
+static inline void ocelot_ifh_set_qos_class(void *injection, u64 qos_class)
+{
+	packing(injection, &qos_class, 19, 17, OCELOT_TAG_LEN, PACK, 0);
+}
+
+static inline void ocelot_ifh_set_tag_type(void *injection, u64 tag_type)
+{
+	packing(injection, &tag_type, 16, 16, OCELOT_TAG_LEN, PACK, 0);
+}
+
+static inline void ocelot_ifh_set_vid(void *injection, u64 vid)
+{
+	packing(injection, &vid, 11, 0, OCELOT_TAG_LEN, PACK, 0);
+}
+
+#endif
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 656fd8bc818d..287c17a7e80f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -87,9 +87,6 @@
 /* Source PGIDs, one per physical port */
 #define PGID_SRC			80
 
-#define IFH_INJ_BYPASS			BIT(31)
-#define IFH_INJ_POP_CNT_DISABLE		(3 << 28)
-
 #define IFH_TAG_TYPE_C			0
 #define IFH_TAG_TYPE_S			1
 
@@ -100,10 +97,6 @@
 #define IFH_REW_OP_ORIGIN_PTP		0x5
 
 #define OCELOT_NUM_TC			8
-#define OCELOT_TAG_LEN			16
-#define OCELOT_SHORT_PREFIX_LEN		4
-#define OCELOT_LONG_PREFIX_LEN		16
-#define OCELOT_TOTAL_TAG_LEN	(OCELOT_SHORT_PREFIX_LEN + OCELOT_TAG_LEN)
 
 #define OCELOT_SPEED_2500		0
 #define OCELOT_SPEED_1000		1
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 225b145fd131..8ce0b26f3520 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -1,138 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright 2019 NXP Semiconductors
  */
+#include <linux/dsa/ocelot.h>
 #include <soc/mscc/ocelot.h>
-#include <linux/packing.h>
 #include "dsa_priv.h"
 
-/* The CPU injection header and the CPU extraction header can have 3 types of
- * prefixes: long, short and no prefix. The format of the header itself is the
- * same in all 3 cases.
- *
- * Extraction with long prefix:
- *
- * +-------------------+-------------------+------+------+------------+-------+
- * | ff:ff:ff:ff:ff:ff | ff:ff:ff:ff:ff:ff | 8880 | 000a | extraction | frame |
- * |                   |                   |      |      |   header   |       |
- * +-------------------+-------------------+------+------+------------+-------+
- *        48 bits             48 bits      16 bits 16 bits  128 bits
- *
- * Extraction with short prefix:
- *
- *                                         +------+------+------------+-------+
- *                                         | 8880 | 000a | extraction | frame |
- *                                         |      |      |   header   |       |
- *                                         +------+------+------------+-------+
- *                                         16 bits 16 bits  128 bits
- *
- * Extraction with no prefix:
- *
- *                                                       +------------+-------+
- *                                                       | extraction | frame |
- *                                                       |   header   |       |
- *                                                       +------------+-------+
- *                                                          128 bits
- *
- *
- * Injection with long prefix:
- *
- * +-------------------+-------------------+------+------+------------+-------+
- * |      any dmac     |      any smac     | 8880 | 000a | injection  | frame |
- * |                   |                   |      |      |   header   |       |
- * +-------------------+-------------------+------+------+------------+-------+
- *        48 bits             48 bits      16 bits 16 bits  128 bits
- *
- * Injection with short prefix:
- *
- *                                         +------+------+------------+-------+
- *                                         | 8880 | 000a | injection  | frame |
- *                                         |      |      |   header   |       |
- *                                         +------+------+------------+-------+
- *                                         16 bits 16 bits  128 bits
- *
- * Injection with no prefix:
- *
- *                                                       +------------+-------+
- *                                                       | injection  | frame |
- *                                                       |   header   |       |
- *                                                       +------------+-------+
- *                                                          128 bits
- *
- * The injection header looks like this (network byte order, bit 127
- * is part of lowest address byte in memory, bit 0 is part of highest
- * address byte):
- *
- *         +------+------+------+------+------+------+------+------+
- * 127:120 |BYPASS| MASQ |          MASQ_PORT        |REW_OP|REW_OP|
- *         +------+------+------+------+------+------+------+------+
- * 119:112 |                         REW_OP                        |
- *         +------+------+------+------+------+------+------+------+
- * 111:104 |                         REW_VAL                       |
- *         +------+------+------+------+------+------+------+------+
- * 103: 96 |                         REW_VAL                       |
- *         +------+------+------+------+------+------+------+------+
- *  95: 88 |                         REW_VAL                       |
- *         +------+------+------+------+------+------+------+------+
- *  87: 80 |                         REW_VAL                       |
- *         +------+------+------+------+------+------+------+------+
- *  79: 72 |                          RSV                          |
- *         +------+------+------+------+------+------+------+------+
- *  71: 64 |            RSV            |           DEST            |
- *         +------+------+------+------+------+------+------+------+
- *  63: 56 |                         DEST                          |
- *         +------+------+------+------+------+------+------+------+
- *  55: 48 |                          RSV                          |
- *         +------+------+------+------+------+------+------+------+
- *  47: 40 |  RSV |         SRC_PORT          |     RSV     |TFRM_TIMER|
- *         +------+------+------+------+------+------+------+------+
- *  39: 32 |     TFRM_TIMER     |               RSV                |
- *         +------+------+------+------+------+------+------+------+
- *  31: 24 |  RSV |  DP  |   POP_CNT   |           CPUQ            |
- *         +------+------+------+------+------+------+------+------+
- *  23: 16 |           CPUQ            |      QOS_CLASS     |TAG_TYPE|
- *         +------+------+------+------+------+------+------+------+
- *  15:  8 |         PCP        |  DEI |            VID            |
- *         +------+------+------+------+------+------+------+------+
- *   7:  0 |                          VID                          |
- *         +------+------+------+------+------+------+------+------+
- *
- * And the extraction header looks like this:
- *
- *         +------+------+------+------+------+------+------+------+
- * 127:120 |  RSV |                  REW_OP                        |
- *         +------+------+------+------+------+------+------+------+
- * 119:112 |       REW_OP       |              REW_VAL             |
- *         +------+------+------+------+------+------+------+------+
- * 111:104 |                         REW_VAL                       |
- *         +------+------+------+------+------+------+------+------+
- * 103: 96 |                         REW_VAL                       |
- *         +------+------+------+------+------+------+------+------+
- *  95: 88 |                         REW_VAL                       |
- *         +------+------+------+------+------+------+------+------+
- *  87: 80 |       REW_VAL      |               LLEN               |
- *         +------+------+------+------+------+------+------+------+
- *  79: 72 | LLEN |                      WLEN                      |
- *         +------+------+------+------+------+------+------+------+
- *  71: 64 | WLEN |                      RSV                       |
- *         +------+------+------+------+------+------+------+------+
- *  63: 56 |                          RSV                          |
- *         +------+------+------+------+------+------+------+------+
- *  55: 48 |                          RSV                          |
- *         +------+------+------+------+------+------+------+------+
- *  47: 40 | RSV  |          SRC_PORT         |       ACL_ID       |
- *         +------+------+------+------+------+------+------+------+
- *  39: 32 |       ACL_ID       |  RSV |         SFLOW_ID          |
- *         +------+------+------+------+------+------+------+------+
- *  31: 24 |ACL_HIT| DP  |  LRN_FLAGS  |           CPUQ            |
- *         +------+------+------+------+------+------+------+------+
- *  23: 16 |           CPUQ            |      QOS_CLASS     |TAG_TYPE|
- *         +------+------+------+------+------+------+------+------+
- *  15:  8 |         PCP        |  DEI |            VID            |
- *         +------+------+------+------+------+------+------+------+
- *   7:  0 |                          VID                          |
- *         +------+------+------+------+------+------+------+------+
- */
-
 static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
@@ -142,7 +14,6 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port;
 	u8 *prefix, *injection;
-	u64 qos_class, rew_op;
 
 	ocelot_port = ocelot->ports[dp->index];
 
@@ -155,19 +26,19 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	/* Fix up the fields which are not statically determined
 	 * in the template
 	 */
-	qos_class = skb->priority;
-	packing(injection, &qos_class, 19,  17, OCELOT_TAG_LEN, PACK, 0);
+	ocelot_ifh_set_qos_class(injection, skb->priority);
 
 	/* TX timestamping was requested */
 	if (clone) {
-		rew_op = ocelot_port->ptp_cmd;
+		u64 rew_op = ocelot_port->ptp_cmd;
+
 		/* Retrieve timestamp ID populated inside skb->cb[0] of the
 		 * clone by ocelot_port_add_txtstamp_skb
 		 */
 		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
 			rew_op |= clone->cb[0] << 3;
 
-		packing(injection, &rew_op, 125, 117, OCELOT_TAG_LEN, PACK, 0);
+		ocelot_ifh_set_rew_op(injection, rew_op);
 	}
 
 	return skb;
@@ -208,10 +79,10 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	/* Remove from inet csum the extraction header */
 	skb_postpull_rcsum(skb, start, OCELOT_TOTAL_TAG_LEN);
 
-	packing(extraction, &src_port,  46, 43, OCELOT_TAG_LEN, UNPACK, 0);
-	packing(extraction, &qos_class, 19, 17, OCELOT_TAG_LEN, UNPACK, 0);
-	packing(extraction, &tag_type,  16, 16, OCELOT_TAG_LEN, UNPACK, 0);
-	packing(extraction, &vlan_tci,  15,  0, OCELOT_TAG_LEN, UNPACK, 0);
+	ocelot_xfh_get_src_port(extraction, &src_port);
+	ocelot_xfh_get_qos_class(extraction, &qos_class);
+	ocelot_xfh_get_tag_type(extraction, &tag_type);
+	ocelot_xfh_get_vlan_tci(extraction, &vlan_tci);
 
 	skb->dev = dsa_master_find_slave(netdev, 0, src_port);
 	if (!skb->dev)
-- 
2.25.1

