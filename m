Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3CA4DE2E4
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbiCRUye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240809AbiCRUyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9893BE31
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72EC960DC0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE52DC340F0;
        Fri, 18 Mar 2022 20:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636793;
        bh=GcxCSUlc814iFM5sQq1lXA3WDO3U1eqAFBJeKJ3gz40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgsJsujt6DEKT4dDp/dVvAIfrqXNoOaEAOk5Gl4vCFTmMQMS8cMOP6oEtAJ9r0h/Y
         1VqkLg/QxTtYdUG2kgVidZr5hyP1ja1By3ynSv+TZjpBtW69hkUHNr1ntTuxiSd812
         5Vy4tr4uZsrFgVeHWGI9cFg9FqalgUmH6EB1NIxpD1xulyyD0iBq13rKA+0h5CNnAG
         c90ub3/Pn7sqe+t3gEvMH5Zy9ndZAOaL5NBZUh8OGejC87QHXFy+RP03tdYcyJEZXq
         MHEJy+O+HQ/R0Cy5TRC8n0FfYgjI1bUwZncy08l9oejxe5DEON7dTcV7yVMd7ZH1ay
         fctO6AmL1Lq+A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Remove assignment of inline_hdr.sz on XDP TX
Date:   Fri, 18 Mar 2022 13:52:40 -0700
Message-Id: <20220318205248.33367-8-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

When MPWQE is disabled, mlx5e_open_xdpsq prefills the common fields of
WQEs in the XDP SQ to save time when sending packets. One of such fields
is eseg->inline_hdr.sz, which can be either 0 or MLX5E_XDP_MIN_INLINE,
depending on the inline mode of the SQ.

The inline mode can't change during the lifetime of the SQ, so setting
this field again in mlx5e_xmit_xdp_frame is redundant. Moreover, the
xmit function only sets it to MLX5E_XDP_MIN_INLINE, but not to 0 in the
other case.

This commit removes the redundant assignment in mlx5e_xmit_xdp_frame.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index b1114f854057..9478df6c87bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -343,7 +343,6 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 	/* copy the inline part if required */
 	if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE) {
 		memcpy(eseg->inline_hdr.start, xdptxd->data, sizeof(eseg->inline_hdr.start));
-		eseg->inline_hdr.sz = cpu_to_be16(MLX5E_XDP_MIN_INLINE);
 		memcpy(dseg, xdptxd->data + sizeof(eseg->inline_hdr.start),
 		       MLX5E_XDP_MIN_INLINE - sizeof(eseg->inline_hdr.start));
 		dma_len  -= MLX5E_XDP_MIN_INLINE;
-- 
2.35.1

