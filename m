Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EEA3FB639
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbhH3Mir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbhH3Mip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 08:38:45 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C329BC061575;
        Mon, 30 Aug 2021 05:37:51 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4Gyqbf3YV9zQkJ0;
        Mon, 30 Aug 2021 14:37:50 +0200 (CEST)
Received: from gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173])
        by smtp202.mailbox.org (Postfix) with ESMTP id 7D554272;
        Mon, 30 Aug 2021 14:37:48 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp202.mailbox.org ([80.241.60.245])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id ZmaoWW-eg1AL; Mon, 30 Aug 2021 14:37:47 +0200 (CEST)
Received: from suagaze.. (unknown [46.183.103.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp202.mailbox.org (Postfix) with ESMTPSA id A1F423D0;
        Mon, 30 Aug 2021 14:37:42 +0200 (CEST)
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
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 2/2] mwifiex: Try waking the firmware until we get an interrupt
Date:   Mon, 30 Aug 2021 14:37:04 +0200
Message-Id: <20210830123704.221494-3-verdre@v0yd.nl>
In-Reply-To: <20210830123704.221494-1-verdre@v0yd.nl>
References: <20210830123704.221494-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D554272
X-Rspamd-UID: 160a58
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that the firmware of the 88W8897 card sometimes ignores or
misses when we try to wake it up by reading the firmware status
register. This leads to the firmware wakeup timeout expiring and the
driver resetting the card because we assume the firmware has hung up or
crashed (unfortunately that's not unlikely with this card).

Turns out that most of the time the firmware actually didn't hang up,
but simply "missed" our wakeup request and doesn't send us an AWAKE
event.

Trying again to read the firmware status register after a short timeout
usually makes the firmware wake we up as expected, so add a small retry
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

A good reproducer for this issue is letting the firmware sleep and wake
up in very short intervals, for example by pinging an device on the
network every 0.1 seconds.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 29 ++++++++++++++++-----
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index bfd6e135ed99..14742bdb96ef 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -658,6 +658,7 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+	int n_tries = 0;
 
 	mwifiex_dbg(adapter, EVENT,
 		    "event: Wakeup device...\n");
@@ -665,12 +666,28 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 	if (reg->sleep_cookie)
 		mwifiex_pcie_dev_wakeup_delay(adapter);
 
-	/* Accessing fw_status register will wakeup device */
-	if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
-		mwifiex_dbg(adapter, ERROR,
-			    "Writing fw_status register failed\n");
-		return -1;
-	}
+	/* Access the fw_status register to wake up the device.
+	 * Since the 88W8897 firmware sometimes appears to ignore or miss
+	 * that wakeup request, we continue trying until we receive an
+	 * interrupt from the card.
+	 */
+	do {
+		if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
+			mwifiex_dbg(adapter, ERROR,
+				    "Writing fw_status register failed\n");
+			return -1;
+		}
+
+		n_tries++;
+
+		if (n_tries <= 15)
+			usleep_range(400, 700);
+		else
+			msleep(10);
+	} while (n_tries <= 50 && READ_ONCE(adapter->int_status) == 0);
+
+	mwifiex_dbg(adapter, EVENT,
+		    "event: Tried %d times until firmware woke up\n", n_tries);
 
 	if (reg->sleep_cookie) {
 		mwifiex_pcie_dev_wakeup_delay(adapter);
-- 
2.31.1

