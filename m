Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A8476379
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 12:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfGZK1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 06:27:45 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42370 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfGZK1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 06:27:44 -0400
Received: by mail-ed1-f66.google.com with SMTP id v15so52860370eds.9;
        Fri, 26 Jul 2019 03:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fgttaSu7/U77TvA6+GrlVNqDjBSP1cH/fJcE2FiVPSc=;
        b=Xq7dFVT2BAh2OKlWZADYRxsgSTDnQyREt3lSe51iX1a4VbZ5tbKueNdrd8Tl55F0fH
         jE3HFiLoW8gJBQlPDGPk09oV2PXFmSxEwhfiga28IsSjQuAMyh4iZz9h/hztR9xouEnd
         sqIB7z6gCSaIlN39Lb+vWX3jNLyTJ3SmcVHqvm1x0WsB54H9SOBztWS7rYaON6kYgWk5
         bhSswDrnGIsOjLJshXfCPLprUZ4ieqHvqFCwH8muxoHfuCX/cVp+2R3n3jCysfYL+MwC
         t99y8R7UaVlbRoQhdBAUbmy7gOX+/ySaOLp618i6NcMZT6wRk6d4Z0iX4GpyPt/RNhGW
         iYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fgttaSu7/U77TvA6+GrlVNqDjBSP1cH/fJcE2FiVPSc=;
        b=NYeXuq6aifjdmi76hiAdIPf4b17rqD9WOZyYswEa0a2JZn3b2v4LCuxIJakhUJKTkX
         XuqvVXtf9Z1qDl1QUY+KIqi0C9D+qODJfNwY+pZVOxBd66zdATN+ls6RISrDrOjI4IQw
         Do/ObFNwgYbBOarM9XtmO2Ap9eHeVlW84D1R+mq+0pFF/3wUQ9KtktHowrPwzcC+X2yK
         0LjB0l4mUOlIZpx8LoUcJvcjj9rWo5InOJRtc195lIgdq0GwLCICjfxku38EeDy8eiY2
         1fUo9wrk2atJkxTKeJeerM5lPPkoAqbRkYDLYlF6lNnnDMUEiahSNQQ0B0CJvAB8QTcq
         oqew==
X-Gm-Message-State: APjAAAUtX1VkOpGnQwHzxISuFi96C9KI1oNYP6sIJfXBjUATYHcbGTcu
        U4Cu1lrhqYC7qkai3Y5CxJg=
X-Google-Smtp-Source: APXvYqwQ4adhOOkffJ+ooQljdZOK2+c+FVkKICz8TXR5in66XUj5Vqepfv9d8dlyGCxc9wsvjX1kJA==
X-Received: by 2002:a50:b3b8:: with SMTP id s53mr81412876edd.61.1564136862640;
        Fri, 26 Jul 2019 03:27:42 -0700 (PDT)
Received: from localhost (pD9E51890.dip0.t-ipconnect.de. [217.229.24.144])
        by smtp.gmail.com with ESMTPSA id v12sm10210515ejj.52.2019.07.26.03.27.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 03:27:42 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 1/2] net: stmmac: Make MDIO bus reset optional
Date:   Fri, 26 Jul 2019 12:27:40 +0200
Message-Id: <20190726102741.27872-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The Tegra EQOS driver already resets the MDIO bus at probe time via the
reset GPIO specified in the phy-reset-gpios device tree property. There
is no need to reset the bus again later on.

This avoids the need to query the device tree for the snps,reset GPIO,
which is not part of the Tegra EQOS device tree bindings. This quiesces
an error message from the generic bus reset code if it doesn't find the
snps,reset related delays.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 3 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c       | 4 +++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c        | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c   | 8 +++++++-
 include/linux/stmmac.h                                  | 1 +
 5 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 3a14cdd01f5f..66933332c68e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -333,6 +333,9 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 	usleep_range(2000, 4000);
 	gpiod_set_value(eqos->reset, 0);
 
+	/* MDIO bus was already reset just above */
+	data->mdio_bus_data->needs_reset = false;
+
 	eqos->rst = devm_reset_control_get(&pdev->dev, "eqos");
 	if (IS_ERR(eqos->rst)) {
 		err = PTR_ERR(eqos->rst);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 4304c1abc5d1..40c42637ad75 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -348,7 +348,9 @@ int stmmac_mdio_register(struct net_device *ndev)
 		max_addr = PHY_MAX_ADDR;
 	}
 
-	new_bus->reset = &stmmac_mdio_reset;
+	if (mdio_bus_data->needs_reset)
+		new_bus->reset = &stmmac_mdio_reset;
+
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		 new_bus->name, priv->plat->bus_id);
 	new_bus->priv = ndev;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 86f9c07a38cf..d5d08e11c353 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -63,6 +63,7 @@ static void common_default_data(struct plat_stmmacenet_data *plat)
 	plat->has_gmac = 1;
 	plat->force_sf_dma_mode = 1;
 
+	plat->mdio_bus_data->needs_reset = true;
 	plat->mdio_bus_data->phy_mask = 0;
 
 	/* Set default value for multicast hash bins */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 73fc2524372e..333b09564b88 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -342,10 +342,16 @@ static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
 		mdio = true;
 	}
 
-	if (mdio)
+	if (mdio) {
 		plat->mdio_bus_data =
 			devm_kzalloc(dev, sizeof(struct stmmac_mdio_bus_data),
 				     GFP_KERNEL);
+		if (!plat->mdio_bus_data)
+			return -ENOMEM;
+
+		plat->mdio_bus_data->needs_reset = true;
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 7d06241582dd..7b3e354bcd3c 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -81,6 +81,7 @@ struct stmmac_mdio_bus_data {
 	unsigned int phy_mask;
 	int *irqs;
 	int probed_phy_irq;
+	bool needs_reset;
 };
 
 struct stmmac_dma_cfg {
-- 
2.22.0

