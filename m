Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C319B695BC8
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjBNICT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBNIBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:01:45 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0819273E;
        Tue, 14 Feb 2023 00:01:43 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B0F874267B;
        Tue, 14 Feb 2023 08:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676361702; bh=p6L/0L78DJAiXa0tWZGy/+KT5i43QkswVQmSdbLw7W0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=fMeRXy3c57zRowzLprZV33IK3KYYODRGXmi7VeH2aOtOdskSfAIrcAhBfKcrBEjI+
         VvJg09GZv4wRPEn9RfU01DWTjXV2j69eYKXyUBHpVTaGRP6IF3fE49Wr8X4+1KNiGK
         IbiXAZe8nZhE4pjRfSFLxhMMQiHYyYQPQ5GWE1HbiCGl0xb6dA5KO5Dy7aMICJJ+Zh
         jCOCg1UKZdhjmVZ/pMhyNdZeDhypDDUES4IommwlmAGy3iSYdF+krAecGhULMD4kiL
         4PnOxQJb6tK4WYZ5HRQi83u+skkYXNiMKByJeBmctDV8FrAAJOwn5OLD+wQc1fvNE4
         7H2QqyFnXGT0Q==
From:   Hector Martin <marcan@marcan.st>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>
Subject: [PATCH 1/2] brcmfmac: acpi: Add support for fetching Apple ACPI properties
Date:   Tue, 14 Feb 2023 17:00:33 +0900
Message-Id: <20230214080034.3828-2-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230214080034.3828-1-marcan@marcan.st>
References: <20230214080034.3828-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 0e996cf24f88..dc6d27a36faa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
@@ -48,6 +48,8 @@ brcmfmac-$(CONFIG_OF) += \
 		of.o
 brcmfmac-$(CONFIG_DMI) += \
 		dmi.o
+brcmfmac-$(CONFIG_ACPI) += \
+		acpi.o
 
 ifeq ($(CONFIG_BRCMFMAC),m)
 obj-m += wcc/
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
new file mode 100644
index 000000000000..c4a54861bfb4
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
+	const union acpi_object *o;
+	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+
+	if (!adev)
+		return;
+
+	if (!ACPI_FAILURE(acpi_dev_get_property(adev, "module-instance",
+						ACPI_TYPE_STRING, &o))) {
+		brcmf_dbg(INFO, "ACPI module-instance=%s\n", o->string.pointer);
+		settings->board_type = devm_kasprintf(dev, GFP_KERNEL,
+						      "apple,%s",
+						      o->string.pointer);
+	} else {
+		brcmf_dbg(INFO, "No ACPI module-instance\n");
+		return;
+	}
+
+	status = acpi_evaluate_object(adev->handle, "RWCV", NULL, &buf);
+	o = buf.pointer;
+	if (!ACPI_FAILURE(status) && o && o->type == ACPI_TYPE_BUFFER &&
+	    o->buffer.length >= 2) {
+		char *antenna_sku = devm_kzalloc(dev, 3, GFP_KERNEL);
+
+		if (antenna_sku) {
+			memcpy(antenna_sku, o->buffer.pointer, 2);
+			brcmf_dbg(INFO, "ACPI RWCV data=%*phN antenna-sku=%s\n",
+				  (int)o->buffer.length, o->buffer.pointer,
+				  antenna_sku);
+			settings->antenna_sku = antenna_sku;
+		}
+
+		kfree(buf.pointer);
+	} else {
+		brcmf_dbg(INFO, "No ACPI antenna-sku\n");
+	}
+}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 4a309e5a5707..b977e50137bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -484,6 +484,7 @@ struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
 		/* No platform data for this device, try OF and DMI data */
 		brcmf_dmi_probe(settings, chip, chiprev);
 		brcmf_of_probe(dev, bus_type, settings);
+		brcmf_acpi_probe(dev, bus_type, settings);
 	}
 	return settings;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index aa25abffcc7d..7167fd4f8c63 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -77,6 +77,15 @@ static inline void
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
2.35.1

