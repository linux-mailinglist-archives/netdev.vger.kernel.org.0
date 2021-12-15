Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AB94761D2
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhLOTfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:35:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:59490 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhLOTfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 14:35:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639596948; x=1671132948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2xZkHFxW3aXrQQg90KbsZSAS52xeC5fAipuud9vCIOo=;
  b=K69gG+bQajuh3JMcuQXDEWlE7sdiuVIs0t4NJVUIjTcuCw3CtMHJlrb8
   rHovFCQMXyIZQHN2gaas0twH9Rv+6s5N13Exydw/Y1CQ3dxySy3hh7VjH
   4Hu47WEy3mUvbyqS+92O9Wq4SLrH9wWxnefoys6ToZScLlh/2B+KQr7yr
   H456zvOWGQ16NVsC32pxa7/O2ILmTheinwqIFqlb+Hc/OTq0jzvuPud4u
   MIiLWYNjlCgFSg69/pfrwOw/xo6zA0RinbLNxnpCjRihbW2/XRlwoqIgR
   yj0nNnoG4fW++ZrtyGOG4gCcvwSjtTBgYdncA1RSmIVEhCr9n+vrYJ6Nu
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="236856410"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="236856410"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 11:35:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465746699"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 11:35:30 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net 3/5] igc: Fix typo in i225 LTR functions
Date:   Wed, 15 Dec 2021 11:34:32 -0800
Message-Id: <20211215193434.3253664-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
References: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

The LTR maximum value was incorrectly written using the scale from
the LTR minimum value. This would cause incorrect values to be sent,
in cases where the initial calculation lead to different min/max scales.

Fixes: 707abf069548 ("igc: Add initial LTR support")
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_i225.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index b2ef9fde97b3..b6807e16eea9 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -636,7 +636,7 @@ s32 igc_set_ltr_i225(struct igc_hw *hw, bool link)
 		ltrv = rd32(IGC_LTRMAXV);
 		if (ltr_max != (ltrv & IGC_LTRMAXV_LTRV_MASK)) {
 			ltrv = IGC_LTRMAXV_LSNP_REQ | ltr_max |
-			       (scale_min << IGC_LTRMAXV_SCALE_SHIFT);
+			       (scale_max << IGC_LTRMAXV_SCALE_SHIFT);
 			wr32(IGC_LTRMAXV, ltrv);
 		}
 	}
-- 
2.31.1

