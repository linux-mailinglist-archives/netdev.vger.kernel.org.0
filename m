Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0232AABA6
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 15:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgKHOne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 09:43:34 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58348 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727570AbgKHOne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 09:43:34 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 8 Nov 2020 16:43:29 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0A8EhTpk029393;
        Sun, 8 Nov 2020 16:43:29 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: [PATCH net V2] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled
Date:   Sun,  8 Nov 2020 16:43:09 +0200
Message-Id: <20201108144309.31699-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With NETIF_F_HW_TLS_TX packets are encrypted in HW. This cannot be
logically done when HW_CSUM offload is off.

Fixes: 2342a8512a1e ("net: Add TLS TX offload features")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 Documentation/networking/tls-offload.rst | 4 ++++
 net/core/dev.c                           | 5 +++++
 2 files changed, 9 insertions(+)

Hi,

Please queue to -stable >= v4.18.
Thanks.

v2:
- Documented the change in tls-offload.rst.

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index 37773da2bee5..f315feae3a65 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -528,3 +528,7 @@ Drivers should ignore the changes to TLS the device feature flags.
 These flags will be acted upon accordingly by the core ``ktls`` code.
 TLS device feature flags only control adding of new TLS connection
 offloads, old connections will remain active after flags are cleared.
+
+The TLS encryption cannot be offloaded to device if checksum calculation
+is not, hence the TLS TX device feature flag is cleared when HW_CSUM is
+disabled.
diff --git a/net/core/dev.c b/net/core/dev.c
index 9499a414d67e..26c9b059cade 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9584,6 +9584,11 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		}
 	}
 
+	if ((features & NETIF_F_HW_TLS_TX) && !(features & NETIF_F_HW_CSUM)) {
+		netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
+		features &= ~NETIF_F_HW_TLS_TX;
+	}
+
 	return features;
 }
 
-- 
2.21.0

