Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E271960A3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgC0VtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:49:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:25804 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727717AbgC0VtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 17:49:10 -0400
IronPort-SDR: aOK6IFZ+GLEJG4sBVbNOIy/UjvIXKWjmg8rkgtFF1E/BovVbPiPXesSBb5fi08sYOhBViiQ0yq
 pm/FVDfxLz/g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 14:49:09 -0700
IronPort-SDR: ob/DZAMCbXMb/do+228l7KjU+8j2hFc8bXQxBQjXSWQEr8PwWupp+2/3IV1m7SoHyheRVkXPUg
 irKHwaVvVQFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="271713466"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.7.195])
  by fmsmga004.fm.intel.com with ESMTP; 27 Mar 2020 14:49:09 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, eric.dumazet@gmail.com,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v3 06/17] mptcp: update per unacked sequence on pkt reception
Date:   Fri, 27 Mar 2020 14:48:42 -0700
Message-Id: <20200327214853.140669-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
References: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

So that we keep per unacked sequence number consistent; since
we update per msk data, use an atomic64 cmpxchg() to protect
against concurrent updates from multiple subflows.

Initialize the snd_una at connect()/accept() time.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 52 +++++++++++++++++++++++++++++++++++++++-----
 net/mptcp/protocol.c |  2 ++
 net/mptcp/protocol.h |  1 +
 3 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 20ba00865c55..b0ff8ad702a3 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -744,6 +744,46 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
 	return true;
 }
 
+static u64 expand_ack(u64 old_ack, u64 cur_ack, bool use_64bit)
+{
+	u32 old_ack32, cur_ack32;
+
+	if (use_64bit)
+		return cur_ack;
+
+	old_ack32 = (u32)old_ack;
+	cur_ack32 = (u32)cur_ack;
+	cur_ack = (old_ack & GENMASK_ULL(63, 32)) + cur_ack32;
+	if (unlikely(before(cur_ack32, old_ack32)))
+		return cur_ack + (1LL << 32);
+	return cur_ack;
+}
+
+static void update_una(struct mptcp_sock *msk,
+		       struct mptcp_options_received *mp_opt)
+{
+	u64 new_snd_una, snd_una, old_snd_una = atomic64_read(&msk->snd_una);
+	u64 write_seq = READ_ONCE(msk->write_seq);
+
+	/* avoid ack expansion on update conflict, to reduce the risk of
+	 * wrongly expanding to a future ack sequence number, which is way
+	 * more dangerous than missing an ack
+	 */
+	new_snd_una = expand_ack(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
+
+	/* ACK for data not even sent yet? Ignore. */
+	if (after64(new_snd_una, write_seq))
+		new_snd_una = old_snd_una;
+
+	while (after64(new_snd_una, old_snd_una)) {
+		snd_una = old_snd_una;
+		old_snd_una = atomic64_cmpxchg(&msk->snd_una, snd_una,
+					       new_snd_una);
+		if (old_snd_una == snd_una)
+			break;
+	}
+}
+
 static bool add_addr_hmac_valid(struct mptcp_sock *msk,
 				struct mptcp_options_received *mp_opt)
 {
@@ -805,6 +845,12 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 	if (!mp_opt->dss)
 		return;
 
+	/* we can't wait for recvmsg() to update the ack_seq, otherwise
+	 * monodirectional flows will stuck
+	 */
+	if (mp_opt->use_ack)
+		update_una(msk, mp_opt);
+
 	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
 	if (!mpext)
 		return;
@@ -831,12 +877,6 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 		mpext->use_map = 1;
 	}
 
-	if (mp_opt->use_ack) {
-		mpext->data_ack = mp_opt->data_ack;
-		mpext->use_ack = 1;
-		mpext->ack64 = mp_opt->ack64;
-	}
-
 	mpext->data_fin = mp_opt->data_fin;
 }
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5c4560287bd2..d3197ace2a89 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -906,6 +906,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *req)
 	}
 
 	msk->write_seq = subflow_req->idsn + 1;
+	atomic64_set(&msk->snd_una, msk->write_seq);
 	if (subflow_req->remote_key_valid) {
 		msk->can_ack = true;
 		msk->remote_key = subflow_req->remote_key;
@@ -1107,6 +1108,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
 	WRITE_ONCE(msk->ack_seq, ack_seq);
 	WRITE_ONCE(msk->can_ack, 1);
+	atomic64_set(&msk->snd_una, msk->write_seq);
 
 	mptcp_pm_new_connection(msk, 0);
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 209bdaa43dda..29db05467cc3 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -147,6 +147,7 @@ struct mptcp_sock {
 	u64		remote_key;
 	u64		write_seq;
 	u64		ack_seq;
+	atomic64_t	snd_una;
 	u32		token;
 	unsigned long	flags;
 	bool		can_ack;
-- 
2.26.0

