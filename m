Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87054560E80
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 03:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiF3BAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 21:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiF3BAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 21:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DB822B29
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D8546151E
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F2AC341CA;
        Thu, 30 Jun 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656550813;
        bh=3soJmCJASKSCZTg9s1elNH66wYrZVSwGCi9T+opLlS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BS2FfAUuPP8CbkEjKo0yLIW8IVr5+c3oaApvYEol25gLBUsn0pjCWKhWYRBZHbc3X
         f/H6kAnx4eJVAzamVftFltPHH5MTaqlb5vwZjvdEiWarMxLlMN9NXJKLoLH8XO5VVQ
         gOvod7iEzFL3vnBgZ3YoDAEVn2fhEnapa7xD7/DV+9wvqg/3aTi4GeHnO3QMDwyaiV
         3wAabTtsWcUdqOc3R6X3yzm1dBJEkwwih4ikP63NxAYPpXrS8vRGDPdtnULVx192JI
         HStojxhVEP3hx3BaPZW5uIMpgcibiz5NhiJ9Ugz0G1vAH9ZHRLX+E7sRdi85AwGXAo
         Skylud5HDO9Hw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net-next 02/15] net/mlx5: delete dead code in mlx5_esw_unlock()
Date:   Wed, 29 Jun 2022 17:59:52 -0700
Message-Id: <20220630010005.145775-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630010005.145775-1-saeed@kernel.org>
References: <20220630010005.145775-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

Smatch complains about this function:

    drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:2000 mlx5_esw_unlock()
    warn: inconsistent returns '&esw->mode_lock'.

Before commit ec2fa47d7b98 ("net/mlx5: Lag, use lag lock") there
used to be a matching mlx5_esw_lock() function and the lock and
unlock functions were symmetric.  But now we take the lock
unconditionally and must unlock unconditionally as well.

As near as I can tell this is dead code and can just be deleted.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 719ef26d23c0..3e662e389be4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1995,8 +1995,6 @@ int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
  */
 void mlx5_esw_unlock(struct mlx5_eswitch *esw)
 {
-	if (!mlx5_esw_allowed(esw))
-		return;
 	up_write(&esw->mode_lock);
 }
 
-- 
2.36.1

