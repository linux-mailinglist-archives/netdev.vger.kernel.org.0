Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258CC2C0D02
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388544AbgKWONd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:13:33 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42982 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731325AbgKWONd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:13:33 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 23 Nov 2020 16:13:27 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0ANEDRjA032315;
        Mon, 23 Nov 2020 16:13:27 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] netdevice.h: Fix unintentional disable of ALL_FOR_ALL features on upper device
Date:   Mon, 23 Nov 2020 16:12:56 +0200
Message-Id: <20201123141256.14208-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling netdev_increment_features() on upper/master device from
netdev_add_tso_features() implies unintentional clearance of ALL_FOR_ALL
features supported by all slaves.  Fix it by passing ALL_FOR_ALL in
addition to ALL_TSO.

Fixes: b0ce3508b25e ("bonding: allow TSO being set on bonding master")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Hi,

I know that netdev_increment_features() does not set any feature that's
unmasked in the mask argument.
I wonder why it can clear them though, was it meant to be like this?
If not, then the proper fix should be in netdev_increment_features(), not
in netdev_add_tso_features().


diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 18dec08439f9..a9d5e4bb829b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4748,7 +4748,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 static inline netdev_features_t netdev_add_tso_features(netdev_features_t features,
 							netdev_features_t mask)
 {
-	return netdev_increment_features(features, NETIF_F_ALL_TSO, mask);
+	return netdev_increment_features(features, NETIF_F_ALL_TSO | NETIF_F_ALL_FOR_ALL, mask);
 }
 
 int __netdev_update_features(struct net_device *dev);
-- 
2.21.0

