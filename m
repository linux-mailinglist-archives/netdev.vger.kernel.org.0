Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB385171691
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgB0MA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:00:28 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36598 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbgB0MA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 07:00:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Yr6im8tIYFui7uR0P+2mjigt0hLtUiNlwOMqs8r8/cQ=; b=Yh95iGE5+RP+xfIsTw/qJBUkNB
        2r4X6plZ0G9Ar3HR9i+2vmK1qryF00pCP9wJL3FYGs8QY5x3sww5WIprCKfQAvs5gKf3GQAJEmo0Z
        7YXPPVtM/NxTk4CcsiV60nGBqTZDAjl2l/9Ha8gtYeBbU5FwkbDmojNzCZcvAqrwS/qt4tIxYa0KF
        NnZxvqvSo1BIP71jy60nYtRAuCNJkBptXkwQdJmknQ7+sejx0IOfeKhTO1WqE7Y6hZT2ZBXMSc+w/
        a7on2/wjpMdw28iGpfMrEGM9+nGZ7uDRjpH7du505b8GhuQqXBiBleJjaykk6yQE+n7V5Y8Ok8sv+
        1CIaJ3mg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:58322 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7Hq2-0005Li-A0; Thu, 27 Feb 2020 12:00:22 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7Hq1-0004Fc-MX; Thu, 27 Feb 2020 12:00:21 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] dpaa2-eth: add support for mii ioctls
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j7Hq1-0004Fc-MX@rmk-PC.armlinux.org.uk>
Date:   Thu, 27 Feb 2020 12:00:21 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 40290fea9e36..f1ab6bb5db5d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1704,10 +1704,15 @@ static int dpaa2_eth_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 static int dpaa2_eth_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+
 	if (cmd == SIOCSHWTSTAMP)
 		return dpaa2_eth_ts_ioctl(dev, rq, cmd);
 
-	return -EINVAL;
+	if (priv->mac)
+		return phylink_mii_ioctl(priv->mac->phylink, rq, cmd);
+
+	return -EOPNOTSUPP;
 }
 
 static bool xdp_mtu_valid(struct dpaa2_eth_priv *priv, int mtu)
-- 
2.20.1

