Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2690595A0D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbiHPL03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiHPLZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933CEB4EAD
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16E3B8169C
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEE1C433C1;
        Tue, 16 Aug 2022 10:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646444;
        bh=sdpEdAFbXYZASynPgnTWwTHlsfTwxJHAxZfYCR8ukz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeS/Lhu8q9GxlcbkxNKDmH/ShWSebqqLigg8GJJ1zrfyjdESHd642D7A0j1LG9SgT
         oExNhFWmyHMbC4+ABUF2+Cadjc5LV7HvOSPQiqSLDzID49AHy0ikjrozSLsHotoYkb
         rdXqbY9EBwym+RVv9llITdeuAXI8iYLXf/SJfezG+mXen4gv/MMxKjEPWkvhmfC6Il
         UNzsFUG5uP9DmC5+P2WSfICYz5270ypmSJC0DJ4LbudDZYwVSW17AqoZx0erC73qWh
         4iJ7f+RQb0mV1ySOsMX5Cp62InIzSS4ATklzVipn79RctqKHNiwKcqZCAGTGF8MBTD
         p86RZikdV8FbA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 22/26] net/mlx5e: Configure IPsec full offload flow steering
Date:   Tue, 16 Aug 2022 13:38:10 +0300
Message-Id: <513ea821354a80e2bfc944f87d17b802b2c522fd.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
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

In full offload mode, the HW is responsible to handle ESP headers,
SPI numbers and trailers (ICV) together with different logic for
RX and TX paths.

In order to support full offload mode, special logic is added
to flow steering rules.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  2 +
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 95 +++++++++++++++++--
 3 files changed, 89 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index fef1b1918419..7f93ec8ed3dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -165,6 +165,8 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	memcpy(&aes_gcm->salt, x->aead->alg_key + key_len,
 	       sizeof(aes_gcm->salt));
 
+	attrs->authsize = crypto_aead_authsize(aead) / 4; /* in dwords */
+
 	/* iv len */
 	aes_gcm->icv_len = x->aead->alg_icv_len;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index fead96097332..e5e3b2d1acc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -76,6 +76,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u8 type : 2;
 	u8 family;
 	u32 replay_window;
+	u32 authsize;
 };
 
 enum mlx5_ipsec_cap {
@@ -122,6 +123,7 @@ struct mlx5e_ipsec_esn_state {
 struct mlx5e_ipsec_rule {
 	struct mlx5_flow_handle *rule;
 	struct mlx5_modify_hdr *modify_hdr;
+	struct mlx5_pkt_reformat *pkt_reformat;
 };
 
 struct mlx5e_ipsec_modify_state_work {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 6911f0b962ce..a047b1d6a016 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -484,6 +484,49 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
 	return 0;
 }
 
+static int setup_pkt_reformat(struct mlx5_core_dev *mdev,
+			      struct mlx5_accel_esp_xfrm_attrs *attrs,
+			      struct mlx5_flow_act *flow_act)
+{
+	struct mlx5_pkt_reformat_params reformat_params = {};
+	enum mlx5_flow_namespace_type ns_type =
+		MLX5_FLOW_NAMESPACE_EGRESS_KERNEL;
+	struct mlx5_pkt_reformat *pkt_reformat;
+	u8 reformatbf[16] = {};
+	__be32 spi;
+
+	if (attrs->dir == XFRM_DEV_OFFLOAD_IN) {
+		reformat_params.type = MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT;
+		ns_type = MLX5_FLOW_NAMESPACE_KERNEL;
+		goto cmd;
+	}
+
+	if (attrs->family == AF_INET)
+		reformat_params.type =
+			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4;
+	else
+		reformat_params.type =
+			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;
+
+	/* convert to network format */
+	spi = htonl(attrs->spi);
+	memcpy(reformatbf, &spi, 4);
+
+	reformat_params.param_0 = attrs->authsize;
+	reformat_params.size = sizeof(reformatbf);
+	reformat_params.data = &reformatbf;
+
+cmd:
+	pkt_reformat =
+		mlx5_packet_reformat_alloc(mdev, &reformat_params, ns_type);
+	if (IS_ERR(pkt_reformat))
+		return PTR_ERR(pkt_reformat);
+
+	flow_act->pkt_reformat = pkt_reformat;
+	flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+	return 0;
+}
+
 static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
@@ -520,6 +563,16 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	if (err)
 		goto err_mod_header;
 
+	switch (attrs->type) {
+	case XFRM_DEV_OFFLOAD_FULL:
+		err = setup_pkt_reformat(mdev, attrs, &flow_act);
+		if (err)
+			goto err_pkt_reformat;
+		break;
+	default:
+		break;
+	}
+
 	flow_act.ipsec_obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
 	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
@@ -536,9 +589,13 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	sa_entry->ipsec_rule.rule = rule;
 	sa_entry->ipsec_rule.modify_hdr = flow_act.modify_hdr;
+	sa_entry->ipsec_rule.pkt_reformat = flow_act.pkt_reformat;
 	return 0;
 
 err_add_flow:
+	if (flow_act.pkt_reformat)
+		mlx5_packet_reformat_dealloc(mdev, flow_act.pkt_reformat);
+err_pkt_reformat:
 	mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
 err_mod_header:
 	kvfree(spec);
@@ -565,7 +622,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
 		err = -ENOMEM;
-		goto out;
+		goto err_alloc;
 	}
 
 	if (attrs->family == AF_INET)
@@ -573,28 +630,46 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	else
 		setup_fte_addr6(spec, attrs->saddr.a6, attrs->daddr.a6);
 
-	setup_fte_spi(spec, attrs->spi);
-	setup_fte_esp(spec);
 	setup_fte_no_frags(spec);
-	setup_fte_reg_a(spec);
+
+	switch (attrs->type) {
+	case XFRM_DEV_OFFLOAD_CRYPTO:
+		setup_fte_spi(spec, attrs->spi);
+		setup_fte_esp(spec);
+		setup_fte_reg_a(spec);
+		break;
+	case XFRM_DEV_OFFLOAD_FULL:
+		err = setup_pkt_reformat(mdev, attrs, &flow_act);
+		if (err)
+			goto err_pkt_reformat;
+		break;
+	default:
+		break;
+	}
 
 	flow_act.ipsec_obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW |
-			  MLX5_FLOW_CONTEXT_ACTION_IPSEC_ENCRYPT;
+	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW |
+			   MLX5_FLOW_CONTEXT_ACTION_IPSEC_ENCRYPT;
 	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, NULL, 0);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		mlx5_core_err(mdev, "fail to add TX ipsec rule err=%d\n", err);
-		goto out;
+		goto err_add_flow;
 	}
 
+	kvfree(spec);
 	sa_entry->ipsec_rule.rule = rule;
+	sa_entry->ipsec_rule.pkt_reformat = flow_act.pkt_reformat;
+	return 0;
 
-out:
+err_add_flow:
+	if (flow_act.pkt_reformat)
+		mlx5_packet_reformat_dealloc(mdev, flow_act.pkt_reformat);
+err_pkt_reformat:
 	kvfree(spec);
-	if (err)
-		tx_ft_put(ipsec);
+err_alloc:
+	tx_ft_put(ipsec);
 	return err;
 }
 
-- 
2.37.2

