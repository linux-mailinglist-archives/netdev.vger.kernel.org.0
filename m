Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EEC6C3C75
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjCUVLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCUVLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:11:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E819C57D30
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 14:11:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2B75B81A3C
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 21:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B64EC433D2;
        Tue, 21 Mar 2023 21:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679433102;
        bh=T1gHgF/krt66bMl+FzD/Z1bqpe1pdkwXeh6elPfYFvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ST6HAVioK6/iQsCwupwlRvoqK6Qd6hMguGl/nhpG/RHyGRaypDeaxRMSr0ttQI3x8
         E4VtNZdhqwY8z7aKupGrzeaZQH1QD24nT1dlClw3YHlML7yX7UQJVW3k+iprHWvBi0
         3OxVa3HCIh/KIhfGt4wW/MLQWufPonZ1Dj3k6FAKLr1ML3iiuStB56wo6eHwRA7Jhe
         P7MPTzhM7t0z5pbXCPwZr74YpJNZsJnCPguXUYMBkPwt6CyCctubCUG+Cn8OpaiJga
         y67Q+02Jtwp/64UkPrC0cZfDdFYWIky+l4y6dZgwfSNf+Fsq7SIRqBrZfsczOXAP4R
         iiHzVrs9X5gnA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dan Carpenter <error27@gmail.com>, Roi Dayan <roid@nvidia.com>
Subject: [net 7/7] net/mlx5: E-Switch, Fix an Oops in error handling code
Date:   Tue, 21 Mar 2023 14:11:35 -0700
Message-Id: <20230321211135.47711-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321211135.47711-1-saeed@kernel.org>
References: <20230321211135.47711-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

The error handling dereferences "vport".  There is nothing we can do if
it is an error pointer except returning the error code.

Fixes: 133dcfc577ea ("net/mlx5: E-Switch, Alloc and free unique metadata for match")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index d55775627a47..50d2ea323979 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -364,8 +364,7 @@ int mlx5_esw_acl_ingress_vport_metadata_update(struct mlx5_eswitch *esw, u16 vpo
 
 	if (WARN_ON_ONCE(IS_ERR(vport))) {
 		esw_warn(esw->dev, "vport(%d) invalid!\n", vport_num);
-		err = PTR_ERR(vport);
-		goto out;
+		return PTR_ERR(vport);
 	}
 
 	esw_acl_ingress_ofld_rules_destroy(esw, vport);
-- 
2.39.2

