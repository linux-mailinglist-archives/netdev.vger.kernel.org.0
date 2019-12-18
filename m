Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74F61250CB
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfLRSi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:38:56 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:37345 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLRSi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:38:56 -0500
Received: by mail-qv1-f67.google.com with SMTP id f16so1158040qvi.4
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 10:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m3KJbj/2ipgtN2cLNIjJ62WUMegElStcycrQCWUakW4=;
        b=MSod8UrmGdVJcpGg5iDEGZEtucemBJMcZxQmQYHXEpGTzHGcU2uAmJ23swilPdBgKA
         +fQOyPNtm2TiqHF+nx+b44JXeIbxxgj6RJ1iClk6Ms1xWT/sfZ15KotqZaIe0rNU7ZJj
         LNZNLuCZFH2LRkVnNPiYyMljy50xh7TIYIpVrJm9dRi+f+eevOF+SnrausJSM7WHHxMP
         FC0NckbJHpEhLKYBthPX4C6NWog8fMbqYlsVFGTra/n5KuECW3apBwB3ZoNqHbpbQQLj
         4eeSQmSUpOOfLoo160Ld0ZbqjEG6mtBHciR9aE3RMI5bbPXOmv6axh1GzLsBxR54Ylxk
         H+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m3KJbj/2ipgtN2cLNIjJ62WUMegElStcycrQCWUakW4=;
        b=KpQLwVPn5j0arxx3Lp5MijcNdIywB0H+eFcTdtLf+PPsEpCwE59TnmQHsZ9nx60Y2G
         Ew3tv92go1L4No/LldKnNDL3ibPOwNAt3hW927KZbd1oNdzrCNQ8AhU2KRT6TwrI48nt
         HHlmuj5QwMZlYioWL27ZPgBNa+GGUtXVmmVAW239XQ3gd+ptE41gsSXYlksGgZ3HwV46
         OLthI2a/zag5rIJ8BYsdjfhixVs0kuQrA4M4NMmRnEe+n2znNNWMfl/s94bRy5JzSuWl
         SD+gnru9efqieOoIFFcAh/Iv4kQFfhyomO0SmMfOdRnAsXGEZCUzYKhHsLouffJnb/WD
         5IRg==
X-Gm-Message-State: APjAAAVC8xE0XFwlhYsk7gFJ+xZN6nil6qnQpVFU8ILXjErJXM8Y3pOF
        1Knn5Sq+6zTYgUtEYX2+IojIipYe
X-Google-Smtp-Source: APXvYqyZCbO5O2rsw8OAW3WcqAf9alCRDuH3LbXiMGAi+iRjJ0DPd94k6pVWzpzcTnZOMphkvFTv8g==
X-Received: by 2002:a0c:8d0a:: with SMTP id r10mr3586051qvb.7.1576694334723;
        Wed, 18 Dec 2019 10:38:54 -0800 (PST)
Received: from ubuntu.default (201-42-108-210.dsl.telesp.net.br. [201.42.108.210])
        by smtp.gmail.com with ESMTPSA id s11sm890049qkg.99.2019.12.18.10.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 10:38:54 -0800 (PST)
From:   Julio Faracco <jcfaracco@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 2/2] drivers: net: ice: Removing hung_queue variable to use txqueue function parameter
Date:   Wed, 18 Dec 2019 15:38:45 -0300
Message-Id: <20191218183845.20038-3-jcfaracco@gmail.com>
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
some cleanups into Intel ice driver to remove a redundant loop to find
stopped queue.

Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 41 ++++++-----------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4d5220c9c721..2d7ecdc157be 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5066,36 +5066,17 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	struct ice_ring *tx_ring = NULL;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
-	int hung_queue = -1;
 	u32 i;
 
 	pf->tx_timeout_count++;
 
-	/* find the stopped queue the same way dev_watchdog() does */
-	for (i = 0; i < netdev->num_tx_queues; i++) {
-		unsigned long trans_start;
-		struct netdev_queue *q;
-
-		q = netdev_get_tx_queue(netdev, i);
-		trans_start = q->trans_start;
-		if (netif_xmit_stopped(q) &&
-		    time_after(jiffies,
-			       trans_start + netdev->watchdog_timeo)) {
-			hung_queue = i;
-			break;
-		}
-	}
-
-	if (i == netdev->num_tx_queues)
-		netdev_info(netdev, "tx_timeout: no netdev hung queue found\n");
-	else
-		/* now that we have an index, find the tx_ring struct */
-		for (i = 0; i < vsi->num_txq; i++)
-			if (vsi->tx_rings[i] && vsi->tx_rings[i]->desc)
-				if (hung_queue == vsi->tx_rings[i]->q_index) {
-					tx_ring = vsi->tx_rings[i];
-					break;
-				}
+	/* now that we have an index, find the tx_ring struct */
+	for (i = 0; i < vsi->num_txq; i++)
+		if (vsi->tx_rings[i] && vsi->tx_rings[i]->desc)
+			if (txqueue == vsi->tx_rings[i]->q_index) {
+				tx_ring = vsi->tx_rings[i];
+				break;
+			}
 
 	/* Reset recovery level if enough time has elapsed after last timeout.
 	 * Also ensure no new reset action happens before next timeout period.
@@ -5110,19 +5091,19 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 		struct ice_hw *hw = &pf->hw;
 		u32 head, val = 0;
 
-		head = (rd32(hw, QTX_COMM_HEAD(vsi->txq_map[hung_queue])) &
+		head = (rd32(hw, QTX_COMM_HEAD(vsi->txq_map[txqueue])) &
 			QTX_COMM_HEAD_HEAD_M) >> QTX_COMM_HEAD_HEAD_S;
 		/* Read interrupt register */
 		val = rd32(hw, GLINT_DYN_CTL(tx_ring->q_vector->reg_idx));
 
 		netdev_info(netdev, "tx_timeout: VSI_num: %d, Q %d, NTC: 0x%x, HW_HEAD: 0x%x, NTU: 0x%x, INT: 0x%x\n",
-			    vsi->vsi_num, hung_queue, tx_ring->next_to_clean,
+			    vsi->vsi_num, txqueue, tx_ring->next_to_clean,
 			    head, tx_ring->next_to_use, val);
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

