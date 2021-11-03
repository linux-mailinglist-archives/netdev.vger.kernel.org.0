Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FFD4449ED
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhKCVBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 17:01:14 -0400
Received: from mout-p-201.mailbox.org ([80.241.56.171]:10690 "EHLO
        mout-p-201.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhKCVBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 17:01:14 -0400
Received: from smtp202.mailbox.org (smtp202.mailbox.org [80.241.60.245])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4HkzdR6K5VzQlYP;
        Wed,  3 Nov 2021 21:58:35 +0100 (CET)
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
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH] mwifiex: Ignore BTCOEX events from the 88W8897 firmware
Date:   Wed,  3 Nov 2021 21:58:27 +0100
Message-Id: <20211103205827.14559-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B71D826B
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The firmware of the 88W8897 PCIe+USB card sends those events very
unreliably, sometimes bluetooth together with 2.4ghz-wifi is used and no
COEX event comes in, and sometimes bluetooth is disabled but the
coexistance mode doesn't get disabled.

This means we sometimes end up capping the rx/tx window size while
bluetooth is not enabled anymore, artifically limiting wifi speeds even
though bluetooth is not being used.

Since we can't fix the firmware, let's just ignore those events on the
88W8897 device. From some Wireshark capture sessions it seems that the
Windows driver also doesn't change the rx/tx window sizes when bluetooth
gets enabled or disabled, so this is fairly consistent with the Windows
driver.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/main.h      | 2 ++
 drivers/net/wireless/marvell/mwifiex/pcie.c      | 3 +++
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 90012cbcfd15..486315691851 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1055,6 +1055,8 @@ struct mwifiex_adapter {
 	void *devdump_data;
 	int devdump_len;
 	struct timer_list devdump_timer;
+
+	bool ignore_btcoex_events;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c3f5583ea70d..d5fb29400bad 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3152,6 +3152,9 @@ static int mwifiex_init_pcie(struct mwifiex_adapter *adapter)
 	if (ret)
 		goto err_alloc_buffers;
 
+	if (pdev->device == PCIE_DEVICE_ID_MARVELL_88W8897)
+		adapter->ignore_btcoex_events = true;
+
 	return 0;
 
 err_alloc_buffers:
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 68c63268e2e6..80e5d44bad9d 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -1058,6 +1058,9 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 	case EVENT_BT_COEX_WLAN_PARA_CHANGE:
 		dev_dbg(adapter->dev, "EVENT: BT coex wlan param update\n");
+		if (adapter->ignore_btcoex_events)
+			break;
+
 		mwifiex_bt_coex_wlan_param_update_event(priv,
 							adapter->event_skb);
 		break;
-- 
2.33.1

