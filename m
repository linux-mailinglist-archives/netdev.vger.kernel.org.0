Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CBE190054
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgCWV3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:29:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:60329 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCWV3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:29:39 -0400
IronPort-SDR: PlMHXfpTD7FpZKwgOfuY8QCKQ8m3euaXt9gl21123rY63PdGcvFnhJ1MCeFEryyIHkBb5gFyDu
 mg4bSbVLNf3Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 14:29:38 -0700
IronPort-SDR: 38jwlUymnc871SWS8CdfyvFVTFlxLqh6tPxOjr7/CVuxGTU/7HYx3qSN0ZAMC4G8UO740OOjlQ
 ND5IuPkgJDbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="445960423"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.100.76])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2020 14:29:38 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, eric.dumazet@gmail.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/17] mptcp: allow partial cleaning of rtx head dfrag
Date:   Mon, 23 Mar 2020 14:26:35 -0700
Message-Id: <20200323212642.34104-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
References: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

After adding wmem accounting for the mptcp socket we could get
into a situation where the mptcp socket can't transmit more data,
and mptcp_clean_una doesn't reduce wmem even if snd_una has advanced
because it currently will only remove entire dfrags.

Allow advancing the dfrag head sequence and reduce wmem,
even though this isn't correct (as we can't release the page).

Because we will soon block on mptcp sk in case wmem is too large,
call sk_stream_write_space() in case we reduced the backlog so
userspace task blocked in sendmsg or poll will be woken up.

This isn't an issue if the send buffer is large, but it is when
SO_SNDBUF is used to reduce it to a lower value.

Note we can still get a deadlock for low SO_SNDBUF values in
case both sides of the connection write to the socket: both could
be blocked due to wmem being too small -- and current mptcp stack
will only increment mptcp ack_seq on recv.

This doesn't happen with the selftest as it uses poll() and
will always call recv if there is data to read.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 16 ++++++++++++++++
 net/mptcp/protocol.h | 10 ++++++++++
 2 files changed, 26 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c578f1deed0b..d4b6ce984576 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -338,6 +338,7 @@ static inline bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 static void dfrag_uncharge(struct sock *sk, int len)
 {
 	sk_mem_uncharge(sk, len);
+	sk_wmem_queued_add(sk, -len);
 }
 
 static void dfrag_clear(struct sock *sk, struct mptcp_data_frag *dfrag)
@@ -364,8 +365,23 @@ static void mptcp_clean_una(struct sock *sk)
 		cleaned = true;
 	}
 
+	dfrag = mptcp_rtx_head(sk);
+	if (dfrag && after64(snd_una, dfrag->data_seq)) {
+		u64 delta = dfrag->data_seq + dfrag->data_len - snd_una;
+
+		dfrag->data_seq += delta;
+		dfrag->data_len -= delta;
+
+		dfrag_uncharge(sk, delta);
+		cleaned = true;
+	}
+
 	if (cleaned) {
 		sk_mem_reclaim_partial(sk);
+
+		/* Only wake up writers if a subflow is ready */
+		if (test_bit(MPTCP_SEND_SPACE, &msk->flags))
+			sk_stream_write_space(sk);
 	}
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d222eea11922..f855c954a8ff 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -190,6 +190,16 @@ static inline struct mptcp_data_frag *mptcp_rtx_tail(const struct sock *sk)
 	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
 }
 
+static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (list_empty(&msk->rtx_queue))
+		return NULL;
+
+	return list_first_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
+}
+
 struct mptcp_subflow_request_sock {
 	struct	tcp_request_sock sk;
 	u16	mp_capable : 1,
-- 
2.26.0

