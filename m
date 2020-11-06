Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316E22A9FE5
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgKFWSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729049AbgKFWSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:46 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84A8320B1F;
        Fri,  6 Nov 2020 22:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701125;
        bh=quYL6FmY9NRqROBT7gD89RdIR4mWBVj5mvB8k4ghwsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVkT2rV+ZZT8ggUQJXoUIn5wGJbOSDXoR0riPdF5VpQNgUs0rm8nAK2xhnjcj2+Jh
         89cGeNC9su/aAcdfEYlzDhyIFeeYoAwgYme3lMgV7MGsw2axEx44564aq2qTQDGbv4
         tM3+v8w0ekwBHLWs19yiX2m9XdxkpWf7ku35ctsQ=
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
Subject: [RFC net-next 18/28] cxgb3: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:33 +0100
Message-Id: <20201106221743.3271965-19-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

cxgb3 has a private multiplexor that works correctly in compat
mode, split out the siocdevprivate callback from do_ioctl for
simplification.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 84ad7261e243..c79a70d370bd 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2135,13 +2135,18 @@ static int in_range(int val, int lo, int hi)
 	return val < 0 || (val <= hi && val >= lo);
 }
 
-static int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)
+static int cxgb_siocdevprivate(struct net_device *dev,
+			       struct ifreq *ifreq,
+			       void __user *useraddr,
+			       int cmd)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
-	u32 cmd;
 	int ret;
 
+	if (cmd != SIOCCHIOCTL)
+		return -EOPNOTSUPP;
+
 	if (copy_from_user(&cmd, useraddr, sizeof(cmd)))
 		return -EFAULT;
 
@@ -2546,8 +2551,6 @@ static int cxgb_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 		fallthrough;
 	case SIOCGMIIPHY:
 		return mdio_mii_ioctl(&pi->phy.mdio, data, cmd);
-	case SIOCCHIOCTL:
-		return cxgb_extension_ioctl(dev, req->ifr_data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3181,6 +3184,7 @@ static const struct net_device_ops cxgb_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= cxgb_set_rxmode,
 	.ndo_do_ioctl		= cxgb_ioctl,
+	.ndo_siocdevprivate	= cxgb_siocdevprivate,
 	.ndo_change_mtu		= cxgb_change_mtu,
 	.ndo_set_mac_address	= cxgb_set_mac_addr,
 	.ndo_fix_features	= cxgb_fix_features,
-- 
2.27.0

