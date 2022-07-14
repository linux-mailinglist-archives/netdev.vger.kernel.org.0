Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B830B57545A
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiGNSCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239055AbiGNSCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:02:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7780467C83
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657821730; x=1689357730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LQAZslm867twwTmK6CdAmA4kHwSfZikjbqBWQ6R8pkI=;
  b=MeSA0mHvgdR46zihiUYhYdWSNkB3SkXye9P+z938bT4lnEIBlv8tgghi
   DsGvrdZcBQAIHHSL/SYNNymmbqjP/hV1PYr8PtQJOg3fGDE3dJT84RZq4
   otq8U+keLKPY4VLa3sVbYZR4vWSTxpeaasTK1D5zLwbFAN1Isy6PYYzON
   D68L11bfB7M6qEzoADyhKs/Wqma98f2j5jQljf2iGenzBwgBKW9/1Znbf
   QL4ubae8HXptGO0ZyMZdOOw9f5sDY+Zcn0J+75UL1ASwnj6naSqOqPWIP
   I86itD1tPWn09hkb5YpWcXrcGZXTKJKKPro2m0kewjdHg9yMD6bKoikhX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="283151252"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="283151252"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="842235652"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2022 11:01:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Lennert Buytenhek <buytenh@arista.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 3/3] igc: Reinstate IGC_REMOVED logic and implement it properly
Date:   Thu, 14 Jul 2022 10:58:57 -0700
Message-Id: <20220714175857.933537-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714175857.933537-1-anthony.l.nguyen@intel.com>
References: <20220714175857.933537-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lennert Buytenhek <buytenh@wantstofly.org>

The initially merged version of the igc driver code (via commit
146740f9abc4, "igc: Add support for PF") contained the following
IGC_REMOVED checks in the igc_rd32/wr32() MMIO accessors:

	u32 igc_rd32(struct igc_hw *hw, u32 reg)
	{
		u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
		u32 value = 0;

		if (IGC_REMOVED(hw_addr))
			return ~value;

		value = readl(&hw_addr[reg]);

		/* reads should not return all F's */
		if (!(~value) && (!reg || !(~readl(hw_addr))))
			hw->hw_addr = NULL;

		return value;
	}

And:

	#define wr32(reg, val) \
	do { \
		u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
		if (!IGC_REMOVED(hw_addr)) \
			writel((val), &hw_addr[(reg)]); \
	} while (0)

E.g. igb has similar checks in its MMIO accessors, and has a similar
macro E1000_REMOVED, which is implemented as follows:

	#define E1000_REMOVED(h) unlikely(!(h))

These checks serve to detect and take note of an 0xffffffff MMIO read
return from the device, which can be caused by a PCIe link flap or some
other kind of PCI bus error, and to avoid performing MMIO reads and
writes from that point onwards.

However, the IGC_REMOVED macro was not originally implemented:

	#ifndef IGC_REMOVED
	#define IGC_REMOVED(a) (0)
	#endif /* IGC_REMOVED */

This led to the IGC_REMOVED logic to be removed entirely in a
subsequent commit (commit 3c215fb18e70, "igc: remove IGC_REMOVED
function"), with the rationale that such checks matter only for
virtualization and that igc does not support virtualization -- but a
PCIe device can become detached even without virtualization being in
use, and without proper checks, a PCIe bus error affecting an igc
adapter will lead to various NULL pointer dereferences, as the first
access after the error will set hw->hw_addr to NULL, and subsequent
accesses will blindly dereference this now-NULL pointer.

This patch reinstates the IGC_REMOVED checks in igc_rd32/wr32(), and
implements IGC_REMOVED the way it is done for igb, by checking for the
unlikely() case of hw_addr being NULL.  This change prevents the oopses
seen when a PCIe link flap occurs on an igc adapter.

Fixes: 146740f9abc4 ("igc: Add support for PF")
Signed-off-by: Lennert Buytenhek <buytenh@arista.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 drivers/net/ethernet/intel/igc/igc_regs.h | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ae17af44fe02..a5ebee7df4a8 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6171,6 +6171,9 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
 	u32 value = 0;
 
+	if (IGC_REMOVED(hw_addr))
+		return ~value;
+
 	value = readl(&hw_addr[reg]);
 
 	/* reads should not return all F's */
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index e197a33d93a0..026c3b65fc37 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -306,7 +306,8 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg);
 #define wr32(reg, val) \
 do { \
 	u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
-	writel((val), &hw_addr[(reg)]); \
+	if (!IGC_REMOVED(hw_addr)) \
+		writel((val), &hw_addr[(reg)]); \
 } while (0)
 
 #define rd32(reg) (igc_rd32(hw, reg))
@@ -318,4 +319,6 @@ do { \
 
 #define array_rd32(reg, offset) (igc_rd32(hw, (reg) + ((offset) << 2)))
 
+#define IGC_REMOVED(h) unlikely(!(h))
+
 #endif
-- 
2.35.1

