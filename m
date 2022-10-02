Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E965F2168
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiJBFOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiJBFOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:14:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8D951A38
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D7DA60DEC
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551D3C43140;
        Sun,  2 Oct 2022 05:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687649;
        bh=QPQ6QU1ES7l/+6v+fOyUnegCUkwN4oPlQQr5ZXABZN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mw/VYIV86vv42/H7sqlvt0l/7YCXEgrW8de3ojv/8ZTKFB8FvNp32pagd1WD1QaGL
         ewv7LgeYs9WefVhN1wgGvmzg080vJrbMeL8SWcjnkXXjTy/DrwT+FzPfOyhKIjWW8/
         Qou7RoUMBWz4D8wwYfrP8GJlJocGJ0Cwz7YDGEWg4LG+lkSqZzcGfc5zMbuuclnigh
         OQj0X7SpldwlUQ5FAS/DFqcHe8hYbfe7xHV18bF8caxXSIw0oxbA4MotiC2nzVIlQL
         wkoe/fOcsMNdVuuqbxSBA6AFPs9pisHIGzjAbiy6mZ9P4Y18pcsRCs3T9v/0wh1nr6
         kBsUKhJzNfRhw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH net-next 14/15] net/mlx5: E-switch, Don't update group if qos is not enabled
Date:   Sat,  1 Oct 2022 21:56:31 -0700
Message-Id: <20221002045632.291612-15-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221002045632.291612-1-saeed@kernel.org>
References: <20221002045632.291612-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently, qos group will be updated and qos will be enabled when
unregistering devlink port. Actually no need to update group if qos
is not enabled.

Add a check to prevent unnecessary enabling and disabling qos for
every port.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Dmytro Linkin <dlinkin@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 694c54066955..4f8a24d84a86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -924,12 +924,16 @@ int mlx5_esw_qos_vport_update_group(struct mlx5_eswitch *esw,
 				    struct mlx5_esw_rate_group *group,
 				    struct netlink_ext_ack *extack)
 {
-	int err;
+	int err = 0;
 
 	mutex_lock(&esw->state_lock);
+	if (!vport->qos.enabled && !group)
+		goto unlock;
+
 	err = esw_qos_vport_enable(esw, vport, 0, 0, extack);
 	if (!err)
 		err = esw_qos_vport_update_group(esw, vport, group, extack);
+unlock:
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
-- 
2.37.3

