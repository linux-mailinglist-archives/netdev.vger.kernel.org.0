Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741332F62E0
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbhANOQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbhANOQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:16:25 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A6FC0613CF
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:44 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id u19so5872309edx.2
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yanC+wOgmCBlimUgkaB9EldM8bGHaBGupmLHxyN+2GY=;
        b=o5ERLF7ZUjh8xO7TI3H1c7de2v++KFzWkUQgxqGlClp8MMFIv0pcfK5pQgZDaFMR2p
         dN66NMgJ0t/JK0K8wDFPyAUyUpetwtkhepdvPiy824cOgkk6ENuFpgutjp00cQqZvCtv
         LLqX777VG3dmi/1DH/7CnUn9be/x9yHVfyyjVbmcFaoXZVjGh11l2BZmFFdM1tj3KexI
         /aLAB9C9Dzso58rgcvm5n48znmqGJpmhUGL2D8WJ5zLtfZMXaiOFKLqM5tnqn2CwC+U9
         jiA2lXpLNFtrslXP/FS4zZZaUVZVxkcVO8oipDyVEFXJCVb3jB0lRT40FJoZbmN3+9/f
         fRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yanC+wOgmCBlimUgkaB9EldM8bGHaBGupmLHxyN+2GY=;
        b=Tosy4DuWwy5MAw8D7Oc1Ai8AlD4oVUs8oRPfLKuVY4d9cGq++iEZ5FL2PFV5Ot3dJO
         cLsd8LZBAehPFfoVFnDqxl+CO4RvlPCSCej/Vb/+buwzK9axpnrwbr5m0Oiw05w2AMoz
         w+x+7yqlsYNg6eEmW+MTI8/TpFN/d2Gkt6/hadK8OBEF79ZPtGEaAJ1b7lByMJB4eSIG
         9sEe3PSSskbBOMWuDqRD7YR2U8N6qbyb3cdlUr0zmmOp/E0cxsm2vAsoGBtTqEKRtsuV
         IyHP2B2riwinGOdMDFOXhc83Yu9mcNcQMQgAIlq5LOAAr57VPpWvkcwqHqd+6hh+55ue
         H8Fw==
X-Gm-Message-State: AOAM530Ygw8HLI4ihhyTFy3aMTjIaAQIy3F1Jnqn4PtQCk48Ie7gUnUs
        Z3Jhq3fiHWQgPoWOU4+AvzE=
X-Google-Smtp-Source: ABdhPJwsDUDQ3asisJsdIkElsnTtNXPLD3YvoTcXAV0BXJM4J0H5A6KPYGA+IuaSlBTQdSqjRBM1WA==
X-Received: by 2002:a50:d88c:: with SMTP id p12mr5895885edj.370.1610633742914;
        Thu, 14 Jan 2021 06:15:42 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr3sm773535ejc.41.2021.01.14.06.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:15:42 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 02/10] net: mscc: ocelot: add ops for decoding watermark threshold and occupancy
Date:   Thu, 14 Jan 2021 16:15:14 +0200
Message-Id: <20210114141522.2478059-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210114141522.2478059-1-olteanv@gmail.com>
References: <20210114141522.2478059-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix_vsc9959.c     | 18 ++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 18 ++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 16 ++++++++++++++++
 include/soc/mscc/ocelot.h                  |  2 ++
 include/soc/mscc/ocelot_qsys.h             |  6 ------
 5 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b68df85e01a1..21dacb85976e 100644
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
index c17a372335cd..e548b0f51d0c 100644
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

