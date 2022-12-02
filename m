Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2202640EFE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiLBUPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiLBUPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6CCF2301
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8DEF3CE1FB0
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D599C433D6;
        Fri,  2 Dec 2022 20:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012134;
        bh=4DqiH4CzIeTQtWrJgb9DnNRUEGfBnNIHdnpKgMKaRY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ep+JYkERifpKX3YV4v1oYOGL7lV2zWBFEgyCaCc4IICofgpcMZj9v13grx47piHwi
         QLQEa439us+eA0gkqdn6GRboSSdso/DYznUSimlYvd2tBNpPF2/Mxozi1PvwqXEb9Z
         GyBrATSr5UEOptcZQ55H+X7vKLvn7nVrZ00Rueu2s1Ns0mvrXdm7MtlRhfQf47pX+0
         rVqfzq9/abdp6WegGt184sdJ5faMxQcKB/Q8jH4PkV0t/Yc0SDTOlVRAjN2XIwbOXj
         6Pftt9DA/LNH08eCMx6Wd8UiaWzjUiaRXLRYMf9Bp2OXf9RbbjCKY6/+sx2bnZHKHM
         hrn2KGj7S87gQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 04/13] net/mlx5e: Configure IPsec packet offload flow steering
Date:   Fri,  2 Dec 2022 22:14:48 +0200
Message-Id: <fd9c492becf3b134c5ccce35ed385ee251b76f13.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

In packet offload mode, the HW is responsible to handle ESP headers,
SPI numbers and trailers (ICV) together with different logic for
RX and TX paths.

In order to support packet offload mode, special logic is added
to flow steering rules.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  2 +
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 97 +++++++++++++++++--
 3 files changed, 91 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index b22a31e178cf..65f73a5c29ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -162,6 +162,8 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	memcpy(&aes_gcm->salt, x->aead->alg_key + key_len,
 	       sizeof(aes_gcm->salt));
 
+	attrs->authsize = crypto_aead_authsize(aead) / 4; /* in dwords */
+
 	/* iv len */
 	aes_gcm->icv_len = x->aead->alg_icv_len;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 8d1a0d053eb4..25b865590488 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -76,6 +76,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u8 type : 2;
 	u8 family;
 	u32 replay_window;
+	u32 authsize;
 };
 
 enum mlx5_ipsec_cap {
@@ -127,6 +128,7 @@ struct mlx5e_ipsec_esn_state {
 struct mlx5e_ipsec_rule {
 	struct mlx5_flow_handle *rule;
 	struct mlx5_modify_hdr *modify_hdr;
+	struct mlx5_pkt_reformat *pkt_reformat;
 };
 
 struct mlx5e_ipsec_modify_state_work {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 893c1862e211..dbe35accaebf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -480,6 +480,48 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
 	return 0;
 }
 
+static int setup_pkt_reformat(struct mlx5_core_dev *mdev,
+			      struct mlx5_accel_esp_xfrm_attrs *attrs,
+			      struct mlx5_flow_act *flow_act)
+{
+	enum mlx5_flow_namespace_type ns_type = MLX5_FLOW_NAMESPACE_EGRESS;
+	struct mlx5_pkt_reformat_params reformat_params = {};
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
@@ -516,6 +558,16 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	if (err)
 		goto err_mod_header;
 
+	switch (attrs->type) {
+	case XFRM_DEV_OFFLOAD_PACKET:
+		err = setup_pkt_reformat(mdev, attrs, &flow_act);
+		if (err)
+			goto err_pkt_reformat;
+		break;
+	default:
+		break;
+	}
+
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
@@ -533,9 +585,13 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
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
@@ -562,7 +618,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
 		err = -ENOMEM;
-		goto out;
+		goto err_alloc;
 	}
 
 	if (attrs->family == AF_INET)
@@ -570,29 +626,47 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
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
+	case XFRM_DEV_OFFLOAD_PACKET:
+		err = setup_pkt_reformat(mdev, attrs, &flow_act);
+		if (err)
+			goto err_pkt_reformat;
+		break;
+	default:
+		break;
+	}
 
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW |
-			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT;
+	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW |
+			   MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT;
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
 
@@ -735,6 +809,9 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	mlx5_del_flow_rules(ipsec_rule->rule);
 
+	if (ipsec_rule->pkt_reformat)
+		mlx5_packet_reformat_dealloc(mdev, ipsec_rule->pkt_reformat);
+
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT) {
 		tx_ft_put(sa_entry->ipsec);
 		return;
-- 
2.38.1

