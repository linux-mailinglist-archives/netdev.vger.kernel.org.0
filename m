Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E5947DCDB
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346097AbhLWBOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:31 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18442 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345814AbhLWBOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=9GhperGdLp5mSs2oGPGWX3vVh6QZlgVmNWU2J8h4eJY=;
        b=LDUXjoktAgidrqd0DknbCqj+Cq40xD+T0dA+omHvM5a/4tAsOr8lu85ZnBVyl117D4T1
        FF/7RavN0zfbhSOk65PFCRePblFoKBm7YovjdXl36Irqi5OE0cZerC77CMMg778yvMHGOA
        4LQvwb8c/Sa5XuP3gfzg0bWBOzGIC4GeFNSiViaBFUloEd1urrYLDtOBRa8VKL3ZJjDrPe
        HBXWnwHuUWJxbf9WKQZS2ZbRYEtdF9hZLmGCSMNC9oNE7TvGuLp41zLzEMZkmjB3UaN17Q
        vAIQJ6EZkyay17ZVb9Lr0l2llKMvaffc9QCNvyD8Ah15pv21Nq8rtulondgJF2Nw==
Received: by filterdrecv-656998cfdd-vtnvg with SMTP id filterdrecv-656998cfdd-vtnvg-1-61C3CD5E-1E
        2021-12-23 01:14:06.716473164 +0000 UTC m=+7955207.766253174
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-0 (SG)
        with ESMTP
        id FZOMOdXcTZSqSpHTHFO7eA
        Thu, 23 Dec 2021 01:14:06.545 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 3DED070133A; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 19/50] wilc1000: don't tell the chip to go to sleep while
 copying tx packets
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-20-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvP9gs2xqRpyIBtGYR?=
 =?us-ascii?Q?lDavY3uO9Y96GusEhphEvR8U2Or9IV1GN9AtCEU?=
 =?us-ascii?Q?roMXcil4bWWz0vBANOAMeohSevp9gTUzC7KDsTm?=
 =?us-ascii?Q?Wwz7kOcjqSX5SPTtTVv3j2LWDTGlNe2yveWGthd?=
 =?us-ascii?Q?3oSGvjVdQrsHrEdvtco4e9Qhf1R261rzjNz5sy?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Putting the chip to sleep and waking it up again is relatively slow,
so there is no point to put the chip to sleep for the short time it
takes to copy a couple of packets.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 24 +++++++++----------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 54dfb2b9f3524..a6064a85140b4 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -924,29 +924,27 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
 
 	ret = send_vmm_table(wilc, i, vmm_table);
+	if (ret <= 0) {
+		if (ret == 0)
+			/* No VMM space available in firmware.  Inform
+			 * caller to retry later.
+			 */
+			ret = WILC_VMM_ENTRY_FULL_RETRY;
+		goto out_release_bus;
+	}
 
-	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
-
-	if (ret < 0)
-		goto out_unlock;
+	release_bus(wilc, WILC_BUS_RELEASE_ONLY);
 
 	entries = ret;
-	if (entries == 0) {
-		/* No VMM space available in firmware.  Inform caller
-		 * to retry later.
-		 */
-		ret = WILC_VMM_ENTRY_FULL_RETRY;
-		goto out_unlock;
-	}
-
 	len = copy_packets(wilc, entries, vmm_table, vmm_entries_ac);
 	if (len <= 0)
 		goto out_unlock;
 
-	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
 
 	ret = send_packets(wilc, len);
 
+out_release_bus:
 	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 
 out_unlock:
-- 
2.25.1

