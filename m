Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFEF4C2075
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245206AbiBXANR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245198AbiBXAM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0165F4DD
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55AF560C47
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA37DC340F3;
        Thu, 24 Feb 2022 00:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661547;
        bh=jNTdZS/CT+zl6ucAkDhYmI1TltV8OvpG0FwErI0fGrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvAC7dpKZkh+toUba/A6tq46URJKO4X5SsH5LsuQxHebQ2simmMAKGgtpJXjvgB+c
         uJZ373GqEogLyoQ5dSqj7Vpd5lVz8b0O+UsZ+KeVRGdSd9QwAmg3uen9oQzM1HFM1p
         B3Lp7ktm7gpR0E/pDERN/bQHnHMNHeOCuqotjevBHxdL65rFa6jqZ2ox7jGfv0Zzxr
         0wry8mFEh0oBLXRliLcq9+LT2eC4dz2f7ey/DwA2FAwreAZ6pE/vAwNUMGK3e9OEly
         hve3Eb8Sb24zDXq0xMUz1arCiMtm8eDpUqhhqJECgTwawziJ9hAuq6jcvVcrZSmpy+
         i/ku1bRAzr0Qg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Lama Kayal <lkayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 18/19] net/mlx5e: Add missing increment of count
Date:   Wed, 23 Feb 2022 16:11:22 -0800
Message-Id: <20220224001123.365265-19-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Add mistakenly missing increment of count variable when looping over
output buffer in mlx5e_self_test().

This resolves the issue of garbage values output when querying with self
test via ethtool.

before:
$ ethtool -t eth2
The test result is PASS
The test extra info:
Link Test        0
Speed Test       1768697188
Health Test      758528120
Loopback Test    3288687

after:
$ ethtool -t eth2
The test result is PASS
The test extra info:
Link Test        0
Speed Test       0
Health Test      0
Loopback Test    0

Fixes: 7990b1b5e8bd ("net/mlx5e: loopback test is not supported in switchdev mode")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 8c9163d2c646..08a75654f5f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -334,6 +334,7 @@ void mlx5e_self_test(struct net_device *ndev, struct ethtool_test *etest,
 		netdev_info(ndev, "\t[%d] %s start..\n", i, st.name);
 		buf[count] = st.st_func(priv);
 		netdev_info(ndev, "\t[%d] %s end: result(%lld)\n", i, st.name, buf[count]);
+		count++;
 	}
 
 	mutex_unlock(&priv->state_lock);
-- 
2.35.1

