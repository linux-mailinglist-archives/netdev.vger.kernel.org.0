Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949B8200169
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 06:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgFSEsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 00:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFSEsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 00:48:14 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D84EC06174E;
        Thu, 18 Jun 2020 21:48:14 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id mb16so8775153ejb.4;
        Thu, 18 Jun 2020 21:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+V5Jgmnw6zPAxpFlqqIwG2UnRCpwzgUpgKhoqNVxZr0=;
        b=Sm2Ju+Ypyp2Nfkld/Cp7+WPbxFJUQI1+zxzblDcwbEAqnaBo5PCkAbI1S/Sb4YqgZN
         O5BOwYB/FzhHRcSo5QdK97qodlzmfntrJ9jujkyAPvH6PX8GiYqJ5yhBMzTdrJKgjjcU
         kkL+NTaaLGdhvHnkHI9Emyw4n8Po6ynvm2UtWkyULHKBxQD64mgN+cEmk7qU5+w2zqd3
         TamN+xe3jZIa1fpKNG93VqKxTWYg7aqyPJe2CUWRdzFb3yQfmrezn0rXgHqBCuPJHkQy
         7aZrwar0cf/ZsuN8jhK73ZzBRwyCkSQj8aFtO+WO9QyaV1ARnco6Qae//LC5atq88e+r
         uTEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+V5Jgmnw6zPAxpFlqqIwG2UnRCpwzgUpgKhoqNVxZr0=;
        b=reg0JEpilDtyl95sA0aebxRL+gVUX8QjCEdICkmkvfqO3wV6BDhrE410pW5DyQZJtt
         rXvbGnRux4y+CYryVzCfgCTWzVI2vAXYgv25krHHgJrvqjzy2ZbRY14Xoou+zBzIncwL
         Ygd3oTem5v84cWm5g3RD1/z9iC092DUXQ+wSDq9AMi4gHY1w2MfaYhy1GBcQp0WT8SJ4
         R5Dr368SLHEhRRdMsfsGl0g6On/usxkTdBqDMU8Ty3VYmy90SH7fpFI7fV+we/tUU7Po
         vAFcXG0SqefSjNFqQ0p3mLSEyGO9YN7HhwmFcKpSfP46DajxelLEO1i2sB9vqepg/tnB
         tt0w==
X-Gm-Message-State: AOAM5339oAO9yhoD8Fy5tClpZ8YcjUh//iv5k58y2em+KQxtYvbjRouM
        jNVm06dEzCmNst5DKOXCEfNtDhie
X-Google-Smtp-Source: ABdhPJxxLNz8Fx8VDtqGD8X7i3DfiIprxWQvEFgNVWhrk0jYL3LKlgaFq3jgt9r7Gcbi6MVPhDfG+w==
X-Received: by 2002:a17:907:94c4:: with SMTP id dn4mr1856569ejc.150.1592542092553;
        Thu, 18 Jun 2020 21:48:12 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ew9sm3867852ejb.121.2020.06.18.21.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 21:48:11 -0700 (PDT)
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
Subject: [PATCH net 1/2] of: of_mdio: Correct loop scanning logic
Date:   Thu, 18 Jun 2020 21:47:58 -0700
Message-Id: <20200619044759.11387-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619044759.11387-1-f.fainelli@gmail.com>
References: <20200619044759.11387-1-f.fainelli@gmail.com>
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
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/of/of_mdio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index a04afe79529c..7496dc64d6b5 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -315,9 +315,10 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 
 			if (of_mdiobus_child_is_phy(child)) {
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

