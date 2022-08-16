Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074CE595A0E
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiHPL0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbiHPLZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13A9103600
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:40:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A42F960B80
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A327DC433D6;
        Tue, 16 Aug 2022 10:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646407;
        bh=6JDAKPEmvxlERFp9TCFA2PSpBWFnpEy5Z7BpNLkTZ2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLPWuaRavpUN+KZEKYOCiwnGuzTQ7V4ZN8PAWtI0j7z1uxn6MKPYNkpo6LfK5kXlD
         vZyQtTN5SD4X4jqkC9EFzQj6L230dvKM3KFcK6WDaF/2TMbsXJbvDB3UBHBSAx8maU
         Jd+X5iz/l/EnjUrPk3tPtVGfKEdAay2qd9IeyhPApKgJMvdDR5cDy2mtwj5NQdrNmD
         sQzerv0IaixMCdtpH1XJAKvb5yRb82J13xsuKWgrNApJX0UxPcxv5j4LgP9Jw+E+rQ
         lnWjDryzdHzR+s5bXHZ9lgSoL68DoIwuMoZkejsiu9LZtVWn5mM/vDwVGty90zUJ/E
         4p6t5A22h9jgQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 17/26] net/mlx5e: Group IPsec miss handles into separate struct
Date:   Tue, 16 Aug 2022 13:38:05 +0300
Message-Id: <209ea06f2a192bb24567720ade3583f41e82f0c3.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Move miss handles into dedicated struct, so we can reuse it in next
patch when creating IPsec policy flow table.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c     | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 7d1b587a0a04..3443638453a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -16,10 +16,14 @@ struct mlx5e_ipsec_ft {
 	u32 refcnt;
 };
 
+struct mlx5e_ipsec_miss {
+	struct mlx5_flow_group *group;
+	struct mlx5_flow_handle *rule;
+};
+
 struct mlx5e_ipsec_rx {
 	struct mlx5e_ipsec_ft ft;
-	struct mlx5_flow_group *miss_group;
-	struct mlx5_flow_handle *miss_rule;
+	struct mlx5e_ipsec_miss sa;
 	struct mlx5_flow_destination default_dest;
 	struct mlx5e_ipsec_rule status;
 };
@@ -142,18 +146,18 @@ static int rx_fs_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 		mlx5_core_err(mdev, "fail to create ipsec rx miss_group err=%d\n", err);
 		goto out;
 	}
-	rx->miss_group = miss_group;
+	rx->sa.group = miss_group;
 
 	/* Create miss rule */
 	miss_rule =
 		mlx5_add_flow_rules(ft, spec, &flow_act, &rx->default_dest, 1);
 	if (IS_ERR(miss_rule)) {
-		mlx5_destroy_flow_group(rx->miss_group);
+		mlx5_destroy_flow_group(rx->sa.group);
 		err = PTR_ERR(miss_rule);
 		mlx5_core_err(mdev, "fail to create ipsec rx miss_rule err=%d\n", err);
 		goto out;
 	}
-	rx->miss_rule = miss_rule;
+	rx->sa.rule = miss_rule;
 out:
 	kvfree(flow_group_in);
 	kvfree(spec);
@@ -162,8 +166,8 @@ static int rx_fs_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 
 static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 {
-	mlx5_del_flow_rules(rx->miss_rule);
-	mlx5_destroy_flow_group(rx->miss_group);
+	mlx5_del_flow_rules(rx->sa.rule);
+	mlx5_destroy_flow_group(rx->sa.group);
 	mlx5_destroy_flow_table(rx->ft.sa);
 
 	mlx5_del_flow_rules(rx->status.rule);
-- 
2.37.2

