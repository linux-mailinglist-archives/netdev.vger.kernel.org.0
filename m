Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 184D94959C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbfFQW7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:10995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbfFQW6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:50 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 14/33] tcp: clean ext on tx recycle
Date:   Mon, 17 Jun 2019 15:57:49 -0700
Message-Id: <20190617225808.665-15-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Otherwise we will find stray/unexpected/old extensions
value on next iteration.

On tcp_write_xmit() we can end-up splitting an already queued
skb in two parts, via tso_fragment(). The newly created skb
can be allocated via the tx cache and the mptcp stack will not
be aware of it, so nobody set properly the MPTCP ext.

End result, we transmit the skb using an hold MPTCP DSS map
and that confuses the rx side/corrupt the stream. It requires
some concurrent conditions, so it's not deterministic.

Resetting the ext on recycle fixes all the current mptcp self tests
issues.

Apparently only MPTCP has issues with this kind of stray ext,
so an alternative would be add an additional mptcp hook in
tso_fragment() or in sk_stream_alloc_skb() to always init
the ext.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/skbuff.h | 8 ++++++++
 include/net/sock.h     | 1 +
 2 files changed, 9 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 28bdaf978e72..37387ab9f336 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4024,6 +4024,14 @@ static inline void skb_ext_put(struct sk_buff *skb)
 		__skb_ext_put(skb->extensions);
 }
 
+static inline void skb_ext_clear(struct sk_buff *skb)
+{
+	if (skb->active_extensions) {
+		__skb_ext_put(skb->extensions);
+		skb->active_extensions = 0;
+	}
+}
+
 static inline void __skb_ext_copy(struct sk_buff *dst,
 				  const struct sk_buff *src)
 {
diff --git a/include/net/sock.h b/include/net/sock.h
index e9d769c04637..bfa695716721 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1469,6 +1469,7 @@ static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 	sk->sk_wmem_queued -= skb->truesize;
 	sk_mem_uncharge(sk, skb->truesize);
 	if (!sk->sk_tx_skb_cache && !skb_cloned(skb)) {
+		skb_ext_clear(skb);
 		skb_zcopy_clear(skb, true);
 		sk->sk_tx_skb_cache = skb;
 		return;
-- 
2.22.0

