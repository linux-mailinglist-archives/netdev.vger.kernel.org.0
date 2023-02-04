Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9003668A951
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbjBDKJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbjBDKJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B88C1B55E
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1989B60BE9
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F10C433D2;
        Sat,  4 Feb 2023 10:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505358;
        bh=PLeqP9ZkL34y+i9Q0etSgYF7QxJwD/JN6ESo80mfQw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PX1NF0ChErKzkeU3n5TIwu/RQv2BwbneTzt3fUHKDeajy2b5lxKHEbfi5QOr3iIG+
         xzpVp6BEEDhC3W17eSz1kGTbDWZJm3N9NhTLCMqwU8tB5GCpF8Txn7T3SzLJdF71+y
         JI2e5v8booYCAZLQgugeMwT2CnvbSPz4YHtD4XEUuaeXgNAH7yd1MpqIU/zOBA2tcz
         Bs337YZS+avtf/MZlpJ0e+CVuvkEU901KxweypCOZyo7veUvShDeqpUNPmahTrR7AE
         1ZI0dzZJ0m5A7xEe/+1czzi2qshH+yBRL5K1riiIlR/g/xqX/tPzXmH0RGICEQinKR
         Y2pB5NsRXdVBw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Lag, Use flag to check for shared FDB mode
Date:   Sat,  4 Feb 2023 02:08:43 -0800
Message-Id: <20230204100854.388126-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

It's redundant and incorrect to check lag is also sriov mode.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index b64c63e67a18..dbf218cac535 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1386,8 +1386,7 @@ bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev)
 
 	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
-	res = ldev && __mlx5_lag_is_sriov(ldev) &&
-	      test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &ldev->mode_flags);
+	res = ldev && test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &ldev->mode_flags);
 	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
-- 
2.39.1

