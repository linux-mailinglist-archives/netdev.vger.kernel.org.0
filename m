Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD6447D897
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbhLVVMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:12:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54760 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238281AbhLVVML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:12:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 553C5B81E6E
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 21:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C388FC36AF2;
        Wed, 22 Dec 2021 21:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640207529;
        bh=aamdlyEqjULudsqkUOXkmLTEF3GxGZa91++5bATsdn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CICd3tIVRuB4C4LHh4ZKPHKSerj1O1L6OJPS7HlEscTw01PT2+Mhv0pnorKD7g6wZ
         Hr/qhXrurz4VJ+Mh8xNT5ASOMFzW7oFSe1AJzTlnvsH55DZxzBfen7M9JPHsqs97uP
         A1eo+HuC4CtKnYxSzb/14KWX7IvglUQcJwCfcudiY2UCCuNhmNOgELutNOUXeCHsLR
         A011XQxv9PbKl8G+zqd1tpYdNBrX3O8uOEFtjoWQ1tfIYr3ihF/c7v96BdrVgPbGmt
         FsC6wlenIE67wYRyHosgS7KvrQrDQwpBsdhHpV2VHYQXfDr8SvEJNNSzFn7JT28I8d
         PWUC+LoCCxYVg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/11] net/mlx5e: Fix skb memory leak when TC classifier action offloads are disabled
Date:   Wed, 22 Dec 2021 13:11:58 -0800
Message-Id: <20211222211201.77469-9-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222211201.77469-1-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

When TC classifier action offloads are disabled (CONFIG_MLX5_CLS_ACT in
Kconfig), the mlx5e_rep_tc_receive() function which is responsible for
passing the skb to the stack (or freeing it) is defined as a nop, and
results in leaking the skb memory. Replace the nop with a call to
napi_gro_receive() to resolve the leak.

Fixes: 28e7606fa8f1 ("net/mlx5e: Refactor rx handler of represetor device")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
index d6c7c81690eb..7c9dd3a75f8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
@@ -66,7 +66,7 @@ mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 static inline void
 mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
-		     struct sk_buff *skb) {}
+		     struct sk_buff *skb) { napi_gro_receive(rq->cq.napi, skb); }
 
 #endif /* CONFIG_MLX5_CLS_ACT */
 
-- 
2.33.1

