Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81202B7E0B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 14:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgKRNF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:05:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57433 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgKRNF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 08:05:27 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kfN9F-0000K3-3q; Wed, 18 Nov 2020 13:05:21 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-pf: Fix unintentional sign extension issue
Date:   Wed, 18 Nov 2020 13:05:20 +0000
Message-Id: <20201118130520.460365-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The shifting of the u16 result from ntohs(proto) by 16 bits to the
left will be promoted to a 32 bit signed int and then sign-extended
to a u64.  In the event that the top bit of the return from ntohs(proto)
is set then all then all the upper 32 bits of a 64 bit long end up as
also being set because of the sign-extension. Fix this by casting to
a u64 long before the shift.

Addresses-Coverity: ("Unintended sign extension")
Fixes: f0c2982aaf98 ("octeontx2-pf: Add support for SR-IOV management function")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 4c82f60f3cf3..634d60655a74 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2084,7 +2084,7 @@ static int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
 	vtag_req->vtag_size = VTAGSIZE_T4;
 	vtag_req->cfg_type = 0; /* tx vlan cfg */
 	vtag_req->tx.cfg_vtag0 = 1;
-	vtag_req->tx.vtag0 = (ntohs(proto) << 16) | vlan;
+	vtag_req->tx.vtag0 = ((u64)ntohs(proto) << 16) | vlan;
 
 	err = otx2_sync_mbox_msg(&pf->mbox);
 	if (err)
-- 
2.28.0

