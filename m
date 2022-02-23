Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCBE4C195D
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243150AbiBWRFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243155AbiBWRFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311E65372C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:04:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2C8760FD2
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C43C36AE7;
        Wed, 23 Feb 2022 17:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645635886;
        bh=jNTdZS/CT+zl6ucAkDhYmI1TltV8OvpG0FwErI0fGrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBGS/IBIhgNZSO1MqRS0gNli4z6ZTuaj1Pb3EN9GDJcykf75j/EdAt7SHtDQytiGK
         6nK+pisvAsnrgYi1YmOupPj61Dbo3+flktC5Z7w7WSz0aeGse2DlUSbMojiG/7PdQD
         U7iZkYIzEyIpAqTjj95OYtPNnec1efQz9vnAASFlpRm8k8MBkTL/rGYzOLP/aKMILl
         G4TWdn4Lx40GRHM2ZOs4dhsEJyzW70VaDeOOiMiAz46b+fq6d/QxM5YQsw8bUGeHCp
         QvuFb89q6hJGP4VpGFdbHcwHTQ9QOkx2M0Mx/HG9rnBrGNkKCVPZ653ANKnq1fxPbI
         B89qd5ml9xDlg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Lama Kayal <lkayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 18/19] net/mlx5e: Add missing increment of count
Date:   Wed, 23 Feb 2022 09:04:29 -0800
Message-Id: <20220223170430.295595-19-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223170430.295595-1-saeed@kernel.org>
References: <20220223170430.295595-1-saeed@kernel.org>
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

