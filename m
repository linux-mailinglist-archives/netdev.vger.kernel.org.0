Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F5E391DFD
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhEZRYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:24:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:18091 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234254AbhEZRXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:23:48 -0400
IronPort-SDR: p0kcMBCO3m0ECwRA8w5JAhXJ3rTRKAKoi41tvU5rfYwN5Uwlw1Q8BNBiySEoBw+xEDiCVRtewK
 Os1omBulK1qg==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266415789"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="266415789"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 10:21:27 -0700
IronPort-SDR: +RyhQGVWcyKR3btd04tgkrXUE0UIMQEmGQLqdXblN27QgFFW4wzqfe2Ih1hkLLd5LRdGyb9XQ5
 ZoZNDE/FQPFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="443149212"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2021 10:21:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 06/11] igb: fix assignment on big endian machines
Date:   Wed, 26 May 2021 10:23:41 -0700
Message-Id: <20210526172346.3515587-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The igb driver was trying hard to be sparse correct, but somehow
ended up converting a variable into little endian order and then
tries to OR something with it.

A much plainer way of doing things is to leave all variables and
OR operations in CPU (non-endian) mode, and then convert to
little endian only once, which is what this change does.

This probably fixes a bug that might have been seen only on
big endian systems.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Warning Detail:
.../igb/igb_main.c:6286:23: warning: incorrect type in assignment (different base types)
.../igb/igb_main.c:6286:23:    expected unsigned int [usertype] olinfo_status
.../igb/igb_main.c:6286:23:    got restricted __le32 [usertype]
.../igb/igb_main.c:6291:37: warning: incorrect type in assignment (different base types)
.../igb/igb_main.c:6291:37:    expected restricted __le32 [usertype] olinfo_status
.../igb/igb_main.c:6291:37:    got unsigned int [assigned] [usertype] olinfo_status
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 3a96b61a7229..f555670e9271 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6276,12 +6276,12 @@ int igb_xmit_xdp_ring(struct igb_adapter *adapter,
 	cmd_type |= len | IGB_TXD_DCMD;
 	tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
 
-	olinfo_status = cpu_to_le32(len << E1000_ADVTXD_PAYLEN_SHIFT);
+	olinfo_status = len << E1000_ADVTXD_PAYLEN_SHIFT;
 	/* 82575 requires a unique index per ring */
 	if (test_bit(IGB_RING_FLAG_TX_CTX_IDX, &tx_ring->flags))
 		olinfo_status |= tx_ring->reg_idx << 4;
 
-	tx_desc->read.olinfo_status = olinfo_status;
+	tx_desc->read.olinfo_status = cpu_to_le32(olinfo_status);
 
 	netdev_tx_sent_queue(txring_txq(tx_ring), tx_buffer->bytecount);
 
-- 
2.26.2

