Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3C2440478
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhJ2U7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhJ2U7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 565E26108F;
        Fri, 29 Oct 2021 20:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541003;
        bh=rZUXi9pFSu0D3oR3PqE3i0PNZ7YloYtLWAexjWfjRR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gP9VCunlzQOPVLxlDnuFt4rZPbH6yPBPEN/KSjwl6K5v6PY66lMAjJfZlObMmJLn7
         u5BIShcTAZqIROzXMh+RmzY39LK214SgrjXWBNjXna1YOAolJWT4oL/YJGdSrZT2jp
         //YWY1p8rLZ7WUuqjqGbooa5pzlsVoq/t8GnB6fCll90sxF6XrBleLaK4K0Y4byp07
         fiRQUOWbaxu9VEQjuB9PU85dSZO4CGRM3GqIA2upmEWtJAiFrPNrB+pO5Ae2Dnk4dG
         D1AFICNIZGP7j0viMPmUbf9YRrskAP3omjOvwUEldqghGaNHfoyZexKOKqWBv+y3vZ
         UrbLMWm4324NA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/14] net/mlx5: Add esw assignment back in mlx5e_tc_sample_unoffload()
Date:   Fri, 29 Oct 2021 13:56:19 -0700
Message-Id: <20211029205632.390403-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

Clang warns:

drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c:635:34: error: variable 'esw' is uninitialized when used here [-Werror,-Wuninitialized]
        mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, sample_flow->pre_attr);
                                        ^~~
drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c:626:26: note: initialize the variable 'esw' to silence this warning
        struct mlx5_eswitch *esw;
                                ^
                                 = NULL
1 error generated.

It appears that the assignment should have been shuffled instead of
removed outright like in mlx5e_tc_sample_offload(). Add it back so there
is no use of esw uninitialized.

Fixes: a64c5edbd20e ("net/mlx5: Remove unnecessary checks for slow path flag")
Link: https://github.com/ClangBuiltLinux/linux/issues/1494
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 1046b7ea5c88..df6888c4793c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -631,6 +631,7 @@ mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
 	/* The following delete order can't be changed, otherwise,
 	 * will hit fw syndromes.
 	 */
+	esw = tc_psample->esw;
 	sample_flow = attr->sample_attr->sample_flow;
 	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, sample_flow->pre_attr);
 
-- 
2.31.1

