Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F3D3F2DEB
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 16:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240879AbhHTOWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 10:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240854AbhHTOWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 10:22:23 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB30C061760;
        Fri, 20 Aug 2021 07:21:44 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4GrkN71XKWzQjDs;
        Fri, 20 Aug 2021 16:21:43 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id 27n24f8jtIiD; Fri, 20 Aug 2021 16:21:36 +0200 (CEST)
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
Subject: [PATCH v3 1/2] mwifiex: pcie: add DMI-based quirk implementation for Surface devices
Date:   Fri, 20 Aug 2021 16:20:49 +0200
Message-Id: <20210820142050.35741-2-verdre@v0yd.nl>
In-Reply-To: <20210820142050.35741-1-verdre@v0yd.nl>
References: <20210820142050.35741-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0D021899
X-Rspamd-UID: 64833e
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
 drivers/net/wireless/marvell/mwifiex/pcie.c   |  4 ++
 drivers/net/wireless/marvell/mwifiex/pcie.h   |  1 +
 .../wireless/marvell/mwifiex/pcie_quirks.c    | 38 +++++++++++++++++++
 .../wireless/marvell/mwifiex/pcie_quirks.h    | 20 ++++++++++
 5 files changed, 64 insertions(+)
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
index 000000000000..c1665ac5c5d9
--- /dev/null
+++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
@@ -0,0 +1,38 @@
+/*
+ * NXP Wireless LAN device driver: PCIE and platform specific quirks
+ *
+ * This software file (the "File") is distributed by NXP
+ * under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
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
index 000000000000..18eacc8c2d3a
--- /dev/null
+++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
@@ -0,0 +1,20 @@
+/*
+ * NXP Wireless LAN device driver: PCIE and platform specific quirks
+ *
+ * This software file (the "File") is distributed by NXP
+ * under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "pcie.h"
+
+void mwifiex_initialize_quirks(struct pcie_service_card *card);
-- 
2.31.1

