Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074483D7741
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbhG0NrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236985AbhG0Nqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6381E61ABB;
        Tue, 27 Jul 2021 13:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393588;
        bh=2JsZiWZJESDfLBgY4ct1aeoV1nqlOgPxfgz9I7TduX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZ8jf5tfE85K8mNNfU2quSTxOujp0k1hxZS4ENX0HvFcYHSuQ5bHHjzgT4CX9tdeH
         C07rX3CQ6DMD+BPYGOHeQmJZFKk/TZ/qhrrlHp475BoLWzXGWoyZ9gDuUnXEzxxc7Y
         ointhfXoW+VvTnUPTcarB7GS99UjjvRHUn7BtSo7ZbpWo0dE35eAccB6Mg0jCrIgI4
         s97vaxy2yA0uICsdQsrd26R61Kyp3zo6qaMm5i+55dSpTpB7xH+QvHGFuAFniK+UFd
         ng2Z/+8YNn3GObUgbI5AhwBsYUig6sm/b/eyNMP1tPO0hoj2SCuYqUbdb7wc0xHsyu
         RyAy4e8mTf/Sg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH net-next v3 17/31] cxgb3: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:45:03 +0200
Message-Id: <20210727134517.1384504-18-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

cxgb3 has a private multiplexor that works correctly in compat
mode, split out the siocdevprivate callback from do_ioctl for
simplification.

Cc: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 57f210c53afc..eae893d7d840 100644
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
@@ -3182,6 +3185,7 @@ static const struct net_device_ops cxgb_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= cxgb_set_rxmode,
 	.ndo_do_ioctl		= cxgb_ioctl,
+	.ndo_siocdevprivate	= cxgb_siocdevprivate,
 	.ndo_change_mtu		= cxgb_change_mtu,
 	.ndo_set_mac_address	= cxgb_set_mac_addr,
 	.ndo_fix_features	= cxgb_fix_features,
-- 
2.29.2

