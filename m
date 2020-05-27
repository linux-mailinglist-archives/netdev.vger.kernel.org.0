Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396AF1E51F1
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgE0Xlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgE0Xli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:41:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8813C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:36 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o15so8708986ejm.12
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p6NFCIT12d9evx2OFd+iOGXSpqp9ITQc+G8YVnNynXE=;
        b=QfTNcygxt7sX95nFLIEoUuaUS57QQ3T4yKybzKJ4zisrzWyW4Xk7JYUmecZtoYVK/h
         NA9PaKfHav9vYY8bDies122ux1dc4Bbcg/uIHapPCSZhICA4Ta7RlKEeb1GWR7UIwe7h
         6qjyDA7mWf3q/tTbd06eskfNNtQcaXvkxXQ5mtfdL8QwWZo922SJO1WrhpMPjO+WrI2O
         i4GAoUwnsk3EvKm6Cmv04hx13DELvvj6z9YIIuBZNrmt+7cu1ZxdyrUBM2etlvwVx3Eq
         Mm6y0mK1JNKpvXIF65UQXcmuz8lqkLB/6mDijVXJYir1c8i3+2VQwZ57nZER99DxS3LB
         5FeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p6NFCIT12d9evx2OFd+iOGXSpqp9ITQc+G8YVnNynXE=;
        b=KSpr6/sUmkwzvqDBDe3L1DQfNk+FIHyp6wPwYeD2FaXp3zseY0LiG7bUSR6m7RjC54
         PE4f13KXFVi3YtP3SSDY+mqNze4cHmzzVjh4inhqo88lbNYD1orVZALNSL4bN44pjSFM
         8F+ZTKkpqtGnkU7+M6J6/ddJEGJYtRWtfBgCaV6BmoMS/+5rjHzBG2qrG+on9l17QLg8
         vt2Z+8lQ6piAgTBqiVhD73+Glfu33PedXoUIDt/BfpSyg7LVsJSIdQD0oAKh1QURf8lY
         XzTeMKRHnf5JFY//UlSILs8eUXRBA0oGNeVbWrDq3nEB8iO6UiyzkOzP3WqbWbjhkx34
         iE6Q==
X-Gm-Message-State: AOAM533i827qTtSnsoHcsaCoM5ntO86xppAKt+ybLod432LRIvjXgWki
        0udsgXnmAp9RpAPx7fMcU+w=
X-Google-Smtp-Source: ABdhPJwpixtktR4vLCkNdkpifDxOgNT2f6N3Tfw6wlYz9TC3Vl+emt1M4I/pGtElaGpuH6f35g7BPA==
X-Received: by 2002:a17:906:4ec2:: with SMTP id i2mr651321ejv.211.1590622895396;
        Wed, 27 May 2020 16:41:35 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id a13sm3236555eds.6.2020.05.27.16.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 16:41:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH net-next 09/11] net: mscc: ocelot: convert SYS_PAUSE_CFG register access to regfield
Date:   Thu, 28 May 2020 02:41:11 +0300
Message-Id: <20200527234113.2491988-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200527234113.2491988-1-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
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
 drivers/net/dsa/ocelot/felix_vsc9959.c  |  3 +++
 drivers/net/ethernet/mscc/ocelot.c      | 14 ++++++--------
 drivers/net/ethernet/mscc/ocelot_regs.c |  3 +++
 include/soc/mscc/ocelot.h               |  3 +++
 include/soc/mscc/ocelot_sys.h           | 10 ----------
 5 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index dc9480e82d70..bd0bb720558c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -514,6 +514,9 @@ static const struct reg_field vsc9959_regfields[] = {
 	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 7, 4),
 	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 7, 4),
 	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 7, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 7, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 7, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 7, 4),
 };
 
 static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 41d1026ec5b3..b66589a5300c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2029,10 +2029,10 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
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
@@ -2096,8 +2096,7 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
 
 	/* Enable transmission of pause frames */
-	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA, SYS_PAUSE_CFG_PAUSE_ENA,
-		       SYS_PAUSE_CFG, port);
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 1);
 
 	/* Drop frames with multicast source address */
 	ocelot_rmw_gix(ocelot, ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
@@ -2202,8 +2201,7 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 				    injection);
 
 		/* Disable transmission of pause frames */
-		ocelot_rmw_rix(ocelot, 0, SYS_PAUSE_CFG_PAUSE_ENA,
-			       SYS_PAUSE_CFG, npi);
+		ocelot_fields_write(ocelot, npi, SYS_PAUSE_CFG_PAUSE_ENA, 0);
 	}
 
 	/* Enable CPU port module */
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index 56bdb1bb2f36..eeb4771a9a2a 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -352,6 +352,9 @@ static const struct reg_field ocelot_regfields[] = {
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

