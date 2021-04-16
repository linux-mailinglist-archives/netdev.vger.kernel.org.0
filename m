Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E94362994
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242067AbhDPUn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:43:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:45471 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239831AbhDPUnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 16:43:40 -0400
IronPort-SDR: KpTNy+F0TN1hq94Oi7hnqT55de6uNBxWcTtV2i6PtO6cy6SeGXCW3ECSDHdPpzUMBWJfz5hMH7
 tLK9Kz+U5vXQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="182234183"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="182234183"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 13:43:13 -0700
IronPort-SDR: nd2kfoOjT4ZIfmKe9ERUGSYNBIgfavq1doNHgQ6IJKM8sGJy7Pnp8Ewiw6q0IEr28rsrrzbIxV
 YPWqC16qEggQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="384425616"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 16 Apr 2021 13:43:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        vitaly.lifshits@intel.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 5/6] igc: Fix overwrites return value
Date:   Fri, 16 Apr 2021 13:44:59 -0700
Message-Id: <20210416204500.2012073-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

drivers/net/ethernet/intel/igc/igc_i225.c:235 igc_write_nvm_srwr()
warn: loop overwrites return value 'ret_val'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_i225.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index cc83bb5c15e8..b2ef9fde97b3 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -229,10 +229,11 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 	if (offset >= nvm->word_size || (words > (nvm->word_size - offset)) ||
 	    words == 0) {
 		hw_dbg("nvm parameter(s) out of bounds\n");
-		goto out;
+		return ret_val;
 	}
 
 	for (i = 0; i < words; i++) {
+		ret_val = -IGC_ERR_NVM;
 		eewr = ((offset + i) << IGC_NVM_RW_ADDR_SHIFT) |
 			(data[i] << IGC_NVM_RW_REG_DATA) |
 			IGC_NVM_RW_REG_START;
@@ -254,7 +255,6 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 		}
 	}
 
-out:
 	return ret_val;
 }
 
-- 
2.26.2

