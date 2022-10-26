Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D643560E2A8
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiJZNxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbiJZNwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:52:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9EE108DD3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:52:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC587B82257
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07B3C433D6;
        Wed, 26 Oct 2022 13:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792353;
        bh=WYCjuyrdUwQffFpLyhVGFBEeejAtTOq7ZMQ1SiitKiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmW4OiKL1K85DTy5bKhjotXmT8mLFhUcuxiUX+taSnRfO/Skz4OBFR4awyC3Xpog1
         ONdZ6PQVfPNx1D5ZstZY5R8JVJi1Xsc8YaQgSJmgLHLmgBDpV9gDVtQtX5386io7Bw
         FJmSflQsXKQf4EKsgvYKY+JC0ghyMmgyw4kF5XraTzAoEn6CzQ8XOR7y0TghlUQr2G
         gII3MW4wzm629+yimGfZjDroZX824HG+UoO/P0EFMu9q0jJVpQNpENG/O4mLGU+i7r
         vcuopjUNHyaAOwfwJBk/n3awmgU/DJQWfPqL5qA4xtnjW5aoN2sbp23zqEbsimFWPD
         ghQz2GDA1cqzA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [V4 net 08/15] net/mlx5e: TC, Reject forwarding from internal port to internal port
Date:   Wed, 26 Oct 2022 14:51:46 +0100
Message-Id: <20221026135153.154807-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026135153.154807-1-saeed@kernel.org>
References: <20221026135153.154807-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Reject TC rules that forward from internal port to internal port
as it is not supported.

This include rules that are explicitly have internal port as
the filter device as well as rules that apply on tunnel interfaces
as the route device for the tunnel interface can be an internal
port.

Fixes: 27484f7170ed ("net/mlx5e: Offload tc rules that redirect to ovs internal port")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2cceace36c77..73f91e54e9d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4066,6 +4066,7 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
+	struct net_device *filter_dev;
 	int err;
 
 	err = flow_action_supported(flow_action, extack);
@@ -4074,6 +4075,7 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 	esw_attr = attr->esw_attr;
 	parse_attr = attr->parse_attr;
+	filter_dev = parse_attr->filter_dev;
 	parse_state = &parse_attr->parse_state;
 	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
 	parse_state->ct_priv = get_ct_priv(priv);
@@ -4083,13 +4085,21 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return err;
 
 	/* Forward to/from internal port can only have 1 dest */
-	if ((netif_is_ovs_master(parse_attr->filter_dev) || esw_attr->dest_int_port) &&
+	if ((netif_is_ovs_master(filter_dev) || esw_attr->dest_int_port) &&
 	    esw_attr->out_count > 1) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Rules with internal port can have only one destination");
 		return -EOPNOTSUPP;
 	}
 
+	/* Forward from tunnel/internal port to internal port is not supported */
+	if ((mlx5e_get_tc_tun(filter_dev) || netif_is_ovs_master(filter_dev)) &&
+	    esw_attr->dest_int_port) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Forwarding from tunnel/internal port to internal port is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	err = actions_prepare_mod_hdr_actions(priv, flow, attr, extack);
 	if (err)
 		return err;
-- 
2.37.3

