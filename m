Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1D55F0FF5
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbiI3Q33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiI3Q32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D75169E54
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A38336235A
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0B9C433D7;
        Fri, 30 Sep 2022 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555367;
        bh=8khpaEk2/C2nA91Ssiljq2ls4zPjfNuufXgWhFCvMgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNueTZNtjltdzZF0wB5swzj/vjtFpFoDQlR57dfz2ctSoQkzB9p+p/360FE4brfRg
         icfSoZv3u3iYUhJYzcCcUUYdGzONid6iFCQFbUy5XtMM1cW+Q8EVKuEL+Wqo7Kdn7q
         yCwBZiAkGb+1haxEsQANER96zqsSTrQZlWiHn/x9tJR4ur1idJEmOhNq3LvCsSC1+V
         XVUDGLqWMNPPARTJBDGRDrSzCBfm7HP6rmwEtMSTWhuu99QNN48qxIgRM0HDOOqPhs
         qn130z0cuh+YJsg1QGW/JSMWt+c4HBbEZ6DBEvFEkE0dU36O6TNYRSENp7M0Np+4R4
         ZSPk+7de/7ypg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 01/16] net/mlx5e: xsk: Use mlx5e_trigger_napi_icosq for XSK wakeup
Date:   Fri, 30 Sep 2022 09:28:48 -0700
Message-Id: <20220930162903.62262-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930162903.62262-1-saeed@kernel.org>
References: <20220930162903.62262-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

mlx5e_xsk_wakeup triggers an IRQ by posting a NOP to async_icosq, taking
a spinlock to protect from concurrent access. There is already a
function that does the same: mlx5e_trigger_napi_icosq. Use this function
in mlx5e_xsk_wakeup.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 4902ef74fedf..1203d7d5f9bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -36,9 +36,7 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 		if (test_and_set_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.state))
 			return 0;
 
-		spin_lock_bh(&c->async_icosq_lock);
-		mlx5e_trigger_irq(&c->async_icosq);
-		spin_unlock_bh(&c->async_icosq_lock);
+		mlx5e_trigger_napi_icosq(c);
 	}
 
 	return 0;
-- 
2.37.3

