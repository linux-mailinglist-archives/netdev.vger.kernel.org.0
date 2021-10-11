Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C82F428E07
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbhJKNe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236976AbhJKNez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 09:34:55 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABD7C061570;
        Mon, 11 Oct 2021 06:32:54 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4HSfqm4ywpzQkm2;
        Mon, 11 Oct 2021 15:32:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>, stable@vger.kernel.org
Subject: [PATCH v3 2/2] mwifiex: Try waking the firmware until we get an interrupt
Date:   Mon, 11 Oct 2021 15:32:24 +0200
Message-Id: <20211011133224.15561-3-verdre@v0yd.nl>
In-Reply-To: <20211011133224.15561-1-verdre@v0yd.nl>
References: <20211011133224.15561-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 73BB91887
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that the PCIe+USB firmware (latest version 15.68.19.p21) of the
88W8897 card sometimes ignores or misses when we try to wake it up by
writing to the firmware status register. This leads to the firmware
wakeup timeout expiring and the driver resetting the card because we
assume the firmware has hung up or crashed.

Turns out that the firmware actually didn't hang up, but simply "missed"
our wakeup request and didn't send us an interrupt with an AWAKE event.

Trying again to read the firmware status register after a short timeout
usually makes the firmware wake up as expected, so add a small retry
loop to mwifiex_pm_wakeup_card() that looks at the interrupt status to
check whether the card woke up.

The number of tries and timeout lengths for this were determined
experimentally: The firmware usually takes about 500 us to wake up
after we attempt to read the status register. In some cases where the
firmware is very busy (for example while doing a bluetooth scan) it
might even miss our requests for multiple milliseconds, which is why
after 15 tries the waiting time gets increased to 10 ms. The maximum
number of tries it took to wake the firmware when testing this was
around 20, so a maximum number of 50 tries should give us plenty of
safety margin.

Here's a reproducer for those firmware wakeup failures I've found:

1) Make sure wifi powersaving is enabled (iw dev wlp1s0 set power_save on)
2) Connect to any wifi network (makes firmware go into wifi powersaving
mode, not deep sleep)
3) Make sure bluetooth is turned off (to ensure the firmware actually
enters powersave mode and doesn't keep the radio active doing bluetooth
stuff)
4) To confirm that wifi powersaving is entered ping a device on the LAN,
pings should be a few ms higher than without powersaving
5) Run "while true; do iwconfig; sleep 0.0001; done", this wakes and
suspends the firmware extremely often
6) Wait until things explode, for me it consistently takes <5 minutes

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=109681
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 28 +++++++++++++++++----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 641fa539de1f..c3f5583ea70d 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -17,6 +17,7 @@
  * this warranty disclaimer.
  */
 
+#include <linux/iopoll.h>
 #include <linux/firmware.h>
 
 #include "decl.h"
@@ -647,11 +648,15 @@ static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
 			    "max count reached while accessing sleep cookie\n");
 }
 
+#define N_WAKEUP_TRIES_SHORT_INTERVAL 15
+#define N_WAKEUP_TRIES_LONG_INTERVAL 35
+
 /* This function wakes up the card by reading fw_status register. */
 static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+	int retval;
 
 	mwifiex_dbg(adapter, EVENT,
 		    "event: Wakeup device...\n");
@@ -659,11 +664,24 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 	if (reg->sleep_cookie)
 		mwifiex_pcie_dev_wakeup_delay(adapter);
 
-	/* Accessing fw_status register will wakeup device */
-	if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
-		mwifiex_dbg(adapter, ERROR,
-			    "Writing fw_status register failed\n");
-		return -1;
+	/* The 88W8897 PCIe+USB firmware (latest version 15.68.19.p21) sometimes
+	 * appears to ignore or miss our wakeup request, so we continue trying
+	 * until we receive an interrupt from the card.
+	 */
+	if (read_poll_timeout(mwifiex_write_reg, retval,
+			      READ_ONCE(adapter->int_status) != 0,
+			      500, 500 * N_WAKEUP_TRIES_SHORT_INTERVAL,
+			      false,
+			      adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
+		if (read_poll_timeout(mwifiex_write_reg, retval,
+				      READ_ONCE(adapter->int_status) != 0,
+				      10000, 10000 * N_WAKEUP_TRIES_LONG_INTERVAL,
+				      false,
+				      adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
+			mwifiex_dbg(adapter, ERROR,
+				    "Firmware didn't wake up\n");
+			return -EIO;
+		}
 	}
 
 	if (reg->sleep_cookie) {
-- 
2.31.1

