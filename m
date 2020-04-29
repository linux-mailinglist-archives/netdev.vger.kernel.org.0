Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878E51BE85D
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgD2URx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgD2URW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:17:22 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78CAC03C1AE;
        Wed, 29 Apr 2020 13:17:21 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s10so4151967wrr.0;
        Wed, 29 Apr 2020 13:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1zoQa+ThGA1a5k62C+YVRReIRqRAT+ZWYkJ8mwLP5jA=;
        b=HO0Mhip1lp0c90pKkg5HF+2Xi8ipoLoZCjBymL/hCZEdtEOUvuhAyu2Emi+oh14tz0
         treSzae4lgi7uEJjpqdN8NcvelrsiR4b2Xoto0beyyaagymmYETL4HDgy7DgnF/tpzRp
         fW+jNCw5vh1mXIdvzcbSAqBq5y/3lqESvMrnxe9WCWl9OrKmsNjyVv7bE176w2OvP+Ao
         jsnuPqlWWzFyi2l8n3BzieNBlqqOM8IuuDmtVTtwwh/qR6Ya2+ieBJRlC9hCsBYQrHcS
         eDTudmAAD1UARmX0Vc64TqggXt8GPIDtrTENM1eNjQOs6uE05Xl/RD90zMwzpeiYCubt
         Zu6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1zoQa+ThGA1a5k62C+YVRReIRqRAT+ZWYkJ8mwLP5jA=;
        b=o8/rr1dqbtkovkYajxSPsbPTGygj5wZm74V6nqpOEPxIfA48cj61iGzxBvMYbdjF33
         wbgACZKaTPvHWgVGLl3a4co+TUorq6BTfKkWEt0TSjYzkUil4va961ZWFKuWsbZbJdgh
         +QSs1boDihY4iLphyI4iUcO16Amf2qAGVR8HwVz/FJMuWZCfvzlCbmfmg7mmMTXDJ/x2
         LDsC3NTN7CCW6aAlXhQtXSXsnAt0M1B0FazrqmgJjsKjhV8E3SWtFxjRmcUz5nEqewTL
         NwPybBsl/nWEVcYOG3gvqm+wCZjpl0GxJVtxJrsZmEy7BpD0XXfwEpeAncu9u+m14LMg
         8ShA==
X-Gm-Message-State: AGi0PuaEJBJUkX3Di/anUrUeRU7wOlbdHpXiRXIxltpKhTGmoRo8FIuu
        QYzy2YVhI/Vp00OIVKkVjqQ=
X-Google-Smtp-Source: APiQypJoQwUeXB+jHIHYSWOGywH5PFpLgoIjMjyC73XkhqWlu0AlzPO5mP6r3x1t/ptbpRKTAX7qlA==
X-Received: by 2002:a5d:4b0a:: with SMTP id v10mr19723880wrq.342.1588191440393;
        Wed, 29 Apr 2020 13:17:20 -0700 (PDT)
Received: from localhost.localdomain (p200300F137142E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3714:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q143sm9923623wme.31.2020.04.29.13.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:17:19 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 07/11] net: stmmac: dwmac-meson8b: Make the clock enabling code re-usable
Date:   Wed, 29 Apr 2020 22:16:40 +0200
Message-Id: <20200429201644.1144546-8-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
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

