Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10FAB14B2
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 21:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfILTHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 15:07:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:52976 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbfILTHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 15:07:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 12:07:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,498,1559545200"; 
   d="scan'208";a="192514274"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Sep 2019 12:07:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Shannon Nelson <snelson@pensando.io>,
        Jonathan Tooker <jonathan@reliablehosting.com>
Subject: [net] ixgbevf: Fix secpath usage for IPsec Tx offload
Date:   Thu, 12 Sep 2019 12:07:34 -0700
Message-Id: <20190912190734.10560-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port the same fix for ixgbe to ixgbevf.

The ixgbevf driver currently does IPsec Tx offloading
based on an existing secpath. However, the secpath
can also come from the Rx side, in this case it is
misinterpreted for Tx offload and the packets are
dropped with a "bad sa_idx" error. Fix this by using
the xfrm_offload() function to test for Tx offload.

CC: Shannon Nelson <snelson@pensando.io>
Fixes: 7f68d4306701 ("ixgbevf: enable VF IPsec offload operations")
Reported-by: Jonathan Tooker <jonathan@reliablehosting.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index d2b41f9f87f8..72872d6ca80c 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -30,6 +30,7 @@
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/atomic.h>
+#include <net/xfrm.h>
 
 #include "ixgbevf.h"
 
@@ -4161,7 +4162,7 @@ static int ixgbevf_xmit_frame_ring(struct sk_buff *skb,
 	first->protocol = vlan_get_protocol(skb);
 
 #ifdef CONFIG_IXGBEVF_IPSEC
-	if (secpath_exists(skb) && !ixgbevf_ipsec_tx(tx_ring, first, &ipsec_tx))
+	if (xfrm_offload(skb) && !ixgbevf_ipsec_tx(tx_ring, first, &ipsec_tx))
 		goto out_drop;
 #endif
 	tso = ixgbevf_tso(tx_ring, first, &hdr_len, &ipsec_tx);
-- 
2.21.0

