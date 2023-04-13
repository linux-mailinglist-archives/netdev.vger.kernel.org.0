Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CB66E0D74
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjDMMaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjDMMaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:30:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EDC9755
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 05:30:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92DF563DD4
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7418BC433D2;
        Thu, 13 Apr 2023 12:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681388999;
        bh=o75fQWXxho7trxGhiR6R/L24gY139K9Apf7COG4YfX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ld4hofNzXYwp966RRMegfiuk8Oy4hsmfdEhwer3YPq2hnw08pJ6DLPvzRpmp/cBgo
         ViRM9wTUkhIeuANGqHZ2XtKkM7ik/XnmvcPpfKdQidnwbbn4NJRPPc0ntLtyGQh+HP
         f0lzV3E/DB+WZWjn3yRYAlj/nXFPwwqHpPLo9FcwjfVvHBYnw6x/MnPGo0rC4g6IFc
         XeNcbkTlxHFfNsSX7r7MPzmpC9M9DdA6+HCfFHDF3P1UbYnFNuIlOnOih0ZxSYaah6
         Eu1Tj+pAH3EevWDPDLZtT1/X4uYa49B9CYvRHv3xWNxrfR898Pa9nM5sUH8W9NmPLz
         OKEel7w578yig==
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
Subject: [PATCH net-next v1 06/10] net/mlx5e: Support IPsec TX packet offload in tunnel mode
Date:   Thu, 13 Apr 2023 15:29:24 +0300
Message-Id: <bad0c22f37a3591aa1abed4d8a8e677b92e034f5.1681388425.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681388425.git.leonro@nvidia.com>
References: <cover.1681388425.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Extend mlx5 driver with logic to support IPsec TX packet offload
in tunnel mode.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 12 +++++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 52 +++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7c55b37c1c01..36f3ffd54355 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -271,6 +271,18 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 		neigh_ha_snapshot(addr, n, netdev);
 		ether_addr_copy(attrs->smac, addr);
 		break;
+	case XFRM_DEV_OFFLOAD_OUT:
+		ether_addr_copy(attrs->smac, addr);
+		n = neigh_lookup(&arp_tbl, &attrs->daddr.a4, netdev);
+		if (!n) {
+			n = neigh_create(&arp_tbl, &attrs->daddr.a4, netdev);
+			if (IS_ERR(n))
+				return;
+			neigh_event_send(n, NULL);
+		}
+		neigh_ha_snapshot(addr, n, netdev);
+		ether_addr_copy(attrs->dmac, addr);
+		break;
 	default:
 		return;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 001d7c3add6a..4c800b54d8b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -11,6 +11,7 @@
 
 #define NUM_IPSEC_FTE BIT(15)
 #define MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_SIZE 16
+#define IPSEC_TUNNEL_DEFAULT_TTL 0x40
 
 struct mlx5e_ipsec_fc {
 	struct mlx5_fc *cnt;
@@ -842,12 +843,31 @@ setup_pkt_tunnel_reformat(struct mlx5_core_dev *mdev,
 			  struct mlx5_accel_esp_xfrm_attrs *attrs,
 			  struct mlx5_pkt_reformat_params *reformat_params)
 {
+	struct ip_esp_hdr *esp_hdr;
+	struct ipv6hdr *ipv6hdr;
 	struct ethhdr *eth_hdr;
+	struct iphdr *iphdr;
 	char *reformatbf;
 	size_t bfflen;
+	void *hdr;
 
 	bfflen = sizeof(*eth_hdr);
 
+	if (attrs->dir == XFRM_DEV_OFFLOAD_OUT) {
+		bfflen += sizeof(*esp_hdr) + 8;
+
+		switch (attrs->family) {
+		case AF_INET:
+			bfflen += sizeof(*iphdr);
+			break;
+		case AF_INET6:
+			bfflen += sizeof(*ipv6hdr);
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
 	reformatbf = kzalloc(bfflen, GFP_KERNEL);
 	if (!reformatbf)
 		return -ENOMEM;
@@ -871,6 +891,38 @@ setup_pkt_tunnel_reformat(struct mlx5_core_dev *mdev,
 	case XFRM_DEV_OFFLOAD_IN:
 		reformat_params->type = MLX5_REFORMAT_TYPE_L3_ESP_TUNNEL_TO_L2;
 		break;
+	case XFRM_DEV_OFFLOAD_OUT:
+		reformat_params->type = MLX5_REFORMAT_TYPE_L2_TO_L3_ESP_TUNNEL;
+		reformat_params->param_0 = attrs->authsize;
+
+		hdr = reformatbf + sizeof(*eth_hdr);
+		switch (attrs->family) {
+		case AF_INET:
+			iphdr = (struct iphdr *)hdr;
+			memcpy(&iphdr->saddr, &attrs->saddr.a4, 4);
+			memcpy(&iphdr->daddr, &attrs->daddr.a4, 4);
+			iphdr->version = 4;
+			iphdr->ihl = 5;
+			iphdr->ttl = IPSEC_TUNNEL_DEFAULT_TTL;
+			iphdr->protocol = IPPROTO_ESP;
+			hdr += sizeof(*iphdr);
+			break;
+		case AF_INET6:
+			ipv6hdr = (struct ipv6hdr *)hdr;
+			memcpy(&ipv6hdr->saddr, &attrs->saddr.a6, 16);
+			memcpy(&ipv6hdr->daddr, &attrs->daddr.a6, 16);
+			ipv6hdr->nexthdr = IPPROTO_ESP;
+			ipv6hdr->version = 6;
+			ipv6hdr->hop_limit = IPSEC_TUNNEL_DEFAULT_TTL;
+			hdr += sizeof(*ipv6hdr);
+			break;
+		default:
+			goto free_reformatbf;
+		}
+
+		esp_hdr = (struct ip_esp_hdr *)hdr;
+		esp_hdr->spi = htonl(attrs->spi);
+		break;
 	default:
 		goto free_reformatbf;
 	}
-- 
2.39.2

