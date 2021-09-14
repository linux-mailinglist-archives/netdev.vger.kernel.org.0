Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA13340ACC8
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhINLu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbhINLuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 07:50:01 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8A2C061574;
        Tue, 14 Sep 2021 04:48:43 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:105:465:1:3:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4H81p14VPvzQkBN;
        Tue, 14 Sep 2021 13:48:41 +0200 (CEST)
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
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] mwifiex: Use non-posted PCI write when setting TX ring write pointer
Date:   Tue, 14 Sep 2021 13:48:12 +0200
Message-Id: <20210914114813.15404-2-verdre@v0yd.nl>
In-Reply-To: <20210914114813.15404-1-verdre@v0yd.nl>
References: <20210914114813.15404-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 98AA0268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the 88W8897 card it's very important the TX ring write pointer is
updated correctly to its new value before setting the TX ready
interrupt, otherwise the firmware appears to crash (probably because
it's trying to DMA-read from the wrong place). The issue is present in
the latest firmware version 15.68.19.p21 of the pcie+usb card.

Since PCI uses "posted writes" when writing to a register, it's not
guaranteed that a write will happen immediately. That means the pointer
might be outdated when setting the TX ready interrupt, leading to
firmware crashes especially when ASPM L1 and L1 substates are enabled
(because of the higher link latency, the write will probably take
longer).

So fix those firmware crashes by always using a non-posted write for
this specific register write. We do that by simply reading back the
register after writing it, just as a few other PCI drivers do.

This fixes a bug where during rx/tx traffic and with ASPM L1 substates
enabled (the enabled substates are platform dependent), the firmware
crashes and eventually a command timeout appears in the logs.

Cc: stable@vger.kernel.org
Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 26 ++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c6ccce426b49..0eff717ac5fa 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -240,6 +240,20 @@ static int mwifiex_write_reg(struct mwifiex_adapter *adapter, int reg, u32 data)
 	return 0;
 }
 
+/*
+ * This function does a non-posted write into a PCIE card register, ensuring
+ * it's completion before returning.
+ */
+static int mwifiex_write_reg_np(struct mwifiex_adapter *adapter, int reg, u32 data)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	iowrite32(data, card->pci_mmap1 + reg);
+	ioread32(card->pci_mmap1 + reg);
+
+	return 0;
+}
+
 /* This function reads data from PCIE card register.
  */
 static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
@@ -1482,9 +1496,15 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 						reg->tx_rollover_ind);
 
 		rx_val = card->rxbd_rdptr & reg->rx_wrap_mask;
-		/* Write the TX ring write pointer in to reg->tx_wrptr */
-		if (mwifiex_write_reg(adapter, reg->tx_wrptr,
-				      card->txbd_wrptr | rx_val)) {
+		/* Write the TX ring write pointer in to reg->tx_wrptr.
+		 * The firmware (latest version 15.68.19.p21) of the 88W8897
+		 * pcie+usb card seems to crash when getting the TX ready
+		 * interrupt but the TX ring write pointer points to an outdated
+		 * address, so it's important we do a non-posted write here to
+		 * force the completion of the write.
+		 */
+		if (mwifiex_write_reg_np(adapter, reg->tx_wrptr,
+				        card->txbd_wrptr | rx_val)) {
 			mwifiex_dbg(adapter, ERROR,
 				    "SEND DATA: failed to write reg->tx_wrptr\n");
 			ret = -1;
-- 
2.31.1

