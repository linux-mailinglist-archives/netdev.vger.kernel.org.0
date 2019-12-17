Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908C0122DEB
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbfLQOEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 09:04:40 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:60862 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbfLQOEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 09:04:39 -0500
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2019 09:04:37 EST
Received: from obook.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id B6BD44053B;
        Tue, 17 Dec 2019 14:56:22 +0100 (CET)
From:   Martin Willi <martin@strongswan.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH nf-next] netfilter: xt_slavedev: Add new L3master slave input device match
Date:   Tue, 17 Dec 2019 14:56:15 +0100
Message-Id: <20191217135616.25751-2-martin@strongswan.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191217135616.25751-1-martin@strongswan.org>
References: <20191217135616.25751-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When filtering in INPUT or FORWARD within a VRF domain, input interface
matching is done against the VRF device name instead of the real input
interface. This makes interface based filtering difficult if the interface
is associated to a VRF or some other layer 3 master device. While
PREROUTING can match against the real input interface, using it for
filtering is often inconvenient.

To allow filtering in INPUT/FORWARD against the real input interface,
add a match extension for this specific purpose. It is very similar
to the layer 2 slave device match implemented in xt_physdev to match
against bridge ports, but matches on layer 3 slave devices.

As an option, the user may specify a "strict" flag, limiting matches to
interfaces that strictly are layer 3 slave devices.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 include/net/ip.h                           |  2 +-
 include/uapi/linux/netfilter/xt_slavedev.h | 18 +++++
 net/netfilter/Kconfig                      | 12 ++++
 net/netfilter/Makefile                     |  1 +
 net/netfilter/xt_slavedev.c                | 80 ++++++++++++++++++++++
 5 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/netfilter/xt_slavedev.h
 create mode 100644 net/netfilter/xt_slavedev.c

diff --git a/include/net/ip.h b/include/net/ip.h
index 5b317c9f4470..12cd3971f4cf 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -98,7 +98,7 @@ static inline void ipcm_init_sk(struct ipcm_cookie *ipcm,
 #define PKTINFO_SKB_CB(skb) ((struct in_pktinfo *)((skb)->cb))
 
 /* return enslaved device index if relevant */
-static inline int inet_sdif(struct sk_buff *skb)
+static inline int inet_sdif(const struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
 	if (skb && ipv4_l3mdev_skb(IPCB(skb)->flags))
diff --git a/include/uapi/linux/netfilter/xt_slavedev.h b/include/uapi/linux/netfilter/xt_slavedev.h
new file mode 100644
index 000000000000..d35785b04c4b
--- /dev/null
+++ b/include/uapi/linux/netfilter/xt_slavedev.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_XT_SLAVEDEV_H
+#define _UAPI_XT_SLAVEDEV_H
+
+#include <linux/types.h>
+#include <linux/if.h>
+
+#define XT_SLAVEDEV_IN_INV	0x01	/* invert interface match */
+#define XT_SLAVEDEV_IN_STRICT	0x02	/* require iif to be enslaved */
+#define XT_SLAVEDEV_MASK	(0x04 - 1)
+
+struct xt_slavedev_info {
+	char iniface[IFNAMSIZ];
+	unsigned char iniface_mask[IFNAMSIZ];
+	__u8 flags;
+};
+
+#endif /* _UAPI_XT_SLAVEDEV_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 91efae88e8c2..a259192bdb2e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1530,6 +1530,18 @@ config NETFILTER_XT_MATCH_SCTP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.rst>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_SLAVEDEV
+	tristate '"slavedev" match support'
+	depends on NET_L3_MASTER_DEV
+	depends on NETFILTER_ADVANCED
+	help
+	  Slavedev packet matching matches against the input slave interface
+	  if the IP packet arrived on a layer 3 master device. It allows
+	  matching against the input interface if that interface is
+	  associated to a VRF master device.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_SOCKET
 	tristate '"socket" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5e9b2eb24349..9650d1d5216c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -197,6 +197,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_RECENT) += xt_recent.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_SLAVEDEV) += xt_slavedev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) += xt_socket.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
diff --git a/net/netfilter/xt_slavedev.c b/net/netfilter/xt_slavedev.c
new file mode 100644
index 000000000000..a53466dfb10b
--- /dev/null
+++ b/net/netfilter/xt_slavedev.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <net/ip.h>
+#include <net/ipv6.h>
+#include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
+#include <uapi/linux/netfilter/xt_slavedev.h>
+
+static bool
+slavedev_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_slavedev_info *info = par->matchinfo;
+	struct net_device *sd;
+	unsigned long ret = 1;
+	int sdif = 0;
+
+	switch (xt_family(par)) {
+	case NFPROTO_IPV4:
+		sdif = inet_sdif(skb);
+		break;
+	case NFPROTO_IPV6:
+		sdif = inet6_sdif(skb);
+		break;
+	}
+	if (sdif) {
+		sd = dev_get_by_index_rcu(xt_net(par), sdif);
+		if (sd)
+			ret = ifname_compare_aligned(sd->name, info->iniface,
+						     info->iniface_mask);
+	} else if (!(info->flags & XT_SLAVEDEV_IN_STRICT) && xt_in(par)) {
+		ret = ifname_compare_aligned(xt_inname(par), info->iniface,
+					     info->iniface_mask);
+	}
+
+	if (!ret ^ !(info->flags & XT_SLAVEDEV_IN_INV))
+		return false;
+
+	return true;
+}
+
+static int slavedev_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_slavedev_info *info = par->matchinfo;
+
+	if (info->flags & ~XT_SLAVEDEV_MASK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct xt_match slavedev_mt_reg __read_mostly = {
+	.name		= "slavedev",
+	.revision	= 0,
+	.family		= NFPROTO_UNSPEC,
+	.checkentry	= slavedev_mt_check,
+	.match		= slavedev_mt,
+	.matchsize	= sizeof(struct xt_slavedev_info),
+	.hooks		= (1 << NF_INET_LOCAL_IN) |
+			  (1 << NF_INET_FORWARD),
+	.me		= THIS_MODULE,
+};
+
+static int __init slavedev_mt_init(void)
+{
+	return xt_register_match(&slavedev_mt_reg);
+}
+
+static void __exit slavedev_mt_exit(void)
+{
+	xt_unregister_match(&slavedev_mt_reg);
+}
+
+module_init(slavedev_mt_init);
+module_exit(slavedev_mt_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
+MODULE_DESCRIPTION("Xtables: L3master input slave device match");
+MODULE_ALIAS("ipt_slavedev");
+MODULE_ALIAS("ip6t_slavedev");
-- 
2.20.1

