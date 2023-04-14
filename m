Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7272B6E29CD
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 20:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjDNSHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 14:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDNSHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 14:07:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56F449CB
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 11:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED7C561267
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 18:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129C5C433EF;
        Fri, 14 Apr 2023 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681495651;
        bh=+fBL4DqR+bBvC7BJn4uGLWgu1FwbVj69xGVTWwTrwGA=;
        h=From:To:Cc:Subject:Date:From;
        b=Xh+QFRUi8VXLJU+T8wj4MAMYEVB9w/UPpfOUV9JMTALCfanlKE5f668jX7qwX5BfD
         nbgChKcwTMhHQfemQ2A55gvvN8qc1sV2afS/+lPo1tJ7j4Fa0FUAByFxkusiOq51Wu
         9WAudrQT+lp1OX7sjNPVjX2ipnDsKplkM/VX8VZ063hbE8+fIlt9xuyn30AeEhILZ9
         f03ybxQ7Wg41NTofnKTbyMVwXqIIHnVPFvhFtq/GOsSwxi6lPSgczu0j2ns+JbykAv
         lLIY8E3AaPelQ6u6ELDFY+h9APMRprm6Q13DVC/dKUhOTG9XU39CXjJHgHOUG9So9h
         UIzej0m3IZMZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, saeedm@nvidia.com,
        leon@kernel.org
Subject: [PATCH net-next] eth: mlx5: avoid iterator use outside of a loop
Date:   Fri, 14 Apr 2023 11:07:29 -0700
Message-Id: <20230414180729.198284-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
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

Fix the following warning about risky iterator use:

drivers/net/ethernet/mellanox/mlx5/core/eq.c:1010 mlx5_comp_irq_get_affinity_mask() warn: iterator used outside loop: 'eq'

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: saeedm@nvidia.com
CC: leon@kernel.org
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index eb41f0abf798..03c0165a8fd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -1070,10 +1070,11 @@ mlx5_comp_irq_get_affinity_mask(struct mlx5_core_dev *dev, int vector)
 
 	list_for_each_entry(eq, &table->comp_eqs_list, list) {
 		if (i++ == vector)
-			break;
+			return mlx5_irq_get_affinity_mask(eq->core.irq);
 	}
 
-	return mlx5_irq_get_affinity_mask(eq->core.irq);
+	WARN_ON_ONCE(1);
+	return 0;
 }
 EXPORT_SYMBOL(mlx5_comp_irq_get_affinity_mask);
 
-- 
2.39.2

