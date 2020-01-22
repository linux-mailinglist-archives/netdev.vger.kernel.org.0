Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F856144C8B
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 08:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgAVHmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 02:42:05 -0500
Received: from nwk-aaemail-lapp03.apple.com ([17.151.62.68]:45920 "EHLO
        nwk-aaemail-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgAVHmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 02:42:05 -0500
Received: from pps.filterd (nwk-aaemail-lapp03.apple.com [127.0.0.1])
        by nwk-aaemail-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0urnU013197;
        Tue, 21 Jan 2020 16:57:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=3wLfVErYu8Ok/fd1Az15LlLLwPbv63mCtbZyrlS4iHA=;
 b=KeXfqc47/zFEVZ2bnaP/lCGDi4eSgOe4nHnne21vRYdtpZS1iVpiXtyBobIiKPik8MhS
 ImN0NYwsX269t8MNNswNKrI+ebBAOnhxvTf905ZsFvjsk+B4K1fR5yRpCreNaLDOS1aW
 w2nLiWYm/hr/JiR+UddzX3cABm3AA8CB6u3AAgJGADI62GE6cyKLZYvsAEyvfTA8quhS
 jcqrIWVQVS4T+gYIdLz75x/It9pC1iqlffkFHWhu3t3c1e5szUgGKo4uwZGw21WyugVw
 3SACT4Nffkt7KU9I75bi+uchYGFIwX4Yzsc/6cvyVr7rrzFcamfJKG+9zPpgs/q0P9lE 1A== 
Received: from ma1-mtap-s01.corp.apple.com (ma1-mtap-s01.corp.apple.com [17.40.76.5])
        by nwk-aaemail-lapp03.apple.com with ESMTP id 2xmk4p1699-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:05 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s01.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00HWQHAUJ720@ma1-mtap-s01.corp.apple.com>; Tue,
 21 Jan 2020 16:57:01 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00F00F5G4K00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:56:59 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: c051a37ac4e5843d47ecc64fcf48afb5
X-Va-R-CD: f0ad5c29aa74349f82409ccb4d6aa844
X-Va-CD: 0
X-Va-ID: 469c224d-cdcc-439d-a1cc-6afe209d191c
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: c051a37ac4e5843d47ecc64fcf48afb5
X-V-R-CD: f0ad5c29aa74349f82409ccb4d6aa844
X-V-CD: 0
X-V-ID: 09427620-70d1-44b6-8c18-328a9fc87aee
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H00DS6HAZDC30@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:56:59 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Peter Krystad <peter.krystad@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH net-next v3 02/19] mptcp: Handle MPTCP TCP options
Date:   Tue, 21 Jan 2020 16:56:16 -0800
Message-id: <20200122005633.21229-3-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Add hooks to parse and format the MP_CAPABLE option.

This option is handled according to MPTCP version 0 (RFC6824).
MPTCP version 1 MP_CAPABLE (RFC6824bis/RFC8684) will be added later in
coordination with related code changes.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 include/linux/tcp.h   | 18 ++++++++
 include/net/mptcp.h   | 18 ++++++++
 net/ipv4/tcp_input.c  |  5 +++
 net/ipv4/tcp_output.c | 13 ++++++
 net/mptcp/Makefile    |  2 +-
 net/mptcp/options.c   | 97 +++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h  | 29 +++++++++++++
 7 files changed, 181 insertions(+), 1 deletion(-)
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
index 98ba22379117..3daec2ceb3ff 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -9,6 +9,7 @@
 #define __NET_MPTCP_H
 
 #include <linux/skbuff.h>
+#include <linux/tcp.h>
 #include <linux/types.h>
 
 /* MPTCP sk_buff extension data */
@@ -26,10 +27,22 @@ struct mptcp_ext {
 	/* one byte hole */
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
 /* move the skb extension owership, with the assumption that 'to' is
  * newly allocated
  */
@@ -76,6 +89,11 @@ static inline void mptcp_init(void)
 {
 }
 
+static inline void mptcp_parse_option(const unsigned char *ptr, int opsize,
+				      struct tcp_options_received *opt_rx)
+{
+}
+
 static inline void mptcp_skb_ext_move(struct sk_buff *to,
 				      const struct sk_buff *from)
 {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 358365598216..3458ee13e6f0 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -79,6 +79,7 @@
 #include <trace/events/tcp.h>
 #include <linux/jump_label_ratelimit.h>
 #include <net/busy_poll.h>
+#include <net/mptcp.h>
 
 int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 
@@ -3924,6 +3925,10 @@ void tcp_parse_options(const struct net *net,
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
index 05109d0c675b..b6cf87b02b01 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -38,6 +38,7 @@
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <net/tcp.h>
+#include <net/mptcp.h>
 
 #include <linux/compiler.h>
 #include <linux/gfp.h>
@@ -414,6 +415,7 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 #define OPTION_WSCALE		(1 << 3)
 #define OPTION_FAST_OPEN_COOKIE	(1 << 8)
 #define OPTION_SMC		(1 << 9)
+#define OPTION_MPTCP		(1 << 10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
 {
@@ -439,8 +441,17 @@ struct tcp_out_options {
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
@@ -549,6 +560,8 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
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
index 000000000000..b7a31c0e5283
--- /dev/null
+++ b/net/mptcp/options.c
@@ -0,0 +1,97 @@
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
+	case MPTCPOPT_DSS:
+		pr_debug("DSS");
+		mp_opt->dss = 1;
+		break;
+
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
2.23.0

