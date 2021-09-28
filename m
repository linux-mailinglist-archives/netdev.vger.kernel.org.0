Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E4841B87B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 22:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242785AbhI1UmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 16:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242774AbhI1UmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 16:42:02 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE60BC06161C;
        Tue, 28 Sep 2021 13:40:22 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z24so1173859lfu.13;
        Tue, 28 Sep 2021 13:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgizGkLkXPS9gvBHE9FX2g3T10XoCNyE1O2S+oLIjrw=;
        b=ki1+waXFL/KbSQt1rI5nmEOaIBCufx2k8fcgszwBlA7KXVNVWsBft+wb08FGudDXbm
         rnPN5R6oMMpw97CERJOsSVKCGxEbZNtmCM1svcadg7vCA45qq2eRU9K7P6b/ZC82whpD
         0opqaBkPRnqlIetNvlBjl8VhPXRBKSIf0Q63xQKEAqOwBCo5zoE+3NLOWY/Ss14QUKEU
         2PJtK8AYSskS5OHQtIhdMDaBPixEGQVk4r83kYpzrsMxWVcNPWXWo7S3FdiPjtLHCZZ5
         ygCtNSQ7pNIIClzZr7otzC6kaxIVzSSYrRZrgnPYYz2hPRMQAUYz3hrjmllwYbNlvv0j
         o21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgizGkLkXPS9gvBHE9FX2g3T10XoCNyE1O2S+oLIjrw=;
        b=tdNBait6nn7OTG+RKlr7zM6PEjxQHEanIGM587hKNtBhQo7wIhJfbW98YND/GjHktV
         I6gTi53zNL6OWY1Et1cfLff1KA59Pbi0KMHLJNvGR/R56Zu863ldu/PeNLnvexNmASdS
         3lEuec0NUq+EIP9I7HSSTKvhShxtdXUti3PMtEF61ttyi8bIJS4vMPjXP0nr/jqAZP6B
         CIWdm/EHqQg/KL/FwYtkAdErWZuUi9lMXjD2XkaDy7iM23upvxccCPY6aQ108LNFgoV2
         kmF3wCwHHmT2ZxaiGZiTgh2UVHSaSJ2Jl00fp6FpIQQQJ4oImDUF8Cxww4+QrhwlMTQK
         Ycqw==
X-Gm-Message-State: AOAM532x4VfyhdyRUKC6KPfxjAhYypZh9AXqfFGJDeeX98T02mjET1KG
        K+Lx93JLuQPOlbsCL4F+6Jg=
X-Google-Smtp-Source: ABdhPJwU4MZdQsvvoKbHqbgp3s6cfLrkdjC1Layzkld6Oiwp4WwMSC1wn4vELaFHr1tUVPqI+0SrOw==
X-Received: by 2002:a2e:22c3:: with SMTP id i186mr2003739lji.255.1632861621127;
        Tue, 28 Sep 2021 13:40:21 -0700 (PDT)
Received: from localhost.localdomain ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id n9sm7566lfu.88.2021.09.28.13.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 13:40:20 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com,
        afleming@freescale.com, dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Subject: [PATCH v2 2/2] phy: mdio: fix memory leak
Date:   Tue, 28 Sep 2021 23:40:15 +0300
Message-Id: <55e9785e2ae2eae03c4af850a07e3297c5a0b784.1632861239.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <2324212c8d0a713eba0aae3c25635b3ca5c5243f.1632861239.git.paskripkin@gmail.com>
References: <2324212c8d0a713eba0aae3c25635b3ca5c5243f.1632861239.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in MDIO bus interface, the problem was in
wrong state logic.

MDIOBUS_ALLOCATED indicates 2 states:
	1. Bus is only allocated
	2. Bus allocated and __mdiobus_register() fails, but
	   device_register() was called

In case of device_register() has been called we should call put_device()
to correctly free the memory allocated for this device, but mdiobus_free()
calls just kfree(dev) in case of MDIOBUS_ALLOCATED state

To avoid this behaviour we need to set bus->state to MDIOBUS_UNREGISTERED
_before_ calling device_register(), because put_device() should be
called even in case of device_register() failure.

Link: https://lore.kernel.org/netdev/YVMRWNDZDUOvQjHL@shell.armlinux.org.uk/
Fixes: 46abc02175b3 ("phylib: give mdio buses a device tree presence")
Reported-and-tested-by: syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	Removed new state, since MDIOBUS_UNREGISTERED can be used. Also, moved
	bus->state initialization _before_ device_register() call, because
	Yanfei's patch is reverted in [v2 1/2]

---
 drivers/net/phy/mdio_bus.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53f034fc2ef7..2d16a93af1ae 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -534,6 +534,13 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	bus->dev.groups = NULL;
 	dev_set_name(&bus->dev, "%s", bus->id);
 
+	/* We need to set state to MDIOBUS_UNREGISTERED to correctly realese
+	 * the device in mdiobus_free()
+	 *
+	 * State will be updated later in this function in case of success
+	 */
+	bus->state == MDIOBUS_UNREGISTERED;
+
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
-- 
2.33.0

