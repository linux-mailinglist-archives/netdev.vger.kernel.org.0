Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6838C3BCD98
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhGFLW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:22:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55724 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbhGFLUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 07:20:46 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1m0j5W-0004Ns-Us; Tue, 06 Jul 2021 11:18:03 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-pf: Fix assigned error return value that is never used
Date:   Tue,  6 Jul 2021 12:18:02 +0100
Message-Id: <20210706111802.27114-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently when the call to otx2_mbox_alloc_msg_cgx_mac_addr_update fails
the error return variable rc is being assigned -ENOMEM and does not
return early. rc is then re-assigned and the error case is not handled
correctly. Fix this by returning -ENOMEM rather than assigning rc.

Addresses-Coverity: ("Unused value")
Fixes: 79d2be385e9e ("octeontx2-pf: offload DMAC filters to CGX/RPM block")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
index ffe3e94562d0..383a6b5cb698 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
@@ -161,7 +161,7 @@ int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u8 bit_pos)
 
 	if (!req) {
 		mutex_unlock(&pf->mbox.lock);
-		rc = -ENOMEM;
+		return -ENOMEM;
 	}
 
 	ether_addr_copy(req->mac_addr, mac);
-- 
2.31.1

