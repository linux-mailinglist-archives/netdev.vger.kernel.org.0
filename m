Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC2C2F9375
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 16:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbhAQPS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 10:18:57 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46871 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729289AbhAQPQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 10:16:40 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 17 Jan 2021 17:15:52 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10HFFpDt002041;
        Sun, 17 Jan 2021 17:15:51 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net: Disable NETIF_F_HW_TLS_RX when RXCSUM is disabled
Date:   Sun, 17 Jan 2021 17:15:38 +0200
Message-Id: <20210117151538.9411-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With NETIF_F_HW_TLS_RX packets are decrypted in HW. This cannot be
logically done when RXCSUM offload is off.

Fixes: 14136564c8ee ("net: Add TLS RX offload feature")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 Documentation/networking/tls-offload.rst | 3 +++
 net/core/dev.c                           | 5 +++++
 2 files changed, 8 insertions(+)

Hi,

Please queue to -stable >= v4.19.

Thanks,
Tariq

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index 9af3334d9ad0..5f0dea3d571e 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -534,3 +534,6 @@ offload. Hence, TLS TX device feature flag requires TX csum offload being set.
 Disabling the latter implies clearing the former. Disabling TX checksum offload
 should not affect old connections, and drivers should make sure checksum
 calculation does not break for them.
+Similarly, device-offloaded TLS decryption implies doing RXCSUM. If the user
+does not want to enable RX csum offload, TLS RX device feature is disabled
+as well.
diff --git a/net/core/dev.c b/net/core/dev.c
index c360bb5367e2..a979b86dbacd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9672,6 +9672,11 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		}
 	}
 
+	if ((features & NETIF_F_HW_TLS_RX) && !(features & NETIF_F_RXCSUM)) {
+		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
+		features &= ~NETIF_F_HW_TLS_RX;
+	}
+
 	return features;
 }
 
-- 
2.21.0

