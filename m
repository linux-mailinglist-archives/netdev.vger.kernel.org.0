Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB13E4C2078
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245224AbiBXANY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243716AbiBXAM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB075F4EF
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8907BB8228E
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3060C340F5;
        Thu, 24 Feb 2022 00:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661546;
        bh=5ovLBjw2O/rNwFR3wRR+n3AAMtss0bCK0u9UgJoCaUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXvMiK5HyVyGAH06hvdk7PZVxWr9QwQcNnvwFqiTDtXYvZbHOrAVFMUrodu9kSD5X
         1FEJScnEQgG4XKuyUyDRVvwPPKIMTBKMwjKjsu46UogKDxyX5hZh1C+mwQbvT1gVZ4
         MAYFwJKqSyH8cxHQDDtMpoBUu0yY7kIjb8Ro68Tmf97bu2eQ1ebIctarGvz5Ys2hfm
         pBcEEtRDSN8jbDsucQoGVcR24AojyYVLIYe6Uebpo+rR3boJiwY4A81h4yaJ5cT2oo
         ICSRNbWovZ2VFWtafTcLIlBfYY868KfL2riyMlahjMmxj0SNGvqq5g2aGLPmICk3WR
         qMQvVUfZN6S3Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 16/19] net/mlx5e: Fix MPLSoUDP encap to use MPLS action information
Date:   Wed, 23 Feb 2022 16:11:20 -0800
Message-Id: <20220224001123.365265-17-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

Currently the MPLSoUDP encap builds the MPLS header using encap action
information (tunnel id, ttl and tos) instead of the MPLS action
information (label, ttl, tc and bos) which is wrong.

Fix by storing the MPLS action information during the flow action
parse and later using it to create the encap MPLS header.

Fixes: f828ca6a2fb6 ("net/mlx5e: Add support for hw encapsulation of MPLS over UDP")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/act.h   |  1 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c    |  6 ++++++
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c  | 11 +++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c |  3 +++
 .../ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c  |  5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h      |  8 ++++++++
 7 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 10a40487d536..9cc844bd00f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -22,6 +22,7 @@ struct mlx5e_tc_act_parse_state {
 	bool mpls_push;
 	bool ptype_host;
 	const struct ip_tunnel_info *tun_info;
+	struct mlx5e_mpls_info mpls_info;
 	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX];
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	int if_count;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index c614fc7fdc9c..2e615e0ba972 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -177,6 +177,12 @@ parse_mirred_encap(struct mlx5e_tc_act_parse_state *parse_state,
 		return -ENOMEM;
 
 	parse_state->encap = false;
+
+	if (parse_state->mpls_push) {
+		memcpy(&parse_attr->mpls_info[esw_attr->out_count],
+		       &parse_state->mpls_info, sizeof(parse_state->mpls_info));
+		parse_state->mpls_push = false;
+	}
 	esw_attr->dests[esw_attr->out_count].flags |= MLX5_ESW_DEST_ENCAP;
 	esw_attr->out_count++;
 	/* attr->dests[].rep is resolved when we handle encap */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
index 784fc4f68b1e..89ca88c78840 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
@@ -22,6 +22,16 @@ tc_act_can_offload_mpls_push(struct mlx5e_tc_act_parse_state *parse_state,
 	return true;
 }
 
+static void
+copy_mpls_info(struct mlx5e_mpls_info *mpls_info,
+	       const struct flow_action_entry *act)
+{
+	mpls_info->label = act->mpls_push.label;
+	mpls_info->tc = act->mpls_push.tc;
+	mpls_info->bos = act->mpls_push.bos;
+	mpls_info->ttl = act->mpls_push.ttl;
+}
+
 static int
 tc_act_parse_mpls_push(struct mlx5e_tc_act_parse_state *parse_state,
 		       const struct flow_action_entry *act,
@@ -29,6 +39,7 @@ tc_act_parse_mpls_push(struct mlx5e_tc_act_parse_state *parse_state,
 		       struct mlx5_flow_attr *attr)
 {
 	parse_state->mpls_push = true;
+	copy_mpls_info(&parse_state->mpls_info, act);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index f832c26ff2c3..70b40ae384e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -35,6 +35,7 @@ enum {
 
 struct mlx5e_tc_flow_parse_attr {
 	const struct ip_tunnel_info *tun_info[MLX5_MAX_FLOW_FWD_VPORTS];
+	struct mlx5e_mpls_info mpls_info[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct net_device *filter_dev;
 	struct mlx5_flow_spec spec;
 	struct mlx5e_tc_mod_hdr_acts mod_hdr_acts;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 9918ed8c059b..d39d0dae22fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -750,6 +750,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	const struct ip_tunnel_info *tun_info;
+	const struct mlx5e_mpls_info *mpls_info;
 	unsigned long tbl_time_before = 0;
 	struct mlx5e_encap_entry *e;
 	struct mlx5e_encap_key key;
@@ -760,6 +761,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 
 	parse_attr = attr->parse_attr;
 	tun_info = parse_attr->tun_info[out_index];
+	mpls_info = &parse_attr->mpls_info[out_index];
 	family = ip_tunnel_info_af(tun_info);
 	key.ip_tun_key = &tun_info->key;
 	key.tc_tunnel = mlx5e_get_tc_tun(mirred_dev);
@@ -810,6 +812,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 		goto out_err_init;
 	}
 	e->tun_info = tun_info;
+	memcpy(&e->mpls_info, mpls_info, sizeof(*mpls_info));
 	err = mlx5e_tc_tun_init_encap_attr(mirred_dev, priv, e, extack);
 	if (err)
 		goto out_err_init;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
index 60952b33b568..f40dbfcb6437 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
@@ -30,16 +30,15 @@ static int generate_ip_tun_hdr(char buf[],
 			       struct mlx5e_encap_entry *r)
 {
 	const struct ip_tunnel_key *tun_key = &r->tun_info->key;
+	const struct mlx5e_mpls_info *mpls_info = &r->mpls_info;
 	struct udphdr *udp = (struct udphdr *)(buf);
 	struct mpls_shim_hdr *mpls;
-	u32 tun_id;
 
-	tun_id = be32_to_cpu(tunnel_id_to_key32(tun_key->tun_id));
 	mpls = (struct mpls_shim_hdr *)(udp + 1);
 	*ip_proto = IPPROTO_UDP;
 
 	udp->dest = tun_key->tp_dst;
-	*mpls = mpls_entry_encode(tun_id, tun_key->ttl, tun_key->tos, true);
+	*mpls = mpls_entry_encode(mpls_info->label, mpls_info->ttl, mpls_info->tc, mpls_info->bos);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index b01dacb6f527..b3f7520dfd08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -183,6 +183,13 @@ struct mlx5e_decap_entry {
 	struct rcu_head rcu;
 };
 
+struct mlx5e_mpls_info {
+	u32             label;
+	u8              tc;
+	u8              bos;
+	u8              ttl;
+};
+
 struct mlx5e_encap_entry {
 	/* attached neigh hash entry */
 	struct mlx5e_neigh_hash_entry *nhe;
@@ -196,6 +203,7 @@ struct mlx5e_encap_entry {
 	struct list_head route_list;
 	struct mlx5_pkt_reformat *pkt_reformat;
 	const struct ip_tunnel_info *tun_info;
+	struct mlx5e_mpls_info mpls_info;
 	unsigned char h_dest[ETH_ALEN];	/* destination eth addr	*/
 
 	struct net_device *out_dev;
-- 
2.35.1

