Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8C716BE24
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgBYKBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:01:14 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:35740 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729183AbgBYKBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:01:13 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j6X1S-009J5d-9N; Tue, 25 Feb 2020 11:01:02 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, Alex Elder <elder@linaro.org>,
        m.chetan.kumar@intel.com, Dan Williams <dcbw@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] wwan: add a new WWAN subsystem
Date:   Tue, 25 Feb 2020 11:00:53 +0100
Message-Id: <20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225100053.16385-1-johannes@sipsolutions.net>
References: <20200225100053.16385-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Today, Linux has no concept of a WWAN device, which isn't a huge
surprise given the variety of such devices and their layouts. At
the same time, there's clearly a need to control WWAN devices at
a lower level than what the control channels to the devices can
do, as evidenced by the fact that we have today quite a few ways
of interacting with devices:
 * drivers/net/usb/cdc_mbim.c (and some like it) pretend to just
   have a single netdev, but really that netdev is useless without
   the added channels on top, which are implemented with VLAN tags
   with certain (mostly hard-coded) numbers
 * Qualcomm modems have their own underlying encapsulation format,
   and rmnet has managed to enshrine that into the kernel not just
   as a transport but also as an API
 * drivers/net/usb/qmi_wwan.c is also for a Qualcomm modem, but it
   doesn't use rmnet (despite some similarities), instead it uses
   sysfs to configure the channels to the modem.
 * There are probably more and different ones, in-tree and out-of-
   tree, that I don't have on my radar right now.

For the upcoming Intel 4G modem driver ("iosm"), there's a need to
have such a control channel, to create and configure various types
of devices representing the various communication channels with
and through the modem, perhaps most importantly of course netdevs
for IP connectivity.

Originally, the driver was written to use VLAN devices in a similar
way to the CDC-MBIM driver mentioned above, but that has a number
of drawbacks:
 * VLANs really have no place here, there's no 802.1Q or anything,
   they were just used as a (somewhat convenient) way of getting
   multiple netdevs with an existing configuration interface;
 * the necessary underlying "netdev" is completely useless, it can
   _only_ accept "fake VLAN" traffic, nothing else;
 * VLAN netdevs aren't under the driver's control, so ethtool and
   other tools could only be used for global but not per-channel
   configuration, if at all; similarly, e.g. queue management is
   tricky (if at all possible), etc.
(Those are my main points, there are probably others.)

One issue in comining up with the notion of a "WWAN device" is that
a typical WWAN device (especially USB ones) is not composed of just
a single function, but may have one or multiple network functions,
some TTYs for control, etc. These are actually not even seen by a
single driver in Linux, but various. An additional wrinkle is that
each of those drivers will not be aware of the others, and also be
a driver for a generic network or TTY device (for example), so by
itself it cannot even know it's dealing with a unified WWAN device.

To still achieve a unified model, we allow each WWAN device to be
composed of "component devices". Each component device can offer a
certain subset of the overall functionality (which is shown in the
struct wwan_component_device_ops). This isn't implemented right now,
but ultimately it will allow us to have a "tentative" state, where
a number component drivers register their component, but the full
WWAN device is only formed if any one of them says that it indeed
knows for sure that it's a piece of a WWAN device, or perhaps by
some other heuristic.

Right now, the WWAN subsystem implements a subset of these ideas:
 * each WWAN device (struct wwan_device) has a list of components
   and offers a unified view in WWAN netlink
 * each component device (struct wwan_component_device) registers
   its operations with the overall WWAN device
 * currently, only netdev management capability is supported, but
   this will likely have to be extended by some form of TTY device
   before it's usable for any given driver/device
 * wwan_add() cannot do the tentative behaviour described above

Co-developed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 MAINTAINERS               |  10 ++
 include/net/wwan.h        |  98 +++++++++++++++
 include/uapi/linux/wwan.h | 144 ++++++++++++++++++++++
 net/Kconfig               |   1 +
 net/Makefile              |   2 +
 net/wwan/Kconfig          |  11 ++
 net/wwan/Makefile         |   5 +
 net/wwan/chan.c           |  69 +++++++++++
 net/wwan/core.c           | 193 +++++++++++++++++++++++++++++
 net/wwan/core.h           |  36 ++++++
 net/wwan/nl.c             | 247 ++++++++++++++++++++++++++++++++++++++
 net/wwan/sysfs.c          |  49 ++++++++
 12 files changed, 865 insertions(+)
 create mode 100644 include/net/wwan.h
 create mode 100644 include/uapi/linux/wwan.h
 create mode 100644 net/wwan/Kconfig
 create mode 100644 net/wwan/Makefile
 create mode 100644 net/wwan/chan.c
 create mode 100644 net/wwan/core.c
 create mode 100644 net/wwan/core.h
 create mode 100644 net/wwan/nl.c
 create mode 100644 net/wwan/sysfs.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c74e4ea714a5..3e06b9de4e0b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18116,6 +18116,16 @@ F:	include/linux/workqueue.h
 F:	kernel/workqueue.c
 F:	Documentation/core-api/workqueue.rst
 
+WWAN STACK
+M:	Johannes Berg <johannes@sipsolutions.net>
+L:	linux-wireless@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/wwan.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/wwan-next.git
+S:	Maintained
+F:	include/net/wwan.h
+F:	include/uapi/linux/wwan.h
+F:	net/wwan/
+
 X-POWERS AXP288 PMIC DRIVERS
 M:	Hans de Goede <hdegoede@redhat.com>
 S:	Maintained
diff --git a/include/net/wwan.h b/include/net/wwan.h
new file mode 100644
index 000000000000..7d86ef84fa07
--- /dev/null
+++ b/include/net/wwan.h
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * WWAN stack interfaces
+ *
+ * Copyright (C) 2019 - 2020 Intel Corporation
+ *
+ * This defines the interaction of WWAN drivers with the WWAN stack,
+ * which allows userspace configuration of sessions etc.
+ */
+#ifndef __NET_WWAN_H
+#define __NET_WWAN_H
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <uapi/linux/wwan.h>
+
+struct wwan_device {
+	u32 id;
+	struct device dev;
+/* private: */
+	struct mutex mtx;
+	struct list_head list;
+	struct list_head components;
+	struct list_head channels;
+};
+
+struct wwan_component_device {
+	struct wwan_device *wwan;
+	struct list_head list;
+	const struct wwan_component_device_ops *ops;
+};
+
+struct wwan_channel {
+	struct list_head list;
+	enum wwan_chan_type type;
+	struct wwan_component_device *owner;
+	union {
+		struct net_device *netdev;
+	};
+};
+
+/**
+ * struct wwan_netdev_config - WWAN netdevice configuration
+ * @id: channel identifier this netdev uses
+ */
+struct wwan_netdev_config {
+	u32 id;
+};
+
+/**
+ * wwan_component_device_ops - WWAN component device operations
+ */
+struct wwan_component_device_ops {
+	/**
+	 * @add_netdev: Add a new netdev with the given configuration, must
+	 *	return the new netdev pointer, the resulting netdev will be
+	 *	attached to the WWAN device automatically; return ERR_PTR()
+	 *	on failures.
+	 */
+	struct net_device *(*add_netdev)(struct wwan_component_device *comp,
+					 struct wwan_netdev_config *config);
+
+	/**
+	 * @remove_netdev: remove the given netdev
+	 */
+	int (*remove_netdev)(struct wwan_component_device *comp,
+			     struct net_device *dev);
+};
+
+/**
+ * wwan_add - add a component to a WWAN device without preconfigured channels
+ * @dev: underlying struct device
+ * @comp: the component to add to the WWAN device
+ *
+ * Returns: a struct wwan_device pointer, or an ERR_PTR().
+ *
+ * Note that the WWAN device need not exist before calling this, in this case
+ * it will be created.
+ *
+ * TODO: we probably want another struct device pointer here that actually
+ *	 links to the component device, e.g. the USB interface when the @dev
+ *	 is the overall USB device ... just for discoverability
+ */
+struct wwan_device *
+wwan_add(struct device *dev, struct wwan_component_device *comp);
+
+/**
+ * wwan_remove - remove the given component from the WWAN device
+ * @comp: WWAN component device to remove.
+ *
+ * Note that the WWAN device may not be fully removed if it still has
+ * any channels attached, but nonetheless callers must assume that the
+ * pointer is no longer valid after calling this function.
+ */
+void wwan_remove(struct wwan_component_device *comp);
+
+#endif /* __NET_WWAN_H */
diff --git a/include/uapi/linux/wwan.h b/include/uapi/linux/wwan.h
new file mode 100644
index 000000000000..b013cc46e96e
--- /dev/null
+++ b/include/uapi/linux/wwan.h
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
+/*
+ * WWAN generic netlink interfaces
+ *
+ * Copyright (C) 2019 - 2020 Intel Corporation
+ *
+ * This defines the WWAN generic netlink family APIs for userspace
+ * to control WWAN devices.
+ */
+#ifndef __UAPI_LINUX_WWAN_H
+#define __UAPI_LINUX_WWAN_H
+#include <linux/types.h>
+
+#define WWAN_GENL_NAME "wwan"
+
+#define WWAN_MULTICAST_GROUP_CFG "cfg"
+
+/**
+ * enum wwan_commands - WWAN netlink commands
+ * @WWAN_CMD_UNSPEC: reserved
+ * @WWAN_CMD_GET_DEVICE: dump device information
+ * @WWAN_CMD_SET_DEVICE: set device information
+ * @WWAN_CMD_NEW_DEVICE: new device notification
+ * @WWAN_CMD_DEL_DEVICE: device removal notification
+ * @WWAN_CMD_GET_CHANNEL: dump channel information
+ * @WWAN_CMD_SET_CHANNEL: reserved, not supported now
+ * @WWAN_CMD_NEW_CHANNEL: new channel command or notification
+ * @WWAN_CMD_DEL_CHANNEL: netdev removal channel or notification
+ * @WWAN_CMD_NUM: number of enum entries
+ * @WWAN_CMD_MAX: highest command number
+ */
+enum wwan_commands {
+	WWAN_CMD_UNSPEC,
+
+	WWAN_CMD_GET_DEVICE,
+	WWAN_CMD_SET_DEVICE,
+	WWAN_CMD_NEW_DEVICE,
+	WWAN_CMD_DEL_DEVICE,
+
+	WWAN_CMD_GET_CHANNEL,
+	WWAN_CMD_SET_CHANNEL,
+	WWAN_CMD_NEW_CHANNEL,
+	WWAN_CMD_DEL_CHANNEL,
+
+	/* add new commands here, don't reorder anything */
+
+	/* keep last */
+	WWAN_CMD_NUM,
+	WWAN_CMD_MAX = WWAN_CMD_NUM - 1
+};
+
+/**
+ * enum wwan_chan_type - WWAN communication channel type
+ * @WWAN_CHAN_TYPE_IP: IP channel (netdev)
+ */
+enum wwan_chan_type {
+	WWAN_CHAN_TYPE_IP,
+
+	/* add new types here, don't reorder anything */
+
+	WWAN_CHAN_TYPE_NUM,
+	WWAN_CHAN_TYPE_MAX = WWAN_CHAN_TYPE_NUM - 1
+};
+
+/**
+ * enum wwan_chan_attrs - channel attributes
+ */
+enum wwan_chan_attrs {
+	/**
+	 * @WWAN_CHAN_ATTR_UNSPEC: unused/reserved
+	 */
+	WWAN_CHAN_ATTR_UNSPEC,
+
+	/**
+	 * @WWAN_CHAN_ATTR_TYPE: channel type according to
+	 *	&enum wwan_chan_type [u32]
+	 */
+	WWAN_CHAN_ATTR_TYPE,
+
+	/**
+	 * @WWAN_CHAN_ATTR_IDX: channel index (e.g. for IP channels) [u32]
+	 */
+	WWAN_CHAN_ATTR_IDX,
+
+	/**
+	 * @WWAN_CHAN_ATTR_IFIDX: interface index (for netdev channels) [u32]
+	 */
+	WWAN_CHAN_ATTR_IFIDX,
+
+	/* add new attributes here, don't reorder anything */
+
+	/* keep last */
+	/**
+	 * @WWAN_CHAN_ATTR_NUM: number of attributes
+	 */
+	WWAN_CHAN_ATTR_NUM,
+
+	/**
+	 * @WWAN_CHAN_ATTR_MAX: highest valid attribute number
+	 */
+	WWAN_CHAN_ATTR_MAX = WWAN_CHAN_ATTR_NUM - 1
+};
+
+/**
+ * enum wwan_attrs - WWAN netlink attributes
+ */
+enum wwan_attrs {
+	/**
+	 * @WWAN_ATTR_UNSPEC: unused/reserved
+	 */
+	WWAN_ATTR_UNSPEC,
+
+	/**
+	 * @WWAN_ATTR_DEVICE_ID: device ID [u32]
+	 */
+	WWAN_ATTR_DEVICE_ID,
+
+	/**
+	 * @WWAN_ATTR_CHANNEL: nested attribute containing a single channel
+	 *	for creation or parameter modification [nested]
+	 */
+	WWAN_ATTR_CHANNEL,
+
+	/**
+	 * @WWAN_ATTR_CHANNELS: nested array of channels in dump, using
+	 *	the &enum wwan_chan_attrs [nested array]
+	 */
+	WWAN_ATTR_CHANNELS,
+
+	/* add new attributes here, don't reorder anything */
+
+	/* keep last */
+	/**
+	 * @WWAN_ATTR_NUM: number of attributes
+	 */
+	WWAN_ATTR_NUM,
+
+	/**
+	 * @WWAN_ATTR_MAX: highest valid attribute number
+	 */
+	WWAN_ATTR_MAX = WWAN_ATTR_NUM - 1
+};
+
+#endif /* __UAPI_LINUX_WWAN_H */
diff --git a/net/Kconfig b/net/Kconfig
index b0937a700f01..f2e639ea4550 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -63,6 +63,7 @@ source "net/tls/Kconfig"
 source "net/xfrm/Kconfig"
 source "net/iucv/Kconfig"
 source "net/smc/Kconfig"
+source "net/wwan/Kconfig"
 source "net/xdp/Kconfig"
 
 config INET
diff --git a/net/Makefile b/net/Makefile
index 07ea48160874..07efe8401c66 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -67,6 +67,8 @@ ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
 endif
 obj-$(CONFIG_WIMAX)		+= wimax/
+obj-$(CONFIG_WWAN)		+= wwan/
+
 obj-$(CONFIG_DNS_RESOLVER)	+= dns_resolver/
 obj-$(CONFIG_CEPH_LIB)		+= ceph/
 obj-$(CONFIG_BATMAN_ADV)	+= batman-adv/
diff --git a/net/wwan/Kconfig b/net/wwan/Kconfig
new file mode 100644
index 000000000000..5d65e8292a30
--- /dev/null
+++ b/net/wwan/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config WWAN
+	tristate "common WWAN stack"
+	depends on NET
+	help
+	  This is a WWAN device configuration API, used by some drivers,
+	  that allows discovering and managing WWAN devices.
+
+	  Enable this if you have a WWAN device that uses this.
+
+	  When built as a module it will be called wwan.ko
diff --git a/net/wwan/Makefile b/net/wwan/Makefile
new file mode 100644
index 000000000000..823b21be38cb
--- /dev/null
+++ b/net/wwan/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_WWAN)	+= wwan.o
+
+wwan-y			:= core.o sysfs.o chan.o nl.o
diff --git a/net/wwan/chan.c b/net/wwan/chan.c
new file mode 100644
index 000000000000..49e57b4c58cc
--- /dev/null
+++ b/net/wwan/chan.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2019 - 2020 Intel Corporation
+ */
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <net/wwan.h>
+#include "core.h"
+
+void wwan_chan_remove(struct wwan_device *wwan,
+		      struct wwan_channel *chan)
+{
+	lockdep_assert_held(&wwan->mtx);
+
+	switch (chan->type) {
+	case WWAN_CHAN_TYPE_IP:
+		chan->owner->ops->remove_netdev(chan->owner, chan->netdev);
+		break;
+	case WWAN_CHAN_TYPE_NUM:
+		WARN(1, "Invalid channel type %d\n", chan->type);
+		break;
+	}
+
+	list_del(&chan->list);
+	kfree(chan);
+}
+
+int wwan_chan_add_netdev(struct wwan_device *wwan,
+			 struct wwan_netdev_config *cfg,
+			 struct netlink_ext_ack *extack)
+{
+	struct wwan_component_device *tmp, *comp = NULL;
+	struct wwan_channel *chan;
+	struct net_device *netdev;
+
+	lockdep_assert_held(&wwan->mtx);
+
+	list_for_each_entry(tmp, &wwan->components, list) {
+		if (tmp->ops->add_netdev) {
+			comp = tmp;
+			break;
+		}
+	}
+
+	if (!comp) {
+		NL_SET_ERR_MSG(extack,
+			       "no components supports adding IP channels");
+		return -EOPNOTSUPP;
+	}
+
+	chan = kzalloc(sizeof(*chan), GFP_KERNEL);
+	if (!chan)
+		return -ENOMEM;
+
+	netdev = comp->ops->add_netdev(comp, cfg);
+	if (IS_ERR(netdev)) {
+		kfree(chan);
+		return PTR_ERR(netdev);
+	}
+
+	chan->type = WWAN_CHAN_TYPE_IP;
+	chan->netdev = netdev;
+	chan->owner = comp;
+	list_add_tail(&chan->list, &wwan->channels);
+
+	return 0;
+}
diff --git a/net/wwan/core.c b/net/wwan/core.c
new file mode 100644
index 000000000000..dc018846cf89
--- /dev/null
+++ b/net/wwan/core.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2019 - 2020 Intel Corporation
+ */
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <net/wwan.h>
+#include "core.h"
+
+struct mutex wwan_mtx;
+LIST_HEAD(wwan_devices);
+
+static u32 wwan_id_counter;
+
+static struct wwan_device *wwan_find_by_dev(struct device *dev)
+{
+	struct wwan_device *wwan;
+
+	lockdep_assert_held(&wwan_mtx);
+
+	list_for_each_entry(wwan, &wwan_devices, list) {
+		if (wwan->dev.parent == dev)
+			return wwan;
+	}
+
+	return NULL;
+}
+
+static int wwan_check_new_component(struct wwan_device *wwan,
+				    struct wwan_component_device *comp)
+{
+	struct wwan_component_device *tmp;
+
+	lockdep_assert_held(&wwan_mtx);
+
+	list_for_each_entry(tmp, &wwan->components, list) {
+		if (WARN_ON(tmp == comp))
+			return -EBUSY;
+#define WWAN_CHECK_OP(op) 				\
+		if (tmp->ops->op && comp->ops->op)	\
+			return -EINVAL;
+
+		WWAN_CHECK_OP(add_netdev)
+		WWAN_CHECK_OP(remove_netdev)
+	}
+
+	return 0;
+}
+
+static struct wwan_device *wwan_create(struct device *dev)
+{
+	struct wwan_device *wwan = kzalloc(sizeof(*wwan), GFP_KERNEL);
+	u32 id = ++wwan_id_counter;
+	int err;
+
+	lockdep_assert_held(&wwan_mtx);
+
+	if (WARN_ON(!id))
+		return ERR_PTR(-ENOSPC);
+
+	if (!wwan)
+		return ERR_PTR(-ENOMEM);
+
+	wwan->id = id;
+	INIT_LIST_HEAD(&wwan->list);
+	INIT_LIST_HEAD(&wwan->components);
+	INIT_LIST_HEAD(&wwan->channels);
+	wwan->dev.init_name = "wwan";
+	wwan->dev.class = &wwan_class;
+	wwan->dev.parent = dev;
+
+	err = device_register(&wwan->dev);
+	if (err) {
+		put_device(&wwan->dev);
+		return ERR_PTR(err);
+	}
+
+	list_add_tail(&wwan->list, &wwan_devices);
+	mutex_init(&wwan->mtx);
+
+	return wwan;
+}
+
+struct wwan_device *
+wwan_add(struct device *dev, struct wwan_component_device *comp)
+{
+	struct wwan_device *wwan;
+
+	if (WARN_ON(!comp->ops))
+		return ERR_PTR(-EINVAL);
+
+	if (WARN_ON(comp->wwan))
+		return ERR_PTR(-EBUSY);
+
+	mutex_lock(&wwan_mtx);
+	wwan = wwan_find_by_dev(dev);
+	if (wwan) {
+		int err = wwan_check_new_component(wwan, comp);
+
+		if (err) {
+			wwan = ERR_PTR(err);
+			goto out;
+		}
+		/* wwan_create() already has a reference */
+		get_device(&wwan->dev);
+	} else {
+		wwan = wwan_create(dev);
+		if (IS_ERR(wwan))
+			goto out;
+	}
+
+	mutex_lock(&wwan->mtx);
+	list_add_tail(&comp->list, &wwan->components);
+	comp->wwan = wwan;
+	mutex_unlock(&wwan->mtx);
+out:
+	mutex_unlock(&wwan_mtx);
+	return wwan;
+}
+EXPORT_SYMBOL_GPL(wwan_add);
+
+void wwan_remove(struct wwan_component_device *comp)
+{
+	struct wwan_device *wwan = comp->wwan;
+	struct wwan_channel *chan;
+
+	if (WARN_ON(!wwan))
+		return;
+
+	mutex_lock(&wwan_mtx);
+	mutex_lock(&wwan->mtx);
+	list_for_each_entry(chan, &wwan->channels, list) {
+		if (chan->owner != comp)
+			continue;
+		wwan_chan_remove(wwan, chan);
+	}
+	list_del_init(&comp->list);
+	comp->wwan = NULL;
+
+	if (list_empty(&wwan->components)) {
+		device_unregister(&wwan->dev);
+		list_del(&wwan->list);
+	} else {
+		put_device(&wwan->dev);
+	}
+	mutex_unlock(&wwan->mtx);
+	mutex_unlock(&wwan_mtx);
+}
+EXPORT_SYMBOL_GPL(wwan_remove);
+
+void wwan_dev_release(struct device *dev)
+{
+	struct wwan_device *wwan = dev_to_wwan(dev);
+
+	WARN_ON(!list_empty(&wwan->components));
+	WARN_ON(!list_empty(&wwan->channels));
+
+	mutex_destroy(&wwan->mtx);
+	kfree(wwan);
+}
+
+int __init wwan_init(void)
+{
+	int err;
+
+	mutex_init(&wwan_mtx);
+
+	err = wwan_sysfs_init();
+	if (err)
+		goto exit_nl;
+
+	err = wwan_nl_init();
+	if (err)
+		return err;
+
+	return 0;
+exit_nl:
+	wwan_nl_exit();
+	return err;
+}
+module_init(wwan_init);
+
+void wwan_exit(void)
+{
+	wwan_nl_exit();
+	wwan_sysfs_exit();
+	mutex_destroy(&wwan_mtx);
+}
+module_exit(wwan_exit);
+MODULE_LICENSE("GPL v2");
diff --git a/net/wwan/core.h b/net/wwan/core.h
new file mode 100644
index 000000000000..923abfd2fa1a
--- /dev/null
+++ b/net/wwan/core.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * WWAN internals
+ *
+ * Copyright (C) 2019 - 2020 Intel Corporation
+ */
+#ifndef __NET_WWAN_CORE_H
+#define __NET_WWAN_CORE_H
+#include <linux/mutex.h>
+#include <net/netlink.h>
+#include <net/wwan.h>
+
+extern struct mutex wwan_mtx;
+extern struct list_head wwan_devices;
+
+static inline struct wwan_device *dev_to_wwan(struct device *dev)
+{
+	return container_of(dev, struct wwan_device, dev);
+}
+
+void wwan_dev_release(struct device *dev);
+
+extern struct class wwan_class;
+int __init wwan_sysfs_init(void);
+void wwan_sysfs_exit(void);
+
+int __init wwan_nl_init(void);
+void wwan_nl_exit(void);
+
+int wwan_chan_add_netdev(struct wwan_device *wwan,
+			 struct wwan_netdev_config *cfg,
+			 struct netlink_ext_ack *extack);
+void wwan_chan_remove(struct wwan_device *wwan,
+		      struct wwan_channel *chan);
+
+#endif /* __NET_WWAN_CORE_H */
diff --git a/net/wwan/nl.c b/net/wwan/nl.c
new file mode 100644
index 000000000000..d4b59dc08b13
--- /dev/null
+++ b/net/wwan/nl.c
@@ -0,0 +1,247 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * WWAN netlink interface
+ *
+ * Copyright (C) 2019 - 2020 Intel Corporation
+ */
+#include <net/genetlink.h>
+#include <linux/netdevice.h>
+#include <net/wwan.h>
+#include "core.h"
+
+/* the netlink family */
+static struct genl_family wwan_fam;
+
+/* multicast groups */
+enum wwan_multicast_groups {
+	WWAN_MCGRP_CFG,
+};
+
+static const struct genl_multicast_group wwan_mcgrps[] = {
+	[WWAN_MCGRP_CFG] = { .name = WWAN_MULTICAST_GROUP_CFG },
+};
+
+static inline struct wwan_device *info_wwan(struct genl_info *info)
+{
+	return info->user_ptr[0];
+}
+
+static inline struct wwan_channel *info_chan(struct genl_info *info)
+{
+	return info->user_ptr[1];
+}
+
+static struct wwan_channel *wwan_nl_find_netdev(u32 ifidx)
+{
+	struct wwan_device *wwan;
+	struct wwan_channel *chan;
+
+	lockdep_assert_held(&wwan_mtx);
+
+	list_for_each_entry(wwan, &wwan_devices, list) {
+		list_for_each_entry(chan, &wwan->channels, list) {
+			if (chan->type != WWAN_CHAN_TYPE_IP)
+				continue;
+			if (chan->netdev->ifindex != ifidx)
+				continue;
+			return chan;
+		}
+	}
+
+	return NULL;
+}
+
+static int wwan_nl_find(struct nlattr **attrs, struct netlink_ext_ack *extack,
+			struct wwan_device **wwan, struct wwan_channel **chan)
+{
+	struct wwan_device *twwan;
+
+	*wwan = NULL;
+	*chan = NULL;
+
+	lockdep_assert_held(&wwan_mtx);
+
+	if (attrs[WWAN_ATTR_DEVICE_ID]) {
+		u32 id = nla_get_u32(attrs[WWAN_ATTR_DEVICE_ID]);
+
+		list_for_each_entry(twwan, &wwan_devices, list) {
+			if (twwan->id == id) {
+				*wwan = twwan;
+				break;
+			}
+		}
+	}
+
+	if (attrs[WWAN_ATTR_CHANNEL]) {
+		struct nlattr *tb[WWAN_CHAN_ATTR_NUM];
+
+		nla_parse_nested(tb, WWAN_CHAN_ATTR_MAX,
+				 attrs[WWAN_ATTR_CHANNEL],
+				 NULL, extack);
+
+		if (tb[WWAN_CHAN_ATTR_IFIDX]) {
+			u32 ifidx = nla_get_u32(tb[WWAN_CHAN_ATTR_IFIDX]);
+
+			*chan = wwan_nl_find_netdev(ifidx);
+		}
+	}
+
+	if (!*wwan) {
+		NL_SET_ERR_MSG(extack, "WWAN device is required");
+		return -ENOENT;
+	}
+
+	if (*chan && (*chan)->owner->wwan != *wwan) {
+		NL_SET_ERR_MSG(extack, "Channel doesn't belong to WWAN device");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int wwan_new_netdev_channel(struct genl_info *info, struct nlattr **tb)
+{
+	struct wwan_netdev_config cfg = {};
+
+	if (!tb[WWAN_CHAN_ATTR_IDX]) {
+		GENL_SET_ERR_MSG(info, "channel index is required");
+		return -EINVAL;
+	}
+
+	cfg.id = nla_get_u32(tb[WWAN_CHAN_ATTR_IDX]);
+
+	return wwan_chan_add_netdev(info_wwan(info), &cfg, info->extack);
+}
+
+static int wwan_do_new_channel(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[WWAN_CHAN_ATTR_NUM];
+
+	if (!info->attrs[WWAN_ATTR_CHANNEL]) {
+		GENL_SET_ERR_MSG(info, "channel config is required");
+		return -EINVAL;
+	}
+
+	nla_parse_nested(tb, WWAN_CHAN_ATTR_MAX,
+			 info->attrs[WWAN_ATTR_CHANNEL],
+			 NULL, info->extack);
+
+	if (!tb[WWAN_CHAN_ATTR_TYPE]) {
+		GENL_SET_ERR_MSG(info, "channel type is required");
+		return -EINVAL;
+	}
+
+	switch (nla_get_u32(tb[WWAN_CHAN_ATTR_TYPE])) {
+	case WWAN_CHAN_TYPE_IP:
+		return wwan_new_netdev_channel(info, tb);
+	default:
+		/* should not be possibly according to policy */
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+}
+
+static int wwan_do_del_channel(struct sk_buff *skb, struct genl_info *info)
+{
+	wwan_chan_remove(info_wwan(info), info_chan(info));
+
+	return 0;
+}
+
+#define NEED_MTX	BIT(0)
+#define NEED_WWAN	BIT(1)
+#define NEED_CHANNEL	BIT(2)
+
+static int wwan_nl_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
+			    struct genl_info *info)
+{
+	int err;
+
+	mutex_lock(&wwan_mtx);
+
+	if (ops->internal_flags & (NEED_WWAN | NEED_CHANNEL)) {
+		err = wwan_nl_find(info->attrs, info->extack,
+				   (void *)&info->user_ptr[0],
+				   (void *)&info->user_ptr[1]);
+		if (err)
+			goto out;
+	}
+
+	if ((ops->internal_flags & NEED_CHANNEL) && !info_chan(info)) {
+		GENL_SET_ERR_MSG(info, "Channel is required");
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (ops->internal_flags & (NEED_WWAN | NEED_CHANNEL))
+		mutex_lock(&info_wwan(info)->mtx);
+
+	if (!(ops->internal_flags & NEED_MTX))
+		mutex_unlock(&wwan_mtx);
+
+	return 0;
+out:
+	mutex_unlock(&wwan_mtx);
+	return err;
+}
+
+static void wwan_nl_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
+			      struct genl_info *info)
+{
+	if (ops->internal_flags & (NEED_WWAN | NEED_CHANNEL))
+		mutex_unlock(&info_wwan(info)->mtx);
+
+	if (ops->internal_flags & NEED_MTX)
+		mutex_unlock(&wwan_mtx);
+}
+
+static const struct genl_ops wwan_ops[] = {
+	{
+		.cmd = WWAN_CMD_NEW_CHANNEL,
+		.doit = wwan_do_new_channel,
+		.internal_flags = NEED_WWAN,
+	},
+	{
+		.cmd = WWAN_CMD_DEL_CHANNEL,
+		.doit = wwan_do_del_channel,
+		.internal_flags = NEED_CHANNEL,
+	},
+};
+
+static const struct nla_policy wwan_chan_policy[WWAN_CHAN_ATTR_NUM] = {
+	[WWAN_CHAN_ATTR_TYPE] = NLA_POLICY_RANGE(NLA_U32, 0, WWAN_CHAN_TYPE_MAX),
+	[WWAN_CHAN_ATTR_IDX] = { .type = NLA_U32 },
+	[WWAN_CHAN_ATTR_IFIDX] = { .type = NLA_U32 },
+};
+
+static const struct nla_policy wwan_policy[WWAN_ATTR_NUM] = {
+	[WWAN_ATTR_DEVICE_ID] = { .type = NLA_U32 },
+	[WWAN_ATTR_CHANNEL] = NLA_POLICY_NESTED(wwan_chan_policy),
+	[WWAN_ATTR_CHANNELS] = NLA_POLICY_NESTED_ARRAY(wwan_chan_policy),
+};
+
+static struct genl_family wwan_fam __ro_after_init = {
+	.name = WWAN_GENL_NAME,
+	.hdrsize = 0,
+	.version = 1,
+	.maxattr = WWAN_ATTR_MAX,
+	.policy = wwan_policy,
+	.module = THIS_MODULE,
+	.ops = wwan_ops,
+	.n_ops = ARRAY_SIZE(wwan_ops),
+	.pre_doit = wwan_nl_pre_doit,
+	.post_doit = wwan_nl_post_doit,
+	.mcgrps = wwan_mcgrps,
+	.n_mcgrps = ARRAY_SIZE(wwan_mcgrps),
+	.parallel_ops = true,
+};
+
+int __init wwan_nl_init(void)
+{
+	return genl_register_family(&wwan_fam);
+}
+
+void wwan_nl_exit(void)
+{
+	genl_unregister_family(&wwan_fam);
+}
diff --git a/net/wwan/sysfs.c b/net/wwan/sysfs.c
new file mode 100644
index 000000000000..ff96eb8021a5
--- /dev/null
+++ b/net/wwan/sysfs.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2019 - 2020 Intel Corporation
+ */
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <net/wwan.h>
+#include "core.h"
+
+#define SHOW_FMT(name, fmt, member)					\
+static ssize_t name ## _show(struct device *dev,			\
+			      struct device_attribute *attr,		\
+			      char *buf)				\
+{									\
+	return sprintf(buf, fmt "\n", dev_to_wwan(dev)->member);	\
+}									\
+static DEVICE_ATTR_RO(name)
+
+SHOW_FMT(id, "%u", id);
+
+static struct attribute *wwan_attrs[] = {
+	&dev_attr_id.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(wwan);
+
+static int wwan_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	/* TODO, we probably need stuff here? */
+	return 0;
+}
+
+struct class wwan_class = {
+	.name = "wwan",
+	.owner = THIS_MODULE,
+	.dev_release = wwan_dev_release,
+	.dev_groups = wwan_groups,
+	.dev_uevent = wwan_uevent,
+};
+
+int __init wwan_sysfs_init(void)
+{
+	return class_register(&wwan_class);
+}
+
+void wwan_sysfs_exit(void)
+{
+	class_unregister(&wwan_class);
+}
-- 
2.24.1

