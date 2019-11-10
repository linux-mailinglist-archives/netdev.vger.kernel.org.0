Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C7CF655B
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfKJDGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfKJCpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 082A42085B;
        Sun, 10 Nov 2019 02:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353951;
        bh=kVIWzxKGEP+C3bOY8Q6CeEoA/CoYkqse9JetYoX1jYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBNLboJimbdxeGmRVLdk60OdOWGzySGd+uVUGLQz/0XIwb86cY/15/QR/ssafDwJU
         uRVbK9PqTDXFJ0lv6ZcjN9BWLPrfpbYcKXhgFAyAraUQbDtFGhsQIp1NGGIpp0UwC1
         vHlhTrfEVE3bCQkgHjKKE2QDDy2DVcYkX2I2eKpg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 009/109] net: hns3: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:44:01 -0500
Message-Id: <20191110024541.31567-9-sashal@kernel.org>
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

[ Upstream commit c9c3941186c5637caed131c4f4064411d6882299 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, also the implementation in this
driver has returns 'netdev_tx_t' value, so just change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c    | 3 ++-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 1bfe9544b3c10..57e24f312ca68 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -423,7 +423,8 @@ static void hip04_start_tx_timer(struct hip04_priv *priv)
 			       ns, HRTIMER_MODE_REL);
 }
 
-static int hip04_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t
+hip04_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct hip04_priv *priv = netdev_priv(ndev);
 	struct net_device_stats *stats = &ndev->stats;
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 25a6c8722ecac..aab6fb10af94a 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -736,7 +736,7 @@ static int hix5hd2_fill_sg_desc(struct hix5hd2_priv *priv,
 	return 0;
 }
 
-static int hix5hd2_net_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t hix5hd2_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct hix5hd2_priv *priv = netdev_priv(dev);
 	struct hix5hd2_desc *desc;
-- 
2.20.1

