Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD3F63CE9D
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiK3FNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbiK3FMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048C6769C7
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F6C461A17
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC9BC433D6;
        Wed, 30 Nov 2022 05:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785133;
        bh=+wdxnXcIE3i1bN2LrGxubw4ovxsVmCv4swY7pWk1gYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMhW+MPJ8c45ELhbVcQ3E07PU2IpKbQINf3bNqSiUFzzNmLheq0GxzuchdR+fRzqN
         6zMgUFmFB3d04Dk6EI0VusmL4+ygGMU5LCT0GOc51Wy1ov9cLvbq5A1q2HWw81elOI
         O+eIdKMdw9dgWCwHINMkrp9HNxMEvurMqpTNDjY7nG0QDhWVcWE/dK9jvS+zb3kEvj
         YNhi++arTAANtl5TN/xC4B0u874l6iAHpiB6TtN9qBRASVbIcg+Y6YtMxUvHOletwu
         a64fCvKpFV+F59FDeLVY/j6aqZKgNhvPGDuWcSSlAZGhN120LYXORvkm8O3wUXzTSn
         BafpAoJagiCnw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Do early return when setup vports dests for slow path flow
Date:   Tue, 29 Nov 2022 21:11:50 -0800
Message-Id: <20221130051152.479480-14-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

Adding flow flag cases in setup vport dests before the slow path
case is incorrect as the slow path should take precedence.
Current code doesn't show this importance so make the slow path
case return early and separate from the other cases and remove
the redundant comparison of it in the sample case.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c  | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8c6c9bcb3dc3..4b358b87fead 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -479,13 +479,15 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 	    esw_src_port_rewrite_supported(esw))
 		attr->flags |= MLX5_ATTR_FLAG_SRC_REWRITE;
 
-	if (attr->flags & MLX5_ATTR_FLAG_SAMPLE &&
-	    !(attr->flags & MLX5_ATTR_FLAG_SLOW_PATH)) {
-		esw_setup_sampler_dest(dest, flow_act, attr->sample_attr.sampler_id, *i);
-		(*i)++;
-	} else if (attr->flags & MLX5_ATTR_FLAG_SLOW_PATH) {
+	if (attr->flags & MLX5_ATTR_FLAG_SLOW_PATH) {
 		esw_setup_slow_path_dest(dest, flow_act, esw, *i);
 		(*i)++;
+		goto out;
+	}
+
+	if (attr->flags & MLX5_ATTR_FLAG_SAMPLE) {
+		esw_setup_sampler_dest(dest, flow_act, attr->sample_attr.sampler_id, *i);
+		(*i)++;
 	} else if (attr->flags & MLX5_ATTR_FLAG_ACCEPT) {
 		esw_setup_accept_dest(dest, flow_act, chains, *i);
 		(*i)++;
@@ -506,6 +508,7 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 		}
 	}
 
+out:
 	return err;
 }
 
-- 
2.38.1

