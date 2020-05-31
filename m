Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8C41E9785
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgEaM1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729655AbgEaM1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 08:27:14 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FC4C03E969
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:13 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g1so4302187edv.6
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HAgSveX2T4/MIBOHvmAsZCRIPjmxhBpSFsqu4U4IYVI=;
        b=nPl2WxcDGNVNV0xxzzWQjTrXGAPZtHoTzaEmbRxGbBoRRPLHZEpiPqhfA5wS1YRIHz
         eq5kuIdH72vfXRr+ot1Xj9+q20Cwf3FVQXuAaHuSqc+fjrPw+olP+VmLRxe0Um7v6/yV
         xmyS3DzYeqrGGzfKshGLBo8bZu+kamuYFGYBA6pWbwLa4Tc3J6PgeB/gpVmCnUh7HM9U
         rFFI5Veoy6//wtEhUt5AuLncSqzZEbl4lsnYr0XyLOCLTVfyZtGC6Rlgpv/TDJq+5W8d
         9fQusJWu+uQu4ca48uTbD4SonYDAE0tCqqyGbMCZ3+XzXgGFZC4qd3SD7KrmdOBFErtM
         9tTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HAgSveX2T4/MIBOHvmAsZCRIPjmxhBpSFsqu4U4IYVI=;
        b=HyYhxv+sBEtU+g3i3eR3rWRV4RYctJbBVxFmhyFlg0Tte0U53kDUIW9rJxkuO8A59j
         HlbeROalRXSbxa056kqcQfIcUF8exojPrVmoreJDH2I2HE9s00add/HwkkCSLUXdaUT3
         TNZqkldMuUU6s0jc4mNOYsCO4UbsUt6tpPbD52pcrYmr4ySrmZbgVL1N5eZQeCPEiqOo
         3hvNhGVFl4otP4bTNiZuzNzaSa6IY2yqc7f8hTulAuQkOJTXYZ7OVRGoHp9VQ8Qnqkhj
         8Ff51c1D16WsFoKf5nC7Ttrx5oSaDO4bNW0trgktdUIBAW7VO5Dki87/kRic98qgmvJq
         OkGA==
X-Gm-Message-State: AOAM533I2wb3AyJW1qc+vHK/2kLdXekqmZ2HIeRhdeVjFk10gzRIty7Y
        dCCmWsHYF83+lD7kNdzIQ9s=
X-Google-Smtp-Source: ABdhPJyVC4EFodhjk+NdsQJny45w5T/PjEMRp0C8KWWZvd5FaHIZWuPAPoyza9oWAQG2dNNNvb22pA==
X-Received: by 2002:a05:6402:7ca:: with SMTP id u10mr16476010edy.322.1590928032680;
        Sun, 31 May 2020 05:27:12 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id b16sm12870024edu.89.2020.05.31.05.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 05:27:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v3 net-next 07/13] net: mscc: ocelot: split writes to pause frame enable bit and to thresholds
Date:   Sun, 31 May 2020 15:26:34 +0300
Message-Id: <20200531122640.1375715-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200531122640.1375715-1-olteanv@gmail.com>
References: <20200531122640.1375715-1-olteanv@gmail.com>
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
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 266e69252232..d9b0918080c5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2013,6 +2013,7 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int maxlen = sdu + ETH_HLEN + ETH_FCS_LEN;
+	int pause_start, pause_stop;
 	int atop_wm;
 
 	if (port == ocelot->npi) {
@@ -2026,13 +2027,13 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 
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
@@ -2095,6 +2096,10 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
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

