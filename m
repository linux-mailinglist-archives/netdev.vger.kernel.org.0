Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1488D18C549
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCTCcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:32:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41049 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbgCTCcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:32:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id b1so2304924pgm.8
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ALU5p38x1xN4Al6t3rl9HxZ7C4eDwc0uc29qy4BYej8=;
        b=Ff7x7FY0UArQGdJcQzhObU+NpD/DOOAvAWbVQokC6cF3zubx5BBts8enSpWoGAF35K
         MJAY24M2VPFW2HlAJNqrmWLhbcUpP0KEftPHVXCH2mS0wLYbzPbG3AgB13jfDb5j3uxP
         bW4jbz9jG+oRHiVjX2N5BD/FIWSDt6+jRcbXRsgQZUv3Vg0ygHkJC6peg9uFklxaT2J+
         fFl492JqN80wp6gKUWbttyPXeG25TvrJihJqSemRetvduGIU3MtgFh6+3kcfH9ZoGqex
         jq7SrdQhLtES7547DhAV1FTeEyX0Jttz1QNtXnWlAFWuof+oBHH8Q59v4dfA7H84fRnw
         XTBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ALU5p38x1xN4Al6t3rl9HxZ7C4eDwc0uc29qy4BYej8=;
        b=g5Ib401zMnhFKcd6dqSqwJr5WQPO03F1xA1K2M1RZ2drppVaLGvNFBE3l7Ze+CDVa8
         3ys6XvdBYRAKMEb731JDtXGBTzRv5fHlAj4ESNBzKmwmBiGX8nNoTncvrEV29/zvdSEI
         1Z3t+yNW+Ww3ZJQs/N7HWeQkG7dA0KYE6VpAKhqZDEOSH9uiZovlSqk8JAkhd9Na23SM
         WNkoG7TISE0KJvsz6UKfYxcCKUy3OrhFNdH6/ob33K4uCZoA+UVkX1wJqVAqDGNNKoz2
         Nd+O9b39yd9MwBm5Mr1fl3Ycb/CmBLBAI57wwnyKOcgkjPbE29XCQM7t7cCVjg494Ps3
         b8ow==
X-Gm-Message-State: ANhLgQ3r0/2i+s14RFyeF0eIRj3Yu1/Xm615N/mYaBILo/bwryrMVMfM
        gLX8HQZchKhvnlcUgWFpV3gK0Db6ZQM=
X-Google-Smtp-Source: ADFU+vtYtCW0iPZVLpeb30jk0bXnmYSx+4460e9w19V41TQ7e3MKRX7aer27lawwVUy/JBzIhJnUHA==
X-Received: by 2002:a63:7e56:: with SMTP id o22mr6188648pgn.136.1584671521562;
        Thu, 19 Mar 2020 19:32:01 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i124sm3606485pfg.14.2020.03.19.19.32.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2020 19:32:01 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/6] ionic: add timeout error checking for queue disable
Date:   Thu, 19 Mar 2020 19:31:48 -0700
Message-Id: <20200320023153.48655-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320023153.48655-1-snelson@pensando.io>
References: <20200320023153.48655-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Short circuit the cleanup if we get a timeout error from
ionic_qcq_disable() so as to not have to wait too long
on shutdown when we already know the FW is not responding.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 20 ++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 12e3823b0bc1..c62d3d01d5aa 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1425,10 +1425,15 @@ static void ionic_lif_rss_deinit(struct ionic_lif *lif)
 static void ionic_txrx_disable(struct ionic_lif *lif)
 {
 	unsigned int i;
+	int err;
 
 	for (i = 0; i < lif->nxqs; i++) {
-		ionic_qcq_disable(lif->txqcqs[i].qcq);
-		ionic_qcq_disable(lif->rxqcqs[i].qcq);
+		err = ionic_qcq_disable(lif->txqcqs[i].qcq);
+		if (err == -ETIMEDOUT)
+			break;
+		err = ionic_qcq_disable(lif->rxqcqs[i].qcq);
+		if (err == -ETIMEDOUT)
+			break;
 	}
 }
 
@@ -1552,7 +1557,8 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 		ionic_rx_fill(&lif->rxqcqs[i].qcq->q);
 		err = ionic_qcq_enable(lif->rxqcqs[i].qcq);
 		if (err) {
-			ionic_qcq_disable(lif->txqcqs[i].qcq);
+			if (err != -ETIMEDOUT)
+				ionic_qcq_disable(lif->txqcqs[i].qcq);
 			goto err_out;
 		}
 	}
@@ -1561,8 +1567,12 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 err_out:
 	while (i--) {
-		ionic_qcq_disable(lif->rxqcqs[i].qcq);
-		ionic_qcq_disable(lif->txqcqs[i].qcq);
+		err = ionic_qcq_disable(lif->rxqcqs[i].qcq);
+		if (err == -ETIMEDOUT)
+			break;
+		err = ionic_qcq_disable(lif->txqcqs[i].qcq);
+		if (err == -ETIMEDOUT)
+			break;
 	}
 
 	return err;
-- 
2.17.1

