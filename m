Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5CE40B1F5
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbhINOsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:48:47 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:45657 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234989AbhINOsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 10:48:16 -0400
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id B8C87B41E2A;
        Tue, 14 Sep 2021 16:46:56 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mQ9i4-0001nS-NX; Tue, 14 Sep 2021 16:46:56 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        antony.antony@secunet.com
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [RFC PATCH iproute2 v2] xfrm: enable to manage default policies
Date:   Tue, 14 Sep 2021 16:46:35 +0200
Message-Id: <20210914144635.6850-4-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914144635.6850-1-nicolas.dichtel@6wind.com>
References: <20210908072341.5647-1-nicolas.dichtel@6wind.com>
 <20210914144635.6850-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new commands to manage default policies:
 - ip xfrm policy setdefault
 - ip xfrm policy getdefault

And the corresponding part in 'ip xfrm monitor'.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/uapi/linux/xfrm.h |   9 ++-
 ip/xfrm.h                 |   1 +
 ip/xfrm_monitor.c         |   3 +
 ip/xfrm_policy.c          | 121 ++++++++++++++++++++++++++++++++++++++
 man/man8/ip-xfrm.8        |  12 ++++
 5 files changed, 143 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index ecd06396eb16..2a8135e31f9d 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -514,9 +514,12 @@ struct xfrm_user_offload {
 #define XFRM_OFFLOAD_INBOUND	2
 
 struct xfrm_userpolicy_default {
-#define XFRM_USERPOLICY_DIRMASK_MAX	(sizeof(__u8) * 8)
-	__u8				dirmask;
-	__u8				action;
+#define XFRM_USERPOLICY_UNSPEC	0
+#define XFRM_USERPOLICY_BLOCK	1
+#define XFRM_USERPOLICY_ACCEPT	2
+	__u8				in;
+	__u8				fwd;
+	__u8				out;
 };
 
 /* backwards compatibility for userspace */
diff --git a/ip/xfrm.h b/ip/xfrm.h
index 9ba5ca61d5e4..17dcf3fea83f 100644
--- a/ip/xfrm.h
+++ b/ip/xfrm.h
@@ -132,6 +132,7 @@ void xfrm_state_info_print(struct xfrm_usersa_info *xsinfo,
 void xfrm_policy_info_print(struct xfrm_userpolicy_info *xpinfo,
 			    struct rtattr *tb[], FILE *fp, const char *prefix,
 			    const char *title);
+int xfrm_policy_default_print(struct nlmsghdr *n, FILE *fp);
 int xfrm_id_parse(xfrm_address_t *saddr, struct xfrm_id *id, __u16 *family,
 		  int loose, int *argcp, char ***argvp);
 int xfrm_mode_parse(__u8 *mode, int *argcp, char ***argvp);
diff --git a/ip/xfrm_monitor.c b/ip/xfrm_monitor.c
index e34b5fbda130..f67424c5be06 100644
--- a/ip/xfrm_monitor.c
+++ b/ip/xfrm_monitor.c
@@ -323,6 +323,9 @@ static int xfrm_accept_msg(struct rtnl_ctrl_data *ctrl,
 	case XFRM_MSG_MAPPING:
 		xfrm_mapping_print(n, arg);
 		return 0;
+	case XFRM_MSG_GETDEFAULT:
+		xfrm_policy_default_print(n, arg);
+		return 0;
 	default:
 		break;
 	}
diff --git a/ip/xfrm_policy.c b/ip/xfrm_policy.c
index 7cc00e7c2f5b..744f331ff564 100644
--- a/ip/xfrm_policy.c
+++ b/ip/xfrm_policy.c
@@ -66,6 +66,8 @@ static void usage(void)
 		"Usage: ip xfrm policy flush [ ptype PTYPE ]\n"
 		"Usage: ip xfrm policy count\n"
 		"Usage: ip xfrm policy set [ hthresh4 LBITS RBITS ] [ hthresh6 LBITS RBITS ]\n"
+		"Usage: ip xfrm policy setdefault DIR ACTION [ DIR ACTION ] [ DIR ACTION ]\n"
+		"Usage: ip xfrm policy getdefault\n"
 		"SELECTOR := [ src ADDR[/PLEN] ] [ dst ADDR[/PLEN] ] [ dev DEV ] [ UPSPEC ]\n"
 		"UPSPEC := proto { { tcp | udp | sctp | dccp } [ sport PORT ] [ dport PORT ] |\n"
 		"                  { icmp | ipv6-icmp | mobility-header } [ type NUMBER ] [ code NUMBER ] |\n"
@@ -1124,6 +1126,121 @@ static int xfrm_spd_getinfo(int argc, char **argv)
 	return 0;
 }
 
+static int xfrm_spd_setdefault(int argc, char **argv)
+{
+	struct rtnl_handle rth;
+	struct {
+		struct nlmsghdr			n;
+		struct xfrm_userpolicy_default  up;
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct xfrm_userpolicy_default)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = XFRM_MSG_SETDEFAULT,
+	};
+
+	while (argc > 0) {
+		if (strcmp(*argv, "in") == 0) {
+			if (req.up.in)
+				duparg("in", *argv);
+
+			NEXT_ARG();
+			if (strcmp(*argv, "block") == 0)
+				req.up.in = XFRM_USERPOLICY_BLOCK;
+			else if (strcmp(*argv, "accept") == 0)
+				req.up.in = XFRM_USERPOLICY_ACCEPT;
+			else
+				invarg("in policy value is invalid", *argv);
+		} else if (strcmp(*argv, "fwd") == 0) {
+			if (req.up.fwd)
+				duparg("fwd", *argv);
+
+			NEXT_ARG();
+			if (strcmp(*argv, "block") == 0)
+				req.up.fwd = XFRM_USERPOLICY_BLOCK;
+			else if (strcmp(*argv, "accept") == 0)
+				req.up.fwd = XFRM_USERPOLICY_ACCEPT;
+			else
+				invarg("fwd policy value is invalid", *argv);
+		} else if (strcmp(*argv, "out") == 0) {
+			if (req.up.out)
+				duparg("out", *argv);
+
+			NEXT_ARG();
+			if (strcmp(*argv, "block") == 0)
+				req.up.out = XFRM_USERPOLICY_BLOCK;
+			else if (strcmp(*argv, "accept") == 0)
+				req.up.out = XFRM_USERPOLICY_ACCEPT;
+			else
+				invarg("out policy value is invalid", *argv);
+		} else {
+			invarg("unknown direction", *argv);
+		}
+
+		argc--; argv++;
+	}
+
+	if (rtnl_open_byproto(&rth, 0, NETLINK_XFRM) < 0)
+		exit(1);
+
+	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+		exit(2);
+
+	rtnl_close(&rth);
+
+	return 0;
+}
+
+int xfrm_policy_default_print(struct nlmsghdr *n, FILE *fp)
+{
+	struct xfrm_userpolicy_default *up = NLMSG_DATA(n);
+	int len = n->nlmsg_len - NLMSG_SPACE(sizeof(*up));
+
+	if (len < 0) {
+		fprintf(stderr,
+			"BUG: short nlmsg len %u (expect %lu) for XFRM_MSG_GETDEFAULT\n",
+			n->nlmsg_len, NLMSG_SPACE(sizeof(*up)));
+		return -1;
+	}
+
+	fprintf(fp, "Default policies:\n");
+	fprintf(fp, " in:  %s\n",
+		up->in == XFRM_USERPOLICY_BLOCK ? "block" : "accept");
+	fprintf(fp, " fwd: %s\n",
+		up->fwd == XFRM_USERPOLICY_BLOCK ? "block" : "accept");
+	fprintf(fp, " out: %s\n",
+		up->out == XFRM_USERPOLICY_BLOCK ? "block" : "accept");
+	fflush(fp);
+
+	return 0;
+}
+
+static int xfrm_spd_getdefault(int argc, char **argv)
+{
+	struct rtnl_handle rth;
+	struct {
+		struct nlmsghdr			n;
+		struct xfrm_userpolicy_default  up;
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct xfrm_userpolicy_default)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = XFRM_MSG_GETDEFAULT,
+	};
+	struct nlmsghdr *answer;
+
+	if (rtnl_open_byproto(&rth, 0, NETLINK_XFRM) < 0)
+		exit(1);
+
+	if (rtnl_talk(&rth, &req.n, &answer) < 0)
+		exit(2);
+
+	xfrm_policy_default_print(answer, (FILE *)stdout);
+
+	free(answer);
+	rtnl_close(&rth);
+
+	return 0;
+}
+
 static int xfrm_policy_flush(int argc, char **argv)
 {
 	struct rtnl_handle rth;
@@ -1197,6 +1314,10 @@ int do_xfrm_policy(int argc, char **argv)
 		return xfrm_spd_getinfo(argc, argv);
 	if (matches(*argv, "set") == 0)
 		return xfrm_spd_setinfo(argc-1, argv+1);
+	if (matches(*argv, "setdefault") == 0)
+		return xfrm_spd_setdefault(argc-1, argv+1);
+	if (matches(*argv, "getdefault") == 0)
+		return xfrm_spd_getdefault(argc-1, argv+1);
 	if (matches(*argv, "help") == 0)
 		usage();
 	fprintf(stderr, "Command \"%s\" is unknown, try \"ip xfrm policy help\".\n", *argv);
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index 003f6c3d1c28..bf725cabb82d 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -298,6 +298,18 @@ ip-xfrm \- transform configuration
 .RB "[ " hthresh6
 .IR LBITS " " RBITS " ]"
 
+.ti -8
+.B "ip xfrm policy setdefault"
+.IR DIR
+.IR ACTION " [ "
+.IR DIR
+.IR ACTION " ] [ "
+.IR DIR
+.IR ACTION " ]"
+
+.ti -8
+.B "ip xfrm policy getdefault"
+
 .ti -8
 .IR SELECTOR " :="
 .RB "[ " src
-- 
2.33.0

