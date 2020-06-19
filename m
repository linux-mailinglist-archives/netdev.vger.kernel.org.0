Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F74201AB0
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436706AbgFSSsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436700AbgFSSsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:48:04 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDBEC06174E;
        Fri, 19 Jun 2020 11:48:04 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so1247345wme.5;
        Fri, 19 Jun 2020 11:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G4jQ6kaCkE/80qgTVUSP+xSjKBqbEkPDRdzVI2XfgOE=;
        b=rjOsRP8HXYUbAJBz91Wx4xofztB1QvF9d59K1qUs1S9v2ooDfvehxRkwQ8Dw0ak2xU
         H/jrdk7lTxk+tiUYdhx6HyMmNnvvkKnOStFwuMqSoVoMzXke4CoezioYaHcs5t3BWSzX
         w+Aw6uzOyjUfdsHa+LvrMK4+OnhJpcR59sZhDM5AyDKr9eEXbPqRefOw9c48Ci+F4ll1
         gfBv+WOly552IdqrMAJUeafFAiBT57DMdeSPPV4CZqVc7tbEOdFCBCFUJcI1Vf1rDWCO
         VsjT0yp7XZ3KTdbjTh5J3eC/MiFVlDB8T9mlpBd/QvfkYKNE5ZGJXeTezdAD/3Yq1tdc
         tN9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G4jQ6kaCkE/80qgTVUSP+xSjKBqbEkPDRdzVI2XfgOE=;
        b=diEYGdE5sZDEAfVA1/OnXkbFXXTyJj0TyjTHf0LU/GFWFirKsAJbVTHHPzKio1VP6J
         fRIYunAj9obM+owXwsBbQAMv4Yj6AWE0glFWa6X7Iq87CKhgUCuhmGpzrukkVdD7M+Q9
         nDdWDNZ7eHWZTkHGw8a3RZQgNKmd5s3LLfjK37m4QnuB6nTUm6m6Lh+9hx96dtGUmkTZ
         J/cdsskjCMWuVJptjRJmn/tHL6c+j+Wk/7K5+IfO6ZWdFQpNngvCK8n9kEoxsLr2Jydb
         YwoX39SABH2WBd3juN881lGl/GBEPQUy8ZY3u3yfBT/TcU3zUiyfN6opqgiEPPYMay/1
         0lrQ==
X-Gm-Message-State: AOAM532DzwvS3HFlxLnJx0bMNZxf1DqSjdLDGSeLUP5XHOJU6F5QqELz
        +uj3btwQ4tbpICkgIARwM+V1JHPZ
X-Google-Smtp-Source: ABdhPJzRHeeqIMjoxbEf0ea72owHYeM6kJFmPMdXWT2or3nwSiZHgIF94WMxLDG3FWgVux2sfk+VjQ==
X-Received: by 2002:a1c:964d:: with SMTP id y74mr5341747wmd.154.1592592482659;
        Fri, 19 Jun 2020 11:48:02 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l17sm7283143wmi.3.2020.06.19.11.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 11:48:02 -0700 (PDT)
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
Subject: [PATCH net v2 1/2] of: of_mdio: Correct loop scanning logic
Date:   Fri, 19 Jun 2020 11:47:46 -0700
Message-Id: <20200619184747.16606-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619184747.16606-1-f.fainelli@gmail.com>
References: <20200619184747.16606-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 209c65b61d94 ("drivers/of/of_mdio.c:fix of_mdiobus_register()")
introduced a break of the loop on the premise that a successful
registration should exit the loop. The premise is correct but not to
code, because rc && rc != -ENODEV is just a special error condition,
that means we would exit the loop even with rc == -ENODEV which is
absolutely not correct since this is the error code to indicate to the
MDIO bus layer that scanning should continue.

Fix this by explicitly checking for rc = 0 as the only valid condition
to break out of the loop.

Fixes: 209c65b61d94 ("drivers/of/of_mdio.c:fix of_mdiobus_register()")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/of/of_mdio.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index a04afe79529c..ef6f818ce5b3 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -314,10 +314,15 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 				 child, addr);
 
 			if (of_mdiobus_child_is_phy(child)) {
+				/* -ENODEV is the return code that PHYLIB has
+				 * standardized on to indicate that bus
+				 * scanning should continue.
+				 */
 				rc = of_mdiobus_register_phy(mdio, child, addr);
-				if (rc && rc != -ENODEV)
+				if (!rc)
+					break;
+				if (rc != -ENODEV)
 					goto unregister;
-				break;
 			}
 		}
 	}
-- 
2.17.1

