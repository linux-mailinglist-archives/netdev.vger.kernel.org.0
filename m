Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB092B7F91
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgKROiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:38:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60898 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKROiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:38:11 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kfOax-0007uF-Sd; Wed, 18 Nov 2020 14:38:03 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-af: Fix access of iter->entry after iter object has been kfree'd
Date:   Wed, 18 Nov 2020 14:38:03 +0000
Message-Id: <20201118143803.463297-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The call to pc_delete_flow can kfree the iter object, so the following
dev_err message that accesses iter->entry can accessmemory that has
just been kfree'd.  Fix this by adding a temporary variable 'entry'
that has a copy of iter->entry and also use this when indexing into
the array mcam->entry2target_pffunc[]. Also print the unsigned value
using the %u format specifier rather than %d.

Addresses-Coverity: ("Read from pointer after free")
Fixes: 55307fcb9258 ("octeontx2-af: Add mbox messages to install and delete MCAM rules")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/mlx5/mem.c                       | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 4ddfdff33a61..14832b66d1fe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1218,11 +1218,13 @@ int rvu_mbox_handler_npc_delete_flow(struct rvu *rvu,
 	mutex_unlock(&mcam->lock);
 
 	list_for_each_entry_safe(iter, tmp, &del_list, list) {
+		u16 entry = iter->entry;
+
 		/* clear the mcam entry target pcifunc */
-		mcam->entry2target_pffunc[iter->entry] = 0x0;
+		mcam->entry2target_pffunc[entry] = 0x0;
 		if (npc_delete_flow(rvu, iter, pcifunc))
-			dev_err(rvu->dev, "rule deletion failed for entry:%d",
-				iter->entry);
+			dev_err(rvu->dev, "rule deletion failed for entry:%u",
+				entry);
 	}
 
 	return 0;
-- 
2.28.0

