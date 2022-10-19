Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6E26039E0
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJSGjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiJSGiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:38:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0D76E2EF
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B937A61780
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104F4C433C1;
        Wed, 19 Oct 2022 06:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161522;
        bh=WYCjuyrdUwQffFpLyhVGFBEeejAtTOq7ZMQ1SiitKiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uO5Kze5+zAHPiebVMdl3zPv58mdQaZWTdZFRQ2XMsovkQVRWTw/7iqYE0tqDYzNWU
         KynOaqIR0nkf7nGXCASN8TfkuRMnWV2TNtcRlZrRe1ibEbMcPMvi1KAWa6C89f1CEB
         fwVquA2QdIj+CC3jmULWhywADINrL0N0IQzItqEsCJzcvvnsRfI27yfNly4HMm+YjN
         DoZANgwHLmQvumoGc8TbPH94uJzqrFXSIx6NZi78IO4wlLYH0P8YPWgdJfi0+mnFtu
         kPQ3tm9JC/cSykRRxkTBBqfyMcPF0Fi8L/IknfP241mWw1e5nBBFZORlJqjYrtCHl5
         h+ZG3R18URNKw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net 08/16] net/mlx5e: TC, Reject forwarding from internal port to internal port
Date:   Tue, 18 Oct 2022 23:38:05 -0700
Message-Id: <20221019063813.802772-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019063813.802772-1-saeed@kernel.org>
References: <20221019063813.802772-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

