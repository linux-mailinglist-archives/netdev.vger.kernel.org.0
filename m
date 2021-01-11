Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81B52F1CD2
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389495AbhAKRoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732509AbhAKRoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:44:15 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4E5C06179F
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:35 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id h16so615925edt.7
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4WcGm54Bk3QjfqstG3OQWRPvhT95GSMT/k5joOPTauk=;
        b=T0JOVVEw8H3tRvSSLoNtG1NgkK//AUVb7bFljZw8mIouKQWyXC74ALmYAATke+s1U7
         os8I6g0dw0Jf0Eerbzq2K7WgoqLJxPmjqu11Q3e0Fixav4qKge+UYz2YVlp920oBgav8
         uPOkVGX+8GtwnSlYIgf/h6a2tAFQUgokxykhyk1iYmREfwu7QpsBECZLI+xld53GnTjC
         3ZlCFxMAvchrgPTGoaKL77++X4gSplEsDaujzIUz+eoiZ9G0f1Kgvh0NwE8ty/RXDHtW
         +4gzJDpqaooBdPc8bmObTny6l2wOOF5QUr95PVDn55h0DJzjfitXpiXpu3eOuPWLrDdI
         kGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4WcGm54Bk3QjfqstG3OQWRPvhT95GSMT/k5joOPTauk=;
        b=f2L4PUGqPpC+MRGyhvrupqtV1mWNIzCeYMpvvNoj4bpSI/Ol5pjykybkn6UNsunMjM
         90U91ao43LEd/Un7YX0uPIpIG5xPy+vW0sCk+Vrnw1Mge+nBiCbpsMLSlyMTlQCThP84
         UPoDuLtBv6sOiiiewOxHQTJQGgmIEJgQIuGJuZ5ITsmZiHdJOEOAfbUv/pqrxzHZPYu8
         Tk0wcCl2rxoNKauXWxZDdRhFS9Z8oqcaBuKWyF+jjxZHZeJIcJMv7PCV+1Um+K2AZ8c0
         v317hVBPwipX4AQqkfr5RugaOkTWA96XDwdFt908V0tM9+XDgEpcVtBo3HPR+eDaHcAK
         2lgQ==
X-Gm-Message-State: AOAM532MlftNP4NkzNDESTb2z3RGIbLQht3unLS9R+wSK8mLGyN/zDBy
        gTVuH9wnqUztznSIc9i48gr9B2/xoNU=
X-Google-Smtp-Source: ABdhPJx/eRB6FU10ik+kYJ4+smSDCOO8MpH0LBZ6b8i0D51bzTSB0uoocVv5K//CEBcZo6wpDjVe+g==
X-Received: by 2002:a05:6402:212:: with SMTP id t18mr370046edv.37.1610387013775;
        Mon, 11 Jan 2021 09:43:33 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id j22sm111132ejy.106.2021.01.11.09.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:43:33 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 01/10] net: mscc: ocelot: auto-detect packet buffer size and number of frame references
Date:   Mon, 11 Jan 2021 19:43:07 +0200
Message-Id: <20210111174316.3515736-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210111174316.3515736-1-olteanv@gmail.com>
References: <20210111174316.3515736-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Instead of reading these values from the reference manual and writing
them down into the driver, it appears that the hardware gives us the
option of detecting them dynamically.

The number of frame references corresponds to what the reference manual
notes, however it seems that the frame buffers are reported as slightly
less than the books would indicate. On VSC9959 (Felix), the books say it
should have 128KB of packet buffer, but the registers indicate only
129840 bytes (126.79 KB). Also, the unit of measurement for FREECNT from
the documentation of all these devices is incorrect (taken from an older
generation). This was confirmed by Younes Leroul from Microchip support.

Not having anything better to do with these values at the moment* (this
will change soon), let's just print them.

*The frame buffer size is, in fact, used to calculate the tail dropping
watermarks.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
- Fixed FREECNT multiplier after consulting with Microchip support.

 drivers/net/dsa/ocelot/felix.c             |  1 -
 drivers/net/dsa/ocelot/felix.h             |  1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  1 -
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  1 -
 drivers/net/ethernet/mscc/ocelot.c         | 22 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  1 -
 include/soc/mscc/ocelot.h                  |  3 ++-
 include/soc/mscc/ocelot_qsys.h             |  3 +++
 8 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 90c3c76f21b2..a2e06a0d1509 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -451,7 +451,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->map		= felix->info->map;
 	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_stats	= felix->info->num_stats;
-	ocelot->shared_queue_sz	= felix->info->shared_queue_sz;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 4c717324ac2f..5434fe278d2c 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -15,7 +15,6 @@ struct felix_info {
 	const struct reg_field		*regfields;
 	const u32 *const		*map;
 	const struct ocelot_ops		*ops;
-	int				shared_queue_sz;
 	int				num_mact_rows;
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2e5bbdca5ea4..9fffbad6ef9b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1356,7 +1356,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.stats_layout		= vsc9959_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
 	.vcap			= vsc9959_vcap_props,
-	.shared_queue_sz	= 128 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= FELIX_NUM_TC,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index ebbaf6817ec8..b72813da6d9f 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1181,7 +1181,6 @@ static const struct felix_info seville_info_vsc9953 = {
 	.stats_layout		= vsc9953_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9953_stats_layout),
 	.vcap			= vsc9953_vcap_props,
-	.shared_queue_sz	= 256 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0b9992bd6626..876c03e51bdc 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1366,7 +1366,7 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 			    pause_stop);
 
 	/* Tail dropping watermarks */
-	atop_tot = (ocelot->shared_queue_sz - 9 * maxlen) /
+	atop_tot = (ocelot->packet_buffer_size - 9 * maxlen) /
 		   OCELOT_BUFFER_CELL_SZ;
 	atop = (9 * maxlen) / OCELOT_BUFFER_CELL_SZ;
 	ocelot_write_rix(ocelot, ocelot->ops->wm_enc(atop), SYS_ATOP, port);
@@ -1479,6 +1479,25 @@ static void ocelot_cpu_port_init(struct ocelot *ocelot)
 			 ANA_PORT_VLAN_CFG, cpu);
 }
 
+static void ocelot_detect_features(struct ocelot *ocelot)
+{
+	int mmgt, eq_ctrl;
+
+	/* For Ocelot, Felix, Seville, Serval etc, SYS:MMGT:MMGT:FREECNT holds
+	 * the number of 240-byte free memory words (aka 4-cell chunks) and not
+	 * 192 bytes as the documentation incorrectly says.
+	 */
+	mmgt = ocelot_read(ocelot, SYS_MMGT);
+	ocelot->packet_buffer_size = 240 * SYS_MMGT_FREECNT(mmgt);
+
+	eq_ctrl = ocelot_read(ocelot, QSYS_EQ_CTRL);
+	ocelot->num_frame_refs = QSYS_MMGT_EQ_CTRL_FP_FREE_CNT(eq_ctrl);
+
+	dev_info(ocelot->dev,
+		 "Detected %d bytes of packet buffer and %d frame references\n",
+		 ocelot->packet_buffer_size, ocelot->num_frame_refs);
+}
+
 int ocelot_init(struct ocelot *ocelot)
 {
 	char queue_name[32];
@@ -1521,6 +1540,7 @@ int ocelot_init(struct ocelot *ocelot)
 
 	INIT_LIST_HEAD(&ocelot->multicast);
 	INIT_LIST_HEAD(&ocelot->pgids);
+	ocelot_detect_features(ocelot);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
 	ocelot_vcap_init(ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 9cf2bc5f4289..7135ad18affe 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -517,7 +517,6 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	ocelot->map = ocelot_regmap;
 	ocelot->stats_layout = ocelot_stats_layout;
 	ocelot->num_stats = ARRAY_SIZE(ocelot_stats_layout);
-	ocelot->shared_queue_sz = 224 * 1024;
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2f4cd3288bcc..c6c131142195 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -607,7 +607,8 @@ struct ocelot {
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
 
-	int				shared_queue_sz;
+	int				packet_buffer_size;
+	int				num_frame_refs;
 	int				num_mact_rows;
 
 	struct net_device		*hw_bridge_dev;
diff --git a/include/soc/mscc/ocelot_qsys.h b/include/soc/mscc/ocelot_qsys.h
index a814bc2017d8..b7b263a19068 100644
--- a/include/soc/mscc/ocelot_qsys.h
+++ b/include/soc/mscc/ocelot_qsys.h
@@ -77,6 +77,9 @@
 #define QSYS_RES_STAT_MAXUSE(x)                           ((x) & GENMASK(11, 0))
 #define QSYS_RES_STAT_MAXUSE_M                            GENMASK(11, 0)
 
+#define QSYS_MMGT_EQ_CTRL_FP_FREE_CNT(x)                  ((x) & GENMASK(15, 0))
+#define QSYS_MMGT_EQ_CTRL_FP_FREE_CNT_M                   GENMASK(15, 0)
+
 #define QSYS_EVENTS_CORE_EV_FDC(x)                        (((x) << 2) & GENMASK(4, 2))
 #define QSYS_EVENTS_CORE_EV_FDC_M                         GENMASK(4, 2)
 #define QSYS_EVENTS_CORE_EV_FDC_X(x)                      (((x) & GENMASK(4, 2)) >> 2)
-- 
2.25.1

