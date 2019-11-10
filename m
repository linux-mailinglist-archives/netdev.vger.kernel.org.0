Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14BFF638C
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfKJCvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbfKJCvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:51:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DEE122583;
        Sun, 10 Nov 2019 02:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354276;
        bh=UTXw+8OAS8XcJ+yXQiEfH5etCMRkA8k0yFtoVe6scbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+M37v0nndiOa3bTZNqULTyyhu9Ynpb7oIqd404iyE8nZT6Cq//88CVEd4Z2m/wjd
         WEYv6dyDzLW9EV+dC99h1nYlwocY6ljf0H9WZHmOuaDeaLj4fBJm0cGllJEL+gjGXw
         sj7nXZ+R7kkqvRFq96T4MwBUVliUdt4ds6hTqrLs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 21/40] net: micrel: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:50:13 -0500
Message-Id: <20191110025032.827-21-sashal@kernel.org>
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

[ Upstream commit 2b49117a5abee8478b0470cba46ac74f93b4a479 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8695net.c  | 2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8695net.c b/drivers/net/ethernet/micrel/ks8695net.c
index a8522d8af95d3..2126286b72e9b 100644
--- a/drivers/net/ethernet/micrel/ks8695net.c
+++ b/drivers/net/ethernet/micrel/ks8695net.c
@@ -1156,7 +1156,7 @@ ks8695_timeout(struct net_device *ndev)
  *	sk_buff and adds it to the TX ring. It then kicks the TX DMA
  *	engine to ensure transmission begins.
  */
-static int
+static netdev_tx_t
 ks8695_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct ks8695_priv *ksp = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index 2fc5cd56c0a84..8dc1f0277117d 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -1020,9 +1020,9 @@ static void ks_write_qmu(struct ks_net *ks, u8 *pdata, u16 len)
  * spin_lock_irqsave is required because tx and rx should be mutual exclusive.
  * So while tx is in-progress, prevent IRQ interrupt from happenning.
  */
-static int ks_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t ks_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
-	int retv = NETDEV_TX_OK;
+	netdev_tx_t retv = NETDEV_TX_OK;
 	struct ks_net *ks = netdev_priv(netdev);
 
 	disable_irq(netdev->irq);
-- 
2.20.1

