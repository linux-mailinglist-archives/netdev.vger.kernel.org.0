Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F0919C4C2
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388793AbgDBOv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:51:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43473 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388689AbgDBOv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:51:26 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jK19H-0003mR-HP; Thu, 02 Apr 2020 14:48:51 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] mlxsw: spectrum_trap: fix unintention integer overflow on left shift
Date:   Thu,  2 Apr 2020 15:48:51 +0100
Message-Id: <20200402144851.565983-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Shifting the integer value 1 is evaluated using 32-bit
arithmetic and then used in an expression that expects a 64-bit
value, so there is potentially an integer overflow. Fix this
by using the BIT_ULL macro to perform the shift and avoid the
overflow.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: 13f2e64b94ea ("mlxsw: spectrum_trap: Add devlink-trap policer support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 9096ffd89e50..fbf714d027d8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -643,7 +643,7 @@ static int mlxsw_sp_trap_policer_bs(u64 burst, u8 *p_burst_size,
 {
 	int bs = fls64(burst) - 1;
 
-	if (burst != (1 << bs)) {
+	if (burst != (BIT_ULL(bs))) {
 		NL_SET_ERR_MSG_MOD(extack, "Policer burst size is not power of two");
 		return -EINVAL;
 	}
-- 
2.25.1

