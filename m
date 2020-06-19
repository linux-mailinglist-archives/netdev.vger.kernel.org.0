Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2659F201AB3
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436700AbgFSSsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436712AbgFSSsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:48:08 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C6EC06174E;
        Fri, 19 Jun 2020 11:48:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r9so9339881wmh.2;
        Fri, 19 Jun 2020 11:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3Whs9U2dRSpE/yNJ0hr4nOfl15DSo7ufbKnlcVibON0=;
        b=joFKgenJRDWLWoYPYWpZbACMvmmtHjzFTkJO26jbPB9oEUUDXakyuHH4RslDWv0kTA
         0RYTjJ4QxfK87fa9LHzx0W34y0Nf4/wC3AkmlXVXycMJnpTyWNQytrWaa1nn3gus2dQq
         Sv34LyTBKbf++QYd0XxmyWa9+1l5cjEd8hVS2Dj8/en9q8BOYVvqhCZ9ddOnWXMyo6N4
         2cQMgjnNcmZejQyxelvzqE0WZWB3sZWQ8BX+fg6Xkf9VThDp9TRU+xg89DpanGDFQtYR
         NbZu3Yab11Ueu7U6mTuQ8OZxVSRKCdjpgzK6eg3T/lu9edH8AjKi2T6qgh4lB/DIZrpj
         tz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3Whs9U2dRSpE/yNJ0hr4nOfl15DSo7ufbKnlcVibON0=;
        b=tndOXzmfNWL2auRpF2vnDjqXKpr345ROrwa3XPnES8l2JbikEgD5sdrzFvjDpyi2D0
         yHFtziYzKqIhZK9KV72belZ99UoGU7l/NgRkg+cr6lx4suUkh6jVXT10nZHelFFhieit
         NGkr/PLlEn8Q1WVnMDw7kxGmNrMt0xjOR3umFw5EGukrcHBJWGY2zKiKUPXh8xgEh0T6
         GsgeVTNAC/SJF3/cXv8n7EOxmD2BS143wif3b/+YIske2BYbZfIIeEZ/BdNcO+W3Q7oA
         kaQVEj0B7W5TTGzQ1FGDH6J5JlLjyyivaHG2gE8Y5+gz+Wshi+Vj3Mg2itcl26NariMT
         5ogg==
X-Gm-Message-State: AOAM53228VWZhO5alemD7KVKJasVX9Q0k+Wr7uYZWZlDD+829dNdkJJW
        W2xeNXWYtOFJn7ltseIXQxZLc6nq
X-Google-Smtp-Source: ABdhPJwA4vEG2fwJzEOu1QDvZNpPXDY0gUgNGWH2NXKjcens+gwoTzLZMN8JAF5I3KrCNbFbE4+/sQ==
X-Received: by 2002:a7b:c0c8:: with SMTP id s8mr5315469wmh.134.1592592485614;
        Fri, 19 Jun 2020 11:48:05 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l17sm7283143wmi.3.2020.06.19.11.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 11:48:05 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Dajun Jin <adajunjin@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org (open list),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE)
Subject: [PATCH net v2 2/2] net: phy: Check harder for errors in get_phy_id()
Date:   Fri, 19 Jun 2020 11:47:47 -0700
Message-Id: <20200619184747.16606-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619184747.16606-1-f.fainelli@gmail.com>
References: <20200619184747.16606-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 02a6efcab675 ("net: phy: allow scanning busses with missing
phys") added a special condition to return -ENODEV in case -ENODEV or
-EIO was returned from the first read of the MII_PHYSID1 register.

In case the MDIO bus data line pull-up is not strong enough, the MDIO
bus controller will not flag this as a read error. This can happen when
a pluggable daughter card is not connected and weak internal pull-ups
are used (since that is the only option, otherwise the pins are
floating).

The second read of MII_PHYSID2 will be correctly flagged an error
though, but now we will return -EIO which will be treated as a hard
error, thus preventing MDIO bus scanning loops to continue succesfully.

Apply the same logic to both register reads, thus allowing the scanning
logic to proceed.

Fixes: 02a6efcab675 ("net: phy: allow scanning busses with missing phys")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 04946de74fa0..85ba95b598b5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -794,8 +794,10 @@ static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
 
 	/* Grab the bits from PHYIR2, and put them in the lower half */
 	phy_reg = mdiobus_read(bus, addr, MII_PHYSID2);
-	if (phy_reg < 0)
-		return -EIO;
+	if (phy_reg < 0) {
+		/* returning -ENODEV doesn't stop bus scanning */
+		return (phy_reg == -EIO || phy_reg == -ENODEV) ? -ENODEV : -EIO;
+	}
 
 	*phy_id |= phy_reg;
 
-- 
2.17.1

