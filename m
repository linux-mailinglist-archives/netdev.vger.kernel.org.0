Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27F469B8E8
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 10:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjBRJFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 04:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjBRJFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 04:05:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFADD4C3CB
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:05:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51031B80185
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32AEC4339B;
        Sat, 18 Feb 2023 09:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676711132;
        bh=x++jBRaTZGnOQ9PO88b3zGVLWstLbzQWIwb07kKF37k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qm9VAJ2D0sSCs6fvcpKS4viSi0CHatdKIjSPBOFJXJPtx99PpQS4P/lav2CouBhBa
         zyBU3qnKLFneNENapAPEOMpOBvAEyLC/uGQpfYkEhAuHPMLL3J3fwVrIedr8Hw0tIZ
         kBoi8+AQGH9wl3Yvl92uxfG9/cC5CXv5DItCS0dLSo+H8vSvScH2/+T0fkG8i1e45x
         YX2OkwhqrCMTHIKmnZT1p2ttbnmxuiGVTn8Ae+sRvUccSlJhZM+nrMUOJy+3dLc3eY
         Pz7dJe22Sd5RI396ANsvVLanUSMYZEsj/frhEO7xpGHTApDKGsI7B2Ja8Rk4KKUMr2
         YN8Q4Q3ATj+fA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [net-next V2 9/9] net/mlx5e: RX, Remove doubtful unlikely call
Date:   Sat, 18 Feb 2023 01:05:13 -0800
Message-Id: <20230218090513.284718-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230218090513.284718-1-saeed@kernel.org>
References: <20230218090513.284718-1-saeed@kernel.org>
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

From: Gal Pressman <gal@nvidia.com>

When building an skb in non-linear mode, it is not likely nor unlikely
that the xdp buff has fragments, it depends on the size of the packet
received.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 8e64f4b48d53..15d9932f741d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1718,7 +1718,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 
 	page_ref_inc(head_wi->au->page);
 
-	if (unlikely(xdp_buff_has_frags(&mxbuf.xdp))) {
+	if (xdp_buff_has_frags(&mxbuf.xdp)) {
 		int i;
 
 		/* sinfo->nr_frags is reset by build_skb, calculate again. */
-- 
2.39.1

