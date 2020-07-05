Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F085214DF4
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgGEQRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbgGEQRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 12:17:02 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD22C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 09:17:02 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a1so39853848ejg.12
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 09:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eJ1r/+RQWGN/YjBr+N6vsrzuuPU8mpSDjWAOMgKI6LA=;
        b=iSnVEsE/q9N+p1O0EmFYq8TwpLgci3uchyaPlsaj943gWWyU26UIyqk+Jdi1bHgiAj
         Asavr/xnOLrUWwU85URYcZPUUcQ8IGXx+ccDIfkRMl27zJSVBCaJRWKXZ0UOM+isPIqL
         KjnxZTCisEnhnjTESfoLobhyItH+Xa7hJ6k1Yl+GxWXpktW6B9vTSx70zEYrwXc++X+R
         O9IowG6rivkPkg1xToj9cmDnKLskbu4/5ApsQguD/jkiMaBJ8JCAfE85D/Qa8eioLugK
         j5Chu8MqFlojWiKoDeM39QjL6ijmqcgtqmI+ljKI0Nyq1J95ZCZ3lS+YUqiyz2+ghcxa
         4OAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eJ1r/+RQWGN/YjBr+N6vsrzuuPU8mpSDjWAOMgKI6LA=;
        b=Dv2bXTia7esKan4twQRamRO3gD1Xh6YhGMTpxFbb5gtxSvazh2ujsJ7Xn6XZDR16o5
         qt816YUpUzm3ozd8H62u9Vp2RtTOokNp4oghfhNg3fkBr6Zk9y9fGqXKeT87tWoAjVGV
         3sb4NjbTAzTiTnURZVDOIyye3xmvHSwpvNPe13kg/3F46NUK/9qdTH+bP2ZJ8YGDYP1W
         p33HFn+mAKUlJdr+ca3t/YvSomWHxqWi7SgkF1MiK4gKHSAZxoo2ymzA7d8JtieEqxkl
         Fofes2glwXAT8BaEQygG4Y8yQY1X0PYm8M0jYUHIE+FUPVpM2pDWll1S+xDbqHv44mpY
         JrnA==
X-Gm-Message-State: AOAM533vnTglaePJSOlEehigyYaOEX9K+KFIgfa8SByTc/2IXhEJ93hW
        zrVvF5+tuInQ5exEypp8cdY=
X-Google-Smtp-Source: ABdhPJwSyqdVyHSu3Ps8K5kb7RbdaPoCTK52rndjbWxc9VEkq57B5InDsz2JkCpl6uL5vMLyzVp7CA==
X-Received: by 2002:a17:906:66d0:: with SMTP id k16mr41239498ejp.293.1593965820754;
        Sun, 05 Jul 2020 09:17:00 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x4sm14406126eju.2.2020.07.05.09.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 09:16:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v3 net-next 4/6] net: dsa: felix: set proper pause frame timers based on link speed
Date:   Sun,  5 Jul 2020 19:16:24 +0300
Message-Id: <20200705161626.3797968-5-olteanv@gmail.com>
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

state->speed holds a value of 10, 100, 1000 or 2500, but
SYS_MAC_FC_CFG_FC_LINK_SPEED expects a value in the range 0, 1, 2 or 3.

So set the correct speed encoding into this register.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4d819cc45bed..4684339012c5 100644
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

