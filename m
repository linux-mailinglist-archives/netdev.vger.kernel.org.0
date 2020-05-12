Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320311D003F
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 23:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbgELVLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 17:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728275AbgELVLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 17:11:25 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FF3C061A0C;
        Tue, 12 May 2020 14:11:25 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e26so23835959wmk.5;
        Tue, 12 May 2020 14:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HwKE63xeunU+7jFifhH7Cu96Jgtp0mRWAcPlbA44y5E=;
        b=juJF+3lb7lglsBfA48oWK2otHLd6Zv1VPqsqeH4y7PUUPFJY0U8jSd5BIu39d4bBPl
         Ha6PuABEnMyT6qylAqav/xiblas1pBKWgHcgkgSO2AQY8ANt38qSwJqxU/odINnURDTJ
         6ZMtR/XldqHZlqW5BwW5ZQAEtCMYwXfo8dYqQ0WiYWIyVa23Bg2LvCsBT8vwwCkEJPxc
         cKmBiT7hmi3nV5FgJgTVUZ8Koblo0HEBysz2QWqz4RLGKfYPC98CRt4SCwR4wcPsRAGn
         oEZzjQUyUIvsqz4qN8Esqvzvwp4mrPN50l/19Dtk6bzX7dkXzC8XXR/4PNSNQ+obkzKc
         rCyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HwKE63xeunU+7jFifhH7Cu96Jgtp0mRWAcPlbA44y5E=;
        b=IwU3rHNoGh0zWbRqV/qPphS51G0w8qItca8ZjM5yFRGg4Nt1S/y4hQzoztLThX0Ayh
         BxN1JSYu23dR+MvMXz/m+V4ZG3is07VELKpu+I745N8SqH002kq5gJUqfRjr8NwsIf8m
         SPYgMyvRtx3ZOBJhl0xCBZZeEb8St8cBIa2Cl0DmVMd/pn0r2yCaSkU2KrI3kPjKYCI9
         py9ippFYuyX5WeIU9nnReh7R3A0aLm/Uqh3ra17KEePA0RgZ649bl71KwEWqCIS9sjyn
         eirbRjebW5S542KkNBe/cODw13PTYtZf8Ix9V8Sipn/RS8BFi1lh/9qoPEAaNeSm+5Er
         BeTw==
X-Gm-Message-State: AOAM530i5rNSEC+U1fJfqgtNFFP+A9FZh+aVOEeCA6mbwoZs/iV3cH8k
        GIabzbXo83Ud/tzzdsPGwI8=
X-Google-Smtp-Source: ABdhPJyXbvM6Skz8OIqLk5ZeLyL3PREBPCLQ6UyzGCBiK3jStYDaYt6yd9/iDrKNxjIYuojFg/W/Xw==
X-Received: by 2002:a7b:c385:: with SMTP id s5mr4509808wmj.189.1589317883939;
        Tue, 12 May 2020 14:11:23 -0700 (PDT)
Received: from localhost.localdomain (p200300F137132E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3713:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id r3sm9724228wmh.48.2020.05.12.14.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 14:11:23 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 7/8] net: stmmac: dwmac-meson8b: Make the clock enabling code re-usable
Date:   Tue, 12 May 2020 23:11:02 +0200
Message-Id: <20200512211103.530674-8-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timing adjustment clock will need similar logic as the RGMII clock:
It has to be enabled in the driver conditionally and when the driver is
unloaded it should be disabled again. Extract the existing code for the
RGMII clock into a new function so it can be re-used.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 23 +++++++++++++++----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 41f3ef6bea66..d31f79c455de 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -266,6 +266,22 @@ static int meson_axg_set_phy_mode(struct meson8b_dwmac *dwmac)
 	return 0;
 }
 
+static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
+					   struct clk *clk)
+{
+	int ret;
+
+	ret = clk_prepare_enable(clk);
+	if (ret)
+		return ret;
+
+	devm_add_action_or_reset(dwmac->dev,
+				 (void(*)(void *))clk_disable_unprepare,
+				 dwmac->rgmii_tx_clk);
+
+	return 0;
+}
+
 static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 {
 	int ret;
@@ -299,16 +315,13 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 			return ret;
 		}
 
-		ret = clk_prepare_enable(dwmac->rgmii_tx_clk);
+		ret = meson8b_devm_clk_prepare_enable(dwmac,
+						      dwmac->rgmii_tx_clk);
 		if (ret) {
 			dev_err(dwmac->dev,
 				"failed to enable the RGMII TX clock\n");
 			return ret;
 		}
-
-		devm_add_action_or_reset(dwmac->dev,
-					(void(*)(void *))clk_disable_unprepare,
-					dwmac->rgmii_tx_clk);
 		break;
 
 	case PHY_INTERFACE_MODE_RMII:
-- 
2.26.2

