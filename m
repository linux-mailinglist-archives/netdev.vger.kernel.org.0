Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8AC21DE0E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgGMQ7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMQ7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:59:03 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098FEC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:59:03 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e22so14288434edq.8
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZgZcCFBav/icNKA4EUmAq85KuCNNqPQhg7M3X4GVF6Y=;
        b=Jw/jvDdvUVcjZ+o/6E7rqtEgfVJ74ZZp0gTP/PjIIHsHEd+WemvNtw1q21RhZTqVle
         mX1g3BCyZXZzPYvfvVvsXxWqxH1ETy9TihvP485wjEvZ4KIJVmFvIyt8vcEqP/sAsYrz
         L9AcMc0ywEsuqnVblViaT6BV/0iNY2kaE2DcND2bVv7ENdTzL8HgyWlvc1teu5CvgZIE
         XR1vkmg2xE+zEsw53k0Vq7gCELrMJQPNJW2cEGReE3hfqNSVDxeJsaeV9mNJL/cHaRks
         RZiordjxLXIVmrlEG2V6jtPIQ0PoZh/X5DEhJCA1pCGhSboVa8uCW+5D0GRka/7TujQp
         XbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZgZcCFBav/icNKA4EUmAq85KuCNNqPQhg7M3X4GVF6Y=;
        b=W5ZDgSVkoK4Xa8oiJePU6QgEpN9gwg7p+xvNI7T1+Iw8Cf1fkWXsB12awBgwCDqRL5
         wS+wb1Lf8iWMnXYeruOptLboQEW4FExy9dp0a72x0fABNbAtshWq41h0TzMX/wKoIyGN
         4Gbvz9eR5LVrjergttku/y6QiWwHpzqbVbRFtpJlrupO61WUv2HGQ9Et5tomAatL9ZnY
         JI3hZ1DrlDvTkFslcWOReePRF0SsL6fwk16CHgQVyQDJbVEefcPppwR0XWjl6uARwIZ3
         N9B4L6vYiWtYHECTb1ssbaTTCKpJDqwRHB1ljYGJILsG6YI12+4zjSRZ4fVPJ8AoHLRh
         bJLA==
X-Gm-Message-State: AOAM531W2YvbgrFCuLoXAph/RL0rSsOqF3FH7qCrFW2ksXCNYx8etTjM
        6aKlJdHTxeZiKoqvPevksBbvD6NC
X-Google-Smtp-Source: ABdhPJzWFZoMep4K2gICIDUHSajQvRYvekKckgKPMPF7YPQfeda0E6X00mWTrClQkfMh8HyshDnXWQ==
X-Received: by 2002:a50:e385:: with SMTP id b5mr360335edm.130.1594659541776;
        Mon, 13 Jul 2020 09:59:01 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y1sm12986732ede.7.2020.07.13.09.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:59:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: [PATCH v4 net-next 07/11] net: mscc: ocelot: convert SYS_PAUSE_CFG register access to regfield
Date:   Mon, 13 Jul 2020 19:57:07 +0300
Message-Id: <20200713165711.2518150-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713165711.2518150-1-olteanv@gmail.com>
References: <20200713165711.2518150-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
Rebased on top of patch "net: mscc: ocelot: move ocelot_regs.c into
ocelot_vsc7514.c" which was merged since last submission.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix_vsc9959.c     |  3 +++
 drivers/net/ethernet/mscc/ocelot.c         | 14 ++++++--------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  3 +++
 include/soc/mscc/ocelot.h                  |  3 +++
 include/soc/mscc/ocelot_sys.h              | 10 ----------
 5 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index d640146acc3d..fea482ad92c7 100644
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
index 2a44305912d2..4d5222fa3397 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1276,10 +1276,10 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
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
@@ -1343,8 +1343,7 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
 
 	/* Enable transmission of pause frames */
-	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA, SYS_PAUSE_CFG_PAUSE_ENA,
-		       SYS_PAUSE_CFG, port);
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 1);
 
 	/* Drop frames with multicast source address */
 	ocelot_rmw_gix(ocelot, ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
@@ -1403,8 +1402,7 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 				    injection);
 
 		/* Disable transmission of pause frames */
-		ocelot_rmw_rix(ocelot, 0, SYS_PAUSE_CFG_PAUSE_ENA,
-			       SYS_PAUSE_CFG, npi);
+		ocelot_fields_write(ocelot, npi, SYS_PAUSE_CFG_PAUSE_ENA, 0);
 	}
 
 	/* Enable CPU port module */
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 9c6a9d44871d..e9cbfbed1fc6 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -369,6 +369,9 @@ static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 11, 4),
 	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 11, 4),
 	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 11, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 11, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 11, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 11, 4),
 };
 
 static const struct ocelot_stat_layout ocelot_stats_layout[] = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 6cfbace57770..71bb92bcfdf7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -511,6 +511,9 @@ enum ocelot_regfield {
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

