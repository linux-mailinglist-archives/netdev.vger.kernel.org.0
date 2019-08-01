Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D18D7E59C
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 00:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732085AbfHAW0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 18:26:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:14634 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731576AbfHAWZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 18:25:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 15:25:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="324384887"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 01 Aug 2019 15:25:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/11] fm10k: reduce the scope of the local i variable
Date:   Thu,  1 Aug 2019 15:25:45 -0700
Message-Id: <20190801222548.15975-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
References: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Reduce the scope of the local loop variable in the
fm10k_check_hang_subtask function.

This was detected by cppcheck and resolves the following warning
produced by that tool:

[driver/fm10k_pci.c:852]: (style) The scope of the variable 'i' can be
reduced.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index 9421832c2480..9522e9f8f8b8 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -698,8 +698,6 @@ static void fm10k_watchdog_subtask(struct fm10k_intfc *interface)
  */
 static void fm10k_check_hang_subtask(struct fm10k_intfc *interface)
 {
-	int i;
-
 	/* If we're down or resetting, just bail */
 	if (test_bit(__FM10K_DOWN, interface->state) ||
 	    test_bit(__FM10K_RESETTING, interface->state))
@@ -711,6 +709,8 @@ static void fm10k_check_hang_subtask(struct fm10k_intfc *interface)
 	interface->next_tx_hang_check = jiffies + (2 * HZ);
 
 	if (netif_carrier_ok(interface->netdev)) {
+		int i;
+
 		/* Force detection of hung controller */
 		for (i = 0; i < interface->num_tx_queues; i++)
 			set_check_for_tx_hang(interface->tx_ring[i]);
-- 
2.21.0

