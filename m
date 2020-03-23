Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1DCF18EE3F
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgCWC5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:57:30 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46162 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWC53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 22:57:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id r3so5276497pls.13;
        Sun, 22 Mar 2020 19:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wf+vH9t8xqDaM0zERvmm5OJNRuJUj0RTS8Tt8FdtJX0=;
        b=NUV78+bdWs2ov2/LGKno5Gr3IKthQJ2brX6ImVASTAXbJWAaVYWXspxpnTYXdOiQu7
         tYd88j7LNd6RaN/SMoGOQPkNZo05fF+QQsi6N3pVZ+uSc4NSkrF22UPnW34Ak4qF9vfD
         +pwcoIPUBdf70gDYpm/Jml5ny0fzgXG/sOgYl7jCPinrjRwIehEIU4M3WqL/CbTvDirv
         8/UeskC0pSiXQV6tH6GSJuQ1Ud0LIL+E3D1micygksIQhVjDsWhIQHGCP7GW05JBePwb
         mbjPy3s9JKPd806LdoMMKNrDSChmquTdOHrnsRY3QQYYV/+Bk/yHhvIXlk309BfYesJD
         xodA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wf+vH9t8xqDaM0zERvmm5OJNRuJUj0RTS8Tt8FdtJX0=;
        b=gld0wI/FdAhHMvrcHPNYXUleCvyLAwh3RQvb5gVRWFWV5ILfuiiZmza7J3wCpXj/XO
         9dWHE3BeSaGm+MXZd4tQj/Y0DnPeVaRSBf3J1iZhSoSHKYr8k+dKHP51hnfkdf0svLEs
         CmBnab2/ytvUkbIKmiNpEnEsy2ldGzaBFvpL+3b8xnylmTV1w2KWVVvxJFccpBiQ+uSC
         yWRtd5AADfN5deQaPIDnmEl1QPCoSSTRbw10x7Dl2uf02Se6LlLA/M2BquoXcLnj6Xmc
         EMZPvDDi3Ey3Qzsj0y3sbBhLrFRYXn1W/VoBe+dpm86TIVhZIq/dUne3Ir/dhM4bJpVx
         caug==
X-Gm-Message-State: ANhLgQ1ZJ9EOck5E2Fp1iWv4hXpn5WOEKEEc/gi4GnRdAz3ABFwKVwqm
        ETLjENJc3YzZ2eCCUs9x/NhLUBpH
X-Google-Smtp-Source: ADFU+vsvYEEZXZx2s4n6yefrm4pNY7xmE1t7oePVaYEVLSsVNDhOM+Kx/q72ByjVvJDT1FcJEHZsyw==
X-Received: by 2002:a17:90a:a484:: with SMTP id z4mr6008122pjp.77.1584932247774;
        Sun, 22 Mar 2020 19:57:27 -0700 (PDT)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id l2sm10696030pjn.27.2020.03.22.19.57.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 19:57:27 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v6 06/10] net: phy: marvell10g: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 10:56:29 +0800
Message-Id: <20200323025633.6069-7-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323025633.6069-1-zhengdejin5@gmail.com>
References: <20200323025633.6069-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_mmd_poll_timeout() to replace the poll codes for
simplify mv3310_reset() function.

it should be add msleep(5) before call phy_read_mmd_poll_timeout()
to keep the code more similar, but it will report that warning, so
modify it to msleep(20).

./scripts/checkpatch.pl
v5-0006-net-phy-marvell10g-use-phy_read_mmd_poll_timeout-.patch
WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.rst
#41: FILE: drivers/net/phy/marvell10g.c:251:
+	msleep(5);

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v5 -> v6:
	- no changed.
v4 -> v5:
	- add msleep() to before call phy_read_mmd_poll_timeout()
	  to keep the code more similar.
v3 -> v4:
	- add this patch by Andrew's suggestion. Thanks Andrew!


 drivers/net/phy/marvell10g.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7e05b92504f0..c0fb8391c75b 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -241,22 +241,18 @@ static int mv3310_power_up(struct phy_device *phydev)
 
 static int mv3310_reset(struct phy_device *phydev, u32 unit)
 {
-	int retries, val, err;
+	int val, err;
 
 	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
 			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
 	if (err < 0)
 		return err;
 
-	retries = 20;
-	do {
-		msleep(5);
-		val = phy_read_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1);
-		if (val < 0)
-			return val;
-	} while (val & MDIO_CTRL1_RESET && --retries);
-
-	return val & MDIO_CTRL1_RESET ? -ETIMEDOUT : 0;
+	msleep(20);
+	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_PCS,
+					 unit + MDIO_CTRL1, val,
+					 !(val & MDIO_CTRL1_RESET),
+					 5000, 80000);
 }
 
 static int mv3310_get_edpd(struct phy_device *phydev, u16 *edpd)
-- 
2.25.0

