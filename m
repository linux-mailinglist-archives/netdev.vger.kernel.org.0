Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAFA4A6201
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 08:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfICG5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 02:57:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37603 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfICG5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 02:57:09 -0400
Received: by mail-pl1-f193.google.com with SMTP id b10so2385591plr.4
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 23:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KB/V8KmhO87QpU2qi6NuMt+cmKaMtWbc3N1EFYpdy18=;
        b=A8hMB12rzSIXxfNLfvQpaXb05wViyP2+l2zkaePY3jY9xLsOYXyLQWNvuXoUjKYdYN
         aVEdikjHvxlsATSHPqByhDsXFeMegocbBJZB6BrUKuSUM34tMIYiSBRSOaRBDDLzzOOm
         4c+lh19B+smCdveQxL5zxCOCRiNP2ssUIM4XuQXxl+Iqi4niG/BblKaKI5fdu9kf1tPA
         qJUgEXWDofovWWdVES/7abXnZRPNKx2VnEVI5u0ABQB5rCFFlAxLrBUP5Xcr5i1z0xWD
         gAbEPtvR5qlXbdBe+KvwSmpz/tPGBjcIKTp/Hw8T+bZmD7g+tXwXPBt0n1YU+wMO8iZZ
         ePxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KB/V8KmhO87QpU2qi6NuMt+cmKaMtWbc3N1EFYpdy18=;
        b=YLf3p9e+/cJrKOfkCuyUnQFL0Oua/QY1cli0UK3w4TpZzO3mos1HcBPg3xPbjuxjsT
         13eZs4JLj9bozfK3E+JmN3eIW9PGOEQe72Ey+Z0DzUDFVvFqoCX9DkkbBzibDMeX2Kse
         vEnFUIa++jDbUl4lGfMD3wa1t+C9jbf0ka8qIYAHHsvYI1ALr8NYx4VoPp8vRyyK0LD8
         uDjl5SC61gDgq2Du4E1TwDnrolXNIe5/rjaEmf8M0NPK+gxv9uvgieHMLrPOjU4eTXCA
         yYaZjX0c7avaawpQPOax4zHX9ixAJ/Vupv4s0s8vz/6ZIAmG0cEQz64witj5Wggc2ID9
         Xruw==
X-Gm-Message-State: APjAAAVkVkIqShHWVHkPIwmjPnhPaV06CdwOoVmbyemRFIC+YxT27dv3
        ZLFDRLF/rPU8FJO4PJinRh7dXw==
X-Google-Smtp-Source: APXvYqyfySDW7CEQtmCmNLVRVF0O3NlAe8+q1y4hjyEJb68cAg2PNngFpGF2JKZm/rmzjydG4ijMmQ==
X-Received: by 2002:a17:902:d886:: with SMTP id b6mr8606471plz.149.1567493828795;
        Mon, 02 Sep 2019 23:57:08 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id p20sm17786228pgi.81.2019.09.02.23.57.04
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Sep 2019 23:57:08 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, arnd@arndb.de, baolin.wang@linaro.org,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y 2/8] ip6: fix skb leak in ip6frag_expire_frag_queue()
Date:   Tue,  3 Sep 2019 14:56:42 +0800
Message-Id: <3cf0695f42e8f1b4172b68ad145a5d2afae39a0e.1567492316.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1567492316.git.baolin.wang@linaro.org>
References: <cover.1567492316.git.baolin.wang@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 include/net/ipv6_frag.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index 28aa9b3..1f77fb4 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -94,7 +94,6 @@ static inline u32 ip6frag_obj_hashfn(const void *data, u32 len, u32 seed)
 		goto out;
 
 	head->dev = dev;
-	skb_get(head);
 	spin_unlock(&fq->q.lock);
 
 	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
-- 
1.7.9.5

