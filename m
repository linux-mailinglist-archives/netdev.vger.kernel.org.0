Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD8668A95C
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjBDKJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbjBDKJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F96F69514
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D2C0B80AB2
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F33DC433EF;
        Sat,  4 Feb 2023 10:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505369;
        bh=w4FrPcGDqEAvEmsS5a0AB2DZlPlwZHHODFLCoNYKWuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4PmJA/Zms1gCk/1srso3ysaAcvUVObrBNqaFC6WLxBmLT9TH1/+Qg3zPsyt2hfsV
         NypXY6v4NhDj3xN0mc6rwAKVZaIrBaMZRmE0Wk6sE7lyG8UEUuG3MnXUYIb0QdG8S0
         NbXPu7XF1SCSh9Mom/oPpYlBqV4mQqRS+4PI1uvRe+cNuPo2FyQCP2sDpgJHdhA9/p
         jsWUg4XJLnH4VI7KkjPJ8iUSKRyYFxLPVcQwk5yHuNn4flTepe3eJmyRacyIr2lh5z
         ga62FQcz1xQ24YYDIMLGzrwLX6hgndH65u429fCxWRsifv/aT1rc72KY/B/fpuufU6
         FUWHX//m/VMBA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: IPsec, support upper protocol selector field offload
Date:   Sat,  4 Feb 2023 02:08:53 -0800
Message-Id: <20230204100854.388126-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

Add support to policy/state upper protocol selector field offload,
this will enable to select traffic for IPsec operation based on l4
protocol (TCP/UDP) with specific source/destination port.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 23 +++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 10 ++++++++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 23 +++++++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index e84c3400ba1d..7b0d3de0ec6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -158,6 +158,11 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	attrs->family = x->props.family;
 	attrs->type = x->xso.type;
 	attrs->reqid = x->props.reqid;
+	attrs->upspec.dport = ntohs(x->sel.dport);
+	attrs->upspec.dport_mask = ntohs(x->sel.dport_mask);
+	attrs->upspec.sport = ntohs(x->sel.sport);
+	attrs->upspec.sport_mask = ntohs(x->sel.sport_mask);
+	attrs->upspec.proto = x->sel.proto;
 
 	mlx5e_ipsec_init_limits(sa_entry, attrs);
 }
@@ -221,6 +226,13 @@ static int mlx5e_xfrm_validate_state(struct mlx5_core_dev *mdev,
 		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states with geniv other than seqiv");
 		return -EINVAL;
 	}
+
+	if (x->sel.proto != IPPROTO_IP &&
+	    (x->sel.proto != IPPROTO_UDP || x->xso.dir != XFRM_DEV_OFFLOAD_OUT)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device does not support upper protocol other than UDP, and only Tx direction");
+		return -EINVAL;
+	}
+
 	switch (x->xso.type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
 		if (!(mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO)) {
@@ -517,6 +529,12 @@ static int mlx5e_xfrm_validate_policy(struct xfrm_policy *x,
 		return -EINVAL;
 	}
 
+	if (x->selector.proto != IPPROTO_IP &&
+	    (x->selector.proto != IPPROTO_UDP || x->xdo.dir != XFRM_DEV_OFFLOAD_OUT)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device does not support upper protocol other than UDP, and only Tx direction");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -537,6 +555,11 @@ mlx5e_ipsec_build_accel_pol_attrs(struct mlx5e_ipsec_pol_entry *pol_entry,
 	attrs->action = x->action;
 	attrs->type = XFRM_DEV_OFFLOAD_PACKET;
 	attrs->reqid = x->xfrm_vec[0].reqid;
+	attrs->upspec.dport = ntohs(sel->dport);
+	attrs->upspec.dport_mask = ntohs(sel->dport_mask);
+	attrs->upspec.sport = ntohs(sel->sport);
+	attrs->upspec.sport_mask = ntohs(sel->sport_mask);
+	attrs->upspec.proto = sel->proto;
 }
 
 static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 8bed9c361075..b387adca9c20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -52,6 +52,14 @@ struct aes_gcm_keymat {
 	u32   aes_key[256 / 32];
 };
 
+struct upspec {
+	u16 dport;
+	u16 dport_mask;
+	u16 sport;
+	u16 sport_mask;
+	u8 proto;
+};
+
 struct mlx5_accel_esp_xfrm_attrs {
 	u32   esn;
 	u32   spi;
@@ -68,6 +76,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 		__be32 a6[4];
 	} daddr;
 
+	struct upspec upspec;
 	u8 dir : 2;
 	u8 esn_overlap : 1;
 	u8 esn_trigger : 1;
@@ -181,6 +190,7 @@ struct mlx5_accel_pol_xfrm_attrs {
 		__be32 a6[4];
 	} daddr;
 
+	struct upspec upspec;
 	u8 family;
 	u8 action;
 	u8 type : 2;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 9f19f4b59a70..5da6fe68eea6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -467,6 +467,27 @@ static void setup_fte_reg_c0(struct mlx5_flow_spec *spec, u32 reqid)
 		 misc_parameters_2.metadata_reg_c_0, reqid);
 }
 
+static void setup_fte_upper_proto_match(struct mlx5_flow_spec *spec, struct upspec *upspec)
+{
+	if (upspec->proto != IPPROTO_UDP)
+		return;
+
+	spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, spec->match_criteria, ip_protocol);
+	MLX5_SET(fte_match_set_lyr_2_4, spec->match_value, ip_protocol, upspec->proto);
+	if (upspec->dport) {
+		MLX5_SET(fte_match_set_lyr_2_4, spec->match_criteria, udp_dport,
+			 upspec->dport_mask);
+		MLX5_SET(fte_match_set_lyr_2_4, spec->match_value, udp_dport, upspec->dport);
+	}
+
+	if (upspec->sport) {
+		MLX5_SET(fte_match_set_lyr_2_4, spec->match_criteria, udp_dport,
+			 upspec->sport_mask);
+		MLX5_SET(fte_match_set_lyr_2_4, spec->match_value, udp_dport, upspec->sport);
+	}
+}
+
 static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
 			       struct mlx5_flow_act *flow_act)
 {
@@ -654,6 +675,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		setup_fte_addr6(spec, attrs->saddr.a6, attrs->daddr.a6);
 
 	setup_fte_no_frags(spec);
+	setup_fte_upper_proto_match(spec, &attrs->upspec);
 
 	switch (attrs->type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
@@ -728,6 +750,7 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 		setup_fte_addr6(spec, attrs->saddr.a6, attrs->daddr.a6);
 
 	setup_fte_no_frags(spec);
+	setup_fte_upper_proto_match(spec, &attrs->upspec);
 
 	err = setup_modify_header(mdev, attrs->reqid, XFRM_DEV_OFFLOAD_OUT,
 				  &flow_act);
-- 
2.39.1

