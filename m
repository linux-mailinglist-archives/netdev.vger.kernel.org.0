Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DAC2661D6
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgIKPJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:09:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726359AbgIKPH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599836815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8d8Yue3gHOEQjIrA3mwKO+P2SVxFJw/VIyJ/pkBuTUg=;
        b=ZWrb6GDPhnV9D4m+nAPZfORm61MyDsKy1OrxP9WcNOYBE1co6LKtMsWl6DOz2tPH1G1sJm
        pv1aOg+WXpzXhvDPxyV+w3Ci4cCplotnWYWvrQ2tIlHfgEoU7Ok6PnsjIffYwUgsnEX21D
        eS/S9HWgzynnLzrizImPSM2ZEFD6mcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-UhnvV6leOkuVmZqU54znFQ-1; Fri, 11 Sep 2020 09:52:47 -0400
X-MC-Unique: UhnvV6leOkuVmZqU54znFQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF7B41091064;
        Fri, 11 Sep 2020 13:52:45 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-214.ams2.redhat.com [10.36.114.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3BAE5C22A;
        Fri, 11 Sep 2020 13:52:44 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 12/13] mptcp: call tcp_cleanup_rbuf on subflows
Date:   Fri, 11 Sep 2020 15:52:07 +0200
Message-Id: <c3bd57834ebaf9030e6021c5bd51d169c995ab64.1599832097.git.pabeni@redhat.com>
In-Reply-To: <cover.1599832097.git.pabeni@redhat.com>
References: <cover.1599832097.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That is needed to let the subflows announce promptly when new
space is available in the receive buffer.

tcp_cleanup_rbuf() is currently a static function, drop the
scope modifier and add a declaration in the TCP header.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/tcp.h    | 2 ++
 net/ipv4/tcp.c       | 2 +-
 net/mptcp/protocol.c | 6 ++++++
 net/mptcp/subflow.c  | 2 ++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e85d564446c6..852f0d71dd40 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1414,6 +1414,8 @@ static inline int tcp_full_space(const struct sock *sk)
 	return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf));
 }
 
+void tcp_cleanup_rbuf(struct sock *sk, int copied);
+
 /* We provision sk_rcvbuf around 200% of sk_rcvlowat.
  * If 87.5 % (7/8) of the space has been consumed, we want to override
  * SO_RCVLOWAT constraint, since we are receiving skbs with too small
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 57a568875539..d3781b6087cb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1527,7 +1527,7 @@ static int tcp_peek_sndq(struct sock *sk, struct msghdr *msg, int len)
  * calculation of whether or not we must ACK for the sake of
  * a window update.
  */
-static void tcp_cleanup_rbuf(struct sock *sk, int copied)
+void tcp_cleanup_rbuf(struct sock *sk, int copied)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool time_to_ack = false;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 148c4e685ecd..a17e534a1425 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -515,6 +515,8 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	} while (more_data_avail);
 
 	*bytes += moved;
+	if (moved)
+		tcp_cleanup_rbuf(ssk, moved);
 
 	return done;
 }
@@ -1422,10 +1424,14 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 			 */
 			mptcp_for_each_subflow(msk, subflow) {
 				struct sock *ssk;
+				bool slow;
 
 				ssk = mptcp_subflow_tcp_sock(subflow);
+				slow = lock_sock_fast(ssk);
 				WRITE_ONCE(ssk->sk_rcvbuf, rcvbuf);
 				tcp_sk(ssk)->window_clamp = window_clamp;
+				tcp_cleanup_rbuf(ssk, 1);
+				unlock_sock_fast(ssk, slow);
 			}
 		}
 	}
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 58f2349930a5..fb59bbd9b4cc 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -823,6 +823,8 @@ static void mptcp_subflow_discard_data(struct sock *ssk, struct sk_buff *skb,
 		sk_eat_skb(ssk, skb);
 	if (mptcp_subflow_get_map_offset(subflow) >= subflow->map_data_len)
 		subflow->map_valid = 0;
+	if (incr)
+		tcp_cleanup_rbuf(ssk, incr);
 }
 
 static bool subflow_check_data_avail(struct sock *ssk)
-- 
2.26.2

