Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0E12ED592
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbhAGR2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbhAGR2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:28:20 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A878CC0612F6
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:27:39 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ce23so10757022ejb.8
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KvnPnxE3YCiZa7IYf7HpZAPVjWSSl/Zi8d709CiBsP0=;
        b=c0zAb8Tqu2+JIzvPl23DCt93spOTX1sChrqDBnbnQRTvdnoVHnIsVrYHH34yggWxeU
         Q+szA9ui+f8mj+sPZwayGcfYy1y9TlSKlS1VoMKnxiYS6SJ6oOyqJe/4XQsdNE8sH573
         Ey1hBpksz2fd+BA3lmxPeUwLr7/yo1wFx0rJs/4o7Ku5mSqxTSF/0B53XGbyp/AMee2e
         MsWwY5074uMMNYI+/8elHr3z5PvZslFaJCpdQW1Wu0CoXsPOWNV/GjiRpOcrw/xEWi53
         KkPjmBryIk6dxSf23oxblt+dX8/eZPjb/f20Amd2cbH7oTSu0BpdWuPOgSf1hv12QhTn
         prHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KvnPnxE3YCiZa7IYf7HpZAPVjWSSl/Zi8d709CiBsP0=;
        b=EX4urNJO73ARA8Wc16PTiYWDEvktH1Vqepg4uUZkD81jz0bkSvHlUXpa3m5xw5XTqR
         y/U0U4Fh9Nw7RJaezgN3Hi8fVseswJvrdZNta+sMJDJpmaeXj3p+g6q9AiTmU0aA0BqC
         msXnCG527TuBL07u7RKJ1BC6FHbFA/oOTYihBV11W5roL0ADprroUINZiwlqQzykJ+oA
         ZQtHx7G3z9ID05XdtYf9kjVau092remTQb4Q/FkP0eUIu8/Oic385d7Ia1wHfsTUomW5
         VNOOefBXwQ8lHFs9mYknDrN4pfFzjejJlLF+KAm7t4v9B7oRJtskKwvywXXEHBOzGZxT
         5rOg==
X-Gm-Message-State: AOAM530C78L/NfSTPZZdgeNrVCmvCwj+cervCLA9JeF3hyI+b1f9M3zU
        H8X3wJhFJ4XDQjtVLQMlqtUWhdfS5Qg=
X-Google-Smtp-Source: ABdhPJxEOdWPHhJ/6xaUqy5vmHPxDartloqsUKEX9BGeUe3YQEcuKkHwVelSOAr4xBmjnGwzoG3yEg==
X-Received: by 2002:a17:906:fa8b:: with SMTP id lt11mr7072387ejb.94.1610040458218;
        Thu, 07 Jan 2021 09:27:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id y14sm2643351eju.115.2021.01.07.09.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 09:27:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 02/10] net: mscc: ocelot: add ops for decoding watermark threshold and occupancy
Date:   Thu,  7 Jan 2021 19:27:18 +0200
Message-Id: <20210107172726.2420292-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107172726.2420292-1-olteanv@gmail.com>
References: <20210107172726.2420292-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We'll need to read back the watermark thresholds and occupancy from
hardware (for devlink-sb integration), not only to write them as we did
so far in ocelot_port_set_maxlen. So introduce 2 new functions in struct
ocelot_ops, similar to wm_enc, and implement them for the 3 supported
mscc_ocelot switches.

Remove the INUSE and MAXUSE unpacking helpers for the QSYS_RES_STAT
register, because that doesn't scale with the number of switches that
mscc_ocelot supports now. They have different bit widths for the
watermarks, and we need function pointers to abstract that difference
away.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/ocelot/felix_vsc9959.c     | 18 ++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 18 ++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 16 ++++++++++++++++
 include/soc/mscc/ocelot.h                  |  2 ++
 include/soc/mscc/ocelot_qsys.h             |  6 ------
 5 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 9fffbad6ef9b..540b86edbbb0 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1006,9 +1006,27 @@ static u16 vsc9959_wm_enc(u16 value)
 	return value;
 }
 
+static u16 vsc9959_wm_dec(u16 wm)
+{
+	WARN_ON(wm & ~GENMASK(8, 0));
+
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+
+static void vsc9959_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
 	.wm_enc			= vsc9959_wm_enc,
+	.wm_dec			= vsc9959_wm_dec,
+	.wm_stat		= vsc9959_wm_stat,
 	.port_to_netdev		= felix_port_to_netdev,
 	.netdev_to_port		= felix_netdev_to_port,
 };
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index b72813da6d9f..8dad0c894eca 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1057,9 +1057,27 @@ static u16 vsc9953_wm_enc(u16 value)
 	return value;
 }
 
+static u16 vsc9953_wm_dec(u16 wm)
+{
+	WARN_ON(wm & ~GENMASK(9, 0));
+
+	if (wm & BIT(9))
+		return (wm & GENMASK(8, 0)) * 16;
+
+	return wm;
+}
+
+static void vsc9953_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(25, 13)) >> 13;
+	*maxuse = val & GENMASK(12, 0);
+}
+
 static const struct ocelot_ops vsc9953_ops = {
 	.reset			= vsc9953_reset,
 	.wm_enc			= vsc9953_wm_enc,
+	.wm_dec			= vsc9953_wm_dec,
+	.wm_stat		= vsc9953_wm_stat,
 	.port_to_netdev		= felix_port_to_netdev,
 	.netdev_to_port		= felix_netdev_to_port,
 };
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 7135ad18affe..ecd474476cc6 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -763,9 +763,25 @@ static u16 ocelot_wm_enc(u16 value)
 	return value;
 }
 
+static u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+
+static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
+	.wm_dec			= ocelot_wm_dec,
+	.wm_stat		= ocelot_wm_stat,
 	.port_to_netdev		= ocelot_port_to_netdev,
 	.netdev_to_port		= ocelot_netdev_to_port,
 };
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index c6c131142195..8eb134cd8d9d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -563,6 +563,8 @@ struct ocelot_ops {
 	int (*netdev_to_port)(struct net_device *dev);
 	int (*reset)(struct ocelot *ocelot);
 	u16 (*wm_enc)(u16 value);
+	u16 (*wm_dec)(u16 value);
+	void (*wm_stat)(u32 val, u32 *inuse, u32 *maxuse);
 };
 
 struct ocelot_vcap_block {
diff --git a/include/soc/mscc/ocelot_qsys.h b/include/soc/mscc/ocelot_qsys.h
index b7b263a19068..9731895be643 100644
--- a/include/soc/mscc/ocelot_qsys.h
+++ b/include/soc/mscc/ocelot_qsys.h
@@ -71,12 +71,6 @@
 
 #define QSYS_RES_STAT_GSZ                                 0x8
 
-#define QSYS_RES_STAT_INUSE(x)                            (((x) << 12) & GENMASK(23, 12))
-#define QSYS_RES_STAT_INUSE_M                             GENMASK(23, 12)
-#define QSYS_RES_STAT_INUSE_X(x)                          (((x) & GENMASK(23, 12)) >> 12)
-#define QSYS_RES_STAT_MAXUSE(x)                           ((x) & GENMASK(11, 0))
-#define QSYS_RES_STAT_MAXUSE_M                            GENMASK(11, 0)
-
 #define QSYS_MMGT_EQ_CTRL_FP_FREE_CNT(x)                  ((x) & GENMASK(15, 0))
 #define QSYS_MMGT_EQ_CTRL_FP_FREE_CNT_M                   GENMASK(15, 0)
 
-- 
2.25.1

