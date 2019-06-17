Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0CE481F7
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 14:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfFQMZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 08:25:49 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41960 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfFQMZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 08:25:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hcqhZ-0004wP-Pj; Mon, 17 Jun 2019 14:25:33 +0200
Message-ID: <e6ba8a9063e63506c0b88a70418d74ca4efe85cd.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>, Dan Williams <dcbw@redhat.com>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Date:   Mon, 17 Jun 2019 14:25:32 +0200
In-Reply-To: <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
         <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
         <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
         <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
         <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
         <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
         <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
         <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
         <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
         (sfid-20190612_170637_190349_3B0027EE) <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-17 at 13:42 +0200, Johannes Berg wrote:

> But anyway, as I alluded to above, I had something like this in mind:

I forgot to state this here, but this was *heavily* influenced by
discussions with Dan - many thanks to him.

> driver_dev
>   struct device *dev (USB, PCI, ...)
>   net_device NA
>   net_device NB
>   tty TA
>  ...
> 
> (I'm cutting out the rmnet layer here for now)
> 
> while having a separate that just links all the pieces together:
> 
> wwan_device W
>   ---> dev
>   ---> NA
>   ---> NB
>   ---> TA
> 
> So the driver is still responsible for creating the netdevs (or can of
> course delegate that to an "rmnet" library), but then all it also does
> is register the netdevs with the WWAN core like
> 
> 	wwan_add_netdev(dev, NA)
[snip]

So to put some more meat to this, here's an API definition for both
userspace and internal APIs:


diff --git a/include/net/wwan.h b/include/net/wwan.h
new file mode 100644
index 000000000000..91413ec01def
--- /dev/null
+++ b/include/net/wwan.h
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * WWAN stack interfaces
+ *
+ * Copyright (C) 2019 Intel Corporation
+ *
+ * This defines the interaction of WWAN drivers with the WWAN stack,
+ * which allows userspace configuration of sessions etc.
+ */
+#ifndef __NET_WWAN_H
+#define __NET_WWAN_H
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/device.h>
+
+struct wwan_device {
+	u32 id;
+	void *data;
+/* private: */
+	struct list_head list;
+	struct device *dev;
+	struct wwan_device_ops *ops;
+};
+
+/**
+ * struct wwan_netdev_config - WWAN netdevice configuration
+ * @pdn: PDN identifier this netdev uses
+ */
+struct wwan_netdev_config {
+	u32 pdn;
+};
+
+/**
+ * wwan_device_ops - WWAN device operations
+ */
+struct wwan_device_ops {
+	/**
+	 * @add_netdev: Add a new netdev with the given configuration, must
+	 *	return the new netdev pointer but not call wwan_attach_netdev().
+	 */
+	struct net_device *(*add_netdev)(struct wwan_device *wwan,
+					 struct wwan_netdev_config *config);
+	/**
+	 * @remove_netdev: remove the given netdev
+	 */
+	int (*remove_netdev)(struct wwan_device *wwan, struct net_device *dev);
+
+	/*
+	 * More TBD:
+	 *  - add/remove serial port channels?
+	 *    ideally with some common (library) code to support this
+	 *    Or maybe not - serial is pretty limiting. Perhaps instead:
+	 *  - support something like AF_WWAN sockets for control data
+	 */
+};
+
+/**
+ * wwan_add - add a WWAN device without preconfigured channels
+ * @dev: underlying struct device
+ * @ops: methods to create new channels
+ * @data: data for the new WWAN device
+ *
+ * Returns: a struct wwan_device pointer, or an ERR_PTR().
+ */
+struct wwan_device *
+wwan_add(struct device *dev, struct wwan_device_ops *ops, void *data);
+
+/**
+ * wwan_remove - remove the given WWAN device
+ * @wwan: WWAN device to remove.
+ *
+ * Note that the WWAN device may not be fully removed if it still has
+ * any channels attached, but nonetheless callers must assume that the
+ * pointer is no longer valid after calling this function.
+ */
+void wwan_remove(struct wwan_device *wwan);
+
+/**
+ * wwan_attach_netdev - attach a preconfigured netdev to the WWAN device
+ * @dev: struct device underlying the WWAN device
+ * @netdev: netdev to attach
+ * @config: configuration for this netdev
+ * @tentative: mark the attachment as tentative, don't consider this as
+ *	part of a WWAN device unless other channels are attached as well.
+ *	Set this to %false in drivers that know they're a WWAN device
+ *	and to %true in generic drivers that may or may not be a WWAN
+ *	device and want to wait for other channels.
+ *
+ * Returns: a struct wwan_device pointer or ERR_PTR(). Note that a valid
+ * pointer is returned even for the tentative case.
+ *
+ * Note that there's no need to detach again, this happens automatically
+ * when the netdev is removed.
+ */
+struct wwan_device *
+wwan_attach_netdev(struct device *dev, struct net_device *netdev,
+		   struct wwan_netdev_config *config, bool tentative);
+
+/* TBD */
+struct wwan_device *
+wwan_attach_tty(struct device *dev, struct tty_port *port, bool tentative);
+void wwan_detach_tty(struct device *dev, struct tty_port *port);
+
+#endif /* __NET_WWAN_H */
diff --git a/include/uapi/linux/wwan.h b/include/uapi/linux/wwan.h
new file mode 100644
index 000000000000..af327aab881c
--- /dev/null
+++ b/include/uapi/linux/wwan.h
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
+/*
+ * WWAN generic netlink interfaces
+ *
+ * Copyright (C) 2019 Intel Corporation
+ *
+ * This defines the WWAN generic netlink family APIs for userspace
+ * to control WWAN devices.
+ */
+#ifndef __UAPI_LINUX_WWAN_H
+#define __UAPI_LINUX_WWAN_H
+#include <linux/types.h>
+
+#define WWAN_NAME "wwan"
+
+enum wwan_commands {
+	WWAN_CMD_UNSPEC,
+
+	WWAN_CMD_GET_DEVICE, /* get or dump */
+	WWAN_CMD_SET_DEVICE, /* set name or similar */
+	WWAN_CMD_NEW_DEVICE, /* notification */
+	WWAN_CMD_DEL_DEVICE, /* notification */
+
+	WWAN_CMD_GET_NETDEV, /* probably not needed - show all data in GET_DEVICE dump? */
+	WWAN_CMD_SET_NETDEV, /* probably not supported? */
+	WWAN_CMD_NEW_NETDEV,
+	WWAN_CMD_DEL_NETDEV,
+};
+
+/* TODO DOCS */
+enum wwan_chan_type {
+	WWAN_CHAN_TYPE_UNDEFINED,
+	WWAN_CHAN_TYPE_NETDEV,
+	WWAN_CHAN_TYPE_TTY,
+	/* ... */
+};
+
+enum wwan_chan_attrs {
+	/**
+	 * @WWAN_CHAN_ATTR_UNSPEC: unused/reserved
+	 */
+	WWAN_CHAN_ATTR_UNSPEC,
+
+	/**
+	 * @WWAN_CHAN_ATTR_TYPE: channel type according to &enum wwan_chan_type
+	 */
+	WWAN_CHAN_ATTR_TYPE,
+
+	/**
+	 * @WWAN_CHAN_ATTR_IFIDX: interface index (for netdev channels)
+	 */
+	WWAN_CHAN_ATTR_IFIDX,
+
+	/* need something for TTY - major/minor number? /dev/ name? */
+
+	/* ... */
+};
+
+enum wwan_attrs {
+	/**
+	 * @WWAN_ATTR_UNSPEC: unused/reserved
+	 */
+	WWAN_ATTR_UNSPEC,
+
+	/**
+	 * @WWAN_ATTR_DEVICE_ID: device ID
+	 */
+	WWAN_ATTR_DEVICE_ID,
+
+	/**
+	 * @WWAN_ATTR_DEVICE_NAME: name of the underlying struct device
+	 */
+	WWAN_ATTR_DEVICE_NAME,
+
+	/**
+	 * @WWAN_ATTR_IFIDX: interface index for %WWAN_CMD_NEW_NETDEV
+	 */
+	WWAN_ATTR_IFIDX,
+
+	/**
+	 * @WWAN_ATTR_PDN: PDN for %WWAN_CMD_NEW_NETDEV
+	 */
+	WWAN_ATTR_PDN,
+
+	/**
+	 * @WWAN_ATTR_CHANNELS: nested array of channels in dump, using
+	 *	the &enum wwan_chan_attrs.
+	 */
+	WWAN_ATTR_CHANNELS,
+
+	/* ... */
+};
+
+#endif /* __UAPI_LINUX_WWAN_H */

