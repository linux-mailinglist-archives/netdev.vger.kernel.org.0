Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F5B7E593
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 00:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbfHAWZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 18:25:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:14634 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728885AbfHAWZu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 18:25:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 15:25:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="324384878"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 01 Aug 2019 15:25:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/11] fm10k: reduce the scope of the q_idx local variable
Date:   Thu,  1 Aug 2019 15:25:42 -0700
Message-Id: <20190801222548.15975-6-jeffrey.t.kirsher@intel.com>
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

Reduce the scope of the q_idx local variable in the fm10k_cache_ring_qos
function.

This was detected by cppcheck and resolves the following style warning
produced by that tool:

[fm10k_main.c:2016]: (style) The scope of the variable 'q_idx' can be
reduced.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 9ffff7886085..9e6bddff7625 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
 
 #include <linux/types.h>
 #include <linux/module.h>
@@ -17,7 +17,7 @@ const char fm10k_driver_version[] = DRV_VERSION;
 char fm10k_driver_name[] = "fm10k";
 static const char fm10k_driver_string[] = DRV_SUMMARY;
 static const char fm10k_copyright[] =
-	"Copyright(c) 2013 - 2018 Intel Corporation.";
+	"Copyright(c) 2013 - 2019 Intel Corporation.";
 
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION(DRV_SUMMARY);
@@ -1870,7 +1870,7 @@ static int fm10k_init_msix_capability(struct fm10k_intfc *interface)
 static bool fm10k_cache_ring_qos(struct fm10k_intfc *interface)
 {
 	struct net_device *dev = interface->netdev;
-	int pc, offset, rss_i, i, q_idx;
+	int pc, offset, rss_i, i;
 	u16 pc_stride = interface->ring_feature[RING_F_QOS].mask + 1;
 	u8 num_pcs = netdev_get_num_tc(dev);
 
@@ -1880,7 +1880,8 @@ static bool fm10k_cache_ring_qos(struct fm10k_intfc *interface)
 	rss_i = interface->ring_feature[RING_F_RSS].indices;
 
 	for (pc = 0, offset = 0; pc < num_pcs; pc++, offset += rss_i) {
-		q_idx = pc;
+		int q_idx = pc;
+
 		for (i = 0; i < rss_i; i++) {
 			interface->tx_ring[offset + i]->reg_idx = q_idx;
 			interface->tx_ring[offset + i]->qos_pc = pc;
-- 
2.21.0

