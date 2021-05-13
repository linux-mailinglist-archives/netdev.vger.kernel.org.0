Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1055537F6F7
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbhEMLox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbhEMLow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:44:52 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B55CC061760;
        Thu, 13 May 2021 04:43:42 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lh9kb-0007HF-Da; Thu, 13 May 2021 14:43:33 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v2 3/5] atl1c: adjust max mtu according to Mikrotik 10/25G NIC ability
Date:   Thu, 13 May 2021 14:43:24 +0300
Message-Id: <20210513114326.699663-4-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513114326.699663-1-gatis@mikrotik.com>
References: <20210513114326.699663-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new Mikrotik 10/25G NIC supports jumbo frames. Jumbo frames are
supported for TSO as well.

This enables the support for mtu up to 9500 bytes.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 08a0f49e03ce..dbafd8118a86 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -478,6 +478,9 @@ static void atl1c_set_rxbufsize(struct atl1c_adapter *adapter,
 static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 	netdev_features_t features)
 {
+	struct atl1c_adapter *adapter = netdev_priv(netdev);
+	struct atl1c_hw *hw = &adapter->hw;
+
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
@@ -487,8 +490,10 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
-	if (netdev->mtu > MAX_TSO_FRAME_SIZE)
-		features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+	if (hw->nic_type != athr_mt) {
+		if (netdev->mtu > MAX_TSO_FRAME_SIZE)
+			features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+	}
 
 	return features;
 }
@@ -515,9 +520,12 @@ static void atl1c_set_max_mtu(struct net_device *netdev)
 	case athr_l1d:
 	case athr_l1d_2:
 		netdev->max_mtu = MAX_JUMBO_FRAME_SIZE -
-				  (ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
+			(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
+		break;
+	case athr_mt:
+		netdev->max_mtu = 9500;
 		break;
-	/* The 10/100 devices don't support jumbo packets, max_mtu 1500 */
+		/* The 10/100 devices don't support jumbo packets, max_mtu 1500 */
 	default:
 		netdev->max_mtu = ETH_DATA_LEN;
 		break;
-- 
2.31.1

