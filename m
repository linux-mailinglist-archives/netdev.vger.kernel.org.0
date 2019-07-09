Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48586325D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 09:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfGIHup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 03:50:45 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38379 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGIHup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 03:50:45 -0400
Received: by mail-pg1-f195.google.com with SMTP id z75so9018236pgz.5
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 00:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=m6LG1JlWx9E8VKjLdcpem7+6mMguOAvzuxpXmIyXjIw=;
        b=Vb9ThOm1qtzdnkZc0xuhiWdZNX4JhBmfwmHthyRcZbBy1XDR1LcILVAgL5AJk70Z0+
         6XHiRtQ1wC63d8vq9KS1oDCwrX9hBC4do0uTSEx/WVLlvNB2OsqiTgNw0Ewo1IGge8gl
         xegwkJ+afOPZEAsVey+xRDSsmlR9HPuQ0WUjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=m6LG1JlWx9E8VKjLdcpem7+6mMguOAvzuxpXmIyXjIw=;
        b=h5E6bMoTmYTGyhtI6alYSbe/+cc6QTg3vPtpISZdiOoWE3OcNNsOLpOXIdc4WCIikA
         WZUtuIUUleEs8hAWu7Ef1IW/tKduSG4QjCcI6SiCs6Rz3rbwmt96luoEwbfAQf268Y1A
         OXXiVxXjlZlg97FjkoCClpYhpMLOaJju0lwWlevdCuikreOhYNOIAsL2q5+WktjzFMBL
         eVgLf2Qp8nq1xfktRCvpRwTr+7MgXFR6PSIjEF2snj5hDAZTTZG9m0oOvtHIifqnKzaR
         z9V6iAzyS66TNKH/S3kcO7eDYwGoFluguK4dbFt2vWJbD4UzstsaRDN++VIZtVHbC3/e
         20eg==
X-Gm-Message-State: APjAAAUnwNzpR0IL6yrHkAlE3uZ5EfLy85n0srrxuj0EWZp4b1PRz3kW
        Fybu0MHV9apwieYUAajj5Chmsbbx9B4=
X-Google-Smtp-Source: APXvYqyCjnJOps8ndMydfjReHGZV1W56HaUpH+3cTcm9lc/qmB5w6Csy0Ns0Rxac13d6q7eHEjQLOA==
X-Received: by 2002:a17:90a:19d:: with SMTP id 29mr31579908pjc.71.1562658645085;
        Tue, 09 Jul 2019 00:50:45 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i74sm3554090pje.16.2019.07.09.00.50.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 00:50:44 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andy Gospodarek <gospo@broadcom.com>
Subject: [PATCH net-next] bnxt_en: Add page_pool_destroy() during RX ring cleanup.
Date:   Tue,  9 Jul 2019 03:50:07 -0400
Message-Id: <1562658607-30048-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add page_pool_destroy() in bnxt_free_rx_rings() during normal RX ring
cleanup, as Ilias has informed us that the following commit has been
merged:

1da4bbeffe41 ("net: core: page_pool: add user refcnt and reintroduce page_pool_destroy")

The special error handling code to call page_pool_free() can now be
removed.  bnxt_free_rx_rings() will always be called during normal
shutdown or any error paths.

Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e9d3bd8..2b5b0ab 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2500,6 +2500,7 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
 		if (xdp_rxq_info_is_reg(&rxr->xdp_rxq))
 			xdp_rxq_info_unreg(&rxr->xdp_rxq);
 
+		page_pool_destroy(rxr->page_pool);
 		rxr->page_pool = NULL;
 
 		kfree(rxr->rx_tpa);
@@ -2560,19 +2561,14 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
 			return rc;
 
 		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i);
-		if (rc < 0) {
-			page_pool_free(rxr->page_pool);
-			rxr->page_pool = NULL;
+		if (rc < 0)
 			return rc;
-		}
 
 		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
 						MEM_TYPE_PAGE_POOL,
 						rxr->page_pool);
 		if (rc) {
 			xdp_rxq_info_unreg(&rxr->xdp_rxq);
-			page_pool_free(rxr->page_pool);
-			rxr->page_pool = NULL;
 			return rc;
 		}
 
-- 
2.5.1

