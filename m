Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69663640EFC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbiLBUPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiLBUPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C705B9543
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ECB3DCE1FB0
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99507C433D7;
        Fri,  2 Dec 2022 20:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012126;
        bh=iYGppdFVWZxdsX61u9AWyABCpCgzkeWBvigK6PjXEsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlZJrGlcx5W+ux2TP2WYeZfIpKOdUCQO/Vf0qXEefqbVR1q8Qym2ICMkF4NbICsrd
         ydW4T0Iqw0E/sWQhm9t8HlaC/tlNGVba3TOXZqRw4gMvfMTDL6rPNbWiBwyDzjicFT
         R1a88exmSpNLURC6bw+I4hltmYj8aD0piHhAnDbxOJXcGze7+ieRmUH9Cyy5/D7lhj
         yVR7G8ZIy2NgLye9OjQMSqbtHBWI0c0vqG6t9IIn1C0f6JQdzeNRtUdJiR2edTpzJf
         NQulwAbwNpkjb3VWiw/S2cKPdSFZVoFycpVjr3IxSD8nM1ooUTdmxN3x6KUY76Wlg/
         I1EmeEkZrZ3og==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm-next 05/13] net/mlx5e: Improve IPsec flow steering autogroup
Date:   Fri,  2 Dec 2022 22:14:49 +0200
Message-Id: <5681cd9a1c04517af1fec2843c368ff8b5389c20.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Flow steering API separates newly created rules based on their
match criteria. Right now, all IPsec tables are created with one
group and suffers from not-optimal FS performance.

Count number of different match criteria for relevant tables, and
set proper value at the table creation.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c   | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index dbe35accaebf..0af831128c4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -196,7 +196,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 
 	/* Create FT */
 	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_LEVEL, MLX5E_NIC_PRIO,
-			     1);
+			     2);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_fs_ft;
@@ -208,7 +208,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		goto err_fs;
 
 	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_POL_FT_LEVEL, MLX5E_NIC_PRIO,
-			     1);
+			     2);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_pol_ft;
@@ -307,13 +307,13 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx)
 	struct mlx5_flow_table *ft;
 	int err;
 
-	ft = ipsec_ft_create(tx->ns, 1, 0, 1);
+	ft = ipsec_ft_create(tx->ns, 1, 0, 4);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
 	tx->ft.sa = ft;
 
-	ft = ipsec_ft_create(tx->ns, 0, 0, 1);
+	ft = ipsec_ft_create(tx->ns, 0, 0, 2);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_pol_ft;
-- 
2.38.1

