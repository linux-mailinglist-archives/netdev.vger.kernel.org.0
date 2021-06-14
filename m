Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FB93A66BF
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhFNMku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhFNMkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:40:49 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC6EC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:38:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t3so46323757edc.7
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1dYl3Kq+JFZzxYNsivQciO5XjSWe5kfJOeGII+f4+dg=;
        b=m1kP/Q8DamNCHyaxwC6FUoLrREq/820jRmx8xKCiiJ6XTHG4Y6JgurbB9kmjdWMERs
         c5+zQXAL++NA0YtSD5u8RgmN3MinHwVCoXk9qWS8cCorypfCBHjnXkAcQsgwsMoyN9BQ
         FnuHWtMSj81mlazl8KTDb02k5mzueS3XGRhXa0HL1WjnMnDF/6lYuYX1cUolO9KnbEy+
         VjIElmSq11P5j8cN+adci7WHYzTXoG0uxhsiZq1nM9rbRhKeiosgKFkTv3PFLW5aFjtu
         sI+8tkvHpUHjm7xWbDR30VB5R9xF/1CoQ1eSSxzS+wjPFP3XqL3r/6jeAU2MYNhlUXN2
         LKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1dYl3Kq+JFZzxYNsivQciO5XjSWe5kfJOeGII+f4+dg=;
        b=J/ZLgSX03CEsr4f7kFDmSr9Ausb1k2zZzJkMMZBAhUGoCxXzUyvkdO+JGkis1pBle6
         Wk+wp6ctCEeac2/8z/ivHqvZGT6bUrEb2z6hCYKefrS0czhI50BrJDwwRdrF5QiWSpWK
         3lUtx8zY1JI1zT/lN0ihbmybX0CaKpdTvhqtb7Y6N1rF849E56ecE7Bt4CBp30j81U3W
         QOFX7Mhn+rFFCFLELX3ujN2CSYgEDH7o83j93xTGZT9WEyVTZxPEdUAoAyODtX97KQI4
         9ssoZEnnbpaEjGTdtBMQhfAcHuKCQN9KnaQTNKcuuN3zdfECrIpnXKmJqkwmfgzIQRdw
         K+HA==
X-Gm-Message-State: AOAM531+KQ7wPOL+BE+3+8ybYuIIktfXdNxf6S3WlCyolO40CQOxefhj
        aG/SjVBTeQBKZ8uberNA9fo=
X-Google-Smtp-Source: ABdhPJxgSmAqxdzeaQNYn++htj9mXTRbPIoynbxZ/tJ1sFN/cDy7DYNHoW+iBmUpikDCAEMK9ePyYQ==
X-Received: by 2002:aa7:c7c7:: with SMTP id o7mr17076527eds.231.1623674310497;
        Mon, 14 Jun 2021 05:38:30 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id f6sm7157965eja.108.2021.06.14.05.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 05:38:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 1/3] net: phy: nxp-c45-tja11xx: demote the "no PTP support" message to debug
Date:   Mon, 14 Jun 2021 15:38:13 +0300
Message-Id: <20210614123815.443467-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210614123815.443467-1-olteanv@gmail.com>
References: <20210614123815.443467-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1110 switch integrates these PHYs, and they do not have support
for timestamping. This message becomes quite overwhelming:

[   10.056596] NXP C45 TJA1103 spi1.0-base-t1:01: the phy does not support PTP
[   10.112625] NXP C45 TJA1103 spi1.0-base-t1:02: the phy does not support PTP
[   10.167461] NXP C45 TJA1103 spi1.0-base-t1:03: the phy does not support PTP
[   10.223510] NXP C45 TJA1103 spi1.0-base-t1:04: the phy does not support PTP
[   10.278239] NXP C45 TJA1103 spi1.0-base-t1:05: the phy does not support PTP
[   10.332663] NXP C45 TJA1103 spi1.0-base-t1:06: the phy does not support PTP
[   15.390828] NXP C45 TJA1103 spi1.2-base-t1:01: the phy does not support PTP
[   15.445224] NXP C45 TJA1103 spi1.2-base-t1:02: the phy does not support PTP
[   15.499673] NXP C45 TJA1103 spi1.2-base-t1:03: the phy does not support PTP
[   15.554074] NXP C45 TJA1103 spi1.2-base-t1:04: the phy does not support PTP
[   15.608516] NXP C45 TJA1103 spi1.2-base-t1:05: the phy does not support PTP
[   15.662996] NXP C45 TJA1103 spi1.2-base-t1:06: the phy does not support PTP

So reduce its log level to debug.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v1->v2: none

 drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 512e4cb5d2c2..902fe1aa7782 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1090,7 +1090,7 @@ static int nxp_c45_probe(struct phy_device *phydev)
 				   VEND1_PORT_ABILITIES);
 	ptp_ability = !!(ptp_ability & PTP_ABILITY);
 	if (!ptp_ability) {
-		phydev_info(phydev, "the phy does not support PTP");
+		phydev_dbg(phydev, "the phy does not support PTP");
 		goto no_ptp_support;
 	}
 
-- 
2.25.1

