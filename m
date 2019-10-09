Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B228D1C6D
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732438AbfJIXIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:08:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:40474 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732431AbfJIXIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 19:08:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 16:08:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,277,1566889200"; 
   d="scan'208";a="205902523"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.70.56])
  by orsmga002.jf.intel.com with ESMTP; 09 Oct 2019 16:08:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v3 10/10] tcp: clean ext on tx recycle
Date:   Wed,  9 Oct 2019 16:08:09 -0700
Message-Id: <20191009230809.27387-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009230809.27387-1-mathew.j.martineau@linux.intel.com>
References: <20191009230809.27387-1-mathew.j.martineau@linux.intel.com>
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
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/sock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 4850c10461b8..84ea0efe7952 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1470,6 +1470,7 @@ static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 	sk_mem_uncharge(sk, skb->truesize);
 	if (static_branch_unlikely(&tcp_tx_skb_cache_key) &&
 	    !sk->sk_tx_skb_cache && !skb_cloned(skb)) {
+		skb_ext_reset(skb);
 		skb_zcopy_clear(skb, true);
 		sk->sk_tx_skb_cache = skb;
 		return;
-- 
2.23.0

