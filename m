Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F157D6D364D
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 10:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjDBIcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 04:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDBIcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 04:32:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A641B35D
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 01:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680424203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X2qMh1719XPTmN3fL+GQW8KuUqpmNliiESfRG6QrFt4=;
        b=JcFM46WfTxENRV7jDGEgUygBqhuNuHhaWmzNhsOzLhO7+ktkkfLUO9RLR9XsWjGYEpdBbM
        MhTTre5LYEvPgOCqwODrS5dSXsrQdOC8owu+pGnHObcKR3abvKHv1RyIzLQxQnlcImjqy/
        XbOGSTcNQTbAi/LoL74NnaTV4aKyc0c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-nGHAPBa7MTGybiLRF4_0rg-1; Sun, 02 Apr 2023 04:30:00 -0400
X-MC-Unique: nGHAPBa7MTGybiLRF4_0rg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C5C229ABA07;
        Sun,  2 Apr 2023 08:29:59 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 528AA1400E6D;
        Sun,  2 Apr 2023 08:29:59 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 6888B30736C72;
        Sun,  2 Apr 2023 10:29:58 +0200 (CEST)
Subject: [PATCH bpf V6 4/5] mlx4: bpf_xdp_metadata_rx_hash add xdp rss hash
 type
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, linux-rdma@vger.kernel.org
Date:   Sun, 02 Apr 2023 10:29:58 +0200
Message-ID: <168042419838.4051476.9203995216212009644.stgit@firesoul>
In-Reply-To: <168042409059.4051476.8176861613304493950.stgit@firesoul>
References: <168042409059.4051476.8176861613304493950.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update API for bpf_xdp_metadata_rx_hash() with arg for xdp rss hash type
via matching indiviual Completion Queue Entry (CQE) status bits.

Fixes: ab46182d0dcb ("net/mlx4_en: Support RX XDP metadata")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c   |   19 ++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |    3 ++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 73d10aa4c503..332472fe4990 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -685,11 +685,28 @@ int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
 			enum xdp_rss_hash_type *rss_type)
 {
 	struct mlx4_en_xdp_buff *_ctx = (void *)ctx;
+	struct mlx4_cqe *cqe = _ctx->cqe;
+	enum xdp_rss_hash_type xht = 0;
+	__be16 status;
 
 	if (unlikely(!(_ctx->dev->features & NETIF_F_RXHASH)))
 		return -ENODATA;
 
-	*hash = be32_to_cpu(_ctx->cqe->immed_rss_invalid);
+	*hash = be32_to_cpu(cqe->immed_rss_invalid);
+	status = cqe->status;
+	if (status & cpu_to_be16(MLX4_CQE_STATUS_TCP))
+		xht = XDP_RSS_L4_TCP;
+	if (status & cpu_to_be16(MLX4_CQE_STATUS_UDP))
+		xht = XDP_RSS_L4_UDP;
+	if (status & cpu_to_be16(MLX4_CQE_STATUS_IPV4 | MLX4_CQE_STATUS_IPV4F))
+		xht |= XDP_RSS_L3_IPV4;
+	if (status & cpu_to_be16(MLX4_CQE_STATUS_IPV6)) {
+		xht |= XDP_RSS_L3_IPV6;
+		if (cqe->ipv6_ext_mask)
+			xht |= XDP_RSS_L3_DYNHDR;
+	}
+	*rss_type = xht;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 544e09b97483..4ac4d883047b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -798,7 +798,8 @@ int mlx4_en_netdev_event(struct notifier_block *this,
 
 struct xdp_md;
 int mlx4_en_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp);
-int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash);
+int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
+			enum xdp_rss_hash_type *rss_type);
 
 /*
  * Functions for time stamping


