Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FAD417CE2
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 23:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348558AbhIXVOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 17:14:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:53073 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346967AbhIXVOU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 17:14:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10117"; a="222280912"
X-IronPort-AV: E=Sophos;i="5.85,321,1624345200"; 
   d="scan'208";a="222280912"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 14:12:44 -0700
X-IronPort-AV: E=Sophos;i="5.85,321,1624345200"; 
   d="scan'208";a="704320278"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.52.210])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 14:12:44 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/5] mptcp: do not shrink snd_nxt when recovering
Date:   Fri, 24 Sep 2021 14:12:34 -0700
Message-Id: <20210924211238.162509-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924211238.162509-1-mathew.j.martineau@linux.intel.com>
References: <20210924211238.162509-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When recovering after a link failure, snd_nxt should not be set to a
lower value.  Else, update of snd_nxt is broken because:

  msk->snd_nxt += ret; (where ret is number of bytes sent)

assumes that snd_nxt always moves forward.
After reduction, its possible that snd_nxt update gets out of sync:
dfrag we just sent might have had a data sequence number even past
recovery_snd_nxt.

This change factors the common msk state update to a helper
and updates snd_nxt based on the current dfrag data sequence number.

The conditional is required for the recovery phase where we may
re-transmit old dfrags that are before current snd_nxt.

After this change, snd_nxt only moves forward and covers all in-sequence
data that was transmitted.

recovery_snd_nxt is retained to detect when recovery has completed.

Fixes: 1e1d9d6f119c5 ("mptcp: handle pending data on closed subflow")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  |  8 +++-----
 net/mptcp/protocol.c | 43 +++++++++++++++++++++++++++++++------------
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index c41273cefc51..1ec6529c4326 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1019,11 +1019,9 @@ static void ack_update_msk(struct mptcp_sock *msk,
 	old_snd_una = msk->snd_una;
 	new_snd_una = mptcp_expand_seq(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
 
-	/* ACK for data not even sent yet and even above recovery bound? Ignore.*/
-	if (unlikely(after64(new_snd_una, snd_nxt))) {
-		if (!msk->recovery || after64(new_snd_una, msk->recovery_snd_nxt))
-			new_snd_una = old_snd_una;
-	}
+	/* ACK for data not even sent yet? Ignore.*/
+	if (unlikely(after64(new_snd_una, snd_nxt)))
+		new_snd_una = old_snd_una;
 
 	new_wnd_end = new_snd_una + tcp_sk(ssk)->snd_wnd;
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7e5f76092b64..3d1757b8ef69 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1525,6 +1525,32 @@ static void mptcp_push_release(struct sock *sk, struct sock *ssk,
 	release_sock(ssk);
 }
 
+static void mptcp_update_post_push(struct mptcp_sock *msk,
+				   struct mptcp_data_frag *dfrag,
+				   u32 sent)
+{
+	u64 snd_nxt_new = dfrag->data_seq;
+
+	dfrag->already_sent += sent;
+
+	msk->snd_burst -= sent;
+	msk->tx_pending_data -= sent;
+
+	snd_nxt_new += dfrag->already_sent;
+
+	/* snd_nxt_new can be smaller than snd_nxt in case mptcp
+	 * is recovering after a failover. In that event, this re-sends
+	 * old segments.
+	 *
+	 * Thus compute snd_nxt_new candidate based on
+	 * the dfrag->data_seq that was sent and the data
+	 * that has been handed to the subflow for transmission
+	 * and skip update in case it was old dfrag.
+	 */
+	if (likely(after64(snd_nxt_new, msk->snd_nxt)))
+		msk->snd_nxt = snd_nxt_new;
+}
+
 void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 {
 	struct sock *prev_ssk = NULL, *ssk = NULL;
@@ -1568,12 +1594,10 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 			}
 
 			info.sent += ret;
-			dfrag->already_sent += ret;
-			msk->snd_nxt += ret;
-			msk->snd_burst -= ret;
-			msk->tx_pending_data -= ret;
 			copied += ret;
 			len -= ret;
+
+			mptcp_update_post_push(msk, dfrag, ret);
 		}
 		WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
 	}
@@ -1626,13 +1650,11 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 				goto out;
 
 			info.sent += ret;
-			dfrag->already_sent += ret;
-			msk->snd_nxt += ret;
-			msk->snd_burst -= ret;
-			msk->tx_pending_data -= ret;
 			copied += ret;
 			len -= ret;
 			first = false;
+
+			mptcp_update_post_push(msk, dfrag, ret);
 		}
 		WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
 	}
@@ -2230,15 +2252,12 @@ bool __mptcp_retransmit_pending_data(struct sock *sk)
 		return false;
 	}
 
-	/* will accept ack for reijected data before re-sending them */
-	if (!msk->recovery || after64(msk->snd_nxt, msk->recovery_snd_nxt))
-		msk->recovery_snd_nxt = msk->snd_nxt;
+	msk->recovery_snd_nxt = msk->snd_nxt;
 	msk->recovery = true;
 	mptcp_data_unlock(sk);
 
 	msk->first_pending = rtx_head;
 	msk->tx_pending_data += msk->snd_nxt - rtx_head->data_seq;
-	msk->snd_nxt = rtx_head->data_seq;
 	msk->snd_burst = 0;
 
 	/* be sure to clear the "sent status" on all re-injected fragments */
-- 
2.33.0

