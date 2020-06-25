Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3620F20A1D2
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405814AbgFYPXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405394AbgFYPXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:23:51 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C04DC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:23:51 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g1so4519590edv.6
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dcE3p1bK1dhx6InYLIRr5s7TD7wLBu088hymDs7RaA0=;
        b=MXHNrXplZC81sgJ96wy5VJuGv3REuHz0ZXWSLm5KWHgvPHwgvQUKsbGQXFv9+jqMhc
         a5ykbcmNy1932aTeLIO0PmL9pIq8LNHrFqW7oooa/uvcsG9xuiIw1PcHoFjzFLGMYFPG
         xutlB4Cp0xv5lIjjm9ykQ8rKnTCff1SyVq/0I/CMxC+fVQWFPzSt5zBKDFVDA/6X6G1E
         TeySg+psyxY7DyodO6RWwHW4yguWCLbtpsOFDtneJjk/kn5cBiwRgHFbIOwos6KU6222
         pSEjzOb+iKG+XHbADXkyg0hKLEsfFC8B0sPQBJHz2kLaNMgdLcOg0DZ/yIN59/a7/4QC
         T/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dcE3p1bK1dhx6InYLIRr5s7TD7wLBu088hymDs7RaA0=;
        b=jyra1veyfsUhzDWftrYhgTcH2ZmQOx8iSMzTwGnN7qxVOr8S4pAzSMi1Iymj0KAliI
         AG1Ifk0q+5ivL/KlKxConfschXRZQXP+ZBFzO4tAEly1Ao1OhcIxWVTP8e9udOVYJEHg
         joBWAP3H5ucsoju9gE/KAib8xMZOTYp31SzfmtS6I2dgj2PJPQbHQhiJQ0qjrzzSy8Bj
         csnuSYeJLPPcIX70Nd7MHyqXO8vUqmuVXw89KnwbetMgkPWuEik3QPqK9xyM+qm7MUt5
         1fnZAMASNsfjVvy0s36kTkDhduIildMkttI9GeX6DCNdjqFx1wehANq5Wz/g6Y1zm9jZ
         whkA==
X-Gm-Message-State: AOAM531fzqvY1bnKy+IsU0sFG8/+oKeK1RMyCzI/WBCrW6UH1VKCtY1A
        IYWrc6pUh9tKDj6RRQyV+Ig=
X-Google-Smtp-Source: ABdhPJyGsTseFn/jsAhcryd+BBmPkwSM4umSDbIRWqUBQZOxWsA/fxq/LW5ZuVpxGaKvbmvBuTp4BQ==
X-Received: by 2002:a50:e883:: with SMTP id f3mr6318420edn.220.1593098630127;
        Thu, 25 Jun 2020 08:23:50 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o17sm9102898ejb.105.2020.06.25.08.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:23:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH net-next 3/7] net: dsa: felix: unconditionally configure MAC speed to 1000Mbps
Date:   Thu, 25 Jun 2020 18:23:27 +0300
Message-Id: <20200625152331.3784018-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625152331.3784018-1-olteanv@gmail.com>
References: <20200625152331.3784018-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In VSC9959, the PCS is the one who performs rate adaptation (symbol
duplication) to the speed negotiated by the PHY. The MAC is unaware of
that and must remain configured for gigabit. If it is configured at
OCELOT_SPEED_10 or OCELOT_SPEED_100, it'll start transmitting PAUSE
frames out of control and never recover, _even if_ we then reconfigure
it at OCELOT_SPEED_1000 afterwards.

This patch fixes a bug that luckily did not have any functional impact.
We were writing 10, 100, 1000 etc into this 2-bit field in
DEV_CLOCK_CFG, but the hardware expects values in the range 0, 1, 2, 3.
So all speed values were getting truncated to 0, which is
OCELOT_SPEED_2500, and which also appears to be fine.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 25b340e0a6dd..d229cb5d5f9e 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -240,9 +240,14 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	u32 mac_fc_cfg;
 
 	/* Take port out of reset by clearing the MAC_TX_RST, MAC_RX_RST and
-	 * PORT_RST bits in CLOCK_CFG
+	 * PORT_RST bits in DEV_CLOCK_CFG. Note that the way this system is
+	 * integrated is that the MAC speed is fixed and it's the PCS who is
+	 * performing the rate adaptation, so we have to write "1000Mbps" into
+	 * the LINK_SPEED field of DEV_CLOCK_CFG (which is also its default
+	 * value).
 	 */
-	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(state->speed),
+	ocelot_port_writel(ocelot_port,
+			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
 			   DEV_CLOCK_CFG);
 
 	/* Flow control. Link speed is only used here to evaluate the time
-- 
2.25.1

