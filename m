Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BD03ABFB5
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhFQXsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:13474 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232631AbhFQXsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:40 -0400
IronPort-SDR: vaiNji8jfW4RMYFwqlLbFgVT7CXH+pUVuHm6l8aGGkC8pmoZztZqtgXtLwfXCyg5ekpZBuhCvY
 SLFV1VBmtSOw==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506647"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506647"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:31 -0700
IronPort-SDR: WQx/aqDgtq7bN7uRZvVOsyFN9gGVGme35GdoNLh3hrZ+K2Ihm1qhYj2MnLdED/Pus4kTkZDwPG
 LUBI3CDtpObw==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943908"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:31 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/16] mptcp: receive checksum for MP_CAPABLE with data
Date:   Thu, 17 Jun 2021 16:46:14 -0700
Message-Id: <20210617234622.472030-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new member named csum in struct mptcp_options_received.

When parsing the MP_CAPABLE with data, if the checksum is enabled,
adjust the expected_opsize. If the receiving option length matches the
length with the data checksum, get the checksum value and save it in
mp_opt->csum. And in mptcp_incoming_options, pass it to mpext->csum.

We always parse any csum/nocsum combination and delay the presence check
to later code, to allow reset if missing.

Additionally, in the TX path, use the newly introduce ext field to avoid
MPTCP csum recomputation on TCP retransmission and unneeded csum update
on when setting the data fin_flag.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h  |  3 ++-
 net/mptcp/options.c  | 35 ++++++++++++++++++++++++++---------
 net/mptcp/protocol.h |  3 +++
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 33af68eea96f..d61bbbf11979 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -32,7 +32,8 @@ struct mptcp_ext {
 			mpc_map:1,
 			frozen:1,
 			reset_transient:1;
-	u8		reset_reason:4;
+	u8		reset_reason:4,
+			csum_reqd:1;
 };
 
 #define MPTCP_RM_IDS_MAX	8
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 2e2551590ecd..8cbc75868969 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -44,7 +44,20 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			else
 				expected_opsize = TCPOLEN_MPTCP_MPC_SYN;
 		}
-		if (opsize != expected_opsize)
+
+		/* Cfr RFC 8684 Section 3.3.0:
+		 * If a checksum is present but its use had
+		 * not been negotiated in the MP_CAPABLE handshake, the receiver MUST
+		 * close the subflow with a RST, as it is not behaving as negotiated.
+		 * If a checksum is not present when its use has been negotiated, the
+		 * receiver MUST close the subflow with a RST, as it is considered
+		 * broken
+		 * We parse even option with mismatching csum presence, so that
+		 * later in subflow_data_ready we can trigger the reset.
+		 */
+		if (opsize != expected_opsize &&
+		    (expected_opsize != TCPOLEN_MPTCP_MPC_ACK_DATA ||
+		     opsize != TCPOLEN_MPTCP_MPC_ACK_DATA_CSUM))
 			break;
 
 		/* try to be gentle vs future versions on the initial syn */
@@ -66,11 +79,6 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		 * host requires the use of checksums, checksums MUST be used.
 		 * In other words, the only way for checksums not to be used
 		 * is if both hosts in their SYNs set A=0."
-		 *
-		 * Section 3.3.0:
-		 * "If a checksum is not present when its use has been
-		 * negotiated, the receiver MUST close the subflow with a RST as
-		 * it is considered broken."
 		 */
 		if (flags & MPTCP_CAP_CHECKSUM_REQD)
 			mp_opt->csum_reqd = 1;
@@ -84,7 +92,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			mp_opt->rcvr_key = get_unaligned_be64(ptr);
 			ptr += 8;
 		}
-		if (opsize == TCPOLEN_MPTCP_MPC_ACK_DATA) {
+		if (opsize >= TCPOLEN_MPTCP_MPC_ACK_DATA) {
 			/* Section 3.1.:
 			 * "the data parameters in a MP_CAPABLE are semantically
 			 * equivalent to those in a DSS option and can be used
@@ -96,9 +104,14 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			mp_opt->data_len = get_unaligned_be16(ptr);
 			ptr += 2;
 		}
-		pr_debug("MP_CAPABLE version=%x, flags=%x, optlen=%d sndr=%llu, rcvr=%llu len=%d",
+		if (opsize == TCPOLEN_MPTCP_MPC_ACK_DATA_CSUM) {
+			mp_opt->csum = (__force __sum16)get_unaligned_be16(ptr);
+			mp_opt->csum_reqd = 1;
+			ptr += 2;
+		}
+		pr_debug("MP_CAPABLE version=%x, flags=%x, optlen=%d sndr=%llu, rcvr=%llu len=%d csum=%u",
 			 version, flags, opsize, mp_opt->sndr_key,
-			 mp_opt->rcvr_key, mp_opt->data_len);
+			 mp_opt->rcvr_key, mp_opt->data_len, mp_opt->csum);
 		break;
 
 	case MPTCPOPT_MP_JOIN:
@@ -1118,6 +1131,10 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 		}
 		mpext->data_len = mp_opt.data_len;
 		mpext->use_map = 1;
+		mpext->csum_reqd = mp_opt.csum_reqd;
+
+		if (mpext->csum_reqd)
+			mpext->csum = mp_opt.csum;
 	}
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 66e5063ac6c9..76194babc754 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -68,6 +68,8 @@
 #define TCPOLEN_MPTCP_FASTCLOSE		12
 #define TCPOLEN_MPTCP_RST		4
 
+#define TCPOLEN_MPTCP_MPC_ACK_DATA_CSUM	(TCPOLEN_MPTCP_DSS_CHECKSUM + TCPOLEN_MPTCP_MPC_ACK_DATA)
+
 /* MPTCP MP_JOIN flags */
 #define MPTCPOPT_BACKUP		BIT(0)
 #define MPTCPOPT_HMAC_LEN	20
@@ -124,6 +126,7 @@ struct mptcp_options_received {
 	u64	data_seq;
 	u32	subflow_seq;
 	u16	data_len;
+	__sum16	csum;
 	u16	mp_capable : 1,
 		mp_join : 1,
 		fastclose : 1,
-- 
2.32.0

