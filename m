Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FFD5F216A
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJBFOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJBFOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:14:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9422652097
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:14:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0E37B80C03
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CCCC433B5;
        Sun,  2 Oct 2022 05:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687648;
        bh=N2VXoGIGz/c/zQW6MgFUZddS1ZkJAJj6RVE7botwhOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5Nvra0pzPqXVQlU3aruLXEQVZ75CG63ZZUu+IPwx6tgeOXflNwi/v1Qrags4xQqw
         28Nj3GmdGrRODl4fkbwk2RfACGNxxywKORgXw3t412hcXEau1kPFLm8TxnvUEfcsyu
         Jd7MBcWOPu8CeJlYkxImygvUNayR2DBJl/Zs0YJ8NSuEA7QWyJ7g98r0YTuOeKBGvL
         PYeASJFtWXCrw4ox/b01LDUUCpk3ctuYbVD8jxxCET14Xy1ifQjLvLfiAn++BOFmC2
         jdDl77XUNczfUe+Q7uvcuvvrmPpdzrj8Gz17Lv0MC6RPOtfbQeHrYmTH1cMKffqj4/
         Ze875M5oOtXgA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [PATCH net-next 13/15] net/mlx5: E-Switch, Allow offloading fwd dest flow table with vport
Date:   Sat,  1 Oct 2022 21:56:30 -0700
Message-Id: <20221002045632.291612-14-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

Before this commit a fwd dest flow table resulted in ignoring vport dests
which is incorrect and is supported.
With this commit the dests can be a mix of flow table and vport dests.
There is still a limitation that there cannot be more than one flow table dest.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c        | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c98c6af21581..4e50df3139c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -483,25 +483,27 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 	    !(attr->flags & MLX5_ATTR_FLAG_SLOW_PATH)) {
 		esw_setup_sampler_dest(dest, flow_act, attr->sample_attr.sampler_id, *i);
 		(*i)++;
-	} else if (attr->dest_ft) {
-		esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
-		(*i)++;
 	} else if (attr->flags & MLX5_ATTR_FLAG_SLOW_PATH) {
 		esw_setup_slow_path_dest(dest, flow_act, esw, *i);
 		(*i)++;
 	} else if (attr->flags & MLX5_ATTR_FLAG_ACCEPT) {
 		esw_setup_accept_dest(dest, flow_act, chains, *i);
 		(*i)++;
-	} else if (attr->dest_chain) {
-		err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain,
-					   1, 0, *i);
-		(*i)++;
 	} else if (esw_is_indir_table(esw, attr)) {
 		err = esw_setup_indir_table(dest, flow_act, esw, attr, spec, true, i);
 	} else if (esw_is_chain_src_port_rewrite(esw, esw_attr)) {
 		err = esw_setup_chain_src_port_rewrite(dest, flow_act, esw, chains, attr, i);
 	} else {
 		*i = esw_setup_vport_dests(dest, flow_act, esw, esw_attr, *i);
+
+		if (attr->dest_ft) {
+			err = esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
+			(*i)++;
+		} else if (attr->dest_chain) {
+			err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain,
+						   1, 0, *i);
+			(*i)++;
+		}
 	}
 
 	return err;
-- 
2.37.3

