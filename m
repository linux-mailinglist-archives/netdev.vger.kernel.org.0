Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F40553B494
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 09:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiFBHt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 03:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiFBHt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 03:49:27 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C9F20BB03
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 00:49:25 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id i10so6595299lfj.0
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 00:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K13Ss91uwNp953S1Qn2a/l7SKkqhzBXyNe1HDSvV5fM=;
        b=Yc5ldH5FA5hc0E+wFlHEiyL25VUeJfBDdSeE2esW+o4HCh9hmSwdz5uaPH5GbVe2bR
         5RIxWXfWBbZB7dJkZK3Vkz+9qWrl9l2kZOZQpfj0bHUl9HjQCBIthCNLeFxs/RGCzJpA
         xy6OI4LxCPuEWItM5/HTOrytYxP0k9B5S0iYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K13Ss91uwNp953S1Qn2a/l7SKkqhzBXyNe1HDSvV5fM=;
        b=wNAxJiFa5oqI1Qpzgrgn/6CvQpzwgOV3AEZKpRblhPWciZfuhypVRbzn+3papQX9tV
         ti6b1q4cQQP6YPapQclrcHfBVcWNQ4TzDWoWL3poI2CLv4aes5fgCL34QG7oFHi2+hVx
         qOl6PccGb7BzuYoq5e3drswGkiCd5P0odw2p9uIu+h32lTMWFgmFxNa0lHzwm2R73Atc
         OZVieWRo2/KSgUZa8qxma+y+9FnT5ybE9kKGSz9c0LwXAA5mzp31NRM9xHPK2XBYWO+l
         inedw5jS8fluSXW0zWlGnQy4BBSig2tXUaHDfWnfGTDnuG1SVCz1TuuK0uo5G+DpDRZk
         y1gQ==
X-Gm-Message-State: AOAM530pU9kZosQlHfaHIJZo04v6kIi5l91n0Tl50SG56ksXgyF5bHP8
        IT0htBQz9nmgaNtG3T/9EnbWUw==
X-Google-Smtp-Source: ABdhPJxkBlNJitxs05xkYj69VKHytIrfhfkMwd06bHf/13V/I9QQsXpeRKacHX4d2Uq4oak0J0Uvow==
X-Received: by 2002:a05:6512:c1d:b0:478:f321:a57b with SMTP id z29-20020a0565120c1d00b00478f321a57bmr2584044lfu.125.1654156163819;
        Thu, 02 Jun 2022 00:49:23 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id m16-20020a056512115000b00478f2f2f044sm882946lfg.123.2022.06.02.00.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 00:49:23 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2] net: stmmac: use dev_err_probe() for reporting mdio bus registration failure
Date:   Thu,  2 Jun 2022 09:48:40 +0200
Message-Id: <20220602074840.1143360-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220601142226.1123110-1-linux@rasmusvillemoes.dk>
References: <20220601142226.1123110-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a board where these two lines are always printed during boot:

   imx-dwmac 30bf0000.ethernet: Cannot register the MDIO bus
   imx-dwmac 30bf0000.ethernet: stmmac_dvr_probe: MDIO bus (id: 1) registration failed

It's perfectly fine, and the device is successfully (and silently, as
far as the console goes) probed later.

Use dev_err_probe() instead, which will demote these messages to debug
level (thus removing the alarming messages from the console) when the
error is -EPROBE_DEFER, and also has the advantage of including the
error code if/when it happens to be something other than -EPROBE_DEFER.

While here, add the missing \n to one of the format strings.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
v2: Reindent following lines, fix spello in commit message, also add \n.

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 +++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3b81d4e9dc83..d1a7cf4567bc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7129,9 +7129,9 @@ int stmmac_dvr_probe(struct device *device,
 		/* MDIO bus Registration */
 		ret = stmmac_mdio_register(ndev);
 		if (ret < 0) {
-			dev_err(priv->device,
-				"%s: MDIO bus (id: %d) registration failed",
-				__func__, priv->plat->bus_id);
+			dev_err_probe(priv->device, ret,
+				      "%s: MDIO bus (id: %d) registration failed\n",
+				      __func__, priv->plat->bus_id);
 			goto error_mdio_register;
 		}
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 9bc625fccca0..03d3d1f7aa4b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -482,7 +482,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 	err = of_mdiobus_register(new_bus, mdio_node);
 	if (err != 0) {
-		dev_err(dev, "Cannot register the MDIO bus\n");
+		dev_err_probe(dev, err, "Cannot register the MDIO bus\n");
 		goto bus_register_fail;
 	}
 
-- 
2.31.1

