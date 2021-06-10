Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DF33A377E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhFJXBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:01:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:55161 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhFJXBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 19:01:47 -0400
IronPort-SDR: XH37uWhgPFhRH7/uXpuPcsJnDqm8mb6RTJGSiukDX2v1We6FKuNsgtiBwZVQQUiuUY09uSSv0H
 UUAe2dVMKEvw==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="205383802"
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="205383802"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:59:50 -0700
IronPort-SDR: 1C/FuNPpMYZlVHSvidCbR830ZYzFELsp3/ADTNfNkr98m8J582trb0r/MVRatuwzFHsGkr2TZo
 7Z0LwaBGSuAQ==
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="441387020"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.70.185])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:59:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/5] mptcp: try harder to borrow memory from subflow under pressure
Date:   Thu, 10 Jun 2021 15:59:40 -0700
Message-Id: <20210610225944.351224-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210610225944.351224-1-mathew.j.martineau@linux.intel.com>
References: <20210610225944.351224-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

If the host is under sever memory pressure, and RX forward
memory allocation for the msk fails, we try to borrow the
required memory from the ingress subflow.

The current attempt is a bit flaky: if skb->truesize is less
than SK_MEM_QUANTUM, the ssk will not release any memory, and
the next schedule will fail again.

Instead, directly move the required amount of pages from the
ssk to the msk, if available

Fixes: 9c3f94e1681b ("mptcp: add missing memory scheduling in the rx path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5edc686faff1..534cf500521d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -280,11 +280,13 @@ static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 
 	/* try to fetch required memory from subflow */
 	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
-		if (ssk->sk_forward_alloc < skb->truesize)
-			goto drop;
-		__sk_mem_reclaim(ssk, skb->truesize);
-		if (!sk_rmem_schedule(sk, skb, skb->truesize))
+		int amount = sk_mem_pages(skb->truesize) << SK_MEM_QUANTUM_SHIFT;
+
+		if (ssk->sk_forward_alloc < amount)
 			goto drop;
+
+		ssk->sk_forward_alloc -= amount;
+		sk->sk_forward_alloc += amount;
 	}
 
 	/* the skb map_seq accounts for the skb offset:
-- 
2.32.0

