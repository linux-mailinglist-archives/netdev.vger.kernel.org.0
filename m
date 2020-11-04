Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDFC2A616A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgKDKV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:21:58 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49165 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727389AbgKDKV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 05:21:58 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 4 Nov 2020 12:21:52 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0A4ALqjd014320;
        Wed, 4 Nov 2020 12:21:52 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: [PATCH net] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled
Date:   Wed,  4 Nov 2020 12:21:41 +0200
Message-Id: <20201104102141.3489-1-tariqt@nvidia.com>
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
 net/core/dev.c | 5 +++++
 1 file changed, 5 insertions(+)

Hi,

Please queue to -stable >= v4.18.
Thanks.

diff --git a/net/core/dev.c b/net/core/dev.c
index 82dc6b48e45f..5f72ea17d3f7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9588,6 +9588,11 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
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

