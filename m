Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955FB135D59
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 17:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732786AbgAIQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 11:00:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:6694 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732769AbgAIQAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 11:00:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 08:00:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="218399305"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.4.119])
  by fmsmga008.fm.intel.com with ESMTP; 09 Jan 2020 08:00:05 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v7 10/11] tcp: clean ext on tx recycle
Date:   Thu,  9 Jan 2020 07:59:23 -0800
Message-Id: <20200109155924.30122-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109155924.30122-1-mathew.j.martineau@linux.intel.com>
References: <20200109155924.30122-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Otherwise we will find stray/unexpected/old extensions value on next
iteration.

On tcp_write_xmit() we can end-up splitting an already queued skb in two
parts, via tso_fragment(). The newly created skb can be allocated via
the tx cache and an upper layer will not be aware of it, so that upper
layer cannot set the ext properly.

Resetting the ext on recycle ensures that stale data is not propagated
in to packet headers or elsewhere.

An alternative would be add an additional hook in tso_fragment() or in
sk_stream_alloc_skb() to init the ext for upper layers that need it.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/sock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8766f9bc3e70..432ff73d20f3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1464,6 +1464,7 @@ static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 	sk_mem_uncharge(sk, skb->truesize);
 	if (static_branch_unlikely(&tcp_tx_skb_cache_key) &&
 	    !sk->sk_tx_skb_cache && !skb_cloned(skb)) {
+		skb_ext_reset(skb);
 		skb_zcopy_clear(skb, true);
 		sk->sk_tx_skb_cache = skb;
 		return;
-- 
2.24.1

