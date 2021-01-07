Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDC02ECFFE
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 13:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbhAGMkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 07:40:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39838 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbhAGMkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 07:40:01 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kxUZQ-0003On-Fm; Thu, 07 Jan 2021 12:39:16 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nithya Mani <nmani@marvell.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] octeontx2-af: fix memory leak of lmac and lmac->name
Date:   Thu,  7 Jan 2021 12:39:16 +0000
Message-Id: <20210107123916.189748-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the error return paths don't kfree lmac and lmac->name
leading to some memory leaks.  Fix this by adding two error return
paths that kfree these objects

Addresses-Coverity: ("Resource leak")
Fixes: 1463f382f58d ("octeontx2-af: Add support for CGX link management")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 1156c61f2e02..aa5da9691a1c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -871,8 +871,10 @@ static int cgx_lmac_init(struct cgx *cgx)
 		if (!lmac)
 			return -ENOMEM;
 		lmac->name = kcalloc(1, sizeof("cgx_fwi_xxx_yyy"), GFP_KERNEL);
-		if (!lmac->name)
-			return -ENOMEM;
+		if (!lmac->name) {
+			err = -ENOMEM;
+			goto err_lmac_free;
+		}
 		sprintf(lmac->name, "cgx_fwi_%d_%d", cgx->cgx_id, i);
 		lmac->lmac_id = i;
 		lmac->cgx = cgx;
@@ -883,7 +885,7 @@ static int cgx_lmac_init(struct cgx *cgx)
 						 CGX_LMAC_FWI + i * 9),
 				   cgx_fwi_event_handler, 0, lmac->name, lmac);
 		if (err)
-			return err;
+			goto err_irq;
 
 		/* Enable interrupt */
 		cgx_write(cgx, lmac->lmac_id, CGXX_CMRX_INT_ENA_W1S,
@@ -895,6 +897,12 @@ static int cgx_lmac_init(struct cgx *cgx)
 	}
 
 	return cgx_lmac_verify_fwi_version(cgx);
+
+err_irq:
+	kfree(lmac->name);
+err_lmac_free:
+	kfree(lmac);
+	return err;
 }
 
 static int cgx_lmac_exit(struct cgx *cgx)
-- 
2.29.2

