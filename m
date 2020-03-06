Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D8917C386
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgCFREq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:04:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:43368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgCFREq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:04:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3B5E7B2D8;
        Fri,  6 Mar 2020 17:04:40 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E04CCE00E7; Fri,  6 Mar 2020 18:04:39 +0100 (CET)
Message-Id: <a7554f0344d19d2c36893dd30307bfedb08076da.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 08/25] netlink: netlink socket wrapper and helpers
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:04:39 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add data structure for netlink socket and few helpers to work with it.

The nl_socket structure is a wrapper for struct mnl_socket from libmnl,
a message buffer and some additional data. Helpers for sending netlink
(and genetlink), processing replies are provided as well as debugging
helpers.

v2:
  - reworked debugging output for incoming/outgoing messages
  - drop tables of message type names (replaced in patch 22)
  - nl_context::suppress_nlerr allows two levels (EOPNOTSUPP / all codes)
  - drop nlsock_init(), rename __nlsock_init() to nlsock_init()
  - add kerneldoc style comments

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am       |   3 +-
 internal.h        |   8 +
 netlink/netlink.c |  28 ++++
 netlink/netlink.h |  11 ++
 netlink/nlsock.c  | 364 ++++++++++++++++++++++++++++++++++++++++++++++
 netlink/nlsock.h  |  45 ++++++
 6 files changed, 458 insertions(+), 1 deletion(-)
 create mode 100644 netlink/nlsock.c
 create mode 100644 netlink/nlsock.h

diff --git a/Makefile.am b/Makefile.am
index 2f4b8334cfe6..c51193ac92fd 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -26,7 +26,8 @@ endif
 if ETHTOOL_ENABLE_NETLINK
 ethtool_SOURCES += \
 		  netlink/netlink.c netlink/netlink.h netlink/extapi.h \
-		  netlink/msgbuff.c netlink/msgbuff.h \
+		  netlink/msgbuff.c netlink/msgbuff.h netlink/nlsock.c \
+		  netlink/nlsock.h \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
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
index 1eaeec30b7d2..fbcea0b62240 100644
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
index 000000000000..d5fa668f508d
--- /dev/null
+++ b/netlink/nlsock.c
@@ -0,0 +1,364 @@
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
+static void ctrl_msg_summary(const struct nlmsghdr *nlhdr)
+{
+	const struct nlmsgerr *nlerr;
+
+	switch (nlhdr->nlmsg_type) {
+	case NLMSG_NOOP:
+		printf(" noop\n");
+		break;
+	case NLMSG_ERROR:
+		printf(" error");
+		if (nlhdr->nlmsg_len < NLMSG_HDRLEN + sizeof(*nlerr)) {
+			printf(" malformed\n");
+			break;
+		}
+		nlerr = mnl_nlmsg_get_payload(nlhdr);
+		printf(" errno=%d\n", nlerr->error);
+		break;
+	case NLMSG_DONE:
+		printf(" done\n");
+		break;
+	case NLMSG_OVERRUN:
+		printf(" overrun\n");
+		break;
+	default:
+		printf(" type %u\n", nlhdr->nlmsg_type);
+		break;
+	}
+}
+
+static void genl_msg_summary(const struct nlmsghdr *nlhdr, int ethnl_fam,
+			     bool outgoing)
+{
+	if (nlhdr->nlmsg_type == ethnl_fam) {
+		const struct genlmsghdr *ghdr;
+
+		printf(" ethool");
+		if (nlhdr->nlmsg_len < NLMSG_HDRLEN + GENL_HDRLEN) {
+			printf(" malformed\n");
+			return;
+		}
+		ghdr = mnl_nlmsg_get_payload(nlhdr);
+
+		printf(" cmd %u", ghdr->cmd);
+		fputc('\n', stdout);
+
+		return;
+	}
+
+	if (nlhdr->nlmsg_type == GENL_ID_CTRL)
+		printf(" genl-ctrl\n");
+	else
+		fputc('\n', stdout);
+}
+
+static void rtnl_msg_summary(const struct nlmsghdr *nlhdr)
+{
+	unsigned int type = nlhdr->nlmsg_type;
+
+	printf(" type %u\n", type);
+}
+
+static void debug_msg_summary(const struct nlmsghdr *nlhdr, int ethnl_fam,
+			      int nl_fam, bool outgoing)
+{
+	printf("    msg length %u", nlhdr->nlmsg_len);
+
+	if (nlhdr->nlmsg_type < NLMSG_MIN_TYPE) {
+		ctrl_msg_summary(nlhdr);
+		return;
+	}
+
+	switch(nl_fam) {
+	case NETLINK_GENERIC:
+		genl_msg_summary(nlhdr, ethnl_fam, outgoing);
+		break;
+	case NETLINK_ROUTE:
+		rtnl_msg_summary(nlhdr);
+		break;
+	default:
+		fputc('\n', stdout);
+		break;
+	}
+}
+
+static void debug_msg(struct nl_socket *nlsk, const void *msg, unsigned int len,
+		      bool outgoing)
+{
+	const char *dirlabel = outgoing ? "sending" : "received";
+	uint32_t debug = nlsk->nlctx->ctx->debug;
+	const struct nlmsghdr *nlhdr = msg;
+	bool summary, dump;
+	const char *nl_fam_label;
+	int left = len;
+
+	summary = debug_on(debug, DEBUG_NL_MSGS);
+	dump = debug_on(debug,
+			outgoing ? DEBUG_NL_DUMP_SND : DEBUG_NL_DUMP_RCV);
+	if (!summary && !dump)
+		return;
+	switch(nlsk->nl_fam) {
+	case NETLINK_GENERIC:
+		nl_fam_label = "genetlink";
+		break;
+	case NETLINK_ROUTE:
+		nl_fam_label = "rtnetlink";
+		break;
+	default:
+		nl_fam_label = "netlink";
+		break;
+	}
+	printf("%s %s packet (%u bytes):\n", dirlabel, nl_fam_label, len);
+
+	while (nlhdr && left > 0 && mnl_nlmsg_ok(nlhdr, left)) {
+		if (summary)
+			debug_msg_summary(nlhdr, nlsk->nlctx->ethnl_fam,
+					  nlsk->nl_fam, outgoing);
+		if (dump)
+			mnl_nlmsg_fprintf(stdout, nlhdr, nlhdr->nlmsg_len,
+					  GENL_HDRLEN);
+
+		nlhdr = mnl_nlmsg_next(nlhdr, &left);
+	}
+}
+
+/**
+ * nlsock_process_ack() - process NLMSG_ERROR message from kernel
+ * @nlhdr:          pointer to netlink header
+ * @len:            length of received data (from nlhdr to end of buffer)
+ * @suppress_nlerr: 0 show all errors, 1 silence -EOPNOTSUPP, 2 silence all
+ *
+ * Return: error code extracted from the message
+ */
+static int nlsock_process_ack(struct nlmsghdr *nlhdr, ssize_t len,
+			      unsigned int suppress_nlerr)
+{
+	const struct nlattr *tb[NLMSGERR_ATTR_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	unsigned int tlv_offset;
+	struct nlmsgerr *nlerr;
+	bool silent;
+
+	if (len < NLMSG_HDRLEN + sizeof(*nlerr))
+		return -EFAULT;
+	nlerr = mnl_nlmsg_get_payload(nlhdr);
+	silent = (!(nlhdr->nlmsg_flags & NLM_F_ACK_TLVS) ||
+		  suppress_nlerr >= 2 ||
+		  (suppress_nlerr && nlerr->error == -EOPNOTSUPP));
+	if (silent)
+		goto out;
+
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
+/**
+ * nlsock_process_reply() - process reply packet(s) from kernel
+ * @nlsk:     netlink socket to read from
+ * @reply_cb: callback to process each message
+ * @data:     pointer passed as argument to @reply_cb callback
+ *
+ * Read packets from kernel and pass reply messages to @reply_cb callback
+ * until an error is encountered or NLMSG_ERR message is received. In the
+ * latter case, return value is the error code extracted from it.
+ *
+ * Return: 0 on success or negative error code
+ */
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
+/**
+ * nlsock_sendmsg() - send a netlink message to kernel
+ * @nlsk:    netlink socket
+ * @altbuff: alternative message buffer; if null, use buffer embedded in @nlsk
+ *
+ * Return: sent size or negative error code
+ */
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
+/**
+ * nlsock_send_get_request() - send request and process reply
+ * @nlsk: netlink socket
+ * @cb:   callback to process reply message(s)
+ *
+ * This simple helper only handles the most common case when the embedded
+ * message buffer is sent and @cb takes netlink context (struct nl_context)
+ * as last argument.
+ */
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
+/**
+ * nlsock_init() - allocate and initialize netlink socket
+ * @nlctx:  netlink context
+ * @__nlsk: store pointer to the allocated socket here
+ * @nl_fam: netlink family (e.g. NETLINK_GENERIC or NETLINK_ROUTE)
+ *
+ * Allocate and initialize netlink socket and its embedded message buffer.
+ * Cleans up on error, caller is responsible for destroying the socket with
+ * nlsock_done() on success.
+ *
+ * Return: 0 on success or negative error code
+ */
+int nlsock_init(struct nl_context *nlctx, struct nl_socket **__nlsk, int nl_fam)
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
+	nlsk->sk = mnl_socket_open(nl_fam);
+	if (!nlsk->sk)
+		goto out_msgbuff;
+	val = 1;
+	mnl_socket_setsockopt(nlsk->sk, NETLINK_EXT_ACK, &val, sizeof(val));
+	ret = mnl_socket_bind(nlsk->sk, 0, MNL_SOCKET_AUTOPID);
+	if (ret < 0)
+		goto out_close;
+	nlsk->port = mnl_socket_get_portid(nlsk->sk);
+	nlsk->nl_fam = nl_fam;
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
+/**
+ * nlsock_done() - destroy a netlink socket
+ * @nlsk: netlink socket
+ *
+ * Close the socket and free the structure and related data.
+ */
+void nlsock_done(struct nl_socket *nlsk)
+{
+	if (nlsk->sk)
+		mnl_socket_close(nlsk->sk);
+	msgbuff_done(&nlsk->msgbuff);
+	memset(nlsk, '\0', sizeof(*nlsk));
+}
diff --git a/netlink/nlsock.h b/netlink/nlsock.h
new file mode 100644
index 000000000000..b015f8642704
--- /dev/null
+++ b/netlink/nlsock.h
@@ -0,0 +1,45 @@
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
+/**
+ * struct nl_socket - netlink socket abstraction
+ * @nlctx:   netlink context
+ * @sk:      libmnl socket handle
+ * @msgbuff: embedded message buffer used by default
+ * @port:    port number for netlink header
+ * @seq:     autoincremented sequence number for netlink header
+ * @nl_fam:  netlink family (e.g. NETLINK_GENERIC or NETLINK_ROUTE)
+ */
+struct nl_socket {
+	struct nl_context	*nlctx;
+	struct mnl_socket	*sk;
+	struct nl_msg_buff	msgbuff;
+	unsigned int		port;
+	unsigned int		seq;
+	int			nl_fam;
+};
+
+int nlsock_init(struct nl_context *nlctx, struct nl_socket **__nlsk,
+		int nl_fam);
+void nlsock_done(struct nl_socket *nlsk);
+int nlsock_prep_get_request(struct nl_socket *nlsk, unsigned int nlcmd,
+			    uint16_t hdr_attrtype, u32 flags);
+ssize_t nlsock_sendmsg(struct nl_socket *nlsk, struct nl_msg_buff *__msgbuff);
+int nlsock_send_get_request(struct nl_socket *nlsk, mnl_cb_t cb);
+int nlsock_process_reply(struct nl_socket *nlsk, mnl_cb_t reply_cb, void *data);
+
+#endif /* ETHTOOL_NETLINK_NLSOCK_H__ */
-- 
2.25.1

