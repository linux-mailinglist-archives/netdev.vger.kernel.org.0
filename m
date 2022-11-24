Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C9463735D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiKXIK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKXIK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:10:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A56DD237B
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CAE4B82702
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E130C433D6;
        Thu, 24 Nov 2022 08:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277452;
        bh=3f8fndgLmasITe1SMPpLKpWffyTkNIlemeku0xm+LPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2FzrUSYJ1A96GrLE6GDqJl6uN/l6Ahn3wlAGR51sHnTeKk+4tk9Ke8zgW31Ni+x4
         aRlf3WLWGKAdngnR6CBV1xJBhCpUEAq05Xqv3LPpHqVgiZ9UBeoCOzquDRgzM/b2q9
         XDnZ5SI2qz2XB087XQzTOZdBeF6CFYb3q4IvxK1PEdz7gvuB1U90Gb4jn/bJrNtDx9
         Mete51tafybDFqv2Qos/Ngi44JNlUYaoVICCg4tkcp0I8iF6WpMo9R3RCHWNVK+G/i
         rV8GtA5e7HoeiL5phZoNztokd6P3ehjx1U+esqlDAE20sGfrQqSiC4NRXrYaYzSDy8
         Gr8E0jYfMLZXg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        YueHaibing <yuehaibing@huawei.com>, Roi Dayan <roid@nvidia.com>
Subject: [net 01/15] net/mlx5: DR, Fix uninitialized var warning
Date:   Thu, 24 Nov 2022 00:10:26 -0800
Message-Id: <20221124081040.171790-2-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124081040.171790-1-saeed@kernel.org>
References: <20221124081040.171790-1-saeed@kernel.org>
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

From: YueHaibing <yuehaibing@huawei.com>

Smatch warns this:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c:81
 mlx5dr_table_set_miss_action() error: uninitialized symbol 'ret'.

Initializing ret with -EOPNOTSUPP and fix missing action case.

Fixes: 7838e1725394 ("net/mlx5: DR, Expose steering table functionality")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 31d443dd8386..f68461b13391 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -46,7 +46,7 @@ static int dr_table_set_miss_action_nic(struct mlx5dr_domain *dmn,
 int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 				 struct mlx5dr_action *action)
 {
-	int ret;
+	int ret = -EOPNOTSUPP;
 
 	if (action && action->action_type != DR_ACTION_TYP_FT)
 		return -EOPNOTSUPP;
@@ -67,6 +67,9 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 			goto out;
 	}
 
+	if (ret)
+		goto out;
+
 	/* Release old action */
 	if (tbl->miss_action)
 		refcount_dec(&tbl->miss_action->refcount);
-- 
2.38.1

