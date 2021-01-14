Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275FE2F6403
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbhANPN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:13:57 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39336 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728304AbhANPN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:13:57 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 14 Jan 2021 17:13:10 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10EFDAFi016220;
        Thu, 14 Jan 2021 17:13:10 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net] net: Allow NETIF_F_HW_TLS_TX if IP_CSUM && IPV6_CSUM
Date:   Thu, 14 Jan 2021 17:12:15 +0200
Message-Id: <20210114151215.7061-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cited patch below blocked the TLS TX device offload unless HW_CSUM
is set. This broke devices that use IP_CSUM && IP6_CSUM.
Here we fix it.

Note that the single HW_TLS_TX feature flag indicates support for
both IPv4/6, hence it should still be disabled in case only one of
(IP_CSUM | IPV6_CSUM) is set.

Fixes: ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reported-by: Rohit Maheshwari <rohitm@chelsio.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 Documentation/networking/tls-offload.rst |  2 +-
 net/core/dev.c                           | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index 0f55c6d540f9..9af3334d9ad0 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -530,7 +530,7 @@ TLS device feature flags only control adding of new TLS connection
 offloads, old connections will remain active after flags are cleared.
 
 TLS encryption cannot be offloaded to devices without checksum calculation
-offload. Hence, TLS TX device feature flag requires NETIF_F_HW_CSUM being set.
+offload. Hence, TLS TX device feature flag requires TX csum offload being set.
 Disabling the latter implies clearing the former. Disabling TX checksum offload
 should not affect old connections, and drivers should make sure checksum
 calculation does not break for them.
diff --git a/net/core/dev.c b/net/core/dev.c
index 0071a11a6dc3..c360bb5367e2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9661,9 +9661,15 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		}
 	}
 
-	if ((features & NETIF_F_HW_TLS_TX) && !(features & NETIF_F_HW_CSUM)) {
-		netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
-		features &= ~NETIF_F_HW_TLS_TX;
+	if (features & NETIF_F_HW_TLS_TX) {
+		bool ip_csum = (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) ==
+			(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
+		bool hw_csum = features & NETIF_F_HW_CSUM;
+
+		if (!ip_csum && !hw_csum) {
+			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
+			features &= ~NETIF_F_HW_TLS_TX;
+		}
 	}
 
 	return features;
-- 
2.21.0

