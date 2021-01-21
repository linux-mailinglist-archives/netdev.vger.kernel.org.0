Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4D52FE5A4
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 09:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbhAUIzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 03:55:45 -0500
Received: from m12-16.163.com ([220.181.12.16]:39187 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbhAUIxw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 03:53:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=ArBTUuh53jUTPHGj7F
        B71BEdSOmQokOK+9LhXjG5hec=; b=OArB6ttt/zpOoxfWAVuPD6hqidJXhG54j4
        Q9UX7cigZln44S067At/CbpQk52Xk8EGLBiJJk1YtrF7GRrkUV0YREg1rtu7Et8W
        9YUFW9wCY56pKD4zFBSLFI3O8QhnyQzG4DQCK9LoPIYGqRSSn5TDdrAtV488xR3x
        wQokPDP1A=
Received: from localhost.localdomain (unknown [119.3.119.20])
        by smtp12 (Coremail) with SMTP id EMCowACXQy34CQlgDlyOYA--.45434S4;
        Thu, 21 Jan 2021 12:58:38 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Moshe Tal <moshet@mellanox.com>, Joe Perches <joe@perches.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH] net/mlx5e: free page before return
Date:   Wed, 20 Jan 2021 20:58:30 -0800
Message-Id: <20210121045830.96928-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EMCowACXQy34CQlgDlyOYA--.45434S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr4kXryDXFWDKr4kWrWkCrg_yoWfuFb_Wr
        yUX3WfGrs7XF4jk3W3u3yaka4xKw1Durn3AFZagFy5Jw47Wr1kJayUWFyfAryxWrWxZa4D
        Ga9xta43Z3y5AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnIoGJUUUUU==
X-Originating-IP: [119.3.119.20]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiNh4hclWBlumFIQAAs0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of directly return, goto the error handling label to free
allocated page.

Fixes: 5f29458b77d5 ("net/mlx5e: Support dump callback in TX reporter")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 718f8c0a4f6b..84e501e057b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -273,7 +273,7 @@ int mlx5e_health_rsc_fmsg_dump(struct mlx5e_priv *priv, struct mlx5_rsc_key *key
 
 	err = devlink_fmsg_binary_pair_nest_start(fmsg, "data");
 	if (err)
-		return err;
+		goto free_page;
 
 	cmd = mlx5_rsc_dump_cmd_create(mdev, key);
 	if (IS_ERR(cmd)) {
-- 
2.17.1


