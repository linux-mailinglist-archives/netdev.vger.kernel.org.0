Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421AF882A9
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436493AbfHISgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:36:31 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:38436 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726428AbfHISgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:36:31 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 96273C0ADA
        for <netdev@vger.kernel.org>; Fri,  9 Aug 2019 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565375790; bh=OvPR5IggVD+8KeP+nk7gujxzXatFMkSpkksLGkCbYIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=lKmqnmLDqMQeH/7MBrwA7gnrS2YVpmhFtH4SpYw4YpBPD9gm1Id3iJsWZ9XtRRc4C
         s32XQviK7y7yY5ny5k8DTrgqtpku//3OrxM285S2D5EK9d++3qiFEPMtx8+1n5H8mo
         3gxhYve0oEvy5qYkBc0VY0loILmgrbgSfV3ylfyDxw+f08zoyH/70VwUS755ID9LHT
         4P9e/NU82spS6R2bYgHnNkp/bYooEiX+keeBmVieCCfBGkKZkqMBfNftkr7Hwi5M/m
         o4umR3vvqWsPoK8IZ5As2RAqA97o9mo/+LDgIOGxDcX3Sc5D6u7uegcD/dk91GMZ4e
         CGG5reOy2lIGw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 3A403A0064;
        Fri,  9 Aug 2019 18:36:29 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH net-next 03/12] net: stmmac: xgmac: Correctly return that RX descriptor is not last one
Date:   Fri,  9 Aug 2019 20:36:11 +0200
Message-Id: <49ab9b51be8a73f89228b33f9f8d06a6ac553aa3.1565375521.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return the correct value when RX descriptor is not the last one.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 2391ede97597..717b50d4aa93 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -26,16 +26,15 @@ static int dwxgmac2_get_rx_status(void *data, struct stmmac_extra_stats *x,
 				  struct dma_desc *p)
 {
 	unsigned int rdes3 = le32_to_cpu(p->des3);
-	int ret = good_frame;
 
 	if (unlikely(rdes3 & XGMAC_RDES3_OWN))
 		return dma_own;
 	if (likely(!(rdes3 & XGMAC_RDES3_LD)))
+		return rx_not_ls;
+	if (unlikely((rdes3 & XGMAC_RDES3_ES) && (rdes3 & XGMAC_RDES3_LD)))
 		return discard_frame;
-	if (unlikely(rdes3 & XGMAC_RDES3_ES))
-		ret = discard_frame;
 
-	return ret;
+	return good_frame;
 }
 
 static int dwxgmac2_get_tx_len(struct dma_desc *p)
-- 
2.7.4

