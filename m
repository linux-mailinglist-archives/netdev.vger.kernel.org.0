Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C292318CEEC
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgCTNe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:34:59 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33299 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTNe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:34:57 -0400
Received: by mail-pf1-f196.google.com with SMTP id j1so538524pfe.0;
        Fri, 20 Mar 2020 06:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RswhjvPr5b8vA1NrirXeBdsXcQMYg0zZWrAG+BTT7RM=;
        b=S2hKRur78Ka42SDCfO39JMUlZ5/2AWep4JDtwrW+qcnn9jBVa5ttZShZiN9PlfHoBK
         3y2iMy4fW5Ai40vR9cQeZukTc9FISTYANb8Ft0J0unLydwRH9cKCjhL+AqlXCMSSdZPG
         gm96WF2qtysmHqDPF/aMItuUxAo1GWyyJ0R9xPbVl7C7+UQgInIAi/Bwf8+QKwMDZBfQ
         OplstSiOxHHJbpz4VUXfC7p48+CobbxLeRonxGV0Ovz5KZDUkopYRiXp/ScsE4I5xkzV
         bc6QeAiQDs4zYsFrS/Md2qZYvPoJyKofOmJJxHhDU8E++XnPNwrkgSAaoBXjF7pfhL3e
         ITwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RswhjvPr5b8vA1NrirXeBdsXcQMYg0zZWrAG+BTT7RM=;
        b=Y5x1mql+FiuOd51KLciyJR7CFzmhwP4On8tjsaTzZUPPygiVa8ZGjfBmcustCldZEq
         APyLxBF4MIFeSvs2HHtZ2IzhJKAdZ4omTNrWj2h05aoQpU0utoyAa47DmIr1OAYfpXO2
         gyEeTBPFxeGxXg1sny0HXPq2vlwWNUMuFEVY8BjhUjZC2hsJFfyTEUa/PvZ1/uBSOUzv
         BlWuNZ8rrIDSrWgp5GO097Nde77ZxcbuqdnQjRbyYexhqYfwx/vgQ9ueMHZxlfqfbMS1
         uYE7i+jSA9KEe21ZGw1vfMDWx8oa6cMDJ7Jk5RF8PhEuHd54LoC9pmx4fpwMG9W7bwep
         weiA==
X-Gm-Message-State: ANhLgQ3retmRTdrPXlf1wBt7/a/Wu0Uc87jNXYJLfAurL3YZLScbtt9u
        WskRfY99dS5UimCl/tEcNZY=
X-Google-Smtp-Source: ADFU+vuu9bQZjA9IAnNnVPKiZJRKd/gpVxQ8g/7oJcb20doASt8yWy3ocMJrMU3lLIK+vpuwJiuASQ==
X-Received: by 2002:aa7:96ae:: with SMTP id g14mr9398744pfk.216.1584711296647;
        Fri, 20 Mar 2020 06:34:56 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id k17sm5479096pfp.194.2020.03.20.06.34.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 06:34:56 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        corbet@lwn.net, alexios.zavras@intel.com, broonie@kernel.org,
        tglx@linutronix.de, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 4/7] net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Fri, 20 Mar 2020 21:34:28 +0800
Message-Id: <20200320133431.9354-5-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200320133431.9354-1-zhengdejin5@gmail.com>
References: <20200320133431.9354-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_mmd_poll_timeout() to replace the poll codes for
simplify the code in bcm84881_wait_init() function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v1 -> v2:
	- remove the handle of phy_read_mmd's return error.

 drivers/net/phy/bcm84881.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 14d55a77eb28..21df9b00d2b2 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -22,30 +22,11 @@ enum {
 
 static int bcm84881_wait_init(struct phy_device *phydev)
 {
-	unsigned int tries = 20;
-	int ret, val;
-
-	do {
-		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
-		if (val < 0) {
-			ret = val;
-			break;
-		}
-		if (!(val & MDIO_CTRL1_RESET)) {
-			ret = 0;
-			break;
-		}
-		if (!--tries) {
-			ret = -ETIMEDOUT;
-			break;
-		}
-		msleep(100);
-	} while (1);
+	int val;
 
-	if (ret)
-		phydev_err(phydev, "%s failed: %d\n", __func__, ret);
-
-	return ret;
+	return phy_read_mmd_poll_timeout(val, !(val & MDIO_CTRL1_RESET),
+					 100000, 2000000, phydev,
+					 MDIO_MMD_PMAPMD, MDIO_CTRL1);
 }
 
 static int bcm84881_config_init(struct phy_device *phydev)
-- 
2.25.0

