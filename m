Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE1A43CD98
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242798AbhJ0Pet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:34:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242770AbhJ0Pes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:34:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B82D60234;
        Wed, 27 Oct 2021 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635348743;
        bh=vMiDo4UFd1lZ/YyMXF6Ta6cSnid2M9pwKjos+dk8clw=;
        h=From:To:Cc:Subject:Date:From;
        b=IcQU9SiTQBpayiGmdoY9i48TxVV7oCPhMxF4kYrAlBVJPCdKMsAFI3myKR2VTDOL9
         /35lTXj4ZEXO340BnL1m840ROKVOENu3RljglTx6JATPm+kR1zx4dG5kxCvyYNZVYv
         uR5Rb8rcfiUqFyN0tmZ9l4QVL63A4Fu1W4Wq9xOC4LI7RWJxbhlzIDgeR7d4avMwzl
         ELa/UIGmHfK2gDwBv6cHjvCESlA2usbs4dNv9LSXn57OG1DT1YVqTuo1ZuvgIU+Hvp
         Oe/mvhYqZ4EHq2uv2V7gOAyCW3ZdTnSYLIx+qx9WU69ObqX/RV0k3CXTk0ZNzeEM0L
         d1CiFTPdTBeyw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH net-next] net/mlx5: Add esw assignment back in mlx5e_tc_sample_unoffload()
Date:   Wed, 27 Oct 2021 08:31:22 -0700
Message-Id: <20211027153122.3224673-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.1.637.gf443b226ca
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 

base-commit: 6487c819393ed1678ef847fd260ea86edccc0bb3
-- 
2.33.1.637.gf443b226ca

