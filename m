Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF732B7E45
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 14:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgKRNZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:25:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58352 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgKRNZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 08:25:08 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kfNSI-00022Q-BM; Wed, 18 Nov 2020 13:25:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Vamsi Attunuru <vattunuru@marvell.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-af: Fix return of uninitialized variable err
Date:   Wed, 18 Nov 2020 13:25:02 +0000
Message-Id: <20201118132502.461098-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the variable err may be uninitialized if several of the if
statements are not executed in function nix_tx_vtag_decfg and a garbage
value in err is returned.  Fix this by initialized ret at the start of
the function.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 9a946def264d ("octeontx2-af: Modify nix_vtag_cfg mailbox to support TX VTAG entries")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index e8d039503097..739b37034bdf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2085,7 +2085,7 @@ static int nix_tx_vtag_decfg(struct rvu *rvu, int blkaddr,
 	u16 pcifunc = req->hdr.pcifunc;
 	int idx0 = req->tx.vtag0_idx;
 	int idx1 = req->tx.vtag1_idx;
-	int err;
+	int err = 0;
 
 	if (req->tx.free_vtag0 && req->tx.free_vtag1)
 		if (vlan->entry2pfvf_map[idx0] != pcifunc ||
-- 
2.28.0

