Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E437DE0666
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfJVO3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:29:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34888 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727582AbfJVO3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:29:00 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 16:28:55 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MEStB6029215;
        Tue, 22 Oct 2019 17:28:55 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mleitner@redhat.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH iproute2-next] tc: implement support for action flags
Date:   Tue, 22 Oct 2019 17:28:33 +0300
Message-Id: <20191022142833.29070-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement setting and printing flags for actions that support this new
field (gact, csum, mirred, tunnel_key, vlan, ct). Update docs for
affected actions.

Example usage of fast init flag (only supported flag value at the
moment):

 # tc actions add action gact drop fast_init index 1
 # tc -s actions ls action gact
 total acts 1

        action order 0: gact action drop
         random type none pass val 0
         fast_init
         index 1 ref 1 bind 0 installed 7 sec used 7 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/pkt_cls.h              |  8 ++++++++
 include/uapi/linux/tc_act/tc_csum.h       |  1 +
 include/uapi/linux/tc_act/tc_ct.h         |  1 +
 include/uapi/linux/tc_act/tc_gact.h       |  1 +
 include/uapi/linux/tc_act/tc_mirred.h     |  1 +
 include/uapi/linux/tc_act/tc_tunnel_key.h |  1 +
 include/uapi/linux/tc_act/tc_vlan.h       |  1 +
 man/man8/tc-csum.8                        |  4 ++++
 man/man8/tc-mirred.8                      |  4 ++++
 man/man8/tc-tunnel_key.8                  |  4 ++++
 man/man8/tc-vlan.8                        |  7 ++++++-
 tc/m_csum.c                               | 17 ++++++++++++++++-
 tc/m_ct.c                                 | 19 ++++++++++++++++---
 tc/m_gact.c                               | 22 ++++++++++++++++++++--
 tc/m_mirred.c                             | 19 +++++++++++++++++--
 tc/m_tunnel_key.c                         | 17 +++++++++++++++--
 tc/m_vlan.c                               | 19 ++++++++++++++++---
 17 files changed, 132 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index a6aa466fac9e..56664854a5ab 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -113,6 +113,14 @@ enum tca_id {
 
 #define TCA_ID_MAX __TCA_ID_MAX
 
+/* act flags definitions */
+#define TCA_ACT_FLAGS_FAST_INIT	(1 << 0) /* prefer action update rate
+					  * (slow-path), even at the cost of
+					  * reduced software data-path
+					  * performance (intended to be used for
+					  * hardware-offloaded actions)
+					  */
+
 struct tc_police {
 	__u32			index;
 	int			action;
diff --git a/include/uapi/linux/tc_act/tc_csum.h b/include/uapi/linux/tc_act/tc_csum.h
index 94b2044929de..14eddaca85f8 100644
--- a/include/uapi/linux/tc_act/tc_csum.h
+++ b/include/uapi/linux/tc_act/tc_csum.h
@@ -10,6 +10,7 @@ enum {
 	TCA_CSUM_PARMS,
 	TCA_CSUM_TM,
 	TCA_CSUM_PAD,
+	TCA_CSUM_FLAGS,
 	__TCA_CSUM_MAX
 };
 #define TCA_CSUM_MAX (__TCA_CSUM_MAX - 1)
diff --git a/include/uapi/linux/tc_act/tc_ct.h b/include/uapi/linux/tc_act/tc_ct.h
index 5fb1d7ac1027..82ea92b59d3d 100644
--- a/include/uapi/linux/tc_act/tc_ct.h
+++ b/include/uapi/linux/tc_act/tc_ct.h
@@ -22,6 +22,7 @@ enum {
 	TCA_CT_NAT_PORT_MIN,	/* be16 */
 	TCA_CT_NAT_PORT_MAX,	/* be16 */
 	TCA_CT_PAD,
+	TCA_CT_FLAGS,
 	__TCA_CT_MAX
 };
 
diff --git a/include/uapi/linux/tc_act/tc_gact.h b/include/uapi/linux/tc_act/tc_gact.h
index 37e5392e02c7..b621b7df9919 100644
--- a/include/uapi/linux/tc_act/tc_gact.h
+++ b/include/uapi/linux/tc_act/tc_gact.h
@@ -26,6 +26,7 @@ enum {
 	TCA_GACT_PARMS,
 	TCA_GACT_PROB,
 	TCA_GACT_PAD,
+	TCA_GACT_FLAGS,
 	__TCA_GACT_MAX
 };
 #define TCA_GACT_MAX (__TCA_GACT_MAX - 1)
diff --git a/include/uapi/linux/tc_act/tc_mirred.h b/include/uapi/linux/tc_act/tc_mirred.h
index 2500a0005d05..322108890807 100644
--- a/include/uapi/linux/tc_act/tc_mirred.h
+++ b/include/uapi/linux/tc_act/tc_mirred.h
@@ -21,6 +21,7 @@ enum {
 	TCA_MIRRED_TM,
 	TCA_MIRRED_PARMS,
 	TCA_MIRRED_PAD,
+	TCA_MIRRED_FLAGS,
 	__TCA_MIRRED_MAX
 };
 #define TCA_MIRRED_MAX (__TCA_MIRRED_MAX - 1)
diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/linux/tc_act/tc_tunnel_key.h
index 41c8b462c177..f572101f6adc 100644
--- a/include/uapi/linux/tc_act/tc_tunnel_key.h
+++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
@@ -39,6 +39,7 @@ enum {
 					 */
 	TCA_TUNNEL_KEY_ENC_TOS,		/* u8 */
 	TCA_TUNNEL_KEY_ENC_TTL,		/* u8 */
+	TCA_TUNNEL_KEY_FLAGS,
 	__TCA_TUNNEL_KEY_MAX,
 };
 
diff --git a/include/uapi/linux/tc_act/tc_vlan.h b/include/uapi/linux/tc_act/tc_vlan.h
index 168995b54a70..b2847ed14f08 100644
--- a/include/uapi/linux/tc_act/tc_vlan.h
+++ b/include/uapi/linux/tc_act/tc_vlan.h
@@ -30,6 +30,7 @@ enum {
 	TCA_VLAN_PUSH_VLAN_PROTOCOL,
 	TCA_VLAN_PAD,
 	TCA_VLAN_PUSH_VLAN_PRIORITY,
+	TCA_VLAN_FLAGS,
 	__TCA_VLAN_MAX,
 };
 #define TCA_VLAN_MAX (__TCA_VLAN_MAX - 1)
diff --git a/man/man8/tc-csum.8 b/man/man8/tc-csum.8
index 65724b88d0b6..c93707948d80 100644
--- a/man/man8/tc-csum.8
+++ b/man/man8/tc-csum.8
@@ -6,6 +6,7 @@ csum - checksum update action
 .in +8
 .ti -8
 .BR tc " ... " "action csum"
+.RB "[ " fast_init " ] "
 .I UPDATE
 
 .ti -8
@@ -52,6 +53,9 @@ SCTP header
 .TP
 .B SWEETS
 These are merely syntactic sugar and ignored internally.
+.TP
+.B fast_init
+Prefer initialization speed over run time fast-path performance.
 .SH EXAMPLES
 The following performs stateless NAT for incoming packets from 192.0.2.100 to
 new destination 198.51.100.1. Assuming these are UDP
diff --git a/man/man8/tc-mirred.8 b/man/man8/tc-mirred.8
index 38833b452d92..0cd39f454347 100644
--- a/man/man8/tc-mirred.8
+++ b/man/man8/tc-mirred.8
@@ -7,6 +7,7 @@ mirred - mirror/redirect action
 .ti -8
 .BR tc " ... " "action mirred"
 .I DIRECTION ACTION
+.RB "[ " fast_init " ] "
 .RB "[ " index
 .IR INDEX " ] "
 .BI dev " DEVICENAME"
@@ -49,6 +50,9 @@ is a 32bit unsigned integer greater than zero.
 .TP
 .BI dev " DEVICENAME"
 Specify the network interface to redirect or mirror to.
+.TP
+.B fast_init
+Prefer initialization speed over run time fast-path performance.
 .SH EXAMPLES
 Limit ingress bandwidth on eth0 to 1mbit/s, redirect exceeding traffic to lo for
 debugging purposes:
diff --git a/man/man8/tc-tunnel_key.8 b/man/man8/tc-tunnel_key.8
index 2145eb62e70e..7b827ae0d257 100644
--- a/man/man8/tc-tunnel_key.8
+++ b/man/man8/tc-tunnel_key.8
@@ -7,6 +7,7 @@ tunnel_key - Tunnel metadata manipulation
 .ti -8
 .BR tc " ... " "action tunnel_key" " { " unset " | "
 .IR SET " }"
+.RB "[ " fast_init " ] "
 
 .ti -8
 .IR SET " := "
@@ -114,6 +115,9 @@ If using
 with IPv6, be sure you know what you are doing. Zero UDP checksums provide
 weaker protection against corrupted packets. See RFC6935 for details.
 .RE
+.TP
+.B fast_init
+Prefer initialization speed over run time fast-path performance.
 .SH EXAMPLES
 The following example encapsulates incoming ICMP packets on eth0 into a vxlan
 tunnel, by setting metadata to VNI 11, source IP 11.11.0.1 and destination IP
diff --git a/man/man8/tc-vlan.8 b/man/man8/tc-vlan.8
index f5ffc25f054e..e69322fefd70 100644
--- a/man/man8/tc-vlan.8
+++ b/man/man8/tc-vlan.8
@@ -6,7 +6,9 @@ vlan - vlan manipulation module
 .in +8
 .ti -8
 .BR tc " ... " "action vlan" " { " pop " |"
-.IR PUSH " | " MODIFY " } [ " CONTROL " ]"
+.IR PUSH " | " MODIFY " } [ "
+.BR fast_init " ] [ "
+.IR CONTROL " ]"
 
 .ti -8
 .IR PUSH " := "
@@ -94,6 +96,9 @@ Continue classification with next filter in line.
 Return to calling qdisc for packet processing. This ends the classification
 process.
 .RE
+.TP
+.B fast_init
+Prefer initialization speed over run time fast-path performance.
 .SH EXAMPLES
 The following example encapsulates incoming ICMP packets on eth0 from 10.0.0.2
 into VLAN ID 123:
diff --git a/tc/m_csum.c b/tc/m_csum.c
index 3e3dc251ea38..64cc5a96ff5c 100644
--- a/tc/m_csum.c
+++ b/tc/m_csum.c
@@ -22,7 +22,7 @@
 static void
 explain(void)
 {
-	fprintf(stderr, "Usage: ... csum <UPDATE>\n"
+	fprintf(stderr, "Usage: ... csum [fast_init] <UPDATE>\n"
 			"Where: UPDATE := <TARGET> [<UPDATE>]\n"
 			"       TARGET := { ip4h | icmp | igmp | tcp | udp | udplite | sctp | <SWEETS> }\n"
 			"       SWEETS := { and | or | \'+\' }\n");
@@ -88,6 +88,7 @@ static int
 parse_csum(struct action_util *a, int *argc_p,
 	   char ***argv_p, int tca_id, struct nlmsghdr *n)
 {
+	struct nla_bitfield32 flags = { 0 };
 	struct tc_csum sel = {};
 
 	int argc = *argc_p;
@@ -106,6 +107,11 @@ parse_csum(struct action_util *a, int *argc_p,
 			}
 			ok++;
 			continue;
+		} else if (matches(*argv, "fast_init") == 0) {
+			flags.value |= TCA_ACT_FLAGS_FAST_INIT;
+			flags.selector |= TCA_ACT_FLAGS_FAST_INIT;
+			NEXT_ARG_FWD();
+			continue;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else {
@@ -140,6 +146,8 @@ parse_csum(struct action_util *a, int *argc_p,
 
 	tail = addattr_nest(n, MAX_MSG, tca_id);
 	addattr_l(n, MAX_MSG, TCA_CSUM_PARMS, &sel, sizeof(sel));
+	addattr_l(n, MAX_MSG, TCA_CSUM_FLAGS, &flags,
+		  sizeof(struct nla_bitfield32));
 	addattr_nest_end(n, tail);
 
 	*argc_p = argc;
@@ -206,6 +214,13 @@ print_csum(struct action_util *au, FILE *f, struct rtattr *arg)
 	print_string(PRINT_ANY, "csum", "(%s) ", buf);
 
 	print_action_control(f, "action ", sel->action, "\n");
+	if (tb[TCA_CSUM_FLAGS]) {
+		struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_CSUM_FLAGS]);
+
+		if (flags->selector & TCA_ACT_FLAGS_FAST_INIT)
+			print_bool(PRINT_ANY, "fast_init", "\n\t fast_init",
+				   flags->value & TCA_ACT_FLAGS_FAST_INIT);
+	}
 	print_uint(PRINT_ANY, "index", "\tindex %u", sel->index);
 	print_int(PRINT_ANY, "ref", " ref %d", sel->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", sel->bindcnt);
diff --git a/tc/m_ct.c b/tc/m_ct.c
index 8589cb9a3c51..02947e5075c8 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -19,9 +19,9 @@ static void
 usage(void)
 {
 	fprintf(stderr,
-		"Usage: ct clear\n"
-		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"
-		"	ct [nat] [zone ZONE]\n"
+		"Usage: ct clear [fast_init]\n"
+		"	ct commit [fast_init] [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"
+		"	ct [fast_init] [nat] [zone ZONE]\n"
 		"Where: ZONE is the conntrack zone table number\n"
 		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
 		"\n");
@@ -200,6 +200,7 @@ static int
 parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 		struct nlmsghdr *n)
 {
+	struct nla_bitfield32 flags = { 0 };
 	struct tc_ct sel = {};
 	char **argv = *argv_p;
 	struct rtattr *tail;
@@ -281,6 +282,9 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 				fprintf(stderr, "ct: Illegal \"label\"\n");
 				return -1;
 			}
+		} else if (matches(*argv, "fast_init") == 0) {
+			flags.value |= TCA_ACT_FLAGS_FAST_INIT;
+			flags.selector |= TCA_ACT_FLAGS_FAST_INIT;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else {
@@ -320,6 +324,8 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 
 	addattr16(n, MAX_MSG, TCA_CT_ACTION, ct_action);
 	addattr_l(n, MAX_MSG, TCA_CT_PARMS, &sel, sizeof(sel));
+	addattr_l(n, MAX_MSG, TCA_CT_FLAGS, &flags,
+		  sizeof(struct nla_bitfield32));
 	addattr_nest_end(n, tail);
 
 	*argc_p = argc;
@@ -473,6 +479,13 @@ static int print_ct(struct action_util *au, FILE *f, struct rtattr *arg)
 	ct_print_nat(ct_action, tb);
 
 	print_action_control(f, " ", p->action, "");
+	if (tb[TCA_CT_FLAGS]) {
+		struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_CT_FLAGS]);
+
+		if (flags->selector & TCA_ACT_FLAGS_FAST_INIT)
+			print_bool(PRINT_ANY, "fast_init", "\n\t fast_init",
+				   flags->value & TCA_ACT_FLAGS_FAST_INIT);
+	}
 
 	print_uint(PRINT_ANY, "index", "\n\t index %u", p->index);
 	print_int(PRINT_ANY, "ref", " ref %d", p->refcnt);
diff --git a/tc/m_gact.c b/tc/m_gact.c
index dca2a2f9692f..ce5f22b59da0 100644
--- a/tc/m_gact.c
+++ b/tc/m_gact.c
@@ -42,7 +42,7 @@ static void
 explain(void)
 {
 #ifdef CONFIG_GACT_PROB
-	fprintf(stderr, "Usage: ... gact <ACTION> [RAND] [INDEX]\n");
+	fprintf(stderr, "Usage: ... gact <ACTION> [RAND] [fast_init] [INDEX]\n");
 	fprintf(stderr,
 		"Where: \tACTION := reclassify | drop | continue | pass | pipe |\n"
 		"       \t          goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>\n"
@@ -53,7 +53,7 @@ explain(void)
 			"\tINDEX := index value used\n"
 			"\n");
 #else
-	fprintf(stderr, "Usage: ... gact <ACTION> [INDEX]\n"
+	fprintf(stderr, "Usage: ... gact <ACTION> [fast_init] [INDEX]\n"
 		"Where: \tACTION := reclassify | drop | continue | pass | pipe |\n"
 		"       \t          goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>\n"
 		"\tINDEX := index value used\n"
@@ -74,6 +74,7 @@ static int
 parse_gact(struct action_util *a, int *argc_p, char ***argv_p,
 	   int tca_id, struct nlmsghdr *n)
 {
+	struct nla_bitfield32 flags = { 0 };
 	int argc = *argc_p;
 	char **argv = *argv_p;
 	struct tc_gact p = { 0 };
@@ -133,6 +134,12 @@ parse_gact(struct action_util *a, int *argc_p, char ***argv_p,
 	}
 #endif
 
+	if (argc > 0 && matches(*argv, "fast_init") == 0) {
+		flags.value |= TCA_ACT_FLAGS_FAST_INIT;
+		flags.selector |= TCA_ACT_FLAGS_FAST_INIT;
+		NEXT_ARG_FWD();
+	}
+
 	if (argc > 0) {
 		if (matches(*argv, "index") == 0) {
 skip_args:
@@ -154,6 +161,9 @@ skip_args:
 	if (rd)
 		addattr_l(n, MAX_MSG, TCA_GACT_PROB, &pp, sizeof(pp));
 #endif
+	addattr_l(n, MAX_MSG, TCA_GACT_FLAGS, &flags,
+		  sizeof(struct nla_bitfield32));
+
 	addattr_nest_end(n, tail);
 
 	*argc_p = argc;
@@ -199,6 +209,14 @@ print_gact(struct action_util *au, FILE *f, struct rtattr *arg)
 	print_int(PRINT_ANY, "val", "val %d", pp->pval);
 	close_json_object();
 #endif
+	if (tb[TCA_GACT_FLAGS]) {
+		struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_GACT_FLAGS]);
+
+		if (flags->selector & TCA_ACT_FLAGS_FAST_INIT)
+			print_bool(PRINT_ANY, "fast_init", "\n\t fast_init",
+				   flags->value & TCA_ACT_FLAGS_FAST_INIT);
+	}
+
 	print_uint(PRINT_ANY, "index", "\n\t index %u", p->index);
 	print_int(PRINT_ANY, "ref", " ref %d", p->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", p->bindcnt);
diff --git a/tc/m_mirred.c b/tc/m_mirred.c
index 132095237929..b95f4611891e 100644
--- a/tc/m_mirred.c
+++ b/tc/m_mirred.c
@@ -29,7 +29,7 @@ static void
 explain(void)
 {
 	fprintf(stderr,
-		"Usage: mirred <DIRECTION> <ACTION> [index INDEX] <dev DEVICENAME>\n"
+		"Usage: mirred <DIRECTION> <ACTION> [fast_init] [index INDEX] <dev DEVICENAME>\n"
 		"where:\n"
 		"\tDIRECTION := <ingress | egress>\n"
 		"\tACTION := <mirror | redirect>\n"
@@ -92,7 +92,7 @@ static int
 parse_direction(struct action_util *a, int *argc_p, char ***argv_p,
 		int tca_id, struct nlmsghdr *n)
 {
-
+	struct nla_bitfield32 flags = { 0 };
 	int argc = *argc_p;
 	char **argv = *argv_p;
 	int ok = 0, iok = 0, mirror = 0, redir = 0, ingress = 0, egress = 0;
@@ -125,6 +125,11 @@ parse_direction(struct action_util *a, int *argc_p, char ***argv_p,
 			NEXT_ARG();
 			ok++;
 			continue;
+		} else if (matches(*argv, "fast_init") == 0) {
+			flags.value |= TCA_ACT_FLAGS_FAST_INIT;
+			flags.selector |= TCA_ACT_FLAGS_FAST_INIT;
+			NEXT_ARG_FWD();
+			continue;
 		} else {
 
 			if (matches(*argv, "index") == 0) {
@@ -225,6 +230,8 @@ parse_direction(struct action_util *a, int *argc_p, char ***argv_p,
 
 	tail = addattr_nest(n, MAX_MSG, tca_id);
 	addattr_l(n, MAX_MSG, TCA_MIRRED_PARMS, &p, sizeof(p));
+	addattr_l(n, MAX_MSG, TCA_MIRRED_FLAGS, &flags,
+		  sizeof(struct nla_bitfield32));
 	addattr_nest_end(n, tail);
 
 	*argc_p = argc;
@@ -307,6 +314,14 @@ print_mirred(struct action_util *au, FILE *f, struct rtattr *arg)
 	print_string(PRINT_ANY, "to_dev", " to device %s)", dev);
 	print_action_control(f, " ", p->action, "");
 
+	if (tb[TCA_MIRRED_FLAGS]) {
+		struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_MIRRED_FLAGS]);
+
+		if (flags->selector & TCA_ACT_FLAGS_FAST_INIT)
+			print_bool(PRINT_ANY, "fast_init", "\n\t fast_init",
+				   flags->value & TCA_ACT_FLAGS_FAST_INIT);
+	}
+
 	print_uint(PRINT_ANY, "index", "\n \tindex %u", p->index);
 	print_int(PRINT_ANY, "ref", " ref %d", p->refcnt);
 	print_int(PRINT_ANY, "bind", " bind %d", p->bindcnt);
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index 4e65e444776a..e8b96f8c008f 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -22,8 +22,8 @@
 static void explain(void)
 {
 	fprintf(stderr,
-		"Usage: tunnel_key unset\n"
-		"       tunnel_key set <TUNNEL_KEY>\n"
+		"Usage: tunnel_key [fast_init] unset\n"
+		"       tunnel_key [fast_init] set <TUNNEL_KEY>\n"
 		"Where TUNNEL_KEY is a combination of:\n"
 		"id <TUNNELID>\n"
 		"src_ip <IP> (mandatory)\n"
@@ -209,6 +209,7 @@ static int tunnel_key_parse_tos_ttl(char *str, int type, struct nlmsghdr *n)
 static int parse_tunnel_key(struct action_util *a, int *argc_p, char ***argv_p,
 			    int tca_id, struct nlmsghdr *n)
 {
+	struct nla_bitfield32 flags = { 0 };
 	struct tc_tunnel_key parm = {};
 	char **argv = *argv_p;
 	int argc = *argc_p;
@@ -309,6 +310,9 @@ static int parse_tunnel_key(struct action_util *a, int *argc_p, char ***argv_p,
 			csum = 0;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
+		} else if (matches(*argv, "fast_init") == 0) {
+			flags.value |= TCA_ACT_FLAGS_FAST_INIT;
+			flags.selector |= TCA_ACT_FLAGS_FAST_INIT;
 		} else {
 			break;
 		}
@@ -341,6 +345,8 @@ static int parse_tunnel_key(struct action_util *a, int *argc_p, char ***argv_p,
 
 	parm.t_action = action;
 	addattr_l(n, MAX_MSG, TCA_TUNNEL_KEY_PARMS, &parm, sizeof(parm));
+	addattr_l(n, MAX_MSG, TCA_TUNNEL_KEY_FLAGS, &flags,
+		  sizeof(struct nla_bitfield32));
 	addattr_nest_end(n, tail);
 
 	*argc_p = argc;
@@ -529,6 +535,13 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
 		break;
 	}
 	print_action_control(f, " ", parm->action, "");
+	if (tb[TCA_TUNNEL_KEY_FLAGS]) {
+		struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_TUNNEL_KEY_FLAGS]);
+
+		if (flags->selector & TCA_ACT_FLAGS_FAST_INIT)
+			print_bool(PRINT_ANY, "fast_init", "\n\t fast_init",
+				   flags->value & TCA_ACT_FLAGS_FAST_INIT);
+	}
 
 	print_string(PRINT_FP, NULL, "%s", _SL_);
 	print_uint(PRINT_ANY, "index", "\t index %u", parm->index);
diff --git a/tc/m_vlan.c b/tc/m_vlan.c
index 9c8071e9dbbe..c54829ce297f 100644
--- a/tc/m_vlan.c
+++ b/tc/m_vlan.c
@@ -28,9 +28,9 @@ static const char * const action_names[] = {
 static void explain(void)
 {
 	fprintf(stderr,
-		"Usage: vlan pop\n"
-		"       vlan push [ protocol VLANPROTO ] id VLANID [ priority VLANPRIO ] [CONTROL]\n"
-		"       vlan modify [ protocol VLANPROTO ] id VLANID [ priority VLANPRIO ] [CONTROL]\n"
+		"Usage: vlan pop [fast_init]\n"
+		"       vlan push [fast_init] [ protocol VLANPROTO ] id VLANID [ priority VLANPRIO ] [CONTROL]\n"
+		"       vlan modify [fast_init] [ protocol VLANPROTO ] id VLANID [ priority VLANPRIO ] [CONTROL]\n"
 		"       VLANPROTO is one of 802.1Q or 802.1AD\n"
 		"            with default: 802.1Q\n"
 		"       CONTROL := reclassify | pipe | drop | continue | pass |\n"
@@ -59,6 +59,7 @@ static void unexpected(const char *arg)
 static int parse_vlan(struct action_util *a, int *argc_p, char ***argv_p,
 		      int tca_id, struct nlmsghdr *n)
 {
+	struct nla_bitfield32 flags = { 0 };
 	int argc = *argc_p;
 	char **argv = *argv_p;
 	struct rtattr *tail;
@@ -119,6 +120,9 @@ static int parse_vlan(struct action_util *a, int *argc_p, char ***argv_p,
 			if (get_u8(&prio, *argv, 0) || (prio & ~0x7))
 				invarg("prio is invalid", *argv);
 			prio_set = 1;
+		} else if (matches(*argv, "fast_init") == 0) {
+			flags.value |= TCA_ACT_FLAGS_FAST_INIT;
+			flags.selector |= TCA_ACT_FLAGS_FAST_INIT;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else {
@@ -167,6 +171,8 @@ static int parse_vlan(struct action_util *a, int *argc_p, char ***argv_p,
 	}
 	if (prio_set)
 		addattr8(n, MAX_MSG, TCA_VLAN_PUSH_VLAN_PRIORITY, prio);
+	addattr_l(n, MAX_MSG, TCA_VLAN_FLAGS, &flags,
+		  sizeof(struct nla_bitfield32));
 
 	addattr_nest_end(n, tail);
 
@@ -218,6 +224,13 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 		break;
 	}
 	print_action_control(f, " ", parm->action, "");
+	if (tb[TCA_VLAN_FLAGS]) {
+		struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_VLAN_FLAGS]);
+
+		if (flags->selector & TCA_ACT_FLAGS_FAST_INIT)
+			print_bool(PRINT_ANY, "fast_init", "\n\t fast_init",
+				   flags->value & TCA_ACT_FLAGS_FAST_INIT);
+	}
 
 	print_uint(PRINT_ANY, "index", "\n\t index %u", parm->index);
 	print_int(PRINT_ANY, "ref", " ref %d", parm->refcnt);
-- 
2.21.0

