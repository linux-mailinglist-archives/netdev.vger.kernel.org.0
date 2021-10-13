Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB1142CB46
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhJMUqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhJMUqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 470C26113E;
        Wed, 13 Oct 2021 20:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157885;
        bh=GJNFpj2uq4PlQYpDnuA0lO36wO2/NqM8J0N72JSQp4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kk5HfOxVljOkpyCoC6SAZQU7GKlTNaqla0OzSPa6CB7C3wb+Jx5NTUHQA+QIxzlFf
         dqLnFWtFEhN+rEDRlpNk/2KM8hhdk94dCK49cD6RzwcM2gQuJu07wrlnHk9MX1Km6T
         3YuEvT0o+6T556wKcaD0mnmUJ8OI52foH18p48oRFNzOSt7eLs+IhKY2XgiEgf1f13
         M+4mchLzrB7DB/9455TsfTGIl5Fxuv3MjXCmAeHhEuMImwNyP1jYBrx0Le54j61K1t
         1zqPAtVPFlwgpudfs5Ag25mNBacXUJH7/i6JsvxqoTvuIbKeKtQdwHMQPSMh2PnRki
         oEInEY7URy0yg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        chris.snook@gmail.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, subashab@codeaurora.org,
        stranche@codeaurora.org, michael@walle.cc,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 3/7] ethernet: make use of eth_hw_addr_random() where appropriate
Date:   Wed, 13 Oct 2021 13:44:31 -0700
Message-Id: <20211013204435.322561-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013204435.322561-1-kuba@kernel.org>
References: <20211013204435.322561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Number of drivers use eth_random_addr(netdev->dev_addr)
thus writing to netdev->dev_addr directly, and not setting
the address type. Switch them to eth_hw_addr_random().

  @@
  expression netdev;
  @@
  - eth_random_addr(netdev->dev_addr);
  + eth_hw_addr_random(netdev);

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: chris.snook@gmail.com
CC: ulli.kroll@googlemail.com
CC: linus.walleij@linaro.org
CC: yisen.zhuang@huawei.com
CC: salil.mehta@huawei.com
CC: subashab@codeaurora.org
CC: stranche@codeaurora.org
CC: michael@walle.cc
CC: linux-arm-kernel@lists.infradead.org
---
 drivers/net/ethernet/atheros/ag71xx.c           | 2 +-
 drivers/net/ethernet/cortina/gemini.c           | 2 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c      | 2 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c | 2 +-
 drivers/net/ethernet/ti/netcp_core.c            | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 1aaaf8a4e7c5..ada3a9f0c8c8 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1971,7 +1971,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 	err = of_get_ethdev_address(np, ndev);
 	if (err) {
 		netif_err(ag, probe, ndev, "invalid MAC address, using random address\n");
-		eth_random_addr(ndev->dev_addr);
+		eth_hw_addr_random(ndev);
 	}
 
 	err = of_get_phy_mode(np, &ag->phy_if_mode);
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 82d32caf1374..941f175fb911 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2473,7 +2473,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 			port->mac_addr[0], port->mac_addr[1],
 			port->mac_addr[2]);
 		dev_info(dev, "using a random ethernet address\n");
-		eth_random_addr(netdev->dev_addr);
+		eth_hw_addr_random(netdev);
 	}
 	gmac_write_mac_address(netdev);
 
diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 37b605fed32c..c84ef494bd60 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -998,7 +998,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 		hip04_config_port(ndev, SPEED_100, DUPLEX_FULL);
 
 	hip04_config_fifo(priv);
-	eth_random_addr(ndev->dev_addr);
+	eth_hw_addr_random(ndev);
 	hip04_update_mac_address(ndev);
 
 	ret = hip04_alloc_ring(ndev, d);
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 13d8eb43a485..1b2119b1d48a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -224,7 +224,7 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 	rmnet_dev->netdev_ops = &rmnet_vnd_ops;
 	rmnet_dev->mtu = RMNET_DFLT_PACKET_SIZE;
 	rmnet_dev->needed_headroom = RMNET_NEEDED_HEADROOM;
-	eth_random_addr(rmnet_dev->dev_addr);
+	eth_hw_addr_random(rmnet_dev);
 	rmnet_dev->tx_queue_len = RMNET_TX_QUEUE_LEN;
 
 	/* Raw IP mode */
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index b666e1b53c5f..b818e4579f6f 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2030,14 +2030,14 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 		if (is_valid_ether_addr(efuse_mac_addr))
 			eth_hw_addr_set(ndev, efuse_mac_addr);
 		else
-			eth_random_addr(ndev->dev_addr);
+			eth_hw_addr_random(ndev);
 
 		devm_iounmap(dev, efuse);
 		devm_release_mem_region(dev, res.start, size);
 	} else {
 		ret = of_get_ethdev_address(node_interface, ndev);
 		if (ret)
-			eth_random_addr(ndev->dev_addr);
+			eth_hw_addr_random(ndev);
 	}
 
 	ret = of_property_read_string(node_interface, "rx-channel",
-- 
2.31.1

