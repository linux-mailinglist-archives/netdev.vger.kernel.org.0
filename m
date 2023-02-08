Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B52668E666
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjBHDD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjBHDDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:03:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07BA3D085
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 19:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01715CE1F1D
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D43DC4339C;
        Wed,  8 Feb 2023 03:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675825394;
        bh=5sjB7nFpdcjnZLhgN4XJ+gentFQYYTq6i0zJw5e8FXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lu/9hyaaiCaL/x37Hs9w+n0IADBi4mRZudvKJta1Tt7rhVGFfJP3endBN07cfueBh
         G2czfUvpHWc0yf0EvwX90opEmlFUvp+vO3qrAS12p9d9eobJ6TLoCIcnMZJjtnLiK3
         nCaqsmQMSOV22TtoG4xvWROk4hs0W38jJ8jh4wlvaUjNlCz29xT2miIegho8d4nWRS
         MsrY/3lljN5DOwq+yAfDSOvTpbH85WB8oCglizS5G0q1V6fMtZP0r17+Ai45fN7AMp
         ghtmrue4KGY2+6ScEpTT5pXipcV1/VIUQoor6WCxZmcOxARKaB+6BG9exwMEsZoi3x
         ctI5gXFLcSM6g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net 05/10] net/mlx5e: IPoIB, Show unknown speed instead of error
Date:   Tue,  7 Feb 2023 19:02:57 -0800
Message-Id: <20230208030302.95378-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208030302.95378-1-saeed@kernel.org>
References: <20230208030302.95378-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

ethtool is returning an error for unknown speeds for the IPoIB interface:

$ ethtool ib0
netlink error: failed to retrieve link settings
netlink error: Invalid argument
netlink error: failed to retrieve link settings
netlink error: Invalid argument
Settings for ib0:
Link detected: no

After this change, ethtool will return success and show "unknown speed":

$ ethtool ib0
Settings for ib0:
Supported ports: [  ]
Supported link modes:   Not reported
Supported pause frame use: No
Supports auto-negotiation: No
Supported FEC modes: Not reported
Advertised link modes:  Not reported
Advertised pause frame use: No
Advertised auto-negotiation: No
Advertised FEC modes: Not reported
Speed: Unknown!
Duplex: Full
Auto-negotiation: off
Port: Other
PHYAD: 0
Transceiver: internal
Link detected: no

Fixes: eb234ee9d541 ("net/mlx5e: IPoIB, Add support for get_link_ksettings in ethtool")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index eff92dc0927c..e09518f887a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -189,16 +189,16 @@ static inline int mlx5_ptys_rate_enum_to_int(enum mlx5_ptys_rate rate)
 	}
 }
 
-static int mlx5i_get_speed_settings(u16 ib_link_width_oper, u16 ib_proto_oper)
+static u32 mlx5i_get_speed_settings(u16 ib_link_width_oper, u16 ib_proto_oper)
 {
 	int rate, width;
 
 	rate = mlx5_ptys_rate_enum_to_int(ib_proto_oper);
 	if (rate < 0)
-		return -EINVAL;
+		return SPEED_UNKNOWN;
 	width = mlx5_ptys_width_enum_to_int(ib_link_width_oper);
 	if (width < 0)
-		return -EINVAL;
+		return SPEED_UNKNOWN;
 
 	return rate * width;
 }
@@ -221,16 +221,13 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
 	ethtool_link_ksettings_zero_link_mode(link_ksettings, advertising);
 
 	speed = mlx5i_get_speed_settings(ib_link_width_oper, ib_proto_oper);
-	if (speed < 0)
-		return -EINVAL;
+	link_ksettings->base.speed = speed;
+	link_ksettings->base.duplex = speed == SPEED_UNKNOWN ? DUPLEX_UNKNOWN : DUPLEX_FULL;
 
-	link_ksettings->base.duplex = DUPLEX_FULL;
 	link_ksettings->base.port = PORT_OTHER;
 
 	link_ksettings->base.autoneg = AUTONEG_DISABLE;
 
-	link_ksettings->base.speed = speed;
-
 	return 0;
 }
 
-- 
2.39.1

