Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C6A20A1D3
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405819AbgFYPX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405394AbgFYPX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:23:56 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F78C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:23:56 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id m21so4507596eds.13
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ne2fGgNBRhlxGm756ypk1EShFRK2zh9jHD0nEGHpNdk=;
        b=mzBBq9oDWgfgfIOkXu5TvmItGU3ru7WVjikPazMKhNWJx2z3nW9yjBxPeO8hsCIPyR
         b3VP5Hm/TKFiyQsVJSfMXVXb2BbtPTPqYFr4NlwdWkhjMZg4PnByskv6+tdCqQuKsDwT
         BtQE4MrepWdwbUkIrVqWTyOSLA3Jaj4foTrtGScuPL6FMM0aBxIR/tE5NvXLfsqFog2I
         xqMi8H6OyK9XDbBZ7ITpCFMG43LJz0n2b8IXJCiJZSxT8NTDotgF65mm2EnN71QL6eaD
         jMwp9IFCcnh77zeugq39UOsS0dYuyyRz0Qm0hA4dihbg3gc6S8n5QK4ksbdRHm4rSzzU
         +JCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ne2fGgNBRhlxGm756ypk1EShFRK2zh9jHD0nEGHpNdk=;
        b=L3nbzlOiORJfzkfDQu2XHZLC4gKIeddNwZGb/cIEOn//yUdsh3HmNF9UBu6BTfxk+T
         sWwenBo4ONAmGEijeLd0dD32rkLxkWYPsQxACa94+wTK4R05ljdORgak7cZz9+6pd2yw
         b21KeYDbLPp5RTvJ2E8Cb9qJi6GggkwZk6/mPD7S0sDwgS/ZtveQWVrxqHnrBa5G8LHH
         4ESJkKmDH+Xft3J/rjslkfu9ilkxMKH73dpQpFug8rcsVOOvQfOaLSS1qNbof7H3HgPG
         rcEszqZmr+YPFCtpqr0oMNaBwdA3w7iff9S/5aWNtFirtj7XKc3sN3IiXgmh8ErAZgf7
         yC/w==
X-Gm-Message-State: AOAM5324F/J8rotOW5WiSKTfvb0icKehj1oPD017dzhPrj9efQgYBhrF
        +SfBQOnmY4us8QlviIBoVTY=
X-Google-Smtp-Source: ABdhPJzfDAbh9mylWFY+UG1PJEScLIuqfhfWPXCp9d9QdpEp/qFypYcxICgQ2l3bYRtdsJCoXAVrIg==
X-Received: by 2002:a50:c219:: with SMTP id n25mr32943067edf.306.1593098634721;
        Thu, 25 Jun 2020 08:23:54 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o17sm9102898ejb.105.2020.06.25.08.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:23:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH net-next 4/7] net: dsa: felix: set proper pause frame timers based on link speed
Date:   Thu, 25 Jun 2020 18:23:28 +0300
Message-Id: <20200625152331.3784018-5-olteanv@gmail.com>
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

state->speed holds a value of 10, 100, 1000 or 2500, but
SYS_MAC_FC_CFG_FC_LINK_SPEED expects a value in the range 0, 1, 2 or 3.

So set the correct speed encoding into this register.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d229cb5d5f9e..da337c63e7ca 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -250,10 +250,25 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
 			   DEV_CLOCK_CFG);
 
-	/* Flow control. Link speed is only used here to evaluate the time
-	 * specification in incoming pause frames.
-	 */
-	mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
+	switch (state->speed) {
+	case SPEED_10:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
+		break;
+	case SPEED_100:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(2);
+		break;
+	case SPEED_1000:
+	case SPEED_2500:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
+		break;
+	case SPEED_UNKNOWN:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(0);
+		break;
+	default:
+		dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
+			port, state->speed);
+		return;
+	}
 
 	/* handle Rx pause in all cases, with 2500base-X this is used for rate
 	 * adaptation.
@@ -265,6 +280,10 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
 			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
 			      SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
+
+	/* Flow control. Link speed is only used here to evaluate the time
+	 * specification in incoming pause frames.
+	 */
 	ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
 
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
-- 
2.25.1

