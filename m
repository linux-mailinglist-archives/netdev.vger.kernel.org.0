Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FDE2A9FDF
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgKFWSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:18:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729003AbgKFWS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:29 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9637021707;
        Fri,  6 Nov 2020 22:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701109;
        bh=PWlbZt8wWlmn+LUnXGXuQMunnnfW/Ks/7SA6eyhM52Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMzwQM4OVxtFFKwcgJNzxD9lIMwZ8Ldhj6OoNVtOTOlOh07hOQA+sAtQsWuuZsZMl
         Wm3NC7wnZyJ4/XOyMbyFrK5kwowihD1Dxi7Y2+QvxXFEfzDs/z2M9LCIo5TP+B0Y1v
         B/nHoqZZhKRPrZkbQ0sSnUs1ZV1HjFJLUxZOnGDQ=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 12/28] tehuti: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:27 +0100
Message-Id: <20201106221743.3271965-13-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
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
index b8f4f419173f..e25524081a30 100644
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
2.27.0

