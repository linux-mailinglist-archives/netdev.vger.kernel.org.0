Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A86212CBB
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 13:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfECLr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 07:47:26 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:33444 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfECLrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 07:47:25 -0400
Received: by mail-pf1-f201.google.com with SMTP id i23so2944433pfa.0
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 04:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/aOckwvXfGOhkK/7hAjfa9aCeu89Q47aJasv0lr/Suc=;
        b=qK4a+UIhVxcrXZFAM9B76C46K6u6NBwD5rzZV6WjbzDObIZ2nU+vqwdhfNhzSwtXG/
         sM6VbqsiYbxTTGMUphgRXJ5LHoG5lBlv2CCPN6aRKH7slVNBRRfayASpaL2nKiTV4x2V
         IFLiCdZBkKQhIy8toOyzTdqPFCG/Enl58ajBdBHvTWrYuMAEJsOoBqtFCdItusXWBUhN
         G2cXRYAwpb4ooWvDMnqIww8zEh8eyHra9glB6ls39xlDV3VbnZBNDp+XIhuetMUn9B7z
         fi9hcy4wiR9UCbV7kCLgZtVvuCzDXvdeIpA/9N3aVY1cRSrywjVSWeF4VhtsnJ4Roi9n
         WeGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/aOckwvXfGOhkK/7hAjfa9aCeu89Q47aJasv0lr/Suc=;
        b=Dr4gJgFfQcuYqNg+AAsF/Fbm3KiK/Zx78a9PB4+yg2ZYKAGtydUG5WV1R2qnhKsNAa
         Lr/3hjgFuRAk1Yzff8dJK6VLa8bF8pREAE4ptnYyvbaAolWIs/g5tomyAXfmThOivwYt
         qrASlTtQPqzkowIOM68Q9w2iYVMGyqiFrDGyORrL5SGdLTDTH9O62jkxxJZuU2pMVucx
         qxcrwNMfomv8pUABZnMc89svfZcqQwKyFcKDg6iG54CUvjuvNcg9z61/yeNCgadBVooE
         HsToJxpe0EVQiDQhVBc5Mcpl2k0BTdFSAie1eTn1HIob01LT/2KSMnKUBNgQOjSktvvL
         tF0A==
X-Gm-Message-State: APjAAAXh6OkP9Md7SUc9kDYevQD6Nk0Hn+74q3MmmJ5MX+uZFgFzJCjG
        TW6UcP5dH9F6uCCcKXD19anmXncMct434w==
X-Google-Smtp-Source: APXvYqxYzRv5+QXm5zzZbjozwGf/ux8ZkKlUxQtZFt5PTqB0n7vPMQqQ0uR66TOYg+VvYNFdMQmHU8LbwbIJvw==
X-Received: by 2002:a63:8342:: with SMTP id h63mr9853727pge.251.1556884044438;
 Fri, 03 May 2019 04:47:24 -0700 (PDT)
Date:   Fri,  3 May 2019 04:47:21 -0700
Message-Id: <20190503114721.10502-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net] ip6: fix skb leak in ip6frag_expire_frag_queue()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stfan Bader <stefan.bader@canonical.com>,
        Peter Oskolkov <posk@google.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since ip6frag_expire_frag_queue() now pulls the head skb
from frag queue, we should no longer use skb_get(), since
this leads to an skb leak.

Stefan Bader initially reported a problem in 4.4.stable [1] caused
by the skb_get(), so this patch should also fix this issue.

296583.091021] kernel BUG at /build/linux-6VmqmP/linux-4.4.0/net/core/skbuff.c:1207!
[296583.091734] Call Trace:
[296583.091749]  [<ffffffff81740e50>] __pskb_pull_tail+0x50/0x350
[296583.091764]  [<ffffffff8183939a>] _decode_session6+0x26a/0x400
[296583.091779]  [<ffffffff817ec719>] __xfrm_decode_session+0x39/0x50
[296583.091795]  [<ffffffff818239d0>] icmpv6_route_lookup+0xf0/0x1c0
[296583.091809]  [<ffffffff81824421>] icmp6_send+0x5e1/0x940
[296583.091823]  [<ffffffff81753238>] ? __netif_receive_skb+0x18/0x60
[296583.091838]  [<ffffffff817532b2>] ? netif_receive_skb_internal+0x32/0xa0
[296583.091858]  [<ffffffffc0199f74>] ? ixgbe_clean_rx_irq+0x594/0xac0 [ixgbe]
[296583.091876]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_defrag_ipv6]
[296583.091893]  [<ffffffff8183d431>] icmpv6_send+0x21/0x30
[296583.091906]  [<ffffffff8182b500>] ip6_expire_frag_queue+0xe0/0x120
[296583.091921]  [<ffffffffc04eb27f>] nf_ct_frag6_expire+0x1f/0x30 [nf_defrag_ipv6]
[296583.091938]  [<ffffffff810f3b57>] call_timer_fn+0x37/0x140
[296583.091951]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_defrag_ipv6]
[296583.091968]  [<ffffffff810f5464>] run_timer_softirq+0x234/0x330
[296583.091982]  [<ffffffff8108a339>] __do_softirq+0x109/0x2b0

Fixes: d4289fcc9b16 ("net: IP6 defrag: use rbtrees for IPv6 defrag")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Stfan Bader <stefan.bader@canonical.com>
Cc: Peter Oskolkov <posk@google.com>
Cc: Florian Westphal <fw@strlen.de>
---
 include/net/ipv6_frag.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index 28aa9b30aeceac9a86ee6754e4b5809be115e947..1f77fb4dc79df6bc4e41d6d2f4d49ace32082ca4 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -94,7 +94,6 @@ ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
 		goto out;
 
 	head->dev = dev;
-	skb_get(head);
 	spin_unlock(&fq->q.lock);
 
 	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
-- 
2.21.0.1020.gf2820cf01a-goog

