Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1094766391D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjAJGMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjAJGMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:12:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4399E43A3B
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F4138B81112
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F81C433F1;
        Tue, 10 Jan 2023 06:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331108;
        bh=vfPKr2xXEt6P4OAa5WSOAgKjprWYgHqAJgZ+f/72tBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iH/15h8LHhR94SQCA/2CK4csyUCzi7/E75+GgJvHl+/jAGmcRWSnU6Qk/HdZlqx8y
         yeg1b7nQY19rJhhczTLdGLMmkq3u1GgCTevFslyffZye15BvF56eF1P3F+ODoRp7Tp
         RB9ZIx8ssZETurgohXmsMfVJjsV9n07NwejDc3kuDHCZQhy6b3/8WcG7A5LgByDmNy
         JQe6I3fswvO8SwbTQmYPKukXw9N7dJLBXvj/OKgloPWd/uqMRWBgy4S0vBtMdAR9KU
         DSv1vrkrGFeZUC5LC7Ia9PcSwRd17vLISQMzM/FER1pFUY1FEUg7qaii0bZ2HhZsf8
         +CxFe9T8zxsFA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net 12/16] net/mlx5: Fix ptp max frequency adjustment range
Date:   Mon,  9 Jan 2023 22:11:19 -0800
Message-Id: <20230110061123.338427-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

.max_adj of ptp_clock_info acts as an absolute value for the amount in ppb
that can be set for a single call of .adjfine. This means that a single
call to .getfine cannot be greater than .max_adj or less than -(.max_adj).
Provides correct value for max frequency adjustment value supported by
devices.

Fixes: 3d8c38af1493 ("net/mlx5e: Add PTP Hardware Clock (PHC) support")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 69cfe60c558a..69318b143268 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -681,7 +681,7 @@ static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "mlx5_ptp",
-	.max_adj	= 100000000,
+	.max_adj	= 50000000,
 	.n_alarm	= 0,
 	.n_ext_ts	= 0,
 	.n_per_out	= 0,
-- 
2.39.0

