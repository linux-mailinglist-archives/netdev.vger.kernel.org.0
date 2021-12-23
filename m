Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD9447E7E9
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349922AbhLWTFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:05:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37684 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349919AbhLWTEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE04D61F69
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B2BC36AEA;
        Thu, 23 Dec 2021 19:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286290;
        bh=aamdlyEqjULudsqkUOXkmLTEF3GxGZa91++5bATsdn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDe47wK79F4ywf18qInQlRQR36U1sBmmyRGWahem1QaL89npXs5tp++3aNQNY28II
         8U4sqg2o8XgL3/adBIzCGApHl7TAixXX18XB6rV3d8ijWuCCF0xL3ovcU36H3TkJxB
         gncH4KTQOCGVVYjwv8SuVEyZh4O503sx2/zT495JlkzsoeG1dH8obCde8DrUrQZlcb
         wmsV8ePONQ94KaNLI5KkoAbEf1y6B1HaY86huibqh+RqNpjnuFIf17CVkj/dswsmWn
         9tUS+qGn9o5rORTZSSKf3SrC9dy3e7f0W1cBK5TJtJq+87Jv1ogqeX7Gd458sYcnT2
         O139pCdsL6g2Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 08/12] net/mlx5e: Fix skb memory leak when TC classifier action offloads are disabled
Date:   Thu, 23 Dec 2021 11:04:37 -0800
Message-Id: <20211223190441.153012-9-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223190441.153012-1-saeed@kernel.org>
References: <20211223190441.153012-1-saeed@kernel.org>
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

