Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE56102559
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfKSN1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:27:15 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46934 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfKSN1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:27:15 -0500
Received: by mail-wr1-f66.google.com with SMTP id b3so23815449wrs.13
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 05:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monstr-eu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:date:message-id;
        bh=EGefV7mNK+kl1gbQFeTNeXk1t+zkh+oZ0TH06o9BTAQ=;
        b=dH9qKRozXP3KGtiH9uJ20dq843ddNU4Kp6buGyZNiWSli31NjWeasZ0fjM9+/WH6rG
         cuXqvAacyuw+TjejZTJakkXuiEfx9r2oI0FYPibxm93297dDQxRQFAfwQnrwHTIeFpqT
         3PMWvCYoLXzw8e8VkV/cPIo+iwOgTSngc+huCnwRSTv9ikP2Z9+Y/OYnGS0CJmKdLKU6
         NsmwoeF1aS9rzaESFzr1AX5jAbX1oABu0xzYOipU79jfDeE6szLLhKS13Edomi2fnLCp
         J0r4b2EoPpIsDvCaHYy729/KBUdjTZVbfqxBZegxB4aRwkas5t2Hc4Gx9w4MEYn16huL
         /Cpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=EGefV7mNK+kl1gbQFeTNeXk1t+zkh+oZ0TH06o9BTAQ=;
        b=HsWF3OZxJYNjdCZYPmfsRq/MSq/oNc5bCrl1jY9uoHzAyVQXR50FgMQOju5phJJMOp
         RBX/O6rsD1tBviTGqSDe16UioZJrb5gudfGDguKAmdHK6L/FV2q/1UCWicPdiHuQLYlP
         vjaIvqV2D8xaSq3AWpOBfqxrnU47P5uW4qc5ZzzeFxZLLJHdXIKsk/oNWT6Rc+n2YmjR
         vkG64rPVU63MlVjavO0vQzWZCGVg0k29sZpTxFjqbmVKpHX/ZOmtgNZRli0qs0YdKGxr
         qAQZjSGeYx3io4yqAEfJ95ChY65znpkhvzY1zI+UiIn3cDs+IaOshraWayDp359qCWNc
         awPQ==
X-Gm-Message-State: APjAAAXpT5c/Uy3UC4VUF62e3m5elalHni4RATghZj9bXMpXZcAlmAIQ
        wt/4/nqnTLWP9fymalo4Dgi/Pg==
X-Google-Smtp-Source: APXvYqwWMrQSCn0yw+DxOB4jlYK+39UBztYpH/0OFf16lTrP8qAvd7dbA5m+dfTHLEaP9PMowm96Mg==
X-Received: by 2002:adf:f147:: with SMTP id y7mr29780144wro.236.1574170033042;
        Tue, 19 Nov 2019 05:27:13 -0800 (PST)
Received: from localhost (nat-35.starnet.cz. [178.255.168.35])
        by smtp.gmail.com with ESMTPSA id t185sm3334612wmf.45.2019.11.19.05.27.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 05:27:12 -0800 (PST)
From:   Michal Simek <michal.simek@xilinx.com>
To:     linux-kernel@vger.kernel.org, monstr@monstr.eu,
        michal.simek@xilinx.com, git@xilinx.com
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH] phy: mdio_bus: Check ENOTSUPP instead of ENOSYS in mdiobus_register_reset
Date:   Tue, 19 Nov 2019 14:27:11 +0100
Message-Id: <8712e54912598b3ca6f00d00ff8fbfdd1c53e7e8.1574170028.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Origin patch was using ENOTSUPP instead of ENOSYS. Silently changing error
value ends up in an access to bad area on Microblaze with axi ethernet
driver.

Fixes: 1d4639567d97 ("mdio_bus: Fix PTR_ERR applied after initialization to constant")
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

I didn't track it down where exactly that access happens but the patch is
clearly just changing something without description.

The origin patch has been merged between rc7 and rc8 and would be good to
get this fix to v5.4.
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 35876562e32a..dbacb0031877 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -65,7 +65,7 @@ static int mdiobus_register_reset(struct mdio_device *mdiodev)
 		reset = devm_reset_control_get_exclusive(&mdiodev->dev,
 							 "phy");
 	if (IS_ERR(reset)) {
-		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOSYS)
+		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOTSUPP)
 			reset = NULL;
 		else
 			return PTR_ERR(reset);
-- 
2.17.1

