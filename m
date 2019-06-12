Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADDD42CC1
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440341AbfFLQxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:53:01 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:36941 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438136AbfFLQxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:53:01 -0400
Received: by mail-yb1-f201.google.com with SMTP id z4so16054170ybo.4
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V9DdxJgbt/QiyL9t6RZM+Hgl+yyrC1LTFsD1NIZdXis=;
        b=h4cti1+zluxcrFfwTlBUWExWs32pqz20r4ApejygRlv4dgowLiWOzb6ZKhFPsl1PJp
         zfZ3EI0z2GwxGAcJy6KRw7xkewcg+zHDLR3XoYMNt/T5D6AvifweKE4e3B127VGeiJdN
         0KsVyD6Ug3xeDpJa4Wzeob4h0chtnNk5rpAmoDsyAvm7xCn7usJVfZXOpy01T0ffAu6F
         inTw4Qp01L5XtB1rnWFtY248Gp5vd0e7gdK34Eop+2jMckjDsWqzqnD6NzxQn6YmrM0O
         ByUatWqd3rxr0N0eYlxFRBiq/v3xChACP3nH/WXQfZMNJjSWXvIslI2TSuDVS5Kbqz0V
         c3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V9DdxJgbt/QiyL9t6RZM+Hgl+yyrC1LTFsD1NIZdXis=;
        b=hMxG2f09T653LYbKwVzsROUdeZ+bE74zKAKDM8+JKtWH64C3PC3AQwTYDpin+lOjEZ
         dEdYaL2bYO82mpTFJNFdFYeIJIfN1a9AcWiAPmqMOqsi1nU5amC+FkBwdqt5YlY9Q8vY
         ArR8wsabzY5cG8X6khVubD4K9ynzi99L2pTdyW15t7c6qMa7KyUllp7ilR+edLt9Jr3Y
         db3jLxXuutCY/uuOCDy4IpbUWVI5RAKWkmITVggs3mUe+7vxRaalsVz0u1X33TTagcce
         5/SM8APmTDv8sRORHQ6ufv8OC/PNl0m+1pLYCHx18IB/WmcV/F9XBWt31tWqrI2WfD0g
         Ke+A==
X-Gm-Message-State: APjAAAUDmNAL1W3aVdrJ1dNZ28mHGlmQ6YR+cQFlkmQA/tqeZQqxSrrN
        DKXh/bdpSbd60vPHCOlBn7WQ9Tung3rkjA==
X-Google-Smtp-Source: APXvYqx4FWdGJyBW+EgArVyniDJeVHSo3RD1A9eSAdEEnItnt6Yw+Rbva2xYc2HaSnQG0D/kEZzl5u1KKUc6Tg==
X-Received: by 2002:a25:cac2:: with SMTP id a185mr38919629ybg.489.1560358380466;
 Wed, 12 Jun 2019 09:53:00 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:32 -0700
In-Reply-To: <20190612165233.109749-1-edumazet@google.com>
Message-Id: <20190612165233.109749-8-edumazet@google.com>
Mime-Version: 1.0
References: <20190612165233.109749-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next 7/8] net/packet: remove locking from packet_rcv_has_room()
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

__packet_rcv_has_room() can now be run without lock being held.

po->pressure is only a non persistent hint, we can mark
all read/write accesses with READ_ONCE()/WRITE_ONCE()
to document the fact that the field could be written
without any synchronization.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 860ca3e6abf5198214612e9acc095530b61dac40..d409e2fdaa7ee8ddf261354f91b682e403f40e9e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1260,15 +1260,13 @@ static int __packet_rcv_has_room(const struct packet_sock *po,
 
 static int packet_rcv_has_room(struct packet_sock *po, struct sk_buff *skb)
 {
-	int ret;
-	bool has_room;
+	int pressure, ret;
 
-	spin_lock_bh(&po->sk.sk_receive_queue.lock);
 	ret = __packet_rcv_has_room(po, skb);
-	has_room = ret == ROOM_NORMAL;
-	if (po->pressure == has_room)
-		po->pressure = !has_room;
-	spin_unlock_bh(&po->sk.sk_receive_queue.lock);
+	pressure = ret != ROOM_NORMAL;
+
+	if (READ_ONCE(po->pressure) != pressure)
+		WRITE_ONCE(po->pressure, pressure);
 
 	return ret;
 }
@@ -1353,7 +1351,7 @@ static unsigned int fanout_demux_rollover(struct packet_fanout *f,
 	i = j = min_t(int, po->rollover->sock, num - 1);
 	do {
 		po_next = pkt_sk(f->arr[i]);
-		if (po_next != po_skip && !po_next->pressure &&
+		if (po_next != po_skip && !READ_ONCE(po_next->pressure) &&
 		    packet_rcv_has_room(po_next, skb) == ROOM_NORMAL) {
 			if (i != j)
 				po->rollover->sock = i;
@@ -3310,7 +3308,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (skb == NULL)
 		goto out;
 
-	if (pkt_sk(sk)->pressure)
+	if (READ_ONCE(pkt_sk(sk)->pressure))
 		packet_rcv_has_room(pkt_sk(sk), NULL);
 
 	if (pkt_sk(sk)->has_vnet_hdr) {
@@ -4129,8 +4127,8 @@ static __poll_t packet_poll(struct file *file, struct socket *sock,
 			TP_STATUS_KERNEL))
 			mask |= EPOLLIN | EPOLLRDNORM;
 	}
-	if (po->pressure && __packet_rcv_has_room(po, NULL) == ROOM_NORMAL)
-		po->pressure = 0;
+	if (READ_ONCE(po->pressure) && __packet_rcv_has_room(po, NULL) == ROOM_NORMAL)
+		WRITE_ONCE(po->pressure, 0);
 	spin_unlock_bh(&sk->sk_receive_queue.lock);
 	spin_lock_bh(&sk->sk_write_queue.lock);
 	if (po->tx_ring.pg_vec) {
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

