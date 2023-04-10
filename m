Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CD06DC37F
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDJGTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjDJGTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8B84231
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 23:19:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 063E260FE5
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D92C433D2;
        Mon, 10 Apr 2023 06:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681107586;
        bh=yI77GI5MaI15nTTXEyPBdDoVh1YASn9TUOn/B5ESLRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqDKDGdNwogH1lAOfhhbB4Et7KzY/5jfb1fBASpyexNnCQTad2gTsJaQtWerTi86I
         0rkjsqsBXNez+yVVewczcowjZW6sETFr2x4dFyKfvL54d7dQXplgan7o+xpB8MriHF
         HsLH7/3oZ9QAmveBp/x/Czo9KdXMgyGQT9r5ZqyipHbl7CVxCG4vjwnnQOv2Zb42iG
         HEQywpSByPQKR95ZAt4onTLLgTVBdn3PUmDPTeWFrVaSP/8+cMShRhkAULW6A3/9X/
         QNTRxwbgPa3zqEJ1vyRCao3Jw/KkdhtZaIUm4CpzTUxZr2fl4m050epnyBRaGkfs9h
         xUXlD04DGAtZQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 05/10] net/mlx5e: Support IPsec RX packet offload in tunnel mode
Date:   Mon, 10 Apr 2023 09:19:07 +0300
Message-Id: <255b601d3652bb8c770571ed3e683f695614923f.1681106636.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681106636.git.leonro@nvidia.com>
References: <cover.1681106636.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Extend mlx5 driver with logic to support IPsec RX packet offload
in tunnel mode.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 36 ++++++++++++
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 57 +++++++++++++++++++
 3 files changed, 95 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 359da277c03a..7c55b37c1c01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -242,6 +242,41 @@ static void mlx5e_ipsec_init_limits(struct mlx5e_ipsec_sa_entry *sa_entry,
 	attrs->lft.numb_rounds_soft = (u64)n;
 }
 
+static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
+				  struct mlx5_accel_esp_xfrm_attrs *attrs)
+{
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+	struct xfrm_state *x = sa_entry->x;
+	struct net_device *netdev;
+	struct neighbour *n;
+	u8 addr[ETH_ALEN];
+
+	if (attrs->mode != XFRM_MODE_TUNNEL &&
+	    attrs->type != XFRM_DEV_OFFLOAD_PACKET)
+		return;
+
+	netdev = x->xso.real_dev;
+
+	mlx5_query_mac_address(mdev, addr);
+	switch (attrs->dir) {
+	case XFRM_DEV_OFFLOAD_IN:
+		ether_addr_copy(attrs->dmac, addr);
+		n = neigh_lookup(&arp_tbl, &attrs->saddr.a4, netdev);
+		if (!n) {
+			n = neigh_create(&arp_tbl, &attrs->saddr.a4, netdev);
+			if (IS_ERR(n))
+				return;
+			neigh_event_send(n, NULL);
+		}
+		neigh_ha_snapshot(addr, n, netdev);
+		ether_addr_copy(attrs->smac, addr);
+		break;
+	default:
+		return;
+	}
+	neigh_release(n);
+}
+
 void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 					struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
@@ -300,6 +335,7 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	attrs->mode = x->props.mode;
 
 	mlx5e_ipsec_init_limits(sa_entry, attrs);
+	mlx5e_ipsec_init_macs(sa_entry, attrs);
 }
 
 static int mlx5e_xfrm_validate_state(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index ae525420a492..77384ffa4451 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -99,6 +99,8 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u32 authsize;
 	u32 reqid;
 	struct mlx5_ipsec_lft lft;
+	u8 smac[ETH_ALEN];
+	u8 dmac[ETH_ALEN];
 };
 
 enum mlx5_ipsec_cap {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 980583fb1e52..8ecaf4100b9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -836,6 +836,60 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
 	return 0;
 }
 
+static int
+setup_pkt_tunnel_reformat(struct mlx5_core_dev *mdev,
+			  struct mlx5_accel_esp_xfrm_attrs *attrs,
+			  struct mlx5_pkt_reformat_params *reformat_params)
+{
+	union {
+		struct {
+			u8 dmac[6];
+			u8 smac[6];
+			__be16 ethertype;
+		} __packed;
+		u8 raw[ETH_HLEN];
+	} __packed *mac_hdr;
+	char *reformatbf;
+	size_t bfflen;
+
+	bfflen = sizeof(*mac_hdr);
+
+	reformatbf = kzalloc(bfflen, GFP_KERNEL);
+	if (!reformatbf)
+		return -ENOMEM;
+
+	mac_hdr = (void *)reformatbf;
+	switch (attrs->family) {
+	case AF_INET:
+		mac_hdr->ethertype = htons(ETH_P_IP);
+		break;
+	case AF_INET6:
+		mac_hdr->ethertype = htons(ETH_P_IPV6);
+		break;
+	default:
+		goto free_reformatbf;
+	}
+
+	ether_addr_copy(mac_hdr->dmac, attrs->dmac);
+	ether_addr_copy(mac_hdr->smac, attrs->smac);
+
+	switch (attrs->dir) {
+	case XFRM_DEV_OFFLOAD_IN:
+		reformat_params->type = MLX5_REFORMAT_TYPE_L3_ESP_TUNNEL_TO_L2;
+		break;
+	default:
+		goto free_reformatbf;
+	}
+
+	reformat_params->size = bfflen;
+	reformat_params->data = reformatbf;
+	return 0;
+
+free_reformatbf:
+	kfree(reformatbf);
+	return -EINVAL;
+}
+
 static int
 setup_pkt_transport_reformat(struct mlx5_accel_esp_xfrm_attrs *attrs,
 			     struct mlx5_pkt_reformat_params *reformat_params)
@@ -898,6 +952,9 @@ static int setup_pkt_reformat(struct mlx5_core_dev *mdev,
 	case XFRM_MODE_TRANSPORT:
 		ret = setup_pkt_transport_reformat(attrs, &reformat_params);
 		break;
+	case XFRM_MODE_TUNNEL:
+		ret = setup_pkt_tunnel_reformat(mdev, attrs, &reformat_params);
+		break;
 	default:
 		ret = -EINVAL;
 	}
-- 
2.39.2

