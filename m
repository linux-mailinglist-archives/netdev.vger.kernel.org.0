Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97EB3F5C75
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfKIAoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:44:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:25215 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfKIAod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 19:44:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 16:44:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="215111202"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2019 16:44:31 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 4/6] igb/igc: use ktime accessors for skb->tstamp
Date:   Fri,  8 Nov 2019 16:44:28 -0800
Message-Id: <20191109004430.7219-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
References: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When implementing launch time support in the igb and igc drivers, the
skb->tstamp value is assumed to be a s64, but it's declared as a ktime_t
value.

Although ktime_t is typedef'd to s64 it wasn't always, and the kernel
provides accessors for ktime_t values.

Use the ktime_to_timespec64 and ktime_set accessors instead of directly
assuming that the variable is always an s64.

This improves portability if the code is ever moved to another kernel
version, or if the definition of ktime_t ever changes again in the
future.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h | 2 ++
 drivers/net/ethernet/intel/igb/igb_main.c         | 4 ++--
 drivers/net/ethernet/intel/igc/igc_main.c         | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 530613f31527..69a2daaca5c5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -20,6 +20,8 @@
 
 /* API version 1.7 implements additional link and PHY-specific APIs  */
 #define I40E_MINOR_VER_GET_LINK_INFO_XL710 0x0007
+/* API version 1.9 for X722 implements additional link and PHY-specific APIs */
+#define I40E_MINOR_VER_GET_LINK_INFO_X722 0x0009
 /* API version 1.6 for X722 devices adds ability to stop FW LLDP agent */
 #define I40E_MINOR_VER_FW_LLDP_STOPPABLE_X722 0x0006
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 9148c62d9ac5..ed7e667d7eb2 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5675,8 +5675,8 @@ static void igb_tx_ctxtdesc(struct igb_ring *tx_ring,
 	 * should have been handled by the upper layers.
 	 */
 	if (tx_ring->launchtime_enable) {
-		ts = ns_to_timespec64(first->skb->tstamp);
-		first->skb->tstamp = 0;
+		ts = ktime_to_timespec64(first->skb->tstamp);
+		first->skb->tstamp = ktime_set(0, 0);
 		context_desc->seqnum_seed = cpu_to_le32(ts.tv_nsec / 32);
 	} else {
 		context_desc->seqnum_seed = 0;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 8e424dfab12e..24888676f69b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -824,8 +824,8 @@ static void igc_tx_ctxtdesc(struct igc_ring *tx_ring,
 	 * should have been handled by the upper layers.
 	 */
 	if (tx_ring->launchtime_enable) {
-		ts = ns_to_timespec64(first->skb->tstamp);
-		first->skb->tstamp = 0;
+		ts = ktime_to_timespec64(first->skb->tstamp);
+		first->skb->tstamp = ktime_set(0, 0);
 		context_desc->launch_time = cpu_to_le32(ts.tv_nsec / 32);
 	} else {
 		context_desc->launch_time = 0;
-- 
2.21.0

