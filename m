Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729C553BC12
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiFBQEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236753AbiFBQED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:04:03 -0400
X-Greylist: delayed 344 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Jun 2022 09:03:59 PDT
Received: from mail.wantstofly.org (hmm.wantstofly.org [213.239.204.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F21C21FBC5
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:03:58 -0700 (PDT)
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id C70227F546; Thu,  2 Jun 2022 18:58:11 +0300 (EEST)
Date:   Thu, 2 Jun 2022 18:58:11 +0300
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     intel-wired-lan@lists.osuosl.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH v1] igc: Reinstate IGC_REMOVED logic and implement it properly
Message-ID: <YpjeEyMxobCIRfTx@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
As initially reported on intel-wired-lan@ in February:

	https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20220214/027787.html

We're seeing these NULL pointer dereferences hit fairly reproducibly
when rebooting, presumably due to the particularities of reset
sequencing on the boards we see this hit on.

A link flap can be caused by toggling the Secondary Bus Reset bit
in the upstream PCIe bridge's Bridge Control register and can reliably
reproduce this problem.

 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 drivers/net/ethernet/intel/igc/igc_regs.h | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 74b2c590ed5d..38e46e9ba8bb 100644
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
2.36.1
