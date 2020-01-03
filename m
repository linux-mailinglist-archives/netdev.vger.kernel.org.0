Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB2412F270
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 02:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgACBDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 20:03:36 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52062 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbgACBD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 20:03:26 -0500
Received: by mail-pj1-f67.google.com with SMTP id j11so3950796pjs.1;
        Thu, 02 Jan 2020 17:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5zW2sawHSuJeuDAKrH4RbhZjM5dVp293z99etfp8rFE=;
        b=Sqf7WuzwrEH+Mfhvl5zsdSNHo7p2L/rTxVO6VS0QMWU+b9RvGOphyN9SaBLkfDYalP
         ybXCshIIhox6l2mRaYOuxmGLnNR+vXdzeRsOiLCh8x/5g2hzR3s6UbAKmokxP1VH9UsA
         3GkUfnO2Ea1jIClPt8FssXz24LwsJx7AHYjCoJ3u1pgwa1BUPKUpQ9NbddL4DolRK4Rx
         k+HX26jdblWlpbeEixm1gi95u4KXkZ9okEqhkfiMLa9eNAhQXp6ZojsqITBLvSLtx115
         dPeA3TMVglEhBZ/bRuXBB9d+E+pgXV5DRRW7Mu2b8LhMn1/1bjBonlfgng84Wf3K4/TY
         sX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5zW2sawHSuJeuDAKrH4RbhZjM5dVp293z99etfp8rFE=;
        b=AEws0tYQqQCLP8rh3c9+RouJ67eepwIlpvqkpNo9FqDSlmHBb4j0lfD43oHVlY9Fit
         zduREclwNk7qPNm7l45GGR2tdvBSNqbpus20l/bPw9gF/+a0rHRB+CerF/ntekXjo7WI
         YNqetocKd41npFdlFbho10Lme24W2g7Yej34JSfJd8MOvqlUEbaA9aC5fUg8JaVxEwmw
         tsSgmR+mJqumWyhAWCX8m4wLuGy2Ol9w8MdRIb0sJhOoxBPeHDWkYdMbhGCre2pfnjE3
         uheqhBuBbPuSQGm/zESASWCbG7CFHy88emz6DoPqrpVNr6QQ1Atnr5O0LMNSms10OzWZ
         EiqQ==
X-Gm-Message-State: APjAAAXdt5G3FKi7xXYBBRnDFNrVnFKHQhK+oISnwcWLBwVw3AxwytCK
        87sajpQaT/yAtbQg5wMuVL6sNmXj
X-Google-Smtp-Source: APXvYqzaTD7v5SjxVUglbOFVS9XQDNlsMDsKJaaHESeQBDtgUORh8LCXzb/4342p/1ohffF/qG/8Uw==
X-Received: by 2002:a17:90a:b78d:: with SMTP id m13mr23801500pjr.100.1578013405540;
        Thu, 02 Jan 2020 17:03:25 -0800 (PST)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id 5sm12780784pjt.28.2020.01.02.17.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 17:03:25 -0800 (PST)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v3 2/3] net: phy: fixed_phy: fix use-after-free when checking link GPIO
Date:   Thu,  2 Jan 2020 17:03:19 -0800
Message-Id: <20200103010320.245675-3-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
In-Reply-To: <20200103010320.245675-1-dmitry.torokhov@gmail.com>
References: <20200103010320.245675-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we fail to locate GPIO for any reason other than deferral or
not-found-GPIO, we try to print device tree node info, however if might
be freed already as we called of_node_put() on it.

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

 drivers/net/phy/fixed_phy.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 7c5265fd2b94d..4190f9ed5313d 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -212,16 +212,13 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
 	 */
 	gpiod = gpiod_get_from_of_node(fixed_link_node, "link-gpios", 0,
 				       GPIOD_IN, "mdio");
-	of_node_put(fixed_link_node);
-	if (IS_ERR(gpiod)) {
-		if (PTR_ERR(gpiod) == -EPROBE_DEFER)
-			return gpiod;
-
+	if (IS_ERR(gpiod) && PTR_ERR(gpiod) != -EPROBE_DEFER) {
 		if (PTR_ERR(gpiod) != -ENOENT)
 			pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
 			       fixed_link_node);
 		gpiod = NULL;
 	}
+	of_node_put(fixed_link_node);
 
 	return gpiod;
 }
-- 
2.24.1.735.g03f4e72817-goog

