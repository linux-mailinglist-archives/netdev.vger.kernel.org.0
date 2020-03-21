Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90FA18E213
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 15:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgCUOih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 10:38:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46414 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgCUOig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 10:38:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id j17so7582067wru.13;
        Sat, 21 Mar 2020 07:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KHezbaonDObNhrnITsOBJjiiKzk30bQA9Nv61l1omqk=;
        b=cIcG4ZRm5PgmhKA92ygSxLPrxu7LZhPesEZxIfgPAfNuVpC7YynZsD5a/+MzA5EpaG
         ArirO23mGiHwzZYi/B/SyqQPJCqOCb73+L4OJo+pfY61/k43+TIAY4q2LUuU+rYsFd0j
         6KAWqV0zF3TRV7jnt+t+368F/ULon3DMD54hukiqnZ2huZsCrFoU2PopNmc6Apap92ZQ
         vS4AzOXyyvxnGKgRLMGkMfOFyOR0697PVql8GAy97analmoW7YVKNNG6C0IR1YBfh3Na
         wKI4PXD9KuA8QMHDrh0rBnyP21DFlRrmmhV++5JKSQXxrOi7dQSVafzDtkGo45gw/HnP
         5SHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=KHezbaonDObNhrnITsOBJjiiKzk30bQA9Nv61l1omqk=;
        b=tbQE8FSjRGmsLM1DHUEfu6Un4ZoRKPGHPi4lh6ZvsDUBAtlSGucZAP/4sE55zfmNwB
         8/Oi2UE57JNS6r7jOENTgh16tTRCM4cAe2BYPyhTB/0G3h9mJIQNW3baWJ4sbSTARAbL
         XYMFV1B31FMP85el3TAhHRAy1bUbQOgvEGYL1cBiGFYYGSghYRTHiaH6bjSfL9b9kHPD
         DpLJKjrGPp5OJZ1jX5S3/f+UBYJWvbK2rTTUYSrvTTHaK2k9ofdYfZ4yGIUZxtNtEoqz
         ru26oLomqSot2tDL16X8nXJxXhP+YCgd0lI4APX5ccs4kLRPcjOJy1TaC08DfmDVIdeG
         S1bA==
X-Gm-Message-State: ANhLgQ0xPrSa2+SdvOpKWkvbw9vUGxSgtzxu3pBCGuD4HEKPhw9TXY7v
        PNmZVWGLLu56C4bjsi/NFFzLw6W7
X-Google-Smtp-Source: ADFU+vvpJtD699uzrYrAyKDY3EnPQVf/SKIbwRg3zTVmGJ/b93WqeNNUlBpkc62TVccvt/eOjXNkHg==
X-Received: by 2002:adf:9b96:: with SMTP id d22mr19058977wrc.249.1584801514210;
        Sat, 21 Mar 2020 07:38:34 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4262:1ab:c:b4be:c5ec:d5f1:2a7f])
        by smtp.gmail.com with ESMTPSA id w204sm13499569wma.1.2020.03.21.07.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2020 07:38:33 -0700 (PDT)
From:   Emil Renner Berthing <kernel@esmil.dk>
To:     netdev@vger.kernel.org
Cc:     David Wu <david.wu@rock-chips.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emil Renner Berthing <kernel@esmil.dk>
Subject: [PATCH] net: stmmac: dwmac-rk: fix error path in rk_gmac_probe
Date:   Sat, 21 Mar 2020 15:36:19 +0100
Message-Id: <20200321143619.91533-1-kernel@esmil.dk>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we clean up devicetree related configuration
also when clock init fails.

Fixes: fecd4d7eef8b ("net: stmmac: dwmac-rk: Add integrated PHY support")
Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index dc50ba13a746..2d5573b3dee1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1406,17 +1406,17 @@ static int rk_gmac_probe(struct platform_device *pdev)
 	plat_dat->bsp_priv = rk_gmac_setup(pdev, plat_dat, data);
 	if (IS_ERR(plat_dat->bsp_priv)) {
 		ret = PTR_ERR(plat_dat->bsp_priv);
 		goto err_remove_config_dt;
 	}
 
 	ret = rk_gmac_clk_init(plat_dat);
 	if (ret)
-		return ret;
+		goto err_remove_config_dt;
 
 	ret = rk_gmac_powerup(plat_dat->bsp_priv);
 	if (ret)
 		goto err_remove_config_dt;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
 		goto err_gmac_powerdown;
-- 
2.25.2

