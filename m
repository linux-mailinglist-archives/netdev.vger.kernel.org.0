Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F32E4D3C2A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbiCIVjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbiCIVjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC89B6D944
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 664E6B823DA
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1CFC340F7;
        Wed,  9 Mar 2022 21:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861887;
        bh=irltCNOeHgTn/xUT1M7qCLzTyVYpGdsO+JyZPXrj70g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjlzF/OoIQTIu/QUYSi7WgTSRMfURDaoY6nC7U0dWiys5tQoG0qD9a7WsBZVopaer
         4pcpjGCUDelXTapUSNC6lgtIQ8Q+3l6Rx0pWV0RmiURwegekyMRK+3PxL2FzQJMb8Y
         naUBEVaPytbxNezo26d8U+U2PaM4lkngD8EWz+zOg/2iIMfK8jrtpGn5/alff0c29o
         kbl7p60B62AAwpNntDfIz+JdPuGKGVNZtxuISuFKMiY8cdqXdRar7dgtL02M4Gc7Yz
         XiAoNTCoiO+RY0UnysvQ7gllsbu9Ph6Ma6NXdh3VxtIgvAbnk1RQRlipysyed7p+Ts
         qN+IG8YDKfBqQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/16] net/mlx5: Remove redundant error on give pages
Date:   Wed,  9 Mar 2022 13:37:43 -0800
Message-Id: <20220309213755.610202-5-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

If give pages was triggered by FW event and FW failed the command,
the driver should ignore as FW is aware and will handle it.

The downstream patch will add a debugfs counter on this flow for
debuggability.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index de150643ef83..cc4734da6171 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -327,11 +327,12 @@ static void page_notify_fail(struct mlx5_core_dev *dev, u16 func_id,
 }
 
 static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
-		      int notify_fail, bool ec_function)
+		      int event, bool ec_function)
 {
 	u32 function = get_function(func_id, ec_function);
 	u32 out[MLX5_ST_SZ_DW(manage_pages_out)] = {0};
 	int inlen = MLX5_ST_SZ_BYTES(manage_pages_in);
+	int notify_fail = event;
 	u64 addr;
 	int err;
 	u32 *in;
@@ -366,10 +367,15 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	MLX5_SET(manage_pages_in, in, embedded_cpu_function, ec_function);
 
 	err = mlx5_cmd_do(dev, in, inlen, out, sizeof(out));
+	if (err == -EREMOTEIO) {
+		notify_fail = 0;
+		/* if triggered by FW and failed by FW ignore */
+		if (event) {
+			err = 0;
+			goto out_4k;
+		}
+	}
 	if (err) {
-		if (err == -EREMOTEIO)
-			notify_fail = 0;
-
 		err = mlx5_cmd_check(dev, err, in, out);
 		mlx5_core_warn(dev, "func_id 0x%x, npages %d, err %d\n",
 			       func_id, npages, err);
-- 
2.35.1

