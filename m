Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05CC934ADC
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfFDOry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:47:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42318 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727545AbfFDOrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 10:47:53 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BA6526D2F651EA5B57BA;
        Tue,  4 Jun 2019 22:47:50 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Tue, 4 Jun 2019 22:47:42 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net] tcp: avoid creating multiple req socks with the same tuples
Date:   Tue, 4 Jun 2019 22:55:43 +0800
Message-ID: <20190604145543.61624-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is one issue about bonding mode BOND_MODE_BROADCAST, and
two slaves with diffierent affinity, so packets will be handled
by different cpu. These are two pre-conditions in this case.

When two slaves receive the same syn packets at the same time,
two request sock(reqsk) will be created if below situation happens:
1. syn1 arrived tcp_conn_request, create reqsk1 and have not yet called
inet_csk_reqsk_queue_hash_add.
2. syn2 arrived tcp_v4_rcv, it goes to tcp_conn_request and create reqsk2
because it can't find reqsk1 in the __inet_lookup_skb.

Then reqsk1 and reqsk2 are added to establish hash table, and two synack with different
seq(seq1 and seq2) are sent to client, then tcp ack arrived and will be
processed in tcp_v4_rcv and tcp_check_req, if __inet_lookup_skb find the reqsk2, and
tcp ack packet is ack_seq is seq1, it will be failed after checking:
TCP_SKB_CB(skb)->ack_seq != tcp_rsk(req)->snt_isn + 1)
and then tcp rst will be sent to client and close the connection.

To fix this, do lookup before calling inet_csk_reqsk_queue_hash_add
to add reqsk2 to hash table, if it finds the existed reqsk1 with the same five tuples,
it removes reqsk2 and does not send synack to client.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 net/ipv4/tcp_input.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 08a477e74cf3..c75eeb1fe098 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6569,6 +6569,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		bh_unlock_sock(fastopen_sk);
 		sock_put(fastopen_sk);
 	} else {
+		struct sock *sk1 = req_to_sk(req);
+		struct sock *sk2 = NULL;
+		sk2 = __inet_lookup_established(sock_net(sk1), &tcp_hashinfo,
+									sk1->sk_daddr, sk1->sk_dport,
+									sk1->sk_rcv_saddr, sk1->sk_num,
+									inet_iif(skb),inet_sdif(skb));
+		if (sk2 != NULL)
+			goto drop_and_release;
+
 		tcp_rsk(req)->tfo_listener = false;
 		if (!want_cookie)
 			inet_csk_reqsk_queue_hash_add(sk, req,
-- 
2.20.1

