Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE0147EA90
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 03:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245461AbhLXCPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 21:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbhLXCPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 21:15:06 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CF3C061401;
        Thu, 23 Dec 2021 18:15:06 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 2so6352244pgb.12;
        Thu, 23 Dec 2021 18:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=+u80chd0X9IdJbC9rzVa4i2Ic75GmOj9yENvhOzHlCY=;
        b=eWerUxLhX08ma0gyDkT8WzZQK1o79q5638ooWjYSRttVegdMABmLjs+KP/hcBKHhMo
         StRsMGRiXarH46psOk95RKyAfWTP5n11VRNoiiV8DaaxMxjDUsA8ccnDR+mquHlLyvOd
         sL4wb/psKaTLLC1LZvgptDiP32lIrarYjJc9wFsodL68LFuVjPOh5Tuf+7H5or70YEVX
         Xuxym5VWqma5hrhvZ8kFeUS1oDYM9DvAHg6DCil5P8CEYUj4+3RLTiEg9ASmM3CX9uoa
         cSMYZ2FE1S/w6aFWgMYyDfgXr1Di07rUg+p0mPFRC1sEaX9SvXJO2/iA4EODIPpRGI4a
         MggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+u80chd0X9IdJbC9rzVa4i2Ic75GmOj9yENvhOzHlCY=;
        b=FNHiAMsnrcmNtmY6lqrT1b5MpxzdG0WTsdWOmPAQI2tzEJHUfnxmSOjRkfTqXfvlst
         M0Wtue+ACX9X9B9xpeyI3qZ2CcktsTCFfZpNqBKS9BcP5IBx/g81aHYCOmr5hVRL535+
         FLoojD/+DxzLUOYxpg2xksdTluWnw4r97ThneXfI0blVUhuZuXOpsPxDBbNHCXVLb8Ju
         fqDRLPJqQBsNCNtq8SXhBz0kaoEzYJBZA/BkZDJdH7V6nNwwJKulMpMNcBk9qURxVzrU
         7/0jgvn+j/CoEkc3RWRH2hZhcJhcsQxA/PQ8znjkdhclLja7cRnRamwTe1sbyT0KZK1f
         YIrA==
X-Gm-Message-State: AOAM531YyOaJqhmyqoccGP76P8BU/YxZ2h2YobK66EM0V3g1kO7Hvks4
        hJWKP64788DZ45FZy6YyXJM=
X-Google-Smtp-Source: ABdhPJynCA6P9/woMAiJH6+7MUSjDD0Se4EqhrD7wr2wYeB+2u+TxFyISICUOSSFGlOEQKfw/LX1WQ==
X-Received: by 2002:a63:86c8:: with SMTP id x191mr4214239pgd.475.1640312106169;
        Thu, 23 Dec 2021 18:15:06 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id on2sm10285245pjb.19.2021.12.23.18.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 18:15:05 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
Cc:     linmq006@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register
Date:   Fri, 24 Dec 2021 02:14:59 +0000
Message-Id: <20211224021500.10362-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fixed_phy_get_gpiod function() returns NULL, it doesn't return error
pointers, using NULL checking to fix this.i

Fixes: 5468e82f7034 ("net: phy: fixed-phy: Drop GPIO from fixed_phy_add()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/phy/fixed_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index c65fb5f5d2dc..a0c256bd5441 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -239,8 +239,8 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 	/* Check if we have a GPIO associated with this fixed phy */
 	if (!gpiod) {
 		gpiod = fixed_phy_get_gpiod(np);
-		if (IS_ERR(gpiod))
-			return ERR_CAST(gpiod);
+		if (!gpiod)
+			return ERR_PTR(-EINVAL);
 	}
 
 	/* Get the next available PHY address, up to PHY_MAX_ADDR */
-- 
2.17.1

