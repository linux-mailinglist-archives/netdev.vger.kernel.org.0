Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFA1479E4F
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhLRXyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:38 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25762 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbhLRXy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=o7oSOnb8F57kKru8yGwzxIQp/4qaa84HAsOuc9Qe3GU=;
        b=J3QHPiVAo7ftDRJZFh6x1ZM1eGaPXQOxPM9uWB7T+EVAHEkQUh8FOH1lIBHIXOvL0Zr7
        iwh9POzw4r5dLsJdWNEh8ibBcl9T5LApkLDhaB0NiJ95XaO7LMtBb8RUTW6X4sLzeyZmYc
        fxmv44vg4kgJhN3Sf29H7EheBA3z8IJoTGcr84bPVXANaX3qK4X5YiV4xTDo8nPXC0fhZa
        dTFHSuejOkg0di5kYPpT57FSF74/zmXqmh+GPlPfLOiUbGa3szfpG7rp5q1bg09Y7PDA6H
        vz2AqCJifQsu/B+vdvyWIp4rq7mOmD6G0O0MkwdQx11MTXEaKl/AVqOuG8aeW4FA==
Received: by filterdrecv-64fcb979b9-8r2zw with SMTP id filterdrecv-64fcb979b9-8r2zw-1-61BE74A9-6
        2021-12-18 23:54:17.233925598 +0000 UTC m=+8294249.268681274
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-1 (SG)
        with ESMTP
        id WODQW4uCRqSfD_BdUJPSqg
        Sat, 18 Dec 2021 23:54:17.067 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id CCF52701426; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 19/23] wilc1000: don't tell the chip to go to sleep while
 copying tx packets
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-20-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvBxusGV4Bz+mo2Dhm?=
 =?us-ascii?Q?qm6c7pe6RJmTeflUX3Xl0lMdXMkyBl5XbqwAmvR?=
 =?us-ascii?Q?rRZNjb6=2FG5PGf7B9pBuxASy=2FiQJqPLkE2lwSljk?=
 =?us-ascii?Q?CON+=2Ff8BzzWrtPmTzuKmsI9eeaRv=2FdaJRJsj9cs?=
 =?us-ascii?Q?w+9I3tz50TVl1NDM24ixOys8bgCn1BhkLdWfZK?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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
index b7c8ff95b646a..8652ec9f6d9c8 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -920,29 +920,27 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
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

