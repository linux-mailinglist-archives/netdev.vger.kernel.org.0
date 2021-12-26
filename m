Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14DB47F7C2
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhLZPi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:38:58 -0500
Received: from marcansoft.com ([212.63.210.85]:56376 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234105AbhLZPir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 10:38:47 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id C407044B42;
        Sun, 26 Dec 2021 15:38:37 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 16/34] brcmfmac: acpi: Add support for fetching Apple ACPI properties
Date:   Mon, 27 Dec 2021 00:36:06 +0900
Message-Id: <20211226153624.162281-17-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On DT platforms, the module-instance and antenna-sku-info properties
are passed in the DT. On ACPI platforms, module-instance is passed via
the analogous Apple device property mechanism, while the antenna SKU
info is instead obtained via an ACPI method that grabs it from
non-volatile storage.

Add support for this, to allow proper firmware selection on Apple
platforms.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/Makefile      |  2 +
 .../broadcom/brcm80211/brcmfmac/acpi.c        | 51 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/common.c      |  1 +
 .../broadcom/brcm80211/brcmfmac/common.h      |  9 ++++
 4 files changed, 63 insertions(+)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
index 13c13504a6e8..19009eb9db93 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
@@ -47,3 +47,5 @@ brcmfmac-$(CONFIG_OF) += \
 		of.o
 brcmfmac-$(CONFIG_DMI) += \
 		dmi.o
+brcmfmac-$(CONFIG_ACPI) += \
+		acpi.o
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
new file mode 100644
index 000000000000..3e56dc7a8db2
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright The Asahi Linux Contributors
+ */
+
+#include <linux/acpi.h>
+#include "debug.h"
+#include "core.h"
+#include "common.h"
+
+void brcmf_acpi_probe(struct device *dev, enum brcmf_bus_type bus_type,
+		      struct brcmf_mp_device *settings)
+{
+	acpi_status status;
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+	const union acpi_object *o;
+	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
+
+	if (!adev)
+		return;
+
+	if (!ACPI_FAILURE(acpi_dev_get_property(adev, "module-instance",
+						ACPI_TYPE_STRING, &o))) {
+		const char *prefix = "apple,";
+		int len = strlen(prefix) + o->string.length + 1;
+		char *board_type = devm_kzalloc(dev, len, GFP_KERNEL);
+
+		strscpy(board_type, prefix, len);
+		strlcat(board_type, o->string.pointer, len);
+		brcmf_dbg(INFO, "ACPI module-instance=%s\n", o->string.pointer);
+		settings->board_type = board_type;
+	} else {
+		brcmf_dbg(INFO, "No ACPI module-instance\n");
+	}
+
+	status = acpi_evaluate_object(adev->handle, "RWCV", NULL, &buf);
+	o = buf.pointer;
+	if (!ACPI_FAILURE(status) && o && o->type == ACPI_TYPE_BUFFER &&
+	    o->buffer.length >= 2) {
+		char *antenna_sku = devm_kzalloc(dev, 3, GFP_KERNEL);
+
+		memcpy(antenna_sku, o->buffer.pointer, 2);
+		brcmf_dbg(INFO, "ACPI RWCV data=%*phN antenna-sku=%s\n",
+			  (int)o->buffer.length, o->buffer.pointer,
+			  antenna_sku);
+
+		settings->antenna_sku = antenna_sku;
+	} else {
+		brcmf_dbg(INFO, "No ACPI antenna-sku\n");
+	}
+}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index b8ed851129b4..c84c48e49fde 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -437,6 +437,7 @@ struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
 		/* No platform data for this device, try OF and DMI data */
 		brcmf_dmi_probe(settings, chip, chiprev);
 		brcmf_of_probe(dev, bus_type, settings);
+		brcmf_acpi_probe(dev, bus_type, settings);
 	}
 	return settings;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index d4aa25d646fe..a88c4a9310f3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -73,6 +73,15 @@ static inline void
 brcmf_dmi_probe(struct brcmf_mp_device *settings, u32 chip, u32 chiprev) {}
 #endif
 
+#ifdef CONFIG_ACPI
+void brcmf_acpi_probe(struct device *dev, enum brcmf_bus_type bus_type,
+		      struct brcmf_mp_device *settings);
+#else
+static inline void brcmf_acpi_probe(struct device *dev,
+				    enum brcmf_bus_type bus_type,
+				    struct brcmf_mp_device *settings) {}
+#endif
+
 u8 brcmf_map_prio_to_prec(void *cfg, u8 prio);
 
 u8 brcmf_map_prio_to_aci(void *cfg, u8 prio);
-- 
2.33.0

