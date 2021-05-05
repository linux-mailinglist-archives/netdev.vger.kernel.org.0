Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE58B3742A6
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbhEEQre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235971AbhEEQpW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:45:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4D9B61930;
        Wed,  5 May 2021 16:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232567;
        bh=6r56QBO1lUI0eIJMbOcrck/Kl+oNsMP1657xqdG6OBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6UhR/9j1gwQAoeZQcEC2Ux3qkHDlzjcgtIDOyuX5sRyMWIYdGcXk5+PX1B2QBxfp
         pZN+mC+hEKe2nDgjm5pGD5I+WDTo5fDKJlUtZpzHPixve2Kqgrf0i5WR4tGtWqYamJ
         LizQCmo51VO0CpsYod5aZtlPwoTlEQJpyTP+IFC5U9wAOVdYIUVeC1L8rpfaoX+U17
         0T+WHRlcgIyTxrh1AZiwavQQA5rL35AKDprBS3Sp+vyZlRdUbYdGhIUs9OZrqfI6+W
         r245yAoRK2NjIDvUtPJi/auvkP6UYN2v2qdNiuvMgQY82yk3+QV7hZl1pbhIxJSmDL
         DcqOaIc+tPP5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Mosberger-Tang <davidm@egauge.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 078/104] wilc1000: Bring MAC address setting in line with typical Linux behavior
Date:   Wed,  5 May 2021 12:33:47 -0400
Message-Id: <20210505163413.3461611-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Mosberger-Tang <davidm@egauge.net>

[ Upstream commit a381b78a1598dde34a6e40dae2842024308a6ef2 ]

Linux network drivers normally disallow changing the MAC address when
the interface is up.  This driver has been different in that it allows
to change the MAC address *only* when it's up.  This patch brings
wilc1000 behavior more in line with other network drivers.  We could
have replaced wilc_set_mac_addr() with eth_mac_addr() but that would
break existing documentation on how to change the MAC address.
Likewise, return -EADDRNOTAVAIL (not -EINVAL) when the specified MAC
address is invalid or unavailable.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210303194846.1823596-1-davidm@egauge.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/microchip/wilc1000/netdev.c  | 25 ++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 0c188310919e..acf7ed4bfe57 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -575,7 +575,6 @@ static int wilc_mac_open(struct net_device *ndev)
 {
 	struct wilc_vif *vif = netdev_priv(ndev);
 	struct wilc *wl = vif->wilc;
-	unsigned char mac_add[ETH_ALEN] = {0};
 	int ret = 0;
 	struct mgmt_frame_regs mgmt_regs = {};
 
@@ -598,9 +597,12 @@ static int wilc_mac_open(struct net_device *ndev)
 
 	wilc_set_operation_mode(vif, wilc_get_vif_idx(vif), vif->iftype,
 				vif->idx);
-	wilc_get_mac_address(vif, mac_add);
-	netdev_dbg(ndev, "Mac address: %pM\n", mac_add);
-	ether_addr_copy(ndev->dev_addr, mac_add);
+
+	if (is_valid_ether_addr(ndev->dev_addr))
+		wilc_set_mac_address(vif, ndev->dev_addr);
+	else
+		wilc_get_mac_address(vif, ndev->dev_addr);
+	netdev_dbg(ndev, "Mac address: %pM\n", ndev->dev_addr);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		netdev_err(ndev, "Wrong MAC address\n");
@@ -639,7 +641,14 @@ static int wilc_set_mac_addr(struct net_device *dev, void *p)
 	int srcu_idx;
 
 	if (!is_valid_ether_addr(addr->sa_data))
-		return -EINVAL;
+		return -EADDRNOTAVAIL;
+
+	if (!vif->mac_opened) {
+		eth_commit_mac_addr_change(dev, p);
+		return 0;
+	}
+
+	/* Verify MAC Address is not already in use: */
 
 	srcu_idx = srcu_read_lock(&wilc->srcu);
 	list_for_each_entry_rcu(tmp_vif, &wilc->vif_list, list) {
@@ -647,7 +656,7 @@ static int wilc_set_mac_addr(struct net_device *dev, void *p)
 		if (ether_addr_equal(addr->sa_data, mac_addr)) {
 			if (vif != tmp_vif) {
 				srcu_read_unlock(&wilc->srcu, srcu_idx);
-				return -EINVAL;
+				return -EADDRNOTAVAIL;
 			}
 			srcu_read_unlock(&wilc->srcu, srcu_idx);
 			return 0;
@@ -659,9 +668,7 @@ static int wilc_set_mac_addr(struct net_device *dev, void *p)
 	if (result)
 		return result;
 
-	ether_addr_copy(vif->bssid, addr->sa_data);
-	ether_addr_copy(vif->ndev->dev_addr, addr->sa_data);
-
+	eth_commit_mac_addr_change(dev, p);
 	return result;
 }
 
-- 
2.30.2

