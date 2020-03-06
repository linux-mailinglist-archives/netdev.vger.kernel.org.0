Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6CE617C3A5
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCFRG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:06:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:44388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgCFRG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:06:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AAE57B38A;
        Fri,  6 Mar 2020 17:06:05 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 5A4D5E00E7; Fri,  6 Mar 2020 18:06:05 +0100 (CET)
Message-Id: <960555ef01564626dd3ebff99f5534896d58bfb2.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 25/25] netlink: use pretty printing for ethtool
 netlink messages
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:06:05 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new debugging flag DEBUG_NL_PRETTY_MSG (0x10) which has two
effects:

  - show request messages embedded in extack error messages in human
    readable form; if failing attribute offset is provided, highlight the
    attribute
  - if DEBUG_NL_MSGS is also set, show structure of all outgoing and
    incoming ethtool netlink messages in addition to their summary

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 internal.h       |  1 +
 netlink/nlsock.c | 71 +++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/internal.h b/internal.h
index a518bfa99380..edb07bddd073 100644
--- a/internal.h
+++ b/internal.h
@@ -122,6 +122,7 @@ enum {
 	DEBUG_NL_MSGS,		/* incoming/outgoing netlink messages */
 	DEBUG_NL_DUMP_SND,	/* dump outgoing netlink messages */
 	DEBUG_NL_DUMP_RCV,	/* dump incoming netlink messages */
+	DEBUG_NL_PRETTY_MSG,	/* pretty print of messages and errors */
 };
 
 static inline bool debug_on(unsigned long debug, unsigned int bit)
diff --git a/netlink/nlsock.c b/netlink/nlsock.c
index 4366c52ce390..22abb68b6646 100644
--- a/netlink/nlsock.c
+++ b/netlink/nlsock.c
@@ -10,6 +10,7 @@
 #include "../internal.h"
 #include "nlsock.h"
 #include "netlink.h"
+#include "prettymsg.h"
 
 #define NLSOCK_RECV_BUFFSIZE 65536
 
@@ -43,10 +44,12 @@ static void ctrl_msg_summary(const struct nlmsghdr *nlhdr)
 }
 
 static void genl_msg_summary(const struct nlmsghdr *nlhdr, int ethnl_fam,
-			     bool outgoing)
+			     bool outgoing, bool pretty)
 {
 	if (nlhdr->nlmsg_type == ethnl_fam) {
+		const struct pretty_nlmsg_desc *msg_desc;
 		const struct genlmsghdr *ghdr;
+		unsigned int n_desc;
 
 		printf(" ethool");
 		if (nlhdr->nlmsg_len < NLMSG_HDRLEN + GENL_HDRLEN) {
@@ -55,27 +58,46 @@ static void genl_msg_summary(const struct nlmsghdr *nlhdr, int ethnl_fam,
 		}
 		ghdr = mnl_nlmsg_get_payload(nlhdr);
 
-		printf(" cmd %u", ghdr->cmd);
+		msg_desc = outgoing ? ethnl_umsg_desc : ethnl_kmsg_desc;
+		n_desc = outgoing ? ethnl_umsg_n_desc : ethnl_kmsg_n_desc;
+		if (ghdr->cmd < n_desc && msg_desc[ghdr->cmd].name)
+			printf(" %s", msg_desc[ghdr->cmd].name);
+		else
+			printf(" cmd %u", ghdr->cmd);
 		fputc('\n', stdout);
 
+		if (pretty)
+			pretty_print_genlmsg(nlhdr, msg_desc, n_desc, 0);
 		return;
 	}
 
-	if (nlhdr->nlmsg_type == GENL_ID_CTRL)
+	if (nlhdr->nlmsg_type == GENL_ID_CTRL) {
 		printf(" genl-ctrl\n");
-	else
+		if (pretty)
+			pretty_print_genlmsg(nlhdr, genlctrl_msg_desc,
+					     genlctrl_msg_n_desc, 0);
+	} else {
 		fputc('\n', stdout);
+		if (pretty)
+			pretty_print_genlmsg(nlhdr, NULL, 0, 0);
+	}
 }
 
-static void rtnl_msg_summary(const struct nlmsghdr *nlhdr)
+static void rtnl_msg_summary(const struct nlmsghdr *nlhdr, bool pretty)
 {
 	unsigned int type = nlhdr->nlmsg_type;
 
-	printf(" type %u\n", type);
+	if (type < rtnl_msg_n_desc && rtnl_msg_desc[type].name)
+		printf(" %s\n", rtnl_msg_desc[type].name);
+	else
+		printf(" type %u\n", type);
+
+	if (pretty)
+		pretty_print_rtnlmsg(nlhdr, 0);
 }
 
 static void debug_msg_summary(const struct nlmsghdr *nlhdr, int ethnl_fam,
-			      int nl_fam, bool outgoing)
+			      int nl_fam, bool outgoing, bool pretty)
 {
 	printf("    msg length %u", nlhdr->nlmsg_len);
 
@@ -86,10 +108,10 @@ static void debug_msg_summary(const struct nlmsghdr *nlhdr, int ethnl_fam,
 
 	switch(nl_fam) {
 	case NETLINK_GENERIC:
-		genl_msg_summary(nlhdr, ethnl_fam, outgoing);
+		genl_msg_summary(nlhdr, ethnl_fam, outgoing, pretty);
 		break;
 	case NETLINK_ROUTE:
-		rtnl_msg_summary(nlhdr);
+		rtnl_msg_summary(nlhdr, pretty);
 		break;
 	default:
 		fputc('\n', stdout);
@@ -103,13 +125,14 @@ static void debug_msg(struct nl_socket *nlsk, const void *msg, unsigned int len,
 	const char *dirlabel = outgoing ? "sending" : "received";
 	uint32_t debug = nlsk->nlctx->ctx->debug;
 	const struct nlmsghdr *nlhdr = msg;
-	bool summary, dump;
+	bool summary, dump, pretty;
 	const char *nl_fam_label;
 	int left = len;
 
 	summary = debug_on(debug, DEBUG_NL_MSGS);
 	dump = debug_on(debug,
 			outgoing ? DEBUG_NL_DUMP_SND : DEBUG_NL_DUMP_RCV);
+	pretty = debug_on(debug, DEBUG_NL_PRETTY_MSG);
 	if (!summary && !dump)
 		return;
 	switch(nlsk->nl_fam) {
@@ -128,7 +151,7 @@ static void debug_msg(struct nl_socket *nlsk, const void *msg, unsigned int len,
 	while (nlhdr && left > 0 && mnl_nlmsg_ok(nlhdr, left)) {
 		if (summary)
 			debug_msg_summary(nlhdr, nlsk->nlctx->ethnl_fam,
-					  nlsk->nl_fam, outgoing);
+					  nlsk->nl_fam, outgoing, pretty);
 		if (dump)
 			mnl_nlmsg_fprintf(stdout, nlhdr, nlhdr->nlmsg_len,
 					  GENL_HDRLEN);
@@ -146,7 +169,7 @@ static void debug_msg(struct nl_socket *nlsk, const void *msg, unsigned int len,
  * Return: error code extracted from the message
  */
 static int nlsock_process_ack(struct nlmsghdr *nlhdr, ssize_t len,
-			      unsigned int suppress_nlerr)
+			      unsigned int suppress_nlerr, bool pretty)
 {
 	const struct nlattr *tb[NLMSGERR_ATTR_MAX + 1] = {};
 	DECLARE_ATTR_TB_INFO(tb);
@@ -174,12 +197,23 @@ static int nlsock_process_ack(struct nlmsghdr *nlhdr, ssize_t len,
 
 		fprintf(stderr, "netlink %s: %s",
 			nlerr->error ? "error" : "warning", msg);
-		if (tb[NLMSGERR_ATTR_OFFS])
+		if (!pretty && tb[NLMSGERR_ATTR_OFFS])
 			fprintf(stderr, " (offset %u)",
 				mnl_attr_get_u32(tb[NLMSGERR_ATTR_OFFS]));
 		fputc('\n', stderr);
 	}
 
+	if (nlerr->error && pretty) {
+		unsigned int err_offset = 0;
+
+		if (tb[NLMSGERR_ATTR_OFFS])
+			err_offset = mnl_attr_get_u32(tb[NLMSGERR_ATTR_OFFS]);
+		fprintf(stderr, "offending message%s:\n",
+			err_offset ? " and attribute" : "");
+		pretty_print_genlmsg(&nlerr->msg, ethnl_umsg_desc,
+				     ethnl_umsg_n_desc, err_offset);
+	}
+
 out:
 	if (nlerr->error) {
 		errno = -nlerr->error;
@@ -223,9 +257,14 @@ int nlsock_process_reply(struct nl_socket *nlsk, mnl_cb_t reply_cb, void *data)
 			return -EFAULT;
 
 		nlhdr = (struct nlmsghdr *)buff;
-		if (nlhdr->nlmsg_type == NLMSG_ERROR)
-			return nlsock_process_ack(nlhdr, len,
-						  nlsk->nlctx->suppress_nlerr);
+		if (nlhdr->nlmsg_type == NLMSG_ERROR) {
+			bool silent = nlsk->nlctx->suppress_nlerr;
+			bool pretty;
+
+			pretty = debug_on(nlsk->nlctx->ctx->debug,
+					  DEBUG_NL_PRETTY_MSG);
+			return nlsock_process_ack(nlhdr, len, silent, pretty);
+		}
 
 		msgbuff->nlhdr = nlhdr;
 		msgbuff->genlhdr = mnl_nlmsg_get_payload(nlhdr);
-- 
2.25.1

