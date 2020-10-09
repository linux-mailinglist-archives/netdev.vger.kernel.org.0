Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F8D288F6E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389975AbgJIRBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:01:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390015AbgJIRBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602262905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k3vedgNXsnPTRd8uDisAy0AqNRztast98ievxR3PENM=;
        b=hGGk9QV7LnG/DUmMZfvwQ/DDFNVA0UCtCbPyo+N3yCs17Z2YrY7g5yzKv4tk1sGvrE/mIK
        LLPXYx+vF6XENy9NEc4lvjRLv0EHTYtHTIh6/5yMRE0c4z/6PUrlSQC4xHelOhRodO9Yl2
        CtKdT4MgM7R57t6Yf/GoY1Iz53zsB+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-z7MgUgq3NxOufN1UyLXTlQ-1; Fri, 09 Oct 2020 13:01:39 -0400
X-MC-Unique: z7MgUgq3NxOufN1UyLXTlQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 584BC1084D87;
        Fri,  9 Oct 2020 17:01:17 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-111.ams2.redhat.com [10.36.114.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2728D76642;
        Fri,  9 Oct 2020 17:01:15 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 1/2] mptcp: fix fallback for MP_JOIN subflows
Date:   Fri,  9 Oct 2020 19:00:00 +0200
Message-Id: <d12d2628b07bb883e53a9b16a74802363326a432.1602262630.git.pabeni@redhat.com>
In-Reply-To: <cover.1602262630.git.pabeni@redhat.com>
References: <cover.1602262630.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Additional/MP_JOIN subflows that do not pass some initial handshake
tests currently causes fallback to TCP. That is an RFC violation:
we should instead reset the subflow and leave the the msk untouched.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/91
Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c  | 32 +++++++++++++++++++++++++-------
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 10 ++++++++--
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 888bbbbb3e8a..277f12633fc9 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -626,6 +626,12 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 	if (unlikely(mptcp_check_fallback(sk)))
 		return false;
 
+	/* prevent adding of any MPTCP related options on reset packet
+	 * until we support MP_TCPRST/MP_FASTCLOSE
+	 */
+	if (unlikely(skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_RST))
+		return false;
+
 	if (mptcp_established_options_mp(sk, skb, &opt_size, remaining, opts))
 		ret = true;
 	else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
@@ -676,7 +682,7 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 	return false;
 }
 
-static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
+static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 				    struct mptcp_subflow_context *subflow,
 				    struct sk_buff *skb,
 				    struct mptcp_options_received *mp_opt)
@@ -693,15 +699,20 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
 		    TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq &&
 		    subflow->mp_join && mp_opt->mp_join &&
 		    READ_ONCE(msk->pm.server_side))
-			tcp_send_ack(sk);
+			tcp_send_ack(ssk);
 		goto fully_established;
 	}
 
-	/* we should process OoO packets before the first subflow is fully
-	 * established, but not expected for MP_JOIN subflows
+	/* we must process OoO packets before the first subflow is fully
+	 * established. OoO packets are instead a protocol violation
+	 * for MP_JOIN subflows as the peer must not send any data
+	 * before receiving the forth ack - cfr. RFC 8684 section 3.2.
 	 */
-	if (TCP_SKB_CB(skb)->seq != subflow->ssn_offset + 1)
+	if (TCP_SKB_CB(skb)->seq != subflow->ssn_offset + 1) {
+		if (subflow->mp_join)
+			goto reset;
 		return subflow->mp_capable;
+	}
 
 	if (mp_opt->dss && mp_opt->use_ack) {
 		/* subflows are fully established as soon as we get any
@@ -713,9 +724,12 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
 	}
 
 	/* If the first established packet does not contain MP_CAPABLE + data
-	 * then fallback to TCP
+	 * then fallback to TCP. Fallback scenarios requires a reset for
+	 * MP_JOIN subflows.
 	 */
 	if (!mp_opt->mp_capable) {
+		if (subflow->mp_join)
+			goto reset;
 		subflow->mp_capable = 0;
 		pr_fallback(msk);
 		__mptcp_do_fallback(msk);
@@ -732,12 +746,16 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
 
 	subflow->pm_notified = 1;
 	if (subflow->mp_join) {
-		clear_3rdack_retransmission(sk);
+		clear_3rdack_retransmission(ssk);
 		mptcp_pm_subflow_established(msk, subflow);
 	} else {
 		mptcp_pm_fully_established(msk);
 	}
 	return true;
+
+reset:
+	mptcp_subflow_reset(ssk);
+	return false;
 }
 
 static u64 expand_ack(u64 old_ack, u64 cur_ack, bool use_64bit)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 20f04ac85409..0a6e5b3f6ae8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -348,6 +348,7 @@ void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool mptcp_subflow_data_available(struct sock *sk);
 void __init mptcp_subflow_init(void);
+void mptcp_subflow_reset(struct sock *ssk);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, int ifindex,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6f035af1c9d2..b1b8028730bf 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -270,6 +270,13 @@ static bool subflow_thmac_valid(struct mptcp_subflow_context *subflow)
 	return thmac == subflow->thmac;
 }
 
+void mptcp_subflow_reset(struct sock *ssk)
+{
+	tcp_set_state(ssk, TCP_CLOSE);
+	tcp_send_active_reset(ssk, GFP_ATOMIC);
+	tcp_done(ssk);
+}
+
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
@@ -342,8 +349,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	return;
 
 do_reset:
-	tcp_send_active_reset(sk, GFP_ATOMIC);
-	tcp_done(sk);
+	mptcp_subflow_reset(sk);
 }
 
 struct request_sock_ops mptcp_subflow_request_sock_ops;
-- 
2.26.2

