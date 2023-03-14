Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F806B8AB6
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCNFnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjCNFnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332A585366
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2AFAB8188F
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEBBC4339C;
        Tue, 14 Mar 2023 05:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772564;
        bh=6RXpQxYlI3zjGsz34mYNLCxArTBrkK9dWNdk9V13C6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsFZaKgZpv/badEAGJ8xuezGv0L08O4UOlkqbcseBrzSQv7p6o1k/ruuMHWdSH/1n
         tUOulReM0GSdVSj7Omb1h7F+WCl4EsWiwWwDkmVCpZuNiTBewARYJFXb40NgA4TO0w
         EmOElZBGGx+ecvfvcUXvvkTHQUgVEKih4x0+9FI2p1tTQHj+ES74c9qySykDruk6Rj
         bKnZQ2zIkjudDw2+4tPMTyDoOM+Sccu4vqC86oO3DzJVDmHrAS4b7/zl3/gpqKkyvt
         QsFX2UlK/We8nSdcpqAViHzS18Q1IPmEBYWQaY5tj0OnpSMYcWvhebEzwmBLhUo9Xs
         WJs8hQ0yRSYag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 01/15] net/mlx5: remove redundant clear_bit
Date:   Mon, 13 Mar 2023 22:42:20 -0700
Message-Id: <20230314054234.267365-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

When shutdown or remove callbacks are called the driver sets the flag
MLX5_BREAK_FW_WAIT, to stop waiting for FW as teardown was called. There
is no need to clear the bit as once shutdown or remove were called as
there is no way back, the driver is going down. Furthermore, if not
cleared the flag can be used also in other loops where we may wait while
teardown was already called.

Use test_bit() instead of test_and_clear_bit() as there is no need to
clear the flag.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 540840e80493..0ff0eb660495 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -191,7 +191,7 @@ static int wait_fw_init(struct mlx5_core_dev *dev, u32 max_wait_mili,
 		if (!(fw_initializing >> 31))
 			break;
 		if (time_after(jiffies, end) ||
-		    test_and_clear_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state)) {
+		    test_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state)) {
 			err = -EBUSY;
 			break;
 		}
-- 
2.39.2

