Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3957359C97B
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbiHVUA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238668AbiHVT7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F65D4E85D
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A44E61274
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A33C433C1;
        Mon, 22 Aug 2022 19:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198381;
        bh=CC+jpg71xaLBGudpKzAQFvqNT1ytA0g4cZi4uziilKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aO1Zizo36P9QsV87cg4Sk+dwf+NPykXuq942XRGOZXgGoVkA5S+DiLRWa8o3ArMvq
         xVqQZGKY7C5mPPPYEUVC98Y6m2plIEDzeHceeYK/aiUo10h7rTGXqpntOu8CY/17GV
         jBBhrb+f1ba/tj4d6JoMj5gw3yAmYQ6KNCi6rTS3a/+BoQJn8+IMvwovsG73kbWT9A
         iznxYWfv+5S1VtS8V7Xb8ROYQqLUqRd3den27hs05wFV/pjcY7Yb/BdxE87HALrQWB
         XXyv4voFsKVNS5MsOFcyooA6J8oJvqIBgSoXrwQIByEgNZha5/jU6Vgxc0F2jvbfJB
         aGHGn0b9ubDyw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net 13/13] net/mlx5: Unlock on error in mlx5_sriov_enable()
Date:   Mon, 22 Aug 2022 12:59:17 -0700
Message-Id: <20220822195917.216025-14-saeed@kernel.org>
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

Unlock before returning if mlx5_device_enable_sriov() fails.

Fixes: 84a433a40d0e ("net/mlx5: Lock mlx5 devlink reload callbacks")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index ee2e1b7c1310..c0e6c487c63c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -159,11 +159,11 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 
 	devl_lock(devlink);
 	err = mlx5_device_enable_sriov(dev, num_vfs);
+	devl_unlock(devlink);
 	if (err) {
 		mlx5_core_warn(dev, "mlx5_device_enable_sriov failed : %d\n", err);
 		return err;
 	}
-	devl_unlock(devlink);
 
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err) {
-- 
2.37.1

