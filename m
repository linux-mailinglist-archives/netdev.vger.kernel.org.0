Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DB61E90F9
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgE3Lwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgE3Lwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:30 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B01BC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:30 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id k11so4667589ejr.9
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CG5ad4B0gW4vRCKYDyGMBu3nUn6S5tKwuGL7ZHvMBEc=;
        b=manlPvkYqAO2rpMD+SE+zF+gDwI/PoO3NqUcMKmIzrvjIFpjnWnOrpyVWHj6OBdOMP
         GDl7VdHeHFN5KbrCXzxNS48rNUOOHtRRft5SgUFYv4M0sNjhsiB+FIzqA82azMLMjNVI
         gpjQEEQH9c5YyCFyi0AjAiVM5R5VMXAVuQapJ5GMYzmM4nK1MnlxUhJr405/VBAKR1sO
         pnfbQfizSpgQWvJs3qRIBzf0BFtQTkn9cJDC8IohedxjSeD6ZcVueMD58TayWkSgcO1q
         wOyLE2fE76/OsXDsGUGGCGZqcjVS5DeQh279R/QT5xGifxpUuPLmX2ywAJVK0/ilClCF
         OL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CG5ad4B0gW4vRCKYDyGMBu3nUn6S5tKwuGL7ZHvMBEc=;
        b=G5H1/oqVxOqe+rKLUM9eck5sqyFO3MqI1prGDPop2SulNy2g9Ad9UGrWO282JfEk3a
         9vDIlJVKp79Q5R/FxF2/MiS+TMzgf5ZHTD3RVNva1g9OG1G/3dDG9k0VDAiWB3gTyGdK
         9wvT94/1vxugYZzv9rYq5XD2F8zgPIr9GzS2o8mAp+wNxP9gehnt2gQbWt4PZTqcaTQT
         CpL8wOYpvm89U9bZltu3U8wvsxkCzOEUGJgCBFbBgXlubZPMGL7dfxfbtR+RnfG7M8Yy
         9Y8887l0q18ufniUvupXUDKtJtlnySC3M7sV/ireLcUj382PQqJN3xv3WFK9KYEUqkHp
         wNng==
X-Gm-Message-State: AOAM5303YGnUaZigq7hJhAA7St3LaqsKtbv6CBuSCw3jhzOOhC2A9ba9
        NQpTkVuv+xS7iVzwwh7bz7A=
X-Google-Smtp-Source: ABdhPJy42IRiqF3kS2mZfo7eHAJ7/XCniVq4KgZ65UDdU2HL/E5bwjTbi248tVaJK1XCfbs9cKjkjA==
X-Received: by 2002:a17:906:b817:: with SMTP id dv23mr11464029ejb.185.1590839548797;
        Sat, 30 May 2020 04:52:28 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 10/13] net: mscc: ocelot: extend watermark encoding function
Date:   Sat, 30 May 2020 14:51:39 +0300
Message-Id: <20200530115142.707415-11-olteanv@gmail.com>
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

The ocelot_wm_encode function deals with setting thresholds for pause
frame start and stop. In Ocelot and Felix the register layout is the
same, but for Seville, it isn't. The easiest way to accommodate Seville
hardware configuration is to introduce a function pointer for setting
this up.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/ocelot/felix_vsc9959.c   | 13 +++++++++++++
 drivers/net/ethernet/mscc/ocelot.c       | 16 ++--------------
 drivers/net/ethernet/mscc/ocelot_board.c | 13 +++++++++++++
 include/soc/mscc/ocelot.h                |  1 +
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 81cc21d4d404..e722b58a714f 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1163,8 +1163,21 @@ static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
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
index a76c68481ee3..ad9bb551a843 100644
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
@@ -2038,9 +2026,9 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
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
index 68d3be32217f..620f1c4974ff 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -240,8 +240,21 @@ static int ocelot_reset(struct ocelot *ocelot)
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

