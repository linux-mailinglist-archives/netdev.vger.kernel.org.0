Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD5B6309E1
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbiKSCUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbiKSCTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:19:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B13CC287C;
        Fri, 18 Nov 2022 18:14:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13CE3B82678;
        Sat, 19 Nov 2022 02:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9D9C43147;
        Sat, 19 Nov 2022 02:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824059;
        bh=KL84In0degbvFKcazDHO6LiPWMuucBN9sek+Ljtq1vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=js3pnzprIsMW3Txkr6q+fHUO0p30mIa+8gWhKn5JeGWSro86WJIiGf5tmIOgeCszQ
         7uGp59XHBX8X0gxB6k+LHjl0Z/P+eVl9X8HqJy/xnnIV+UU2uTObk5eTaNBSC5GZMg
         R3xjq/wEiw0xygJf/PK60uYYWEC8NwKLmYSHFSONcdQN+VPWLocGekAWvy5mQ4j7RU
         JPGt7FkgrgfF+mwG8gt9YUXPffJ/c8Wj3C2smdPLxPVzKsP2GQpVy8Jlf8peOp5YmL
         jsMT1JRVVtw4lvFzKeGzMmTK/m+n7d3RF3sP0CB9qaIY0fIS3unIcYlfTvauteQ1Gp
         zdrmFr7u3TojQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <atenart@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/27] Revert "net: macsec: report real_dev features when HW offloading is enabled"
Date:   Fri, 18 Nov 2022 21:13:37 -0500
Message-Id: <20221119021352.1774592-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021352.1774592-1-sashal@kernel.org>
References: <20221119021352.1774592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 8bcd560ae8784da57c610d857118c5d6576b1a8f ]

This reverts commit c850240b6c4132574a00f2da439277ab94265b66.

That commit tried to improve the performance of macsec offload by
taking advantage of some of the NIC's features, but in doing so, broke
macsec offload when the lower device supports both macsec and ipsec
offload, as the ipsec offload feature flags (mainly NETIF_F_HW_ESP)
were copied from the real device. Since the macsec device doesn't
provide xdo_* ops, the XFRM core rejects the registration of the new
macsec device in xfrm_api_check.

Example perf trace when running
  ip link add link eni1np1 type macsec port 4 offload mac

    ip   737 [003]   795.477676: probe:xfrm_dev_event__REGISTER      name="macsec0" features=0x1c000080014869
              xfrm_dev_event+0x3a
              notifier_call_chain+0x47
              register_netdevice+0x846
              macsec_newlink+0x25a

    ip   737 [003]   795.477687:   probe:xfrm_dev_event__return      ret=0x8002 (NOTIFY_BAD)
             notifier_call_chain+0x47
             register_netdevice+0x846
             macsec_newlink+0x25a

dev->features includes NETIF_F_HW_ESP (0x04000000000000), so
xfrm_api_check returns NOTIFY_BAD because we don't have
dev->xfrmdev_ops on the macsec device.

We could probably propagate GSO and a few other features from the
lower device, similar to macvlan. This will be done in a future patch.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 4811bd1f3d74..f1961d7f9db2 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2644,11 +2644,6 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	if (ret)
 		goto rollback;
 
-	/* Force features update, since they are different for SW MACSec and
-	 * HW offloading cases.
-	 */
-	netdev_update_features(dev);
-
 	rtnl_unlock();
 	return 0;
 
@@ -3416,16 +3411,9 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-#define SW_MACSEC_FEATURES \
+#define MACSEC_FEATURES \
 	(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST)
 
-/* If h/w offloading is enabled, use real device features save for
- *   VLAN_FEATURES - they require additional ops
- *   HW_MACSEC - no reason to report it
- */
-#define REAL_DEV_FEATURES(dev) \
-	((dev)->features & ~(NETIF_F_VLAN_FEATURES | NETIF_F_HW_MACSEC))
-
 static int macsec_dev_init(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
@@ -3442,12 +3430,8 @@ static int macsec_dev_init(struct net_device *dev)
 		return err;
 	}
 
-	if (macsec_is_offloaded(macsec)) {
-		dev->features = REAL_DEV_FEATURES(real_dev);
-	} else {
-		dev->features = real_dev->features & SW_MACSEC_FEATURES;
-		dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
-	}
+	dev->features = real_dev->features & MACSEC_FEATURES;
+	dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
 
 	dev->needed_headroom = real_dev->needed_headroom +
 			       MACSEC_NEEDED_HEADROOM;
@@ -3476,10 +3460,7 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 
-	if (macsec_is_offloaded(macsec))
-		return REAL_DEV_FEATURES(real_dev);
-
-	features &= (real_dev->features & SW_MACSEC_FEATURES) |
+	features &= (real_dev->features & MACSEC_FEATURES) |
 		    NETIF_F_GSO_SOFTWARE | NETIF_F_SOFT_FEATURES;
 	features |= NETIF_F_LLTX;
 
-- 
2.35.1

