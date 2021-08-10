Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132EB3E5D51
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243261AbhHJOSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242772AbhHJOQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 127B661073;
        Tue, 10 Aug 2021 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604981;
        bh=yPkuca/mvbHkZv4BfPorv3z/PyxKy5kugxNdJIkTiOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyRpFWBlUvyWE0/VoyUgH5Aqhf6CJ+aKG304t1rp7GSKCuEzHAk6hV1OKPCbsaOYU
         oW6Bgq3lRAFtqtomEqi6kyK/4KSIXZfEQlpyvfNluE8GQXquDu7UZ2r6kbiE8gsGFz
         0NW9ZIBjYoRUCLORtE2PQs2BdQdKtPCEUaFnNulNDCt4SVFPpYCz2zIvNm68tRRigF
         4Q2xmpdQXBdcKWR7fg8+MIHQnVJUNxaOIfBDFjwfema1EM8zfiajBDbiUwu9b26YY1
         Id3fhOaVlIWiOcpmB4Tc8MOI88/HgVSuwIv3KHGFzOFvNIZYls+fmxCh0PBf4Ne7qx
         C/nP59s47Qiig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ivan T. Ivanov" <iivanov@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/13] net: usb: lan78xx: don't modify phy_device state concurrently
Date:   Tue, 10 Aug 2021 10:16:04 -0400
Message-Id: <20210810141606.3117932-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141606.3117932-1-sashal@kernel.org>
References: <20210810141606.3117932-1-sashal@kernel.org>
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
index 71cc5b63d8ce..92d9d3407b79 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1159,7 +1159,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 {
 	struct phy_device *phydev = dev->net->phydev;
 	struct ethtool_link_ksettings ecmd;
-	int ladv, radv, ret;
+	int ladv, radv, ret, link;
 	u32 buf;
 
 	/* clear LAN78xx interrupt status */
@@ -1167,9 +1167,12 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
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
@@ -1182,7 +1185,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 			return -EIO;
 
 		del_timer(&dev->stat_monitor);
-	} else if (phydev->link && !dev->link_on) {
+	} else if (link && !dev->link_on) {
 		dev->link_on = true;
 
 		phy_ethtool_ksettings_get(phydev, &ecmd);
@@ -1471,9 +1474,14 @@ static int lan78xx_set_eee(struct net_device *net, struct ethtool_eee *edata)
 
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

