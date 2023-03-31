Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C636D2859
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 20:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbjCaS4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 14:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbjCaS40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 14:56:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168FE23FD7
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 11:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680288930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X2qMh1719XPTmN3fL+GQW8KuUqpmNliiESfRG6QrFt4=;
        b=OBcXoXXGMRvcDU1h6w0TZCHM4Z689m+gJOo7ud3RGbWE6mA6FDjTHhTBLx3Gge+eD0OeL4
        iFSLZYgq6XVN6IfFanhPgE5DNIY5VN2YFlnpbmEfPQ1FRJ1MQCBPDGvzSqk0RfJovJeYzY
        K0p39a1f8tDd6pgIy4C9HunCsyOME9c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-v4-GH0L9OTuxc76d_jjTmQ-1; Fri, 31 Mar 2023 14:55:23 -0400
X-MC-Unique: v4-GH0L9OTuxc76d_jjTmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F445185A78F;
        Fri, 31 Mar 2023 18:55:20 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F38472166B33;
        Fri, 31 Mar 2023 18:55:19 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 4360E30736C72;
        Fri, 31 Mar 2023 20:55:19 +0200 (CEST)
Subject: [PATCH bpf V5 4/5] mlx4: bpf_xdp_metadata_rx_hash add xdp rss hash
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
        davem@davemloft.net, tariqt@nvidia.com
Date:   Fri, 31 Mar 2023 20:55:19 +0200
Message-ID: <168028891923.4030852.4939492113139299611.stgit@firesoul>
In-Reply-To: <168028882260.4030852.1100965689789226162.stgit@firesoul>
References: <168028882260.4030852.1100965689789226162.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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


