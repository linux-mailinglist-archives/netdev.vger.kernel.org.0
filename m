Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B202F0693
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 12:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbhAJLO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 06:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbhAJLO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 06:14:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F86C06179F
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 03:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=i5OnjgxT3w7MYNDEieE0sbIxAroRQu9a+X2fCSx0cOw=; b=MCTZDvtUn0BvsS8heU8y5N+Ajs
        F8Wv+MHo1BONT7glWHZHIpf0yKuu1XDIuCUUPA3dke81FbdY3ybAQd6EHIWSyAmmo9MqTR2Qoex2a
        3vDlf3ZtYVyI9TZd5W+GB5vjfS8Br8LBOcVJs4VIQ2Z09tOgtFByQbTsbae1V4RZmGcu+fUs00Tym
        HRaCuNC0qFOorXFlpF/9eLjiHmsapPOj6bBw/He/Lbm3/Ajm3Ufwm+i3OspADZcSUhJN1y+tzHea5
        dPLrSqmeVO6foVVblN9fmpAsDicXxUigTSIPzAaZslUbfJJADt8WttdGkc/39bojnSYbWq3IVeZ3L
        HzMtL/Eg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52524 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kyYfJ-0005n2-44; Sun, 10 Jan 2021 11:13:45 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kyYfI-0004wl-Tf; Sun, 10 Jan 2021 11:13:44 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: ethtool: allow MAC drivers to override ethtool
 get_ts_info
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sun, 10 Jan 2021 11:13:44 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check whether the MAC driver has implemented the get_ts_info()
method first, and call it if present.  If this method returns
-EOPNOTSUPP, defer to the phylib or default implementation.

This allows network drivers such as mvpp2 to use their more accurate
timestamping implementation than using a less accurate implementation
in the PHY. Network drivers can opt to defer to phylib by returning
-EOPNOTSUPP.

This change will be needed if the Marvell PHY drivers add support for
PTP.

Note: this may cause a change for any drivers that use phylib and
provide get_ts_info(). It is not obvious if any such cases exist.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 net/ethtool/common.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..9ec93e24f239 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -385,14 +385,18 @@ int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 {
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	struct phy_device *phydev = dev->phydev;
+	int ret;
 
 	memset(info, 0, sizeof(*info));
 	info->cmd = ETHTOOL_GET_TS_INFO;
 
+	if (ops->get_ts_info) {
+		ret = ops->get_ts_info(dev, info);
+		if (ret != -EOPNOTSUPP)
+			return ret;
+	}
 	if (phy_has_tsinfo(phydev))
 		return phy_ts_info(phydev, info);
-	if (ops->get_ts_info)
-		return ops->get_ts_info(dev, info);
 
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE;
-- 
2.20.1

