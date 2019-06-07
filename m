Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB7039422
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731524AbfFGST2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:19:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53227 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729817AbfFGST1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:19:27 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hZJSS-0007zx-Mn; Fri, 07 Jun 2019 18:19:20 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next][V2] ixgbe: fix potential u32 overflow on shift
Date:   Fri,  7 Jun 2019 19:19:20 +0100
Message-Id: <20190607181920.23339-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The u32 variable rem is being shifted using u32 arithmetic however
it is being passed to div_u64 that expects the expression to be a u64.
The 32 bit shift may potentially overflow, so cast rem to a u64 before
shifting to avoid this.  Also remove comment about overflow.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: cd4583206990 ("ixgbe: implement support for SDP/PPS output on X550 hardware")
Fixes: 68d9676fc04e ("ixgbe: fix PTP SDP pin setup on X540 hardware")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: update comment

---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 2c4d327fcc2e..0be13a90ff79 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -205,11 +205,8 @@ static void ixgbe_ptp_setup_sdp_X540(struct ixgbe_adapter *adapter)
 	 */
 	rem = (NS_PER_SEC - rem);
 
-	/* Adjust the clock edge to align with the next full second. This
-	 * assumes that the cycle counter shift is small enough to avoid
-	 * overflowing when shifting the remainder.
-	 */
-	clock_edge += div_u64((rem << cc->shift), cc->mult);
+	/* Adjust the clock edge to align with the next full second. */
+	clock_edge += div_u64(((u64)rem << cc->shift), cc->mult);
 	trgttiml = (u32)clock_edge;
 	trgttimh = (u32)(clock_edge >> 32);
 
@@ -291,11 +288,8 @@ static void ixgbe_ptp_setup_sdp_X550(struct ixgbe_adapter *adapter)
 	 */
 	rem = (NS_PER_SEC - rem);
 
-	/* Adjust the clock edge to align with the next full second. This
-	 * assumes that the cycle counter shift is small enough to avoid
-	 * overflowing when shifting the remainder.
-	 */
-	clock_edge += div_u64((rem << cc->shift), cc->mult);
+	/* Adjust the clock edge to align with the next full second. */
+	clock_edge += div_u64(((u64)rem << cc->shift), cc->mult);
 
 	/* X550 hardware stores the time in 32bits of 'billions of cycles' and
 	 * 32bits of 'cycles'. There's no guarantee that cycles represents
-- 
2.20.1

