Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86596E0D71
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjDMM3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjDMM3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:29:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD4A86BA
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 05:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBC2163CA0
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1206C433EF;
        Thu, 13 Apr 2023 12:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681388990;
        bh=CyCZT8zZqTi4EDp0tMkoLLir7r064G+Tkp4IJfyj3J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDlE1/++iS7nhV4pEvdk6HYdOc7YLBGay7niAcLEO7rNIqJgbGAiKiap6ewsZ2OEu
         vnbvKYVescotn2b6jTF7QuhhPJsYdqoiNor5uCD4+iQ4ZJDRonONrVrHL8eX9dMSPP
         tM8KItODGr0CIUOdcSqPlOJPk8joZQektSSLXdQ9F8tE4PgwQLys7wZY+vrhu7KSuq
         KFEnshMYG/ykRDj/AcGfGCgBQiIW17ul4ukgo6/HfHEeaHujFUK6F97O8DDiIAnajU
         bxhN9ve8AU0Yu5ZA99enyEhoeoeAzQ+sGiBUzjlQPFWzjIoRo6Ure9+7xaSDRfYyTT
         TXFK2AiC9S50A==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v1 04/10] net/mlx5e: Prepare IPsec packet reformat code for tunnel mode
Date:   Thu, 13 Apr 2023 15:29:22 +0300
Message-Id: <f9e31cf8ff6a60ea4eb714c93e5fad7fbd56b860.1681388425.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681388425.git.leonro@nvidia.com>
References: <cover.1681388425.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Refactor setup_pkt_reformat() function to accommodate future extension
to support tunnel mode.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  1 +
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 81 ++++++++++++++-----
 3 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index def01bfde610..359da277c03a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -297,6 +297,7 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	attrs->upspec.sport = ntohs(x->sel.sport);
 	attrs->upspec.sport_mask = ntohs(x->sel.sport_mask);
 	attrs->upspec.proto = x->sel.proto;
+	attrs->mode = x->props.mode;
 
 	mlx5e_ipsec_init_limits(sa_entry, attrs);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index bb89e18b17b4..ae525420a492 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -77,7 +77,7 @@ struct mlx5_replay_esn {
 
 struct mlx5_accel_esp_xfrm_attrs {
 	u32   spi;
-	u32   flags;
+	u32   mode;
 	struct aes_gcm_keymat aes_gcm;
 
 	union {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 060be020ca64..6a1ed4114054 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -10,6 +10,7 @@
 #include "lib/fs_chains.h"
 
 #define NUM_IPSEC_FTE BIT(15)
+#define MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_SIZE 16
 
 struct mlx5e_ipsec_fc {
 	struct mlx5_fc *cnt;
@@ -836,40 +837,80 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
 	return 0;
 }
 
+static int
+setup_pkt_transport_reformat(struct mlx5_accel_esp_xfrm_attrs *attrs,
+			     struct mlx5_pkt_reformat_params *reformat_params)
+{
+	u8 *reformatbf;
+	__be32 spi;
+
+	switch (attrs->dir) {
+	case XFRM_DEV_OFFLOAD_IN:
+		reformat_params->type = MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT;
+		break;
+	case XFRM_DEV_OFFLOAD_OUT:
+		if (attrs->family == AF_INET)
+			reformat_params->type =
+				MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4;
+		else
+			reformat_params->type =
+				MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;
+
+		reformatbf = kzalloc(MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_SIZE,
+				     GFP_KERNEL);
+		if (!reformatbf)
+			return -ENOMEM;
+
+		/* convert to network format */
+		spi = htonl(attrs->spi);
+		memcpy(reformatbf, &spi, sizeof(spi));
+
+		reformat_params->param_0 = attrs->authsize;
+		reformat_params->size =
+			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_SIZE;
+		reformat_params->data = reformatbf;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int setup_pkt_reformat(struct mlx5_core_dev *mdev,
 			      struct mlx5_accel_esp_xfrm_attrs *attrs,
 			      struct mlx5_flow_act *flow_act)
 {
-	enum mlx5_flow_namespace_type ns_type = MLX5_FLOW_NAMESPACE_EGRESS;
 	struct mlx5_pkt_reformat_params reformat_params = {};
 	struct mlx5_pkt_reformat *pkt_reformat;
-	u8 reformatbf[16] = {};
-	__be32 spi;
+	enum mlx5_flow_namespace_type ns_type;
+	int ret;
 
-	if (attrs->dir == XFRM_DEV_OFFLOAD_IN) {
-		reformat_params.type = MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT;
+	switch (attrs->dir) {
+	case XFRM_DEV_OFFLOAD_IN:
 		ns_type = MLX5_FLOW_NAMESPACE_KERNEL;
-		goto cmd;
+		break;
+	case XFRM_DEV_OFFLOAD_OUT:
+		ns_type = MLX5_FLOW_NAMESPACE_EGRESS;
+		break;
+	default:
+		return -EINVAL;
 	}
 
-	if (attrs->family == AF_INET)
-		reformat_params.type =
-			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4;
-	else
-		reformat_params.type =
-			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;
-
-	/* convert to network format */
-	spi = htonl(attrs->spi);
-	memcpy(reformatbf, &spi, 4);
+	switch (attrs->mode) {
+	case XFRM_MODE_TRANSPORT:
+		ret = setup_pkt_transport_reformat(attrs, &reformat_params);
+		break;
+	default:
+		ret = -EINVAL;
+	}
 
-	reformat_params.param_0 = attrs->authsize;
-	reformat_params.size = sizeof(reformatbf);
-	reformat_params.data = &reformatbf;
+	if (ret)
+		return ret;
 
-cmd:
 	pkt_reformat =
 		mlx5_packet_reformat_alloc(mdev, &reformat_params, ns_type);
+	kfree(reformat_params.data);
 	if (IS_ERR(pkt_reformat))
 		return PTR_ERR(pkt_reformat);
 
-- 
2.39.2

