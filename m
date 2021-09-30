Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3097841E05D
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 19:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352855AbhI3RwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 13:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352854AbhI3RwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 13:52:17 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8BBC061770;
        Thu, 30 Sep 2021 10:50:33 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id b15so28500814lfe.7;
        Thu, 30 Sep 2021 10:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+JDjAgU8bFcCk8yPUu11mn0T3Xk2GAlmfZNXipC8Lmo=;
        b=BcLNUXFG9WHALB535wMqdB0A1rvUc6Ym3l6cHuLOP9qxUsmK/YExZ1OUhfNkc4Vcd6
         ftCMTd3RTke73TDteUclXgPPwjsxXbG5N3YR56FGv9xGoccT3Qsd/cldozoXsJ962BJp
         ep5FV+JwAh/vql+orWrR4XRjCc/UNaPZm5qsgXCvXnPETPIFSonsI4dwwX4mBpj3mzkn
         JTFAja4r/VBwW+2gSPtTvxCpoOiKCDKMDFJv28gI28FUDVt9upO4/iANDOvTlY2v8Pol
         /4GJRhrOgldEp3KiHIdZWcODUATh7kq70xiGXuTi0S6QO0B9GIh5k/9RZMO5P++rfjj6
         3lbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+JDjAgU8bFcCk8yPUu11mn0T3Xk2GAlmfZNXipC8Lmo=;
        b=u4/ZoPAd5Qb+eOhVmTPtYZawrnYejy18X+dGTM6mTvdxAiP94AMov9gr7oimG0KLPj
         yCvs9M7Q27PbvJd373zws0RwlOWm5GafuB89d/n42faIkmWTJc1YOuz2vZMcoLRLKCjk
         ONfIyADAtLCtgB4AtbnUYOnLIi5TQZuLCTxOTIU3TmL7uzd8aZ73Od3yntbCOx2cFPM4
         yZFLkSKy0iW1ZdTl2LkcMyvldQnAWHrJj4dGurD67nCVt73eir8IJXQ4Wp25dqr0UBsL
         Rl/k00N85DyYe4TxERCHpSeaimwy6GL5dkr/sFz2BxJFoSFDX6TmYzObYCT7mDqCjgfM
         /SYw==
X-Gm-Message-State: AOAM533Jo9QlYjgVhdOlGb1UUy4U1L4pxNVpPsuKBBe1McCi2nt7Dcn5
        7WDydxJ1aiKGq6X+rsVwJWs=
X-Google-Smtp-Source: ABdhPJz4Ga693I91NXRp0LZZrwh/IFFbkUIE4pp0WVDA7T9qC6OrD08aq9cS+nj4qzZkK0BeCjUBzA==
X-Received: by 2002:ac2:46d8:: with SMTP id p24mr489777lfo.227.1633024231719;
        Thu, 30 Sep 2021 10:50:31 -0700 (PDT)
Received: from localhost.localdomain ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id m5sm443567lfg.121.2021.09.30.10.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 10:50:31 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com,
        afleming@freescale.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v4 2/2] phy: mdio: fix memory leak
Date:   Thu, 30 Sep 2021 20:50:28 +0300
Message-Id: <eceae1429fbf8fa5c73dd2a0d39d525aa905074d.1633024062.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <f12fb1faa4eccf0f355788225335eb4309ff2599.1633024062.git.paskripkin@gmail.com>
References: <f12fb1faa4eccf0f355788225335eb4309ff2599.1633024062.git.paskripkin@gmail.com>
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

Changes in v4:
	Fixed typo in comment, thanks to Wong Vee Khee

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
index 53f034fc2ef7..fca8e335d750 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -534,6 +534,13 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	bus->dev.groups = NULL;
 	dev_set_name(&bus->dev, "%s", bus->id);
 
+	/* We need to set state to MDIOBUS_UNREGISTERED to correctly release
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

