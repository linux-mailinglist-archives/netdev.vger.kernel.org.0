Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E5F6CEF73
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjC2Qag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjC2QaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:30:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A4F5B9F
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 09:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680107368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R04Vq+TEHO0b9S0yy8Ip00yZxPQlDgdJbbW0Gf6DdUk=;
        b=YyvZcTzRizcMH3cwfMxCh+itp9uHZlmXMXnMzheyAXi20ARWfzbZmxmABOSXmQQQpIJnom
        kSfyCxAWO018DESSfzv9lDRFpjxYpmN5gfjRuMWpnZNCgOUPAMZyG4Bb67oVSHmhRcgsVe
        X51xxvGuy7ulFeek0QpPiIQR4sLvP40=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-58AnzNzGPmqO-eeEuGEBpA-1; Wed, 29 Mar 2023 12:29:25 -0400
X-MC-Unique: 58AnzNzGPmqO-eeEuGEBpA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D546885622;
        Wed, 29 Mar 2023 16:29:24 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60F541121330;
        Wed, 29 Mar 2023 16:29:24 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 8349430736C72;
        Wed, 29 Mar 2023 18:29:23 +0200 (CEST)
Subject: [PATCH bpf RFC-V2 5/5] mlx4: bpf_xdp_metadata_rx_hash return xdp rss
 hash type
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Date:   Wed, 29 Mar 2023 18:29:23 +0200
Message-ID: <168010736349.3039990.15736472596192726923.stgit@firesoul>
In-Reply-To: <168010726310.3039990.2753040700813178259.stgit@firesoul>
References: <168010726310.3039990.2753040700813178259.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update API for bpf_xdp_metadata_rx_hash() by returning xdp rss hash type
via matching indiviual Completion Queue Entry (CQE) status bits.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 4b5e459b6d49..f3b7351daa05 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -684,12 +684,28 @@ int mlx4_en_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
 int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
 {
 	struct mlx4_en_xdp_buff *_ctx = (void *)ctx;
+	struct mlx4_cqe *cqe = _ctx->cqe;
+	enum xdp_rss_hash_type xht = 0;
+	__be16 status;
 
 	if (unlikely(!(_ctx->dev->features & NETIF_F_RXHASH)))
 		return -ENODATA;
 
-	*hash = be32_to_cpu(_ctx->cqe->immed_rss_invalid);
-	return 0;
+	status = cqe->status;
+	if (status & cpu_to_be16(MLX4_CQE_STATUS_TCP))
+		xht = XDP_RSS_L4_TCP;
+	if (status & cpu_to_be16(MLX4_CQE_STATUS_UDP))
+		xht = XDP_RSS_L4_UDP;
+	if (status & cpu_to_be16(MLX4_CQE_STATUS_IPV4|MLX4_CQE_STATUS_IPV4F))
+		xht |= XDP_RSS_L3_IPV4;
+	if (status & cpu_to_be16(MLX4_CQE_STATUS_IPV6)) {
+		xht |= XDP_RSS_L3_IPV6;
+		if (cqe->ipv6_ext_mask)
+			xht |= XDP_RSS_BIT_EX;
+	}
+
+	*hash = be32_to_cpu(cqe->immed_rss_invalid);
+	return xht;
 }
 
 int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)


