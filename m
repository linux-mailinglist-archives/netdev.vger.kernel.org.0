Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239A8F62DE
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbfKJCqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729025AbfKJCqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CFEC21D7E;
        Sun, 10 Nov 2019 02:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353979;
        bh=vnr3Sy8Jmq307F6C2GaYr0l6aMOTYS/fpTivtZzlBfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK6Sv1x12IkAyhQfVAcyhAO9ktrvY1UcuRA3gODSVyfz1jkyetLlaq4YXH1PZjvzZ
         tZDm6XAYHxyloD1YASdBtxuQFpadQnf4PKuLkBKpFopyf5nplfVCI1oYL/lBQZ1lz9
         9HzRqJ0Hs5TsXZQ1CxiHqfdEsG5RoDJXIhneQbkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 021/109] net: broadcom: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:44:13 -0500
Message-Id: <20191110024541.31567-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 0c13b8d1aee87c35a2fbc1d85a1f766227cf54b5 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 5 +++--
 drivers/net/ethernet/broadcom/sb1250-mac.c   | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 68470c7c630a8..35eb0119b0151 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -571,12 +571,13 @@ static irqreturn_t bcm_enet_isr_dma(int irq, void *dev_id)
 /*
  * tx request callback
  */
-static int bcm_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t
+bcm_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bcm_enet_priv *priv;
 	struct bcm_enet_desc *desc;
 	u32 len_stat;
-	int ret;
+	netdev_tx_t ret;
 
 	priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ethernet/broadcom/sb1250-mac.c
index ecdef42f0ae63..00230fe097d94 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -299,7 +299,7 @@ static enum sbmac_state sbmac_set_channel_state(struct sbmac_softc *,
 static void sbmac_promiscuous_mode(struct sbmac_softc *sc, int onoff);
 static uint64_t sbmac_addr2reg(unsigned char *ptr);
 static irqreturn_t sbmac_intr(int irq, void *dev_instance);
-static int sbmac_start_tx(struct sk_buff *skb, struct net_device *dev);
+static netdev_tx_t sbmac_start_tx(struct sk_buff *skb, struct net_device *dev);
 static void sbmac_setmulti(struct sbmac_softc *sc);
 static int sbmac_init(struct platform_device *pldev, long long base);
 static int sbmac_set_speed(struct sbmac_softc *s, enum sbmac_speed speed);
@@ -2028,7 +2028,7 @@ static irqreturn_t sbmac_intr(int irq,void *dev_instance)
  *  Return value:
  *  	   nothing
  ********************************************************************* */
-static int sbmac_start_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t sbmac_start_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct sbmac_softc *sc = netdev_priv(dev);
 	unsigned long flags;
-- 
2.20.1

