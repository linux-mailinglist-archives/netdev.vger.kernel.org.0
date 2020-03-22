Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2E018EB16
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 18:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgCVRub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 13:50:31 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33830 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbgCVRua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 13:50:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id 23so6302554pfj.1;
        Sun, 22 Mar 2020 10:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TpAaf6pIDlWasxVFtmzhqQBYaoymlujVKSINWwIwexY=;
        b=dGcRXKjJc2f5XtRos22ebmYCMlFLPCnV1JMyskeVFlc2SWnRr+Uq6a5AH2Na5Qsc5f
         paDc5aslgQpW1MLbHdICOSwUP4EpgiT8i7YElC2jUYkrj5PJcRcXnBo0OQ5rTmpom6N0
         xfTrsy9dagxtcuZ1FNSMzxqQYVSRTWrIh2QqxjKOGB5fFMmG62g1VdDB28bt9CcUa19C
         gLs59Nf+fpiBdIvcPXvDtO9hYI3ZmluJz+jmTjBeDHP0FFebXD/y5GySCzWhCvtwGbDh
         By5qpQFRri0SNqB3vSACwkAWZ/1bbIFwE4PyX/djGx32sV1HDHXPvMsVtjbc1G/Ys/ZD
         eSlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TpAaf6pIDlWasxVFtmzhqQBYaoymlujVKSINWwIwexY=;
        b=HjnuZyRBK7+95fZh9sO6KONCIm75wT9RLDMq+ff7TZ6xbT13Mp+GGIXoOd7sCTWpmj
         cedWy7j7KxiezKEpf7dV5udO+lkFAszn7Gb83jLM1UT0BMvh8uWZjvcplVPUujBZsEmd
         F+1e9fg28o4gyzS3yNFwrJKrUhRklmJzsWdVt4sVWzeGJO7vMCND4NiQPW77fO6e5zxj
         fvSExAPGczYFt80FUMDgG5YrjdKTISTNQDsgYFy7POwRrbFJUe7V/DISmMI2j9WuDiob
         sHLIeUfpXNI5idVRFn3TM8dyq2Vnxw6iEz+4DG9ITrZ61hHRscuPnlx0kyCSG3ZQP0FL
         zmRw==
X-Gm-Message-State: ANhLgQ2hpH1/jfXyNgduI9YmoY8nQpvokZBdEd0WkgoJkOl2qD/N6mP+
        0Xo3oJsz2jj+8ynj3Wt6K84=
X-Google-Smtp-Source: ADFU+vtgyjV/A/ADJMXKTgo6CwD2w9Jf3aHfud8mpofU9uWznIeeVeZZ8IeG4Lq/3EwDBkpgtr533g==
X-Received: by 2002:a62:7ad7:: with SMTP id v206mr19867365pfc.181.1584899429552;
        Sun, 22 Mar 2020 10:50:29 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id j4sm11053651pfg.133.2020.03.22.10.50.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 10:50:29 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, broonie@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v5 09/10] net: phy: smsc: use phy_read_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 01:49:42 +0800
Message-Id: <20200322174943.26332-10-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322174943.26332-1-zhengdejin5@gmail.com>
References: <20200322174943.26332-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify lan87xx_read_status() function.

it should be add msleep(10) before call phy_read_poll_timeout()
to keep the code more similar, but it will report that warning, so
modify it to msleep(20).

./scripts/checkpatch.pl
v5-0009-net-phy-smsc-use-phy_read_poll_timeout-to-simplif.patch
WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.rst
#42: FILE: drivers/net/phy/smsc.c:126:
+		msleep(10);

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v4 -> v5:
	- add msleep before phy_read_poll_timeout() to keep the
	  code more similar
v3 -> v4:
	- add this patch by Andrew's suggestion. Thanks Andrew!

 drivers/net/phy/smsc.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index b73298250793..f888523086ed 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -112,8 +112,6 @@ static int lan87xx_read_status(struct phy_device *phydev)
 	int err = genphy_read_status(phydev);
 
 	if (!phydev->link && priv->energy_enable) {
-		int i;
-
 		/* Disable EDPD to wake up PHY */
 		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
@@ -125,15 +123,12 @@ static int lan87xx_read_status(struct phy_device *phydev)
 			return rc;
 
 		/* Wait max 640 ms to detect energy */
-		for (i = 0; i < 64; i++) {
-			/* Sleep to allow link test pulses to be sent */
-			msleep(10);
-			rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-			if (rc < 0)
-				return rc;
-			if (rc & MII_LAN83C185_ENERGYON)
-				break;
-		}
+		msleep(20);
+		phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS, rc,
+				      rc & MII_LAN83C185_ENERGYON, 10000,
+				      620000);
+		if (rc < 0)
+			return rc;
 
 		/* Re-enable EDPD */
 		rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-- 
2.25.0

