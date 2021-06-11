Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD173A4A44
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhFKUmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:42:46 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:34401 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbhFKUmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:42:45 -0400
Received: by mail-io1-f53.google.com with SMTP id 5so32537677ioe.1
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z0A+YtYYWtQRN8MlN4WVvuoWz4M6oSYiKKNYu0qWiDA=;
        b=wo9cXYZbVuFxh3CDGsdFw8LnYdW3uf+eRWxgzq3HzB968kH2vUe35g5BHDVBgPunE3
         tbu3xLi1hKg9vBnHtq28AhNTRpL6kMtIv3b9hADDJhdPjCVPC/s3D3UAYsICETAcDAZT
         +Qm6nZSIPtPrVUGqn1k7Ev8JplC6B6gv6KsHTLFh1JEbsWwTC3yVGYRayIyFE5fqrwJv
         V5yj58HUvEY3OxWD40N4AJwBRdi93eXm4LaJmDSNahs2Fl2yLDGaO3b2PgPwKPDPeD66
         eRUrpHjsFwlnlpsSaPJh+pzOXRoWl6cHceXrdLnYVaGaZG6xMHWxRSD1agHXTKqM2WeM
         h8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z0A+YtYYWtQRN8MlN4WVvuoWz4M6oSYiKKNYu0qWiDA=;
        b=mcBaeR1L0xgyVAtbZegRZUQGX+Y+NgYt5dski9ZAI3QuXUz8wuwMprkvMBSUcdHLWN
         QHI3vYEgKxza+uAFNro5l6pjMxQDRul+H/OVWGzkVE2wkgT8zJtCtpRDVx6QUxgiv+Bi
         LFXHtxSdX1+460yEg33qMjm5xXmFZBeAEBtxGPZjEwV39IUnjUQRrS08DhAeHxgrv1Ch
         vCkaecrSco8JbmG7Rz8Zb7qKRJCWqYAvOQ10t/PFqzLJaw4BzTi0Fbsms3pbbRgHpQnS
         ZB0lF/T4rz9DsNvLXlQCYbpRou1h5LUdXkk7uDjCRklwn77Nr2exNHts2FNlsiyZYaER
         OoBw==
X-Gm-Message-State: AOAM533xpgKFRPxMxxIqeJlIu81gGuDuyHnYMFx977pr5zZcByuGi72q
        RfGMfkiLQpfkQHvZ6+rJxmgcqA==
X-Google-Smtp-Source: ABdhPJyiFEwV+TphP0CmiwcvHt/HDso4JYJDbiRd+zZ369qwIoMWmNvi6rKhykz7Ol6YdOiwvsoEjQ==
X-Received: by 2002:a02:8784:: with SMTP id t4mr5462367jai.26.1623443986819;
        Fri, 11 Jun 2021 13:39:46 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y9sm3761544ilp.58.2021.06.11.13.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:39:46 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        aleksander@aleksander.es, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: ipa: introduce sysfs code
Date:   Fri, 11 Jun 2021 15:39:40 -0500
Message-Id: <20210611203940.3171057-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611203940.3171057-1-elder@linaro.org>
References: <20210611203940.3171057-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IPA device attributes to expose information known by the IPA
driver about the hardware and its configuration.

All pointers used to display these attribute values (i.e., IPA
pointer and endpoint pointers) will have been initialized by the
time IPA probe has completed, so they may be safely dereferenced.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../testing/sysfs-devices-platform-soc-ipa    |  78 ++++++++++
 drivers/net/ipa/Makefile                      |   3 +-
 drivers/net/ipa/ipa_main.c                    |   9 ++
 drivers/net/ipa/ipa_sysfs.c                   | 136 ++++++++++++++++++
 drivers/net/ipa/ipa_sysfs.h                   |  15 ++
 drivers/net/ipa/ipa_version.h                 |   2 +
 6 files changed, 242 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-soc-ipa
 create mode 100644 drivers/net/ipa/ipa_sysfs.c
 create mode 100644 drivers/net/ipa/ipa_sysfs.h

diff --git a/Documentation/ABI/testing/sysfs-devices-platform-soc-ipa b/Documentation/ABI/testing/sysfs-devices-platform-soc-ipa
new file mode 100644
index 0000000000000..c56dcf15bf29d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-platform-soc-ipa
@@ -0,0 +1,78 @@
+What:		/sys/devices/platform/soc@X/XXXXXXX.ipa/
+Date:		June 2021
+KernelVersion:	v5.14
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The /sys/devices/platform/soc@X/XXXXXXX.ipa/ directory
+		contains read-only attributes exposing information about
+		an IPA device.  The X values could vary, but are typically
+		"soc@0/1e40000.ipa".
+
+What:		.../XXXXXXX.ipa/version
+Date:		June 2021
+KernelVersion:	v5.14
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/version file contains the IPA hardware
+		version, as a period-separated set of two or three integers
+		(e.g., "3.5.1" or "4.2").
+
+What:		.../XXXXXXX.ipa/feature/
+Date:		June 2021
+KernelVersion:	v5.14
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/feature/ directory contains a set of
+		attributes describing features implemented by the IPA
+		hardware.
+
+What:		.../XXXXXXX.ipa/feature/rx_offload
+Date:		June 2021
+KernelVersion:	v5.14
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/feature/rx_offload file contains a
+		string indicating the type of receive checksum offload
+		that is supported by the hardware.  The possible values
+		are "MAPv4" or "MAPv5".
+
+What:		.../XXXXXXX.ipa/feature/tx_offload
+Date:		June 2021
+KernelVersion:	v5.14
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/feature/tx_offload file contains a
+		string indicating the type of transmit checksum offload
+		that is supported by the hardware.  The possible values
+		are "MAPv4" or "MAPv5".
+
+What:		.../XXXXXXX.ipa/modem/
+Date:		June 2021
+KernelVersion:	v5.14
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/modem/ directory contains a set of
+		attributes describing properties of the modem execution
+		environment reachable by the IPA hardware.
+
+What:		.../XXXXXXX.ipa/modem/rx_endpoint_id
+Date:		June 2021
+KernelVersion:	v5.14
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/feature/rx_endpoint_id file contains
+		the AP endpoint ID that receives packets originating from
+		the modem execution environment.  The "rx" is from the
+		perspective of the AP; this endpoint is considered an "IPA
+		producer".  An endpoint ID is a small unsigned integer.
+
+What:		.../XXXXXXX.ipa/modem/tx_endpoint_id
+Date:		June 2021
+KernelVersion:	v5.14
+Contact:	Alex Elder <elder@kernel.org>
+Description:
+		The .../XXXXXXX.ipa/feature/tx_endpoint_id file contains
+		the AP endpoint ID used to transmit packets destined for
+		the modem execution environment.  The "tx" is from the
+		perspective of the AP; this endpoint is considered an "IPA
+		consumer".  An endpoint ID is a small unsigned integer.
diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 1efe1a88104b3..bd34fce8f6e63 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -7,7 +7,8 @@ ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
 				ipa_table.o ipa_interrupt.o gsi.o gsi_trans.o \
 				ipa_gsi.o ipa_smp2p.o ipa_uc.o \
 				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
-				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o
+				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o \
+				ipa_sysfs.o
 
 ipa-y			+=	ipa_data-v3.5.1.o ipa_data-v4.2.o \
 				ipa_data-v4.5.o ipa_data-v4.9.o \
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index cbd39e4667a32..2243e3e5b7ea4 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -31,6 +31,7 @@
 #include "ipa_uc.h"
 #include "ipa_interrupt.h"
 #include "gsi_trans.h"
+#include "ipa_sysfs.h"
 
 /**
  * DOC: The IP Accelerator
@@ -906,6 +907,13 @@ static const struct dev_pm_ops ipa_pm_ops = {
 	.resume		= ipa_resume,
 };
 
+static const struct attribute_group *ipa_attribute_groups[] = {
+	&ipa_attribute_group,
+	&ipa_feature_attribute_group,
+	&ipa_modem_attribute_group,
+	NULL,
+};
+
 static struct platform_driver ipa_driver = {
 	.probe		= ipa_probe,
 	.remove		= ipa_remove,
@@ -914,6 +922,7 @@ static struct platform_driver ipa_driver = {
 		.name		= "ipa",
 		.pm		= &ipa_pm_ops,
 		.of_match_table	= ipa_match,
+		.dev_groups	= ipa_attribute_groups,
 	},
 };
 
diff --git a/drivers/net/ipa/ipa_sysfs.c b/drivers/net/ipa/ipa_sysfs.c
new file mode 100644
index 0000000000000..ff61dbdd70d8c
--- /dev/null
+++ b/drivers/net/ipa/ipa_sysfs.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2021 Linaro Ltd. */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/sysfs.h>
+
+#include "ipa.h"
+#include "ipa_version.h"
+#include "ipa_sysfs.h"
+
+static const char *ipa_version_string(struct ipa *ipa)
+{
+	switch (ipa->version) {
+	case IPA_VERSION_3_0:
+		return "3.0";
+	case IPA_VERSION_3_1:
+		return "3.1";
+	case IPA_VERSION_3_5:
+		return "3.5";
+	case IPA_VERSION_3_5_1:
+		return "3.5.1";
+	case IPA_VERSION_4_0:
+		return "4.0";
+	case IPA_VERSION_4_1:
+		return "4.1";
+	case IPA_VERSION_4_2:
+		return "4.2";
+	case IPA_VERSION_4_5:
+		return "4.5";
+	case IPA_VERSION_4_7:
+		return "4.7";
+	case IPA_VERSION_4_9:
+		return "4.9";
+	case IPA_VERSION_4_11:
+		return "4.11";
+	default:
+		return "0.0";	/* Won't happen (checked at probe time) */
+	}
+}
+
+static ssize_t
+version_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", ipa_version_string(ipa));
+}
+
+static DEVICE_ATTR_RO(version);
+
+static struct attribute *ipa_attrs[] = {
+	&dev_attr_version.attr,
+	NULL
+};
+
+const struct attribute_group ipa_attribute_group = {
+	.attrs		= ipa_attrs,
+};
+
+static const char *ipa_offload_string(struct ipa *ipa)
+{
+	return ipa->version < IPA_VERSION_4_5 ? "MAPv4" : "MAPv5";
+}
+
+static ssize_t rx_offload_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", ipa_offload_string(ipa));
+}
+
+static DEVICE_ATTR_RO(rx_offload);
+
+static ssize_t tx_offload_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", ipa_offload_string(ipa));
+}
+
+static DEVICE_ATTR_RO(tx_offload);
+
+static struct attribute *ipa_feature_attrs[] = {
+	&dev_attr_rx_offload.attr,
+	&dev_attr_tx_offload.attr,
+	NULL
+};
+
+const struct attribute_group ipa_feature_attribute_group = {
+	.name		= "feature",
+	.attrs		= ipa_feature_attrs,
+};
+
+static ssize_t
+ipa_endpoint_id_show(struct ipa *ipa, char *buf, enum ipa_endpoint_name name)
+{
+	u32 endpoint_id = ipa->name_map[name]->endpoint_id;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", endpoint_id);
+}
+
+static ssize_t rx_endpoint_id_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	return ipa_endpoint_id_show(ipa, buf, IPA_ENDPOINT_AP_MODEM_RX);
+}
+
+static DEVICE_ATTR_RO(rx_endpoint_id);
+
+static ssize_t tx_endpoint_id_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	return ipa_endpoint_id_show(ipa, buf, IPA_ENDPOINT_AP_MODEM_TX);
+}
+
+static DEVICE_ATTR_RO(tx_endpoint_id);
+
+static struct attribute *ipa_modem_attrs[] = {
+	&dev_attr_rx_endpoint_id.attr,
+	&dev_attr_tx_endpoint_id.attr,
+	NULL
+};
+
+const struct attribute_group ipa_modem_attribute_group = {
+	.name		= "modem",
+	.attrs		= ipa_modem_attrs,
+};
diff --git a/drivers/net/ipa/ipa_sysfs.h b/drivers/net/ipa/ipa_sysfs.h
new file mode 100644
index 0000000000000..b34e5650bf8cd
--- /dev/null
+++ b/drivers/net/ipa/ipa_sysfs.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2021 Linaro Ltd.
+ */
+#ifndef _IPA_SYSFS_H_
+#define _IPA_SYSFS_H_
+
+struct attribute_group;
+
+extern const struct attribute_group ipa_attribute_group;
+extern const struct attribute_group ipa_feature_attribute_group;
+extern const struct attribute_group ipa_modem_attribute_group;
+
+#endif /* _IPA_SYSFS_H_ */
diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
index ee2b3d02f3cd3..6c16c895d8429 100644
--- a/drivers/net/ipa/ipa_version.h
+++ b/drivers/net/ipa/ipa_version.h
@@ -21,6 +21,8 @@
  * @IPA_VERSION_4_11:	IPA version 4.11/GSI version 2.11 (2.1.1)
  *
  * Defines the version of IPA (and GSI) hardware present on the platform.
+ * Please update ipa_version_valid() and ipa_version_string() whenever a
+ * new version is added.
  */
 enum ipa_version {
 	IPA_VERSION_3_0,
-- 
2.27.0

