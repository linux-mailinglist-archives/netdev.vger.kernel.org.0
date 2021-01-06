Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970FF2EC2D0
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbhAFRy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:54:28 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:24846 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbhAFRy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:54:28 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 106HrSU1026716;
        Wed, 6 Jan 2021 09:53:29 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net] net: feature check mandating HW_CSUM is wrong
Date:   Wed,  6 Jan 2021 23:23:27 +0530
Message-Id: <20210106175327.5606-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mandating NETIF_F_HW_CSUM to enable TLS offload feature is wrong.
And it broke tls offload feature for the drivers, which are still
using NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM. We should use
NETIF_F_CSUM_MASK instead.

Fixes: ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a46334906c94..b1f99287f280 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9643,7 +9643,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		}
 	}
 
-	if ((features & NETIF_F_HW_TLS_TX) && !(features & NETIF_F_HW_CSUM)) {
+	if ((features & NETIF_F_HW_TLS_TX) && !(features & NETIF_F_CSUM_MASK)) {
 		netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
 		features &= ~NETIF_F_HW_TLS_TX;
 	}
-- 
2.18.1

