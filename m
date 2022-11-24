Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D8C637363
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiKXILJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiKXIK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:10:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598F9D1C30
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:10:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDAD86201D
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B665C433D6;
        Thu, 24 Nov 2022 08:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277458;
        bh=ZQCTuS4UOSRrgIP48LCKtunr/RUyUr1DjMNIwOdw9MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZiEKbHHCSMPClutflGyQejnt92pX0bwSOUJvWSlKVTzD0XsbuL4DAvbd8GgYrHaH
         wclPGLnfkaplTXCabrT1LemRJYSNQ3Io60Rnj9Wq2wgyEtQdfOyBLUW982Bmjen428
         rnySojBm8q02l3tx0IcOSqLnTZB0QgnEH4rBegA0L78HQw7uBdZABcOK4aYV23rPCy
         W8Y9URVLhPK8cG+H/qziL6JEWcZi8+35nE7h5nQ8xNcRJUnisB0vXRFbDzMZiIN89t
         5CkYu0HFsWkzxHpJNObDSZEjgQZMrmmJnQuysA+slYGgIe+Q3+UjD0V30EcvZwQKgg
         5PLZeLN+L1Ang==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net 06/15] net/mlx5e: Fix a couple error codes
Date:   Thu, 24 Nov 2022 00:10:31 -0800
Message-Id: <20221124081040.171790-7-saeed@kernel.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

If kvzalloc() fails then return -ENOMEM.  Don't return success.

Fixes: 3b20949cb21b ("net/mlx5e: Add MACsec RX steering rules")
Fixes: e467b283ffd5 ("net/mlx5e: Add MACsec TX steering rules")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 1ac0cf04e811..96cec6d826c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -250,7 +250,7 @@ static int macsec_fs_tx_create(struct mlx5e_macsec_fs *macsec_fs)
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	u32 *flow_group_in;
-	int err = 0;
+	int err;
 
 	ns = mlx5_get_flow_namespace(macsec_fs->mdev, MLX5_FLOW_NAMESPACE_EGRESS_MACSEC);
 	if (!ns)
@@ -261,8 +261,10 @@ static int macsec_fs_tx_create(struct mlx5e_macsec_fs *macsec_fs)
 		return -ENOMEM;
 
 	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
-	if (!flow_group_in)
+	if (!flow_group_in) {
+		err = -ENOMEM;
 		goto out_spec;
+	}
 
 	tx_tables = &tx_fs->tables;
 	ft_crypto = &tx_tables->ft_crypto;
@@ -898,7 +900,7 @@ static int macsec_fs_rx_create(struct mlx5e_macsec_fs *macsec_fs)
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	u32 *flow_group_in;
-	int err = 0;
+	int err;
 
 	ns = mlx5_get_flow_namespace(macsec_fs->mdev, MLX5_FLOW_NAMESPACE_KERNEL_RX_MACSEC);
 	if (!ns)
@@ -909,8 +911,10 @@ static int macsec_fs_rx_create(struct mlx5e_macsec_fs *macsec_fs)
 		return -ENOMEM;
 
 	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
-	if (!flow_group_in)
+	if (!flow_group_in) {
+		err = -ENOMEM;
 		goto free_spec;
+	}
 
 	rx_tables = &rx_fs->tables;
 	ft_crypto = &rx_tables->ft_crypto;
-- 
2.38.1

