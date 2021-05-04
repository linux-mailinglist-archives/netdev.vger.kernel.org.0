Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E04137327A
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhEDWcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbhEDWa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:58 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F896C06134D;
        Tue,  4 May 2021 15:29:55 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id f24so15589419ejc.6;
        Tue, 04 May 2021 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Rb9zhGkjreXvEODmFSjXwmg18fyj2Nk6lMdYtBrlH0=;
        b=KpTOeqzKLQs7ruCUBEYAeWboOVF3yXgN8O64C+6PhlkXccnl9V6a0P7MoKGXCI/ZWu
         cRnSyaU6zCXC6vqRGqBRCZBMtDTJqIrICM+FhhO3uzKy8FN3LQ+iD9N0lcz0Mu6obQCx
         MOlyJZD9gvrPbEfLzfLun03lCuMPArXik/+x3OGG96m8aAl0nmNGqqdEhT+pz+EJSy6c
         9EM2+7PVUhDTT6WoaNPrP8X1Gq/2KTAy0SStzkdRDwohI41sxVpaOBWyTk8VPNgQJi4S
         ALj3aWRSoasPniGnUFbsiMC4xSUH5JdPcEdo4JcmFf6Fr/vD6J1oA+BTP2k2DU4pYyRf
         BFtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Rb9zhGkjreXvEODmFSjXwmg18fyj2Nk6lMdYtBrlH0=;
        b=oxlNeoszjiJKzPMSzgJskIQnw38z1s58K+noAtXEYjDCkwvxRhaBqdzoBoL2gLfEB4
         P1IzLbyt25e84OtcFLVN/i0bVoZa6xWCOgpV+GAJT5mlJCCV6KtF/PApkJi8YcaMs/on
         hRRJHeAKe+qVSL+YzBhgdPUDammVMLgofvxj6cylqcBe0veDdMzBTK/cl2ezJFvF3SAV
         haWiyQk6nIX6YyUBfGkcfPr6c6FFxVRdqLYqipkhy9zonwoh9fRKk6aHKCb+ZeHdZfqM
         hrld0D2ekNFaE7O2h6uJTwSo01cUGxI3wdjuG5YbeRtcvf6Rj0t07fYUxVd3Q64oWwiw
         Xeng==
X-Gm-Message-State: AOAM532hTK3qE6xyHRFlTa/n+G35/gqCly/SbRdhW+Xd3YzfSTXOGghj
        hPo7iXfTmePNvWJhBbs3OAQ=
X-Google-Smtp-Source: ABdhPJyiHqzxkOenoq/KZJ8+qF3wzD0AjmDuaBQqFlWv6P4ZCLb3Nj2YfNJcl8JlVID0Ew5t/7GgGQ==
X-Received: by 2002:a17:906:430f:: with SMTP id j15mr24147869ejm.543.1620167393715;
        Tue, 04 May 2021 15:29:53 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:53 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 18/20] net: dsa: slave: pass dev_flags also to internal PHY
Date:   Wed,  5 May 2021 00:29:12 +0200
Message-Id: <20210504222915.17206-18-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
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

