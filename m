Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADC6466ED7
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244664AbhLCA7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60612 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244188AbhLCA7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D42A6291F
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC61C53FD5;
        Fri,  3 Dec 2021 00:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492987;
        bh=gMzRatX5WD4YwHQycmXjmiHVnzFMqxCYKb63VbljIdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTT7mh76gZD9IUrIkRo7V/Uk1NLhgwWjjiZ8DL1Yta2ukeVPWYXsNAMzlxAX9AtjR
         V+GW7OSTDo8ciKrphYo+TIduOtozi/f8BqpnjwfDRW0NzNYg/qpBHzuygnKTWDzMIS
         RyfRUpEoP8+FoSuNsYKg2/YS07Q+ZYFSHQ7kbKo/YbyPhghwvBqld7oXBJRt8v1pdq
         dwIOB6pXBvlLjcz4A7C2ssrMlih1TXzb/qA/mQqa7JILKn3hehRr63i5M9oMsjw49f
         pk1+kiuhnEul1Wo+BUmAzoRwqvwj3CvTKczkFHt8R2PXh5l9zTgHoSnqnd1sFPHUxJ
         4YbpRxIddYg9g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 05/14] net/mlx5: SF, silence an uninitialized variable warning
Date:   Thu,  2 Dec 2021 16:56:13 -0800
Message-Id: <20211203005622.183325-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This code sometimes calls mlx5_sf_hw_table_hwc_init() when "ext_base_id"
is uninitialized.  It's not used on that path, but it generates a static
checker warning to pass uninitialized variables to another function.
It may also generate runtime UBSan  warnings depending on if the
mlx5_sf_hw_table_hwc_init() function is inlined or not.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 252d6017387d..17aa348989cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -247,7 +247,7 @@ int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_sf_hw_table *table;
 	u16 max_ext_fn = 0;
-	u16 ext_base_id;
+	u16 ext_base_id = 0;
 	u16 max_fn = 0;
 	u16 base_id;
 	int err;
-- 
2.31.1

