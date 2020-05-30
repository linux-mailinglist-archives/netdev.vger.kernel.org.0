Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682051E90F0
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgE3LwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbgE3LwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:19 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC26C08C5C9
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:19 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id f7so4681122ejq.6
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9FrCbTNiAzR9lsB4okxTeW2QU8RNrm7AfpXzRjT4UDk=;
        b=ImAu62XaTIanpD59d88fFFhN2FL2u07jIqJ6m5udF/efeNsyhgyI+qWnHLx+XeksDE
         I20IkBZMV58p9mRipkM6wGabS6Vdxjt83NWm/bKLbCnLdIyqqCj15bjCoH4NDqAaS4I2
         GZQcR85kcfZRVwJb9ZQfmMYAeyNgN9eyn6dYRjXsniEBHIFQbCqjkwBJfjFewIMjMJ1a
         9vTR245rQIdwNbTY1MF4pmQABvE5Se0w6/iOxY9U2/Tc5PyNvkXGK1aTNkB0y7EpvROL
         0P6YcYcu5xLJGQi+D8k9Lu2X/IqCWkKIiiRgswU6u/AV2csTqMM/oBkpykiGz7Q5kCE/
         cUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9FrCbTNiAzR9lsB4okxTeW2QU8RNrm7AfpXzRjT4UDk=;
        b=jzQ5V7fTfo8OtpKehAPlDjrhhgpL9HdPfLGItvnK9Li+BCkZeu7aQQYgefAI/P2dKU
         DxSfvxz7m8aNRzdAkn+Z63WPJ9RmMa6cSF1dcEb3uc6iBmGoG55gpqhDjR+hmND0RsRz
         PVdxueSdCrJpgui0xoix2zUg8GpbaH5d/pL4hvmgkYVBmSf48ONQDfq3ti/aZtiC1NQH
         gDnbPO6OmZQtH7DfU4SOk7WRzMZ+YbAvJ79ajN0bdlkY3t7h0gxSGA/GYzPYXRIYG8T9
         sr4i2Mlwfzqwg3c3oNlrGeMtzyI494vonC3PAOsCs88SpxJA4V5W31CXNzeY26JhNi06
         mvoA==
X-Gm-Message-State: AOAM532v92wSIdR4jWw9t+NpqaRp8EBvSt4k6/anS1q6R01SvLOREU8P
        LCgCS6JCWvLkIsoraJswwxg=
X-Google-Smtp-Source: ABdhPJwRhmuMSPzPno0siGhMNHk92zw8OgwGMcCidxyZkrxufW2DFhdK3E6obGEt5775DmVOv52ezw==
X-Received: by 2002:a17:906:dbef:: with SMTP id yd15mr11487060ejb.5.1590839538306;
        Sat, 30 May 2020 04:52:18 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 02/13] net: dsa: felix: set proper link speed in felix_phylink_mac_config
Date:   Sat, 30 May 2020 14:51:31 +0300
Message-Id: <20200530115142.707415-3-olteanv@gmail.com>
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

state->speed holds a value of 10, 100, 1000 or 2500, but
SYS_MAC_FC_CFG_FC_LINK_SPEE and DEV_CLOCK_CFG_LINK_SPEED expect a value
in the range 0, 1, 2 or 3.

Even truncated to 2 bits, we are still writing incorrect values to the
registers, but for some reason Felix still works.

On Seville (which we're introducing now), however, we need to set
correct values for the link speed into the MAC registers. Do that now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c | 40 +++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a6e272d2110d..6ba0d2c3c2fa 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -208,18 +208,39 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct felix *felix = ocelot_to_felix(ocelot);
-	u32 mac_fc_cfg;
+	u32 clock_cfg, mac_fc_cfg;
+
+	switch (state->speed) {
+	case SPEED_10:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
+		clock_cfg = DEV_CLOCK_CFG_LINK_SPEED(3);
+		break;
+	case SPEED_100:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(2);
+		clock_cfg = DEV_CLOCK_CFG_LINK_SPEED(2);
+		break;
+	case SPEED_1000:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
+		clock_cfg = DEV_CLOCK_CFG_LINK_SPEED(1);
+		break;
+	case SPEED_2500:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
+		clock_cfg = DEV_CLOCK_CFG_LINK_SPEED(0);
+		break;
+	case SPEED_UNKNOWN:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(0);
+		clock_cfg = DEV_CLOCK_CFG_LINK_SPEED(0);
+		break;
+	default:
+		dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
+			port, state->speed);
+		return;
+	}
 
 	/* Take port out of reset by clearing the MAC_TX_RST, MAC_RX_RST and
 	 * PORT_RST bits in CLOCK_CFG
 	 */
-	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(state->speed),
-			   DEV_CLOCK_CFG);
-
-	/* Flow control. Link speed is only used here to evaluate the time
-	 * specification in incoming pause frames.
-	 */
-	mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
+	ocelot_port_writel(ocelot_port, clock_cfg, DEV_CLOCK_CFG);
 
 	/* handle Rx pause in all cases, with 2500base-X this is used for rate
 	 * adaptation.
@@ -231,6 +252,9 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
 			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
 			      SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
+	/* Flow control. Link speed is only used here to evaluate the time
+	 * specification in incoming pause frames.
+	 */
 	ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
 
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
-- 
2.25.1

