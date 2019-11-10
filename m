Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E661FF636A
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfKJCwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:52:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730024AbfKJCvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:51:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C78122581;
        Sun, 10 Nov 2019 02:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354300;
        bh=i1i7cHnRw8mqsnFpsZPU0xEVm/PGqfyMQsM3ZrClmjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLoAzClW2BmjRUsIaE1ZjHmkdkz3qS9V+SK+2G0qbQhKGsimEFTf+u8xK9azH9evI
         /QjbmuQoy0nKavLN/jCQ8SPwdH7SPP6/g43aSiiaDNU7gYndeN3EtSsuraNI5EhSmr
         3u854rU108UQWy3vxJOMS1P9FndLqhZ91kY4sCdg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 36/40] net: smsc: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:50:28 -0500
Message-Id: <20191110025032.827-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 6323d57f335ce1490d025cacc83fc10b07792130 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/smsc/smc911x.c  | 3 ++-
 drivers/net/ethernet/smsc/smc91x.c   | 3 ++-
 drivers/net/ethernet/smsc/smsc911x.c | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index bd64eb982e527..37fb6dfc10875 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -511,7 +511,8 @@ static void smc911x_hardware_send_pkt(struct net_device *dev)
  * now, or set the card to generates an interrupt when ready
  * for the packet.
  */
-static int smc911x_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t
+smc911x_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct smc911x_local *lp = netdev_priv(dev);
 	unsigned int free;
diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 23a0388100834..7405f537beca7 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -637,7 +637,8 @@ done:	if (!THROTTLE_TX_PKTS)
  * now, or set the card to generates an interrupt when ready
  * for the packet.
  */
-static int smc_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t
+smc_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct smc_local *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 219a99b7a631d..b62bf77a64f43 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1677,7 +1677,8 @@ static int smsc911x_stop(struct net_device *dev)
 }
 
 /* Entry point for transmitting a packet */
-static int smsc911x_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t
+smsc911x_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
 	unsigned int freespace;
-- 
2.20.1

