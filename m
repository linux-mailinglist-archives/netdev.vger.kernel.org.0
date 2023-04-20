Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D6A6E87B4
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjDTB6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjDTB6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:58:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E305119
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:58:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED7476445E
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD4DC433D2;
        Thu, 20 Apr 2023 01:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681955884;
        bh=DdoJTMWNANHAZa+omh8su4PBjKCr4a1xPG4fOlBsxIc=;
        h=From:To:Cc:Subject:Date:From;
        b=W0r/Wta2mifbP3XBhxbA/ju5Yq1AwTBiWp3SFUD4BV/OOMtOPCsiGo9qy5wT/OdTq
         mmuPlLk6G8jcekzeeuCbk0FQWWds2ACttbjktHUgFxG/CQEJmwiSr84zW6JMAqsuVq
         cfeageeIZ2hD1T47DIkWjfpTJ5zp/UoJfHVhXVynbwvp9L9HX3bFMF6rmx1/F/zg3h
         3NKFE0PlaUFItVi7GzSQH3nmqHM7pP/sqR3/lj+RbiEgpdrrlt4LZlMI5e/CeyNqCk
         x3vfvZt6Mg3+e0yMzlLgSnFsxXu0Tr65SzKx/nrAQF/UCu/I7UHnwI6xSh+GQT+Irh
         Uni/ZKYbIBZCA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, saeedm@nvidia.com,
        leon@kernel.org
Subject: [PATCH net-next] eth: mlx5: avoid iterator use outside of a loop
Date:   Wed, 19 Apr 2023 18:58:02 -0700
Message-Id: <20230420015802.815362-1-kuba@kernel.org>
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
v2:
 - return NULL rather than 0
v1: https://lore.kernel.org/all/20230416101753.GB15386@unreal/

CC: saeedm@nvidia.com
CC: leon@kernel.org
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index eb41f0abf798..1c35d721a31d 100644
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
+	return NULL;
 }
 EXPORT_SYMBOL(mlx5_comp_irq_get_affinity_mask);
 
-- 
2.39.2

