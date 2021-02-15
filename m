Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E8931B583
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 08:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhBOHDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 02:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhBOHDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 02:03:08 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB3DC061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 23:02:28 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id z68so3730752pgz.0
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 23:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=date:message-id:from:to:cc:subject:content-transfer-encoding
         :mime-version;
        bh=mZAyxpsXnXrCfnHYqktOU9LidFqCx36jCafbV//clLk=;
        b=F3z02QGr4Yt0byrHzf0deNun27SJ+SznNuZg/MzFxqz2iDcapPEMVCDO+W7fLlWjG8
         RxNa3c4knx8KqO3M77jy0L5VrlUkjsyy8EYfCrvqZwnGt8roUEoiVN9eBEAktMCPSUWq
         OnRcuUyn0NdF4Osk0GmlN+FMSVTBgOEIAJoh4UQTdrh8Mz5FzB9dK77TptmDWbiu9eF9
         HmqBpaHxgNZ49TUd8Hy6ubPwHiwJ6ssDzY85vXpVjqZ7eUtUHR++zfM2CfXL4QpAgmno
         8vgI8qFWuT2dcUUaljXDZow4KxHW0MojDeF+megeAvWKTgWEbzXuBYJIF5LuVpJosER+
         W3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject
         :content-transfer-encoding:mime-version;
        bh=mZAyxpsXnXrCfnHYqktOU9LidFqCx36jCafbV//clLk=;
        b=sXe2/71qgzMj79MECaXvpIrzx8eashdVwtT1c5LANKBb4ugPqWi5uEfJa569tU5JnQ
         0hNEeGrNvQZySQirG5zs42ayMxFPAVY/Er07aZstHnH4Re0Yl6QnJVPBI6a6zvBpqoGB
         HC0DNyW9CazBaZ4cvfyGy0HvoXk8U5W8smWDlEidEnJETY2OpY4mowfTlzlmn+DsDjMD
         tmrku0XuUuLInHQqKf1HwIqBxM/6hEnfQW6kR2srTVE+oJ6+fs8UANU2wXwcLOreroW6
         ThVpgqkABmlqB4DmvdfxzWtsjJPItVVCZpY/Z76zMlp/++zLI4QmdJuPA12A02x2YzxL
         s/WA==
X-Gm-Message-State: AOAM532h7G8nYCDReTOZ3Wkpy8+MgQC143fbOUZnG2W/x484YNr/ls5W
        pV+rPwLIUjWcn1ojS4UxF/fgpw==
X-Google-Smtp-Source: ABdhPJyRD5UKZ7Kt3wEfUsJgcV/HFeFKRU19IvLESETVb7tmt42fXog4uiyc3dAzQjj/hA8Ybp9MRA==
X-Received: by 2002:a63:54:: with SMTP id 81mr14146573pga.410.1613372548271;
        Sun, 14 Feb 2021 23:02:28 -0800 (PST)
Received: from [127.0.1.1] (117-20-70-209.751446.bne.nbn.aussiebb.net. [117.20.70.209])
        by smtp.gmail.com with UTF8SMTPSA id z12sm16823242pfn.150.2021.02.14.23.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 23:02:27 -0800 (PST)
Date:   Mon, 15 Feb 2021 07:02:18 +0000
Message-Id: <20210215070218.1188903-1-nathan@nathanrossi.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
To:     netdev@vger.kernel.org
Cc:     Nathan Rossi <nathan@nathanrossi.com>,
        Nathan Rossi <nathan.rossi@digi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] of: of_mdio: Handle properties for non-phy mdio devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

The documentation for MDIO bindings describes the "broken-turn-around",
"reset-assert-us", and "reset-deassert-us" properties such that any MDIO
device can define them. Other MDIO devices may require these properties
in order to correctly function on the MDIO bus.

Enable the parsing and configuration associated with these properties by
moving the associated OF parsing to a common function
of_mdiobus_child_parse and use it to apply these properties for both
PHYs and other MDIO devices.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
---
 drivers/net/mdio/of_mdio.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 4daf94bb56..c28db49b72 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -42,6 +42,18 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 	return -EINVAL;
 }
 
+static void of_mdiobus_child_parse(struct mii_bus *mdio, struct mdio_device
+				   *mdiodev, struct device_node *node, u32 addr)
+{
+	if (of_property_read_bool(node, "broken-turn-around"))
+		mdio->phy_ignore_ta_mask |= 1 << addr;
+
+	of_property_read_u32(node, "reset-assert-us",
+			     &mdiodev->reset_assert_delay);
+	of_property_read_u32(node, "reset-deassert-us",
+			     &mdiodev->reset_deassert_delay);
+}
+
 static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
 {
 	struct of_phandle_args arg;
@@ -76,13 +88,7 @@ int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 		phy->irq = mdio->irq[addr];
 	}
 
-	if (of_property_read_bool(child, "broken-turn-around"))
-		mdio->phy_ignore_ta_mask |= 1 << addr;
-
-	of_property_read_u32(child, "reset-assert-us",
-			     &phy->mdio.reset_assert_delay);
-	of_property_read_u32(child, "reset-deassert-us",
-			     &phy->mdio.reset_deassert_delay);
+	of_mdiobus_child_parse(mdio, &phy->mdio, child, addr);
 
 	/* Associate the OF node with the device structure so it
 	 * can be looked up later */
@@ -158,6 +164,8 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
 	if (IS_ERR(mdiodev))
 		return PTR_ERR(mdiodev);
 
+	of_mdiobus_child_parse(mdio, mdiodev, child, addr);
+
 	/* Associate the OF node with the device structure so it
 	 * can be looked up later.
 	 */
---
2.30.0
