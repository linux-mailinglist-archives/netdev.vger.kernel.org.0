Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C63F25A6E
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 00:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfEUWrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 18:47:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36399 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbfEUWra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 18:47:30 -0400
Received: by mail-pg1-f195.google.com with SMTP id a3so242595pgb.3;
        Tue, 21 May 2019 15:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PJqqiN+Wp5W/gapp80YAcA5W/ceWG+crZ/R8YC8HihQ=;
        b=CLozKzGOFQtvJNUjFKIYQC1kLGkv2IrXf8Hecw/a9CHOFFKETzpz41eDOqrqh4YZhC
         EDmx/ELR9ZqPLAsFHie9P19kWjkMuUeOR4IDtIguckCs/bhVlacfCkYwDwE3//YX5W0/
         W11D3MZsEkTl4w/f/mxZgtyyC7+CaOGZuu/d0CbURPDwkPnWTtW/o8XpmEU2ZGa09kCJ
         galJXLjtrRoMFHmty9Nq1h3KyyKsIy377LJzUl0FS3/iVnNEhljqxdg6nXOV+Xtqu4vL
         6I0k2zF/pGrUFiSp4vzyIxSHysR2uNKNqVFHAzgD6x/D2Nnj5sJdiLMkFnfGQzV15Mn0
         j0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PJqqiN+Wp5W/gapp80YAcA5W/ceWG+crZ/R8YC8HihQ=;
        b=dz0drG1r+vv4q1zgUB790ompHhQjsGeiN8asHRrNYvsC+bJGrhELlJZ312dxC5kXjY
         Se/HlZLAZWY1ftm1nayQ7skwXVxkRw4S/Gz5IhCx6S99zsUZ6aOFph4tZoLEQkjIzIgf
         /xsAaABoZ9d8xCsB7wlCEDirZCQNHGAUsZ8BQWfPCOacSaeDqqIS58oTZRnELg3SP7Jq
         8h3kQOkKW6gAalOhtLiuog3ay4lhmGuzUW3mydXBiiYGuGN8w6TQHw1UhrYwn//6b+VJ
         ojOLRQ3a/8TNeNHEfINm6hGV4gnmY91d9bcgroz5VhUGVUVp8/+hiIm4SMUbtphSQ6T0
         E5mQ==
X-Gm-Message-State: APjAAAUI83O7amPQns/QipKcRBxxkOqR6tYoLFcIqyKCXQ9orQ6507NM
        LXXpdddAef6RHEacTK5K+o8Tff+B
X-Google-Smtp-Source: APXvYqxKg6tM1oGNLjjrY5T4K3zEHKErl/ZTxUXsR2WJ1u4STPlHjUEwVt/ZDCNETZtoEV5eTDANxg==
X-Received: by 2002:a62:e718:: with SMTP id s24mr5266997pfh.247.1558478849625;
        Tue, 21 May 2019 15:47:29 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id r29sm34122419pgn.14.2019.05.21.15.47.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 15:47:28 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH V3 net-next 3/6] net: Add a layer for non-PHY MII time stamping drivers.
Date:   Tue, 21 May 2019 15:47:20 -0700
Message-Id: <20190521224723.6116-4-richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While PHY time stamping drivers can simply attach their interface
directly to the PHY instance, stand alone drivers require support in
order to manage their services.  Non-PHY MII time stamping drivers
have a control interface over another bus like I2C, SPI, UART, or via
a memory mapped peripheral.  The controller device will be associated
with one or more time stamping channels, each of which snoops on a MII
bus.

This patch provides a glue layer that will enable time stamping
channels to find their controlling device.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/Makefile          |   2 +
 drivers/net/phy/mii_timestamper.c | 121 ++++++++++++++++++++++++++++++++++++++
 include/linux/mii_timestamper.h   |  64 ++++++++++++++++++++
 net/Kconfig                       |   7 ++-
 4 files changed, 191 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mii_timestamper.c

diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 27d7f9f3b0de..0f1b1d9e440e 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -42,6 +42,8 @@ obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
 obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)	+= mdio-xgene.o
 
+obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += mii_timestamper.o
+
 obj-$(CONFIG_SFP)		+= sfp.o
 sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
 obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
diff --git a/drivers/net/phy/mii_timestamper.c b/drivers/net/phy/mii_timestamper.c
new file mode 100644
index 000000000000..51b77fc92475
--- /dev/null
+++ b/drivers/net/phy/mii_timestamper.c
@@ -0,0 +1,121 @@
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
+			if (mii_ts) {
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
diff --git a/include/linux/mii_timestamper.h b/include/linux/mii_timestamper.h
index 97e20e7033f6..3903f0d675b0 100644
--- a/include/linux/mii_timestamper.h
+++ b/include/linux/mii_timestamper.h
@@ -8,6 +8,7 @@
 
 #include <linux/device.h>
 #include <linux/ethtool.h>
+#include <linux/phy.h>
 #include <linux/skbuff.h>
 
 /**
@@ -27,10 +28,15 @@
  * @hwtstamp:	Handles SIOCSHWTSTAMP ioctl for hardware time stamping.
  * @link_state:	Allows the device to respond to changes in the link state.
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
@@ -47,6 +53,64 @@ struct mii_timestamper {
 
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
index 3e8fdd688329..7d80c6c28962 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -109,9 +109,10 @@ config NETWORK_PHY_TIMESTAMPING
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
2.11.0

