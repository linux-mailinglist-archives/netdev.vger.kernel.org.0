Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C380653A92E
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 16:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355014AbiFAO2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 10:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354990AbiFAO1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 10:27:41 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CF4263F
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 07:22:34 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id z13so2154991ljn.11
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 07:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vsEqLx3OgDPWs4ZLZiTy/4sPplZIdTXobmR6Gec9Res=;
        b=h94CdPcu+dARHjr4EssZ6BTEc/vGQO45X4Nuoq/mitPHx9QZKuiWPUxcRIR5NaOI4D
         RN2tYmO+UX9I/BumRzmgOijyHBO+qvwQzKoIIjWVTdkluzwZOUB4gFYwPFaNLkdYRI+Z
         JYSzmr88Kar6PBUw858oPrsyazEgLfqQuqVRY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vsEqLx3OgDPWs4ZLZiTy/4sPplZIdTXobmR6Gec9Res=;
        b=b/qwfN5fsilfgEJPqo4/HLpy7P5JQ3b1Wiczye1LF2EXiX/n08bpNsQlG2+93Gfuh8
         V/770PoVaS2rt6mb944WhjTStydoKC2faIQ/acdX1nqHD78fG5HM51a0YWwhDVVkrn/J
         2mtV9uD0aXEmhczm0XD1Wq0u0XQMVd0axOjjFlGWD5+hyvTIYrFjN8q8gGsy04O0KZVy
         IC9lShNUvQxfuAiwPDTHbi56/sIptFq2BSzMbZyq/TYHjAJqBA5qE9xEoC+cwjjUMJL8
         zjCkBpqJZpNjyAcR+RCuYDGonp/2cKjtAtQ1yEd3vriAddoC5harwlTtg/Oa7dg3IDNN
         +Kjg==
X-Gm-Message-State: AOAM531sz5xMjOQ88NuC8mIN0WWUrM9/Qgoj3VzX5dPyTPY+lZkBC+ow
        UW29F8HgfTu0CaheIJnKnP9iMQ==
X-Google-Smtp-Source: ABdhPJxMAt1NLVYOUw6pB3tro1F7SV4gxh6HLOIWuCWEzEcs7MAgK5A7qupPnnzpzHH5YenUpHzBUA==
X-Received: by 2002:a2e:88da:0:b0:255:51e2:32a6 with SMTP id a26-20020a2e88da000000b0025551e232a6mr7549883ljk.49.1654093352819;
        Wed, 01 Jun 2022 07:22:32 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id f14-20020a05651232ce00b0047255d2118csm388255lfg.187.2022.06.01.07.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 07:22:32 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] net: stmmac: use dev_err_probe() for reporting mdio bus registration failure
Date:   Wed,  1 Jun 2022 16:22:26 +0200
Message-Id: <20220601142226.1123110-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a board where these two lines are always printed during boot:

   imx-dwmac 30bf0000.ethernet: Cannot register the MDIO bus
   imx-dwmac 30bf0000.ethernet: stmmac_dvr_probe: MDIO bus (id: 1) registration failed

It's perfectly fine, and the device is succesfully (and silently, as far
as the console goes) probed later.

Use dev_err_probe() instead, which will demote these messages to debug
level (thus removing the alarming messages from the console) when the
error is -EPROBE_DEFER, and also has the advantage of including the
error code if/when it happens to be something other than -EPROBE_DEFER.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3b81d4e9dc83..8a739746c951 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7129,7 +7129,7 @@ int stmmac_dvr_probe(struct device *device,
 		/* MDIO bus Registration */
 		ret = stmmac_mdio_register(ndev);
 		if (ret < 0) {
-			dev_err(priv->device,
+			dev_err_probe(priv->device, ret,
 				"%s: MDIO bus (id: %d) registration failed",
 				__func__, priv->plat->bus_id);
 			goto error_mdio_register;
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

