Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621DA2A2BE6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgKBNqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:46:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49305 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKBNqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 08:46:11 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kZa9p-0000ZO-B0; Mon, 02 Nov 2020 13:46:01 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] octeontx2-pf: Fix sizeof() mismatch
Date:   Mon,  2 Nov 2020 13:46:01 +0000
Message-Id: <20201102134601.698436-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

An incorrect sizeof() is being used, sizeof(u64 *) is not correct,
it should be sizeof(*sq->sqb_ptrs).

Fixes: caa2da34fd25 ("octeontx2-pf: Initialize and config queues")
Addresses-Coverity: ("Sizeof not portable (SIZEOF_MISMATCH)")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index fc765e86988e..9f3d6715748e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1239,7 +1239,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 
 		sq = &qset->sq[qidx];
 		sq->sqb_count = 0;
-		sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(u64 *), GFP_KERNEL);
+		sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_KERNEL);
 		if (!sq->sqb_ptrs)
 			return -ENOMEM;
 
-- 
2.27.0

