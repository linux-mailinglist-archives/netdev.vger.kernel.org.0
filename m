Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57DD4F5C5E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiDFLgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238571AbiDFLec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:34:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA02466A12;
        Wed,  6 Apr 2022 01:26:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3844060BBC;
        Wed,  6 Apr 2022 08:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27289C385A5;
        Wed,  6 Apr 2022 08:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233577;
        bh=mVWd0sPSPhb/64Il5vnij+ydWrnTPFzzurOFlKh4S/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeF4RCFDTbxczBxDH/PwCTGjhXQm4UgN3+hQvKtW6ib4dtKgNRGzsm7ixpNvyCbOa
         9CcQGS6vK+o8xGG6BhY0ZbsVcU7qLHaaQISvmNhr+uikY5tcMGGFx+MeRvUDRXH5aI
         aiYusf8UKqzRLxEgETW7dHb/WYm1KvEgUUVYCNQH8X77uMf849c/OyG7wYACsvhdP/
         0CmYCBHXQryHLWis/8qQp2Z7decwJ+KkkKs5ouBLE7oyk/SoRMuufWm6fkLpxuCRYX
         J7ZbGWSvdWhA//rH3peDMPSx68Jdcm70FhdsqDJBQmLJzUDBHfs7FblwodRi41aYZy
         e+4zB0Z6llE4A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 06/17] RDMA/mlx5: Delete never supported IPsec flow action
Date:   Wed,  6 Apr 2022 11:25:41 +0300
Message-Id: <697cd60bd5c9b6a004c449c1a41c2798fac844ff.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

The IPSEC_REQUIRED_METADATA capability bit is never set, and can be
safely removed from the flow action flags.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 172773ed427a..4a9629c01cf1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1798,15 +1798,11 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
 		if (mlx5_get_flow_namespace(dev->mdev,
 				MLX5_FLOW_NAMESPACE_EGRESS))
 			resp->flow_action_flags |= MLX5_USER_ALLOC_UCONTEXT_FLOW_ACTION_FLAGS_ESP_AES_GCM;
-		if (mlx5_accel_ipsec_device_caps(dev->mdev) &
-				MLX5_ACCEL_IPSEC_CAP_REQUIRED_METADATA)
-			resp->flow_action_flags |= MLX5_USER_ALLOC_UCONTEXT_FLOW_ACTION_FLAGS_ESP_AES_GCM_REQ_METADATA;
 		if (MLX5_CAP_FLOWTABLE(dev->mdev, flow_table_properties_nic_receive.ft_field_support.outer_esp_spi))
 			resp->flow_action_flags |= MLX5_USER_ALLOC_UCONTEXT_FLOW_ACTION_FLAGS_ESP_AES_GCM_SPI_STEERING;
 		if (mlx5_accel_ipsec_device_caps(dev->mdev) &
 				MLX5_ACCEL_IPSEC_CAP_TX_IV_IS_ESN)
 			resp->flow_action_flags |= MLX5_USER_ALLOC_UCONTEXT_FLOW_ACTION_FLAGS_ESP_AES_GCM_TX_IV_IS_ESN;
-		/* MLX5_USER_ALLOC_UCONTEXT_FLOW_ACTION_FLAGS_ESP_AES_GCM_FULL_OFFLOAD is currently always 0 */
 	}
 
 	resp->tot_bfregs = bfregi->lib_uar_dyn ? 0 :
-- 
2.35.1

