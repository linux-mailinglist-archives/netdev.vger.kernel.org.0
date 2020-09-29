Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F6727DB6E
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgI2WI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:08:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:6058 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgI2WI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:08:27 -0400
IronPort-SDR: t0wCguem7OXiMqWjDyuCd2AzyxQoHJUYggmx4QB46Uk4qeiCm9fI+F4WosOOjctOh0Dfrpncu+
 0UFvcg0/ffpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="223900088"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="223900088"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 15:08:26 -0700
IronPort-SDR: wIS71QTGKGoj4OI2m9fvE2itDUMhd+JVpcDLU+znUDsgNi5RLEQN1+7/SKH4PlcrfVY8QjcOE6
 3fvzVlt0d3LQ==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="312368804"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.88.125])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 15:08:25 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, pabeni@redhat.com
Subject: [PATCH net 1/2] mptcp: Consistently use READ_ONCE/WRITE_ONCE with msk->ack_seq
Date:   Tue, 29 Sep 2020 15:08:19 -0700
Message-Id: <20200929220820.278003-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929220820.278003-1-mathew.j.martineau@linux.intel.com>
References: <20200929220820.278003-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The msk->ack_seq value is sometimes read without the msk lock held, so
make proper use of READ_ONCE and WRITE_ONCE.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 4 ++--
 net/mptcp/protocol.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 7fa822b55c34..120ef39fe589 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -518,11 +518,11 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 
 	if (subflow->use_64bit_ack) {
 		ack_size = TCPOLEN_MPTCP_DSS_ACK64;
-		opts->ext_copy.data_ack = msk->ack_seq;
+		opts->ext_copy.data_ack = READ_ONCE(msk->ack_seq);
 		opts->ext_copy.ack64 = 1;
 	} else {
 		ack_size = TCPOLEN_MPTCP_DSS_ACK32;
-		opts->ext_copy.data_ack32 = (uint32_t)(msk->ack_seq);
+		opts->ext_copy.data_ack32 = (uint32_t)READ_ONCE(msk->ack_seq);
 		opts->ext_copy.ack64 = 0;
 	}
 	opts->ext_copy.use_ack = 1;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 365ba96c84b0..5d747c6a610e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -123,7 +123,7 @@ static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 
 	skb_ext_reset(skb);
 	skb_orphan(skb);
-	msk->ack_seq += copy_len;
+	WRITE_ONCE(msk->ack_seq, msk->ack_seq + copy_len);
 
 	tail = skb_peek_tail(&sk->sk_receive_queue);
 	if (offset == 0 && tail) {
@@ -261,7 +261,7 @@ static void mptcp_check_data_fin(struct sock *sk)
 	if (mptcp_pending_data_fin(sk, &rcv_data_fin_seq)) {
 		struct mptcp_subflow_context *subflow;
 
-		msk->ack_seq++;
+		WRITE_ONCE(msk->ack_seq, msk->ack_seq + 1);
 		WRITE_ONCE(msk->rcv_data_fin, 0);
 
 		sk->sk_shutdown |= RCV_SHUTDOWN;
@@ -1720,7 +1720,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 		msk->remote_key = mp_opt->sndr_key;
 		mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
 		ack_seq++;
-		msk->ack_seq = ack_seq;
+		WRITE_ONCE(msk->ack_seq, ack_seq);
 	}
 
 	sock_reset_flag(nsk, SOCK_RCU_FREE);
@@ -2072,7 +2072,7 @@ bool mptcp_finish_join(struct sock *sk)
 	parent_sock = READ_ONCE(parent->sk_socket);
 	if (parent_sock && !sk->sk_socket)
 		mptcp_sock_graft(sk, parent_sock);
-	subflow->map_seq = msk->ack_seq;
+	subflow->map_seq = READ_ONCE(msk->ack_seq);
 	return true;
 }
 
-- 
2.28.0

