Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4612B27E
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 12:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfE0Kwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 06:52:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37534 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfE0Kwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 06:52:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id 7so15378343wmo.2;
        Mon, 27 May 2019 03:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A1VWy41IvoBarmDwJxKEbfTJGr59Xp9sqvlsdgaxrsc=;
        b=J5gRHCse3CBmGc8Tbhh4Z7Ego/mItRapUC4tFdD7VIq2E2J6ITKBdnuhX0gOG75Q+F
         72kdy4TL3OhGPj3aKHq+tD5P4ByOIsYwzzu536W02hsutPmvXPkAF9Px5NLWOJFNqpQR
         QcDj3KcF/b0UafdyYSj44khXzz4T7KHC1ea/L8+u7XFg/X9IvTe/w+AR+JzS1Kila4eQ
         UfuV12TR3I4AzYGYWUQ5eE+BR5HQyEyTEEPSk5kyOhhnY9Gbo/aXH8CChft7DJxAyk+0
         CXS2sFaVuF03N6FoqF7Oo6m/iQ7MIBLu9GbC4Q8S6y0SKJRZXgmsyNo5sWqdxeEsDGI+
         7nMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A1VWy41IvoBarmDwJxKEbfTJGr59Xp9sqvlsdgaxrsc=;
        b=lh4PEzQSoh7LyByoVBIBJ++IPt6bGXWE8zDEa4Ido/RPT0AEIbMqYs+HerQnNrNAz+
         WsJNnG4IhXgJZlE6DplDxTEBwPLplZNCybOgZbqhYYrJG70t7XTFwLNzSpciwF5JaCUa
         Ug6fRD3DZ7txXNVYNjDEBcUO9kRTqeXylAaP08Zs8h3Fs4krOOFzgpBLbkGD0/uZ6sdX
         SdILhCyb55yTH+yRawKOckp+Y6EQe3k6pKYjguuBxKglHvas6gFuK8KezQnWoyPleYRw
         ZijyiJudu2AGMX1WhWEheRKt1soLta4rTQGeBRgbIOTYfQpZSFwFrGwKVBWJOiWL5tiQ
         H3Qg==
X-Gm-Message-State: APjAAAVc7lZpkUFUb2a5x5NpA8aM6noVQ3DGj+9aNPIGPKd1/9OaZZAm
        w1/H2qC0m8jOXIay6SRwz9o=
X-Google-Smtp-Source: APXvYqzcLhyjl5mQsT1SZ9iPldQjotTqTvtgR4egYrw0ernmhv1aXyAumiFkr5weubhrHo9ioAOHLQ==
X-Received: by 2002:a1c:6c04:: with SMTP id h4mr18906175wmc.135.1558954373276;
        Mon, 27 May 2019 03:52:53 -0700 (PDT)
Received: from localhost (p2E5BEF36.dip0.t-ipconnect.de. [46.91.239.54])
        by smtp.gmail.com with ESMTPSA id o8sm25682324wra.4.2019.05.27.03.52.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 03:52:52 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH] net: stmmac: Do not output error on deferred probe
Date:   Mon, 27 May 2019 12:52:51 +0200
Message-Id: <20190527105251.11198-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

If the subdriver defers probe, do not show an error message. It's
perfectly fine for this error to occur since the driver will get another
chance to probe after some time and will usually succeed after all of
the resources that it requires have been registered.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 3256e5cbad27..5bc224834c77 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -455,7 +455,11 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 	priv = data->probe(pdev, plat_dat, &stmmac_res);
 	if (IS_ERR(priv)) {
 		ret = PTR_ERR(priv);
-		dev_err(&pdev->dev, "failed to probe subdriver: %d\n", ret);
+
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "failed to probe subdriver: %d\n",
+				ret);
+
 		goto remove_config;
 	}
 
-- 
2.21.0

