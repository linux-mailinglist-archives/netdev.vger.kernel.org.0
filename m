Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD27B27F013
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbgI3RQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:16:36 -0400
Received: from inva021.nxp.com ([92.121.34.21]:56954 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728232AbgI3RQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 13:16:32 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 33C5E2007C4;
        Wed, 30 Sep 2020 19:16:30 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 26B0A2007C1;
        Wed, 30 Sep 2020 19:16:30 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CE5F420307;
        Wed, 30 Sep 2020 19:16:29 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     jiri@nvidia.com, idosch@nvidia.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/4] dpaa2-eth: add basic devlink support
Date:   Wed, 30 Sep 2020 20:16:10 +0300
Message-Id: <20200930171611.27121-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930171611.27121-1-ioana.ciornei@nxp.com>
References: <20200930171611.27121-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic support in dpaa2-eth for devlink. For the moment, just
register the device with devlink, add the corresponding devlink port and
implement the .info_get() callback.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/Makefile |  2 +-
 .../freescale/dpaa2/dpaa2-eth-devlink.c       | 90 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 15 ++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 12 +++
 4 files changed, 118 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c

diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
index 6e7f33c956bf..146cb3540e61 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Makefile
+++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
@@ -6,7 +6,7 @@
 obj-$(CONFIG_FSL_DPAA2_ETH)		+= fsl-dpaa2-eth.o
 obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+= fsl-dpaa2-ptp.o
 
-fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o
+fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o dpaa2-eth-devlink.o
 fsl-dpaa2-eth-${CONFIG_FSL_DPAA2_ETH_DCB} += dpaa2-eth-dcb.o
 fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
 fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
new file mode 100644
index 000000000000..3691981f5165
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+#include "dpaa2-eth.h"
+/* Copyright 2020 NXP
+ */
+
+static int dpaa2_eth_dl_info_get(struct devlink *devlink,
+				 struct devlink_info_req *req,
+				 struct netlink_ext_ack *extack)
+{
+	struct dpaa2_eth_devlink_priv *dl_priv = devlink_priv(devlink);
+	struct dpaa2_eth_priv *priv = dl_priv->dpaa2_priv;
+	char buf[10];
+	int err;
+
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (err)
+		return err;
+
+	scnprintf(buf, 10, "%d.%d", priv->dpni_ver_major, priv->dpni_ver_minor);
+	err = devlink_info_version_running_put(req, "dpni", buf);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static const struct devlink_ops dpaa2_eth_devlink_ops = {
+	.info_get = dpaa2_eth_dl_info_get,
+};
+
+int dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv)
+{
+	struct net_device *net_dev = priv->net_dev;
+	struct device *dev = net_dev->dev.parent;
+	struct dpaa2_eth_devlink_priv *dl_priv;
+	int err;
+
+	priv->devlink = devlink_alloc(&dpaa2_eth_devlink_ops, sizeof(*dl_priv));
+	if (!priv->devlink) {
+		dev_err(dev, "devlink_alloc failed\n");
+		return -ENOMEM;
+	}
+	dl_priv = devlink_priv(priv->devlink);
+	dl_priv->dpaa2_priv = priv;
+
+	err = devlink_register(priv->devlink, dev);
+	if (err) {
+		dev_err(dev, "devlink_register() = %d\n", err);
+		goto devlink_free;
+	}
+
+	return 0;
+
+devlink_free:
+	devlink_free(priv->devlink);
+
+	return err;
+}
+
+void dpaa2_eth_dl_unregister(struct dpaa2_eth_priv *priv)
+{
+	devlink_unregister(priv->devlink);
+	devlink_free(priv->devlink);
+}
+
+int dpaa2_eth_dl_port_add(struct dpaa2_eth_priv *priv)
+{
+	struct devlink_port *devlink_port = &priv->devlink_port;
+	struct devlink_port_attrs attrs = {};
+	int err;
+
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	devlink_port_attrs_set(devlink_port, &attrs);
+
+	err = devlink_port_register(priv->devlink, devlink_port, 0);
+	if (err)
+		return err;
+
+	devlink_port_type_eth_set(devlink_port, priv->net_dev);
+
+	return 0;
+}
+
+void dpaa2_eth_dl_port_del(struct dpaa2_eth_priv *priv)
+{
+	struct devlink_port *devlink_port = &priv->devlink_port;
+
+	devlink_port_type_clear(devlink_port);
+	devlink_port_unregister(devlink_port);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index fe4caf7aad7c..29c1c9263422 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4223,6 +4223,14 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	if (err)
 		goto err_connect_mac;
 
+	err = dpaa2_eth_dl_register(priv);
+	if (err)
+		goto err_dl_register;
+
+	err = dpaa2_eth_dl_port_add(priv);
+	if (err)
+		goto err_dl_port_add;
+
 	err = register_netdev(net_dev);
 	if (err < 0) {
 		dev_err(dev, "register_netdev() failed\n");
@@ -4237,6 +4245,10 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	return 0;
 
 err_netdev_reg:
+	dpaa2_eth_dl_port_del(priv);
+err_dl_port_add:
+	dpaa2_eth_dl_unregister(priv);
+err_dl_register:
 	dpaa2_eth_disconnect_mac(priv);
 err_connect_mac:
 	if (priv->do_link_poll)
@@ -4291,6 +4303,9 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 
 	unregister_netdev(net_dev);
 
+	dpaa2_eth_dl_port_del(priv);
+	dpaa2_eth_dl_unregister(priv);
+
 	if (priv->do_link_poll)
 		kthread_stop(priv->poll_thread);
 	else
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 6436fa3b25cb..6578c59160c3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -11,6 +11,7 @@
 #include <linux/if_vlan.h>
 #include <linux/fsl/mc.h>
 #include <linux/net_tstamp.h>
+#include <net/devlink.h>
 
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
@@ -503,6 +504,11 @@ struct dpaa2_eth_priv {
 	 * queue before transmit current packet.
 	 */
 	struct mutex		onestep_tstamp_lock;
+	struct devlink *devlink;
+};
+
+struct dpaa2_eth_devlink_priv {
+	struct dpaa2_eth_priv *dpaa2_priv;
 };
 
 #define TX_TSTAMP		0x1
@@ -636,4 +642,10 @@ void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
 
 extern const struct dcbnl_rtnl_ops dpaa2_eth_dcbnl_ops;
 
+int dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv);
+void dpaa2_eth_dl_unregister(struct dpaa2_eth_priv *priv);
+
+int dpaa2_eth_dl_port_add(struct dpaa2_eth_priv *priv);
+void dpaa2_eth_dl_port_del(struct dpaa2_eth_priv *priv);
+
 #endif	/* __DPAA2_H */
-- 
2.28.0

