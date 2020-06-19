Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EC3200165
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 06:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgFSEsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 00:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgFSEsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 00:48:17 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F491C06174E;
        Thu, 18 Jun 2020 21:48:17 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id cy7so29876edb.5;
        Thu, 18 Jun 2020 21:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z6pjZcvuC6hfoI30JKSQEs1lxYUwr1VGXrh+ISodyNY=;
        b=EjhitqHwM0Ddc1lu+b7bk7/9gwOyrLf50KXySN2IHjKuH90HwRdgaXJhtnkIAU1sbh
         hlSn+B1ZIN2iCaToSbDBIZ6YmgdUvjZ9gThOmkC4PrY9ZrHgpCRsj8ozR9E8gsR5mXnR
         /pqL99KNleodPg+XYOAMBFZU7B3v1v2ookoCOjD2/ozYx3xf17RdRFyDB1gSrJU7uJVz
         WU604RVnKVQ8G3YYLkyjiOxiATVfZl9U/OzFK0Bx0BiVhAejDK5QBNmbxyle6p8/nS4V
         9eqoGXrFZUm/hFw/qCrlvtwVbhZ9FZNStqZBz3Ch2wf48Wp9dLB7zQAGFk7awGUmZYMh
         1EGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z6pjZcvuC6hfoI30JKSQEs1lxYUwr1VGXrh+ISodyNY=;
        b=SIrjbM0nYP+nv1CaM/9dNCObH9k8f2JcKCHZZHkY9/ZqidPv0mW019mz2laq/YOgFw
         YhNHPBExmS+dEpxTzlBtvrcr3fLvSTn6B8PHEKD8lmAxJXycLV03RozUf5Zf2OIzj/zG
         redLlMNsktKpkaBkLVZ9hA01tcTgboGcVTKEi/YZo6M+SfHvYfX7U8j1giq+dZhvJ/n5
         5pFYiYtuqIULqgteHHyqBOZIvApyAEMys6dUF+UBP29PtOjGr25FCYBvQ82JU7D6d6/r
         cXhOHZ3pasKH6L8jDOlPBOYLz+fqb68o71dV0joPY65VKc1e2S8ywDIUWAeE4uLgfcNH
         SKTw==
X-Gm-Message-State: AOAM530EzwUCzmeW9aN0JpDmzL8oj4di+xM6jZ6Mvpagfa/0wDa3PqwF
        pxG4U5de7A2Fno7UcpE0QKUetoOI
X-Google-Smtp-Source: ABdhPJz4RJRXfOqvp2LISkOtvFVlDLIIFMYK9X3zJZqq+YkzWTe+hOEXhgfqbMS5LOi76Wg/XgP+2w==
X-Received: by 2002:aa7:d7cc:: with SMTP id e12mr1475006eds.70.1592542095630;
        Thu, 18 Jun 2020 21:48:15 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ew9sm3867852ejb.121.2020.06.18.21.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 21:48:15 -0700 (PDT)
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
Subject: [PATCH net 2/2] net: phy: Check harder for errors in get_phy_id()
Date:   Thu, 18 Jun 2020 21:47:59 -0700
Message-Id: <20200619044759.11387-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619044759.11387-1-f.fainelli@gmail.com>
References: <20200619044759.11387-1-f.fainelli@gmail.com>
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

