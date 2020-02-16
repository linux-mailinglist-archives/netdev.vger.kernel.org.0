Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C521606FD
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 23:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgBPWrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 17:47:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:33792 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgBPWrI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 17:47:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 375ADAF55;
        Sun, 16 Feb 2020 22:47:06 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D76D5E03D6; Sun, 16 Feb 2020 23:47:05 +0100 (CET)
Message-Id: <243e6cdd79a02065acca55a79407baac7d17b316.1581892124.git.mkubecek@suse.cz>
In-Reply-To: <cover.1581892124.git.mkubecek@suse.cz>
References: <cover.1581892124.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 07/19] netlink: message buffer and composition helpers
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Sun, 16 Feb 2020 23:47:05 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add data structure for flexible message buffer and helpers for safe message
composition.

The nl_msg_buff structure is an abstraction for a message buffer used to
compose an outgoing netlink message. When the message exceeds currently
allocated length, buffer is reallocated. Only if the buffer size reaches
MAX_MSG_SIZE (4 MB), an error is issued.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am       |   1 +
 netlink/msgbuff.c | 169 ++++++++++++++++++++++++++++++++++++++++++++++
 netlink/msgbuff.h | 106 +++++++++++++++++++++++++++++
 netlink/netlink.h |   1 +
 4 files changed, 277 insertions(+)
 create mode 100644 netlink/msgbuff.c
 create mode 100644 netlink/msgbuff.h

diff --git a/Makefile.am b/Makefile.am
index 3748d0df5608..12412b433445 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -27,6 +27,7 @@ endif
 if ETHTOOL_ENABLE_NETLINK
 ethtool_SOURCES += \
 		  netlink/netlink.c netlink/netlink.h netlink/extapi.h \
+		  netlink/msgbuff.c netlink/msgbuff.h \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h
 ethtool_CFLAGS += @MNL_CFLAGS@
diff --git a/netlink/msgbuff.c b/netlink/msgbuff.c
new file mode 100644
index 000000000000..1e73354d194b
--- /dev/null
+++ b/netlink/msgbuff.c
@@ -0,0 +1,169 @@
+/*
+ * msgbuff.c - netlink message buffer
+ *
+ * Data structures and code for flexible message buffer abstraction.
+ */
+
+#include <string.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <stdint.h>
+
+#include "../internal.h"
+#include "netlink.h"
+#include "msgbuff.h"
+
+#define MAX_MSG_SIZE (4 << 20)		/* 4 MB */
+
+int msgbuff_realloc(struct nl_msg_buff *msgbuff, unsigned int new_size)
+{
+	unsigned int nlhdr_off, genlhdr_off, payload_off;
+	unsigned int old_size = msgbuff->size;
+	char *nbuff;
+
+	nlhdr_off = (char *)msgbuff->nlhdr - msgbuff->buff;
+	genlhdr_off = (char *)msgbuff->genlhdr - msgbuff->buff;
+	payload_off = (char *)msgbuff->payload - msgbuff->buff;
+
+	if (!new_size)
+		new_size = old_size + MNL_SOCKET_BUFFER_SIZE;
+	if (new_size <= old_size)
+		return 0;
+	if (new_size > MAX_MSG_SIZE)
+		return -EMSGSIZE;
+	nbuff = realloc(msgbuff->buff, new_size);
+	if (!nbuff) {
+		msgbuff->buff = NULL;
+		msgbuff->size = 0;
+		msgbuff->left = 0;
+		return -ENOMEM;
+	}
+	if (nbuff != msgbuff->buff) {
+		if (new_size > old_size)
+			memset(nbuff + old_size, '\0', new_size - old_size);
+		msgbuff->nlhdr = (struct nlmsghdr *)(nbuff + nlhdr_off);
+		msgbuff->genlhdr = (struct genlmsghdr *)(nbuff + genlhdr_off);
+		msgbuff->payload = nbuff + payload_off;
+		msgbuff->buff = nbuff;
+	}
+	msgbuff->size = new_size;
+	msgbuff->left += (new_size - old_size);
+
+	return 0;
+}
+
+int msgbuff_append(struct nl_msg_buff *dest, struct nl_msg_buff *src)
+{
+	unsigned int src_len = mnl_nlmsg_get_payload_len(src->nlhdr);
+	unsigned int dest_len = MNL_ALIGN(msgbuff_len(dest));
+	int ret;
+
+	ret = msgbuff_realloc(dest, dest_len + src_len);
+	if (ret < 0)
+		return ret;
+	memcpy(mnl_nlmsg_get_payload_tail(dest->nlhdr), src->payload, src_len);
+	msgbuff_reset(dest, dest_len + src_len);
+
+	return 0;
+}
+
+bool ethnla_put(struct nl_msg_buff *msgbuff, uint16_t type, size_t len,
+		const void *data)
+{
+	struct nlmsghdr *nlhdr = msgbuff->nlhdr;
+
+	while (!mnl_attr_put_check(nlhdr, msgbuff->left, type, len, data)) {
+		int ret = msgbuff_realloc(msgbuff, 0);
+
+		if (ret < 0)
+			return true;
+	}
+
+	return false;
+}
+
+struct nlattr *ethnla_nest_start(struct nl_msg_buff *msgbuff, uint16_t type)
+{
+	struct nlmsghdr *nlhdr = msgbuff->nlhdr;
+	struct nlattr *attr;
+
+	do {
+		attr = mnl_attr_nest_start_check(nlhdr, msgbuff->left, type);
+		if (attr)
+			return attr;
+	} while (msgbuff_realloc(msgbuff, 0) == 0);
+
+	return NULL;
+}
+
+bool ethnla_fill_header(struct nl_msg_buff *msgbuff, uint16_t type,
+			const char *devname, uint32_t flags)
+{
+	struct nlattr *nest;
+
+	nest = ethnla_nest_start(msgbuff, type);
+	if (!nest)
+		return true;
+
+	if ((devname &&
+	     ethnla_put_strz(msgbuff, ETHTOOL_A_HEADER_DEV_NAME, devname)) ||
+	    (flags &&
+	     ethnla_put_u32(msgbuff, ETHTOOL_A_HEADER_FLAGS, flags)))
+		goto err;
+
+	ethnla_nest_end(msgbuff, nest);
+	return false;
+
+err:
+	ethnla_nest_cancel(msgbuff, nest);
+	return true;
+}
+
+/* initialize a genetlink message and fill netlink and genetlink header */
+int __msg_init(struct nl_msg_buff *msgbuff, int family, int cmd,
+	       unsigned int flags, int version)
+{
+	struct nlmsghdr *nlhdr;
+	struct genlmsghdr *genlhdr;
+	int ret;
+
+	ret = msgbuff_realloc(msgbuff, MNL_SOCKET_BUFFER_SIZE);
+	if (ret < 0)
+		return ret;
+	memset(msgbuff->buff, '\0', NLMSG_HDRLEN + GENL_HDRLEN);
+
+	nlhdr = mnl_nlmsg_put_header(msgbuff->buff);
+	nlhdr->nlmsg_type = family;
+	nlhdr->nlmsg_flags = flags;
+	msgbuff->nlhdr = nlhdr;
+
+	genlhdr = mnl_nlmsg_put_extra_header(nlhdr, sizeof(*genlhdr));
+	genlhdr->cmd = cmd;
+	genlhdr->version = version;
+	msgbuff->genlhdr = genlhdr;
+
+	msgbuff->payload = mnl_nlmsg_get_payload_offset(nlhdr, GENL_HDRLEN);
+
+	return 0;
+}
+
+/* simplified wrapper to initialize an ethtool netlink message */
+int msg_init(struct nl_context *nlctx, struct nl_msg_buff *msgbuff, int cmd,
+	     unsigned int flags)
+{
+	return __msg_init(msgbuff, nlctx->ethnl_fam, cmd, flags,
+			  ETHTOOL_GENL_VERSION);
+}
+
+void msgbuff_init(struct nl_msg_buff *msgbuff)
+{
+	memset(msgbuff, '\0', sizeof(*msgbuff));
+}
+
+void msgbuff_done(struct nl_msg_buff *msgbuff)
+{
+	free(msgbuff->buff);
+	msgbuff->buff = NULL;
+	msgbuff->size = 0;
+	msgbuff->left = 0;
+}
diff --git a/netlink/msgbuff.h b/netlink/msgbuff.h
new file mode 100644
index 000000000000..6f3baa9992fd
--- /dev/null
+++ b/netlink/msgbuff.h
@@ -0,0 +1,106 @@
+/*
+ * msgbuff.h - netlink message buffer
+ *
+ * Declarations of netlink message buffer and related functions.
+ */
+
+#ifndef ETHTOOL_NETLINK_MSGBUFF_H__
+#define ETHTOOL_NETLINK_MSGBUFF_H__
+
+#include <string.h>
+#include <libmnl/libmnl.h>
+#include <linux/netlink.h>
+#include <linux/genetlink.h>
+
+struct nl_context;
+
+struct nl_msg_buff {
+	char			*buff;
+	unsigned int		size;
+	unsigned int		left;
+	struct nlmsghdr		*nlhdr;
+	struct genlmsghdr	*genlhdr;
+	void			*payload;
+};
+
+void msgbuff_init(struct nl_msg_buff *msgbuff);
+void msgbuff_done(struct nl_msg_buff *msgbuff);
+int msgbuff_realloc(struct nl_msg_buff *msgbuff, unsigned int new_size);
+int msgbuff_append(struct nl_msg_buff *dest, struct nl_msg_buff *src);
+
+int __msg_init(struct nl_msg_buff *msgbuff, int family, int cmd,
+	       unsigned int flags, int version);
+int msg_init(struct nl_context *nlctx, struct nl_msg_buff *msgbuff, int cmd,
+	     unsigned int flags);
+
+bool ethnla_put(struct nl_msg_buff *msgbuff, uint16_t type, size_t len,
+		const void *data);
+struct nlattr *ethnla_nest_start(struct nl_msg_buff *msgbuff, uint16_t type);
+bool ethnla_fill_header(struct nl_msg_buff *msgbuff, uint16_t type,
+			const char *devname, uint32_t flags);
+
+static inline unsigned int msgbuff_len(const struct nl_msg_buff *msgbuff)
+{
+	return msgbuff->nlhdr->nlmsg_len;
+}
+
+static inline void msgbuff_reset(const struct nl_msg_buff *msgbuff,
+				 unsigned int len)
+{
+	msgbuff->nlhdr->nlmsg_len = len;
+}
+
+/* put data wrappers */
+
+static inline void ethnla_nest_end(struct nl_msg_buff *msgbuff,
+				   struct nlattr *nest)
+{
+	return mnl_attr_nest_end(msgbuff->nlhdr, nest);
+}
+
+static inline void ethnla_nest_cancel(struct nl_msg_buff *msgbuff,
+				      struct nlattr *nest)
+{
+	return mnl_attr_nest_cancel(msgbuff->nlhdr, nest);
+}
+
+static inline bool ethnla_put_u32(struct nl_msg_buff *msgbuff, uint16_t type,
+				  uint32_t data)
+{
+	return ethnla_put(msgbuff, type, sizeof(uint32_t), &data);
+}
+
+static inline bool ethnla_put_u8(struct nl_msg_buff *msgbuff, uint16_t type,
+				 uint8_t data)
+{
+	return ethnla_put(msgbuff, type, sizeof(uint8_t), &data);
+}
+
+static inline bool ethnla_put_flag(struct nl_msg_buff *msgbuff, uint16_t type,
+				   bool val)
+{
+	if (val)
+		return ethnla_put(msgbuff, type, 0, &val);
+	else
+		return false;
+}
+
+static inline bool ethnla_put_bitfield32(struct nl_msg_buff *msgbuff,
+					 uint16_t type, uint32_t value,
+					 uint32_t selector)
+{
+	struct nla_bitfield32 val = {
+		.value		= value,
+		.selector	= selector,
+	};
+
+	return ethnla_put(msgbuff, type, sizeof(val), &val);
+}
+
+static inline bool ethnla_put_strz(struct nl_msg_buff *msgbuff, uint16_t type,
+				   const char *data)
+{
+	return ethnla_put(msgbuff, type, strlen(data) + 1, data);
+}
+
+#endif /* ETHTOOL_NETLINK_MSGBUFF_H__ */
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 610beccbefda..48c4ebb3d7aa 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -21,6 +21,7 @@ struct nl_context {
 	bool			is_dump;
 	int			exit_code;
 	bool			suppress_nlerr;
+	uint16_t		ethnl_fam;
 };
 
 #endif /* ETHTOOL_NETLINK_INT_H__ */
-- 
2.25.0

