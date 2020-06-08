Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC5E1F255A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731882AbgFHXZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731869AbgFHXZu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:25:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1218F2068D;
        Mon,  8 Jun 2020 23:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658749;
        bh=pYNQcSSA8JE5e7nUhFvhxl8tYDixqAuawiEefCQhtHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrJ7F4FGDmjgA8mL/J0GLgH1UmkOX+EZ5cji858pl+YJhZhbLMUiCo4NK/Q8ehRZg
         qpL0/j9JZbCRTFx7cDhlHYqBNIK0Kn0jonuDtU052/Y7+qwBtfGr3IMHyBMU2FVQM3
         E1PJARUXd8m/MhoDKkWMIGhj+cx3/nprDpk/3upY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 35/72] net: bcmgenet: set Rx mode before starting netif
Date:   Mon,  8 Jun 2020 19:24:23 -0400
Message-Id: <20200608232500.3369581-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 72f96347628e73dbb61b307f18dd19293cc6792a ]

This commit explicitly calls the bcmgenet_set_rx_mode() function when
the network interface is started. This function is normally called by
ndo_set_rx_mode when the flags are changed, but apparently not when
the driver is suspended and resumed.

This change ensures that address filtering or promiscuous mode are
properly restored by the driver after the MAC may have been reset.

Fixes: b6e978e50444 ("net: bcmgenet: add suspend/resume callbacks")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 38391230ca86..7d3cbbd88a00 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -72,6 +72,9 @@
 #define GENET_RDMA_REG_OFF	(priv->hw_params->rdma_offset + \
 				TOTAL_DESC * DMA_DESC_SIZE)
 
+/* Forward declarations */
+static void bcmgenet_set_rx_mode(struct net_device *dev);
+
 static inline void bcmgenet_writel(u32 value, void __iomem *offset)
 {
 	/* MIPS chips strapped for BE will automagically configure the
@@ -2858,6 +2861,7 @@ static void bcmgenet_netif_start(struct net_device *dev)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
 	/* Start the network engine */
+	bcmgenet_set_rx_mode(dev);
 	bcmgenet_enable_rx_napi(priv);
 	bcmgenet_enable_tx_napi(priv);
 
-- 
2.25.1

