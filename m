Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AD01E90F6
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgE3Lwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbgE3Lw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:29 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07E6C08C5C9
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:28 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f7so4681334ejq.6
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cz7r/aiZxaAks8iUX3fh/elvHnSsU1VI/Tr1An0/v4Q=;
        b=HBknhsLJ1xXP8u2lIXJcmGHWGRf5DVfPOzeLLKt0szum9woM/lH8V4kgvsVMWiwdll
         tTqii27FekLvVHuQte5QiXsZWin/Ra3El1owIf2r+eZ/CPurA0dI6fdIqv3tUlnQSdjK
         zOjIU5Doyl/Ze2tD3UE8voc14uEj2nZeTW/a/OtGvH4NZTuKfRKbKIU+ijhb3FOkIv7M
         OGdQ0VYW6SM+r/M9nGlwAjCMoU98jmJp+eSnoRHYtOa4lerZ+JccTxYc1CaMvLFYT8aX
         IIEi7IaUYhUBscns5DDvfgWLYaJ0c7Ni8IObckc9slPGN1nrrqhMiR3OLkGONWqHUO6r
         hykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cz7r/aiZxaAks8iUX3fh/elvHnSsU1VI/Tr1An0/v4Q=;
        b=IBnPQCejyaAcTSgKEXDiBhi5/jDQb4j6Z2/20Pt77kSmnKxT4abe1TsWwE73GKi0gy
         TKVk4WdlF56h/m9wXUg0niGyNjigUNS6sy5B5zT3nKxu5ysYZoQP5QzVJXnwJyt/qqD7
         eV9mm7CZKu5LMNqB8PUgISYA+SEpHZTXVfjIxNmPOR1PbdxUNHJz5bfZPPWHUfnjuOfz
         13kOZ0bo1883I1rcmhO5qfG+zqhfn4O11rF96LOBfDtm4Eix622MT2Iini0yM7ohSg++
         QTYMn8tfWD3RS6klP6BM9LYjOTuWUcL7nGpDIB8QpVp5QvytaDJf8spvlVJQFBPz/zUX
         tu2g==
X-Gm-Message-State: AOAM530WuoKEHz5213log2wYVpX02SqWl0RZhMMqOl+EARDfMmSWia6j
        O4mdh+r5Lch/cq6wJPO/MsY=
X-Google-Smtp-Source: ABdhPJwFgnByFNeZQWGO9+pBy4eHI1y8JLjh6fluhHkJLBWgKbNQL7vOClUzvUvbhWdtoYfumc92dQ==
X-Received: by 2002:a17:906:1c4a:: with SMTP id l10mr10859730ejg.499.1590839547496;
        Sat, 30 May 2020 04:52:27 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 09/13] net: mscc: ocelot: convert SYS_PAUSE_CFG register access to regfield
Date:   Sat, 30 May 2020 14:51:38 +0300
Message-Id: <20200530115142.707415-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200530115142.707415-1-olteanv@gmail.com>
References: <20200530115142.707415-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

Seville has a different bitwise layout than Ocelot and Felix.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/ocelot/felix_vsc9959.c  |  3 +++
 drivers/net/ethernet/mscc/ocelot.c      | 14 ++++++--------
 drivers/net/ethernet/mscc/ocelot_regs.c |  3 +++
 include/soc/mscc/ocelot.h               |  3 +++
 include/soc/mscc/ocelot_sys.h           | 10 ----------
 5 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 554f24fa6ff9..81cc21d4d404 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -515,6 +515,9 @@ static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 7, 4),
 	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 7, 4),
 	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 7, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 7, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 7, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 7, 4),
 };
 
 static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c36d29974092..a76c68481ee3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2030,10 +2030,10 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 	/* Set Pause watermark hysteresis */
 	pause_start = 6 * maxlen / OCELOT_BUFFER_CELL_SZ;
 	pause_stop = 4 * maxlen / OCELOT_BUFFER_CELL_SZ;
-	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_START(pause_start),
-		       SYS_PAUSE_CFG_PAUSE_START_M, SYS_PAUSE_CFG, port);
-	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_STOP(pause_stop),
-		       SYS_PAUSE_CFG_PAUSE_STOP_M, SYS_PAUSE_CFG, port);
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_START,
+			    pause_start);
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_STOP,
+			    pause_stop);
 
 	/* Tail dropping watermark */
 	atop_wm = (ocelot->shared_queue_sz - 9 * maxlen) /
@@ -2097,8 +2097,7 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
 
 	/* Enable transmission of pause frames */
-	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA, SYS_PAUSE_CFG_PAUSE_ENA,
-		       SYS_PAUSE_CFG, port);
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 1);
 
 	/* Drop frames with multicast source address */
 	ocelot_rmw_gix(ocelot, ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
@@ -2204,8 +2203,7 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 				    injection);
 
 		/* Disable transmission of pause frames */
-		ocelot_rmw_rix(ocelot, 0, SYS_PAUSE_CFG_PAUSE_ENA,
-			       SYS_PAUSE_CFG, npi);
+		ocelot_fields_write(ocelot, npi, SYS_PAUSE_CFG_PAUSE_ENA, 0);
 	}
 
 	/* Enable CPU port module */
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index 019c8231f448..708e4d798202 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -352,6 +352,9 @@ static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 11, 4),
 	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 11, 4),
 	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 11, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 11, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 11, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 11, 4),
 };
 
 static const struct ocelot_stat_layout ocelot_stats_layout[] = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1a87a3a32616..a97cc1796b5e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -496,6 +496,9 @@ enum ocelot_regfield {
 	GCB_SOFT_RST_SWC_RST,
 	GCB_MIIM_MII_STATUS_PENDING,
 	GCB_MIIM_MII_STATUS_BUSY,
+	SYS_PAUSE_CFG_PAUSE_START,
+	SYS_PAUSE_CFG_PAUSE_STOP,
+	SYS_PAUSE_CFG_PAUSE_ENA,
 	REGFIELD_MAX
 };
 
diff --git a/include/soc/mscc/ocelot_sys.h b/include/soc/mscc/ocelot_sys.h
index 8a95fc93fde5..79cf40ccdbe6 100644
--- a/include/soc/mscc/ocelot_sys.h
+++ b/include/soc/mscc/ocelot_sys.h
@@ -43,16 +43,6 @@
 #define SYS_TIMESTAMP_OFFSET_TIMESTAMP_OFFSET(x)          ((x) & GENMASK(5, 0))
 #define SYS_TIMESTAMP_OFFSET_TIMESTAMP_OFFSET_M           GENMASK(5, 0)
 
-#define SYS_PAUSE_CFG_RSZ                                 0x4
-
-#define SYS_PAUSE_CFG_PAUSE_START(x)                      (((x) << 10) & GENMASK(18, 10))
-#define SYS_PAUSE_CFG_PAUSE_START_M                       GENMASK(18, 10)
-#define SYS_PAUSE_CFG_PAUSE_START_X(x)                    (((x) & GENMASK(18, 10)) >> 10)
-#define SYS_PAUSE_CFG_PAUSE_STOP(x)                       (((x) << 1) & GENMASK(9, 1))
-#define SYS_PAUSE_CFG_PAUSE_STOP_M                        GENMASK(9, 1)
-#define SYS_PAUSE_CFG_PAUSE_STOP_X(x)                     (((x) & GENMASK(9, 1)) >> 1)
-#define SYS_PAUSE_CFG_PAUSE_ENA                           BIT(0)
-
 #define SYS_PAUSE_TOT_CFG_PAUSE_TOT_START(x)              (((x) << 9) & GENMASK(17, 9))
 #define SYS_PAUSE_TOT_CFG_PAUSE_TOT_START_M               GENMASK(17, 9)
 #define SYS_PAUSE_TOT_CFG_PAUSE_TOT_START_X(x)            (((x) & GENMASK(17, 9)) >> 9)
-- 
2.25.1

