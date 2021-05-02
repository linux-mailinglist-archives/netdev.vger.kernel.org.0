Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C576370FA7
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhEBXIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbhEBXIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:23 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80215C061349;
        Sun,  2 May 2021 16:07:31 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id b25so5208157eju.5;
        Sun, 02 May 2021 16:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Rb9zhGkjreXvEODmFSjXwmg18fyj2Nk6lMdYtBrlH0=;
        b=NMbGBLARrklBXU67t0W06/RzdN6xJtvSI6hJxSeB3yOQWoLKn0oCRrXzHMmmWm5h/B
         kYcs4t8u/iqL7VvTsL746r/ZThSz/huMXAVbS1gRhCg6aPOKNCl4Rm/0iLMTm4in/I2k
         atZxi7sJB1BcgPrkQ1QRr6GO9O6y05qfoichyMjxXe2rYAUN5hWx9NpceT9ffFxMVbg1
         zfIZvPF1J0EdJcbjlYU7vRpquN/zqAAGVlXGMjO2EcpF3ZZB7tLjkfJNzSHUCOxSvetx
         8wBKYH/svQFCPhdq85Rr2dU6irWlLJGKyWT4utffwPXwGI4z+Cju3g9hyPiU5aBuok7v
         irUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Rb9zhGkjreXvEODmFSjXwmg18fyj2Nk6lMdYtBrlH0=;
        b=DNwqFzbFLxneVkcAM0Rv7qEp0lhS6p9QrIcptrSYwftbWfXx5QXNvXVDtuYhqabH84
         VXiR9TnAGQF2+i8PzydSqDp7Cj4HBExcI7vKDgHk5G8q6/8sHNiaaj/gwk/pKrmxYQRR
         Lz30cIvwxKXg2q6ywqYO+XiKZUM6GOy3S69pWpyPNAhx+OMGmqPZ5vmM4KtDorkZOzQZ
         INDiLYHD4sxwYCC7/bzsgljh+mH6wP7yrrVCgrbfXI6H580tajYjgDfnpuJvHXWiYrWM
         H9QH8JPf37D7wKhcDg3uawQjJdKF1yW4pdre7Qad3g0yeU2s69IrSOLmh/N3TomHwiL1
         UP+w==
X-Gm-Message-State: AOAM5322nysJeDLzumQybF7yAz/h5n+n/WmQ2W6Jty9LA3QUa7rNrqDo
        b2FPCvoSTo5yCci9PN22c5w=
X-Google-Smtp-Source: ABdhPJwe/vITAlmSq7MbdrafUnrvcBNznUki+aEO/pMjUh7wC2aAxmT2o6xdIQKBn2nm3ye4iPG2Jw==
X-Received: by 2002:a17:906:7d82:: with SMTP id v2mr14390696ejo.524.1619996850215;
        Sun, 02 May 2021 16:07:30 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:29 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 15/17] net: dsa: slave: pass dev_flags also to internal PHY
Date:   Mon,  3 May 2021 01:07:07 +0200
Message-Id: <20210502230710.30676-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to dsa_slave_phy_connect to properly pass dev_flags if
defined by the dsa driver.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/slave.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8ecfcb553ac1..339280330357 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1707,7 +1707,7 @@ static void dsa_slave_phylink_fixed_state(struct phylink_config *config,
 }
 
 /* slave device setup *******************************************************/
-static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr)
+static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr, u32 flags)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
 	struct dsa_switch *ds = dp->ds;
@@ -1718,7 +1718,7 @@ static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr)
 		return -ENODEV;
 	}
 
-	return phylink_connect_phy(dp->pl, slave_dev->phydev, 0);
+	return phylink_connect_phy(dp->pl, slave_dev->phydev, flags);
 }
 
 static int dsa_slave_phy_setup(struct net_device *slave_dev)
@@ -1762,7 +1762,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		/* We could not connect to a designated PHY or SFP, so try to
 		 * use the switch internal MDIO bus instead
 		 */
-		ret = dsa_slave_phy_connect(slave_dev, dp->index);
+		ret = dsa_slave_phy_connect(slave_dev, dp->index, phy_flags);
 		if (ret) {
 			netdev_err(slave_dev,
 				   "failed to connect to port %d: %d\n",
-- 
2.30.2

