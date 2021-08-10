Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856063E5CE5
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242511AbhHJOQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242389AbhHJOPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 10:15:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FDC961019;
        Tue, 10 Aug 2021 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604931;
        bh=JaQQDWTDJD/juKy/Yq5YS5zSjfP6vGiSD6Awz3BvaR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMtDA/LdPdxJecikyIqDvtfrL4CmI7T5Kh6wy2vXLGOGGiKZaQpA89t/k01chhCou
         16gOMlGedivlfHcZ+4k1e0SLYyWD6cHtPomK9dtF65mf/TIwMOR+uhJkuxIqyfpNxg
         /0E2gg8pwVSTMHrEft2E8xznltAia1aAOtlESetZmKXCcAIyIyOKRuC0bu4kJ8czn+
         Mj1zSxBJ63hCTgz/eK+OzZdyqZlNRaOd+N1NMI+YYe25FP/wSXdf8dfJ0VLqB16lbG
         KHU5xyp9UK8r4Lpw9/VCbkEiM0MOIynIsYMACtb3S2vrA9yHWwFiIh5IrjMCdifY3W
         l+ON29erTmEhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ivan T. Ivanov" <iivanov@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 19/24] net: usb: lan78xx: don't modify phy_device state concurrently
Date:   Tue, 10 Aug 2021 10:15:00 -0400
Message-Id: <20210810141505.3117318-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141505.3117318-1-sashal@kernel.org>
References: <20210810141505.3117318-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@suse.de>

[ Upstream commit 6b67d4d63edece1033972214704c04f36c5be89a ]

Currently phy_device state could be left in inconsistent state shown
by following alert message[1]. This is because phy_read_status could
be called concurrently from lan78xx_delayedwork, phy_state_machine and
__ethtool_get_link. Fix this by making sure that phy_device state is
updated atomically.

[1] lan78xx 1-1.1.1:1.0 eth0: No phy led trigger registered for speed(-1)

Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 02bce40a67e5..c46a66ea32eb 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1154,7 +1154,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 {
 	struct phy_device *phydev = dev->net->phydev;
 	struct ethtool_link_ksettings ecmd;
-	int ladv, radv, ret;
+	int ladv, radv, ret, link;
 	u32 buf;
 
 	/* clear LAN78xx interrupt status */
@@ -1162,9 +1162,12 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 	if (unlikely(ret < 0))
 		return -EIO;
 
+	mutex_lock(&phydev->lock);
 	phy_read_status(phydev);
+	link = phydev->link;
+	mutex_unlock(&phydev->lock);
 
-	if (!phydev->link && dev->link_on) {
+	if (!link && dev->link_on) {
 		dev->link_on = false;
 
 		/* reset MAC */
@@ -1177,7 +1180,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 			return -EIO;
 
 		del_timer(&dev->stat_monitor);
-	} else if (phydev->link && !dev->link_on) {
+	} else if (link && !dev->link_on) {
 		dev->link_on = true;
 
 		phy_ethtool_ksettings_get(phydev, &ecmd);
@@ -1466,9 +1469,14 @@ static int lan78xx_set_eee(struct net_device *net, struct ethtool_eee *edata)
 
 static u32 lan78xx_get_link(struct net_device *net)
 {
+	u32 link;
+
+	mutex_lock(&net->phydev->lock);
 	phy_read_status(net->phydev);
+	link = net->phydev->link;
+	mutex_unlock(&net->phydev->lock);
 
-	return net->phydev->link;
+	return link;
 }
 
 static void lan78xx_get_drvinfo(struct net_device *net,
-- 
2.30.2

