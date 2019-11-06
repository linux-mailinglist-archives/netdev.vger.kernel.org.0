Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506DEF10B8
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 09:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbfKFIBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 03:01:46 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53458 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbfKFIBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 03:01:46 -0500
Received: by mail-wm1-f65.google.com with SMTP id x4so2200694wmi.3;
        Wed, 06 Nov 2019 00:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OmFJplJ1m4VwQ427zpEUzGG+xB7JCkAtrYHj59vzKyE=;
        b=MrbKKbkEEpLaaU1VA3LNiZShxLjleQKizjxFb7o/RogoTWhFIPRUc8oQXlcid/bVNM
         4vs+KOYK7Xf5q6D0wkM5qVbvZknjzUgZottXfmR5MFEA8mY2XmBlY4ZTY/GEXT4tQgGD
         xZMblYOfLeUwcmgAh0AYFTdcMatBIMY9scFaNjjkUM2hSIGADavlKn+ob8wlhdBpTWFE
         b6u2fPUxGn+S7Y+T9FluJIptb5NoU0PCt/U5tbNkP8kJORoGJCa5gfOx1u6OtF32xgIi
         kcJUVmQsTwlYtYMdKaLGN1KJKArN03Zdlu1TVBOLR+b2T91a2uyIj49Iyzv0HjsN4W4a
         XJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OmFJplJ1m4VwQ427zpEUzGG+xB7JCkAtrYHj59vzKyE=;
        b=nNQW7zFxps+qoCaaIc0dYMZchZdo19VtBkJNQWKNHjFK27xNr5Dx2Gkt7BXJ84lOX3
         jA1Q1041VuoNLShWJqsVpzXo0ojx1q/GXkGu/cWcQOXYW9O9qCIaEkuYcfwFHa+Gl6VI
         56TJeAP9dXQMJWSXLBLn6KWUgiLWRtEMyBOQ8uRhSPZGeP22f+n/04w1wpD+NNljP/fH
         rVobrQBa53zmat08GNuRT/neCHaktCW8u8qlpUocXuHDr18xh6fjXGf1YVBp+6HsCaOU
         sAXnqOCWLg3pSMnp17jFRam5dqpbuKExW1Tl12YCbGiXKdJVllYh1CqM5YkFZ+e8Jcyv
         0Sxg==
X-Gm-Message-State: APjAAAUV56qm7uV/YygmjQZ5cY3RUm0iqqKtrvDYxfEpCP11Y4GfgvN0
        E2XdCNnsH4jmNlqFpob4G6I=
X-Google-Smtp-Source: APXvYqz0qSwFylWIoX9SCHh6ZEfiYNutupEMlWdsubaKkmKhmucKMct2x7LvguGkr4ZOhw5eOEZczQ==
X-Received: by 2002:a1c:b607:: with SMTP id g7mr1032801wmf.94.1573027304320;
        Wed, 06 Nov 2019 00:01:44 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id q124sm1196668wme.13.2019.11.06.00.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 00:01:43 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net: fec: add a check for CONFIG_PM to avoid clock count mis-match
Date:   Wed,  6 Nov 2019 16:01:28 +0800
Message-Id: <20191106080128.23284-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_PM is enabled, runtime pm will work and call runtime_suspend
automatically to disable clks.
Therefore, remove only needs to disable clks when CONFIG_PM is disabled.
Add this check to avoid clock count mis-match caused by double-disable.

This patch depends on patch
("net: fec: add missed clk_disable_unprepare in remove").

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a9c386b63581..696550f4972f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3645,8 +3645,10 @@ fec_drv_remove(struct platform_device *pdev)
 		regulator_disable(fep->reg_phy);
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+#ifndef CONFIG_PM
 	clk_disable_unprepare(fep->clk_ahb);
 	clk_disable_unprepare(fep->clk_ipg);
+#endif
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
-- 
2.23.0

