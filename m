Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4B418CF02
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgCTNfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:35:16 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37609 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbgCTNfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:35:15 -0400
Received: by mail-pj1-f68.google.com with SMTP id ca13so2470526pjb.2;
        Fri, 20 Mar 2020 06:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WfFHHS6jo8iZrY1Q3mVkHkvmg4vs2kPyprC/yFvbuKo=;
        b=LJLBVt+OcyGdNCpEgRLEMVyl27HZA4JqEkvd9fTKBjqDQEmL8bCFp+/xZxf/B8LhK4
         RbybovpDhlOVk3qhPBuUbhaFfdcddiEOLERWsz7eK93to4UCUFaDDLXdScfz/prgrxEl
         fkgsjD/4/CPQ8tJNEfl/i4o+XDCp4L2c/MSs5Z8cC+eyfsjGRYCuLPr3fWEpLCdwQd7c
         S0CCey2apNmqV+Yligu/+mubYSf07+vM/vQq9JrJbOEcIAAMeeZSJ/sdNcI9ZHVv5XFb
         sRF+ch8kEK4GH0U1OQ4resR/fGkfS2Kowxc4csGh/U96Qj6AZw43HXcn5XpmJCXiXSen
         cFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WfFHHS6jo8iZrY1Q3mVkHkvmg4vs2kPyprC/yFvbuKo=;
        b=Q/3sD2XWbGXzTD9oJm9qdsoOjKiQojMwa5fqrWPZg6yZOW19xhbKUYtVzW5/7ZsIOp
         tgsq6qt8pFrkbPuPak7y3AjxqENdlhnL2hrc2az2fS4nJkImlvEtyRw1E7eH+PUb4s/M
         4svdSDc4hLNsLwK5R8aBJyJrSFHD+GQTwUByCABzOv/H9h9mZrU5fv6HuaaUCiJrQ8gh
         1PnDIxC4T+01T9UoulGpEhkHJRq01383/Q24vPuNgPSa2LWJ094k3TvCKMamIegP+Pg6
         7FniPo13oSd0LVM7xHbpJ4i4M9oh15Cn1Aaas5KBYIWLumRuAUYATN9IfhArLIyuJ1Si
         U7qQ==
X-Gm-Message-State: ANhLgQ2cmixxl1dUFdZR1clvCoPoSpi9FeLq9NjK4dG8Ca1vxKi5UDYc
        j5TKk8ubh0xnAGll1VDHciI=
X-Google-Smtp-Source: ADFU+vsnkwyQlAetIoZw3jesRuNLUue3PcnvCMHt7xVuySpu+fuLVeOqLt1d0lrtKgBvfb1euVeJFA==
X-Received: by 2002:a17:90a:d205:: with SMTP id o5mr9307963pju.46.1584711313701;
        Fri, 20 Mar 2020 06:35:13 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id c128sm5526246pfa.11.2020.03.20.06.35.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 06:35:13 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        corbet@lwn.net, alexios.zavras@intel.com, broonie@kernel.org,
        tglx@linutronix.de, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 7/7] net: phy: use phy_read_poll_timeout() to simplify the code
Date:   Fri, 20 Mar 2020 21:34:31 +0800
Message-Id: <20200320133431.9354-8-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200320133431.9354-1-zhengdejin5@gmail.com>
References: <20200320133431.9354-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify the code in phy_poll_reset() function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v1 -> v2:
	- remove the handle of phy_read()'s return error.

 drivers/net/phy/phy_device.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a585faf8b844..0de4f03ba90c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1059,23 +1059,15 @@ EXPORT_SYMBOL(phy_disconnect);
 static int phy_poll_reset(struct phy_device *phydev)
 {
 	/* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
-	unsigned int retries = 12;
-	int ret;
-
-	do {
-		msleep(50);
-		ret = phy_read(phydev, MII_BMCR);
-		if (ret < 0)
-			return ret;
-	} while (ret & BMCR_RESET && --retries);
-	if (ret & BMCR_RESET)
-		return -ETIMEDOUT;
+	int ret, val;
 
+	ret = phy_read_poll_timeout(val, !(val & BMCR_RESET), 50000, 600000,
+				    phydev, MII_BMCR);
 	/* Some chips (smsc911x) may still need up to another 1ms after the
 	 * BMCR_RESET bit is cleared before they are usable.
 	 */
 	msleep(1);
-	return 0;
+	return ret;
 }
 
 int phy_init_hw(struct phy_device *phydev)
-- 
2.25.0

