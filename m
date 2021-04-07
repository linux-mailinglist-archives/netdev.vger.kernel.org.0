Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D934356244
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhDGEGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhDGEGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:06:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C069A613CE;
        Wed,  7 Apr 2021 04:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617768403;
        bh=31W5DVZmsPZhibGtQ5uhY7B0+WfV2eB4IqtkL45RwMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOIXaU3+5koMPnJY70qjeXOcEENR+dnfQmg6l1CmtdEoKqwXTwq169wfdY+saUQZx
         qNcx0tkpofE5wt+hQ0a2rab85KkRntHcon/OK5tj4NZ050wcB+UapQl80mu/14Zu/z
         ibRAWMQY3h29F239AKuFQaOnW0kupj2hid9uGSqSbryYY5APBSh0LSVWLNQdqLQN0o
         qYYwFTEXi1L+c2chqvNkwdkMtu6wbrexI5NO5k3b9tPH7g7pf/O6icN2ntEwtJ93iZ
         YAN3l8Nj2sF/dFUTnPANT8ayMYeIuvXpgGjj9vMMFWdGn24uUeC1BZFQpgv6ql4dH4
         pfyJChG0Z0oHw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/5] net/mlx5: fix kfree mismatch in indir_table.c
Date:   Tue,  6 Apr 2021 21:06:20 -0700
Message-Id: <20210407040620.96841-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407040620.96841-1-saeed@kernel.org>
References: <20210407040620.96841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>

Memory allocated by kvzalloc() should be freed by kvfree().

Fixes: 34ca65352ddf2 ("net/mlx5: E-Switch, Indirect table infrastructur")
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/indir_table.c  | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index 6f6772bf61a2..3da7becc1069 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -248,7 +248,7 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 err_ethertype:
 	kfree(rule);
 out:
-	kfree(rule_spec);
+	kvfree(rule_spec);
 	return err;
 }
 
@@ -328,7 +328,7 @@ static int mlx5_create_indir_recirc_group(struct mlx5_eswitch *esw,
 	e->recirc_cnt = 0;
 
 out:
-	kfree(in);
+	kvfree(in);
 	return err;
 }
 
@@ -347,7 +347,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
-		kfree(in);
+		kvfree(in);
 		return -ENOMEM;
 	}
 
@@ -371,8 +371,8 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 	}
 
 err_out:
-	kfree(spec);
-	kfree(in);
+	kvfree(spec);
+	kvfree(in);
 	return err;
 }
 
-- 
2.30.2

