Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE22E8EBB
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfJ2Ryx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:54:53 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:56508 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfJ2Ryx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:54:53 -0400
Received: by mail-pg1-f201.google.com with SMTP id u4so11614108pgp.23
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 10:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=m7lZx9OalUeMZFtS674LSf3BS4xpvycgqF/OcJgKidw=;
        b=J9uht0dOvFtvylrazqb3bmncMn936RRfQvNEXzuuTqliY5IKcyOF3tTBPDbdovr8mV
         pFG4nf9H6vbeQZXjDBtXFieTrxv2rvzfvjuYRmU4dmEo+bFldtaoHK1KqykFZcJCTl+B
         +U6nfDwerYkkP7n+oTTMODNnrNbinopRKakYFsrlW9XqJYHc8s1AXrcxq7mrKYmfxU0D
         HkvgY1Vzm8+VCFJgqFbWxfvYTYUpwXtxoxyJEaSVm1eUDwewYWyyYPfs6mHxeVYFGe4J
         Zw00CfGavkkaa8h0GU0dUquZKaYHePCmGQMgnrmveojWSHYYKwvEJ4f2koHjOafDk9b2
         k/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=m7lZx9OalUeMZFtS674LSf3BS4xpvycgqF/OcJgKidw=;
        b=f2w+HEsIQ37xeR0jZ+nFVGRnqtV4/jHkzoj4CmLO6uc1hB9yVt8sKDATb1MOC+GiBb
         unB+sgwCpLvQqDnSR9hC/fZ+QrD6BYzWK1BiZab5MuAMq+3sXOhoOnhxcl5/Qy4mGBjc
         0qajS+mcX/Eh7n/yFNiKvGJyL9YlD/kycz3Ns43L3X/3vi2v+4dN5s/PcbIAY4TqupoS
         jRoqjRHdtd1Do1qR/nt1fsm6mPGLMQMtrWH4EDaGOdniAYrNnrFkpsrU0XcZQEuIf+l+
         g9xDRe57OoBuAcIN6P85+dlb8/5T3qaLYfAH1R/BEjPLJJ22nhQs66XYnx658Pujuqu5
         tc+Q==
X-Gm-Message-State: APjAAAULbpn4hwB1dEvOqUpBlgPWiY9vC/1yQ4hUvE+gczg8DxznJrNU
        ybSFT8FmDk5wqUMmUU2FydeqR6zovAuLkg==
X-Google-Smtp-Source: APXvYqx6sYppD9tEHCf44xp1l0AF3er0ct1FOfunhsD+lbRgATZr+wxkJoSyAvTd9BXMmGv4bgyj9KBj11e2tw==
X-Received: by 2002:a65:6903:: with SMTP id s3mr28014742pgq.195.1572371692235;
 Tue, 29 Oct 2019 10:54:52 -0700 (PDT)
Date:   Tue, 29 Oct 2019 10:54:44 -0700
Message-Id: <20191029175444.83564-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH net] net: annotate lockless accesses to sk->sk_napi_id
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We already annotated most accesses to sk->sk_napi_id

We missed sk_mark_napi_id() and sk_mark_napi_id_once()
which might be called without socket lock held in UDP stack.

KCSAN reported :
BUG: KCSAN: data-race in udpv6_queue_rcv_one_skb / udpv6_queue_rcv_one_skb

write to 0xffff888121c6d108 of 4 bytes by interrupt on cpu 0:
 sk_mark_napi_id include/net/busy_poll.h:125 [inline]
 __udpv6_queue_rcv_skb net/ipv6/udp.c:571 [inline]
 udpv6_queue_rcv_one_skb+0x70c/0xb40 net/ipv6/udp.c:672
 udpv6_queue_rcv_skb+0xb5/0x400 net/ipv6/udp.c:689
 udp6_unicast_rcv_skb.isra.0+0xd7/0x180 net/ipv6/udp.c:832
 __udp6_lib_rcv+0x69c/0x1770 net/ipv6/udp.c:913
 udpv6_rcv+0x2b/0x40 net/ipv6/udp.c:1015
 ip6_protocol_deliver_rcu+0x22a/0xbe0 net/ipv6/ip6_input.c:409
 ip6_input_finish+0x30/0x50 net/ipv6/ip6_input.c:450
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip6_input+0x177/0x190 net/ipv6/ip6_input.c:459
 dst_input include/net/dst.h:442 [inline]
 ip6_rcv_finish+0x110/0x140 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ipv6_rcv+0x1a1/0x1b0 net/ipv6/ip6_input.c:284
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5010
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5124
 process_backlog+0x1d3/0x420 net/core/dev.c:5955
 napi_poll net/core/dev.c:6392 [inline]
 net_rx_action+0x3ae/0xa90 net/core/dev.c:6460

write to 0xffff888121c6d108 of 4 bytes by interrupt on cpu 1:
 sk_mark_napi_id include/net/busy_poll.h:125 [inline]
 __udpv6_queue_rcv_skb net/ipv6/udp.c:571 [inline]
 udpv6_queue_rcv_one_skb+0x70c/0xb40 net/ipv6/udp.c:672
 udpv6_queue_rcv_skb+0xb5/0x400 net/ipv6/udp.c:689
 udp6_unicast_rcv_skb.isra.0+0xd7/0x180 net/ipv6/udp.c:832
 __udp6_lib_rcv+0x69c/0x1770 net/ipv6/udp.c:913
 udpv6_rcv+0x2b/0x40 net/ipv6/udp.c:1015
 ip6_protocol_deliver_rcu+0x22a/0xbe0 net/ipv6/ip6_input.c:409
 ip6_input_finish+0x30/0x50 net/ipv6/ip6_input.c:450
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip6_input+0x177/0x190 net/ipv6/ip6_input.c:459
 dst_input include/net/dst.h:442 [inline]
 ip6_rcv_finish+0x110/0x140 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ipv6_rcv+0x1a1/0x1b0 net/ipv6/ip6_input.c:284
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5010
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5124
 process_backlog+0x1d3/0x420 net/core/dev.c:5955

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 10890 Comm: syz-executor.0 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: e68b6e50fa35 ("udp: enable busy polling for all sockets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/busy_poll.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 127a5c4e369914814c3004d2701ebb5ae026ca95..86e028388badc46977bf6c05bd8f718d852c14a8 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -122,7 +122,7 @@ static inline void skb_mark_napi_id(struct sk_buff *skb,
 static inline void sk_mark_napi_id(struct sock *sk, const struct sk_buff *skb)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	sk->sk_napi_id = skb->napi_id;
+	WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
 #endif
 	sk_rx_queue_set(sk, skb);
 }
@@ -132,8 +132,8 @@ static inline void sk_mark_napi_id_once(struct sock *sk,
 					const struct sk_buff *skb)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	if (!sk->sk_napi_id)
-		sk->sk_napi_id = skb->napi_id;
+	if (!READ_ONCE(sk->sk_napi_id))
+		WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
 #endif
 }
 
-- 
2.24.0.rc0.303.g954a862665-goog

