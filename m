Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8DE65867A
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbiL1Tnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiL1Tnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:43:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6524C10FEB
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C557B818F6
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C1CC433EF;
        Wed, 28 Dec 2022 19:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256621;
        bh=/PwXLCNITnaPbbJkcifvAgm5gOCofwoHcg4LahpwtNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdKXmUVVQw2wKC0pmEk9pd1PegKSfFkihjOmoh28sRUhv20FYs/zzVq6Q45En94Yi
         juqJP0WGeF6CLxc+qRTymr7dbzvtfUYmqW4fv9gkfgQssbCWgnmiLxsW0EQivQF4UD
         ttClwwSHJCT60v3uhF0IJQs+n7mMb3xOCdFPcCPc2eAqknsoKoYp5xyEi8NQ/MZI3C
         sRjHhalsL9HHOCra1uXxNusm5A8hON+fySH56qCmcn2SXCywfbqvkOafDOv+DhRiKW
         9XDjhPMTYBH8kdERONKIGGJHBmet/w0FPZM6B+CutwEuUg+jV1sI3NQJahRVMAI2sd
         Vyskdv9voTrjg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net 03/12] net/mlx5: Fix io_eq_size and event_eq_size params validation
Date:   Wed, 28 Dec 2022 11:43:22 -0800
Message-Id: <20221228194331.70419-4-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
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

From: Shay Drory <shayd@nvidia.com>

io_eq_size and event_eq_size params are of param type
DEVLINK_PARAM_TYPE_U32. But, the validation callback is addressing them
as DEVLINK_PARAM_TYPE_U16.

This cause mismatch in validation in big-endian systems, in which
values in range were rejected while 268500991 was accepted.
Fix it by checking the U32 value in the validation callback.

Fixes: 0844fa5f7b89 ("net/mlx5: Let user configure io_eq_size param")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index ddb197970c22..be59bb35d795 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -563,7 +563,7 @@ static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
 					  union devlink_param_value val,
 					  struct netlink_ext_ack *extack)
 {
-	return (val.vu16 >= 64 && val.vu16 <= 4096) ? 0 : -EINVAL;
+	return (val.vu32 >= 64 && val.vu32 <= 4096) ? 0 : -EINVAL;
 }
 
 static const struct devlink_param mlx5_devlink_params[] = {
-- 
2.38.1

