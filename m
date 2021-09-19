Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2590E410C7A
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbhISRB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhISRBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 13:01:51 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67795C06175F;
        Sun, 19 Sep 2021 10:00:26 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id c22so51169205edn.12;
        Sun, 19 Sep 2021 10:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=19lsN6f/KlOPR5hqb4/mwEXZyNouLZoH3YnozNMBbu4=;
        b=Fk6pLsojfxzs3j5NpN8mKdOPdNs85bxweJ5SOcvWW2FDEe48xUlh0XF2IvDc9oXDtJ
         VJ/V+7Ujhvp/TsXsclp5Fvjj4tPU2b5n2iOOViS2W4uJRdvpTK7iYfnr+tfoj/yMn6No
         8XxZrC8sFHpMBREoTVe8A2pc5THnc9+kDu8FXuM8CYS1ZXNYqf6UycxXoSOIqHYUSYoE
         lqQ1lv7Nm/qoHpC0fhObl8teiJ6HME0JZb5ze/ndyrC/A+9WFCNCjakd54YL+FgwW/gZ
         fxLv7UBxtT+0FV4k+Tc+jCRkh2vJKqWShPrj15lyDr4FNQLYG5O+VLOR4+ysfhj3PKeJ
         o4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=19lsN6f/KlOPR5hqb4/mwEXZyNouLZoH3YnozNMBbu4=;
        b=KkZdNT+xVw+K1EeOfFrKac/r2d2Wg0TR4Q86AfMTHeuqPH5cm1saVCRamKW5JSbtji
         vf2Xj9XyJyRAye538EAuIpkNgH4CrmdktvXQ98rXE4bSFwwJQ+i2GybWGyz1b0wvemB3
         iMOfhHJ+FqBjbpGpJCB71J0SaZ6WK36W9SdYIDONXcJafNZztozaTqH8GgicFsm74U5+
         gkDk+d5atUfG2hfxyM2pAzgwbFafN6ps9Aga6M/KXDGiWVhyF0Mj04e9rLOGGaCDAmhS
         GFC7kHfAuyXxOzpQw3U5KshUcX983wNTQH2yal9McgNEeCIEFYel6iVb043imNW1Clb4
         Db0w==
X-Gm-Message-State: AOAM532JBRd6L0n0OnoDyl8LtrF+D/mQWwqz6Z6/micgz4Nna4szyEm5
        AfdX4VgLkdApapeSffcSiB8=
X-Google-Smtp-Source: ABdhPJxklihdxhOkeKnWjxZjebLyIhtURDNz+tfpk2gJ9n4mVFL2lWaMB+oNyh/lBRptqGb9iiyEvQ==
X-Received: by 2002:a17:906:cc0e:: with SMTP id ml14mr23081516ejb.395.1632070824898;
        Sun, 19 Sep 2021 10:00:24 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id a15sm6101760edr.2.2021.09.19.10.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 10:00:24 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 2/3] net: phy: at803x: add resume/suspend function to qca83xx phy
Date:   Sun, 19 Sep 2021 18:28:16 +0200
Message-Id: <20210919162817.26924-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210919162817.26924-1-ansuelsmth@gmail.com>
References: <20210919162817.26924-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add resume/suspend function to qca83xx internal phy.
We can't use the at803x generic function as the documentation lacks of
any support for WoL regs.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 618e014abd2f..db432d228d07 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1421,6 +1421,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count = at803x_get_sset_count,
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
+	.suspend		= genphy_suspend,
+	.resume			= genphy_resume,
 }, {
 	/* QCA8327-A from switch QCA8327-AL1A */
 	.phy_id = QCA8327_A_PHY_ID,
@@ -1434,6 +1436,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count = at803x_get_sset_count,
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
+	.suspend		= genphy_suspend,
+	.resume			= genphy_resume,
 }, {
 	/* QCA8327-B from switch QCA8327-BL1A */
 	.phy_id = QCA8327_B_PHY_ID,
@@ -1447,6 +1451,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count = at803x_get_sset_count,
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
+	.suspend		= genphy_suspend,
+	.resume			= genphy_resume,
 }, };
 
 module_phy_driver(at803x_driver);
-- 
2.32.0

