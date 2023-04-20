Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5E86E8737
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbjDTBLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbjDTBK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:10:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC3F49E0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1517D6444C
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E267FC433D2;
        Thu, 20 Apr 2023 01:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953045;
        bh=ZbNM2BK8ao5yA+3pJv/4/olqqrtkX/RVK48RK+9ixgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t21CLmzMKwjAUWXgWgG0ybSx2gepMQUFI9F8F2+7IWl8RpIG/15b0MGSm31FXk/rX
         VN3jUIw2wcStBBOejxB9ukmxEijLGlsF2WRQ+WKi/Uu16Qj4yTyusLRXyrASHvwiRq
         0KprxYqUK6CgDtqaEK8i1o/lYoK47NWJ1K595lDZAPPjhpIImOPuQ3dk4Cw0w+TBHo
         43SBFynQLHkC8oM1QLv2LfCrhc5BaySA46M7Mlz0Cyk54tKf3Cl6cHGOV0sOtXe/In
         Aa8NvwJ9Z3GOKwpHZU7dGOcn2bMYYoZQcJtvBaFDfq9zHFzvwm909P7XVZr7scZXtr
         nVELN0z5vYOVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net 09/10] net/mlx5e: Nullify table pointer when failing to create
Date:   Wed, 19 Apr 2023 18:09:58 -0700
Message-Id: <20230420010959.276760-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420010959.276760-1-saeed@kernel.org>
References: <20230420010959.276760-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

On failing to create promisc flow steering table, the pointer is
returned with an error. Nullify it so unloading the driver won't try to
destroy a non existing table.

Failing to create promisc table may happen over BF devices when the ARM
side is going through a firmware tear down. The host side start a
reload flow. While the driver unloads, it tries to remove the promisc
table. Remove WARN in this state as it is a valid error flow.

Fixes: 1c46d7409f30 ("net/mlx5e: Optimize promiscuous mode")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index f1dac0244958..33bfe4d7338b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -783,6 +783,7 @@ static int mlx5e_create_promisc_table(struct mlx5e_flow_steering *fs)
 	ft->t = mlx5_create_auto_grouped_flow_table(fs->ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
+		ft->t = NULL;
 		fs_err(fs, "fail to create promisc table err=%d\n", err);
 		return err;
 	}
@@ -810,7 +811,7 @@ static void mlx5e_del_promisc_rule(struct mlx5e_flow_steering *fs)
 
 static void mlx5e_destroy_promisc_table(struct mlx5e_flow_steering *fs)
 {
-	if (WARN(!fs->promisc.ft.t, "Trying to remove non-existing promiscuous table"))
+	if (!fs->promisc.ft.t)
 		return;
 	mlx5e_del_promisc_rule(fs);
 	mlx5_destroy_flow_table(fs->promisc.ft.t);
-- 
2.39.2

