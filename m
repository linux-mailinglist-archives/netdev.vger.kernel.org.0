Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F066BD0FE
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCPNj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjCPNjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:39:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F1FBBB11;
        Thu, 16 Mar 2023 06:39:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B3EDB82147;
        Thu, 16 Mar 2023 13:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C328C433EF;
        Thu, 16 Mar 2023 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678973982;
        bh=Wux+XxEZPB1U92HR/G3eeSmgEcoyPwhkmPSe5qCT320=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwyYsl/g+ZCLLcMZ6rYIsobpSBZRyq/7ql3WmGpjfTOXPtJKauVgUZ8MCQycD+w5i
         zBw0SraaN/OGvJSwQb0jnExhDzPsZUfke7jAax4/ANWooCJ4ktKAvrZayI5LIHa6gs
         sJKJLN+y/PaiOFyD0GjP9lVqN0ZyGa/hhgPeca7UDW0PbrgIRtKS8cJyB5b9HRmrnI
         oHJjYNDQTWOuv3mAmUQk204yD4kC5a500jE6b7MSH5gNXOQwmRKSFqCXkG73YP973N
         BxPbxDfRRcgWrtRq+oorso8LfhKNkVlzvtd1sCqexg7vDFHJl35jSArhMhKc9K2v4D
         7M2Z4+dgJ/r2A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next v1 1/3] net/mlx5: Nullify qp->dbg pointer post destruction
Date:   Thu, 16 Mar 2023 15:39:26 +0200
Message-Id: <62b3e99480984ee18a8e77d9667ef3f06420f1a8.1678973858.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678973858.git.leon@kernel.org>
References: <cover.1678973858.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrisious Haddad <phaddad@nvidia.com>

Nullifying qp->dbg is a preparation for the next patches
from the series in which mlx5_core_destroy_qp() could actually fail,
and then it can be called again which causes a kernel crash, since
qp->dbg was not nullified in previous call.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index bb95b40d25eb..b08b5695ee45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -513,11 +513,11 @@ EXPORT_SYMBOL(mlx5_debug_qp_add);
 
 void mlx5_debug_qp_remove(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp)
 {
-	if (!mlx5_debugfs_root)
+	if (!mlx5_debugfs_root || !qp->dbg)
 		return;
 
-	if (qp->dbg)
-		rem_res_tree(qp->dbg);
+	rem_res_tree(qp->dbg);
+	qp->dbg = NULL;
 }
 EXPORT_SYMBOL(mlx5_debug_qp_remove);
 
-- 
2.39.2

