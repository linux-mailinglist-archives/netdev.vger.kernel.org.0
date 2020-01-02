Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1964D12EB59
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 22:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgABV1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 16:27:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:61675 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgABV1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 16:27:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 13:27:08 -0800
X-IronPort-AV: E=Sophos;i="5.69,388,1571727600"; 
   d="scan'208";a="214266298"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 13:27:07 -0800
Date:   Thu, 2 Jan 2020 13:27:06 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     David Miller <davem@davemloft.net>
Cc:     fenghua.yu@intel.com, michael.chan@broadcom.com,
        netdev@vger.kernel.org, tglx@linutronix.de, luto@kernel.org,
        peterz@infradead.org, David.Laight@aculab.com,
        ravi.v.shankar@intel.com
Subject: [Patch v2] drivers/net/b44: Change to non-atomic bit operations on
 pwol_mask
Message-ID: <20200102212706.GA29778@agluck-desk2.amr.corp.intel.com>
References: <1576884551-9518-1-git-send-email-fenghua.yu@intel.com>
 <20191224.161826.37676943451935844.davem@davemloft.net>
 <20191225011020.GE241295@romley-ivt3.sc.intel.com>
 <20191224.182307.2303352806218314412.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224.182307.2303352806218314412.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


From: Fenghua Yu <fenghua.yu@intel.com>

Atomic operations that span cache lines are super-expensive on x86
(not just to the current processor, but also to other processes as all
memory operations are blocked until the operation completes). Upcoming
x86 processors have a switch to cause such operations to generate a #AC
trap. It is expected that some real time systems will enable this mode
in BIOS.

In preparation for this, it is necessary to fix code that may execute
atomic instructions with operands that cross cachelines because the #AC
trap will crash the kernel.

Since "pwol_mask" is local and never exposed to concurrency, there is
no need to set bits in pwol_mask using atomic operations.

Directly operate on the byte which contains the bit instead of using
__set_bit() to avoid any big endian concern due to type cast to
unsigned long in __set_bit().

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Tony: Updated commit comment with background information motivating
this change.  No changes to code.

 drivers/net/ethernet/broadcom/b44.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 035dbb1b2c98..ec25fd81985d 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1516,8 +1516,10 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
 	int ethaddr_bytes = ETH_ALEN;
 
 	memset(ppattern + offset, 0xff, magicsync);
-	for (j = 0; j < magicsync; j++)
-		set_bit(len++, (unsigned long *) pmask);
+	for (j = 0; j < magicsync; j++) {
+		pmask[len >> 3] |= BIT(len & 7);
+		len++;
+	}
 
 	for (j = 0; j < B44_MAX_PATTERNS; j++) {
 		if ((B44_PATTERN_SIZE - len) >= ETH_ALEN)
@@ -1529,7 +1531,8 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
 		for (k = 0; k< ethaddr_bytes; k++) {
 			ppattern[offset + magicsync +
 				(j * ETH_ALEN) + k] = macaddr[k];
-			set_bit(len++, (unsigned long *) pmask);
+			pmask[len >> 3] |= BIT(len & 7);
+			len++;
 		}
 	}
 	return len - 1;
-- 
2.21.0

