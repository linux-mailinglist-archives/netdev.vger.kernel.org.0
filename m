Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9C813118
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfECPYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:24:51 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:55937 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfECPYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:24:51 -0400
Received: by mail-qk1-f201.google.com with SMTP id l4so6010447qke.22
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 08:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YzeitDl0vUNHApyuf2zqzRmiNwBg1eEjPTcYVVvX93I=;
        b=lUOuHLD0HFvojlSxvSiAiNF1CDE+PQvkL0SUKlVwHi5GMBYCc+uqykEUAnHbeVDCdY
         TuXSruYn2JCIDlSZ4rwg6z7UDOQ5uz2nF6urz4wHfOj9Amwk2S4MeMstQgMZbSQVc2i9
         yOSUcA3GMwUpqeFoRqngGm7IWw0ehbVRXh6y8y6WxOBgwcZRUxSUfaH2YpIq8ZuXSYoF
         z2MfIMYpDcbDoDZer/216n2oIaeOplWgmb8KtYF+BlbncxdexJboBB5T+W6G0fWazoop
         YVrygCeTYTIpJIBbpXEjhvN+vIi79VWKdGRbQbz6hZZdtWDMOz79AIyjxzYbBJzLO1OI
         9A0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YzeitDl0vUNHApyuf2zqzRmiNwBg1eEjPTcYVVvX93I=;
        b=XprYdGoPVgEXD18mg9jwN1xol8iTHTQi0RtcLFgISYL5vhhjiWpx1SI4wEzz3dv6m6
         CKjGfsxM7EGQXs7cGYJ0TR7q5wYnYanqvKBPuThYfNyRgrwgrM1/hE3T0gQDPJ0Y4SAe
         /tNt5SVvjGcttMEoo2M+aDqf5j9Y8rG9KwCcqVTKK4h+99SwS/5H9McDfab5bNwmk6t6
         hqeADM5O9sA13Xu2q3WimAcD6VHtcZ6GTTow/1vj9OaJse0Tf+mjYQNNSdgUByj4wRKV
         A2qjVidpAVXtxd77kHhoHEHV6F099GVpJje+Ev6HtBBe9izf7TQ+DqYVin4IO0vg028u
         sR5A==
X-Gm-Message-State: APjAAAWs7CNGT03qujbl1/8rUu9PApokFMj4kqF8Ry8ubZ+H9f9/lnM2
        F6oYBsxRkGgMJLv94+PCyMAE+Wrf2Smn/w==
X-Google-Smtp-Source: APXvYqyxEmr0F6/x6Vt/W1CdL9DFi2fQ/fxPntIL4KINHco6X74qrY/P30jh4IJrtUrUoTlQlK4UVwMMli+vJA==
X-Received: by 2002:a05:620a:14a7:: with SMTP id x7mr3049752qkj.215.1556897089964;
 Fri, 03 May 2019 08:24:49 -0700 (PDT)
Date:   Fri,  3 May 2019 08:24:44 -0700
Message-Id: <20190503152444.122630-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v2 net] ip6: fix skb leak in ip6frag_expire_frag_queue()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stefan Bader <stefan.bader@canonical.com>,
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
Reported-by: Stefan Bader <stefan.bader@canonical.com>
Cc: Peter Oskolkov <posk@google.com>
Cc: Florian Westphal <fw@strlen.de>
---
v2: fixed typo in Stefan email in the Reported-by: tag

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

