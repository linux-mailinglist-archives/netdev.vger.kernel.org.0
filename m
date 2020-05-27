Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62831E51F0
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgE0Xln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgE0Xle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:41:34 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40AFC08C5C2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:33 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x1so30059702ejd.8
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Bl+Xkqd/N5CRbI8KV1rH3dBCjP3GStdDYejRCBn5Xs=;
        b=NY1fHAX7CInH6ap9iBT3RMMxkpvD35juleeWWIHdYxY56+OXBGSzbbWwCGZ/ooKlq2
         qqrndBL9QwWxhmFbbt3/eCy5gDf4hM1sK2oSQ3w9GXf6qordLrgwv9A+rXxDLLcxTmfs
         +fNi2san71uVS24pNK7O2UspSfqAHMRi2ozj8f2ICeEsIdwuis1h3DrOIoJej0uxSHJa
         1HVit1d4eECSUrauR1+cALrXFcGejJtB/YbSDHbW0yYu6aBIx3cL2o2dH8m4CFeaFd85
         JqHKZcikn17ET71fzT0V2KuBrBEddIr563OzCGRzDVn0ViXuMHQPsx+ApzZYo5VyVVDp
         4W/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Bl+Xkqd/N5CRbI8KV1rH3dBCjP3GStdDYejRCBn5Xs=;
        b=XpBNw2xtiOaG6+LAE+o/+163EytsV3t3DqiTwUUsC8Acbfy7AtuxbMmKkTzhfj5SMO
         sDsLXOx5uU5nA7pNL85cZuWY1xdznIVzobSaCasWX8n35iwE/8y4u7FYPHDoPc+ZFq4p
         QJKGY/Yf1Vtzu5/KV2xtd+acuYmSZCUQcmoqbIDBMA65Srzn2H5FOjOfbqDaLF4ki16K
         kaY8cUK3kgYW8+VvkVqOq/65bqnYStK4gv5/yD+oTVtLukxTB1hBe8N74D6uSz/SjtU0
         DD40LgD7Z9Tr+PeOVHftTdmBo9wpG/08Q8pTOC28V5jXah79t6/3vJWTB2CZeH2qX+RE
         WEcA==
X-Gm-Message-State: AOAM532SAuW3Lax1v1tVBSW5u5LgjFwVsnDm89EtrEdTNAeI+0uCI9Ol
        q6+EnPj6LJsqZIsGZ3auT/I=
X-Google-Smtp-Source: ABdhPJwXfwXCrrMHlCNtSNRZ5RzEtdhW+DmPp/c4KtA2JAMvi9GXujwxqo7oTqXl/kksSR4hd39afQ==
X-Received: by 2002:a17:906:aac8:: with SMTP id kt8mr673566ejb.460.1590622892667;
        Wed, 27 May 2020 16:41:32 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id a13sm3236555eds.6.2020.05.27.16.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 16:41:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH net-next 07/11] net: mscc: ocelot: split writes to pause frame enable bit and to thresholds
Date:   Thu, 28 May 2020 02:41:09 +0300
Message-Id: <20200527234113.2491988-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200527234113.2491988-1-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
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
---
 drivers/net/ethernet/mscc/ocelot.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0f016f497972..6fc5b72c9260 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2012,6 +2012,7 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int maxlen = sdu + ETH_HLEN + ETH_FCS_LEN;
+	int pause_start, pause_stop;
 	int atop_wm;
 
 	if (port == ocelot->npi) {
@@ -2025,13 +2026,13 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 
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
@@ -2094,6 +2095,10 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
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

