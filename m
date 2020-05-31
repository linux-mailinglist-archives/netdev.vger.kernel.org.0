Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59C81E978A
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgEaM13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbgEaM1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 08:27:18 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDF1C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:18 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id k19so5156594edv.9
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HPwHDLIEKYlTYjQXJSaD9uNYUiuhuCnoC1mTVfECGuY=;
        b=bttSwRxHrvjyJzfbmgBEwoOHWMN3pZlrp3vZNkGZENGGMPngbXgELevDBHSs0bxju+
         cE9mCdz/MJkJNIekyin4qFPCKZIFvbtzjb/TXo7jyYkCeYWRv3FfTy05oaefSQuL8UIm
         caiAI3cN3BlcV0t+nXVCAODAvmXrlhMSk4IsOMYKU1Sa86MF7kFEiXuR4YFlkPDIYFRQ
         +vl/gXpcEotHFn1+lw6yxW58ZtMcpT6sfiV5pFlgPPdPEpUkEgoRWfS5IWmfSzX84z1T
         F3/gujZny/eT0DJWXYSE5MeP+SYLbYIkh9yQN04MRvXb2HhKsQ8f1UeYfY13Rr9+4Vkc
         TXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HPwHDLIEKYlTYjQXJSaD9uNYUiuhuCnoC1mTVfECGuY=;
        b=f3mdr+vBi8EmpuHyTcIO7VVHLVQqb7bN1d4ApN6WnmQuT5bAtQpiwlacVnC1kWIEYD
         XhH+2k2YcU5ojcQZ2HRPod2xQB/WLKAiZb6Cbc1Fs1EJ+MOqKkjSJzQqIT90e79rbCnl
         8dJnfk6eWvofv5672tUkGTDECwCBUvf5yENMV80MwcTOaIgCIiUBmXVrvDitUHcnAqiu
         +BuV2U5hjRI3GcYdSjJR5jQ1DoaE8RcYkEJovfTldoCccyxL8jZdZuhzpveqTdZmrjB9
         q+6KffKQ08rBIsl9WW6zXt5XZlm6x/f16H3fmNDM5Po36gUcitii0GE5Oxj6fb5DihSE
         Q32g==
X-Gm-Message-State: AOAM530F6Y70BZRSGv2N/pQ4qSnMsEtbKo71y8xCnAjwpJygg9jFXhX7
        ypGfsdIkGxEc2K+ZVS2eev4k4T4b
X-Google-Smtp-Source: ABdhPJySJ16ntfWNq06uZuNxF4yqJM7Sz1GsNrtQ2LqM+1fA/fTyEJIOgDDoIJV7RbQ3Iws+sleVRQ==
X-Received: by 2002:a05:6402:c87:: with SMTP id cm7mr16616308edb.96.1590928036732;
        Sun, 31 May 2020 05:27:16 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id b16sm12870024edu.89.2020.05.31.05.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 05:27:16 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v3 net-next 10/13] net: mscc: ocelot: extend watermark encoding function
Date:   Sun, 31 May 2020 15:26:37 +0300
Message-Id: <20200531122640.1375715-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200531122640.1375715-1-olteanv@gmail.com>
References: <20200531122640.1375715-1-olteanv@gmail.com>
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
Changes in v3:
None.

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

