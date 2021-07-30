Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FB03DC159
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 00:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhG3W6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 18:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbhG3W6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 18:58:10 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8444C061765
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 15:58:04 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id k1so12800606plt.12
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 15:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=workware-net-au.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YVFNv/nJzPFLIKlkRvy7UBoWXkQ2+gaA9RIm68msr/k=;
        b=NTj5WuC7VBzOEvsgIDQyhYVHPtwEDZMYcoRo53rEa1PGSDeWByZ2DAswqLVQbjYvTg
         YZzyHQEUXHqaHQSGnrZFD1LtNWDrJUt/a6cYq4GB/jpPCJXEBpCqbN1XxPI+tw8jTjBD
         z0sDFa3eETVYyp10gw8Fivmq+5SiQ1lNliIXZGJnUiPTBiBtPO7lXYfkgwAxKp0GhwKH
         4BubNh1FJ+RCyMdT05YFDjyYVWXwSyHU1UjE9jZyqp6b+Cs59xnanSBV1W6ojuh7u4ko
         lJLhNED9IrtPZ/MWxI1hGUgw6pgYDM2CitXy4vZnhdX0nF0FGIJeEwQFoO8TiumkLrOd
         NImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YVFNv/nJzPFLIKlkRvy7UBoWXkQ2+gaA9RIm68msr/k=;
        b=hktiKdyEvuMAk7R+IRlaxpM+shPm7VlvT/6PAGu1XP8DsSQfo5T0F7WdC2vIGE8dYR
         0mrjTDaJCUChu2zW65AFu2UQ3oBwfK51cpUn7RWwWrFSct3eMT9ZHz6MfwyNqy2z0bGV
         ggQTFbFOhXpt4z1hQlQlT5md4vik2Q/wdlzJFt3Ztr5sqNZ1hhqdP78r0Kzeseq3VkHc
         vGyFDrow3y6Ix+9oJkmjUkO3wRnmvupADcdjzfsLVwc0MXVNDaprnVBZrJPG4nf1nLzQ
         Fo5/8U8f0k+hXWC4K3hTAjkpBCsXvNKE9yQgQ795Vo31sZJRMD1BGWY2T8YlpKI37Wd2
         uMrg==
X-Gm-Message-State: AOAM5334K3K53e93Le6r1SRZRIzGfIVrNlDP9nYypM0KVniOddvo5V4H
        Kxn7T90OMFjEn/f1432D0WzAN468lLH5rJ5D
X-Google-Smtp-Source: ABdhPJzBF4R7be2jKsTzcGhAItmUSMyV319KYORwEht+h4ehzvZ4rERnKRDiE/PD79by7SBXDNPIWw==
X-Received: by 2002:a63:ff4d:: with SMTP id s13mr2849739pgk.237.1627685884319;
        Fri, 30 Jul 2021 15:58:04 -0700 (PDT)
Received: from workware.net.au (117-20-69-228.751445.bne.nbn.aussiebb.net. [117.20.69.228])
        by smtp.gmail.com with ESMTPSA id w3sm3389178pjq.12.2021.07.30.15.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:58:03 -0700 (PDT)
From:   Steve Bennett <steveb@workware.net.au>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, marex@denx.de
Cc:     Steve Bennett <steveb@workware.net.au>
Subject: [PATCH v2] net: phy: micrel: Fix detection of ksz87xx switch
Date:   Sat, 31 Jul 2021 08:57:50 +1000
Message-Id: <20210730225750.98849-1-steveb@workware.net.au>
X-Mailer: git-send-email 2.24.2 (Apple Git-127)
In-Reply-To: <20210730105120.93743-1-steveb@workware.net.au>
References: <20210730105120.93743-1-steveb@workware.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The logic for discerning between KSZ8051 and KSZ87XX PHYs is incorrect
such that the that KSZ87XX switch is not identified correctly.

ksz8051_ksz8795_match_phy_device() uses the parameter ksz_phy_id
to discriminate whether it was called from ksz8051_match_phy_device()
or from ksz8795_match_phy_device() but since PHY_ID_KSZ87XX is the
same value as PHY_ID_KSZ8051, this doesn't work.

Instead use a bool to discriminate the caller.

Without this patch, the KSZ8795 switch port identifies as:

ksz8795-switch spi3.1 ade1 (uninitialized): PHY [dsa-0.1:03] driver [Generic PHY]

With the patch, it identifies correctly:

ksz8795-switch spi3.1 ade1 (uninitialized): PHY [dsa-0.1:03] driver [Micrel KSZ87XX Switch]

Fixes: 8b95599c55ed24b36cf4 ("net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs")
Signed-off-by: Steve Bennett <steveb@workware.net.au>
---
 drivers/net/phy/micrel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 4d53886f7d51..53bdd673ae56 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -401,11 +401,11 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
 }
 
 static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
-					    const u32 ksz_phy_id)
+					    const bool ksz_8051)
 {
 	int ret;
 
-	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != ksz_phy_id)
+	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8051)
 		return 0;
 
 	ret = phy_read(phydev, MII_BMSR);
@@ -418,7 +418,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
 	 * the switch does not.
 	 */
 	ret &= BMSR_ERCAP;
-	if (ksz_phy_id == PHY_ID_KSZ8051)
+	if (ksz_8051)
 		return ret;
 	else
 		return !ret;
@@ -426,7 +426,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
 
 static int ksz8051_match_phy_device(struct phy_device *phydev)
 {
-	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8051);
+	return ksz8051_ksz8795_match_phy_device(phydev, true);
 }
 
 static int ksz8081_config_init(struct phy_device *phydev)
@@ -535,7 +535,7 @@ static int ksz8061_config_init(struct phy_device *phydev)
 
 static int ksz8795_match_phy_device(struct phy_device *phydev)
 {
-	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ87XX);
+	return ksz8051_ksz8795_match_phy_device(phydev, false);
 }
 
 static int ksz9021_load_values_from_of(struct phy_device *phydev,
-- 
2.24.2 (Apple Git-127)

