Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F073B214DF3
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgGEQRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727869AbgGEQRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 12:17:00 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4A5C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 09:17:00 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id z17so32456238edr.9
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 09:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1O8BKQbsB3cuoPCkpzYQE5EX9RuArBPO6YfLOUOM+Kw=;
        b=JBfv2NcH3DO8uNrqROGYNltwCZwIfa6TPXOj5K6OESqO1O3GBUWjjI8cKyXj6kBucW
         +GlE/zD002KFauMhUeoTb+2TZ3cxYyAhQykQRsLq27sNcgLvpJ1edOaXXgF2MmXt6riN
         lZne1EfLtIQExVaqHgJ+CAIn0yrDcTh6yqkQ+tnlEswsoCT9mwwlo9egrvoHgICrZKI8
         mJHtfI7rH3NfE27fyNPJeyERgMKAdm2BjzSCgpWCrzITGzwUh1jMkVEtDNjt+9jvlPmh
         FVQNLW4x2qadJ10P8jpOJ4oFR09w97/UgytwseDQr3w0Rbcl86KNIXQHIHKB0n93CvPS
         BvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1O8BKQbsB3cuoPCkpzYQE5EX9RuArBPO6YfLOUOM+Kw=;
        b=YfMk0gHn5Hm9EWpBARSre+C0RIKewFDDy/0h+LxyvyAc2qpetPgQg7tpx5k1qGzvVn
         ul6/rVvu8Rx//+e2l9AYOBbSPbdafmJWsY7JIfTuaSHsyGsiezHT7HizRRtNPRathWgp
         ZZZTNStmKsAWtS6JtA7MS5cU3O3tATcZ7e40qOLDCiOktHtej44r1IsJPR/7NVanSKRQ
         04DK7YmmJLJVqpCTIfVdfdHVQYFLdMl2TWmGxJfy2J11DYCJI9aqJaXuMmFNQyaL6VtV
         9WV8tjs4OkYJ41JOyXXDRHz+aC+f7PYSsUwMvlUMqVEkJjgdArjdcLQ5afdMrvbEGYQ4
         Cobg==
X-Gm-Message-State: AOAM532q9s6yoCJwKk2SDMkPcWEtb4VbYKaoJIKSEpRilPwZYIVLwwfk
        nJXF+2KAjFGBWgSVn9iac1U=
X-Google-Smtp-Source: ABdhPJyqZr/tSlp3WsqAvAp449+uFKPRuotBnxe5GyeIj7cv0zmhQX6mpR1021PcPwHFijjNZxaRNw==
X-Received: by 2002:a50:ba8b:: with SMTP id x11mr52713290ede.201.1593965819352;
        Sun, 05 Jul 2020 09:16:59 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x4sm14406126eju.2.2020.07.05.09.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 09:16:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v3 net-next 3/6] net: dsa: felix: unconditionally configure MAC speed to 1000Mbps
Date:   Sun,  5 Jul 2020 19:16:23 +0300
Message-Id: <20200705161626.3797968-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200705161626.3797968-1-olteanv@gmail.com>
References: <20200705161626.3797968-1-olteanv@gmail.com>
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
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f54648dff0ec..4d819cc45bed 100644
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

