Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216053CFDAE
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241813AbhGTOyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240449AbhGTOaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:30:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 958EB61246;
        Tue, 20 Jul 2021 14:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792425;
        bh=sDCMtMP7Pgt+PxycUvIgb3ElpWRaEe2P7FlQyXYUjpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bn8h9GWf28Bv8rXYbWyKXBWBlUS4/sQjINhGrMiNhUGo6KMx2aZudqvXiGFb/DJCv
         S4m5gEyssanvyRRBQ2PPe8J4ACeNNsoeZ5M5iiKAu6tG+Tofd0eS61M6e/5yy8jw4p
         OafJQdDC+jGBS8isxHgRKD33KZzVMpEadfyJ5ekmstlqOOGbPp019TQt9rBOgAZAzI
         rpdqo/wxY6TmQzyXyGMkZqymJwY6kKiJMoIN6xhHI6Y7StS96mNP+LwxyyPJIakrcL
         13ITvh75CSx1P/HYzzIq6MMIZCQiBOIw8q13lFECZFTHKlMz/j5nSy2VcuPfvLkX/n
         sSZopXdbSktNQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 11/31] tehuti: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:18 +0200
Message-Id: <20210720144638.2859828-12-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Tehuti only implements private ioctl commands, and implements
them by overriding the ifreq layout, which is broken in
compat mode.

Move it to the ndo_siocdevprivate callback in order to fix this.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/tehuti/tehuti.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index d054c6e83b1c..8f6abaec41d1 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -637,7 +637,8 @@ static int bdx_range_check(struct bdx_priv *priv, u32 offset)
 		-EINVAL : 0;
 }
 
-static int bdx_ioctl_priv(struct net_device *ndev, struct ifreq *ifr, int cmd)
+static int bdx_siocdevprivate(struct net_device *ndev, struct ifreq *ifr,
+			      void __user *udata, int cmd)
 {
 	struct bdx_priv *priv = netdev_priv(ndev);
 	u32 data[3];
@@ -647,7 +648,7 @@ static int bdx_ioctl_priv(struct net_device *ndev, struct ifreq *ifr, int cmd)
 
 	DBG("jiffies=%ld cmd=%d\n", jiffies, cmd);
 	if (cmd != SIOCDEVPRIVATE) {
-		error = copy_from_user(data, ifr->ifr_data, sizeof(data));
+		error = copy_from_user(data, udata, sizeof(data));
 		if (error) {
 			pr_err("can't copy from user\n");
 			RET(-EFAULT);
@@ -669,7 +670,7 @@ static int bdx_ioctl_priv(struct net_device *ndev, struct ifreq *ifr, int cmd)
 		data[2] = READ_REG(priv, data[1]);
 		DBG("read_reg(0x%x)=0x%x (dec %d)\n", data[1], data[2],
 		    data[2]);
-		error = copy_to_user(ifr->ifr_data, data, sizeof(data));
+		error = copy_to_user(udata, data, sizeof(data));
 		if (error)
 			RET(-EFAULT);
 		break;
@@ -688,15 +689,6 @@ static int bdx_ioctl_priv(struct net_device *ndev, struct ifreq *ifr, int cmd)
 	return 0;
 }
 
-static int bdx_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
-{
-	ENTER;
-	if (cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15))
-		RET(bdx_ioctl_priv(ndev, ifr, cmd));
-	else
-		RET(-EOPNOTSUPP);
-}
-
 /**
  * __bdx_vlan_rx_vid - private helper for adding/killing VLAN vid
  * @ndev: network device
@@ -1860,7 +1852,7 @@ static const struct net_device_ops bdx_netdev_ops = {
 	.ndo_stop		= bdx_close,
 	.ndo_start_xmit		= bdx_tx_transmit,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= bdx_ioctl,
+	.ndo_siocdevprivate	= bdx_siocdevprivate,
 	.ndo_set_rx_mode	= bdx_setmulti,
 	.ndo_change_mtu		= bdx_change_mtu,
 	.ndo_set_mac_address	= bdx_set_mac,
-- 
2.29.2

