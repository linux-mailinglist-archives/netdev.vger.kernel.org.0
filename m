Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B75721DE0A
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbgGMQ7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730185AbgGMQ7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:59:00 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FA5C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:59:00 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id p20so18001023ejd.13
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=14O9zEt648WxJ9u0usTEBB/YN10Uloi76pt6upd82RA=;
        b=sAi9hjf58TfYw6RLIUbzJtMP5OvJICfFxwr0Dyrgn2NsAUf5baDceEkWuhuE4F7v8J
         Im2No9empjhOQH7ztipv7gHtPoHHMh4ClZT/XSfNUYPTJNB8HFWn1S9tncqTA82hkXk/
         RwrjL/22jDDjf1aOP71JOPO9rj/YQD9m8QjBvKsC5niYS3cxDCYr+KqUIKhl4ZDiugM3
         I7rVmfnz9DDjsU6d1sYeeMq0+jiCDbzjF62/r+YlslP5YCDxTSv9rgwpe2pS4X0zLT41
         SQhvjC7g37JTKYk0tq3q8zsueMYbJ4jC5YScZs1YqMsNf/eXX30Yv0m4TWWNRQdjehk0
         J7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=14O9zEt648WxJ9u0usTEBB/YN10Uloi76pt6upd82RA=;
        b=REJPVqDdzD/FjmJ8wHIxVHuTnlG0Zu4zMXz/niWGsTeeopZcbLI3nMNvm1+aEQoaHK
         22rBHWdZmjivtKKkbObApTTij2/RiaClNIKyly5NMaZB71Tna2JtE434DIX8I98kMa2n
         nqndyw2dHr8QF6ug/DQGmSFqr0AwAnZh9wkhc5aJFEFq6G894AtiJKBLdFXrQ0AwFKY+
         2LX8dIlS22JvCrrXnDxeYkaePda+zj/rsWaPSsg93cDemCfpk4XRgdZtwNb+8F8gs1CI
         OB6TJFADVG70yIGSIkGG2RrjSq4PfsEzqYcvZERS+Ab4wFtrSuZHyEjaQns6zJZlH6Xu
         mdKg==
X-Gm-Message-State: AOAM531fYvBnYXMINJbVrGQtKrGc0ujP3fvVb2pWAeOl3J8v9vgXpx/P
        Xw8l61642NOIQMrSd+v748RBMYdr
X-Google-Smtp-Source: ABdhPJwiXJnirHsCR93+kppF8As5ZA0aKtM8dsLi1MmUF8rt35TGPRWildkGatv5BO31oKrfEO2lwQ==
X-Received: by 2002:a17:906:1403:: with SMTP id p3mr664849ejc.106.1594659539317;
        Mon, 13 Jul 2020 09:58:59 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y1sm12986732ede.7.2020.07.13.09.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:58:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: [PATCH v4 net-next 05/11] net: mscc: ocelot: split writes to pause frame enable bit and to thresholds
Date:   Mon, 13 Jul 2020 19:57:05 +0300
Message-Id: <20200713165711.2518150-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713165711.2518150-1-olteanv@gmail.com>
References: <20200713165711.2518150-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We don't want ocelot_port_set_maxlen to enable pause frame TX, just to
adjust the pause thresholds.

Move the unconditional enabling of pause TX to ocelot_init_port. There
is no good place to put such setting because it shouldn't be
unconditional. But at the moment it is, we're not changing that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 36986fccedf4..aca805b9c0b3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1259,6 +1259,7 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int maxlen = sdu + ETH_HLEN + ETH_FCS_LEN;
+	int pause_start, pause_stop;
 	int atop_wm;
 
 	if (port == ocelot->npi) {
@@ -1272,13 +1273,13 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 
 	ocelot_port_writel(ocelot_port, maxlen, DEV_MAC_MAXLEN_CFG);
 
-	/* Set Pause WM hysteresis
-	 * 152 = 6 * maxlen / OCELOT_BUFFER_CELL_SZ
-	 * 101 = 4 * maxlen / OCELOT_BUFFER_CELL_SZ
-	 */
-	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
-			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
-			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
+	/* Set Pause watermark hysteresis */
+	pause_start = 6 * maxlen / OCELOT_BUFFER_CELL_SZ;
+	pause_stop = 4 * maxlen / OCELOT_BUFFER_CELL_SZ;
+	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_START(pause_start),
+		       SYS_PAUSE_CFG_PAUSE_START_M, SYS_PAUSE_CFG, port);
+	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_STOP(pause_stop),
+		       SYS_PAUSE_CFG_PAUSE_STOP_M, SYS_PAUSE_CFG, port);
 
 	/* Tail dropping watermark */
 	atop_wm = (ocelot->shared_queue_sz - 9 * maxlen) /
@@ -1341,6 +1342,10 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_HIGH_CFG);
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
 
+	/* Enable transmission of pause frames */
+	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA, SYS_PAUSE_CFG_PAUSE_ENA,
+		       SYS_PAUSE_CFG, port);
+
 	/* Drop frames with multicast source address */
 	ocelot_rmw_gix(ocelot, ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
 		       ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
-- 
2.25.1

