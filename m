Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822CE69BAC0
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBRPe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 10:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBRPe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 10:34:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E1616ACB
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 07:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676734447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FqonhcsRGF6G8XrHZRMJ1BoKNDgNdFT99O2RJUO6t4Y=;
        b=AVty4A+5WFSn8SF9hU1/M6Z9NVM5h9fryw5gXhVdgIdqZC3OkoVh95g8aSA3Zr+hAJVEtL
        RZtp2xgM+Mz5YByyXVUFUe8zJYn27r+oFuq0VUyVxdih9lfNBXFkE6u2wxrAEqRlo9av4v
        7TdTspPaQYzR4Gu2yAG5gKubyeQJfsw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-YYB29ZiIN1Kz8EDc6ZRKlQ-1; Sat, 18 Feb 2023 10:34:03 -0500
X-MC-Unique: YYB29ZiIN1Kz8EDc6ZRKlQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF72B1C04B7C;
        Sat, 18 Feb 2023 15:34:02 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-25.brq.redhat.com [10.40.208.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 563802026D4B;
        Sat, 18 Feb 2023 15:34:02 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 0BB6230018F8B;
        Sat, 18 Feb 2023 16:34:01 +0100 (CET)
Subject: [PATCH bpf-next V3] xdp: bpf_xdp_metadata use EOPNOTSUPP for no
 driver support
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net
Date:   Sat, 18 Feb 2023 16:34:00 +0100
Message-ID: <167673444093.2179692.14745621008776172374.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When driver doesn't implement a bpf_xdp_metadata kfunc the default
implementation returns EOPNOTSUPP, which indicate device driver doesn't
implement this kfunc.

Currently many drivers also return EOPNOTSUPP when the hint isn't
available. Instead change drivers to return ENODATA in these cases.
There can be natural cases why a driver doesn't provide any hardware
info for a specific hint, even on a frame to frame basis (e.g. PTP).
Lets keep these cases as separate return codes.

When describing the return values, adjust the function kernel-doc layout
to get proper rendering for the return values.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 Documentation/networking/xdp-rx-metadata.rst     |    7 +++++--
 drivers/net/ethernet/mellanox/mlx4/en_rx.c       |    4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |    4 ++--
 drivers/net/veth.c                               |    4 ++--
 net/core/xdp.c                                   |   10 ++++++++--
 5 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
index aac63fc2d08b..25ce72af81c2 100644
--- a/Documentation/networking/xdp-rx-metadata.rst
+++ b/Documentation/networking/xdp-rx-metadata.rst
@@ -23,10 +23,13 @@ metadata is supported, this set will grow:
 An XDP program can use these kfuncs to read the metadata into stack
 variables for its own consumption. Or, to pass the metadata on to other
 consumers, an XDP program can store it into the metadata area carried
-ahead of the packet.
+ahead of the packet. Not all packets will necessary have the requested
+metadata available in which case the driver returns ``-ENODATA``.
 
 Not all kfuncs have to be implemented by the device driver; when not
-implemented, the default ones that return ``-EOPNOTSUPP`` will be used.
+implemented, the default ones that return ``-EOPNOTSUPP`` will be used
+to indicate the device driver have not implemented this kfunc.
+
 
 Within an XDP frame, the metadata layout (accessed via ``xdp_buff``) is
 as follows::
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 0869d4fff17b..4b5e459b6d49 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -674,7 +674,7 @@ int mlx4_en_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
 	struct mlx4_en_xdp_buff *_ctx = (void *)ctx;
 
 	if (unlikely(_ctx->ring->hwtstamp_rx_filter != HWTSTAMP_FILTER_ALL))
-		return -EOPNOTSUPP;
+		return -ENODATA;
 
 	*timestamp = mlx4_en_get_hwtstamp(_ctx->mdev,
 					  mlx4_en_get_cqe_ts(_ctx->cqe));
@@ -686,7 +686,7 @@ int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
 	struct mlx4_en_xdp_buff *_ctx = (void *)ctx;
 
 	if (unlikely(!(_ctx->dev->features & NETIF_F_RXHASH)))
-		return -EOPNOTSUPP;
+		return -ENODATA;
 
 	*hash = be32_to_cpu(_ctx->cqe->immed_rss_invalid);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f7d52b1d293b..32c444c01906 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -161,7 +161,7 @@ static int mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
 	const struct mlx5e_xdp_buff *_ctx = (void *)ctx;
 
 	if (unlikely(!mlx5e_rx_hw_stamp(_ctx->rq->tstamp)))
-		return -EOPNOTSUPP;
+		return -ENODATA;
 
 	*timestamp =  mlx5e_cqe_ts_to_ns(_ctx->rq->ptp_cyc2time,
 					 _ctx->rq->clock, get_cqe_ts(_ctx->cqe));
@@ -173,7 +173,7 @@ static int mlx5e_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
 	const struct mlx5e_xdp_buff *_ctx = (void *)ctx;
 
 	if (unlikely(!(_ctx->xdp.rxq->dev->features & NETIF_F_RXHASH)))
-		return -EOPNOTSUPP;
+		return -ENODATA;
 
 	*hash = be32_to_cpu(_ctx->cqe->rss_hash_result);
 	return 0;
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 1bb54de7124d..046461ee42ea 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1610,7 +1610,7 @@ static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
 	struct veth_xdp_buff *_ctx = (void *)ctx;
 
 	if (!_ctx->skb)
-		return -EOPNOTSUPP;
+		return -ENODATA;
 
 	*timestamp = skb_hwtstamps(_ctx->skb)->hwtstamp;
 	return 0;
@@ -1621,7 +1621,7 @@ static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
 	struct veth_xdp_buff *_ctx = (void *)ctx;
 
 	if (!_ctx->skb)
-		return -EOPNOTSUPP;
+		return -ENODATA;
 
 	*hash = skb_get_hash(_ctx->skb);
 	return 0;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 26483935b7a4..b71fe21b5c3e 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -721,7 +721,10 @@ __diag_ignore_all("-Wmissing-prototypes",
  * @ctx: XDP context pointer.
  * @timestamp: Return value pointer.
  *
- * Returns 0 on success or ``-errno`` on error.
+ * Return:
+ * * Returns 0 on success or ``-errno`` on error.
+ * * ``-EOPNOTSUPP`` : means device driver does not implement kfunc
+ * * ``-ENODATA``    : means no RX-timestamp available for this frame
  */
 __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
 {
@@ -733,7 +736,10 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
  * @ctx: XDP context pointer.
  * @hash: Return value pointer.
  *
- * Returns 0 on success or ``-errno`` on error.
+ * Return:
+ *  * Returns 0 on success or ``-errno`` on error.
+ *  * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
+ *  * ``-ENODATA``    : means no RX-hash available for this frame
  */
 __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
 {


