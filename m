Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF0A12AB09
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 09:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfLZImI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 03:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbfLZImI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 03:42:08 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DA19206CB;
        Thu, 26 Dec 2019 08:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577349727;
        bh=p5Xq9lCWsvm9q6/gWBNo4dIiGKmP2WBm5Fkywl823qw=;
        h=From:To:Cc:Subject:Date:From;
        b=oaQY23k8IziY6sLYBxIH4d4roqmsV9mnaWb+UhSYRkgZWMdqt2n85IopauXDr/xsU
         9ordfw0d4/7TWyiUHDX6+vLEqbibBC7jBb+qR6FFak1kJCl6K8GAcaHe1qhGLFZIH8
         IDOJ0dGw+Pbt0eJiwC1bmJg4eO18SVoRF4K9PW6c=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        mlxsw <mlxsw@mellanox.com>
Cc:     Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH net] net/mlxfw: Fix out-of-memory error in mfa2 flash burning
Date:   Thu, 26 Dec 2019 10:41:56 +0200
Message-Id: <20191226084156.9561-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

The burning process requires to perform internal allocations of large
chunks of memory. This memory doesn't need to be contiguous and can be
safely allocated by vzalloc() instead of kzalloc(). This patch changes
such allocation to avoid possible out-of-memory failure.

Fixes: 410ed13cae39 ("Add the mlxfw module for Mellanox firmware flash process")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
index 544344ac4894..79057af4fe99 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
+#include <linux/vmalloc.h>
 #include <linux/xz.h>
 #include "mlxfw_mfa2.h"
 #include "mlxfw_mfa2_file.h"
@@ -548,7 +549,7 @@ mlxfw_mfa2_file_component_get(const struct mlxfw_mfa2_file *mfa2_file,
 	comp_size = be32_to_cpu(comp->size);
 	comp_buf_size = comp_size + mlxfw_mfa2_comp_magic_len;

-	comp_data = kmalloc(sizeof(*comp_data) + comp_buf_size, GFP_KERNEL);
+	comp_data = vzalloc(sizeof(*comp_data) + comp_buf_size);
 	if (!comp_data)
 		return ERR_PTR(-ENOMEM);
 	comp_data->comp.data_size = comp_size;
@@ -570,7 +571,7 @@ mlxfw_mfa2_file_component_get(const struct mlxfw_mfa2_file *mfa2_file,
 	comp_data->comp.data = comp_data->buff + mlxfw_mfa2_comp_magic_len;
 	return &comp_data->comp;
 err_out:
-	kfree(comp_data);
+	vfree(comp_data);
 	return ERR_PTR(err);
 }

@@ -579,7 +580,7 @@ void mlxfw_mfa2_file_component_put(struct mlxfw_mfa2_component *comp)
 	const struct mlxfw_mfa2_comp_data *comp_data;

 	comp_data = container_of(comp, struct mlxfw_mfa2_comp_data, comp);
-	kfree(comp_data);
+	vfree(comp_data);
 }

 void mlxfw_mfa2_file_fini(struct mlxfw_mfa2_file *mfa2_file)
--
2.20.1

