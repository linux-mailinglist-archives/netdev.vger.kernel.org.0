Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43840171698
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgB0MB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:01:59 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36622 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbgB0MB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 07:01:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LCh0wlcg+vToGkH55TLwcae2tCPuR7/LJRtNl22L71s=; b=KpXInSqL0YWEi1YqvGtmqxUIgC
        M/+NZLfFrnsBBt9S/aMIeuHX8DoqZXCzdn/iThKRuah1aQjOLDCU1I3QoP+b3kZX0OkrQRu8RX1Ic
        eetL0aWamuhN/TWA/dOxsKsNLlVc4z6XXQX9UkAnlm3Tco6WyQb6xh5KIro+waDu6sJZqcPeOn29h
        d5S8l+Xx/HZ5aG3t74XBoLqBGlKUUwLlbKZMA7YHkHwPovS1KrnzjtRSQ9RSkI/J+1cD8/zvAW3BM
        lsIuKAotaGwasGHExLX69dyuGbAD9UVovy3hDA8xNcWJjgObqWWfred4CPEZqniEcW+14w6TdWaiB
        FDVeC7xw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45864 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7HrX-0005MO-Af; Thu, 27 Feb 2020 12:01:55 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7HrW-0004HW-Pz; Thu, 27 Feb 2020 12:01:54 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] dpaa2-eth: add support for nway reset
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j7HrW-0004HW-Pz@rmk-PC.armlinux.org.uk>
Date:   Thu, 27 Feb 2020 12:01:54 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ethtool -r so that PHY negotiation can be restarted.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 96676abcebd5..94347c695233 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -79,6 +79,16 @@ static void dpaa2_eth_get_drvinfo(struct net_device *net_dev,
 		sizeof(drvinfo->bus_info));
 }
 
+static int dpaa2_eth_nway_reset(struct net_device *net_dev)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+
+	if (priv->mac)
+		return phylink_ethtool_nway_reset(priv->mac->phylink);
+
+	return -EOPNOTSUPP;
+}
+
 static int
 dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
 			     struct ethtool_link_ksettings *link_settings)
@@ -761,6 +771,7 @@ static int dpaa2_eth_get_ts_info(struct net_device *dev,
 
 const struct ethtool_ops dpaa2_ethtool_ops = {
 	.get_drvinfo = dpaa2_eth_get_drvinfo,
+	.nway_reset = dpaa2_eth_nway_reset,
 	.get_link = ethtool_op_get_link,
 	.get_link_ksettings = dpaa2_eth_get_link_ksettings,
 	.set_link_ksettings = dpaa2_eth_set_link_ksettings,
-- 
2.20.1

