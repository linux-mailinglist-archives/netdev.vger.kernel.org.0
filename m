Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3113D7732
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbhG0Nqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236860AbhG0NqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0576661A8B;
        Tue, 27 Jul 2021 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393578;
        bh=79XTVpCt/ykWdmIsFWtzZbSIe8bov8bIjAYDooG6RHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcT/f4FuRrUC9JeIW/rccwUoBiOG1R8L0yPELnVkGB9wPnVDZE6PSTIHX7wrnGU+1
         dt9KeQa+NtnGJ4PtOHbJ2ioNOclcglbrpSXHHmgxXIgdr43AWU/j5PSRyO2vF/haJL
         0+IlR8Lwg/n5CPGkQx9lpg09XufBivFx64hxkJyCcmsdXetOa/WjQ7y99N5IFK5LvY
         tezmiSokeH+6TSu9xlzfYmNKsMSSEbEIREnx/qUWYvXGKmgj4ziUoFL5Zi6GXDTaN9
         lmvq7/dB+v1vftmT/N3K//dQq8iRS82tBFd7L0uJrDULt91R1u3i8SZMY7J8f7d6/d
         rdaEqJX50CQYw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH net-next v3 11/31] tehuti: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:44:57 +0200
Message-Id: <20210727134517.1384504-12-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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

Cc: Andy Gospodarek <andy@greyhouse.net>
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

