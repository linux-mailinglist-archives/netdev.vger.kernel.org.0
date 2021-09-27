Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32856419301
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhI0LWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhI0LV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 07:21:59 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AC3C061714;
        Mon, 27 Sep 2021 04:20:21 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id b15so74881375lfe.7;
        Mon, 27 Sep 2021 04:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IM0udcg7Exs9Wnno0uDS6E62zPZhOJr/cycPpKfnVQk=;
        b=L/8MgV0oyeUPafvMVbtVmDu6G4fF5NWkGlFnkakoW6A0bmCaZYF6m8mJPsAnlfgUv6
         bQwfyboY2aMAG+yBz7WnKoQeJDIMKxTVOAPa7i0GHwMl66BG7AfTdcbJ8qLKYbOHoJOG
         JGKcc591VuF3xRKTGo7wZZzjlImrv/NGMlYdsV++U6hGXd/WkWbO8M0EH/fTkFxoWIeG
         xwRPGBWRaKip8p0kelTi2jtXzGrWo4O4N9ptR+eQ9Nz2gBTaF3liuj+pb6ExopGrKBeu
         obY1Ref6pkgYjWXbQL1wPpA2kOhpOX3N+YD6wGpK+JrCpJziQoxAaPXw8C0rbXyiixhH
         3NJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IM0udcg7Exs9Wnno0uDS6E62zPZhOJr/cycPpKfnVQk=;
        b=2nh/H/XX2gAaZ9ah9L8t+DCqdAIN+DWWFmsyCGKb7F6IVEBP9vFbeSeQMiDmGFTZRc
         6R0R/I5q5jtJs4nIfuyVeRzB6HBSuaJe2u2M6thwsq7Bjn7sRY+uBs4nKXiqFgurbVNX
         LKyenTicTNsvm8ygG/JXT4fIQfz4RQAo4w6AP5gi/dBSIWqglkJVRh4+NswV9uW9BM02
         qMhyAr5lV/RxLxLtTl10f8hJxiCHX7rS3+YqpBC7weq8l+wC6iNYhNy3UFlSihqJKu1s
         qnNGHY43yoSZMGWrsIS5iayfah84tw1TT5n90FmGquiVJ0tvcVxiSwul/A+2gwwKsPuo
         m4Ww==
X-Gm-Message-State: AOAM53161W8e4MYfpdWZ4mZdeBBjth6iyRy8tMSnwhi0N//fsQrNlXg8
        qEVAOBl6oWI1tLIL6C8JsgM=
X-Google-Smtp-Source: ABdhPJxxCsdNzj//iPQCyzCjltNqYaesAyRbJIFqOu6djIN1chwsISnVFjpzf1PB0yJt89PxuZrJbg==
X-Received: by 2002:a05:6512:3ba5:: with SMTP id g37mr23275112lfv.651.1632741619712;
        Mon, 27 Sep 2021 04:20:19 -0700 (PDT)
Received: from localhost.localdomain ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id p8sm1387002lft.242.2021.09.27.04.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 04:20:18 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Subject: [PATCH] phy: mdio: fix memory leak
Date:   Mon, 27 Sep 2021 14:20:17 +0300
Message-Id: <20210927112017.19108-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.0
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
was just calling kfree(dev) in case of MDIOBUS_ALLOCATED state

To avoid this behaviour we can add new intermediate state, which means,
that we have called device_regiter(), but failed on any of the next steps.
Clean up process for this state is the same as for MDIOBUS_UNREGISTERED,
but MDIOBUS_UNREGISTERED name does not fit to the logic described above.

Fixes: 46abc02175b3 ("phylib: give mdio buses a device tree presence")
Reported-and-tested-by: syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 4 +++-
 include/linux/phy.h        | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53f034fc2ef7..ed764638b449 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -540,6 +540,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		return -EINVAL;
 	}
 
+	bus->state = MDIOBUS_DEV_REGISTERED;
+
 	mutex_init(&bus->mdio_lock);
 	mutex_init(&bus->shared_lock);
 
@@ -647,7 +649,7 @@ void mdiobus_free(struct mii_bus *bus)
 		return;
 	}
 
-	BUG_ON(bus->state != MDIOBUS_UNREGISTERED);
+	BUG_ON(bus->state != MDIOBUS_UNREGISTERED && bus->state != MDIOBUS_DEV_REGISTERED);
 	bus->state = MDIOBUS_RELEASED;
 
 	put_device(&bus->dev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 736e1d1a47c4..41d2ccdacd5e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -343,6 +343,7 @@ struct mii_bus {
 		MDIOBUS_REGISTERED,
 		MDIOBUS_UNREGISTERED,
 		MDIOBUS_RELEASED,
+		MDIOBUS_DEV_REGISTERED,
 	} state;
 
 	/** @dev: Kernel device representation */
-- 
2.33.0

