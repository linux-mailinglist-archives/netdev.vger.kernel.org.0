Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7383B1E51F3
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgE0Xlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgE0Xli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:41:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167CAC08C5C2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:38 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z5so30109760ejb.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OJUz/sdOGlH0F+LYx1lbLdlOI9OhVr63im+F452Sb9U=;
        b=ETUH/XCIC57wQkwEErXtN/JRVb0JUiaoYTsPgs06Ko0GnKkcRJgr6ne7eNxHi4j3A/
         BMHZb8CBt5+JzioaTE3bzrjH0FeSnCT5izEehRHIXCgxiQcSwPcWn9Rb/ObD/cjdz2iM
         smH1/wCa+lGWEpiSEFqLP9yKb0LI4AVCHCKDMYXVb0HBuoO5R3kAnAAzmxmhx4yP6THT
         9Ib/VQPIquO5cW+2wR8/2Rw10SZVCGLMXnBrjHYgdgjAzQhqIEdrWc/p3MDP13bVMoOb
         mp4tuAsH/VVbXjy0GlZsAprlpOEld901R+Lchy9JhOwUJxnWJ7xhw66AGJaWLgMaFFc7
         J3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OJUz/sdOGlH0F+LYx1lbLdlOI9OhVr63im+F452Sb9U=;
        b=l4LuYOdQhLUXauTMUUuYEuzqrzMSuVZ7sqcVwQlJgkyGGhKBv9/CBeDoFHfCJfisHp
         W5x5qnJBCBpgcTNjkmZ60FL0LSijODWgprmdkspVvvLwpePP0//DpUKoepHV233WKQyH
         seIZUzUIcUA47xMgdrUsl5G1h/6nSPHtNUzXQK+C1BRHUNOtZw66kEEO/FsUG+97nJPL
         bXyjlw4CzxVPDs41xCi7joOzFIIMFD5j1A77oK6GfxONCAyABeCOkqE83mqandCrJD1U
         /lkKu+7vIfcTl4eRhaoD2dWj88Umg3Ef8tpLH0A3hakBxs5BwMSdGGc9nnokw2EA9E29
         1Xhw==
X-Gm-Message-State: AOAM530dlIZRvt6lL9ZEwQ7ZJRK8UZF0KAnAyMZVoHY6Wci4vvcLXcwq
        hnjjY4rgOtJv/jFQbLUBH2k=
X-Google-Smtp-Source: ABdhPJwOkteZ3VoxX785svZwhMfygXifbQuwol5nmcYMtTerpAYzPbQFRniDmYBpTz9AxEwpMgGOsg==
X-Received: by 2002:a17:906:5941:: with SMTP id g1mr692732ejr.182.1590622896796;
        Wed, 27 May 2020 16:41:36 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id a13sm3236555eds.6.2020.05.27.16.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 16:41:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH net-next 10/11] net: mscc: ocelot: extend watermark encoding function
Date:   Thu, 28 May 2020 02:41:12 +0300
Message-Id: <20200527234113.2491988-11-olteanv@gmail.com>
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

The ocelot_wm_encode function deals with setting thresholds for pause
frame start and stop. In Ocelot and Felix the register layout is the
same, but for Seville, it isn't. The easiest way to accommodate Seville
hardware configuration is to introduce a function pointer for setting
this up.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 13 +++++++++++++
 drivers/net/ethernet/mscc/ocelot.c       | 16 ++--------------
 drivers/net/ethernet/mscc/ocelot_board.c | 13 +++++++++++++
 include/soc/mscc/ocelot.h                |  1 +
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index bd0bb720558c..8efcc2bda2b0 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1162,8 +1162,21 @@ static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
 	}
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+static u16 vsc9959_wm_enc(u16 value)
+{
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
+	.wm_enc			= vsc9959_wm_enc,
 };
 
 static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b66589a5300c..583f62c52131 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -396,18 +396,6 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	}
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
 void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev)
 {
@@ -2037,9 +2025,9 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 	/* Tail dropping watermark */
 	atop_wm = (ocelot->shared_queue_sz - 9 * maxlen) /
 		   OCELOT_BUFFER_CELL_SZ;
-	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * maxlen),
+	ocelot_write_rix(ocelot, ocelot->ops->wm_enc(9 * maxlen),
 			 SYS_ATOP, port);
-	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
+	ocelot_write(ocelot, ocelot->ops->wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
 }
 EXPORT_SYMBOL(ocelot_port_set_maxlen);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index b6ea9694c3ae..4a807a9027f5 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -239,8 +239,21 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return 0;
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+static u16 ocelot_wm_enc(u16 value)
+{
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
+	.wm_enc			= ocelot_wm_enc,
 };
 
 static const struct vcap_field vsc7514_vcap_is2_keys[] = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index a97cc1796b5e..8a2cb5ea17e7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -526,6 +526,7 @@ struct ocelot;
 
 struct ocelot_ops {
 	int (*reset)(struct ocelot *ocelot);
+	u16 (*wm_enc)(u16 value);
 };
 
 struct ocelot_acl_block {
-- 
2.25.1

