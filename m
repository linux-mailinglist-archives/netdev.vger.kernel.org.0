Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04063A684C
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhFNNrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbhFNNrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:47:05 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9D0C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:45:02 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l1so16722558ejb.6
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ooqFNZfnR/s9okR3m5H2rRBaiu37jKflQXhtJLrUE8c=;
        b=Hf/T/pqVipE4iw/vhI4QH7DtFZJPfcwaa7FWUe5tIyQACIG/NXcNef7JDogRF3Tj8C
         VfeIBW8OzCB4ZjFhr1yZPzO9PwR3kQowG4ZsowR0j/x04aElIWvN9jhHnWq2fFr1Qd+E
         hPuxoL8Ht/Hi00X03YLnmYWRvN//Id/OorNQWpYH2UXuAM6ZDhZRNHDNTbzqHDmStZqH
         V9x0PjSEiKSEV2HCC36H96FKilI1gnkzK8f0HKuzrDOhpR19prHf1zOsMtV5qESmb03Y
         i5Y4s5Fdua+tbixneiMW/OSs40c+xB8GXlC1CNn9cDs6Ra230JADd0Btiq68rZEZJhi7
         zwlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ooqFNZfnR/s9okR3m5H2rRBaiu37jKflQXhtJLrUE8c=;
        b=Pkp1Pi/nKNgYA+F2uYr+JKLWLvTDBAMY6Z65hzlkVcKCEVRSNGwkcwjB7yuOdYIkmH
         OZSotq8NnPJWAL/fo53FGU4OV78cj7PcK3e7/dCKEjNfvYE1kTe3hMrsqs1vBW3w5Jzw
         LeUKhiZiyelSfK0xqL7uocfLFffycqut4cozyV92vE42+zUJ/9NPrvrOr6gSol3U/GMD
         vw0Z3im4RS5abGHl8pxvfvOHLAAtvK4dxGBhbehYizjuRCQY1SUp+6D3e4MLjQSvRvM2
         BjK+rPzLFs4zTTqjvMAVFxVOqBgRL+4XG4LrOMDivDMzztbdA0sArsPaiHAPoEkVLVCH
         QbSA==
X-Gm-Message-State: AOAM532d26ZsxQz4uzO8ZZke4rSvIoHHdf37WEKFxEGL8s+dhMzaiA5J
        Gvs5N9EnD9eDuW9eim3MXAQ=
X-Google-Smtp-Source: ABdhPJyAlZWV0pcyVaqbLF1qmL1+BQGFJE98hcwTEJQhzfUAuRUaVA0qNOeR1piB+tTfovgr8LEmUg==
X-Received: by 2002:a17:906:d297:: with SMTP id ay23mr15284438ejb.418.1623678300738;
        Mon, 14 Jun 2021 06:45:00 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id q20sm7626891ejb.71.2021.06.14.06.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 06:45:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 net-next 1/4] net: phy: nxp-c45-tja11xx: demote the "no PTP support" message to debug
Date:   Mon, 14 Jun 2021 16:44:38 +0300
Message-Id: <20210614134441.497008-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210614134441.497008-1-olteanv@gmail.com>
References: <20210614134441.497008-1-olteanv@gmail.com>
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

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
v2->v3: none
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

