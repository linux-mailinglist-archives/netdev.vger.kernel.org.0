Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F25818C0B5
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCSTuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:50:03 -0400
Received: from mail-pj1-f73.google.com ([209.85.216.73]:58712 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCSTuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 15:50:02 -0400
Received: by mail-pj1-f73.google.com with SMTP id r42so2396660pjb.8
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 12:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XT4x4JQMOqj28IN9OvTrKae936apFzRtQmeyO1heFao=;
        b=dGMpdlx7E2h9/MoeV6GZVnVsS1w+uPT4jfiwyOjNqBNIsjUVClUHlOW6JM1nGKdUav
         +e8OtTe6CmbKXsyfGwbPuztx4Y9kJDmYEcuBFQo8pM2rRGJFSvEQczqHgtyAPJ/Jzrvs
         LGnZolXv1cHl87vyjC6FV3mvPCOW/s/luy3LvGFWFTN5GYt6XDXXG8rzYUDZLl+yKdBT
         aILOAD0FeDq1J5fN8DRGjU2GDZEkQzKzlfGi5vT1bxPD5XZhWFHz4fAIFW4Q3BYoI+lR
         MwJvQZbAoOz+v7tD+8eYxw+7am1Iww+/16+6T2vRq228Eb9hos23y/l87lEeoFTuvyli
         5OpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XT4x4JQMOqj28IN9OvTrKae936apFzRtQmeyO1heFao=;
        b=dOdcA5bpo6wM1s+tpRedToLjQrmR/da6ZkvGhlakuU3GXZopAeM/qStyuPik7B331r
         YsqKLT+A2vXR8WKO6jKoyQqRIcUA4uf7HQDiYHifgpOMsWrefuKBQyfJOHQhJz05cgNb
         X2bGA/qMyMu+sY9Pa2huaURhC8qXBoHWP3OtkQ4Gcz3V1jB9h0fiX+lvbucE22LX9V6R
         SrEeNQ5hstxQdTFpaReViT40l0nPiuv3S1fZYaEKTeIVHi72abbrvA17Ie6hMvjR5alX
         4FJ3A6tByb1HfBt9VdMlikHROkcLqKys3ShFgA0ljzICwJMObdFHkggnuf61iFzB28B7
         10Aw==
X-Gm-Message-State: ANhLgQ30MUeU6PMGge9yila0UUFzjopnXQ7aIyEO3nw2ZC1xK3nTNq/1
        0p3tn/gU34GWvQNytbedtfx7aIf/yUwoiA==
X-Google-Smtp-Source: ADFU+vsWNAaP/bb+n0K+3pud/Mub++NuJBA1r1o7ZZXgd7J/NCReLyYgDfolKQk2qIFgDMGoCCQBww0Xz0CDjw==
X-Received: by 2002:a17:90b:3849:: with SMTP id nl9mr5344507pjb.86.1584647399277;
 Thu, 19 Mar 2020 12:49:59 -0700 (PDT)
Date:   Thu, 19 Mar 2020 12:49:55 -0700
Message-Id: <20200319194955.13742-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
Subject: [PATCH net] tcp: ensure skb->dev is NULL before leaving TCP stack
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Zaharinov <micron10@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->rbnode is sharing three skb fields : next, prev, dev

When a packet is sent, TCP keeps the original skb (master)
in a rtx queue, which was converted to rbtree a while back.

__tcp_transmit_skb() is responsible to clone the master skb,
and add the TCP header to the clone before sending it
to network layer.

skb_clone() already clears skb->next and skb->prev, but copies
the master oskb->dev into the clone.

We need to clear skb->dev, otherwise lower layers could interpret
the value as a pointer to a netdev.

This old bug surfaced recently when commit 28f8bfd1ac94
("netfilter: Support iif matches in POSTROUTING") was merged.

Before this netfilter commit, skb->dev value was ignored and
changed before reaching dev_queue_xmit()

Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Fixes: 28f8bfd1ac94 ("netfilter: Support iif matches in POSTROUTING")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Martin Zaharinov <micron10@gmail.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/tcp_output.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 306e25d743e8de1bfe23d6e3b3a9fb0f23664912..e8cf8fde3d37dc3b455224d33d0bde0e585f989e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1109,6 +1109,10 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 
 		if (unlikely(!skb))
 			return -ENOBUFS;
+		/* retransmit skbs might have a non zero value in skb->dev
+		 * because skb->dev is aliased with skb->rbnode.rb_left
+		 */
+		skb->dev = NULL;
 	}
 
 	inet = inet_sk(sk);
-- 
2.25.1.696.g5e7596f4ac-goog

