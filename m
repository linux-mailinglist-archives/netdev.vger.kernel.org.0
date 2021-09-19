Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF05410C78
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhISRB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhISRBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 13:01:51 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A267C061757;
        Sun, 19 Sep 2021 10:00:25 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v22so46877088edd.11;
        Sun, 19 Sep 2021 10:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=21nowariD76inilnHAN+GS6tHZVsucKQkxTmpZSNO8A=;
        b=nI/ZfIrdiRZshKrX22QsXyQ23dbOqePQ1iP7RfIgIi8nT5A/wHc5ouYD4zeE87NyFL
         9AydgrNVvhC+N72x99S2hHOH9rnyJYeukbP9LkzzGvEiLFw0t3RgiD3G3mvLcQHRxeqB
         y5Vyit+uEB5MWoUH/10FtmDw5E3OnWgJZ5SbUwIG2S7WvH1z5lVfPW0CRx1REk65YDrv
         CXSOCqbN82/+wL3KDnYtlIY1gCADynFYS5/nLczAeFa/oPry00jygdjUmQNqPiQ1bnfT
         WbJLkEaF6A+LEvVRXEf37hKefA8qjcGUPMJKkNHAjo2OQu6l5QOmn0ggrLlp6Rx5imv9
         7qkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=21nowariD76inilnHAN+GS6tHZVsucKQkxTmpZSNO8A=;
        b=ZRYWgNCXVHb7w8/8iBh3CyBZ1/foOxa/NWwdxmvMnX9G906AhUZ8Y4hwMmcZevDvah
         9wW5hN/oSPav2tXIR/icWc1APMkuJekYYo6a+Xs6XQGH8pUbyWoT/s59alese7Ja2Mfm
         jankKyn7kpWmbVz6p/NljQBDppJvrs/pj1klJWXosqD8FrX1lkoLN0RVKhrgUCz9H1ji
         /rVXK80bql+5pQOYge+x7nnv9MhPUpgzh0RppmoxPzIYQb3YnL1lSwq0IxcZwwVbsGRk
         C4YZMCyUBmydylAjTwwXjFgkcdlMzfW2wUMyal/+2XnXbQX+3IT+3mCevmBujZX1TgJf
         9VBA==
X-Gm-Message-State: AOAM531KmvVS3M6goDv+TklwNuqmg7rGRaWjNyunKKSrZrex4bKO3JkQ
        lcF2LxVhsU660TSzqhAmUUs=
X-Google-Smtp-Source: ABdhPJxCVSP7egl5HChJYGQpu3F4RbQ11G0dgLFCNCQdJESOXPiCYyOpVFGzf3doPMaLBdusNhZfFg==
X-Received: by 2002:a17:906:aeda:: with SMTP id me26mr24259557ejb.83.1632070823924;
        Sun, 19 Sep 2021 10:00:23 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id a15sm6101760edr.2.2021.09.19.10.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 10:00:23 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 1/3] net: phy: at803x: add support for qca 8327 A variant internal phy
Date:   Sun, 19 Sep 2021 18:28:15 +0200
Message-Id: <20210919162817.26924-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210919162817.26924-1-ansuelsmth@gmail.com>
References: <20210919162817.26924-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For qca8327 internal phy there are 2 different switch variant with 2
different phy id. Add this missing variant so the internal phy can be
correctly identified and fixed.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 719860a93d7c..618e014abd2f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -150,7 +150,8 @@
 #define ATH8035_PHY_ID				0x004dd072
 #define AT8030_PHY_ID_MASK			0xffffffef
 
-#define QCA8327_PHY_ID				0x004dd034
+#define QCA8327_A_PHY_ID			0x004dd033
+#define QCA8327_B_PHY_ID			0x004dd034
 #define QCA8337_PHY_ID				0x004dd036
 #define QCA8K_PHY_ID_MASK			0xffffffff
 
@@ -1421,10 +1422,23 @@ static struct phy_driver at803x_driver[] = {
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
 }, {
-	/* QCA8327 */
-	.phy_id = QCA8327_PHY_ID,
+	/* QCA8327-A from switch QCA8327-AL1A */
+	.phy_id = QCA8327_A_PHY_ID,
 	.phy_id_mask = QCA8K_PHY_ID_MASK,
-	.name = "QCA PHY 8327",
+	.name = "QCA PHY 8327-A",
+	/* PHY_GBIT_FEATURES */
+	.probe = at803x_probe,
+	.flags = PHY_IS_INTERNAL,
+	.config_init = qca83xx_config_init,
+	.soft_reset = genphy_soft_reset,
+	.get_sset_count = at803x_get_sset_count,
+	.get_strings = at803x_get_strings,
+	.get_stats = at803x_get_stats,
+}, {
+	/* QCA8327-B from switch QCA8327-BL1A */
+	.phy_id = QCA8327_B_PHY_ID,
+	.phy_id_mask = QCA8K_PHY_ID_MASK,
+	.name = "QCA PHY 8327-B",
 	/* PHY_GBIT_FEATURES */
 	.probe = at803x_probe,
 	.flags = PHY_IS_INTERNAL,
@@ -1444,7 +1458,8 @@ static struct mdio_device_id __maybe_unused atheros_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(ATH8035_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(QCA8337_PHY_ID) },
-	{ PHY_ID_MATCH_EXACT(QCA8327_PHY_ID) },
+	{ PHY_ID_MATCH_EXACT(QCA8327_A_PHY_ID) },
+	{ PHY_ID_MATCH_EXACT(QCA8327_B_PHY_ID) },
 	{ }
 };
 
-- 
2.32.0

