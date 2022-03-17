Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58BD4DCE2A
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237528AbiCQSzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237493AbiCQSzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0DADFDF7
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A36617AE
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5DDC340E9;
        Thu, 17 Mar 2022 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543269;
        bh=L8brqgHgkfE3Vp7CWJ0SL8hKhSo70n894auJIB/S00s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6V0Euu1t+PTJGOInCRU3fyJx9yOOmZQKBvOn30XSBXt4plnXlDMeEdZgs3H4ITgl
         /W9VS+gjyuvBG4JbFGHEAXrpzZG83H/52Jw4hjQKh4R1o85OTCTsLjEOkg0tCQvpj/
         FinI/TY/I5iOZ9os5iDKuFDdz7FXglatw6xmDySFBn4uV26WUVdI4zgaU2FfG2cXel
         ZHpYohiqdRTJHhG0X343Ee4pb6PzCRU1kQhZRyGmxGsWNHLHMHwa0OqlJXtguNA8Xf
         XYXhjk1AsX/xDtBnTpowd25w4JnJ8n1TlSRUNnmEKP7c+mylDgGP3oLtcMk4XcxnZS
         Ylo1IeuNGdhUw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Add headroom only to the first fragment in legacy RQ
Date:   Thu, 17 Mar 2022 11:54:11 -0700
Message-Id: <20220317185424.287982-3-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317185424.287982-1-saeed@kernel.org>
References: <20220317185424.287982-1-saeed@kernel.org>
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

Currently, rq->buff.headroom is applied to all fragments in legacy RQ.
In the linear mode, there is a non-zero headroom, but there is only one
fragment per packet. In the non-linear mode, the headroom is zero.

This commit changes the logic to apply the headroom only to the first
fragment. The current behavior remains the same for both linear and
non-linear modes. However, it allows the next commit to enable headroom
for the non-linear mode, which will be applied only to the first
fragment.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 074a44b281b6..6eda906342c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -373,12 +373,15 @@ static int mlx5e_alloc_rx_wqe(struct mlx5e_rq *rq, struct mlx5e_rx_wqe_cyc *wqe,
 	int i;
 
 	for (i = 0; i < rq->wqe.info.num_frags; i++, frag++) {
+		u16 headroom;
+
 		err = mlx5e_get_rx_frag(rq, frag);
 		if (unlikely(err))
 			goto free_frags;
 
+		headroom = i == 0 ? rq->buff.headroom : 0;
 		wqe->data[i].addr = cpu_to_be64(frag->di->addr +
-						frag->offset + rq->buff.headroom);
+						frag->offset + headroom);
 	}
 
 	return 0;
-- 
2.35.1

