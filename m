Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E896DC37D
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjDJGTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjDJGTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:19:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6469540D7
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 23:19:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0075560FE5
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE85C433D2;
        Mon, 10 Apr 2023 06:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681107578;
        bh=/mTDVzQQG7hE8yUaPMhQIoIub2V2dUmCPjekne3uNUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFshxEBbYOZBBOZxVnCESF1f1Ey75JlWej3h3iLvXCJHm0NDowOizumcT+HYcPZyM
         341bgaIbQk/APQc5e+bf0fUebJEamG0SNbb347ME4tNjUIDdbjo/XNnC+VxgHrn0Td
         ni6I5VELeQ9shZRXd7ElGEWbTbv+KIhJmkI2RZ4RYJd52mNdp2CJ6syRwiL70KXpyj
         0SgadBXXnP7GmNzAUylYp4seKp6cyx1GlEo5WEH8hdqe9wmF5NJ/fdUeWAQRzx7X2X
         QdZhqNoZF8lTmxpDZ621dcvIy4layORRn1JdCWmV2xRmEXjbGTe9Owqq9mzd+A6N/t
         FHLnSqeEqmSLw==
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
Subject: [PATCH net-next 06/10] net/mlx5e: Support IPsec TX packet offload in tunnel mode
Date:   Mon, 10 Apr 2023 09:19:08 +0300
Message-Id: <30dda5afae1ed9ec7c5302cd96f80e4771d0c8a6.1681106636.git.leonro@nvidia.com>
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
index 8ecaf4100b9c..b1f759c378d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -10,6 +10,7 @@
 #include "lib/fs_chains.h"
 
 #define NUM_IPSEC_FTE BIT(15)
+#define IPSEC_TUNNEL_DEFAULT_TTL 0x40
 
 struct mlx5e_ipsec_fc {
 	struct mlx5_fc *cnt;
@@ -849,11 +850,30 @@ setup_pkt_tunnel_reformat(struct mlx5_core_dev *mdev,
 		} __packed;
 		u8 raw[ETH_HLEN];
 	} __packed *mac_hdr;
+	struct ip_esp_hdr *esp_hdr;
+	struct ipv6hdr *ipv6hdr;
+	struct iphdr *iphdr;
 	char *reformatbf;
 	size_t bfflen;
+	void *hdr;
 
 	bfflen = sizeof(*mac_hdr);
 
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
@@ -877,6 +897,38 @@ setup_pkt_tunnel_reformat(struct mlx5_core_dev *mdev,
 	case XFRM_DEV_OFFLOAD_IN:
 		reformat_params->type = MLX5_REFORMAT_TYPE_L3_ESP_TUNNEL_TO_L2;
 		break;
+	case XFRM_DEV_OFFLOAD_OUT:
+		reformat_params->type = MLX5_REFORMAT_TYPE_L2_TO_L3_ESP_TUNNEL;
+		reformat_params->param_0 = attrs->authsize;
+
+		hdr = reformatbf + sizeof(*mac_hdr);
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

