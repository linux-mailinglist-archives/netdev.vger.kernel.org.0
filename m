Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB1EA98B8
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 05:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731029AbfIEDGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 23:06:55 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38413 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730652AbfIEDGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 23:06:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so750647pfe.5
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 20:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ELttBCRw1A5YO2An5LqOnscxESNC1jHrDOB2eOhUzf0=;
        b=nPb1Hpra7lqtzWoDX7p3CwYYne28JfIDVytSB/01eknPmAJcb7kVWu95VG+U4ZEZgE
         l5VuOduJ/BjKaWI6PJMfHuIsIZoA06axlX2II/apMQ/HDWsfAvMOxTThrr5cCjTsPUz/
         grodGpmKSfuMPURQWkJyvU+wUKQqG7i4MVckTpeYCEK+4FbcShEV/QALo+bKQXj132oy
         NSnHrBwwDCfRme5aKHxcALcRPXH5m+EsUIBjnYOXUoDPGA8YL+FEqsYRrxoLl4tVIjWo
         7Wn9k/0y4dfyRVEBQT68Z+JMflYckhBJosyoUP1DYcsvz/qGmPBCXWceAAKgpjpQQuA6
         RoUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ELttBCRw1A5YO2An5LqOnscxESNC1jHrDOB2eOhUzf0=;
        b=EFnAsy5Yo19a/SmqRyaytERQ947j2Nx1n4eXl+1wh8VIPd3FXZxUZOplULyiuC/feG
         VkbyJWW0jpkIKtvTic/nZhWTzZAbgaJViS2VKikIOcRPj1Pkr8f37cDpPc1Q79byuZUK
         D8OFmp4Zt7hGs7N8pUqpvJp8xUJf+tapEuwx6RH4+zlTuV87u45n28h+93uzzMgy/FUM
         OVzddx/ji+NotApjPTsT3HBXJMdS6tM2Hnu3QblrA7zVbaT+R/EuuWnYTRv+Zs58c+YA
         Kqn05JZprDAL9PRIhd8+zXCihIuPKnInxEHXnEUY/qC3VW9iCpz5Zdah9B9tNkhLpfqi
         xO9g==
X-Gm-Message-State: APjAAAWxaKjFxlJcyFy4KmCWyd5HxgweERXHe1dZRu5EXp3ut5P1yaZv
        6Vwg1wjRanchpNkk9o9uC5IMdw==
X-Google-Smtp-Source: APXvYqxS7NXgi1tDYJCAiwpQskzahnsXS/8F9dZOzXw7WrSxv/s3pHyxNQ2yC/Uojecq9VUcpTJ53Q==
X-Received: by 2002:a17:90a:8a02:: with SMTP id w2mr198598pjn.131.1567652814821;
        Wed, 04 Sep 2019 20:06:54 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id n9sm461728pgf.64.2019.09.04.20.06.51
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Sep 2019 20:06:54 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Cc:     edumazet@google.com, netdev@vger.kernel.org, arnd@arndb.de,
        baolin.wang@linaro.org, orsonzhai@gmail.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y v2 1/6] ip6: fix skb leak in ip6frag_expire_frag_queue()
Date:   Thu,  5 Sep 2019 11:06:18 +0800
Message-Id: <48fc1cc230c4840898ded9e57653b11f274d511a.1567649729.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1567649728.git.baolin.wang@linaro.org>
References: <cover.1567649728.git.baolin.wang@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[Upstream commit 47d3d7fdb10a21c223036b58bd70ffdc24a472c4]

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

