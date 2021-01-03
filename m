Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6324A2E89CB
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 02:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbhACB0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 20:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbhACB0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 20:26:41 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4B0C0613C1;
        Sat,  2 Jan 2021 17:26:01 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id jx16so32166037ejb.10;
        Sat, 02 Jan 2021 17:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2UOqQ4to22i0EnrVVvZCa3Uq60RXDtYLcZVnEvKV1nc=;
        b=Ul/q7EhmQw5F7xPOlh4+bpVyAiHAA9k6aBe2SfUtrGzaJI+UwEOkteSJatPFs4+4ia
         dxgCQhinwakP1k6FunaUSTgVn6zOzr25haFLsAsqy4wmDiZvrzTiMLdfoD0KfJLpSmCV
         KwFOMwWaANw9LYmD1sUeRisdO+P/+d5cigCtcYr4JaEEqMrtNehRgAXw4FWSuNXuLz4k
         4sNcHbZstjyPqAoG9NxIPEz1s6EEp5vEyObECxhelZRIzZ9T5jeq41H/OT4a7yHfC5c5
         04eb4CrulIorSzWKUo8EUmT9Z31dixB/Yfm4N+Xerlhn7a8+/olVnrPrT8OoIocuGSqB
         l6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2UOqQ4to22i0EnrVVvZCa3Uq60RXDtYLcZVnEvKV1nc=;
        b=Ov69dWrgHHW3g/ZgNlbQ3YY/g01EM8/R9xJUWfOcD2jHSFaRXuSaQuSwY20JmJc/ma
         HIcWi3R5Zj2EfFKOsUlhxeLkRU6mT+fxtPHEPVn2kBVVGLv4Y4IEiVCmPy8dROgfdGhD
         PxCMYeta5qqaG9MEzp7uKIGLMyud6lIRKG8LhZ1jPw+wZ1x+cZ5BNL0XzboC/5Hsv7o6
         eKcVS0zThps5BR7VeS1FydjK+Kqzwc1TxA2rYiA/Vlet/1qme3KzntD0/Ko+rzBDoYBY
         Vib9Miguja050zvNauCFyjEoB8m/gyGAv+o3AaPD8mqdPvTPFSnW9Q2cyqn2Z7CNsRhL
         52YQ==
X-Gm-Message-State: AOAM5333Vgj7sXkzCM16BKzXjnQ7nFTyb94YGkWYVY0Hde1o5aXfxqp7
        Y3Y6+1wCey7XxnGeddLqB3I=
X-Google-Smtp-Source: ABdhPJzmIjLwUagL7GdNwIkMmm4RgvvqFjyAPHnkfDtkIG1Bcw2gYF2+vWeTPMlaVpsR4n+mYGPr7w==
X-Received: by 2002:a17:906:4d17:: with SMTP id r23mr64843341eju.87.1609637159855;
        Sat, 02 Jan 2021 17:25:59 -0800 (PST)
Received: from localhost.localdomain (p200300f13724fd00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3724:fd00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id op5sm22118006ejb.43.2021.01.02.17.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 17:25:59 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also for internal PHYs
Date:   Sun,  3 Jan 2021 02:25:43 +0100
Message-Id: <20210103012544.3259029-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
References: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable GSWIP_MII_CFG_EN also for internal PHYs to make traffic flow.
Without this the PHY link is detected properly and ethtool statistics
for TX are increasing but there's no RX traffic coming in.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Cc: stable@vger.kernel.org
Suggested-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 09701c17f3f6..5d378c8026f0 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1541,9 +1541,7 @@ static void gswip_phylink_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct gswip_priv *priv = ds->priv;
 
-	/* Enable the xMII interface only for the external PHY */
-	if (interface != PHY_INTERFACE_MODE_INTERNAL)
-		gswip_mii_mask_cfg(priv, 0, GSWIP_MII_CFG_EN, port);
+	gswip_mii_mask_cfg(priv, 0, GSWIP_MII_CFG_EN, port);
 }
 
 static void gswip_get_strings(struct dsa_switch *ds, int port, u32 stringset,
-- 
2.30.0

