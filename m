Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D8467271E
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjARSgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjARSgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9CF56880
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C6B3B81EA0
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19784C433EF;
        Wed, 18 Jan 2023 18:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066970;
        bh=/S+xu222hdhyfWLGlxi5B19wK/X5OWC+60K6zHZU8LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLHu6yQ7ZSIWS/OzaKvvXOFM6dgInm4gDWakmvSj5mit7jHfB6ba9kkx0sCuOCQPL
         xpvJZQ0HDkE8baDVR4wOxDqBGaHSrMDfcy1divBwKPnqi2xpbHz1wCj//j556nJCsF
         sgbDo1qJSyFGntGoFOJDYl8KOmbavQvlVxKdmKq9Vm4LRFv8elNZg1WTwqVWZ5VvZ0
         5Bd1lA6XxvJlFT5BzEB6iAmliWt1Jg/FEwg3pWnR/DxrnHkqtqY93Ee5YxUEFJx998
         3WNDvuXefSrv8cXi9lJ9Bzsy5eNVm6JQ7cu18QHgkBt10d0Sa94BofRulq++AiZoUq
         tvpiaFB+PaIxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Add adjphase function to support hardware-only offset control
Date:   Wed, 18 Jan 2023 10:35:50 -0800
Message-Id: <20230118183602.124323-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
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

The adjtime function supports using hardware to set the clock offset when
the delta was supported by the hardware. When the delta is not supported by
the hardware, the driver handles adjusting the clock. The newly-introduced
adjphase function is similar to the adjtime function, except it guarantees
that a provided clock offset will be used directly by the hardware to
adjust the PTP clock. When the range is not acceptable by the hardware, an
error is returned.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 69318b143268..ecdff26a22b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -326,6 +326,14 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return 0;
 }
 
+static int mlx5_ptp_adjphase(struct ptp_clock_info *ptp, s32 delta)
+{
+	if (delta < S16_MIN || delta > S16_MAX)
+		return -ERANGE;
+
+	return mlx5_ptp_adjtime(ptp, delta);
+}
+
 static int mlx5_ptp_adjfreq_real_time(struct mlx5_core_dev *mdev, s32 freq)
 {
 	u32 in[MLX5_ST_SZ_DW(mtutc_reg)] = {};
@@ -688,6 +696,7 @@ static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.n_pins		= 0,
 	.pps		= 0,
 	.adjfine	= mlx5_ptp_adjfine,
+	.adjphase	= mlx5_ptp_adjphase,
 	.adjtime	= mlx5_ptp_adjtime,
 	.gettimex64	= mlx5_ptp_gettimex,
 	.settime64	= mlx5_ptp_settime,
-- 
2.39.0

