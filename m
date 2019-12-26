Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C70B12A9A2
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLZCQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:16:39 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45038 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbfLZCQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:16:35 -0500
Received: by mail-pg1-f195.google.com with SMTP id x7so12180725pgl.11;
        Wed, 25 Dec 2019 18:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n8ih2AdQhlW0qNsJZLfHPrYXlYifMpkcfOvwkII2NAs=;
        b=qSDEMnt7TuS2/gfPnUJLNrbs76bKTBMZAa0FgCP3APyyd87irSqSAmmK8KSk7+jkba
         Rmm14xNkFVM9+LTQ4dALUMFYpjlqktTi2AaFQdOJAch9SkDVeki9z4orBsyBCGlsIpbG
         C/UAeo/WQ4jxpizm0hb5Uzb4oeOGwhAwptHPr5aYUwOMN6gWLSaZP72b6/+0joqSYaeM
         8zVCfT3ssoJzawTNiyd5o+yf0384pnzz8+NmX19mQwSKM2bzBLUQc+3+SpC9W78aoxX1
         XUcCC8Q926p+itr+8fDLWA3hfPpG7hS4bfYAJs0tfqyGtKa43HaJJX6Ax+HO8V5fHYzV
         7Jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n8ih2AdQhlW0qNsJZLfHPrYXlYifMpkcfOvwkII2NAs=;
        b=GafE+W8RoOi754xa5fWhB91oSYL58UkxuI4UfA/lHHYXcM2Q8+RN+SAq7rvYacjTjG
         pgXoAfVbe6XfCM1oecubyGcUeupYUz/2DiOr+pud4jik+zOSRwIgZaJlQt/Wkk98wvQv
         4YKldBQWiMEzEJ9HTp6x02T3x5/+AZN4A9LxpaDqU7L83eESoNflNKsx7zDTXFGFcixq
         65IifoGObgFELwgmH0oIoqbs6XlH9dY8/lLFnVuU6zss2NFeaR9t6Q12QEjqkYGAFXz9
         E3jQT/HCONdLjUF0g/Bo1tryl7c3BOcpizD434jIkapf0OYVTcByRZNxnCx/9KSK62pW
         aX6Q==
X-Gm-Message-State: APjAAAWYoceVlSqJthZiJ1defpy61PbgR2T8iHifGcffOdRaHDclonuC
        klRyM3pbu5eMzPMbepdNRUax8XuK
X-Google-Smtp-Source: APXvYqwmibooQOfwgC2CvxXA289oYM20H/EXXzTCDDMTtSTwy2WLDHsKqWKyCYnK9Nzaz3L7tHe2GA==
X-Received: by 2002:a63:2d44:: with SMTP id t65mr48429335pgt.112.1577326593728;
        Wed, 25 Dec 2019 18:16:33 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b65sm31880723pgc.18.2019.12.25.18.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:16:33 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V9 net-next 08/12] net: Add a layer for non-PHY MII time stamping drivers.
Date:   Wed, 25 Dec 2019 18:16:16 -0800
Message-Id: <cc15136877e6e4c0a1aafe02307023178b05e2cb.1577326042.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While PHY time stamping drivers can simply attach their interface
directly to the PHY instance, stand alone drivers require support in
order to manage their services.  Non-PHY MII time stamping drivers
have a control interface over another bus like I2C, SPI, UART, or via
a memory mapped peripheral.  The controller device will be associated
with one or more time stamping channels, each of which sits snoops in
on a MII bus.

This patch provides a glue layer that will enable time stamping
channels to find their controlling device.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/Makefile          |   2 +
 drivers/net/phy/mii_timestamper.c | 125 ++++++++++++++++++++++++++++++
 include/linux/mii_timestamper.h   |  63 +++++++++++++++
 net/Kconfig                       |   7 +-
 4 files changed, 194 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mii_timestamper.c

diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index d846b4dc1c68..fe5badf13b65 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -43,6 +43,8 @@ obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
 obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)	+= mdio-xgene.o
 
+obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += mii_timestamper.o
+
 obj-$(CONFIG_SFP)		+= sfp.o
 sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
 obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
diff --git a/drivers/net/phy/mii_timestamper.c b/drivers/net/phy/mii_timestamper.c
new file mode 100644
index 000000000000..2f12c5d901df
--- /dev/null
+++ b/drivers/net/phy/mii_timestamper.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Support for generic time stamping devices on MII buses.
+// Copyright (C) 2018 Richard Cochran <richardcochran@gmail.com>
+//
+
+#include <linux/mii_timestamper.h>
+
+static LIST_HEAD(mii_timestamping_devices);
+static DEFINE_MUTEX(tstamping_devices_lock);
+
+struct mii_timestamping_desc {
+	struct list_head list;
+	struct mii_timestamping_ctrl *ctrl;
+	struct device *device;
+};
+
+/**
+ * register_mii_tstamp_controller() - registers an MII time stamping device.
+ *
+ * @device:	The device to be registered.
+ * @ctrl:	Pointer to device's control interface.
+ *
+ * Returns zero on success or non-zero on failure.
+ */
+int register_mii_tstamp_controller(struct device *device,
+				   struct mii_timestamping_ctrl *ctrl)
+{
+	struct mii_timestamping_desc *desc;
+
+	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&desc->list);
+	desc->ctrl = ctrl;
+	desc->device = device;
+
+	mutex_lock(&tstamping_devices_lock);
+	list_add_tail(&mii_timestamping_devices, &desc->list);
+	mutex_unlock(&tstamping_devices_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(register_mii_tstamp_controller);
+
+/**
+ * unregister_mii_tstamp_controller() - unregisters an MII time stamping device.
+ *
+ * @device:	A device previously passed to register_mii_tstamp_controller().
+ */
+void unregister_mii_tstamp_controller(struct device *device)
+{
+	struct mii_timestamping_desc *desc;
+	struct list_head *this, *next;
+
+	mutex_lock(&tstamping_devices_lock);
+	list_for_each_safe(this, next, &mii_timestamping_devices) {
+		desc = list_entry(this, struct mii_timestamping_desc, list);
+		if (desc->device == device) {
+			list_del_init(&desc->list);
+			kfree(desc);
+			break;
+		}
+	}
+	mutex_unlock(&tstamping_devices_lock);
+}
+EXPORT_SYMBOL(unregister_mii_tstamp_controller);
+
+/**
+ * register_mii_timestamper - Enables a given port of an MII time stamper.
+ *
+ * @node:	The device tree node of the MII time stamp controller.
+ * @port:	The index of the port to be enabled.
+ *
+ * Returns a valid interface on success or ERR_PTR otherwise.
+ */
+struct mii_timestamper *register_mii_timestamper(struct device_node *node,
+						 unsigned int port)
+{
+	struct mii_timestamper *mii_ts = NULL;
+	struct mii_timestamping_desc *desc;
+	struct list_head *this;
+
+	mutex_lock(&tstamping_devices_lock);
+	list_for_each(this, &mii_timestamping_devices) {
+		desc = list_entry(this, struct mii_timestamping_desc, list);
+		if (desc->device->of_node == node) {
+			mii_ts = desc->ctrl->probe_channel(desc->device, port);
+			if (!IS_ERR(mii_ts)) {
+				mii_ts->device = desc->device;
+				get_device(desc->device);
+			}
+			break;
+		}
+	}
+	mutex_unlock(&tstamping_devices_lock);
+
+	return mii_ts ? mii_ts : ERR_PTR(-EPROBE_DEFER);
+}
+EXPORT_SYMBOL(register_mii_timestamper);
+
+/**
+ * unregister_mii_timestamper - Disables a given MII time stamper.
+ *
+ * @mii_ts:	An interface obtained via register_mii_timestamper().
+ *
+ */
+void unregister_mii_timestamper(struct mii_timestamper *mii_ts)
+{
+	struct mii_timestamping_desc *desc;
+	struct list_head *this;
+
+	mutex_lock(&tstamping_devices_lock);
+	list_for_each(this, &mii_timestamping_devices) {
+		desc = list_entry(this, struct mii_timestamping_desc, list);
+		if (desc->device == mii_ts->device) {
+			desc->ctrl->release_channel(desc->device, mii_ts);
+			put_device(desc->device);
+			break;
+		}
+	}
+	mutex_unlock(&tstamping_devices_lock);
+}
+EXPORT_SYMBOL(unregister_mii_timestamper);
diff --git a/include/linux/mii_timestamper.h b/include/linux/mii_timestamper.h
index 36002386029c..fa940bbaf8ae 100644
--- a/include/linux/mii_timestamper.h
+++ b/include/linux/mii_timestamper.h
@@ -33,10 +33,15 @@ struct phy_device;
  *		the phy_device mutex.
  *
  * @ts_info:	Handles ethtool queries for hardware time stamping.
+ * @device:	Remembers the device to which the instance belongs.
  *
  * Drivers for PHY time stamping devices should embed their
  * mii_timestamper within a private structure, obtaining a reference
  * to it using container_of().
+ *
+ * Drivers for non-PHY time stamping devices should return a pointer
+ * to a mii_timestamper from the probe_channel() callback of their
+ * mii_timestamping_ctrl interface.
  */
 struct mii_timestamper {
 	bool (*rxtstamp)(struct mii_timestamper *mii_ts,
@@ -53,6 +58,64 @@ struct mii_timestamper {
 
 	int  (*ts_info)(struct mii_timestamper *mii_ts,
 			struct ethtool_ts_info *ts_info);
+
+	struct device *device;
+};
+
+/**
+ * struct mii_timestamping_ctrl - MII time stamping controller interface.
+ *
+ * @probe_channel:	Callback into the controller driver announcing the
+ *			presence of the 'port' channel.  The 'device' field
+ *			had been passed to register_mii_tstamp_controller().
+ *			The driver must return either a pointer to a valid
+ *			MII timestamper instance or PTR_ERR.
+ *
+ * @release_channel:	Releases an instance obtained via .probe_channel.
+ */
+struct mii_timestamping_ctrl {
+	struct mii_timestamper *(*probe_channel)(struct device *device,
+						 unsigned int port);
+	void (*release_channel)(struct device *device,
+				struct mii_timestamper *mii_ts);
 };
 
+#ifdef CONFIG_NETWORK_PHY_TIMESTAMPING
+
+int register_mii_tstamp_controller(struct device *device,
+				   struct mii_timestamping_ctrl *ctrl);
+
+void unregister_mii_tstamp_controller(struct device *device);
+
+struct mii_timestamper *register_mii_timestamper(struct device_node *node,
+						 unsigned int port);
+
+void unregister_mii_timestamper(struct mii_timestamper *mii_ts);
+
+#else
+
+static inline
+int register_mii_tstamp_controller(struct device *device,
+				   struct mii_timestamping_ctrl *ctrl)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void unregister_mii_tstamp_controller(struct device *device)
+{
+}
+
+static inline
+struct mii_timestamper *register_mii_timestamper(struct device_node *node,
+						 unsigned int port)
+{
+	return NULL;
+}
+
+static inline void unregister_mii_timestamper(struct mii_timestamper *mii_ts)
+{
+}
+
+#endif
+
 #endif
diff --git a/net/Kconfig b/net/Kconfig
index bd191f978a23..52af65e5d28c 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -108,9 +108,10 @@ config NETWORK_PHY_TIMESTAMPING
 	bool "Timestamping in PHY devices"
 	select NET_PTP_CLASSIFY
 	help
-	  This allows timestamping of network packets by PHYs with
-	  hardware timestamping capabilities. This option adds some
-	  overhead in the transmit and receive paths.
+	  This allows timestamping of network packets by PHYs (or
+	  other MII bus snooping devices) with hardware timestamping
+	  capabilities. This option adds some overhead in the transmit
+	  and receive paths.
 
 	  If you are unsure how to answer this question, answer N.
 
-- 
2.20.1

