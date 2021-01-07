Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40842ED591
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbhAGR2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbhAGR2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:28:19 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D55AC0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:27:38 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id 6so10791515ejz.5
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wd0QcwBJ2vn++lI7pidSu3Qx2q+Ci60Px6nqG2GRnxw=;
        b=qGg7BThsXPoKgb2hjyWxGyzoGltsO4DXx1fhPEsPr9kbiJDUtbwQEE4Lul/pUegnea
         KVkUQXZxTlYOfH6eBcf1d+rYM4oA2vIWVawhuDnVbnQsBqPrnRXgc73D4IS10LiVtb1a
         QKx6bBK6fAQ/p+88eYGJe2YwaSDWYGuvoi2abiB5UOBPYUbOlDxuobsFAKkq2yX4BSxQ
         U1Or9Dxz5mhE9Yaz3d15eTxPC3YRhUO38A0VQjCaA6i8eKyKtGs4sl+3eTU5nu/hfnLS
         RAC6wFE+pUYVvSx7FOJ066XWeLwlc+u+rChr2qowGpKHCgAv4NAhVKPbPt57EpGxIGoS
         nC0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wd0QcwBJ2vn++lI7pidSu3Qx2q+Ci60Px6nqG2GRnxw=;
        b=t7jY1C8xkTpnJ/7u1Z3WISMpiG3YrUm6lXf/G/GOwpRCUpKjzi7EFxFqGUYc/DPUPl
         Pkfw1P+AgqXA4W3oO8DhOgcn7+7d8kuj9WaXGbwALXxlinnl0CINDlahEbc9eq9od0Qp
         Q3P2dvKVqiub6hpN4yTuknH6PRxcC/Tj+0vDqs+0jor8Yz1Y2UBRMyfLKjgQglJ9yUBu
         J3av9XrK9S8Uf9v1PDVwegBl9akzNbdcvvubA7Ano2+TPQv29+tFaE/jWmolX2pJMNqD
         mscrtRF+TXMEC2oKZh38QWJZ/tPs3nDG0yfNimqn0R8uK8sw7shmukc+x6rZhg1pYwGP
         Zqvw==
X-Gm-Message-State: AOAM531X8TTsd9Y/K+D2l6JQcOq5MXqcXH8aqTIBJnyzBrhWA7utqyh6
        mZnbmGjnHBw30potB7r2/k7tLzbz4Sg=
X-Google-Smtp-Source: ABdhPJwRZDf0+MA/SRT/FfUCElZZ8UxnUQ1AZdpJXugEvgh7TmO7CckpPIYKpirFESdbQUc7lq4p+g==
X-Received: by 2002:a17:906:39d5:: with SMTP id i21mr6736758eje.339.1610040457051;
        Thu, 07 Jan 2021 09:27:37 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id y14sm2643351eju.115.2021.01.07.09.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 09:27:36 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 01/10] net: mscc: ocelot: auto-detect packet buffer size and number of frame references
Date:   Thu,  7 Jan 2021 19:27:17 +0200
Message-Id: <20210107172726.2420292-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107172726.2420292-1-olteanv@gmail.com>
References: <20210107172726.2420292-1-olteanv@gmail.com>
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
---
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
index 7dc230677b78..bcc9ee7517d6 100644
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

