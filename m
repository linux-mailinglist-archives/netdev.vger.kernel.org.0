Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E4149583
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfFQW6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:58:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbfFQW6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:49 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 04/33] mptcp: Handle MPTCP TCP options
Date:   Mon, 17 Jun 2019 15:57:39 -0700
Message-Id: <20190617225808.665-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Currently only MPTCP v0 is supported so ignore v1 MP_CAPABLE option.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 include/linux/tcp.h   |  15 +++++
 include/net/mptcp.h   |  20 ++++++
 net/ipv4/tcp_input.c  |   5 ++
 net/ipv4/tcp_output.c |  15 +++++
 net/mptcp/Makefile    |   2 +-
 net/mptcp/options.c   | 146 ++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.c  |   4 +-
 net/mptcp/protocol.h  |  22 +++++++
 8 files changed, 226 insertions(+), 3 deletions(-)
 create mode 100644 net/mptcp/options.c

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index c23019a3b264..73c633f58233 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -100,6 +100,17 @@ struct tcp_options_received {
 	u8	num_sacks;	/* Number of SACK blocks		*/
 	u16	user_mss;	/* mss requested by user in ioctl	*/
 	u16	mss_clamp;	/* Maximal mss, negotiated at connection setup */
+#if IS_ENABLED(CONFIG_MPTCP)
+	struct mptcp_options_received {
+		u8      mp_capable : 1,
+			mp_join : 1,
+			dss : 1,
+			version : 4;
+		u8      flags;
+		u64     sndr_key;
+		u64     rcvr_key;
+	} mptcp;
+#endif
 };
 
 static inline void tcp_clear_options(struct tcp_options_received *rx_opt)
@@ -109,6 +120,10 @@ static inline void tcp_clear_options(struct tcp_options_received *rx_opt)
 #if IS_ENABLED(CONFIG_SMC)
 	rx_opt->smc_ok = 0;
 #endif
+#if IS_ENABLED(CONFIG_MPTCP)
+	rx_opt->mptcp.mp_capable = rx_opt->mptcp.mp_join = 0;
+	rx_opt->mptcp.dss = 0;
+#endif
 }
 
 /* This is the max number of SACKS that we'll generate and process. It's safe
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 0fe78fddc638..0d3e02c6c817 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -8,15 +8,35 @@
 #ifndef __NET_MPTCP_H
 #define __NET_MPTCP_H
 
+/* MPTCP option subtypes */
+#define OPTION_MPTCP_MPC_SYN	BIT(0)
+#define OPTION_MPTCP_MPC_SYNACK	BIT(1)
+#define OPTION_MPTCP_MPC_ACK	BIT(2)
+
+struct mptcp_out_options {
+	u16 suboptions;
+	u64 sndr_key;
+	u64 rcvr_key;
+};
+
 #ifdef CONFIG_MPTCP
 
 void mptcp_init(void);
 
+void mptcp_parse_option(const unsigned char *ptr, int opsize,
+			struct tcp_options_received *opt_rx);
+void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts);
+
 #else
 
 static inline void mptcp_init(void)
 {
 }
 
+static inline void mptcp_parse_option(const unsigned char *ptr, int opsize,
+				      struct tcp_options_received *opt_rx)
+{
+}
+
 #endif /* CONFIG_MPTCP */
 #endif /* __NET_MPTCP_H */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9269bbfc05f9..117f0efbbad5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -79,6 +79,7 @@
 #include <trace/events/tcp.h>
 #include <linux/jump_label_ratelimit.h>
 #include <net/busy_poll.h>
+#include <net/mptcp.h>
 
 int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 
@@ -3857,6 +3858,10 @@ void tcp_parse_options(const struct net *net,
 				 */
 				break;
 #endif
+			case TCPOPT_MPTCP:
+				mptcp_parse_option(ptr, opsize, opt_rx);
+				break;
+
 			case TCPOPT_FASTOPEN:
 				tcp_parse_fastopen_option(
 					opsize - TCPOLEN_FASTOPEN_BASE,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index d954ff9069e8..69c4f39efe8b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -38,6 +38,7 @@
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <net/tcp.h>
+#include <net/mptcp.h>
 
 #include <linux/compiler.h>
 #include <linux/gfp.h>
@@ -411,6 +412,7 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 #define OPTION_WSCALE		(1 << 3)
 #define OPTION_FAST_OPEN_COOKIE	(1 << 8)
 #define OPTION_SMC		(1 << 9)
+#define OPTION_MPTCP		(1 << 10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
 {
@@ -436,8 +438,19 @@ struct tcp_out_options {
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
+#if IS_ENABLED(CONFIG_MPTCP)
+	struct mptcp_out_options mptcp;
+#endif
 };
 
+static void mptcp_options_write(__be32 *ptr, struct tcp_out_options *opts)
+{
+#if IS_ENABLED(CONFIG_MPTCP)
+	if (unlikely(OPTION_MPTCP & opts->options))
+		mptcp_write_options(ptr, &opts->mptcp);
+#endif
+}
+
 /* Write previously computed TCP options to the packet.
  *
  * Beware: Something in the Internet is very sensitive to the ordering of
@@ -546,6 +559,8 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 	}
 
 	smc_options_write(ptr, &options);
+
+	mptcp_options_write(ptr, opts);
 }
 
 static void smc_set_option(const struct tcp_sock *tp,
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index 659129d1fcbf..27a846263f08 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MPTCP) += mptcp.o
 
-mptcp-y := protocol.o
+mptcp-y := protocol.o options.o
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
new file mode 100644
index 000000000000..42626cd0a9f7
--- /dev/null
+++ b/net/mptcp/options.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP
+ *
+ * Copyright (c) 2017 - 2019, Intel Corporation.
+ */
+
+#include <linux/kernel.h>
+#include <net/tcp.h>
+#include <net/mptcp.h>
+#include "protocol.h"
+
+void mptcp_parse_option(const unsigned char *ptr, int opsize,
+			struct tcp_options_received *opt_rx)
+{
+	struct mptcp_options_received *mp_opt = &opt_rx->mptcp;
+	u8 subtype = *ptr >> 4;
+
+	switch (subtype) {
+	/* MPTCPOPT_MP_CAPABLE
+	 * 0: 4MSB=subtype, 4LSB=version
+	 * 1: Handshake flags
+	 * 2-9: Sender key
+	 * 10-17: Receiver key (optional)
+	 */
+	case MPTCPOPT_MP_CAPABLE:
+		if (opsize != TCPOLEN_MPTCP_MPC_SYN &&
+		    opsize != TCPOLEN_MPTCP_MPC_SYNACK)
+			break;
+
+		mp_opt->version = *ptr++ & MPTCP_VERSION_MASK;
+		if (mp_opt->version != 0)
+			break;
+
+		mp_opt->flags = *ptr++;
+		if (!((mp_opt->flags & MPTCP_CAP_FLAG_MASK) == MPTCP_CAP_HMAC_SHA1) ||
+		    (mp_opt->flags & MPTCP_CAP_EXTENSIBILITY))
+			break;
+
+		mp_opt->mp_capable = 1;
+		mp_opt->sndr_key = get_unaligned_be64(ptr);
+		ptr += 8;
+
+		if (opsize == TCPOLEN_MPTCP_MPC_SYNACK) {
+			mp_opt->rcvr_key = get_unaligned_be64(ptr);
+			ptr += 8;
+			pr_debug("MP_CAPABLE flags=%x, sndr=%llu, rcvr=%llu",
+				 mp_opt->flags, mp_opt->sndr_key,
+				 mp_opt->rcvr_key);
+		} else {
+			pr_debug("MP_CAPABLE flags=%x, sndr=%llu",
+				 mp_opt->flags, mp_opt->sndr_key);
+		}
+		break;
+
+	/* MPTCPOPT_MP_JOIN
+	 *
+	 * Initial SYN
+	 * 0: 4MSB=subtype, 000, 1LSB=Backup
+	 * 1: Address ID
+	 * 2-5: Receiver token
+	 * 6-9: Sender random number
+	 *
+	 * SYN/ACK response
+	 * 0: 4MSB=subtype, 000, 1LSB=Backup
+	 * 1: Address ID
+	 * 2-9: Sender truncated HMAC
+	 * 10-13: Sender random number
+	 *
+	 * Third ACK
+	 * 0: 4MSB=subtype, 0000
+	 * 1: 0 (Reserved)
+	 * 2-21: Sender HMAC
+	 */
+
+	/* MPTCPOPT_DSS
+	 * 0: 4MSB=subtype, 0000
+	 * 1: 3MSB=0, F=Data FIN, m=DSN length, M=has DSN/SSN/DLL/checksum,
+	 *    a=DACK length, A=has DACK
+	 * 0, 4, or 8 bytes of DACK (depending on A/a)
+	 * 0, 4, or 8 bytes of DSN (depending on M/m)
+	 * 0 or 4 bytes of SSN (depending on M)
+	 * 0 or 2 bytes of DLL (depending on M)
+	 * 0 or 2 bytes of checksum (depending on M)
+	 */
+	case MPTCPOPT_DSS:
+		pr_debug("DSS");
+		mp_opt->dss = 1;
+		break;
+
+	/* MPTCPOPT_ADD_ADDR
+	 * 0: 4MSB=subtype, 4LSB=IP version (4 or 6)
+	 * 1: Address ID
+	 * 4 or 16 bytes of address (depending on ip version)
+	 * 0 or 2 bytes of port (depending on length)
+	 */
+
+	/* MPTCPOPT_REMOVE_ADDR
+	 * 0: 4MSB=subtype, 0000
+	 * 1: Address ID
+	 * Additional bytes: More address IDs (depending on length)
+	 */
+
+	/* MPTCPOPT_MP_PRIO
+	 * 0: 4MSB=subtype, 000, 1LSB=Backup
+	 * 1: Address ID (optional, current addr implied if not present)
+	 */
+
+	/* MPTCPOPT_MP_FAIL
+	 * 0: 4MSB=subtype, 0000
+	 * 1: 0 (Reserved)
+	 * 2-9: DSN
+	 */
+
+	/* MPTCPOPT_MP_FASTCLOSE
+	 * 0: 4MSB=subtype, 0000
+	 * 1: 0 (Reserved)
+	 * 2-9: Receiver key
+	 */
+	default:
+		break;
+	}
+}
+
+void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
+{
+	if ((OPTION_MPTCP_MPC_SYN |
+	     OPTION_MPTCP_MPC_ACK) & opts->suboptions) {
+		u8 len;
+
+		if (OPTION_MPTCP_MPC_SYN & opts->suboptions)
+			len = TCPOLEN_MPTCP_MPC_SYN;
+		else
+			len = TCPOLEN_MPTCP_MPC_ACK;
+
+		*ptr++ = htonl((TCPOPT_MPTCP << 24) | (len << 16) |
+			       (MPTCPOPT_MP_CAPABLE << 12) |
+			       ((MPTCP_VERSION_MASK & 0) << 8) |
+			       MPTCP_CAP_HMAC_SHA1);
+		put_unaligned_be64(opts->sndr_key, ptr);
+		ptr += 2;
+		if (OPTION_MPTCP_MPC_ACK & opts->suboptions) {
+			put_unaligned_be64(opts->rcvr_key, ptr);
+			ptr += 2;
+		}
+	}
+}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 86db17af8c05..e57ee600df7f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -39,13 +39,13 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 static int mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct net *net = sock_net(sk);
 	struct socket *sf;
 	int err;
 
 	pr_debug("msk=%p", msk);
 
-	err = sock_create_kern(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
-			       &sf);
+	err = sock_create_kern(net, PF_INET, SOCK_STREAM, IPPROTO_TCP, &sf);
 	if (!err) {
 		pr_debug("subflow=%p", sf->sk);
 		msk->subflow = sf;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 972204835421..ac57e10ec4ca 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -7,6 +7,28 @@
 #ifndef __MPTCP_PROTOCOL_H
 #define __MPTCP_PROTOCOL_H
 
+/* MPTCP option subtypes */
+#define MPTCPOPT_MP_CAPABLE	0
+#define MPTCPOPT_MP_JOIN	1
+#define MPTCPOPT_DSS		2
+#define MPTCPOPT_ADD_ADDR	3
+#define MPTCPOPT_REMOVE_ADDR	4
+#define MPTCPOPT_MP_PRIO	5
+#define MPTCPOPT_MP_FAIL	6
+#define MPTCPOPT_MP_FASTCLOSE	7
+
+/* MPTCP suboption lengths */
+#define TCPOLEN_MPTCP_MPC_SYN		12
+#define TCPOLEN_MPTCP_MPC_SYNACK	20
+#define TCPOLEN_MPTCP_MPC_ACK		20
+
+/* MPTCP MP_CAPABLE flags */
+#define MPTCP_VERSION_MASK	(0x0F)
+#define MPTCP_CAP_CHECKSUM_REQD	BIT(7)
+#define MPTCP_CAP_EXTENSIBILITY	BIT(6)
+#define MPTCP_CAP_HMAC_SHA1	BIT(0)
+#define MPTCP_CAP_FLAG_MASK	(0x3F)
+
 /* MPTCP connection sock */
 struct mptcp_sock {
 	/* inet_connection_sock must be the first member */
-- 
2.22.0

