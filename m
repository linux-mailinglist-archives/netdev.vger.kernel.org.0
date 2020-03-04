Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3071C1799B8
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388281AbgCDUZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:25:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:33424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388230AbgCDUZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:25:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8F291B2A2;
        Wed,  4 Mar 2020 20:25:26 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3E923E037F; Wed,  4 Mar 2020 21:25:26 +0100 (CET)
Message-Id: <8c607619bcf65c21a7dc4da11a84625568342438.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 10/25] netlink: add support for string sets
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:25:26 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add infrastructure for querying kernel for string sets (analog to ioctl
commands ETHTOOL_GSSET_INFO and ETHTOOL_GSTRINGS), caching the results and
making them available to netlink code.

There are two types of string sets: global (not related to a device) and
per device (each device has its set of string sets). Per device string sets
are stored in a linked list (one entry for each device) for now.

String sets can be either preloaded completely on start using
preload_global_strings() and preload_perdev_strings() or requested by one
when there is a need for them. In the latter case (preferred, in particular
for one shot operation mode), second netlink socket is used to request the
string set contents.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am       |   2 +-
 netlink/netlink.c |  53 +++++++++
 netlink/netlink.h |   9 ++
 netlink/strset.c  | 295 ++++++++++++++++++++++++++++++++++++++++++++++
 netlink/strset.h  |  25 ++++
 5 files changed, 383 insertions(+), 1 deletion(-)
 create mode 100644 netlink/strset.c
 create mode 100644 netlink/strset.h

diff --git a/Makefile.am b/Makefile.am
index 04f4157e7bc0..aa41b21fa779 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -28,7 +28,7 @@ if ETHTOOL_ENABLE_NETLINK
 ethtool_SOURCES += \
 		  netlink/netlink.c netlink/netlink.h netlink/extapi.h \
 		  netlink/msgbuff.c netlink/msgbuff.h netlink/nlsock.c \
-		  netlink/nlsock.h \
+		  netlink/nlsock.h netlink/strset.c netlink/strset.h \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/netlink/netlink.c b/netlink/netlink.c
index 7cd7bef6eac9..60f7912181df 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -11,6 +11,7 @@
 #include "extapi.h"
 #include "msgbuff.h"
 #include "nlsock.h"
+#include "strset.h"
 
 /* Used as reply callback for requests where no reply is expected (e.g. most
  * "set" type commands)
@@ -40,6 +41,57 @@ int attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+/* misc helpers */
+
+const char *get_dev_name(const struct nlattr *nest)
+{
+	const struct nlattr *tb[ETHTOOL_A_HEADER_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	int ret;
+
+	if (!nest)
+		return NULL;
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	if (ret < 0 || !tb[ETHTOOL_A_HEADER_DEV_NAME])
+		return "(none)";
+	return mnl_attr_get_str(tb[ETHTOOL_A_HEADER_DEV_NAME]);
+}
+
+int get_dev_info(const struct nlattr *nest, int *ifindex, char *ifname)
+{
+	const struct nlattr *tb[ETHTOOL_A_HEADER_MAX + 1] = {};
+	const struct nlattr *index_attr;
+	const struct nlattr *name_attr;
+	DECLARE_ATTR_TB_INFO(tb);
+	int ret;
+
+	if (ifindex)
+		*ifindex = 0;
+	if (ifname)
+		memset(ifname, '\0', ALTIFNAMSIZ);
+
+	if (!nest)
+		return -EFAULT;
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	index_attr = tb[ETHTOOL_A_HEADER_DEV_INDEX];
+	name_attr = tb[ETHTOOL_A_HEADER_DEV_NAME];
+	if (ret < 0 || (ifindex && !index_attr) || (ifname && !name_attr))
+		return -EFAULT;
+
+	if (ifindex)
+		*ifindex = mnl_attr_get_u32(index_attr);
+	if (ifname) {
+		strncpy(ifname, mnl_attr_get_str(name_attr), ALTIFNAMSIZ);
+		if (ifname[ALTIFNAMSIZ - 1]) {
+			ifname[ALTIFNAMSIZ - 1] = '\0';
+			fprintf(stderr, "kernel device name too long: '%s'\n",
+				mnl_attr_get_str(name_attr));
+			return -EFAULT;
+		}
+	}
+	return 0;
+}
+
 /* initialization */
 
 struct fam_info {
@@ -153,4 +205,5 @@ void netlink_done(struct cmd_context *ctx)
 
 	free(ctx->nlctx);
 	ctx->nlctx = NULL;
+	cleanup_all_strings();
 }
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 9ba03b05163f..04ad7bcd347c 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -39,6 +39,15 @@ struct attr_tb_info {
 int nomsg_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int attr_cb(const struct nlattr *attr, void *data);
 
+const char *get_dev_name(const struct nlattr *nest);
+int get_dev_info(const struct nlattr *nest, int *ifindex, char *ifname);
+
+static inline void copy_devname(char *dst, const char *src)
+{
+	strncpy(dst, src, ALTIFNAMSIZ);
+	dst[ALTIFNAMSIZ - 1] = '\0';
+}
+
 static inline int netlink_init_ethnl2_socket(struct nl_context *nlctx)
 {
 	if (nlctx->ethnl2_socket)
diff --git a/netlink/strset.c b/netlink/strset.c
new file mode 100644
index 000000000000..bc468ae5a88e
--- /dev/null
+++ b/netlink/strset.c
@@ -0,0 +1,295 @@
+/*
+ * strset.c - string set handling
+ *
+ * Implementation of local cache of ethtool string sets.
+ */
+
+#include <errno.h>
+#include <string.h>
+
+#include "../internal.h"
+#include "netlink.h"
+#include "nlsock.h"
+#include "msgbuff.h"
+
+struct stringset {
+	const char		**strings;
+	void			*raw_data;
+	unsigned int		count;
+	bool			loaded;
+};
+
+struct perdev_strings {
+	int			ifindex;
+	char			devname[ALTIFNAMSIZ];
+	struct stringset	strings[ETH_SS_COUNT];
+	struct perdev_strings	*next;
+};
+
+/* universal string sets */
+static struct stringset global_strings[ETH_SS_COUNT];
+/* linked list of string sets related to network devices */
+static struct perdev_strings *device_strings;
+
+static void drop_stringset(struct stringset *set)
+{
+	if (!set)
+		return;
+
+	free(set->strings);
+	free(set->raw_data);
+	memset(set, 0, sizeof(*set));
+}
+
+static int import_stringset(struct stringset *dest, const struct nlattr *nest)
+{
+	const struct nlattr *tb_stringset[ETHTOOL_A_STRINGSET_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb_stringset);
+	const struct nlattr *string;
+	unsigned int size;
+	unsigned int count;
+	unsigned int idx;
+	int ret;
+
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_stringset_info);
+	if (ret < 0)
+		return ret;
+	if (!tb_stringset[ETHTOOL_A_STRINGSET_ID] ||
+	    !tb_stringset[ETHTOOL_A_STRINGSET_COUNT] ||
+	    !tb_stringset[ETHTOOL_A_STRINGSET_STRINGS])
+		return -EFAULT;
+	idx = mnl_attr_get_u32(tb_stringset[ETHTOOL_A_STRINGSET_ID]);
+	if (idx >= ETH_SS_COUNT)
+		return 0;
+	if (dest[idx].loaded)
+		drop_stringset(&dest[idx]);
+	dest[idx].loaded = true;
+	count = mnl_attr_get_u32(tb_stringset[ETHTOOL_A_STRINGSET_COUNT]);
+	if (count == 0)
+		return 0;
+
+	size = mnl_attr_get_len(tb_stringset[ETHTOOL_A_STRINGSET_STRINGS]);
+	ret = -ENOMEM;
+	dest[idx].raw_data = malloc(size);
+	if (!dest[idx].raw_data)
+		goto err;
+	memcpy(dest[idx].raw_data, tb_stringset[ETHTOOL_A_STRINGSET_STRINGS],
+	       size);
+	dest[idx].strings = calloc(count, sizeof(dest[idx].strings[0]));
+	if (!dest[idx].strings)
+		goto err;
+	dest[idx].count = count;
+
+	nest = dest[idx].raw_data;
+	mnl_attr_for_each_nested(string, nest) {
+		const struct nlattr *tb[ETHTOOL_A_STRING_MAX + 1] = {};
+		DECLARE_ATTR_TB_INFO(tb);
+		unsigned int i;
+
+		if (mnl_attr_get_type(string) != ETHTOOL_A_STRINGS_STRING)
+			continue;
+		ret = mnl_attr_parse_nested(string, attr_cb, &tb_info);
+		if (ret < 0)
+			goto err;
+		ret = -EFAULT;
+		if (!tb[ETHTOOL_A_STRING_INDEX] || !tb[ETHTOOL_A_STRING_VALUE])
+			goto err;
+
+		i = mnl_attr_get_u32(tb[ETHTOOL_A_STRING_INDEX]);
+		if (i >= count)
+			goto err;
+		dest[idx].strings[i] =
+			mnl_attr_get_payload(tb[ETHTOOL_A_STRING_VALUE]);
+	}
+
+	return 0;
+err:
+	drop_stringset(&dest[idx]);
+	return ret;
+}
+
+static struct perdev_strings *get_perdev_by_ifindex(int ifindex)
+{
+	struct perdev_strings *perdev = device_strings;
+
+	while (perdev && perdev->ifindex != ifindex)
+		perdev = perdev->next;
+	if (perdev)
+		return perdev;
+
+	/* not found, allocate and insert into list */
+	perdev = calloc(sizeof(*perdev), 1);
+	if (!perdev)
+		return NULL;
+	perdev->ifindex = ifindex;
+	perdev->next = device_strings;
+	device_strings = perdev;
+
+	return perdev;
+}
+
+static int strset_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_STRSET_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	char devname[ALTIFNAMSIZ] = "";
+	struct stringset *dest;
+	struct nlattr *attr;
+	int ifindex = 0;
+	int ret;
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+	if (tb[ETHTOOL_A_STRSET_HEADER]) {
+		ret = get_dev_info(tb[ETHTOOL_A_STRSET_HEADER], &ifindex,
+				   devname);
+		if (ret < 0)
+			return MNL_CB_OK;
+		nlctx->devname = devname;
+	}
+
+	if (ifindex) {
+		struct perdev_strings *perdev;
+
+		perdev = get_perdev_by_ifindex(ifindex);
+		if (!perdev)
+			return MNL_CB_OK;
+		copy_devname(perdev->devname, devname);
+		dest = perdev->strings;
+	} else {
+		dest = global_strings;
+	}
+
+	if (!tb[ETHTOOL_A_STRSET_STRINGSETS])
+		return MNL_CB_OK;
+	mnl_attr_for_each_nested(attr, tb[ETHTOOL_A_STRSET_STRINGSETS]) {
+		if (mnl_attr_get_type(attr) ==
+		    ETHTOOL_A_STRINGSETS_STRINGSET)
+			import_stringset(dest, attr);
+	}
+
+	return MNL_CB_OK;
+}
+
+static int fill_stringset_id(struct nl_msg_buff *msgbuff, unsigned int type)
+{
+	struct nlattr *nest_sets;
+	struct nlattr *nest_set;
+
+	nest_sets = ethnla_nest_start(msgbuff, ETHTOOL_A_STRSET_STRINGSETS);
+	if (!nest_sets)
+		return -EMSGSIZE;
+	nest_set = ethnla_nest_start(msgbuff, ETHTOOL_A_STRINGSETS_STRINGSET);
+	if (!nest_set)
+		goto err;
+	if (ethnla_put_u32(msgbuff, ETHTOOL_A_STRINGSET_ID, type))
+		goto err;
+	ethnla_nest_end(msgbuff, nest_set);
+	ethnla_nest_end(msgbuff, nest_sets);
+	return 0;
+
+err:
+	ethnla_nest_cancel(msgbuff, nest_sets);
+	return -EMSGSIZE;
+}
+
+static int stringset_load_request(struct nl_socket *nlsk, const char *devname,
+				  int type, bool is_dump)
+{
+	struct nl_msg_buff *msgbuff = &nlsk->msgbuff;
+	int ret;
+
+	ret = msg_init(nlsk->nlctx, msgbuff, ETHTOOL_MSG_STRSET_GET,
+		       NLM_F_REQUEST | NLM_F_ACK | (is_dump ? NLM_F_DUMP : 0));
+	if (ret < 0)
+		return ret;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_STRSET_HEADER, devname, 0))
+		return -EMSGSIZE;
+	if (type >= 0) {
+		ret = fill_stringset_id(msgbuff, type);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = nlsock_send_get_request(nlsk, strset_reply_cb);
+	return ret;
+}
+
+/* interface */
+
+const struct stringset *global_stringset(unsigned int type,
+					 struct nl_socket *nlsk)
+{
+	int ret;
+
+	if (type >= ETH_SS_COUNT)
+		return NULL;
+	if (global_strings[type].loaded)
+		return &global_strings[type];
+	ret = stringset_load_request(nlsk, NULL, type, false);
+	return ret < 0 ? NULL : &global_strings[type];
+}
+
+const struct stringset *perdev_stringset(const char *devname, unsigned int type,
+					 struct nl_socket *nlsk)
+{
+	const struct perdev_strings *p;
+	int ret;
+
+	if (type >= ETH_SS_COUNT)
+		return NULL;
+	for (p = device_strings; p; p = p->next)
+		if (!strcmp(p->devname, devname))
+			return &p->strings[type];
+
+	ret = stringset_load_request(nlsk, devname, type, false);
+	if (ret < 0)
+		return NULL;
+	for (p = device_strings; p; p = p->next)
+		if (!strcmp(p->devname, devname))
+			return &p->strings[type];
+
+	return NULL;
+}
+
+unsigned int get_count(const struct stringset *set)
+{
+	return set->count;
+}
+
+const char *get_string(const struct stringset *set, unsigned int idx)
+{
+	if (!set || idx >= set->count)
+		return NULL;
+	return set->strings[idx];
+}
+
+int preload_global_strings(struct nl_socket *nlsk)
+{
+	return stringset_load_request(nlsk, NULL, -1, false);
+}
+
+int preload_perdev_strings(struct nl_socket *nlsk, const char *dev)
+{
+	return stringset_load_request(nlsk, dev, -1, !dev);
+}
+
+void cleanup_all_strings(void)
+{
+	struct perdev_strings *perdev;
+	unsigned int i;
+
+	for (i = 0; i < ETH_SS_COUNT; i++)
+		drop_stringset(&global_strings[i]);
+
+	perdev = device_strings;
+	while (perdev) {
+		device_strings = perdev->next;
+		for (i = 0; i < ETH_SS_COUNT; i++)
+			drop_stringset(&perdev->strings[i]);
+		free(perdev);
+		perdev = device_strings;
+	}
+}
diff --git a/netlink/strset.h b/netlink/strset.h
new file mode 100644
index 000000000000..72a4a3929244
--- /dev/null
+++ b/netlink/strset.h
@@ -0,0 +1,25 @@
+/*
+ * strset.h - string set handling
+ *
+ * Interface for local cache of ethtool string sets.
+ */
+
+#ifndef ETHTOOL_NETLINK_STRSET_H__
+#define ETHTOOL_NETLINK_STRSET_H__
+
+struct nl_socket;
+struct stringset;
+
+const struct stringset *global_stringset(unsigned int type,
+					 struct nl_socket *nlsk);
+const struct stringset *perdev_stringset(const char *dev, unsigned int type,
+					 struct nl_socket *nlsk);
+
+unsigned int get_count(const struct stringset *set);
+const char *get_string(const struct stringset *set, unsigned int idx);
+
+int preload_global_strings(struct nl_socket *nlsk);
+int preload_perdev_strings(struct nl_socket *nlsk, const char *dev);
+void cleanup_all_strings(void);
+
+#endif /* ETHTOOL_NETLINK_STRSET_H__ */
-- 
2.25.1

