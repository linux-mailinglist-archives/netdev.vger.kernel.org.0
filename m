Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6819F6EA11E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbjDUBj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbjDUBjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272D86A64
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A91FF6436C
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864F9C433D2;
        Fri, 21 Apr 2023 01:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041177;
        bh=tt2HFRLiYZp635/TIcdqX5puBNCuv52z+Smo8i/Scv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbxc+17Lm/v1G0GYnpPMhAeaXO6Js/HfRD3KJ3ET0hOBQeCzVPwm9gueWZOHUKVGw
         lW820+coBz8Ruwy9i67Y6C2NkRVdNjg0Em5EXPfJDlEhnLbkW+DSPwKOIMjRejKr3c
         LP/PO3tq3aNDSeaTkwxyG9wPq2lH0T3iu99Ls4cI9KvFIvgZJUtYkPic8PqBPRZRNb
         equJa6gKLBnzqcc3OuQZIHSU5PpyWbZf9IpVGUylHKURbW3mf9Ti8HvWfMRu8pl1NC
         dwB3CVtzArDgdXEK06sVHCe1hd0QGETdOQUncR83No6t05EoI2hTkFZyWl/ZH2V0kT
         XXRLpjKfbe8TA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: RX, Fix releasing page_pool pages twice for striding RQ
Date:   Thu, 20 Apr 2023 18:38:44 -0700
Message-Id: <20230421013850.349646-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

mlx5e_free_rx_descs is responsible for calling the dealloc_wqe op which
returns pages to the page_pool. This can happen during flush or close.
For XSK, the regular RQ is flushed (when replaced by the XSK RQ) and
also closed later. This is normally not a problem as the wqe list is
empty on a second call to mlx5e_free_rx_descs. However, for striding RQ,
the previously released wqes from the list will appear as missing
and will be released a second time by mlx5e_free_rx_missing_descs.

This patch sets the no release bits on the striding RQ wqes in the
dealloc_wqe op to prevent releasing the pages a second time.

Please note that the bits are set only in the control path during
close and not in the data path.

Fixes: 4c2a13236807 ("net/mlx5e: RX, Defer page release in striding rq for better recycling")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a8c2ae389d6c..5dc907541094 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -861,6 +861,11 @@ static void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, ix);
 	/* This function is called on rq/netdev close. */
 	mlx5e_free_rx_mpwqe(rq, wi);
+
+	/* Avoid a second release of the wqe pages: dealloc is called also
+	 * for missing wqes on an already flushed RQ.
+	 */
+	bitmap_fill(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
 }
 
 INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
-- 
2.39.2

