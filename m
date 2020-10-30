Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CFC2A1117
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgJ3WpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:45:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:45959 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgJ3WpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 18:45:15 -0400
IronPort-SDR: dJDwoRjuYXNP7ZXxJg9Lzxy6HZuz0SUeZJ9eZR9Y10pboIPeysfTaew6BfHP8kfs6OiKrTOGNc
 NIflivYB4UAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="165177398"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="165177398"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:14 -0700
IronPort-SDR: EGFqJTfKjrCLDJ6CD7m6P1DNdqp6YqKD2wb+FlmB5qfiJf1Cj3ZM7YdFPERMmCAi2knh+T0ESE
 WnBPYEe9F2Hw==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="361983939"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.102.227])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:12 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, mptcp@lists.01.org,
        kuba@kernel.org, davem@davemloft.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/6] tcp: propagate MPTCP skb extensions on xmit splits
Date:   Fri, 30 Oct 2020 15:45:03 -0700
Message-Id: <20201030224506.108377-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
References: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

When the TCP stack splits a packet on the write queue, the tail
half currently lose the associated skb extensions, and will not
carry the DSM on the wire.

The above does not cause functional problems and is allowed by
the RFC, but interact badly with GRO and RX coalescing, as possible
candidates for aggregation will carry different TCP options.

This change tries to improve the MPTCP behavior, propagating the
skb extensions on split.

Additionally, we must prevent the MPTCP stack from updating the
mapping after the split occur: that will both violate the RFC and
fool the reader.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/mptcp.h   | 21 ++++++++++++++++++++-
 net/ipv4/tcp_output.c |  3 +++
 net/mptcp/protocol.c  |  7 +++++--
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 753ba7e755d6..6e706d838e4e 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -29,7 +29,8 @@ struct mptcp_ext {
 			use_ack:1,
 			ack64:1,
 			mpc_map:1,
-			__unused:2;
+			frozen:1,
+			__unused:1;
 	/* one byte hole */
 };
 
@@ -106,6 +107,19 @@ static inline void mptcp_skb_ext_move(struct sk_buff *to,
 	from->active_extensions = 0;
 }
 
+static inline void mptcp_skb_ext_copy(struct sk_buff *to,
+				      struct sk_buff *from)
+{
+	struct mptcp_ext *from_ext;
+
+	from_ext = skb_ext_find(from, SKB_EXT_MPTCP);
+	if (!from_ext)
+		return;
+
+	from_ext->frozen = 1;
+	skb_ext_copy(to, from);
+}
+
 static inline bool mptcp_ext_matches(const struct mptcp_ext *to_ext,
 				     const struct mptcp_ext *from_ext)
 {
@@ -193,6 +207,11 @@ static inline void mptcp_skb_ext_move(struct sk_buff *to,
 {
 }
 
+static inline void mptcp_skb_ext_copy(struct sk_buff *to,
+				      struct sk_buff *from)
+{
+}
+
 static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
 					  const struct sk_buff *from)
 {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bf48cd73e967..9abf5a0358d5 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1569,6 +1569,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	if (!buff)
 		return -ENOMEM; /* We'll just try again later. */
 	skb_copy_decrypted(buff, skb);
+	mptcp_skb_ext_copy(buff, skb);
 
 	sk_wmem_queued_add(sk, buff->truesize);
 	sk_mem_charge(sk, buff->truesize);
@@ -2123,6 +2124,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 	if (unlikely(!buff))
 		return -ENOMEM;
 	skb_copy_decrypted(buff, skb);
+	mptcp_skb_ext_copy(buff, skb);
 
 	sk_wmem_queued_add(sk, buff->truesize);
 	sk_mem_charge(sk, buff->truesize);
@@ -2393,6 +2395,7 @@ static int tcp_mtu_probe(struct sock *sk)
 
 	skb = tcp_send_head(sk);
 	skb_copy_decrypted(nskb, skb);
+	mptcp_skb_ext_copy(nskb, skb);
 
 	TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(skb)->seq;
 	TCP_SKB_CB(nskb)->end_seq = TCP_SKB_CB(skb)->seq + probe_size;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f5bacfc55006..25d12183d1ca 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -771,8 +771,11 @@ static bool mptcp_skb_can_collapse_to(u64 write_seq,
 	if (!tcp_skb_can_collapse_to(skb))
 		return false;
 
-	/* can collapse only if MPTCP level sequence is in order */
-	return mpext && mpext->data_seq + mpext->data_len == write_seq;
+	/* can collapse only if MPTCP level sequence is in order and this
+	 * mapping has not been xmitted yet
+	 */
+	return mpext && mpext->data_seq + mpext->data_len == write_seq &&
+	       !mpext->frozen;
 }
 
 static bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
-- 
2.29.2

