Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0341218EB1C
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 18:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgCVRu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 13:50:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44193 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgCVRu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 13:50:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id 142so694808pgf.11;
        Sun, 22 Mar 2020 10:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NDwcXbElIXd33ZID6UH6u9dMvaW921/FvHkSPleU3cw=;
        b=GF+8JpWHBGFvIgSO+k4NS9xkCAxr5UeaLnLWB+HDaGaIpTmX/DP8c7AU0kdAYM2QKq
         FYETp03CkLi4KbwiMwKZKZagglctOt7tkTuG49+l0EQM9KywalZDap/lUW1/psEZO6oX
         D1R1ifuxba7xW3VgNoro+1poTbAkd11PwSv7kTh7o6zULnHEtV4TpO03kX2C2nVlbM9R
         ZPoYR18WglrUYAP7VjxYu31Iqs8KUwBA3BjgDkTqQwnlberfNaVVLA9kmKUOpOq0j+2t
         Emo8R2ZPiDpmSOmUtajKghHSwqSClKKMGJVslgneh5il+Kmua78xQU3jRs1JmjSjLZsI
         b9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NDwcXbElIXd33ZID6UH6u9dMvaW921/FvHkSPleU3cw=;
        b=BKCyhdxrAaCUNvXz9Eqz8TPIhueu3+LPNlxqNEHsydpZt574X3ZIUzljGbqii0q9bE
         rbmI75szDmPXotfqhByc0OsfjJwEyO0pnnS/OZK7Wxk1KlRp65Y5HA5d+s1pY12Ohy50
         fwjId/Z7GuJafFp8rOaDJHrjEElOU5KZ9FOH0F0zJmfFw1Guz/Hsx8S5nTMtquXKsHKx
         6oR1BkQ/kgERhdxnYNTZp81IYDlRgAA9qJpLGyM0PkSpoQAsUwepzQ8STAk3vVyY2wmu
         A7vYPNNEs6rySAcOJuzm2ZmlNi0L1+U19Man8gFI2bY0yGQKvlSoPDB2DyFMj9Lbz/52
         NJCQ==
X-Gm-Message-State: ANhLgQ07n3PgnGSMsf2j6LaRTregeHizgn5PtlSz12yqQma59I0rhX3L
        jJpAweYyI/cOb2eeW2aABDA=
X-Google-Smtp-Source: ADFU+vstn20zYm/fvMc0J3Q2jpvKeOKalw+QB0a+bT1MCFCpWf7szt8oAlxitdIc6A8kNw1a2FoAhQ==
X-Received: by 2002:a62:1946:: with SMTP id 67mr21077830pfz.0.1584899425512;
        Sun, 22 Mar 2020 10:50:25 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id e126sm11000284pfa.122.2020.03.22.10.50.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 10:50:25 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, broonie@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v5 08/10] net: phy: use phy_read_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 01:49:41 +0800
Message-Id: <20200322174943.26332-9-zhengdejin5@gmail.com>
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
simplify the code in phy_poll_reset() function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v4 -> v5:
	- it can add msleep before call phy_read_poll_timeout()
	  to keep the code more similar. so add it.
v3 -> v4:
	- drop it.
v2 -> v3:
	- adapt to it after modifying the parameter order of the
	  newly added function
v1 -> v2:
	- remove the handle of phy_read()'s return error.


 drivers/net/phy/phy_device.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a585faf8b844..24297ee7f626 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1059,23 +1059,16 @@ EXPORT_SYMBOL(phy_disconnect);
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
 
+	msleep(50);
+	ret = phy_read_poll_timeout(phydev, MII_BMCR, val, !(val & BMCR_RESET),
+				    50000, 550000);
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

