Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1DE1653ED
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbgBTA5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:57:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:33266 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbgBTA5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 19:57:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 16:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="408621341"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga005.jf.intel.com with ESMTP; 19 Feb 2020 16:57:14 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/12] e1000e: fix missing cpu_to_le64 on buffer_addr
Date:   Wed, 19 Feb 2020 16:57:02 -0800
Message-Id: <20200220005713.682605-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
References: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>

The following warning suggests there is a missing cpu_to_le64() in
the e1000_flush_tx_ring() function (it is also the behaviour
elsewhere in the driver to do cpu_to_le64() on the buffer_addr
when setting it)

drivers/net/ethernet/intel/e1000e/netdev.c:3813:30: warning: incorrect type in assignment (different base types)
drivers/net/ethernet/intel/e1000e/netdev.c:3813:30:    expected restricted __le64 [usertype] buffer_addr
drivers/net/ethernet/intel/e1000e/netdev.c:3813:30:    got unsigned long long [usertype] dma

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index db4ea58bac82..618c218978fe 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3807,7 +3807,7 @@ static void e1000_flush_tx_ring(struct e1000_adapter *adapter)
 	tdt = er32(TDT(0));
 	BUG_ON(tdt != tx_ring->next_to_use);
 	tx_desc =  E1000_TX_DESC(*tx_ring, tx_ring->next_to_use);
-	tx_desc->buffer_addr = tx_ring->dma;
+	tx_desc->buffer_addr = cpu_to_le64(tx_ring->dma);
 
 	tx_desc->lower.data = cpu_to_le32(txd_lower | size);
 	tx_desc->upper.data = 0;
-- 
2.24.1

