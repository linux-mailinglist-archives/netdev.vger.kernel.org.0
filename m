Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35FA141133
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgAQS4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:56:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:5303 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbgAQS4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 13:56:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 10:56:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="220819576"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jan 2020 10:56:19 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 6/9] fm10k: use txqueue parameter in fm10k_tx_timeout
Date:   Fri, 17 Jan 2020 10:56:14 -0800
Message-Id: <20200117185617.1585693-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
References: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Make use of the new txqueue parameter to the .ndo_tx_timeout function.
In fm10k_tx_timeout, remove the now unnecessary loop to determine which
Tx queue is stuck. Instead, just double check the specified queue

This could be improved further to attempt resetting only the specific
queue that got stuck. However, that is a much larger refactor and has
been left as a future improvement.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index ba2566e2123d..0637ccadee79 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -696,21 +696,24 @@ static netdev_tx_t fm10k_xmit_frame(struct sk_buff *skb, struct net_device *dev)
 /**
  * fm10k_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: the index of the Tx queue that timed out
  **/
 static void fm10k_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 	struct fm10k_intfc *interface = netdev_priv(netdev);
+	struct fm10k_ring *tx_ring;
 	bool real_tx_hang = false;
-	int i;
-
-#define TX_TIMEO_LIMIT 16000
-	for (i = 0; i < interface->num_tx_queues; i++) {
-		struct fm10k_ring *tx_ring = interface->tx_ring[i];
 
-		if (check_for_tx_hang(tx_ring) && fm10k_check_tx_hang(tx_ring))
-			real_tx_hang = true;
+	if (txqueue >= interface->num_tx_queues) {
+		WARN(1, "invalid Tx queue index %d", txqueue);
+		return;
 	}
 
+	tx_ring = interface->tx_ring[txqueue];
+	if (check_for_tx_hang(tx_ring) && fm10k_check_tx_hang(tx_ring))
+		real_tx_hang = true;
+
+#define TX_TIMEO_LIMIT 16000
 	if (real_tx_hang) {
 		fm10k_tx_timeout_reset(interface);
 	} else {
-- 
2.24.1

