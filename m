Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF90152B26E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiERGf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiERGey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:34:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503EEE52BC
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1869B81E98
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BF3C385AA;
        Wed, 18 May 2022 06:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652855684;
        bh=cj9jtXmq3iqIkef08oxu1r419tbTqPDC6iUgur0THHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdzEpgLV5lBgRFI4UBiNbZd/8ypJQ4uL3KRqpRqX73td6gSA+l+Nx06Rov85Is+l9
         rT1vPtxSHaytCVtM4e56eLI4r4m6Y81XtHKEH5GTYsWIBHMoi7ro3S5rTljP4YagQR
         EB1hK7dPBCFQVQxE8++ibSTfboC1wxtsxFMP5LMYzIK/5qZo2j4otVJ9xNBmSh0Lm/
         RCiLeaN6lqO49TqIpwitI/pfriKTvgjrcInCLmkh5diS3nPMHaT02rqSmPc8WsQBts
         gwWNIfzx8R9VzNjRORREb1aX+wDelPeBb5vGzodxrAh6Or4l2OkywNiW34JNEseb3Y
         6fxw3Tgz+yh6g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/11] net/mlx5e: Block rx-gro-hw feature in switchdev mode
Date:   Tue, 17 May 2022 23:34:21 -0700
Message-Id: <20220518063427.123758-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518063427.123758-1-saeed@kernel.org>
References: <20220518063427.123758-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When the driver is in switchdev mode and rx-gro-hw is set, the RQ needs
special CQE handling. Till then, block setting of rx-gro-hw feature in
switchdev mode, to avoid failure while setting the feature due to
failure while opening the RQ.

Fixes: f97d5c2a453e ("net/mlx5e: Add handle SHAMPO cqe support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2f1dedc721d1..999241961714 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3864,6 +3864,10 @@ static netdev_features_t mlx5e_fix_uplink_rep_features(struct net_device *netdev
 	if (netdev->features & NETIF_F_NTUPLE)
 		netdev_warn(netdev, "Disabling ntuple, not supported in switchdev mode\n");
 
+	features &= ~NETIF_F_GRO_HW;
+	if (netdev->features & NETIF_F_GRO_HW)
+		netdev_warn(netdev, "Disabling HW_GRO, not supported in switchdev mode\n");
+
 	return features;
 }
 
-- 
2.36.1

