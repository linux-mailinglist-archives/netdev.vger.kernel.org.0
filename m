Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3858C471418
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 15:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhLKOCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 09:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhLKOB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 09:01:59 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A16C061751;
        Sat, 11 Dec 2021 06:01:59 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p18so8078868plf.13;
        Sat, 11 Dec 2021 06:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=S5lEl/YZSPTyWLii/zQHYRrSecSEgRYfMX2KEJm8EXo=;
        b=j0eBAXIEJjZMgY2m6PKFGmXDQpx/ndamysZeKIyHORkjeckxqs8zh/KigRizogD5Ea
         jMbdzgs1mJ995Oph+K4RkZA0w8AA0s06ZyXTXuR1ouhBVxc/dWanyox/hF83vFCqyzzk
         MflofwTgEn65x04EamT4xaBAP5VCCJVBj25U5772I8QAeUwMb4Zf8SRQXCPnVRYeI2Uf
         yqDmFdHKizpqFvlxmXpeY5aR7uWXSn0Up3VA0VdZYPEbURe3n8dM9bMQ7duO1LPkjUHJ
         j2kxGgXyTtyVrSRIHs27umZwnZ1x+JrUp3t4W+BY3vJ4SUC5qTnMcPs3nTiD7+XYVEJV
         3x8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S5lEl/YZSPTyWLii/zQHYRrSecSEgRYfMX2KEJm8EXo=;
        b=NAIfUy7TslXYzbQ3f8m0XutT1enQVYYWQ85J12tIPiF6OsgkTqsOs7FWDigIC31uyF
         B2C+MVdDhpN0ZbqNStwXoF7nnCVik+9THfjCBaR46IHQnBP2Q6bycpuWuMSkwllIswGE
         Q2vOBcjQi/K+0kWnRZpsrdaybekeH36cTHwVVIM912FI/bBz6UPz1If/6C6u8gIkVnMq
         5vqJJVQMSZ9vZR5/YOYY5KexZQqTi3V70lHpgRzPwxL/FI93ZpGpShFNVa7L92XaCEV6
         oEz4cK+qZVf/2sE12vY72iWqyXS7bbbeDTJR4zkgSzrRu+kz2b/Auk5OmvCq2ObW/jAQ
         VhvA==
X-Gm-Message-State: AOAM530zDHOHIN3BsibYfsoSE3k1CedbJ4R3J78xrNeQGIHUPsscwpa6
        C4Zz4SL+owmOLaMcwBpv+F49DDTQ33t9yTiwRC8=
X-Google-Smtp-Source: ABdhPJxzZSB8zHDw5dgrQjJ1qJb2q0iYsPRCp6yvjgQqRwxdX8x3hkAi2BT8KQcOh7bVSulj4a3BHQ==
X-Received: by 2002:a17:902:e852:b0:143:8152:26c7 with SMTP id t18-20020a170902e85200b00143815226c7mr83257431plg.75.1639231318939;
        Sat, 11 Dec 2021 06:01:58 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id s15sm2112048pjs.51.2021.12.11.06.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 06:01:58 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
Cc:     linmq006@gmail.com, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: bcmgenet: Fix NULL vs IS_ERR() checking
Date:   Sat, 11 Dec 2021 14:01:53 +0000
Message-Id: <20211211140154.23613-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy_attach() function does not return NULL. It returns error pointers.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 5f259641437a..c888ddee1fc4 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -589,9 +589,9 @@ static int bcmgenet_mii_pd_init(struct bcmgenet_priv *priv)
 		 * Internal or external PHY with MDIO access
 		 */
 		phydev = phy_attach(priv->dev, phy_name, pd->phy_interface);
-		if (!phydev) {
+		if (IS_ERR(phydev)) {
 			dev_err(kdev, "failed to register PHY device\n");
-			return -ENODEV;
+			return PTR_ERR(phydev);
 		}
 	} else {
 		/*
-- 
2.17.1

