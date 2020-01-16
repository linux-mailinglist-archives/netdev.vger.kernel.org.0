Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E770E13F044
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395465AbgAPSTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:19:43 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39274 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbgAPSTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:19:42 -0500
Received: by mail-wm1-f66.google.com with SMTP id 20so4836712wmj.4
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0uvC8fWxSkFRwJ29nnfRK6ReJYlaVRKyfwxI5wncSjE=;
        b=aiKPr0cYrlcZDRCmTILAUE4GDHwMuaBBuUVBgpoCsc0aAY4DxyCsGFTB01/Hwa9Y57
         wxfOpJ8NAYH9YdaKV5Tj+qPoiIgP+FiWhkn9+lVWT5YNc4Z3XaqJNtKgCOQqhcnbi+sR
         wo52IBYd7Xy5N00swwNko3D4FpArbcva6tx7MKGxe50nOZSqH0yUDffsVH3j1J+g9Wyh
         cZsMQtfp9c0JKnt47ct1VeA/p6OKqnrJXkHEtM2eNZJ/1NX/YwABfz1sMBymdXm5aukl
         OJreuTUljthBzqXIye/sTF6lMEA7WxriBfLmLmPv8iPcTB/4WKNFOIpNbojliF4xX1fU
         CWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0uvC8fWxSkFRwJ29nnfRK6ReJYlaVRKyfwxI5wncSjE=;
        b=sUDwYZ8jWEDWw1zzxmSqK1MmzXJ/xLJRKK74f5Z6sawhhha6KBAZtJYDwouMEp83Qv
         hPxnoN7Br6wL7gyHR5wah0l1d+dQW1M7tKrBf9d/1RlYm5hl/Wa/dWGRDyjo1I9+uqiD
         aOkS5Bn20RZguHC1NEYsct4lRACaJmW3081vUcAEYuixWh/KYkQuPlKFmbDbGkfoGrw1
         G9Btu2YdeyWZDamGN2jp7Ksv+d9u7s9a7LPNr3gLuuFFqUitnmVNFNTwvh3+b2weRPht
         APR3Dp1iNsYtaPuetSeMZ5R8F9SZ0vOSE1qXpxSWHorSeNBiNJSwdN/DOk4zBNdzUVjm
         oFsQ==
X-Gm-Message-State: APjAAAXSlsvfFi3MoPUOPbGKk6+4GBBdu7LsxHRmBCYQlCu2P1X1Dhc1
        55/EJEbbxQjGGgb/tgLA1KanBNYtBPo=
X-Google-Smtp-Source: APXvYqz57VPO+upKUhYkBr9Ya+OaR+rnxtU85lP0frCnVPY+hhiGv15mYnlDbYHju3MUun6QusUZZw==
X-Received: by 2002:a7b:cf12:: with SMTP id l18mr357684wmg.66.1579198780324;
        Thu, 16 Jan 2020 10:19:40 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id g25sm1038148wmh.3.2020.01.16.10.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 10:19:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/2] net: dsa: felix: Handle PAUSE RX regardless of AN result
Date:   Thu, 16 Jan 2020 20:19:32 +0200
Message-Id: <20200116181933.32765-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200116181933.32765-1-olteanv@gmail.com>
References: <20200116181933.32765-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

Flow control is used with 2500Base-X and AQR PHYs to do rate adaptation
between line side 100/1000 links and MAC running at 2.5G.

This is independent of the flow control configuration settled on line
side though AN.

In general, allowing the MAC to handle flow control even if not
negotiated with the link partner should not be a problem, so the patch
just enables it in all cases.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d6ee089dbfe1..46334436a8fe 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -222,8 +222,12 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	 * specification in incoming pause frames.
 	 */
 	mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
-	if (state->pause & MLO_PAUSE_RX)
-		mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
+
+	/* handle Rx pause in all cases, with 2500base-X this is used for rate
+	 * adaptation.
+	 */
+	mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
+
 	if (state->pause & MLO_PAUSE_TX)
 		mac_fc_cfg |= SYS_MAC_FC_CFG_TX_FC_ENA |
 			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
-- 
2.17.1

