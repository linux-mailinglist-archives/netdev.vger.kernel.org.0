Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B35D417CE4
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 23:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348562AbhIXVOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 17:14:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:53078 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347069AbhIXVOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 17:14:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10117"; a="222280919"
X-IronPort-AV: E=Sophos;i="5.85,321,1624345200"; 
   d="scan'208";a="222280919"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 14:12:46 -0700
X-IronPort-AV: E=Sophos;i="5.85,321,1624345200"; 
   d="scan'208";a="704320286"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.52.210])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 14:12:46 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/5] mptcp: remove tx_pending_data
Date:   Fri, 24 Sep 2021 14:12:37 -0700
Message-Id: <20210924211238.162509-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924211238.162509-1-mathew.j.martineau@linux.intel.com>
References: <20210924211238.162509-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The update on recovery is not correct.

msk->tx_pending_data += msk->snd_nxt - rtx_head->data_seq;

will update tx_pending_data multiple times when a subflow is declared
stale while earlier recovery is still in progress.
This means that tx_pending_data will still be positive even after
all data as has been transmitted.

Rather than fix it, remove this field: there are no consumers.
The outstanding data byte count can be computed either via

 "msk->write_seq - rtx_head->data_seq" or
 "msk->write_seq - msk->snd_una".

The latter is more recent/accurate estimate as rtx_head adjustment
is deferred until mptcp lock can be acquired.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 4 ----
 net/mptcp/protocol.h | 1 -
 2 files changed, 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 87ee409d68ab..5b0ed64c5cd2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1531,7 +1531,6 @@ static void mptcp_update_post_push(struct mptcp_sock *msk,
 	dfrag->already_sent += sent;
 
 	msk->snd_burst -= sent;
-	msk->tx_pending_data -= sent;
 
 	snd_nxt_new += dfrag->already_sent;
 
@@ -1761,7 +1760,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		frag_truesize += psize;
 		pfrag->offset += frag_truesize;
 		WRITE_ONCE(msk->write_seq, msk->write_seq + psize);
-		msk->tx_pending_data += psize;
 
 		/* charge data on mptcp pending queue to the msk socket
 		 * Note: we charge such data both to sk and ssk
@@ -2254,7 +2252,6 @@ bool __mptcp_retransmit_pending_data(struct sock *sk)
 	mptcp_data_unlock(sk);
 
 	msk->first_pending = rtx_head;
-	msk->tx_pending_data += msk->snd_nxt - rtx_head->data_seq;
 	msk->snd_burst = 0;
 
 	/* be sure to clear the "sent status" on all re-injected fragments */
@@ -2525,7 +2522,6 @@ static int __mptcp_init_sock(struct sock *sk)
 	msk->first_pending = NULL;
 	msk->wmem_reserved = 0;
 	WRITE_ONCE(msk->rmem_released, 0);
-	msk->tx_pending_data = 0;
 	msk->timer_ival = TCP_RTO_MIN;
 
 	msk->first = NULL;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d3e6fd1615f1..d516fb6578cc 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -254,7 +254,6 @@ struct mptcp_sock {
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;
 	struct sk_buff_head receive_queue;
-	int		tx_pending_data;
 	struct list_head conn_list;
 	struct list_head rtx_queue;
 	struct mptcp_data_frag *first_pending;
-- 
2.33.0

