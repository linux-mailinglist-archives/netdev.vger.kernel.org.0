Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648731E90F4
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgE3Lwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728944AbgE3Lw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:27 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275FAC08C5C9
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:26 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id m21so3705553eds.13
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aCsh0gwZuFBldApOXNxaq+zg0SbtjYLWUPx1zrBwRYo=;
        b=bBNmleS7b/NTJDpbHPlb04w4hR0Af11NO0Cx9JJYrhXb/K8vZp3+bADrVTTE7XNxoU
         u4dos3VqMf8coYDBknQRWKiyBCHx0/gKiLdjiRqGPN9DfJN+ykfh+Yy8ay3Z7ZrZDMMn
         Vne6OHA6pHJBh+9YRPwF0qR9m+EBlCucNhPT8hcVsEiPlka/MPss8yhnwvNla9i70caf
         0D9pXsjI870aq034PTrXewoadVAkaVMCwUomqE9j5xuUHxKrL7L3o7Zzyj8CzAdvSdZ8
         Hmum5JPjDz43q/tXtkmxkzpcSIN8N+MRMoDKMPAWGwC7Tbbmh+m6OyUl+LUzWPzh/wka
         xCig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aCsh0gwZuFBldApOXNxaq+zg0SbtjYLWUPx1zrBwRYo=;
        b=H/vyR+A4VueiqnUc571/P4GToC4FUxabG26zLgOUziwZyvgjj5eb0972ExWhyifY8O
         490TV1g+0sUH53LIm6u7+ys9wSahZko7mksz2eHKtsuFJy6/7f45i9oYBnNXaXiN3C2S
         nohrLIncrBvTYLR0MgYhq0PeAJznNg8MZhD8x2f1qnbYWbYQER6zoMNhuVNhnRIpEYfz
         4Ye6bq6MyJyRLhG7/nIOXtinCPDA/sI5xKODuHakvnASdxBetfAx/d/BiNBTjadETAMd
         NKV8GsUyuBKVS64TFwBLwyRhbmv5iffkbv8O5GiWOHoSTnGXTxs973qpjyobfs7aRGb2
         gFmg==
X-Gm-Message-State: AOAM530+8Vojvbualvd8QzCCaJL9xhBpZJ45lJkPzbT0InHXksB2h4Ta
        tpJ616X5+mDmav4j3ncR+YU=
X-Google-Smtp-Source: ABdhPJxPgDuTEj56NSecYrlZfSJ+8NdqKrt8fKX+iDJq2YJU6bnTIQdM/FejyXDWV0vmGD9PIAQcWQ==
X-Received: by 2002:a50:9a86:: with SMTP id p6mr12787659edb.153.1590839544917;
        Sat, 30 May 2020 04:52:24 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 07/13] net: mscc: ocelot: split writes to pause frame enable bit and to thresholds
Date:   Sat, 30 May 2020 14:51:36 +0300
Message-Id: <20200530115142.707415-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200530115142.707415-1-olteanv@gmail.com>
References: <20200530115142.707415-1-olteanv@gmail.com>
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

