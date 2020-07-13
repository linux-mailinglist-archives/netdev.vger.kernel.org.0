Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3F521DE11
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgGMQ7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730247AbgGMQ7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:59:04 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED29C08C5DB
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:59:04 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n2so14290816edr.5
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZXjy5HFc5KZB9HcZ6leuEcLSOXXYxm2/VwMz3DJaCTs=;
        b=YNShyOTU8PDummYyUtaj36qLXcumpX145fjywNUpB/Tb7Tw7GS6ad8Jfck3ixnWZV+
         9xPYLBxISm5m20gT0DCXnsVnnBb4/zIdvnP9UtyOTE4Q+eDVbTC78nSnVMK+EDU+XbXS
         SgFhBWJAflhPwFOa7yobxerpalc7R5Pi2WJazb5iV45svR6MIoCnJjpYc+liydhWJEj4
         gJgLP8ymkJhBMG96HwPvU6jSpGtiPZ05So+qfCLHf+wN6Iq+Z23mTTVp4NkC4SEbfO7a
         GpnObv+xvXddsKdeciQcAu1As08f4mvRLW119KIcvVvlA9niWkOCH+LsPaEtV9Cnfu75
         5fxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZXjy5HFc5KZB9HcZ6leuEcLSOXXYxm2/VwMz3DJaCTs=;
        b=p1HQkG19I5Gkh27uEEDf2uzYXfULFY5uvPCAKnUpZbr2A0EksvJavL9CZAK8M5Blga
         /6SIrMcGoAjsom70Gv2G5zTLn6Tf5y2u+jM8E401ZnZCC9dzv1cgvt+W85WGBj0cnWB+
         OBkgZCEBSxmLaU7JqBxvEu7aQUBixlAJW8F6w941pc4LnKdY0MRaFlDhAwa/JVhodCz7
         JWeQmgSfFCPetgwp32DXWpIGqtKA9305mjTa6GEUtEy2VuN9edoTmxKVqq4XHJCjhBLj
         QfkJFyZpcW/V33Bx2ZJLaSg2Yvs55+LlMprhKcPkn4OVvw4uRdbLyD7mvdj2c1E/KyVy
         m2GA==
X-Gm-Message-State: AOAM530flnvWAUMwF+wANWRDGv+iaZsNcuNAMWwGWvMUC5CxUqjCAKoY
        bKYlCkU2/XV4UqMVhrCWFkg=
X-Google-Smtp-Source: ABdhPJwpw83JP3fI+5A61YEjY3JdXvDoUmW2ACaDoPZEXTB7fo1S1l8xMv8P8x/HC6enTz+xPtDQwA==
X-Received: by 2002:a50:eb02:: with SMTP id y2mr310061edp.281.1594659542968;
        Mon, 13 Jul 2020 09:59:02 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y1sm12986732ede.7.2020.07.13.09.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:59:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: [PATCH v4 net-next 08/11] net: mscc: ocelot: extend watermark encoding function
Date:   Mon, 13 Jul 2020 19:57:08 +0300
Message-Id: <20200713165711.2518150-9-olteanv@gmail.com>
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

The ocelot_wm_encode function deals with setting thresholds for pause
frame start and stop. In Ocelot and Felix the register layout is the
same, but for Seville, it isn't. The easiest way to accommodate Seville
hardware configuration is to introduce a function pointer for setting
this up.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
Rebased on top of patch "net: mscc: ocelot: rename ocelot_board.c to
ocelot_vsc7514.c" which was merged since last submission.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix_vsc9959.c     | 13 +++++++++++++
 drivers/net/ethernet/mscc/ocelot.c         | 16 ++--------------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 13 +++++++++++++
 include/soc/mscc/ocelot.h                  |  1 +
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index fea482ad92c7..7e8a99455670 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1149,8 +1149,21 @@ static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
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
index 4d5222fa3397..f2d94b026d88 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -309,18 +309,6 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
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
@@ -1284,9 +1272,9 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
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
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index e9cbfbed1fc6..0ead1ef11c6c 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -739,8 +739,21 @@ static int ocelot_reset(struct ocelot *ocelot)
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
index 71bb92bcfdf7..da369b12005f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -541,6 +541,7 @@ struct ocelot;
 
 struct ocelot_ops {
 	int (*reset)(struct ocelot *ocelot);
+	u16 (*wm_enc)(u16 value);
 };
 
 struct ocelot_vcap_block {
-- 
2.25.1

