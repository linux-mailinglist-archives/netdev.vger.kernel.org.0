Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB3F67A7C7
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbjAYAeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbjAYAeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:34:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8244CDD9;
        Tue, 24 Jan 2023 16:34:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B2B5B8171E;
        Wed, 25 Jan 2023 00:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7250DC433EF;
        Wed, 25 Jan 2023 00:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674606857;
        bh=GdbK9etGuEf1KIxNGxo5c7bNnwD+W19O8EolVsXRFzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncr1s6d8ovq7CXFIb2Dr0YB4QrJ3EUfX3fPpKZK0zdI7B8CS9zNSQlyzGbAwBiQRY
         05zrgA0CPGAOYX8ZVQu6O61g+3c62VFRmg1sekcrasRZhp7buLLHkiU9u43Tncy4Il
         8R7kMmJArPE496IZ7Oe76hBnBLny6I0TzDqzCoF/Z3QoVpRarOWGUHhIJzgmQc+FkM
         vPTfSu/njq+oaxHZFej7NhDGN11PBQqwCvJ/Tgwchw95AFlg4X8K2rdmH0CbiITOZ+
         tOB1LeOSqW1zDYqpH7pLpwxngR/KGLicijBJt7Z8y6lnESFn/I5FKGJw9zvg1m95mK
         MOVhJeedE0kSA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, martin.lau@linux.dev
Subject: [PATCH v2 bpf-next 1/8] netdev-genl: create a simple family for netdev stuff
Date:   Wed, 25 Jan 2023 01:33:21 +0100
Message-Id: <b420eea0f362daa127448a5647a801d1ae9cb6dd.1674606196.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674606193.git.lorenzo@kernel.org>
References: <cover.1674606193.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

Add a Netlink spec-compatible family for netdevs.
This is a very simple implementation without much
thought going into it.

It allows us to reap all the benefits of Netlink specs,
one can use the generic client to issue the commands:

  $ ./cli.py --spec netdev.yaml --dump dev_get
  [{'ifindex': 1, 'xdp-features': set()},
   {'ifindex': 2, 'xdp-features': {'basic', 'ndo-xmit', 'redirect'}},
   {'ifindex': 3, 'xdp-features': {'rx-sg'}}]

the generic python library does not have flags-by-name
support, yet, but we also don't have to carry strings
in the messages, as user space can get the names from
the spec.

Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Co-developed-by: Marek Majtyka <alardam@gmail.com>
Signed-off-by: Marek Majtyka <alardam@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/netdev.yaml | 100 +++++++++++++
 include/linux/netdevice.h               |   3 +
 include/net/xdp.h                       |   3 +
 include/uapi/linux/netdev.h             |  59 ++++++++
 net/core/Makefile                       |   3 +-
 net/core/dev.c                          |   1 +
 net/core/netdev-genl-gen.c              |  48 +++++++
 net/core/netdev-genl-gen.h              |  23 +++
 net/core/netdev-genl.c                  | 179 ++++++++++++++++++++++++
 tools/include/uapi/linux/netdev.h       |  59 ++++++++
 10 files changed, 477 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/netlink/specs/netdev.yaml
 create mode 100644 include/uapi/linux/netdev.h
 create mode 100644 net/core/netdev-genl-gen.c
 create mode 100644 net/core/netdev-genl-gen.h
 create mode 100644 net/core/netdev-genl.c
 create mode 100644 tools/include/uapi/linux/netdev.h

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
new file mode 100644
index 000000000000..b4dcdae54ffd
--- /dev/null
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -0,0 +1,100 @@
+name: netdev
+
+doc:
+  netdev configuration over generic netlink.
+
+definitions:
+  -
+    type: flags
+    name: xdp-act
+    entries:
+      -
+        name: basic
+        doc:
+          XDP feautues set supported by all drivers
+          (XDP_ABORTED, XDP_DROP, XDP_PASS, XDP_TX)
+      -
+        name: redirect
+        doc:
+          The netdev supports XDP_REDIRECT
+      -
+        name: ndo-xmit
+        doc:
+          This feature informs if netdev implements ndo_xdp_xmit callback.
+      -
+        name: xsk-zerocopy
+        doc:
+          This feature informs if netdev supports AF_XDP in zero copy mode.
+      -
+        name: hw-offload
+        doc:
+         This feature informs if netdev supports XDP hw oflloading.
+      -
+        name: rx-sg
+        doc:
+          This feature informs if netdev implements non-linear XDP buffer
+          support in the driver napi callback.
+      -
+        name: ndo-xmit-sg
+        doc:
+          This feature informs if netdev implements non-linear XDP buffer
+          support in ndo_xdp_xmit callback.
+
+attribute-sets:
+  -
+    name: dev
+    attributes:
+      -
+        name: ifindex
+        doc: netdev ifindex
+        type: u32
+        value: 1
+        checks:
+          min: 1
+      -
+        name: pad
+        type: pad
+      -
+        name: xdp-features
+        doc: Bitmask of enabled xdp-features.
+        type: u64
+        enum: xdp-act
+        enum-as-flags: true
+
+operations:
+  list:
+    -
+      name: dev-get
+      doc: Get / dump information about a netdev.
+      value: 1
+      attribute-set: dev
+      do:
+        request:
+          attributes:
+            - ifindex
+        reply: &dev-all
+          attributes:
+            - ifindex
+            - xdp-features
+      dump:
+        reply: *dev-all
+    -
+      name: dev-add-ntf
+      doc: Notification about device appearing.
+      notify: dev-get
+      mcgrp: mgmt
+    -
+      name: dev-del-ntf
+      doc: Notification about device disappearing.
+      notify: dev-get
+      mcgrp: mgmt
+    -
+      name: dev-change-ntf
+      doc: Notification about device configuration being changed.
+      notify: dev-get
+      mcgrp: mgmt
+
+mcast-groups:
+  list:
+    -
+      name: mgmt
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 90f2be194bc5..2cbe9a6ede76 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -47,6 +47,7 @@
 #include <uapi/linux/netdevice.h>
 #include <uapi/linux/if_bonding.h>
 #include <uapi/linux/pkt_cls.h>
+#include <uapi/linux/netdev.h>
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
 #include <net/net_trackers.h>
@@ -2055,6 +2056,7 @@ struct net_device {
 
 	/* Read-mostly cache-line for fast-path access */
 	unsigned int		flags;
+	xdp_features_t		xdp_features;
 	unsigned long long	priv_flags;
 	const struct net_device_ops *netdev_ops;
 	const struct xdp_metadata_ops *xdp_metadata_ops;
@@ -2839,6 +2841,7 @@ enum netdev_cmd {
 	NETDEV_OFFLOAD_XSTATS_DISABLE,
 	NETDEV_OFFLOAD_XSTATS_REPORT_USED,
 	NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
+	NETDEV_XDP_FEAT_CHANGE,
 };
 const char *netdev_cmd_to_name(enum netdev_cmd cmd);
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 91292aa13bc0..8d1c86914f4c 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -7,6 +7,7 @@
 #define __LINUX_NET_XDP_H__
 
 #include <linux/skbuff.h> /* skb_shared_info */
+#include <uapi/linux/netdev.h>
 
 /**
  * DOC: XDP RX-queue information
@@ -43,6 +44,8 @@ enum xdp_mem_type {
 	MEM_TYPE_MAX,
 };
 
+typedef u32 xdp_features_t;
+
 /* XDP flags for ndo_xdp_xmit */
 #define XDP_XMIT_FLUSH		(1U << 0)	/* doorbell signal consumer */
 #define XDP_XMIT_FLAGS_MASK	XDP_XMIT_FLUSH
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
new file mode 100644
index 000000000000..9ee459872600
--- /dev/null
+++ b/include/uapi/linux/netdev.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/netdev.yaml */
+/* YNL-GEN uapi header */
+
+#ifndef _UAPI_LINUX_NETDEV_H
+#define _UAPI_LINUX_NETDEV_H
+
+#define NETDEV_FAMILY_NAME	"netdev"
+#define NETDEV_FAMILY_VERSION	1
+
+/**
+ * enum netdev_xdp_act
+ * @NETDEV_XDP_ACT_BASIC: XDP feautues set supported by all drivers
+ *   (XDP_ABORTED, XDP_DROP, XDP_PASS, XDP_TX)
+ * @NETDEV_XDP_ACT_REDIRECT: The netdev supports XDP_REDIRECT
+ * @NETDEV_XDP_ACT_NDO_XMIT: This feature informs if netdev implements
+ *   ndo_xdp_xmit callback.
+ * @NETDEV_XDP_ACT_XSK_ZEROCOPY: This feature informs if netdev supports AF_XDP
+ *   in zero copy mode.
+ * @NETDEV_XDP_ACT_HW_OFFLOAD: This feature informs if netdev supports XDP hw
+ *   oflloading.
+ * @NETDEV_XDP_ACT_RX_SG: This feature informs if netdev implements non-linear
+ *   XDP buffer support in the driver napi callback.
+ * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
+ *   non-linear XDP buffer support in ndo_xdp_xmit callback.
+ */
+enum netdev_xdp_act {
+	NETDEV_XDP_ACT_BASIC = 1,
+	NETDEV_XDP_ACT_REDIRECT = 2,
+	NETDEV_XDP_ACT_NDO_XMIT = 4,
+	NETDEV_XDP_ACT_XSK_ZEROCOPY = 8,
+	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
+	NETDEV_XDP_ACT_RX_SG = 32,
+	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
+};
+
+enum {
+	NETDEV_A_DEV_IFINDEX = 1,
+	NETDEV_A_DEV_PAD,
+	NETDEV_A_DEV_XDP_FEATURES,
+
+	__NETDEV_A_DEV_MAX,
+	NETDEV_A_DEV_MAX = (__NETDEV_A_DEV_MAX - 1)
+};
+
+enum {
+	NETDEV_CMD_DEV_GET = 1,
+	NETDEV_CMD_DEV_ADD_NTF,
+	NETDEV_CMD_DEV_DEL_NTF,
+	NETDEV_CMD_DEV_CHANGE_NTF,
+
+	__NETDEV_CMD_MAX,
+	NETDEV_CMD_MAX = (__NETDEV_CMD_MAX - 1)
+};
+
+#define NETDEV_MCGRP_MGMT	"mgmt"
+
+#endif /* _UAPI_LINUX_NETDEV_H */
diff --git a/net/core/Makefile b/net/core/Makefile
index 10edd66a8a37..8f367813bc68 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -12,7 +12,8 @@ obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
 			neighbour.o rtnetlink.o utils.o link_watch.o filter.o \
 			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
-			fib_notifier.o xdp.o flow_offload.o gro.o
+			fib_notifier.o xdp.o flow_offload.o gro.o \
+			netdev-genl.o netdev-genl-gen.o
 
 obj-$(CONFIG_NETDEV_ADDR_LIST_TEST) += dev_addr_lists_test.o
 
diff --git a/net/core/dev.c b/net/core/dev.c
index e66da626df84..2df1c940aa14 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1614,6 +1614,7 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
 	N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
 	N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
 	N(OFFLOAD_XSTATS_REPORT_USED) N(OFFLOAD_XSTATS_REPORT_DELTA)
+	N(XDP_FEAT_CHANGE)
 	}
 #undef N
 	return "UNKNOWN_NETDEV_EVENT";
diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
new file mode 100644
index 000000000000..48812ec843f5
--- /dev/null
+++ b/net/core/netdev-genl-gen.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/netdev.yaml */
+/* YNL-GEN kernel source */
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include "netdev-genl-gen.h"
+
+#include <linux/netdev.h>
+
+/* NETDEV_CMD_DEV_GET - do */
+static const struct nla_policy netdev_dev_get_nl_policy[NETDEV_A_DEV_IFINDEX + 1] = {
+	[NETDEV_A_DEV_IFINDEX] = NLA_POLICY_MIN(NLA_U32, 1),
+};
+
+/* Ops table for netdev */
+static const struct genl_split_ops netdev_nl_ops[2] = {
+	{
+		.cmd		= NETDEV_CMD_DEV_GET,
+		.doit		= netdev_nl_dev_get_doit,
+		.policy		= netdev_dev_get_nl_policy,
+		.maxattr	= NETDEV_A_DEV_IFINDEX,
+		.flags		= GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd	= NETDEV_CMD_DEV_GET,
+		.dumpit	= netdev_nl_dev_get_dumpit,
+		.flags	= GENL_CMD_CAP_DUMP,
+	},
+};
+
+static const struct genl_multicast_group netdev_nl_mcgrps[] = {
+	[NETDEV_NLGRP_MGMT] = { "mgmt", },
+};
+
+struct genl_family netdev_nl_family __ro_after_init = {
+	.name		= NETDEV_FAMILY_NAME,
+	.version	= NETDEV_FAMILY_VERSION,
+	.netnsok	= true,
+	.parallel_ops	= true,
+	.module		= THIS_MODULE,
+	.split_ops	= netdev_nl_ops,
+	.n_split_ops	= ARRAY_SIZE(netdev_nl_ops),
+	.mcgrps		= netdev_nl_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(netdev_nl_mcgrps),
+};
diff --git a/net/core/netdev-genl-gen.h b/net/core/netdev-genl-gen.h
new file mode 100644
index 000000000000..b16dc7e026bb
--- /dev/null
+++ b/net/core/netdev-genl-gen.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/netdev.yaml */
+/* YNL-GEN kernel header */
+
+#ifndef _LINUX_NETDEV_GEN_H
+#define _LINUX_NETDEV_GEN_H
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include <linux/netdev.h>
+
+int netdev_nl_dev_get_doit(struct sk_buff *skb, struct genl_info *info);
+int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+
+enum {
+	NETDEV_NLGRP_MGMT,
+};
+
+extern struct genl_family netdev_nl_family;
+
+#endif /* _LINUX_NETDEV_GEN_H */
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
new file mode 100644
index 000000000000..a4270fafdf11
--- /dev/null
+++ b/net/core/netdev-genl.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/netdevice.h>
+#include <linux/notifier.h>
+#include <linux/rtnetlink.h>
+#include <net/net_namespace.h>
+#include <net/sock.h>
+
+#include "netdev-genl-gen.h"
+
+static int
+netdev_nl_dev_fill(struct net_device *netdev, struct sk_buff *rsp,
+		   u32 portid, u32 seq, int flags, u32 cmd)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(rsp, portid, seq, &netdev_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(rsp, NETDEV_A_DEV_IFINDEX, netdev->ifindex) ||
+	    nla_put_u64_64bit(rsp, NETDEV_A_DEV_XDP_FEATURES,
+			      netdev->xdp_features, NETDEV_A_DEV_PAD)) {
+		genlmsg_cancel(rsp, hdr);
+		return -EINVAL;
+	}
+
+	genlmsg_end(rsp, hdr);
+
+	return 0;
+}
+
+static void
+netdev_genl_dev_notify(struct net_device *netdev, int cmd)
+{
+	struct sk_buff *ntf;
+
+	if (!genl_has_listeners(&netdev_nl_family, dev_net(netdev),
+				NETDEV_NLGRP_MGMT))
+		return;
+
+	ntf = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!ntf)
+		return;
+
+	if (netdev_nl_dev_fill(netdev, ntf, 0, 0, 0, cmd)) {
+		nlmsg_free(ntf);
+		return;
+	}
+
+	genlmsg_multicast_netns(&netdev_nl_family, dev_net(netdev), ntf,
+				0, NETDEV_NLGRP_MGMT, GFP_KERNEL);
+}
+
+int netdev_nl_dev_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net_device *netdev;
+	struct sk_buff *rsp;
+	u32 ifindex;
+	int err;
+
+	if (GENL_REQ_ATTR_CHECK(info, NETDEV_A_DEV_IFINDEX))
+		return -EINVAL;
+
+	ifindex = nla_get_u32(info->attrs[NETDEV_A_DEV_IFINDEX]);
+
+	rsp = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!rsp)
+		return -ENOMEM;
+
+	rtnl_lock();
+
+	netdev = __dev_get_by_index(genl_info_net(info), ifindex);
+	if (netdev)
+		err = netdev_nl_dev_fill(netdev, rsp, info->snd_portid,
+					 info->snd_seq, 0, info->genlhdr->cmd);
+	else
+		err = -ENODEV;
+
+	rtnl_unlock();
+
+	if (err)
+		goto err_free_msg;
+
+	return genlmsg_reply(rsp, info);
+
+err_free_msg:
+	nlmsg_free(rsp);
+	return err;
+}
+
+int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct net *net = sock_net(skb->sk);
+	struct net_device *netdev;
+	int idx = 0, s_idx;
+	int h, s_h;
+	int err;
+
+	s_h = cb->args[0];
+	s_idx = cb->args[1];
+
+	rtnl_lock();
+
+	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
+		struct hlist_head *head;
+
+		idx = 0;
+		head = &net->dev_index_head[h];
+		hlist_for_each_entry(netdev, head, index_hlist) {
+			if (idx < s_idx)
+				goto cont;
+			err = netdev_nl_dev_fill(netdev, skb,
+						 NETLINK_CB(cb->skb).portid,
+						 cb->nlh->nlmsg_seq, 0,
+						 NETDEV_CMD_DEV_GET);
+			if (err < 0)
+				break;
+cont:
+			idx++;
+		}
+	}
+
+	rtnl_unlock();
+
+	if (err != -EMSGSIZE)
+		return err;
+
+	cb->args[1] = idx;
+	cb->args[0] = h;
+	cb->seq = net->dev_base_seq;
+
+	return skb->len;
+}
+
+static int netdev_genl_netdevice_event(struct notifier_block *nb,
+				       unsigned long event, void *ptr)
+{
+	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+
+	switch (event) {
+	case NETDEV_REGISTER:
+		netdev_genl_dev_notify(netdev, NETDEV_CMD_DEV_ADD_NTF);
+		break;
+	case NETDEV_UNREGISTER:
+		netdev_genl_dev_notify(netdev, NETDEV_CMD_DEV_DEL_NTF);
+		break;
+	case NETDEV_XDP_FEAT_CHANGE:
+		netdev_genl_dev_notify(netdev, NETDEV_CMD_DEV_CHANGE_NTF);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block netdev_genl_nb = {
+	.notifier_call	= netdev_genl_netdevice_event,
+};
+
+static int __init netdev_genl_init(void)
+{
+	int err;
+
+	err = register_netdevice_notifier(&netdev_genl_nb);
+	if (err)
+		return err;
+
+	err = genl_register_family(&netdev_nl_family);
+	if (err)
+		goto err_unreg_ntf;
+
+	return 0;
+
+err_unreg_ntf:
+	unregister_netdevice_notifier(&netdev_genl_nb);
+	return err;
+}
+
+subsys_initcall(netdev_genl_init);
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
new file mode 100644
index 000000000000..9ee459872600
--- /dev/null
+++ b/tools/include/uapi/linux/netdev.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/netdev.yaml */
+/* YNL-GEN uapi header */
+
+#ifndef _UAPI_LINUX_NETDEV_H
+#define _UAPI_LINUX_NETDEV_H
+
+#define NETDEV_FAMILY_NAME	"netdev"
+#define NETDEV_FAMILY_VERSION	1
+
+/**
+ * enum netdev_xdp_act
+ * @NETDEV_XDP_ACT_BASIC: XDP feautues set supported by all drivers
+ *   (XDP_ABORTED, XDP_DROP, XDP_PASS, XDP_TX)
+ * @NETDEV_XDP_ACT_REDIRECT: The netdev supports XDP_REDIRECT
+ * @NETDEV_XDP_ACT_NDO_XMIT: This feature informs if netdev implements
+ *   ndo_xdp_xmit callback.
+ * @NETDEV_XDP_ACT_XSK_ZEROCOPY: This feature informs if netdev supports AF_XDP
+ *   in zero copy mode.
+ * @NETDEV_XDP_ACT_HW_OFFLOAD: This feature informs if netdev supports XDP hw
+ *   oflloading.
+ * @NETDEV_XDP_ACT_RX_SG: This feature informs if netdev implements non-linear
+ *   XDP buffer support in the driver napi callback.
+ * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
+ *   non-linear XDP buffer support in ndo_xdp_xmit callback.
+ */
+enum netdev_xdp_act {
+	NETDEV_XDP_ACT_BASIC = 1,
+	NETDEV_XDP_ACT_REDIRECT = 2,
+	NETDEV_XDP_ACT_NDO_XMIT = 4,
+	NETDEV_XDP_ACT_XSK_ZEROCOPY = 8,
+	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
+	NETDEV_XDP_ACT_RX_SG = 32,
+	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
+};
+
+enum {
+	NETDEV_A_DEV_IFINDEX = 1,
+	NETDEV_A_DEV_PAD,
+	NETDEV_A_DEV_XDP_FEATURES,
+
+	__NETDEV_A_DEV_MAX,
+	NETDEV_A_DEV_MAX = (__NETDEV_A_DEV_MAX - 1)
+};
+
+enum {
+	NETDEV_CMD_DEV_GET = 1,
+	NETDEV_CMD_DEV_ADD_NTF,
+	NETDEV_CMD_DEV_DEL_NTF,
+	NETDEV_CMD_DEV_CHANGE_NTF,
+
+	__NETDEV_CMD_MAX,
+	NETDEV_CMD_MAX = (__NETDEV_CMD_MAX - 1)
+};
+
+#define NETDEV_MCGRP_MGMT	"mgmt"
+
+#endif /* _UAPI_LINUX_NETDEV_H */
-- 
2.39.1

