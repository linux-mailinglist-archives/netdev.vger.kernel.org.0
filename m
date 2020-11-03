Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6E22A4FAA
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgKCTF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:05:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:49624 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbgKCTFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:05:25 -0500
IronPort-SDR: 5X9XAgkh5gysAOOUHTjq25IbVLEVFp97AfxUz0JmHn15kQz+5LkchxmZvtdgZYcI0Hmlhwv+X2
 Eol+lpnl1qxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="148386932"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="148386932"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 11:05:14 -0800
IronPort-SDR: gY9ozo9f3XbKpyPtld/gg3SdORkrm41VZmweYHUs+0aLqEs2+UZtf8GOGRjUlO7suD+VLfCpDQ
 FIOl8cpWdJxw==
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="352430149"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.18.188])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 11:05:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, mptcp@lists.01.org,
        kuba@kernel.org, davem@davemloft.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 3/7] tcp: propagate MPTCP skb extensions on xmit splits
Date:   Tue,  3 Nov 2020 11:05:05 -0800
Message-Id: <20201103190509.27416-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
References: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
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

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
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

