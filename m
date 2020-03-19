Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1DAA18BCC9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgCSQkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:40:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45505 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbgCSQkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:40:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id j10so1696611pfi.12;
        Thu, 19 Mar 2020 09:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jBQgkE+2h3XlEh/pjWOWeE4Zg9A9tqd9LFxNsk1kNiA=;
        b=D/4jY0jdJSPfQvuruHzUfn0bsDbfm3VsdzUoVIJvwuibEyeP1SV703MmvokG23vTnw
         5dg4I0fTPHtLwm6f4+0lH+XFLkI0+UAnreToh4kTb+QUN2ciEV3JJZ6jH5DBtKkYuuXj
         QMcky4GpvpA8BpMVaou4MYgKpm5AOj7ebuyXKCU+6K0lZi9eSE+nZ7XBIO74BP3zDply
         E3shXChMZifuzV9sNRtCWaAmpfB/AJ6molWSYLMJJD6p4rK9I8BnpgdeKIbJKS08yHB6
         ydTXhzvp2zmXuJd6LnpRBUj0wYEyk1VrvNEYfYhxt5bTOEtQ2WVIpYMvKEvSuellRZ8x
         1DXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jBQgkE+2h3XlEh/pjWOWeE4Zg9A9tqd9LFxNsk1kNiA=;
        b=ccmvHVrY7J+iqnByDxqalLLdK/0lia0ZcpbKegv/ooVRKHKjtFUYssONiv3oS/R3HU
         Dp8HFm4B+ebHPxirnubtFGddKSB8KvD5aWU82E9PlSLRl/62Wyc6X/ezsxUEcoBsk0oL
         GjnBn1RbtG/NLGbcIGFetEVnWdofWZNLVwJ4GBt4Ms6avJHFtxBiRqFlHNO3wyjO/YqF
         4pTa6fGT9kEHQaHzoUCFmt48VitWDsJNh0wMFuPqily4PrFnQKIr/79+LGh2eVbPgvCZ
         3btaBljtDccUOf/oiap/g73bCZEV7NuFDF8rfrO+WOT0NIDw/gtyIBegtgUpfgMczYSP
         c0Qg==
X-Gm-Message-State: ANhLgQ0u6KJQmL0Eyrfl2hFJxg2V7pk5rDlmcyIFjnE8iBxXKOkrxSiz
        DR3gHEl2sx0Yu0Hft/P9hmuPbPxb
X-Google-Smtp-Source: ADFU+vt6QldAoOvm+9pV4KRcPx9v+v3swyZUkXStkhm/ekqeAQHYIKtXvesfXE8dqIi49MfwqcqEVA==
X-Received: by 2002:a63:3712:: with SMTP id e18mr3909618pga.401.1584635999862;
        Thu, 19 Mar 2020 09:39:59 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id a185sm3060609pfa.27.2020.03.19.09.39.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 09:39:59 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, tglx@linutronix.de,
        broonie@kernel.org, corbet@lwn.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next 4/7] net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Fri, 20 Mar 2020 00:39:07 +0800
Message-Id: <20200319163910.14733-5-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200319163910.14733-1-zhengdejin5@gmail.com>
References: <20200319163910.14733-1-zhengdejin5@gmail.com>
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
 drivers/net/phy/bcm84881.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 14d55a77eb28..c916bd0f6afa 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -22,26 +22,14 @@ enum {
 
 static int bcm84881_wait_init(struct phy_device *phydev)
 {
-	unsigned int tries = 20;
 	int ret, val;
 
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
-
+	ret = phy_read_mmd_poll_timeout(val, val < 0 ||
+					!(val & MDIO_CTRL1_RESET), 100000,
+					2000000, phydev, MDIO_MMD_PMAPMD,
+					MDIO_CTRL1);
+	if (val < 0)
+		ret = val;
 	if (ret)
 		phydev_err(phydev, "%s failed: %d\n", __func__, ret);
 
-- 
2.25.0

