Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C95E1606FE
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 23:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgBPWrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 17:47:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:33810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgBPWrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 17:47:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3A398AF63;
        Sun, 16 Feb 2020 22:47:11 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id DDD18E03D6; Sun, 16 Feb 2020 23:47:10 +0100 (CET)
Message-Id: <968e120364367cbc1919e0f00f3c0da028d8275c.1581892124.git.mkubecek@suse.cz>
In-Reply-To: <cover.1581892124.git.mkubecek@suse.cz>
References: <cover.1581892124.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 08/19] netlink: netlink socket wrapper and helpers
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Sun, 16 Feb 2020 23:47:10 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add data structure for netlink socket and few helpers to work with it.

The nl_socket structure is a wrapper for struct mnl_socket from libmnl,
a message buffer and some additional data. Helpers for sending netlink
(and genetlink), processing replies are provided as well as debugging
helpers.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am       |   3 +-
 internal.h        |   8 ++
 netlink/netlink.c |  28 +++++
 netlink/netlink.h |  11 ++
 netlink/nlsock.c  | 291 ++++++++++++++++++++++++++++++++++++++++++++++
 netlink/nlsock.h  |  35 ++++++
 6 files changed, 375 insertions(+), 1 deletion(-)
 create mode 100644 netlink/nlsock.c
 create mode 100644 netlink/nlsock.h

diff --git a/Makefile.am b/Makefile.am
index 12412b433445..857de24a130a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -27,7 +27,8 @@ endif
 if ETHTOOL_ENABLE_NETLINK
 ethtool_SOURCES += \
 		  netlink/netlink.c netlink/netlink.h netlink/extapi.h \
-		  netlink/msgbuff.c netlink/msgbuff.h \
+		  netlink/msgbuff.c netlink/msgbuff.h netlink/nlsock.c \
+		  netlink/nlsock.h \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h
 ethtool_CFLAGS += @MNL_CFLAGS@
diff --git a/internal.h b/internal.h
index 72a04e638a13..a518bfa99380 100644
--- a/internal.h
+++ b/internal.h
@@ -119,8 +119,16 @@ static inline int test_bit(unsigned int nr, const unsigned long *addr)
 /* debugging flags */
 enum {
 	DEBUG_PARSE,
+	DEBUG_NL_MSGS,		/* incoming/outgoing netlink messages */
+	DEBUG_NL_DUMP_SND,	/* dump outgoing netlink messages */
+	DEBUG_NL_DUMP_RCV,	/* dump incoming netlink messages */
 };
 
+static inline bool debug_on(unsigned long debug, unsigned int bit)
+{
+	return (debug & (1 << bit));
+}
+
 /* Internal values for old-style offload flags.  Values and names
  * must not clash with the flags defined for ETHTOOL_{G,S}FLAGS.
  */
diff --git a/netlink/netlink.c b/netlink/netlink.c
index 84e188119989..7d5eca666c84 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -10,6 +10,34 @@
 #include "netlink.h"
 #include "extapi.h"
 
+/* Used as reply callback for requests where no reply is expected (e.g. most
+ * "set" type commands)
+ */
+int nomsg_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct genlmsghdr *ghdr = (const struct genlmsghdr *)(nlhdr + 1);
+
+	fprintf(stderr, "received unexpected message: len=%u type=%u cmd=%u\n",
+		nlhdr->nlmsg_len, nlhdr->nlmsg_type, ghdr->cmd);
+	return MNL_CB_OK;
+}
+
+/* standard attribute parser callback; it fills provided array with pointers
+ * to attributes like kernel nla_parse(). We must expect to run on top of
+ * a newer kernel which may send attributes that we do not know (yet). Rather
+ * than treating them as an error, just ignore them.
+ */
+int attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct attr_tb_info *tb_info = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (type >= 0 && type <= tb_info->max_type)
+		tb_info->tb[type] = attr;
+
+	return MNL_CB_OK;
+}
+
 /* initialization */
 
 int netlink_init(struct cmd_context *ctx)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 48c4ebb3d7aa..54d2baaab516 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -24,4 +24,15 @@ struct nl_context {
 	uint16_t		ethnl_fam;
 };
 
+struct attr_tb_info {
+	const struct nlattr **tb;
+	unsigned int max_type;
+};
+
+#define DECLARE_ATTR_TB_INFO(tbl) \
+	struct attr_tb_info tbl ## _info = { (tbl), (MNL_ARRAY_SIZE(tbl) - 1) }
+
+int nomsg_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int attr_cb(const struct nlattr *attr, void *data);
+
 #endif /* ETHTOOL_NETLINK_INT_H__ */
diff --git a/netlink/nlsock.c b/netlink/nlsock.c
new file mode 100644
index 000000000000..8cb661e96e30
--- /dev/null
+++ b/netlink/nlsock.c
@@ -0,0 +1,291 @@
+/*
+ * nlsock.c - netlink socket
+ *
+ * Data structure and code for netlink socket abstraction.
+ */
+
+#include <stdint.h>
+#include <errno.h>
+
+#include "../internal.h"
+#include "nlsock.h"
+#include "netlink.h"
+
+#define NLSOCK_RECV_BUFFSIZE 65536
+
+#define __MSG_NAME(x) \
+	[ETHTOOL_MSG_ ## x] = "ETHTOOL_MSG_" #x
+
+static const char *const ethnl_umsg_names[] = {
+	__MSG_NAME(USER_NONE),
+	__MSG_NAME(STRSET_GET),
+	__MSG_NAME(LINKINFO_GET),
+	__MSG_NAME(LINKINFO_SET),
+	__MSG_NAME(LINKMODES_GET),
+	__MSG_NAME(LINKMODES_SET),
+	__MSG_NAME(LINKSTATE_GET),
+	__MSG_NAME(DEBUG_GET),
+	__MSG_NAME(DEBUG_SET),
+	__MSG_NAME(WOL_GET),
+	__MSG_NAME(WOL_SET),
+};
+
+static const char *const ethnl_kmsg_names[] = {
+	__MSG_NAME(KERNEL_NONE),
+	__MSG_NAME(STRSET_GET_REPLY),
+	__MSG_NAME(LINKINFO_GET_REPLY),
+	__MSG_NAME(LINKINFO_NTF),
+	__MSG_NAME(LINKMODES_GET_REPLY),
+	__MSG_NAME(LINKMODES_NTF),
+	__MSG_NAME(LINKSTATE_GET_REPLY),
+	__MSG_NAME(DEBUG_GET_REPLY),
+	__MSG_NAME(DEBUG_NTF),
+	__MSG_NAME(WOL_GET_REPLY),
+	__MSG_NAME(WOL_NTF),
+};
+
+#undef __MSG_NAME
+
+static const char *msg_type_str(unsigned int type, unsigned int ethnl_fam)
+{
+	if (type == ethnl_fam)
+		return "ethtool";
+
+	switch (type) {
+	case NLMSG_NOOP:
+		return "noop";
+	case NLMSG_ERROR:
+		return "error";
+	case NLMSG_DONE:
+		return "done";
+	case NLMSG_OVERRUN:
+		return "overrun";
+	case GENL_ID_CTRL:
+		return "genl-ctrl";
+	}
+
+	return "unknown";
+}
+
+static void debug_msg_summary(const struct nlmsghdr *nlhdr, int ethnl_fam,
+			      bool outgoing)
+{
+	const char * const *msg_names =
+		outgoing ? ethnl_umsg_names : ethnl_kmsg_names;
+	const unsigned int names_cnt =
+		outgoing ? MNL_ARRAY_SIZE(ethnl_umsg_names) :
+			   MNL_ARRAY_SIZE(ethnl_kmsg_names);
+
+	printf("    msg length %u family %u (%s) flags %04x", nlhdr->nlmsg_len,
+	       nlhdr->nlmsg_type, msg_type_str(nlhdr->nlmsg_type, ethnl_fam),
+	       nlhdr->nlmsg_flags);
+	if (nlhdr->nlmsg_type == ethnl_fam &&
+	    nlhdr->nlmsg_len >= NLMSG_HDRLEN + GENL_HDRLEN) {
+		const struct genlmsghdr *ghdr = mnl_nlmsg_get_payload(nlhdr);
+		unsigned int cmd = ghdr->cmd;
+		const char *cmd_name = "unknown";
+
+		if (cmd < names_cnt && msg_names[cmd])
+			cmd_name = msg_names[cmd];
+		printf(" ethtool cmd %u (%s)", cmd, cmd_name);
+	}
+	fputc('\n', stdout);
+}
+
+static void debug_msg(struct nl_socket *nlsk, const void *msg, unsigned int len,
+		      bool outgoing)
+{
+	const char *dirlabel = outgoing ? "sending" : "received";
+	uint32_t debug = nlsk->nlctx->ctx->debug;
+	const struct nlmsghdr *nlhdr = msg;
+	bool summary, dump;
+	int left = len;
+
+	summary = debug_on(debug, DEBUG_NL_MSGS);
+	dump = debug_on(debug,
+			outgoing ? DEBUG_NL_DUMP_SND : DEBUG_NL_DUMP_RCV);
+	if (!summary && !dump)
+		return;
+	printf("%s packet (%u bytes):\n", dirlabel, len);
+
+	while (nlhdr && left > 0 && mnl_nlmsg_ok(nlhdr, left)) {
+		if (summary)
+			debug_msg_summary(nlhdr, nlsk->nlctx->ethnl_fam,
+					  outgoing);
+		if (dump)
+			mnl_nlmsg_fprintf(stdout, nlhdr, nlhdr->nlmsg_len,
+					  GENL_HDRLEN);
+
+		nlhdr = mnl_nlmsg_next(nlhdr, &left);
+	}
+}
+
+static int nlsock_process_ack(struct nlmsghdr *nlhdr, ssize_t len, bool silent)
+{
+	const struct nlattr *tb[NLMSGERR_ATTR_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	unsigned int tlv_offset;
+	struct nlmsgerr *nlerr;
+
+	if (len < NLMSG_HDRLEN + sizeof(*nlerr))
+		return -EFAULT;
+	nlerr = mnl_nlmsg_get_payload(nlhdr);
+	if (silent || !(nlhdr->nlmsg_flags & NLM_F_ACK_TLVS))
+		goto out;
+	tlv_offset = sizeof(*nlerr);
+	if (!(nlhdr->nlmsg_flags & NLM_F_CAPPED))
+		tlv_offset += MNL_ALIGN(mnl_nlmsg_get_payload_len(&nlerr->msg));
+
+	if (mnl_attr_parse(nlhdr, tlv_offset, attr_cb, &tb_info) < 0)
+		goto out;
+	if (tb[NLMSGERR_ATTR_MSG]) {
+		const char *msg = mnl_attr_get_str(tb[NLMSGERR_ATTR_MSG]);
+
+		fprintf(stderr, "netlink %s: %s",
+			nlerr->error ? "error" : "warning", msg);
+		if (tb[NLMSGERR_ATTR_OFFS])
+			fprintf(stderr, " (offset %u)",
+				mnl_attr_get_u32(tb[NLMSGERR_ATTR_OFFS]));
+		fputc('\n', stderr);
+	}
+
+out:
+	if (nlerr->error) {
+		errno = -nlerr->error;
+		if (!silent)
+			perror("netlink error");
+	}
+	return nlerr->error;
+}
+
+int nlsock_process_reply(struct nl_socket *nlsk, mnl_cb_t reply_cb, void *data)
+{
+	struct nl_msg_buff *msgbuff = &nlsk->msgbuff;
+	struct nlmsghdr *nlhdr;
+	ssize_t len;
+	char *buff;
+	int ret;
+
+	ret = msgbuff_realloc(msgbuff, NLSOCK_RECV_BUFFSIZE);
+	if (ret < 0)
+		return ret;
+	buff = msgbuff->buff;
+
+	do {
+		len = mnl_socket_recvfrom(nlsk->sk, buff, msgbuff->size);
+		if (len <= 0)
+			return (len ? -EFAULT : 0);
+		debug_msg(nlsk, buff, len, false);
+		if (len < NLMSG_HDRLEN)
+			return -EFAULT;
+
+		nlhdr = (struct nlmsghdr *)buff;
+		if (nlhdr->nlmsg_type == NLMSG_ERROR)
+			return nlsock_process_ack(nlhdr, len,
+						  nlsk->nlctx->suppress_nlerr);
+
+		msgbuff->nlhdr = nlhdr;
+		msgbuff->genlhdr = mnl_nlmsg_get_payload(nlhdr);
+		msgbuff->payload =
+			mnl_nlmsg_get_payload_offset(nlhdr, GENL_HDRLEN);
+		ret = mnl_cb_run(buff, len, nlsk->seq, nlsk->port, reply_cb,
+				 data);
+	} while (ret > 0);
+
+	return ret;
+}
+
+int nlsock_prep_get_request(struct nl_socket *nlsk, unsigned int nlcmd,
+			    uint16_t hdr_attrtype, u32 flags)
+{
+	unsigned int nlm_flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nl_context *nlctx = nlsk->nlctx;
+	const char *devname = nlctx->ctx->devname;
+	int ret;
+
+	if (devname && !strcmp(devname, WILDCARD_DEVNAME)) {
+		devname = NULL;
+		nlm_flags |= NLM_F_DUMP;
+	}
+	nlctx->is_dump = !devname;
+
+	ret = msg_init(nlctx, &nlsk->msgbuff, nlcmd, nlm_flags);
+	if (ret < 0)
+		return ret;
+	if (ethnla_fill_header(&nlsk->msgbuff, hdr_attrtype, devname, flags))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+ssize_t nlsock_sendmsg(struct nl_socket *nlsk, struct nl_msg_buff *altbuff)
+{
+	struct nl_msg_buff *msgbuff = altbuff ?: &nlsk->msgbuff;
+	struct nlmsghdr *nlhdr = msgbuff->nlhdr;
+
+	nlhdr->nlmsg_seq = ++nlsk->seq;
+	debug_msg(nlsk, msgbuff->buff, nlhdr->nlmsg_len, true);
+	return mnl_socket_sendto(nlsk->sk, nlhdr, nlhdr->nlmsg_len);
+}
+
+int nlsock_send_get_request(struct nl_socket *nlsk, mnl_cb_t cb)
+{
+	int ret;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		goto err;
+	ret = nlsock_process_reply(nlsk, cb, nlsk->nlctx);
+	if (ret == 0)
+		return 0;
+err:
+	return nlsk->nlctx->exit_code ?: 1;
+}
+
+int __nlsock_init(struct nl_context *nlctx, struct nl_socket **__nlsk, int bus)
+{
+	struct nl_socket *nlsk;
+	int val;
+	int ret;
+
+	nlsk = calloc(1, sizeof(*nlsk));
+	if (!nlsk)
+		return -ENOMEM;
+	nlsk->nlctx = nlctx;
+	msgbuff_init(&nlsk->msgbuff);
+
+	ret = -ECONNREFUSED;
+	nlsk->sk = mnl_socket_open(bus);
+	if (!nlsk->sk)
+		goto out_msgbuff;
+	val = 1;
+	mnl_socket_setsockopt(nlsk->sk, NETLINK_EXT_ACK, &val, sizeof(val));
+	ret = mnl_socket_bind(nlsk->sk, 0, MNL_SOCKET_AUTOPID);
+	if (ret < 0)
+		goto out_close;
+	nlsk->port = mnl_socket_get_portid(nlsk->sk);
+
+	*__nlsk = nlsk;
+	return 0;
+
+out_close:
+	if (nlsk->sk)
+		mnl_socket_close(nlsk->sk);
+out_msgbuff:
+	msgbuff_done(&nlsk->msgbuff);
+	free(nlsk);
+	return ret;
+}
+
+int nlsock_init(struct nl_context *nlctx,  struct nl_socket **__nlsk)
+{
+	return __nlsock_init(nlctx, __nlsk, NETLINK_GENERIC);
+}
+
+void nlsock_done(struct nl_socket *nlsk)
+{
+	if (nlsk->sk)
+		mnl_socket_close(nlsk->sk);
+	msgbuff_done(&nlsk->msgbuff);
+	memset(nlsk, '\0', sizeof(*nlsk));
+}
diff --git a/netlink/nlsock.h b/netlink/nlsock.h
new file mode 100644
index 000000000000..beab176e6775
--- /dev/null
+++ b/netlink/nlsock.h
@@ -0,0 +1,35 @@
+/*
+ * nlsock.h - netlink socket
+ *
+ * Declarations of netlink socket structure and related functions.
+ */
+
+#ifndef ETHTOOL_NETLINK_NLSOCK_H__
+#define ETHTOOL_NETLINK_NLSOCK_H__
+
+#include <libmnl/libmnl.h>
+#include <linux/netlink.h>
+#include <linux/genetlink.h>
+#include <linux/ethtool_netlink.h>
+#include "msgbuff.h"
+
+struct nl_context;
+
+struct nl_socket {
+	struct nl_context	*nlctx;
+	struct mnl_socket	*sk;
+	struct nl_msg_buff	msgbuff;
+	unsigned int		port;
+	unsigned int		seq;
+};
+
+int __nlsock_init(struct nl_context *nlctx, struct nl_socket **__nlsk, int bus);
+int nlsock_init(struct nl_context *nlctx,  struct nl_socket **__nlsk);
+void nlsock_done(struct nl_socket *nlsk);
+int nlsock_prep_get_request(struct nl_socket *nlsk, unsigned int nlcmd,
+			    uint16_t hdr_attrtype, u32 flags);
+ssize_t nlsock_sendmsg(struct nl_socket *nlsk, struct nl_msg_buff *__msgbuff);
+int nlsock_send_get_request(struct nl_socket *nlsk, mnl_cb_t cb);
+int nlsock_process_reply(struct nl_socket *nlsk, mnl_cb_t reply_cb, void *data);
+
+#endif /* ETHTOOL_NETLINK_NLSOCK_H__ */
-- 
2.25.0

