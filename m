Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 374911250CA
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfLRSiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:38:54 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42477 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLRSix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:38:53 -0500
Received: by mail-qk1-f193.google.com with SMTP id z14so1172490qkg.9
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 10:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b0ybn8DuKtuB1EcL3f+qtWsIuALB19x61Jlk3bJVMfI=;
        b=ADTZFaSZJGOJUWHzgN/Cy370WYK5eyFQpHbiYqCqvc3FxECvME40KHKMiV+iqqcEDE
         MswTEXHwX9xQIJsspYmDlMMWhhLgqjQFo0i7Bssfpfg9suFdaMBZzQfeTgvZFjwrzXLa
         FT6a0grylHn64/b9DtahjlH4D4V2WwGBvt+fAFW5SwytWG2WaVqb4GFflsgXIJOJ9D61
         3FfP4/tzlcdXO8eOdFLQAfI7BG9o7rLxgfEMqC/coNzoUPFTvBubOsOVr3Z5WoAo5UI3
         Khd71eUTrAhO0pfMfg5lSr51pJgV8LLVzyNfSPpsfh4DUkmz8TF1H0zm6jJbGQgOASQm
         dXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b0ybn8DuKtuB1EcL3f+qtWsIuALB19x61Jlk3bJVMfI=;
        b=lCWeGEuBTFrDujGrqyx54WbylmyjBRZn+ki1tE8COQ6fSqrh4OQBDdTm8B96xnQOyn
         jryVhiqS/yd/z67+KJQdPMy5w0lfEs4BIc+YQTbFXTzBxiRR/mo16Mxjp5L2j7sgEADD
         jz1BFlPqlH7y6zmmzn1Qe9TRFpOrjaS01cObdFgOmQQVHJ3m9hgmEDN0UtT+WaQobeb0
         hxL8+YgdyXOwkw5lREvoXdTyn/ghN7Cq6AUMRMu9tBYtVf4dECEJiXgan5GDMjcVvY/J
         EcTHPLltNxUd5iQ55MPZM9VqtqvamEW0FFPwFBrWeCEmLT+W9iXlVQKv0Uie/ZAlPI8w
         /Rkg==
X-Gm-Message-State: APjAAAUgLeNmutvMGhPOVbQgaCQvgRua0WcYHVdoemBj0fMz9oAVXgZ8
        L40ObSy1C+0qmlrANnflDTw2KRWn
X-Google-Smtp-Source: APXvYqwFxlMn2WZQ8whnAGXKDowPFy4vMN6IV3I72cyVS5ppiu/ab5cHjfYERpD6WgLViQ8yUBqIjQ==
X-Received: by 2002:a37:a70b:: with SMTP id q11mr4027437qke.393.1576694332281;
        Wed, 18 Dec 2019 10:38:52 -0800 (PST)
Received: from ubuntu.default (201-42-108-210.dsl.telesp.net.br. [201.42.108.210])
        by smtp.gmail.com with ESMTPSA id s11sm890049qkg.99.2019.12.18.10.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 10:38:51 -0800 (PST)
From:   Julio Faracco <jcfaracco@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 1/2] drivers: net: i40e: Removing hung_queue variable to use txqueue function parameter
Date:   Wed, 18 Dec 2019 15:38:44 -0300
Message-Id: <20191218183845.20038-2-jcfaracco@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218183845.20038-1-jcfaracco@gmail.com>
References: <20191218183845.20038-1-jcfaracco@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The scope of function .ndo_tx_timeout was changed to include the hang
queue when a TX timeout event occurs. See commit 0290bd291cc0
("netdev: pass the stuck queue to the timeout handler") for more
details. Now, drivers don't need to identify which queue is stopped.
Drivers can simply use the queue index provided bt dev_watchdog and
execute all actions needed to restore network traffic. This commit do
some cleanups into Intel i40e driver to remove a redundant loop to find
stopped queue.

Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 41 ++++++---------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4c9ac6c80eb8..71fedee21488 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -307,37 +307,18 @@ static void i40e_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
 	struct i40e_ring *tx_ring = NULL;
-	unsigned int i, hung_queue = 0;
+	unsigned int i;
 	u32 head, val;
 
 	pf->tx_timeout_count++;
 
-	/* find the stopped queue the same way the stack does */
-	for (i = 0; i < netdev->num_tx_queues; i++) {
-		struct netdev_queue *q;
-		unsigned long trans_start;
-
-		q = netdev_get_tx_queue(netdev, i);
-		trans_start = q->trans_start;
-		if (netif_xmit_stopped(q) &&
-		    time_after(jiffies,
-			       (trans_start + netdev->watchdog_timeo))) {
-			hung_queue = i;
-			break;
-		}
-	}
-
-	if (i == netdev->num_tx_queues) {
-		netdev_info(netdev, "tx_timeout: no netdev hung queue found\n");
-	} else {
-		/* now that we have an index, find the tx_ring struct */
-		for (i = 0; i < vsi->num_queue_pairs; i++) {
-			if (vsi->tx_rings[i] && vsi->tx_rings[i]->desc) {
-				if (hung_queue ==
-				    vsi->tx_rings[i]->queue_index) {
-					tx_ring = vsi->tx_rings[i];
-					break;
-				}
+	/* with txqueue index, find the tx_ring struct */
+	for (i = 0; i < vsi->num_queue_pairs; i++) {
+		if (vsi->tx_rings[i] && vsi->tx_rings[i]->desc) {
+			if (txqueue ==
+			    vsi->tx_rings[i]->queue_index) {
+				tx_ring = vsi->tx_rings[i];
+				break;
 			}
 		}
 	}
@@ -363,14 +344,14 @@ static void i40e_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 			val = rd32(&pf->hw, I40E_PFINT_DYN_CTL0);
 
 		netdev_info(netdev, "tx_timeout: VSI_seid: %d, Q %d, NTC: 0x%x, HWB: 0x%x, NTU: 0x%x, TAIL: 0x%x, INT: 0x%x\n",
-			    vsi->seid, hung_queue, tx_ring->next_to_clean,
+			    vsi->seid, txqueue, tx_ring->next_to_clean,
 			    head, tx_ring->next_to_use,
 			    readl(tx_ring->tail), val);
 	}
 
 	pf->tx_timeout_last_recovery = jiffies;
-	netdev_info(netdev, "tx_timeout recovery level %d, hung_queue %d\n",
-		    pf->tx_timeout_recovery_level, hung_queue);
+	netdev_info(netdev, "tx_timeout recovery level %d, txqueue %d\n",
+		    pf->tx_timeout_recovery_level, txqueue);
 
 	switch (pf->tx_timeout_recovery_level) {
 	case 1:
-- 
2.17.1

