Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BE93ABFF2
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 02:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhFRAHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 20:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhFRAHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 20:07:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FCA061369;
        Fri, 18 Jun 2021 00:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623974702;
        bh=MEsWiZlMtxcrV/QOrUJyp+E0fsqBpIcMcqq8myyO81Q=;
        h=From:To:Cc:Subject:Date:From;
        b=grzMm7uXMCQnNxhRvyJY01V/OjzS51U616atg4MjFMENbqj7a8a0bvwq2iu/O7afJ
         l7Z0Dohb+gREI2VIW/DEjaZy/cu2rFoxf5bITKjX0CBlStwcLvcQ73HYwscfNis2zK
         t+tmgvqbXtdMk03NWAcnFnRaLrUxXQBdSaJZLY5/ELyMUvc51qSgJjm7ZHdFVIn/yG
         IpHQQV9/mn+mjEhcF0z8/fjKhwQ0UIhdQTDyDC65h63O0/7Gs0YomZmt5pLHpMt+pu
         VzPTjeawmWl1NBnDpmKUSlef1Hrl+qD1b6Sr9d36dTxMeHmCmsRg7iM3/VdXvvrIgs
         wDY8Dn8GuEyug==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH net-next] net/mlx5: Use cpumask_available() in mlx5_eq_create_generic()
Date:   Thu, 17 Jun 2021 17:03:59 -0700
Message-Id: <20210618000358.2402567-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.93.g670b81a890
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_CPUMASK_OFFSTACK is unset, cpumask_var_t is not a pointer
but a single element array, meaning its address in a structure cannot be
NULL as long as it is not the first element, which it is not. This
results in a clang warning:

drivers/net/ethernet/mellanox/mlx5/core/eq.c:715:14: warning: address of
array 'param->affinity' will always evaluate to 'true'
[-Wpointer-bool-conversion]
        if (!param->affinity)
            ~~~~~~~~^~~~~~~~
1 warning generated.

The helper cpumask_available was added in commit f7e30f01a9e2 ("cpumask:
Add helper cpumask_available()") to handle situations like this so use
it to keep the meaning of the code the same while resolving the warning.

Fixes: e4e3f24b822f ("net/mlx5: Provide cpumask at EQ creation phase")
Link: https://github.com/ClangBuiltLinux/linux/issues/1400
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 7e5b3826eae5..d3356771e628 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -710,7 +710,7 @@ mlx5_eq_create_generic(struct mlx5_core_dev *dev,
 	struct mlx5_eq *eq = kvzalloc(sizeof(*eq), GFP_KERNEL);
 	int err;
 
-	if (!param->affinity)
+	if (!cpumask_available(param->affinity))
 		return ERR_PTR(-EINVAL);
 
 	if (!eq)

base-commit: 8fe088bd4fd12f4c8899b51d5bc3daad98767d49
-- 
2.32.0.93.g670b81a890

