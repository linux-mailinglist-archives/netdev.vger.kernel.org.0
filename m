Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6327D80AC1
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 13:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfHDL7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 07:59:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:50580 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbfHDL7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 07:59:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Aug 2019 04:59:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,345,1559545200"; 
   d="scan'208";a="178602040"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 04 Aug 2019 04:59:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 8/8] fm10k: fix fm10k_get_fault_pf to read correct address
Date:   Sun,  4 Aug 2019 04:59:26 -0700
Message-Id: <20190804115926.31944-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
References: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Fix assignment of the FM10K_FAULT_ADDR_LO register into fault->address
by using a bit-wise |= operation. Without this, the low address is
completely overwriting the high potion of the address. This caused the
fault to incorrectly return only the lower 32 bits of the fault address.

This issue was detected by cppcheck and resolves the following warnings
produced by that tool:

[fm10k_pf.c:1668] -> [fm10k_pf.c:1670]: (style) Variable
'fault->address' is reassigned a value before the old one has been used.

[fm10k_pf.c:1669] -> [fm10k_pf.c:1670]: (style) Variable
'fault->address' is reassigned a value before the old one has been used.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
index 095c5b0e4096..be07bfdb0bb4 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
@@ -1565,7 +1565,7 @@ static s32 fm10k_get_fault_pf(struct fm10k_hw *hw, int type,
 	/* read remaining fields */
 	fault->address = fm10k_read_reg(hw, type + FM10K_FAULT_ADDR_HI);
 	fault->address <<= 32;
-	fault->address = fm10k_read_reg(hw, type + FM10K_FAULT_ADDR_LO);
+	fault->address |= fm10k_read_reg(hw, type + FM10K_FAULT_ADDR_LO);
 	fault->specinfo = fm10k_read_reg(hw, type + FM10K_FAULT_SPECINFO);
 
 	/* clear valid bit to allow for next error */
-- 
2.21.0

