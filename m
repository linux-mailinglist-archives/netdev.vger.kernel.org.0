Return-Path: <netdev+bounces-8799-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2421E725D5B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 821771C20D58
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7769930B7C;
	Wed,  7 Jun 2023 11:39:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681926AB7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:39:17 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A0D1730
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686137954; x=1717673954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wuK/iYHc6tNoahXN6ShzbJrN9ZOwxTc5dX66vYw1Fbg=;
  b=L90/1ECdZ5lvZn3l/0PGnNNcF2xMK0UOGFplTSEGp+vadaRFu/DiBrna
   jsHLhidWZyn6eA7A6kTH5J8PQK7c0jbLdyl/MO78x6iAEEmTrdl17SH2i
   qaVSoFLFRewhAcPgz+aXK7LapEwYcbqaZwC6mUOogOR7z2GDRmtB2LSUo
   CLdk6HGr9Mz4zkzIYJkni3TkTd+t7oHo13r0BXNj7jH8mJdmDN32xJuDO
   2POzisaf0oV7yTtth9ENXn5r4iEJ61jGRfbGhu3/lNI01ru9Z/JVt9w2t
   vvBABOLUvuF0AMp227R23fNObQRWSWaumym+0Gedo44ifc8NpidwG0LZ1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="359432155"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="359432155"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 04:39:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="686935677"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="686935677"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga006.jf.intel.com with ESMTP; 07 Jun 2023 04:39:06 -0700
Received: from giewont.igk.intel.com (giewont.igk.intel.com [10.211.8.15])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id C843B35806;
	Wed,  7 Jun 2023 12:39:04 +0100 (IST)
From: Marcin Szycik <marcin.szycik@linux.intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	wojciech.drewek@intel.com,
	michal.swiatkowski@linux.intel.com,
	aleksander.lobakin@intel.com,
	davem@davemloft.net,
	kuba@kernel.org,
	jiri@resnulli.us,
	pabeni@redhat.com,
	jesse.brandeburg@intel.com,
	simon.horman@corigine.com,
	idosch@nvidia.com,
	Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [PATCH iwl-next v2 3/6] pfcp: add PFCP module
Date: Wed,  7 Jun 2023 13:26:03 +0200
Message-Id: <20230607112606.15899-4-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230607112606.15899-1-marcin.szycik@linux.intel.com>
References: <20230607112606.15899-1-marcin.szycik@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wojciech Drewek <wojciech.drewek@intel.com>

Packet Forwarding Control Protocol (PFCP) is a 3GPP Protocol
used between the control plane and the user plane function.
It is specified in TS 29.244[1].

Note that this module is not designed to support this Protocol
in the kernel space. There is no support for parsing any PFCP messages.
There is no API that could be used by any userspace daemon.
Basically it does not support PFCP. This protocol is sophisticated
and there is no need for implementing it in the kernel. The purpose
of this module is to allow users to setup software and hardware offload
of PFCP packets using tc tool.

When user requests to create a PFCP device, a new socket is created.
The socket is set up with port number 8805 which is specific for
PFCP [29.244 4.2.2]. This allow to receive PFCP request messages,
response messages use other ports.

Note that only one PFCP netdev can be created.

Only IPv4 is supported at this time.

[1] https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=3111

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v2: Fixed typos
---
 drivers/net/Kconfig  |  13 +++
 drivers/net/Makefile |   1 +
 drivers/net/pfcp.c   | 223 +++++++++++++++++++++++++++++++++++++++++++
 include/net/pfcp.h   |  13 +++
 4 files changed, 250 insertions(+)
 create mode 100644 drivers/net/pfcp.c
 create mode 100644 include/net/pfcp.h

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 368c6f5b327e..8f94b8b2b2e4 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -290,6 +290,19 @@ config GTP
 	  To compile this drivers as a module, choose M here: the module
 	  will be called gtp.
 
+config PFCP
+	tristate "Packet Forwarding Control Protocol (PFCP)"
+	depends on INET
+	select NET_UDP_TUNNEL
+	help
+	  This allows one to create PFCP virtual interfaces that allows to
+	  set up software and hardware offload of PFCP packets.
+	  Note that this module does not support PFCP protocol in the kernel space.
+	  There is no support for parsing any PFCP messages.
+
+	  To compile this drivers as a module, choose M here: the module
+	  will be called pfcp.
+
 config AMT
 	tristate "Automatic Multicast Tunneling (AMT)"
 	depends on INET && IP_MULTICAST
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index e26f98f897c5..2cded0a3ed4b 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_GENEVE) += geneve.o
 obj-$(CONFIG_BAREUDP) += bareudp.o
 obj-$(CONFIG_GTP) += gtp.o
 obj-$(CONFIG_NLMON) += nlmon.o
+obj-$(CONFIG_PFCP) += pfcp.o
 obj-$(CONFIG_NET_VRF) += vrf.o
 obj-$(CONFIG_VSOCKMON) += vsockmon.o
 obj-$(CONFIG_MHI_NET) += mhi_net.o
diff --git a/drivers/net/pfcp.c b/drivers/net/pfcp.c
new file mode 100644
index 000000000000..3ab2e93e0b45
--- /dev/null
+++ b/drivers/net/pfcp.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* PFCP according to 3GPP TS 29.244
+ *
+ * Copyright (C) 2022, Intel Corporation.
+ * (C) 2022 by Wojciech Drewek <wojciech.drewek@intel.com>
+ *
+ * Author: Wojciech Drewek <wojciech.drewek@intel.com>
+ */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/rculist.h>
+#include <linux/skbuff.h>
+
+#include <net/udp.h>
+#include <net/udp_tunnel.h>
+#include <net/pfcp.h>
+
+struct pfcp_dev {
+	struct list_head	list;
+
+	struct socket		*sock;
+	struct net_device	*dev;
+	struct net		*net;
+};
+
+static unsigned int pfcp_net_id __read_mostly;
+
+struct pfcp_net {
+	struct list_head	pfcp_dev_list;
+};
+
+static void pfcp_del_sock(struct pfcp_dev *pfcp)
+{
+	udp_tunnel_sock_release(pfcp->sock);
+	pfcp->sock = NULL;
+}
+
+static void pfcp_dev_uninit(struct net_device *dev)
+{
+	struct pfcp_dev *pfcp = netdev_priv(dev);
+
+	pfcp_del_sock(pfcp);
+}
+
+static int pfcp_dev_init(struct net_device *dev)
+{
+	struct pfcp_dev *pfcp = netdev_priv(dev);
+
+	pfcp->dev = dev;
+
+	return 0;
+}
+
+static const struct net_device_ops pfcp_netdev_ops = {
+	.ndo_init		= pfcp_dev_init,
+	.ndo_uninit		= pfcp_dev_uninit,
+	.ndo_get_stats64	= dev_get_tstats64,
+};
+
+static const struct device_type pfcp_type = {
+	.name = "pfcp",
+};
+
+static void pfcp_link_setup(struct net_device *dev)
+{
+	dev->netdev_ops	= &pfcp_netdev_ops;
+	dev->needs_free_netdev	= true;
+	SET_NETDEV_DEVTYPE(dev, &pfcp_type);
+
+	dev->hard_header_len = 0;
+	dev->addr_len = 0;
+
+	dev->type = ARPHRD_NONE;
+	dev->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
+	dev->priv_flags |= IFF_NO_QUEUE;
+
+	netif_keep_dst(dev);
+}
+
+static struct socket *pfcp_create_sock(struct pfcp_dev *pfcp)
+{
+	struct udp_tunnel_sock_cfg tuncfg = {};
+	struct udp_port_cfg udp_conf = {
+		.local_ip.s_addr	= htonl(INADDR_ANY),
+		.family			= AF_INET,
+	};
+	struct net *net = pfcp->net;
+	struct socket *sock;
+	int err;
+
+	udp_conf.local_udp_port = htons(PFCP_PORT);
+
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err)
+		return ERR_PTR(err);
+
+	setup_udp_tunnel_sock(net, sock, &tuncfg);
+
+	return sock;
+}
+
+static int pfcp_add_sock(struct pfcp_dev *pfcp)
+{
+	pfcp->sock = pfcp_create_sock(pfcp);
+
+	return PTR_ERR_OR_ZERO(pfcp->sock);
+}
+
+static int pfcp_newlink(struct net *net, struct net_device *dev,
+			struct nlattr *tb[], struct nlattr *data[],
+			struct netlink_ext_ack *extack)
+{
+	struct pfcp_dev *pfcp = netdev_priv(dev);
+	struct pfcp_net *pn;
+	int err;
+
+	pfcp->net = net;
+
+	err = pfcp_add_sock(pfcp);
+	if (err) {
+		netdev_dbg(dev, "failed to add pfcp socket %d\n", err);
+		goto exit;
+	}
+
+	err = register_netdevice(dev);
+	if (err) {
+		netdev_dbg(dev, "failed to register pfcp netdev %d\n", err);
+		goto exit_reg_netdev;
+	}
+
+	pn = net_generic(dev_net(dev), pfcp_net_id);
+	list_add_rcu(&pfcp->list, &pn->pfcp_dev_list);
+
+	netdev_dbg(dev, "registered new PFCP interface\n");
+
+	return 0;
+
+exit_reg_netdev:
+	pfcp_del_sock(pfcp);
+exit:
+	return err;
+}
+
+static void pfcp_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct pfcp_dev *pfcp = netdev_priv(dev);
+
+	list_del_rcu(&pfcp->list);
+	unregister_netdevice_queue(dev, head);
+}
+
+static struct rtnl_link_ops pfcp_link_ops __read_mostly = {
+	.kind		= "pfcp",
+	.priv_size	= sizeof(struct pfcp_dev),
+	.setup		= pfcp_link_setup,
+	.newlink	= pfcp_newlink,
+	.dellink	= pfcp_dellink,
+};
+
+static int __net_init pfcp_net_init(struct net *net)
+{
+	struct pfcp_net *pn = net_generic(net, pfcp_net_id);
+
+	INIT_LIST_HEAD(&pn->pfcp_dev_list);
+	return 0;
+}
+
+static void __net_exit pfcp_net_exit(struct net *net)
+{
+	struct pfcp_net *pn = net_generic(net, pfcp_net_id);
+	struct pfcp_dev *pfcp;
+	LIST_HEAD(list);
+
+	rtnl_lock();
+	list_for_each_entry(pfcp, &pn->pfcp_dev_list, list)
+		pfcp_dellink(pfcp->dev, &list);
+
+	unregister_netdevice_many(&list);
+	rtnl_unlock();
+}
+
+static struct pernet_operations pfcp_net_ops = {
+	.init	= pfcp_net_init,
+	.exit	= pfcp_net_exit,
+	.id	= &pfcp_net_id,
+	.size	= sizeof(struct pfcp_net),
+};
+
+static int __init pfcp_init(void)
+{
+	int err;
+
+	err = register_pernet_subsys(&pfcp_net_ops);
+	if (err)
+		goto exit;
+
+	err = rtnl_link_register(&pfcp_link_ops);
+	if (err)
+		goto exit_subsys;
+	return 0;
+
+exit_subsys:
+	unregister_pernet_subsys(&pfcp_net_ops);
+exit:
+	pr_err("loading PFCP module failed: err %d\n", err);
+	return err;
+}
+late_initcall(pfcp_init);
+
+static void __exit pfcp_exit(void)
+{
+	rtnl_link_unregister(&pfcp_link_ops);
+	unregister_pernet_subsys(&pfcp_net_ops);
+
+	pr_info("PFCP module unloaded\n");
+}
+module_exit(pfcp_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Wojciech Drewek <wojciech.drewek@intel.com>");
+MODULE_DESCRIPTION("Interface driver for PFCP encapsulated traffic");
+MODULE_ALIAS_RTNL_LINK("pfcp");
diff --git a/include/net/pfcp.h b/include/net/pfcp.h
new file mode 100644
index 000000000000..88f0815e40d2
--- /dev/null
+++ b/include/net/pfcp.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _PFCP_H_
+#define _PFCP_H_
+
+#define PFCP_PORT 8805
+
+static inline bool netif_is_pfcp(const struct net_device *dev)
+{
+	return dev->rtnl_link_ops &&
+	       !strcmp(dev->rtnl_link_ops->kind, "pfcp");
+}
+
+#endif
-- 
2.31.1


