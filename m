Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE327637B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 12:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfGZK1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 06:27:47 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40430 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfGZK1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 06:27:46 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so52814519eds.7;
        Fri, 26 Jul 2019 03:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rewoVtfouB0g/nXQoB/RM2R5vzQI4yMuwrUsg0cojFo=;
        b=g8OSiArKsqZUyCCRvOtz447BXqWLIh9TENdSd8soBDBDjAQP6kBC/Y76w9OQNAN7uz
         zhThUk4Hz5YWZi1BGjCD9kUPg94uaxS/LiUQtCTuD+W3GO8nyy/AkwTIypOZGrkn/ZKP
         CoYfUqQARRdDtUaux9UkD8IULax0ircXxFaMu7puylYmpUFF/rIqcRYIgNfZ4Qe3McR7
         xvl86H14llCjOu/smTrglGY+lgpx99qiJVKUhau8QuKtBiC+Ey+K/DpjE+8f8vBbMjV3
         7twoAb/xQJzOTT90xqWT9/bFfjdLDAIaCEydE3OXhjg1EDtKCLDTf3B6cDa8yB4q8dKB
         7fHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rewoVtfouB0g/nXQoB/RM2R5vzQI4yMuwrUsg0cojFo=;
        b=h+1Z0VBCIaS28kNFReKu/7ysZcnxSEiuZTEIFT1jWUIFxO0N+kw+OQ5wjuvqX7cmZb
         UTDb5CVSmpGJCHC7PZXlBJOAi7ha+rYM+1ZtVXhq6i2OW3lHEKEIbc1TNWDuHjAyifuc
         jUXcNt6r/a1YuSyiStW4rqhUEMhy5JbQx8fBevPtE9tITuF4+HDBmx1JzneW6efpkJtG
         Osap9TiIwfxdFDwbxEISctATe1Fh8fjyBtPQYuTqrRBSB8nhIfUVPoHbL3/zK6b7BG39
         GLSmKBvGEZF8IwV+72Y309TTTEB/hfebtbhNE7eYsax8WeNDnnGdCAPfkORjr+v8u30L
         BBcw==
X-Gm-Message-State: APjAAAWUklX7aWI6B8NRBtQ03aJNvuAm0SzKYSJgFHCuWEkmpIOXLIof
        m8RsduQcaSUDcBtilVmstiI=
X-Google-Smtp-Source: APXvYqzHJhuMDDE9QF7E9JMSoVtDHfi8t0kysgpga1ZEPI+Hjwzo13gVjk020JOqtEC8/t8S217O2Q==
X-Received: by 2002:a17:906:bcd6:: with SMTP id lw22mr72674992ejb.68.1564136863962;
        Fri, 26 Jul 2019 03:27:43 -0700 (PDT)
Received: from localhost (pD9E51890.dip0.t-ipconnect.de. [217.229.24.144])
        by smtp.gmail.com with ESMTPSA id h10sm13307080edn.86.2019.07.26.03.27.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 03:27:43 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 2/2] net: stmmac: Do not request stmmaceth clock
Date:   Fri, 26 Jul 2019 12:27:41 +0200
Message-Id: <20190726102741.27872-2-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726102741.27872-1-thierry.reding@gmail.com>
References: <20190726102741.27872-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The stmmaceth clock is specified by the slave_bus and apb_pclk clocks in
the device tree bindings for snps,dwc-qos-ethernet-4.10 compatible nodes
of this IP.

The subdrivers for these bindings will be requesting the stmmac clock
correctly at a later point, so there is no need to request it here and
cause an error message to be printed to the kernel log.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 333b09564b88..7ad2bb90ceb1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -521,13 +521,15 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	}
 
 	/* clock setup */
-	plat->stmmac_clk = devm_clk_get(&pdev->dev,
-					STMMAC_RESOURCE_NAME);
-	if (IS_ERR(plat->stmmac_clk)) {
-		dev_warn(&pdev->dev, "Cannot get CSR clock\n");
-		plat->stmmac_clk = NULL;
+	if (!of_device_is_compatible(np, "snps,dwc-qos-ethernet-4.10")) {
+		plat->stmmac_clk = devm_clk_get(&pdev->dev,
+						STMMAC_RESOURCE_NAME);
+		if (IS_ERR(plat->stmmac_clk)) {
+			dev_warn(&pdev->dev, "Cannot get CSR clock\n");
+			plat->stmmac_clk = NULL;
+		}
+		clk_prepare_enable(plat->stmmac_clk);
 	}
-	clk_prepare_enable(plat->stmmac_clk);
 
 	plat->pclk = devm_clk_get(&pdev->dev, "pclk");
 	if (IS_ERR(plat->pclk)) {
-- 
2.22.0

