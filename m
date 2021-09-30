Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A70641D331
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348279AbhI3GVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348267AbhI3GVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:21:41 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F88C06161C;
        Wed, 29 Sep 2021 23:19:58 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id i4so20885908lfv.4;
        Wed, 29 Sep 2021 23:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UYSzK2oRpRLs39P58LffOhEpmAopES8bceIpkauH90g=;
        b=K2KrpjzzON5G5Y57FE5DJZCvGli5VwvTTuC2WmoW/FukQj1QvK/mE+yLWqjQ++I0Z4
         Ez4+hh6LJ8ple6Tv1ALAt5BZeVI6Shf6hdK4oo21E66EyCtj8hh9vieohy6gVUi3uVwh
         431mUrsn2Xo0zxRBI6YCWLZZS01jHffvPsLI3AI/rssi/sbDDZPyUBGMyJ2q1m+pYOsn
         aWRJrEQSNCmmWg4k3gxa7BafV5qJSDD7ePmqYv6ePBTgV7gKJ75lipkZI6nN813dt1eb
         3oqZTbzDxrNFn8Nf1q4G3j6ZqVxCxfebMCb6ZZuNX4tDYwzCWx6fcve82q2/VDjTDK18
         aPzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UYSzK2oRpRLs39P58LffOhEpmAopES8bceIpkauH90g=;
        b=m/tsW+wKmTR0GDcvSaO2S+C+K+/MF630TIxlDyzr8eawadUbFTLYnLo39iOQj0uP5x
         uBBmt5+q1CQhi/mNfhVBQcFiHJhej4bqmuCfK5tWLKqpUC3NIw4ixPK+9iC3TcqrXeR5
         +WazD0SSvm+7DGnjkTX8YVDTVHNsBpHG16+KDNzjOmS7na80+Re49TbpO99ZoG5aYQ1k
         j7wFuxaYCCcDHJuW/B1AUKq0njxodGl3lerEeSJKr/cJCy2gEHf5ZBFBnFjGis/06dLP
         b8NW5r9oaA26RkqCwZDRLoiUTLqaM2oU6kS9CyrqGCbJ3eUwe+XDu4YeYFS98Mh9dgRB
         xQ0A==
X-Gm-Message-State: AOAM532Afoif4wTBCW1zBI0FcgYxHIk+3XLM4KVqsy//W0vllWRSV3Cb
        V81NxmFiLKsg87zveqleejQ=
X-Google-Smtp-Source: ABdhPJwSAYLVz7LCHeX3el9rkXaztxr+oOA5U4cvjevnJDg42e6Zc2hPXLJuBdgjxSHSNNDxZirAtw==
X-Received: by 2002:a2e:998a:: with SMTP id w10mr4120546lji.322.1632982797221;
        Wed, 29 Sep 2021 23:19:57 -0700 (PDT)
Received: from localhost.localdomain ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id a16sm252597lfr.186.2021.09.29.23.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:19:56 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com,
        afleming@freescale.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v3 2/2] phy: mdio: fix memory leak
Date:   Thu, 30 Sep 2021 09:19:54 +0300
Message-Id: <5745dea4e12268a3f6b0772317f1cf0f49dab958.1632982651.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <f12fb1faa4eccf0f355788225335eb4309ff2599.1632982651.git.paskripkin@gmail.com>
References: <f12fb1faa4eccf0f355788225335eb4309ff2599.1632982651.git.paskripkin@gmail.com>
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
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v3:
	s/==/=/
	Added Dan's Reviewed-by tag

Changes in v2:
	Removed new state, since MDIOBUS_UNREGISTERED can be used. Also, moved
	bus->state initialization _before_ device_register() call, because
	Yanfei's patch is reverted in [v2 1/2]

---
 drivers/net/phy/mdio_bus.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53f034fc2ef7..a5f910d4a7be 100644
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
+	bus->state = MDIOBUS_UNREGISTERED;
+
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
-- 
2.33.0

