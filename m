Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C49286650
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgJGRzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:55:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:18440 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728770AbgJGRzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:55:01 -0400
IronPort-SDR: 0S0EBdTrjt8dAZfxb/g4Gnb06GX2zyYCmrRrNK/4JJIHAtxIIQy2ANiCFuVl/uqNZfTm/qa2AW
 0SZHUzsj3XAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="144957658"
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="144957658"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:59 -0700
IronPort-SDR: H7tzg2OIO+2uhoY67Ib/yJhY82PEzhbC6MAIskRfqVou8wFlD7ARuyXjVJV7rigMFtvW3VjZS4
 hJ0SPw5wDknQ==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="518935797"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 7/8] ice: Fix pointer cast warnings
Date:   Wed,  7 Oct 2020 10:54:46 -0700
Message-Id: <20201007175447.647867-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
References: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

pointers should be casted to unsigned long to avoid
-Wpointer-to-int-cast warnings:

drivers/net/ethernet/intel/ice/ice_flow.h:197:33: warning:
    cast from pointer to integer of different size
drivers/net/ethernet/intel/ice/ice_flow.h:198:32: warning:
    cast to pointer from integer of different size

Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 3913da2116d2..829f90b1e998 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -194,8 +194,8 @@ struct ice_flow_entry {
 	u16 entry_sz;
 };
 
-#define ICE_FLOW_ENTRY_HNDL(e)	((u64)e)
-#define ICE_FLOW_ENTRY_PTR(h)	((struct ice_flow_entry *)(h))
+#define ICE_FLOW_ENTRY_HNDL(e)	((u64)(uintptr_t)e)
+#define ICE_FLOW_ENTRY_PTR(h)	((struct ice_flow_entry *)(uintptr_t)(h))
 
 struct ice_flow_prof {
 	struct list_head l_entry;
-- 
2.26.2

