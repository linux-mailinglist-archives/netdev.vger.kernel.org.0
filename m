Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0753511F07F
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 07:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfLNGEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 01:04:35 -0500
Received: from mga06.intel.com ([134.134.136.31]:24722 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfLNGEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 01:04:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 22:04:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,312,1571727600"; 
   d="scan'208";a="216855215"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.17.224])
  by orsmga003.jf.intel.com with ESMTP; 13 Dec 2019 22:04:33 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/15] mptcp: Handle MPTCP TCP options
Date:   Fri, 13 Dec 2019 22:04:04 -0800
Message-Id: <20191214060417.2870-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
References: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Add routines to parse and format the MP_CAPABLE option.

These options are handled according to MPTCPv0 (RFC6824).
RFC6824bis/RFC8684 MPTCPv1 MP_CAPABLE is added later in coordination
with related code changes.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/linux/tcp.h   |  18 +++++
 include/net/mptcp.h   |  18 +++++
 net/ipv4/tcp_input.c  |   5 ++
 net/ipv4/tcp_output.c |  13 ++++
 net/mptcp/Makefile    |   2 +-
 net/mptcp/options.c   | 159 ++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h  |  29 ++++++++
 7 files changed, 243 insertions(+), 1 deletion(-)
 create mode 100644 net/mptcp/options.c

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index ca6f01531e64..52798ab00394 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -78,6 +78,16 @@ struct tcp_sack_block {
 #define TCP_SACK_SEEN     (1 << 0)   /*1 = peer is SACK capable, */
 #define TCP_DSACK_SEEN    (1 << 2)   /*1 = DSACK was received from peer*/
 
+#if IS_ENABLED(CONFIG_MPTCP)
+struct mptcp_options_received {
+	u64	sndr_key;
+	u64	rcvr_key;
+	u8	mp_capable : 1,
+		mp_join : 1,
+		dss : 1;
+};
+#endif
+
 struct tcp_options_received {
 /*	PAWS/RTTM data	*/
 	int	ts_recent_stamp;/* Time we stored ts_recent (for aging) */
@@ -95,6 +105,9 @@ struct tcp_options_received {
 	u8	num_sacks;	/* Number of SACK blocks		*/
 	u16	user_mss;	/* mss requested by user in ioctl	*/
 	u16	mss_clamp;	/* Maximal mss, negotiated at connection setup */
+#if IS_ENABLED(CONFIG_MPTCP)
+	struct mptcp_options_received	mptcp;
+#endif
 };
 
 static inline void tcp_clear_options(struct tcp_options_received *rx_opt)
@@ -104,6 +117,11 @@ static inline void tcp_clear_options(struct tcp_options_received *rx_opt)
 #if IS_ENABLED(CONFIG_SMC)
 	rx_opt->smc_ok = 0;
 #endif
+#if IS_ENABLED(CONFIG_MPTCP)
+	rx_opt->mptcp.mp_capable = 0;
+	rx_opt->mptcp.mp_join = 0;
+	rx_opt->mptcp.dss = 0;
+#endif
 }
 
 /* This is the max number of SACKS that we'll generate and process. It's safe
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 4113e063f728..ea96308ae546 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -9,6 +9,7 @@
 #define __NET_MPTCP_H
 
 #include <linux/skbuff.h>
+#include <linux/tcp.h>
 #include <linux/types.h>
 
 /* MPTCP sk_buff extension data */
@@ -25,10 +26,22 @@ struct mptcp_ext {
 			__unused:2;
 };
 
+struct mptcp_out_options {
+#if IS_ENABLED(CONFIG_MPTCP)
+	u16 suboptions;
+	u64 sndr_key;
+	u64 rcvr_key;
+#endif
+};
+
 #ifdef CONFIG_MPTCP
 
 void mptcp_init(void);
 
+void mptcp_parse_option(const unsigned char *ptr, int opsize,
+			struct tcp_options_received *opt_rx);
+void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts);
+
 static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
 {
 	return skb_ext_exist(skb, SKB_EXT_MPTCP);
@@ -40,6 +53,11 @@ static inline void mptcp_init(void)
 {
 }
 
+static inline void mptcp_parse_option(const unsigned char *ptr, int opsize,
+				      struct tcp_options_received *opt_rx)
+{
+}
+
 static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
 {
 	return false;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 55b460a2ece2..4fc649b72ae4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -79,6 +79,7 @@
 #include <trace/events/tcp.h>
 #include <linux/jump_label_ratelimit.h>
 #include <net/busy_poll.h>
+#include <net/mptcp.h>
 
 int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 
@@ -3920,6 +3921,10 @@ void tcp_parse_options(const struct net *net,
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
index 710ab45badfa..5c91fc3b126b 100644
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
@@ -436,8 +438,17 @@ struct tcp_out_options {
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
+	struct mptcp_out_options mptcp;
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
@@ -546,6 +557,8 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
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
index 000000000000..cd4c0c8de6e0
--- /dev/null
+++ b/net/mptcp/options.c
@@ -0,0 +1,159 @@
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
+	u8 version;
+	u8 flags;
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
+		    opsize != TCPOLEN_MPTCP_MPC_ACK)
+			break;
+
+		version = *ptr++ & MPTCP_VERSION_MASK;
+		if (version != MPTCP_SUPPORTED_VERSION)
+			break;
+
+		flags = *ptr++;
+		if (!((flags & MPTCP_CAP_FLAG_MASK) == MPTCP_CAP_HMAC_SHA1) ||
+		    (flags & MPTCP_CAP_EXTENSIBILITY))
+			break;
+
+		/* RFC 6824, Section 3.1:
+		 * "For the Checksum Required bit (labeled "A"), if either
+		 * host requires the use of checksums, checksums MUST be used.
+		 * In other words, the only way for checksums not to be used
+		 * is if both hosts in their SYNs set A=0."
+		 *
+		 * Section 3.3.0:
+		 * "If a checksum is not present when its use has been
+		 * negotiated, the receiver MUST close the subflow with a RST as
+		 * it is considered broken."
+		 *
+		 * We don't implement DSS checksum - fall back to TCP.
+		 */
+		if (flags & MPTCP_CAP_CHECKSUM_REQD)
+			break;
+
+		mp_opt->mp_capable = 1;
+		mp_opt->sndr_key = get_unaligned_be64(ptr);
+		ptr += 8;
+
+		if (opsize == TCPOLEN_MPTCP_MPC_ACK) {
+			mp_opt->rcvr_key = get_unaligned_be64(ptr);
+			ptr += 8;
+			pr_debug("MP_CAPABLE sndr=%llu, rcvr=%llu",
+				 mp_opt->sndr_key, mp_opt->rcvr_key);
+		} else {
+			pr_debug("MP_CAPABLE sndr=%llu", mp_opt->sndr_key);
+		}
+		break;
+
+	/* MPTCPOPT_MP_JOIN
+	 * Initial SYN
+	 * 0: 4MSB=subtype, 000, 1LSB=Backup
+	 * 1: Address ID
+	 * 2-5: Receiver token
+	 * 6-9: Sender random number
+	 * SYN/ACK response
+	 * 0: 4MSB=subtype, 000, 1LSB=Backup
+	 * 1: Address ID
+	 * 2-9: Sender truncated HMAC
+	 * 10-13: Sender random number
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
+	/* MPTCPOPT_RM_ADDR
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
+			       (MPTCP_SUPPORTED_VERSION << 8) |
+			       MPTCP_CAP_HMAC_SHA1);
+		put_unaligned_be64(opts->sndr_key, ptr);
+		ptr += 2;
+		if (OPTION_MPTCP_MPC_ACK & opts->suboptions) {
+			put_unaligned_be64(opts->rcvr_key, ptr);
+			ptr += 2;
+		}
+	}
+}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index ee04a01bffd3..c59cf8b220b0 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -7,6 +7,35 @@
 #ifndef __MPTCP_PROTOCOL_H
 #define __MPTCP_PROTOCOL_H
 
+#define MPTCP_SUPPORTED_VERSION	0
+
+/* MPTCP option bits */
+#define OPTION_MPTCP_MPC_SYN	BIT(0)
+#define OPTION_MPTCP_MPC_SYNACK	BIT(1)
+#define OPTION_MPTCP_MPC_ACK	BIT(2)
+
+/* MPTCP option subtypes */
+#define MPTCPOPT_MP_CAPABLE	0
+#define MPTCPOPT_MP_JOIN	1
+#define MPTCPOPT_DSS		2
+#define MPTCPOPT_ADD_ADDR	3
+#define MPTCPOPT_RM_ADDR	4
+#define MPTCPOPT_MP_PRIO	5
+#define MPTCPOPT_MP_FAIL	6
+#define MPTCPOPT_MP_FASTCLOSE	7
+
+/* MPTCP suboption lengths */
+#define TCPOLEN_MPTCP_MPC_SYN		12
+#define TCPOLEN_MPTCP_MPC_SYNACK	12
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
2.24.1

