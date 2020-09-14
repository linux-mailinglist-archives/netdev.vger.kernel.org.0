Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5CA2686B9
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgINICv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:02:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726188AbgINICB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=18aD81rE/UZJpGysBh8fsfhfdES3An/9frFOw/W97vU=;
        b=VnKnzzrqJcsvv8g711NHZqZ6uo2mO0ftWpCRORRA02ywX3OKZqK3z4sUEyeIe+RJlZFqfW
        ca9oTYBIq8hpoIlJgnF1DQJr2WTeOAHWXrbQZfETEQ9BOVWXayQf6HM949vanKHq1n2HoC
        gabvHhe+p4Uc13ziwTis2K9w8+KzRbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-A1li_XdEPsauThpEVmI9ow-1; Mon, 14 Sep 2020 04:01:58 -0400
X-MC-Unique: A1li_XdEPsauThpEVmI9ow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF53018A2246;
        Mon, 14 Sep 2020 08:01:56 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F6F419C66;
        Mon, 14 Sep 2020 08:01:55 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next v2 12/13] mptcp: call tcp_cleanup_rbuf on subflows
Date:   Mon, 14 Sep 2020 10:01:18 +0200
Message-Id: <6b86efb4be6a098401b53a66ec49022bd1c7cfee.1599854632.git.pabeni@redhat.com>
In-Reply-To: <cover.1599854632.git.pabeni@redhat.com>
References: <cover.1599854632.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index d7af96a900c4..ef0dd2f23482 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -515,6 +515,8 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	} while (more_data_avail);
 
 	*bytes += moved;
+	if (moved)
+		tcp_cleanup_rbuf(ssk, moved);
 
 	return done;
 }
@@ -1424,10 +1426,14 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
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
index 8be401349d9f..a2ae3087e24d 100644
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

