Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF7A1239AA
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfLQWTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:19:45 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34798 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbfLQWTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:19:44 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so166460wrr.1
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MmC76MqjhrtQ6wMnjjY260jIEM+2Ajm1PiO9i0E3y5A=;
        b=kXN3tbSKhQ8ZPYGjTHnLkCtpIwHZ1eqCGgsWcobpH5B+u3t1VE9mZgkyk1zm7WR7v0
         EGshYl8pj5QnuBt90WcVYi+JXbmUATXdsed/hv13MAesuXzW23ViDQpLBIfbHeG3Kpa7
         AlblQC6uybFmEyORmQjIAePL4fQMg8vrwVEUHQZtBQbiyhyXVQMcrM3ST52ebubIyR/R
         JNwT2yfoJ/YUHWh0Maj1+vPMMOa6hRH/KhDj5GiT0LE/druhcSKtGg2Rdqi2kMiLyYdw
         LB/FbfOyyXRx0mYRHAdqpRsUo7CPGwm/I0f2i7XHy98R/S2gRDMdx2Om5Qaj5LtCg9HU
         rwdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MmC76MqjhrtQ6wMnjjY260jIEM+2Ajm1PiO9i0E3y5A=;
        b=SWaNiG50exjO4vvJHpSn9fvk0/Qvl9IuAXyn6tdWWMWUyCahAT+wjCwlTpKKLJYR3L
         7z+mnLjGMgCJyJP41tRwjPWBRNl0qicKC+yWaFkXhL3xU9HLIh74cGTP+ETb8cXaz35t
         G4BDnr8NGCxMdhn2dLR3vTPKp9LwGG5JTPyD1H6IVACrYb8iqvuPNnpsnK+Ki6hlSOYH
         aKJW/vKh/SXgPKPJPvwxaotQPHST2ix9ANbJWI662CRlGWduYL0zLMURmnTIkPZxAnJ7
         QICmFauQx780YmrI+sPOEMqH9XL7MZE8srOXb8tBinXMqidQQzGEpoO9lrUpyW9hGtz+
         bvkA==
X-Gm-Message-State: APjAAAVn9shJDp1JbBSiGcRoZ9I8fBHl6vcj/8pZuT6j/zUYSIxpxWR3
        649zDEEm2PWNdOf/Y4Cbyi0=
X-Google-Smtp-Source: APXvYqzjQQXTaojR1VB0w6abhjyVV4XhKkYoT4xw0hAe6nSvrwTSrWeTfZjGxbFBt7hlhHeVXbGE0w==
X-Received: by 2002:a5d:6ca1:: with SMTP id a1mr38175928wra.36.1576621182836;
        Tue, 17 Dec 2019 14:19:42 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id e6sm196808wru.44.2019.12.17.14.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:19:42 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 3/8] net: phylink: call mac_an_restart for SGMII/QSGMII inband interfaces too
Date:   Wed, 18 Dec 2019 00:18:26 +0200
Message-Id: <20191217221831.10923-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191217221831.10923-1-olteanv@gmail.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It doesn't quite make sense why restarting the AN process should be
unique to 802.3z (1000Base-X) modes. It is valid to put an SGMII PCS in
in-band AN mode, therefore also make PHYLINK re-trigger an
auto-negotiation if needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phylink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f9ad794cfee1..0e563c22d725 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -358,7 +358,9 @@ static void phylink_mac_config_up(struct phylink *pl,
 static void phylink_mac_an_restart(struct phylink *pl)
 {
 	if (pl->link_config.an_enabled &&
-	    phy_interface_mode_is_8023z(pl->link_config.interface))
+	    (phy_interface_mode_is_8023z(pl->link_config.interface) ||
+	     pl->link_config.interface == PHY_INTERFACE_MODE_SGMII ||
+	     pl->link_config.interface == PHY_INTERFACE_MODE_QSGMII))
 		pl->ops->mac_an_restart(pl->config);
 }
 
-- 
2.7.4

