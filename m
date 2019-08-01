Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0E37E59A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 00:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbfHAW0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 18:26:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:14639 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731673AbfHAWZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 18:25:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 15:25:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="324384889"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 01 Aug 2019 15:25:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/11] fm10k: reduce the scope of the local msg variable
Date:   Thu,  1 Aug 2019 15:25:46 -0700
Message-Id: <20190801222548.15975-10-jeffrey.t.kirsher@intel.com>
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

The msg variable in the fm10k_mbx_validate_msg_size and
fm10k_sm_mbx_transmit functions is only used within the do {} loop
scope. Reduce its scope only to where it is used.

This was detected by cppcheck, and resolves the following warnings
produced by that tool:

[fm10k_mbx.c:299]: (style) The scope of the variable 'msg' can be reduced.
[fm10k_mbx.c:2004]: (style) The scope of the variable 'msg' can be reduced.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
index 21021fe4f1c3..aece335b41f8 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
@@ -297,13 +297,14 @@ static u16 fm10k_mbx_validate_msg_size(struct fm10k_mbx_info *mbx, u16 len)
 {
 	struct fm10k_mbx_fifo *fifo = &mbx->rx;
 	u16 total_len = 0, msg_len;
-	u32 *msg;
 
 	/* length should include previous amounts pushed */
 	len += mbx->pushed;
 
 	/* offset in message is based off of current message size */
 	do {
+		u32 *msg;
+
 		msg = fifo->buffer + fm10k_fifo_tail_offset(fifo, total_len);
 		msg_len = FM10K_TLV_DWORD_LEN(*msg);
 		total_len += msg_len;
@@ -1920,7 +1921,6 @@ static void fm10k_sm_mbx_transmit(struct fm10k_hw *hw,
 	/* reduce length by 1 to convert to a mask */
 	u16 mbmem_len = mbx->mbmem_len - 1;
 	u16 tail_len, len = 0;
-	u32 *msg;
 
 	/* push head behind tail */
 	if (mbx->tail < head)
@@ -1930,6 +1930,8 @@ static void fm10k_sm_mbx_transmit(struct fm10k_hw *hw,
 
 	/* determine msg aligned offset for end of buffer */
 	do {
+		u32 *msg;
+
 		msg = fifo->buffer + fm10k_fifo_head_offset(fifo, len);
 		tail_len = len;
 		len += FM10K_TLV_DWORD_LEN(*msg);
-- 
2.21.0

