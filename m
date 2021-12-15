Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8AA475F6E
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhLORgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhLORgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 12:36:31 -0500
X-Greylist: delayed 348 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Dec 2021 09:36:31 PST
Received: from forward108o.mail.yandex.net (forward108o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1A4C061574;
        Wed, 15 Dec 2021 09:36:31 -0800 (PST)
Received: from sas1-2c02ca35cfae.qloud-c.yandex.net (sas1-2c02ca35cfae.qloud-c.yandex.net [IPv6:2a02:6b8:c14:3992:0:640:2c02:ca35])
        by forward108o.mail.yandex.net (Yandex) with ESMTP id 2DF4E5DD0F85;
        Wed, 15 Dec 2021 20:30:38 +0300 (MSK)
Received: from sas1-7a2c1d25dbfc.qloud-c.yandex.net (sas1-7a2c1d25dbfc.qloud-c.yandex.net [2a02:6b8:c08:c9f:0:640:7a2c:1d25])
        by sas1-2c02ca35cfae.qloud-c.yandex.net (mxback/Yandex) with ESMTP id yokQyJCqmO-UbeSe4P1;
        Wed, 15 Dec 2021 20:30:38 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1639589438;
        bh=7nv8NpySIPJ8oc39BVvxuaK66vKUYaFhRSkUnNL8y7Q=;
        h=Date:Subject:To:From:Message-Id:Cc;
        b=lIdmh+HRqMEPXT1Ke/RZZIlDInt8ViSHZbKdc/gIkTqZGB9RjZGmzpHuDw+QQNcnv
         1ofT0bi3M3wxZuCX15p5m6H5HXhvFuOkCDVNhwC83+Bk+hWJ0x+ogEWxgKfbYYrYgF
         Anq6qhuAgiER566T8GYeOanNp0TClcO41swTnBHo=
Authentication-Results: sas1-2c02ca35cfae.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by sas1-7a2c1d25dbfc.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id B4Pa0xIn5V-UaPSx8Yd;
        Wed, 15 Dec 2021 20:30:37 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Andrey Eremeev <Axtone4all@yandex.ru>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Andrey Eremeev <Axtone4all@yandex.ru>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] dsa: mv88e6xxx: fix debug print for SPEED_UNFORCED
Date:   Wed, 15 Dec 2021 20:30:32 +0300
Message-Id: <20211215173032.53251-1-Axtone4all@yandex.ru>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Debug print uses invalid check to detect if speed is unforced:
(speed != SPEED_UNFORCED) should be used instead of (!speed).

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Andrey Eremeev <Axtone4all@yandex.ru>
Fixes: 96a2b40c7bd3 ("net: dsa: mv88e6xxx: add port's MAC speed setter")
---
 drivers/net/dsa/mv88e6xxx/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index d9817b20ea64..ab41619a809b 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -283,7 +283,7 @@ static int mv88e6xxx_port_set_speed_duplex(struct mv88e6xxx_chip *chip,
 	if (err)
 		return err;

-	if (speed)
+	if (speed != SPEED_UNFORCED)
 		dev_dbg(chip->dev, "p%d: Speed set to %d Mbps\n", port, speed);
 	else
 		dev_dbg(chip->dev, "p%d: Speed unforced\n", port);
@@ -516,7 +516,7 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 	if (err)
 		return err;

-	if (speed)
+	if (speed != SPEED_UNFORCED)
 		dev_dbg(chip->dev, "p%d: Speed set to %d Mbps\n", port, speed);
 	else
 		dev_dbg(chip->dev, "p%d: Speed unforced\n", port);
--
2.30.1 (Apple Git-130)

