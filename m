Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E599142CC2
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440344AbfFLQxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:53:05 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:47265 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438136AbfFLQxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:53:04 -0400
Received: by mail-yw1-f73.google.com with SMTP id 77so18015474ywp.14
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/bpL9FRxRuXR/AjyrwWtGORRrKaLCeMbOPqzYKGp0oA=;
        b=A9FL+DweVCxZ/AW5Ect7mYp9NIrJSk1dd1cvmTaU5R8BewCg5Wm3LCFdh/z8TNewI8
         Z53AgOZklc2202kvq9hfi35IB8TrQbQ5HKNNzFAffpydLDfWKIbBcUfODw2Aa9a4R0d7
         4Df1esVLcDqFobDfKMb80Cx3AXcsrQHeStpu86yfF1J+XMX3oXDKCbR1wxYsvQ0E67WN
         TA6SQ01Tmjpb4xYXtc+uWLjNVNigXvx0kbYdtHlRxM20TvGA4h68g3OxnRLzV1sD+dES
         XvQMEBKE2PWqfPGF9JNVChfhuogtes+fh6115Bi2wG6DHabka1YnZImXO0+vlmmTrzqm
         ZZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/bpL9FRxRuXR/AjyrwWtGORRrKaLCeMbOPqzYKGp0oA=;
        b=FiHwxGJ7T7MCpO2i/7ldW2geydO6Vi+x8pL0jcHlxnGS4xs9LV+7hAJ/NjFevZAEHK
         thelHaHmIuh+cq5ZFzus+xsSy4Fv/TD/0auSyRHhJ96PNc3H+a8UjWH9OJph5qjhwX3e
         SRGOBt1ZqF3PFQ5cDOL6Z6m03aFAtWm3xtQ0tpXboimf/NyHqqWXR6ZlMC2+NrEnbrWc
         uiAqBWcevOZhRr6oi0ZwFn5KPEXNyQuhex1DQ9640IQp6sBKRj9WoL/70rXOVE2VybRr
         U9kO2OIW/Ld8n4TraVAoyEVw3Z8wJk0/wdHm59qGBT/NMLn+JH/Z8ogMAHpVXIHJCQY6
         lXsg==
X-Gm-Message-State: APjAAAVIWXDkUlCvJF0rXauyoH8v4MqVEIUPNXvrLztry27r+IlQ61nl
        Js6Cbus19eGfHgT9n7An0Sm/G8ljj0VvUg==
X-Google-Smtp-Source: APXvYqz9ZY+pdcTorNe/S8NV3mi1n+Ie4Vwf1zD/BUsaAXAS9lZt3SoyHxhLejlCK4Y6+aqD7PWWYGTmc8k9wQ==
X-Received: by 2002:a25:1542:: with SMTP id 63mr41059242ybv.6.1560358383515;
 Wed, 12 Jun 2019 09:53:03 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:33 -0700
In-Reply-To: <20190612165233.109749-1-edumazet@google.com>
Message-Id: <20190612165233.109749-9-edumazet@google.com>
Mime-Version: 1.0
References: <20190612165233.109749-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next 8/8] net/packet: introduce packet_rcv_try_clear_pressure()
 helper
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two places where we want to clear the pressure
if possible, add a helper to make it more obvious.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Willem de Bruijn <willemb@google.com>
---
 net/packet/af_packet.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d409e2fdaa7ee8ddf261354f91b682e403f40e9e..8c27e198268ab5148daa8e90aa2f53546623b9ed 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1271,6 +1271,13 @@ static int packet_rcv_has_room(struct packet_sock *po, struct sk_buff *skb)
 	return ret;
 }
 
+static void packet_rcv_try_clear_pressure(struct packet_sock *po)
+{
+	if (READ_ONCE(po->pressure) &&
+	    __packet_rcv_has_room(po, NULL) == ROOM_NORMAL)
+		WRITE_ONCE(po->pressure,  0);
+}
+
 static void packet_sock_destruct(struct sock *sk)
 {
 	skb_queue_purge(&sk->sk_error_queue);
@@ -3308,8 +3315,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (skb == NULL)
 		goto out;
 
-	if (READ_ONCE(pkt_sk(sk)->pressure))
-		packet_rcv_has_room(pkt_sk(sk), NULL);
+	packet_rcv_try_clear_pressure(pkt_sk(sk));
 
 	if (pkt_sk(sk)->has_vnet_hdr) {
 		err = packet_rcv_vnet(msg, skb, &len);
@@ -4127,8 +4133,7 @@ static __poll_t packet_poll(struct file *file, struct socket *sock,
 			TP_STATUS_KERNEL))
 			mask |= EPOLLIN | EPOLLRDNORM;
 	}
-	if (READ_ONCE(po->pressure) && __packet_rcv_has_room(po, NULL) == ROOM_NORMAL)
-		WRITE_ONCE(po->pressure, 0);
+	packet_rcv_try_clear_pressure(po);
 	spin_unlock_bh(&sk->sk_receive_queue.lock);
 	spin_lock_bh(&sk->sk_write_queue.lock);
 	if (po->tx_ring.pg_vec) {
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

