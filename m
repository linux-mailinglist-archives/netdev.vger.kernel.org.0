Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF9759C97A
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiHVUBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbiHVT7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24744F183
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93743B818BC
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAA0C433D6;
        Mon, 22 Aug 2022 19:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198380;
        bh=XSFkR3FGXT9WJQ8s+XvFV48zhCowUdvyg/afXYDK2go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAB/Ez1uNC9O+WbGdkVqHBQ3vicurBj8Q7JmWzVs00eeh4w/oH9bl0EWoOHIGrulB
         9MpPKbmzbWPDWiE4OKyk2xaTUgQCtZ2VnMK7oVOQB0qLsVfeUlSFFNn8Y7sa12d63+
         PpbuMW+W2uHIBd9Svc9Sbn8sPRu2SZAraJ1093D6a0i97NpadLzESFshoOQQ47F3EM
         ZM3KAK2zIVRerzpqWgXhpUezrP7u2vxrOxZV+08xjUYMhT4Fuctt0SkDbP7IdGaoLU
         BjbTNzRbIYwR2jaEObPKjQh74hAts1XTD0uZhcaGf7N5Kp7Ew/obySDvnkC19icczx
         x9vaOK1wGv1lg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net 12/13] net/mlx5e: Fix use after free in mlx5e_fs_init()
Date:   Mon, 22 Aug 2022 12:59:16 -0700
Message-Id: <20220822195917.216025-13-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822195917.216025-1-saeed@kernel.org>
References: <20220822195917.216025-1-saeed@kernel.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

Call mlx5e_fs_vlan_free(fs) before kvfree(fs).

Fixes: af8bbf730068 ("net/mlx5e: Convert mlx5e_flow_steering member of mlx5e_priv to pointer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index e2a9b9be5c1f..e0ce5a233d0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1395,10 +1395,11 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 	}
 
 	return fs;
-err_free_fs:
-	kvfree(fs);
+
 err_free_vlan:
 	mlx5e_fs_vlan_free(fs);
+err_free_fs:
+	kvfree(fs);
 err:
 	return NULL;
 }
-- 
2.37.1

