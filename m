Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95193FB634
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhH3Mik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbhH3Mij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 08:38:39 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE505C06175F;
        Mon, 30 Aug 2021 05:37:45 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [80.241.60.245])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4GyqbX26LtzQkBk;
        Mon, 30 Aug 2021 14:37:44 +0200 (CEST)
Received: from spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122])
        by smtp202.mailbox.org (Postfix) with ESMTP id C001737F;
        Mon, 30 Aug 2021 14:37:41 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp202.mailbox.org ([80.241.60.245])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id bp41yfpSoChk; Mon, 30 Aug 2021 14:37:40 +0200 (CEST)
Received: from suagaze.. (unknown [46.183.103.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp202.mailbox.org (Postfix) with ESMTPSA id 1B743271;
        Mon, 30 Aug 2021 14:37:37 +0200 (CEST)
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
Subject: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
Date:   Mon, 30 Aug 2021 14:37:03 +0200
Message-Id: <20210830123704.221494-2-verdre@v0yd.nl>
In-Reply-To: <20210830123704.221494-1-verdre@v0yd.nl>
References: <20210830123704.221494-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C001737F
X-Rspamd-UID: edda12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the 88W8897 card it's very important the TX ring write pointer is
updated correctly to its new value before setting the TX ready
interrupt, otherwise the firmware appears to crash (probably because
it's trying to DMA-read from the wrong place).

Since PCI uses "posted writes" when writing to a register, it's not
guaranteed that a write will happen immediately. That means the pointer
might be outdated when setting the TX ready interrupt, leading to
firmware crashes especially when ASPM L1 and L1 substates are enabled
(because of the higher link latency, the write will probably take
longer).

So fix those firmware crashes by always forcing non-posted writes. We do
that by simply reading back the register after writing it, just as a lot
of other drivers do.

There are two reproducers that are fixed with this patch:

1) During rx/tx traffic and with ASPM L1 substates enabled (the enabled
substates are platform dependent), the firmware crashes and eventually a
command timeout appears in the logs. That crash is fixed by using a
non-posted write in mwifiex_pcie_send_data().

2) When sending lots of commands to the card, waking it up from sleep in
very quick intervals, the firmware eventually crashes. That crash
appears to be fixed by some other non-posted write included here.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c6ccce426b49..bfd6e135ed99 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -237,6 +237,12 @@ static int mwifiex_write_reg(struct mwifiex_adapter *adapter, int reg, u32 data)
 
 	iowrite32(data, card->pci_mmap1 + reg);
 
+	/* Do a read-back, which makes the write non-posted, ensuring the
+	 * completion before returning.
+	 * The firmware of the 88W8897 card is buggy and this avoids crashes.
+	 */
+	ioread32(card->pci_mmap1 + reg);
+
 	return 0;
 }
 
-- 
2.31.1

