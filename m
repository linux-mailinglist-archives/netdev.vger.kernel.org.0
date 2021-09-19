Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF11410C37
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhISPpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 11:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbhISPpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 11:45:11 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A943DC061574;
        Sun, 19 Sep 2021 08:43:45 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id co2so4134974edb.8;
        Sun, 19 Sep 2021 08:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q3TLMvWKODKgQevKC2fILhwIeSJWa7sk0dMQgGyL238=;
        b=WWIcReOTFRvLrEOt26ndhPr6s81lKS8rh4SBA6dBl0EMVEmt+T8UmCm4DxDaBGAO5W
         dVk/dBQZ1VPmt0wKvWdiVHHUOXHNAk67wHX/lpL6Fri3AlSya4zT0lYJgC/kgCHqSLiH
         A4GNzceelhs9sffLkVQQkVBoDVAXkmuxhoIKw53h6ERp93hyD0fuxrZ8b9GLsWkezeSl
         lHIi5OWz1WSzhewiLCPvKcBYC8xcj3xmTL9sGxl90iuTTvdHm9rMIt5I64f4+DEZ70+M
         cvlFwvvUBIisqNUUY+lUcQ1dHNbMRVcwbglIvElfWLgzslNbVnajxB2NJsHfU/ojk0tt
         IGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q3TLMvWKODKgQevKC2fILhwIeSJWa7sk0dMQgGyL238=;
        b=2BI7YiaV5Dof+0UsvaXl2SYhI+0LKLhXRuHmJ/vE+/jermVov0a66PHhvAheBDU5aa
         WjBHTYlJjpx4ULwwyU4qpMHcB9zru47PeHi9WT1pzBctARzYwUDFsVNiBCFhtvqzc1tC
         sOjSUWay20LXalbQRlPRWZxIwAmmMLsMA6n/o3sa5UUYoiqor8iopFKDfpJWaAIwVl5O
         //N1XdgWGujT87b8xGLi/Ejydrgd0gvgSqW2DIw30YzQ8/mj/kDB0Zuh1MFA9rAeojUR
         360JcpA2r8+T9KChXwCK0bTKiT4PlIBKCiqOXbWolPh12Hn1OgUkT7cqoxqNnKroesOx
         VBoA==
X-Gm-Message-State: AOAM531MsiA7ge3KOKXM0/YMKuQoTYSZOVyJrKt9mHrU9tNSW2r25PVF
        zPU6WedPVq56taY4Sg0ALGQ=
X-Google-Smtp-Source: ABdhPJywXnrC1NswQbe2g/ZUD4YClju7BGrw3nFk+e1xRn2akogB88IHxce5BxZF9BPT6++UCd0QBA==
X-Received: by 2002:a50:d4dc:: with SMTP id e28mr23628210edj.106.1632066224047;
        Sun, 19 Sep 2021 08:43:44 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id g10sm4999309ejj.44.2021.09.19.08.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 08:43:43 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 2/3] net: phy: at803x: add resume/suspend function to qca83xx phy
Date:   Sun, 19 Sep 2021 17:11:45 +0200
Message-Id: <20210919151146.10501-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210919151146.10501-1-ansuelsmth@gmail.com>
References: <20210919151146.10501-1-ansuelsmth@gmail.com>
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
 drivers/net/phy/at803x.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 618e014abd2f..8156fbc7f00d 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1312,6 +1312,18 @@ static int qca83xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int qca83xx_suspend(struct phy_device *phydev)
+{
+	phy_modify(phydev, MII_BMCR, 0, BMCR_PDOWN);
+
+	return 0;
+}
+
+static int qca83xx_resume(struct phy_device *phydev)
+{
+	return phy_modify(phydev, MII_BMCR, BMCR_PDOWN, 0);
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
@@ -1421,6 +1433,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count = at803x_get_sset_count,
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
+	.suspend		= qca83xx_suspend,
+	.resume			= qca83xx_resume,
 }, {
 	/* QCA8327-A from switch QCA8327-AL1A */
 	.phy_id = QCA8327_A_PHY_ID,
@@ -1434,6 +1448,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count = at803x_get_sset_count,
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
+	.suspend		= qca83xx_suspend,
+	.resume			= qca83xx_resume,
 }, {
 	/* QCA8327-B from switch QCA8327-BL1A */
 	.phy_id = QCA8327_B_PHY_ID,
@@ -1447,6 +1463,8 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count = at803x_get_sset_count,
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
+	.suspend		= qca83xx_suspend,
+	.resume			= qca83xx_resume,
 }, };
 
 module_phy_driver(at803x_driver);
-- 
2.32.0

