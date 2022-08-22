Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5812559C979
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiHVUAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238555AbiHVT7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A40119C3A
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCB136128D
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30033C433D6;
        Mon, 22 Aug 2022 19:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198378;
        bh=uRrZUgDUEsRzob2O7CFGPJyUTWBhrERkQH5lXjLTSIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Np+FMOe/OXfvUTs40obkMNEtfg9NEQMAOHUiX+Be6czi31/c5FNRoFJPVZDd5SWOv
         yktH7VCXumnS0J2zu+Wvx4vHOQ8Ahmzdwrhq4obRHXhK5jG8PyDrmTGPSGaF99LbqE
         hSJAaaJLPIET//T/Go3925K8+2vDKFH7PtMq9M1N60VLOez/dyiLTVuPXcPd+2/d73
         wYqDPoTVUm6o4XDl2I6UDCIlnr1rYEqRdkHy+gh3K+ICIC0QiW+jyu1lYMGDATtxmr
         4TIbz/HShBxwhQNC+C6tnu4n66mvdFAKEXzJcMXYgmdy0SVrfadAa/OffvIDyGWGoy
         y1xmK6ub30BVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net 10/13] net/mlx5: unlock on error path in esw_vfs_changed_event_handler()
Date:   Mon, 22 Aug 2022 12:59:14 -0700
Message-Id: <20220822195917.216025-11-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822195917.216025-1-saeed@kernel.org>
References: <20220822195917.216025-1-saeed@kernel.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

Unlock before returning on this error path.

Fixes: f1bc646c9a06 ("net/mlx5: Use devl_ API in mlx5_esw_offloads_devlink_port_register")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 10b0b260f02b..a9f4c652f859 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3116,8 +3116,10 @@ esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
 
 		err = mlx5_eswitch_load_vf_vports(esw, new_num_vfs,
 						  MLX5_VPORT_UC_ADDR_CHANGE);
-		if (err)
+		if (err) {
+			devl_unlock(devlink);
 			return;
+		}
 	}
 	esw->esw_funcs.num_vfs = new_num_vfs;
 	devl_unlock(devlink);
-- 
2.37.1

