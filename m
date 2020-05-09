Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046121CC2E2
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgEIQwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:52:53 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:38788 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbgEIQwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 12:52:53 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 29D672E0DF2;
        Sat,  9 May 2020 19:52:49 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id MD8WDsPY7T-qlXqssvI;
        Sat, 09 May 2020 19:52:49 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1589043169; bh=eY9ApoVEM+jffkVAX35mJ0Fa3hnBUudjCCNzhbqxNJA=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=luADOpYZbYLZcwfHbDI2pLY98TFP7659u6awPXe7YDRlHvjO/RRiKmgoSyiZap/kW
         hWvWpeNcSksDo8NydqtquPhfzOGknHzkoW04g/K1yBZZW9VqXxVrLbcgK5Zx5rH8pY
         NSjKtb43YqJUkmV0Izpic0D9hyJSeyRZxMsnXZ6U=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.191.33-vpn.dhcp.yndx.net (178.154.191.33-vpn.dhcp.yndx.net [178.154.191.33])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id lkcxSGO050-qlXa0QV4;
        Sat, 09 May 2020 19:52:47 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     netdev@vger.kernel.org, dsahern@gmail.com
Cc:     cgroups@vger.kernel.org
Subject: [PATCH iproute2-next v2 2/3] ss: add support for cgroup v2 information and filtering
Date:   Sat,  9 May 2020 19:52:01 +0300
Message-Id: <20200509165202.17959-2-zeil@yandex-team.ru>
In-Reply-To: <20200509165202.17959-1-zeil@yandex-team.ru>
References: <20200509165202.17959-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces two new features: obtaining cgroup information and
filtering sockets by cgroups. These features work based on cgroup v2 ID
field in the socket (kernel should be compiled with CONFIG_SOCK_CGROUP_DATA).

Cgroup information can be obtained by specifying --cgroup flag and now contains
only pathname. For faster pathname lookups cgroup cache is implemented. This
cache is filled on ss startup and missed entries are resolved and saved
on the fly.

Cgroup filter extends EXPRESSION and allows to specify cgroup pathname
(relative or absolute) to obtain sockets attached only to this cgroup.
Filter syntax: ss [ cgroup PATHNAME ]
Examples:
    ss -a cgroup /sys/fs/cgroup/unified (or ss -a cgroup .)
    ss -a cgroup /sys/fs/cgroup/unified/cgroup1 (or ss -a cgroup cgroup1)

v2:
  - style fixes (David Ahern)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 include/uapi/linux/inet_diag.h |  2 ++
 man/man8/ss.8                  |  9 +++++++
 misc/ss.c                      | 61 ++++++++++++++++++++++++++++++++++++++++++
 misc/ssfilter.h                |  2 ++
 misc/ssfilter.y                | 22 ++++++++++++++-
 5 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index 0c1c781..f009abf 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -96,6 +96,7 @@ enum {
 	INET_DIAG_BC_MARK_COND,
 	INET_DIAG_BC_S_EQ,
 	INET_DIAG_BC_D_EQ,
+	INET_DIAG_BC_CGROUP_COND,   /* u64 cgroup v2 ID */
 };
 
 struct inet_diag_hostcond {
@@ -157,6 +158,7 @@ enum {
 	INET_DIAG_MD5SIG,
 	INET_DIAG_ULP_INFO,
 	INET_DIAG_SK_BPF_STORAGES,
+	INET_DIAG_CGROUP_ID,
 	__INET_DIAG_MAX,
 };
 
diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 023d771..894cb20 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -281,6 +281,15 @@ Class id set by net_cls cgroup. If class is zero this shows priority
 set by SO_PRIORITY.
 .RE
 .TP
+.B \-\-cgroup
+Show cgroup information. Below fields may appear:
+.RS
+.P
+.TP
+.B cgroup
+Cgroup v2 pathname. This pathname is relative to the mount point of the hierarchy.
+.RE
+.TP
 .B \-K, \-\-kill
 Attempts to forcibly close sockets. This option displays sockets that are
 successfully closed and silently skips sockets that the kernel does not support
diff --git a/misc/ss.c b/misc/ss.c
index 75fde23..b9e6b15 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -36,6 +36,7 @@
 #include "namespace.h"
 #include "SNAPSHOT.h"
 #include "rt_names.h"
+#include "cg_map.h"
 
 #include <linux/tcp.h>
 #include <linux/sock_diag.h>
@@ -122,6 +123,7 @@ static int follow_events;
 static int sctp_ino;
 static int show_tipcinfo;
 static int show_tos;
+static int show_cgroup;
 int oneline;
 
 enum col_id {
@@ -797,6 +799,7 @@ struct sockstat {
 	char *name;
 	char *peer_name;
 	__u32		    mark;
+	__u64		    cgroup_id;
 };
 
 struct dctcpstat {
@@ -1417,6 +1420,9 @@ static void sock_details_print(struct sockstat *s)
 
 	if (s->mark)
 		out(" fwmark:0x%x", s->mark);
+
+	if (s->cgroup_id)
+		out(" cgroup:%s", cg_id_to_path(s->cgroup_id));
 }
 
 static void sock_addr_print(const char *addr, char *delim, const char *port,
@@ -1643,6 +1649,7 @@ struct aafilter {
 	unsigned int	iface;
 	__u32		mark;
 	__u32		mask;
+	__u64		cgroup_id;
 	struct aafilter *next;
 };
 
@@ -1771,6 +1778,12 @@ static int run_ssfilter(struct ssfilter *f, struct sockstat *s)
 
 		return (s->mark & a->mask) == a->mark;
 	}
+		case SSF_CGROUPCOND:
+	{
+		struct aafilter *a = (void *)f->pred;
+
+		return s->cgroup_id == a->cgroup_id;
+	}
 		/* Yup. It is recursion. Sorry. */
 		case SSF_AND:
 		return run_ssfilter(f->pred, s) && run_ssfilter(f->post, s);
@@ -1963,6 +1976,23 @@ static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 
 		return inslen;
 	}
+		case SSF_CGROUPCOND:
+	{
+		struct aafilter *a = (void *)f->pred;
+		struct instr {
+			struct inet_diag_bc_op op;
+			__u64 cgroup_id;
+		} __attribute__((packed));
+		int inslen = sizeof(struct instr);
+
+		if (!(*bytecode = malloc(inslen))) abort();
+		((struct instr *)*bytecode)[0] = (struct instr) {
+			{ INET_DIAG_BC_CGROUP_COND, inslen, inslen + 4 },
+			a->cgroup_id,
+		};
+
+		return inslen;
+	}
 		default:
 		abort();
 	}
@@ -2300,6 +2330,22 @@ void *parse_markmask(const char *markmask)
 	return res;
 }
 
+void *parse_cgroupcond(const char *path)
+{
+	struct aafilter *res;
+	__u64 id;
+
+	id = get_cgroup2_id(path);
+	if (!id)
+		return NULL;
+
+	res = malloc(sizeof(*res));
+	if (res)
+		res->cgroup_id = id;
+
+	return res;
+}
+
 static void proc_ctx_print(struct sockstat *s)
 {
 	char *buf;
@@ -3104,6 +3150,9 @@ static void parse_diag_msg(struct nlmsghdr *nlh, struct sockstat *s)
 	s->mark = 0;
 	if (tb[INET_DIAG_MARK])
 		s->mark = rta_getattr_u32(tb[INET_DIAG_MARK]);
+	s->cgroup_id = 0;
+	if (tb[INET_DIAG_CGROUP_ID])
+		s->cgroup_id = rta_getattr_u64(tb[INET_DIAG_CGROUP_ID]);
 	if (tb[INET_DIAG_PROTOCOL])
 		s->raw_prot = rta_getattr_u8(tb[INET_DIAG_PROTOCOL]);
 	else
@@ -3171,6 +3220,11 @@ static int inet_show_sock(struct nlmsghdr *nlh,
 			out(" class_id:%#x", rta_getattr_u32(tb[INET_DIAG_CLASS_ID]));
 	}
 
+	if (show_cgroup) {
+		if (tb[INET_DIAG_CGROUP_ID])
+			out(" cgroup:%s", cg_id_to_path(rta_getattr_u64(tb[INET_DIAG_CGROUP_ID])));
+	}
+
 	if (show_mem || (show_tcpinfo && s->type != IPPROTO_UDP)) {
 		if (!oneline)
 			out("\n\t");
@@ -4996,6 +5050,7 @@ static void _usage(FILE *dest)
 "       --tipcinfo      show internal tipc socket information\n"
 "   -s, --summary       show socket usage summary\n"
 "       --tos           show tos and priority information\n"
+"       --cgroup        show cgroup information\n"
 "   -b, --bpf           show bpf filter socket information\n"
 "   -E, --events        continually display sockets as they are destroyed\n"
 "   -Z, --context       display process SELinux security contexts\n"
@@ -5106,6 +5161,8 @@ static int scan_state(const char *state)
 /* Values of 'x' are already used so a non-character is used */
 #define OPT_XDPSOCK 260
 
+#define OPT_CGROUP 261
+
 static const struct option long_opts[] = {
 	{ "numeric", 0, 0, 'n' },
 	{ "resolve", 0, 0, 'r' },
@@ -5142,6 +5199,7 @@ static const struct option long_opts[] = {
 	{ "net", 1, 0, 'N' },
 	{ "tipcinfo", 0, 0, OPT_TIPCINFO},
 	{ "tos", 0, 0, OPT_TOS },
+	{ "cgroup", 0, 0, OPT_CGROUP },
 	{ "kill", 0, 0, 'K' },
 	{ "no-header", 0, 0, 'H' },
 	{ "xdp", 0, 0, OPT_XDPSOCK},
@@ -5329,6 +5387,9 @@ int main(int argc, char *argv[])
 		case OPT_TOS:
 			show_tos = 1;
 			break;
+		case OPT_CGROUP:
+			show_cgroup = 1;
+			break;
 		case 'K':
 			current_filter.kill = 1;
 			break;
diff --git a/misc/ssfilter.h b/misc/ssfilter.h
index f5b0bc8..d85c084 100644
--- a/misc/ssfilter.h
+++ b/misc/ssfilter.h
@@ -11,6 +11,7 @@
 #define SSF_S_AUTO  9
 #define SSF_DEVCOND 10
 #define SSF_MARKMASK 11
+#define SSF_CGROUPCOND 12
 
 #include <stdbool.h>
 
@@ -25,3 +26,4 @@ int ssfilter_parse(struct ssfilter **f, int argc, char **argv, FILE *fp);
 void *parse_hostcond(char *addr, bool is_port);
 void *parse_devcond(char *name);
 void *parse_markmask(const char *markmask);
+void *parse_cgroupcond(const char *path);
diff --git a/misc/ssfilter.y b/misc/ssfilter.y
index a901ae7..b417579 100644
--- a/misc/ssfilter.y
+++ b/misc/ssfilter.y
@@ -36,7 +36,7 @@ static void yyerror(char *s)
 
 %}
 
-%token HOSTCOND DCOND SCOND DPORT SPORT LEQ GEQ NEQ AUTOBOUND DEVCOND DEVNAME MARKMASK FWMARK
+%token HOSTCOND DCOND SCOND DPORT SPORT LEQ GEQ NEQ AUTOBOUND DEVCOND DEVNAME MARKMASK FWMARK CGROUPCOND CGROUPPATH
 %left '|'
 %left '&'
 %nonassoc '!'
@@ -156,6 +156,14 @@ expr:	'(' exprlist ')'
         {
                 $$ = alloc_node(SSF_NOT, alloc_node(SSF_MARKMASK, $3));
         }
+        | CGROUPPATH eq CGROUPCOND
+        {
+                $$ = alloc_node(SSF_CGROUPCOND, $3);
+        }
+        | CGROUPPATH NEQ CGROUPCOND
+        {
+                $$ = alloc_node(SSF_NOT, alloc_node(SSF_CGROUPCOND, $3));
+        }
         | AUTOBOUND
         {
                 $$ = alloc_node(SSF_S_AUTO, NULL);
@@ -276,6 +284,10 @@ int yylex(void)
 		tok_type = FWMARK;
 		return FWMARK;
 	}
+	if (strcmp(curtok, "cgroup") == 0) {
+		tok_type = CGROUPPATH;
+		return CGROUPPATH;
+	}
 	if (strcmp(curtok, ">=") == 0 ||
 	    strcmp(curtok, "ge") == 0 ||
 	    strcmp(curtok, "geq") == 0)
@@ -318,6 +330,14 @@ int yylex(void)
 		}
 		return MARKMASK;
 	}
+	if (tok_type == CGROUPPATH) {
+		yylval = (void*)parse_cgroupcond(curtok);
+		if (yylval == NULL) {
+			fprintf(stderr, "Cannot parse cgroup %s.\n", curtok);
+			exit(1);
+		}
+		return CGROUPCOND;
+	}
 	yylval = (void*)parse_hostcond(curtok, tok_type == SPORT || tok_type == DPORT);
 	if (yylval == NULL) {
 		fprintf(stderr, "Cannot parse dst/src address.\n");
-- 
2.7.4

