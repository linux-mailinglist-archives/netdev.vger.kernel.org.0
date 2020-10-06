Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7793F285161
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 20:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgJFSMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 14:12:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54319 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgJFSMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 14:12:49 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kPrS8-0001UQ-2u; Tue, 06 Oct 2020 18:12:44 +0000
From:   Colin King <colin.king@canonical.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5: Fix uininitialized pointer read on pointer attr
Date:   Tue,  6 Oct 2020 19:12:43 +0100
Message-Id: <20201006181243.546661-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the error exit path err_free kfree's attr. In the case where
flow and parse_attr failed to be allocated this return path will free
the uninitialized pointer attr, which is not correct.  In the other
case where attr fails to allocate attr does not need to be freed. So
in both error exits via err_free attr should not be freed, so remove
it.

Addresses-Coverity: ("Uninitialized pointer read")
Fixes: ff7ea04ad579 ("net/mlx5e: Fix potential null pointer dereference")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a0c356987e1a..e3a968e9e2a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4569,7 +4569,6 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 err_free:
 	kfree(flow);
 	kvfree(parse_attr);
-	kfree(attr);
 	return err;
 }
 
-- 
2.27.0

