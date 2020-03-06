Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88E017C396
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgCFRFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:05:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:43850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgCFRFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:05:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8F858B152;
        Fri,  6 Mar 2020 17:05:40 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3A5BEE00E7; Fri,  6 Mar 2020 18:05:40 +0100 (CET)
Message-Id: <f3ed37731543cb105493f3ef56d7d4299e173e3b.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 20/25] netlink: add handler for permaddr (-P)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:05:40 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -P <dev>" subcommand. This retrieves and displays
information traditionally provided by ETHTOOL_GPERMADDR ioctl request.

Permanent hardware address is provided by rtnetlink RTM_GETLINK request
so that basic support for rtnetlink (which is not based on genetlink)
requests is also added.

The IFLA_PERM_ADDRESS attribute in RTM_NEWLINK message is not set if the
device driver did not set its permanent hardware address which is hard to
distinguish from ethtool running on top of an older kernel not supporting
the attribute. As IFLA_PERM_ADDRESS attribute was added to kernel shortly
before the initial portion of ethtool netlink interface, we let ethtool
initialize ethtool netlink even if it is not needed so that we can fall
back to ioctl on older kernels and assume that absence of IFLA_PERM_ADDRESS
means the permanent address is not set. This would be only wrong on some
distribution kernel which would backport ethtool netlink interface but not
IFLA_PERM_ADDRESS which is unlikely.

Permanent address is immutable (or not mutable using standard interfaces)
so that there is no related notification message.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am        |   1 +
 ethtool.c          |   1 +
 netlink/extapi.h   |   2 +
 netlink/netlink.h  |   8 ++++
 netlink/permaddr.c | 114 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 126 insertions(+)
 create mode 100644 netlink/permaddr.c

diff --git a/Makefile.am b/Makefile.am
index 30cda5b1fc6f..11acdab1a65e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -30,6 +30,7 @@ ethtool_SOURCES += \
 		  netlink/nlsock.h netlink/strset.c netlink/strset.h \
 		  netlink/monitor.c netlink/bitset.c netlink/bitset.h \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
+		  netlink/permaddr.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/ethtool.c b/ethtool.c
index baa6458bb486..1b4e08b6e60f 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5372,6 +5372,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-P|--show-permaddr",
 		.func	= do_permaddr,
+		.nlfunc	= nl_permaddr,
 		.help	= "Show permanent hardware address"
 	},
 	{
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 612002e8228b..d5b3cd92d4ab 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -17,6 +17,7 @@ void netlink_done(struct cmd_context *ctx);
 
 int nl_gset(struct cmd_context *ctx);
 int nl_sset(struct cmd_context *ctx);
+int nl_permaddr(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -38,6 +39,7 @@ static inline void nl_monitor_usage(void)
 
 #define nl_gset			NULL
 #define nl_sset			NULL
+#define nl_permaddr		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 3ab5f2329e2f..db078d28fabb 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -27,6 +27,7 @@ struct nl_context {
 	uint32_t		ethnl_mongrp;
 	struct nl_socket	*ethnl_socket;
 	struct nl_socket	*ethnl2_socket;
+	struct nl_socket	*rtnl_socket;
 	bool			is_monitor;
 	uint32_t		filter_cmds[CMDMASK_WORDS];
 	const char		*filter_devname;
@@ -76,4 +77,11 @@ static inline int netlink_init_ethnl2_socket(struct nl_context *nlctx)
 	return nlsock_init(nlctx, &nlctx->ethnl2_socket, NETLINK_GENERIC);
 }
 
+static inline int netlink_init_rtnl_socket(struct nl_context *nlctx)
+{
+	if (nlctx->rtnl_socket)
+		return 0;
+	return nlsock_init(nlctx, &nlctx->rtnl_socket, NETLINK_ROUTE);
+}
+
 #endif /* ETHTOOL_NETLINK_INT_H__ */
diff --git a/netlink/permaddr.c b/netlink/permaddr.c
new file mode 100644
index 000000000000..006eac6c0094
--- /dev/null
+++ b/netlink/permaddr.c
@@ -0,0 +1,114 @@
+/*
+ * permaddr.c - netlink implementation of permanent address request
+ *
+ * Implementation of "ethtool -P <dev>"
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+#include <linux/rtnetlink.h>
+#include <linux/if_link.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+
+/* PERMADDR_GET */
+
+static int permaddr_prep_request(struct nl_socket *nlsk)
+{
+	unsigned int nlm_flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nl_context *nlctx = nlsk->nlctx;
+	const char *devname = nlctx->ctx->devname;
+	struct nl_msg_buff *msgbuff = &nlsk->msgbuff;
+	struct ifinfomsg *ifinfo;
+	struct nlmsghdr *nlhdr;
+	int ret;
+
+	if (devname && !strcmp(devname, WILDCARD_DEVNAME)) {
+		devname = NULL;
+		nlm_flags |= NLM_F_DUMP;
+	}
+	nlctx->is_dump = !devname;
+
+        ret = msgbuff_realloc(msgbuff, MNL_SOCKET_BUFFER_SIZE);
+        if (ret < 0)
+                return ret;
+        memset(msgbuff->buff, '\0', NLMSG_HDRLEN + sizeof(*ifinfo));
+
+	nlhdr = mnl_nlmsg_put_header(msgbuff->buff);
+	nlhdr->nlmsg_type = RTM_GETLINK;
+	nlhdr->nlmsg_flags = nlm_flags;
+	msgbuff->nlhdr = nlhdr;
+	ifinfo = mnl_nlmsg_put_extra_header(nlhdr, sizeof(*ifinfo));
+
+	if (devname) {
+		uint16_t type = IFLA_IFNAME;
+
+		if (strlen(devname) >= IFNAMSIZ)
+			type = IFLA_ALT_IFNAME;
+		if (ethnla_put_strz(msgbuff, type, devname))
+			return -EMSGSIZE;
+	}
+	if (ethnla_put_u32(msgbuff, IFLA_EXT_MASK, RTEXT_FILTER_SKIP_STATS))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+int permaddr_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[__IFLA_MAX] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	const uint8_t *permaddr;
+	unsigned int i;
+	int ret;
+
+	if (nlhdr->nlmsg_type != RTM_NEWLINK)
+		goto err;
+	ret = mnl_attr_parse(nlhdr, sizeof(struct ifinfomsg), attr_cb,
+			     &tb_info);
+	if (ret < 0 || !tb[IFLA_IFNAME])
+		goto err;
+	nlctx->devname = mnl_attr_get_str(tb[IFLA_IFNAME]);
+	if (!dev_ok(nlctx))
+		goto err;
+
+	if (!tb[IFLA_PERM_ADDRESS]) {
+		if (!nlctx->is_dump)
+			printf("Permanent address: not set\n");
+		return MNL_CB_OK;
+	}
+
+	if (nlctx->is_dump)
+		printf("Permanent address of %s:", nlctx->devname);
+	else
+		printf("Permanent address:");
+	permaddr = mnl_attr_get_payload(tb[IFLA_PERM_ADDRESS]);
+	for (i = 0; i < mnl_attr_get_payload_len(tb[IFLA_PERM_ADDRESS]); i++)
+		printf("%c%02x", i ? ':' : ' ', permaddr[i]);
+	putchar('\n');
+	return MNL_CB_OK;
+
+err:
+	if (nlctx->is_dump || nlctx->is_monitor)
+		return MNL_CB_OK;
+	nlctx->exit_code = 2;
+	return MNL_CB_ERROR;
+}
+
+int nl_permaddr(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	int ret;
+
+	ret = netlink_init_rtnl_socket(nlctx);
+	if (ret < 0)
+		return ret;
+	ret = permaddr_prep_request(nlctx->rtnl_socket);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlctx->rtnl_socket, permaddr_reply_cb);
+}
-- 
2.25.1

