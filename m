Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302686D8D33
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbjDFCD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbjDFCDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:03:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011238A7D
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABD4762B22
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E188C433EF;
        Thu,  6 Apr 2023 02:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746574;
        bh=BC6izT+qiBRLN7XOEgGF0y/iFj01R66HGAMRlC6Pzd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqsP4TxiA0g/O/50EDguq3vC3QpCWK3bkjZ39ZigIq8i0aT61dQ7aLkLnqQxBsxIy
         eoOFusAxi1rCNbXDveR+HCDCzNp3DKszpSHRaVbzfdMMwRYmkJOpJhPAj3lnaqcqXK
         6ucez3jmretY4DTlUs4DQXfTEsvmLQeuEiIl3Ws6LNv1x4BGb3RTkElk5fwgHzcLa7
         NclJtIUYrYpwHcu3f2HjgIU2Q2uoWK+/1Kc9MAB5TdNpYT9XpcgPP31QUUHJGTFpiY
         PB6u7ddP07s2LZqIz8PIKz3VQCDW1+GND8ltM6toHlNhkIlhcU+XyfEi4YZH9rIRDs
         u2IbyJkHEZ05Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Bar Shapira <bshapira@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Update cyclecounter shift value to improve ptp free running mode precision
Date:   Wed,  5 Apr 2023 19:02:29 -0700
Message-Id: <20230406020232.83844-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Multiplier values are equivalent to 2^(shift constant) since all mlx5
devices advertise a 1Ghz frequency for the internal timer. The previous
shift constant of 23 led to internal timer adjustments only taking place
when the provided adjustment values were greater than or equal to ~120 ppb
or ~7864 scaled ppm. Using a shift constant of 31 enables adjustments when
an adjustment parameter is greater than or equal to ~0.47 ppb or ~30.8
scaled ppm.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Bar Shapira <bshapira@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 4c9a40211059..932fbc843c69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -39,7 +39,7 @@
 #include "clock.h"
 
 enum {
-	MLX5_CYCLES_SHIFT	= 23
+	MLX5_CYCLES_SHIFT	= 31
 };
 
 enum {
-- 
2.39.2

