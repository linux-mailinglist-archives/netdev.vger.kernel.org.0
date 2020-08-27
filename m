Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889F42551B4
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgH0Xoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgH0Xod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:44:33 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8922BC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:44:33 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o13so4497004pgf.0
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=phqYOX/CM3XeWGKEQOKORctpyB1xWswzP10PkeVDExE=;
        b=SPcIdblbtJuSxCKmdnHzzCc3gzCfFydwa/AnQWyzF0TO/iyNAT81dPPE/XuEmQjQR9
         jDiRqN22o49gpseJZfl4beXk7+DKvJM2EXo+AGNtazu+FMsco0o3exgqf0c6m3OIU6Dh
         IHmBfBu9XUw4KDcOjgcNGOmiWdehM0WOZW+8P9mOxdCkk5f8UWidUictRXkFay1eOxqy
         bkJigTwR1rnyB4IKTPrG5qN4izNr/mWL9sWXtmmZutmn/yScWOsszDDPW6s9FDFZKJXO
         xC1EyS8prdnWKD0bd7KlILRhGg6ZSwSIHK1xTMoJGHLCrznTUYh4bzBqmYIruByh9nua
         dkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=phqYOX/CM3XeWGKEQOKORctpyB1xWswzP10PkeVDExE=;
        b=AfOz6j4qcizcrAI6MQVYOxIoIVZ8cdlgEV7LAg9qnJL+bxs8xPQi/hF4uptnrMOFBO
         bLnNkvEOP7Ala0G+7tK0CSL7tc7MESe1fQOvmtcH7gBGyWcrAG0MwChU9aoSCR2VXfeg
         mFYB5/QdbmziIqCdP1RbOu1pYWAulHW7AKHlppekfibUcJieGX2W15+ohhZ7Q6KHQflN
         tpL5rQ4CAzxFhJ2M7BHgD7Zv3IBjLXThEq7A61TTNTzzZLrt4UG6XnN1TaqDcFu54MAw
         vf9F/lZVKUsSR9HGvi/UcaRQXWZuocoD30mAMAd1ZpPc87wCCdye9kdR56aX+XtwWQjG
         osjA==
X-Gm-Message-State: AOAM531SQI4dlwTCoiJEYppREiM/uWmallxhpbjs7n8XR4SC6dAJgLSe
        ga7ijCz3xsULk641kjBx38T2JnBsyzff4Q==
X-Google-Smtp-Source: ABdhPJwqbM9lrzHIvx4b5uAheimsQvu4EeToucKcvl+hqpqQUX9NSLNaSmFOVkNccXpcJ92oa1s++A==
X-Received: by 2002:a63:384b:: with SMTP id h11mr3043911pgn.113.1598571870632;
        Thu, 27 Aug 2020 16:44:30 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id l22sm4434118pfc.27.2020.08.27.16.44.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 16:44:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: fix txrx work accounting
Date:   Thu, 27 Aug 2020 16:44:22 -0700
Message-Id: <20200827234422.47351-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take the tx accounting out of the work_done calculation to
prevent a possible duplicate napi_schedule call when under
high Tx stress but low Rx traffic.

Fixes: b14e4e95f9ec ("ionic: tx separate servicing")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 8107d32c2767..def65fee27b5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -496,9 +496,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	struct ionic_cq *txcq;
 	u32 rx_work_done = 0;
 	u32 tx_work_done = 0;
-	u32 work_done = 0;
 	u32 flags = 0;
-	bool unmask;
 
 	lif = rxcq->bound_q->lif;
 	idev = &lif->ionic->idev;
@@ -512,17 +510,12 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	if (rx_work_done)
 		ionic_rx_fill_cb(rxcq->bound_q);
 
-	unmask = (rx_work_done < budget) && (tx_work_done < lif->tx_budget);
-
-	if (unmask && napi_complete_done(napi, rx_work_done)) {
+	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
 		flags |= IONIC_INTR_CRED_UNMASK;
 		DEBUG_STATS_INTR_REARM(rxcq->bound_intr);
-		work_done = rx_work_done;
-	} else {
-		work_done = budget;
 	}
 
-	if (work_done || flags) {
+	if (rx_work_done || flags) {
 		flags |= IONIC_INTR_CRED_RESET_COALESCE;
 		ionic_intr_credits(idev->intr_ctrl, rxcq->bound_intr->index,
 				   tx_work_done + rx_work_done, flags);
@@ -531,7 +524,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	DEBUG_STATS_NAPI_POLL(qcq, rx_work_done);
 	DEBUG_STATS_NAPI_POLL(qcq, tx_work_done);
 
-	return work_done;
+	return rx_work_done;
 }
 
 static dma_addr_t ionic_tx_map_single(struct ionic_queue *q,
-- 
2.17.1

