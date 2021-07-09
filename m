Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416253C267D
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhGIPCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbhGIPCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:02:48 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB52EC0613DD;
        Fri,  9 Jul 2021 08:00:04 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4GLxCk4bCMzQjy3;
        Fri,  9 Jul 2021 17:00:02 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id rs3Ha9nWGqTj; Fri,  9 Jul 2021 16:59:59 +0200 (CEST)
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
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
Subject: [PATCH v2 1/2] mwifiex: pcie: add DMI-based quirk implementation for Surface devices
Date:   Fri,  9 Jul 2021 16:58:30 +0200
Message-Id: <20210709145831.6123-2-verdre@v0yd.nl>
In-Reply-To: <20210709145831.6123-1-verdre@v0yd.nl>
References: <20210709145831.6123-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -1.77 / 15.00 / 15.00
X-Rspamd-Queue-Id: A31D2189C
X-Rspamd-UID: d767ac
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds the ability to apply device-specific quirks to the
mwifiex driver. It uses DMI matching similar to the quirks brcmfmac uses
with dmi.c. We'll add identifiers to match various MS Surface devices,
which this is primarily meant for, later.

This commit is a slightly modified version of a previous patch sent in
by Tsuchiya Yuto.

Co-developed-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/Makefile |  1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c   |  4 +++
 drivers/net/wireless/marvell/mwifiex/pcie.h   |  1 +
 .../wireless/marvell/mwifiex/pcie_quirks.c    | 32 +++++++++++++++++++
 .../wireless/marvell/mwifiex/pcie_quirks.h    |  8 +++++
 5 files changed, 46 insertions(+)
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h

diff --git a/drivers/net/wireless/marvell/mwifiex/Makefile b/drivers/net/wireless/marvell/mwifiex/Makefile
index 162d557b78af..2bd00f40958e 100644
--- a/drivers/net/wireless/marvell/mwifiex/Makefile
+++ b/drivers/net/wireless/marvell/mwifiex/Makefile
@@ -49,6 +49,7 @@ mwifiex_sdio-y += sdio.o
 obj-$(CONFIG_MWIFIEX_SDIO) += mwifiex_sdio.o
 
 mwifiex_pcie-y += pcie.o
+mwifiex_pcie-y += pcie_quirks.o
 obj-$(CONFIG_MWIFIEX_PCIE) += mwifiex_pcie.o
 
 mwifiex_usb-y += usb.o
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 46517515ba72..a530832c9421 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -27,6 +27,7 @@
 #include "wmm.h"
 #include "11n.h"
 #include "pcie.h"
+#include "pcie_quirks.h"
 
 #define PCIE_VERSION	"1.0"
 #define DRV_NAME        "Marvell mwifiex PCIe"
@@ -410,6 +411,9 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 			return ret;
 	}
 
+	/* check quirks */
+	mwifiex_initialize_quirks(card);
+
 	if (mwifiex_add_card(card, &card->fw_done, &pcie_ops,
 			     MWIFIEX_PCIE, &pdev->dev)) {
 		pr_err("%s failed\n", __func__);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 5ed613d65709..981e330c77d7 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -244,6 +244,7 @@ struct pcie_service_card {
 	unsigned long work_flags;
 
 	bool pci_reset_ongoing;
+	unsigned long quirks;
 };
 
 static inline int
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
new file mode 100644
index 000000000000..4064f99b36ba
--- /dev/null
+++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * File for PCIe quirks.
+ */
+
+/* The low-level PCI operations will be performed in this file. Therefore,
+ * let's use dev_*() instead of mwifiex_dbg() here to avoid troubles (e.g.
+ * to avoid using mwifiex_adapter struct before init or wifi is powered
+ * down, or causes NULL ptr deref).
+ */
+
+#include <linux/dmi.h>
+
+#include "pcie_quirks.h"
+
+/* quirk table based on DMI matching */
+static const struct dmi_system_id mwifiex_quirk_table[] = {
+	{}
+};
+
+void mwifiex_initialize_quirks(struct pcie_service_card *card)
+{
+	struct pci_dev *pdev = card->dev;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id = dmi_first_match(mwifiex_quirk_table);
+	if (dmi_id)
+		card->quirks = (uintptr_t)dmi_id->driver_data;
+
+	if (!card->quirks)
+		dev_info(&pdev->dev, "no quirks enabled\n");
+}
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
new file mode 100644
index 000000000000..7a1fe3b3a61a
--- /dev/null
+++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Header file for PCIe quirks.
+ */
+
+#include "pcie.h"
+
+void mwifiex_initialize_quirks(struct pcie_service_card *card);
-- 
2.31.1

