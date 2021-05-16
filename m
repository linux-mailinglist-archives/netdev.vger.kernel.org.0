Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7B3381F52
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 16:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhEPOqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 10:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhEPOqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 10:46:14 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA7BC061573
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 07:44:58 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso3299922pjx.1
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 07:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=z9JsyJfRlzMAJOT7FcT3zfUktNZ2mMjszlvqkw6Wvc4=;
        b=ZQ2aq/cS22ACEuQbiZG6QbtXly07tJzdP6wGgihJtcAliLr7NI/88QuZZ3re2gQSFw
         9+d4Sjbo7nOZ70clmm0DdDGSTfRrZXFSMJLGmVZJ6Qbb5jo8rf1orwP95wbEll5uAKyI
         74GYmMTuB+dDASN3FPfPWs30v8eBtPUV0vFxEEzEnG6AT1HKWzd0vPB011kMwIf7kNqY
         lLnR8FSQ0zLDsRK+Y1vJBdaMLx8R9nE/M/vOde1XU66nv42xk7/pvXI0WgK4Ni6GFlm6
         AKsrLiAudevELlWCsektsf/0fMGxcOEMK4MCLG85Z5AnHNOWhR0rn70HInR9+JiAWyQF
         7EwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z9JsyJfRlzMAJOT7FcT3zfUktNZ2mMjszlvqkw6Wvc4=;
        b=VumpaY0zgcVwybFqiZs2CN3geA1lsCPLRN4ulNRmnN5H+W8equnAKbN5q7Zofq3rmW
         bOeY/iovWK4cLnedXaU5SC+E3GzdNWKXMxEnOuz7VWCsQNaXJoperrjscYJfGeTjDAdS
         Ydg/ukS4JU6TFplIh67MV8HF1IhvyE4KzUDB7BVbw2elxk4aFUH9rYOlUTGwZSJmSzwz
         NuOLjUU9CETCuMKXgGoKjs/Yf/d3+K+XlwrKIGCYmCo3jgdZEHR3Z9WpL3G0HrSOXhQ0
         4k9hHpMh5DGZ9XGNs2FtgJAD3hOTyBofXMiiyoEsCFL9E1U5ETFUtLW146lQnLtmEIdi
         XGlA==
X-Gm-Message-State: AOAM531F8b7qmJBwbYiozjc6NYR6D3WxMMDmb+5XY93rVZ+x033pwXZ2
        XVA6EQi3XGVq+VpaVrszz4U=
X-Google-Smtp-Source: ABdhPJxXJgrnes8LcIxar521p1bRCTEX14ucsJAPsSqDdV0VPvI2o6v0vssfjLrh7jtvWuU77X2tFg==
X-Received: by 2002:a17:90a:a604:: with SMTP id c4mr21782157pjq.81.1621176298213;
        Sun, 16 May 2021 07:44:58 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id s9sm5390683pfm.120.2021.05.16.07.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 07:44:57 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, xiyou.wangcong@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH v2 net] mld: fix panic in mld_newpack()
Date:   Sun, 16 May 2021 14:44:42 +0000
Message-Id: <20210516144442.4838-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mld_newpack() doesn't allow to allocate high order page,
only order-0 allocation is allowed.
If headroom size is too large, a kernel panic could occur in skb_put().

Test commands:
    ip netns del A
    ip netns del B
    ip netns add A
    ip netns add B
    ip link add veth0 type veth peer name veth1
    ip link set veth0 netns A
    ip link set veth1 netns B

    ip netns exec A ip link set lo up
    ip netns exec A ip link set veth0 up
    ip netns exec A ip -6 a a 2001:db8:0::1/64 dev veth0
    ip netns exec B ip link set lo up
    ip netns exec B ip link set veth1 up
    ip netns exec B ip -6 a a 2001:db8:0::2/64 dev veth1
    for i in {1..99}
    do
        let A=$i-1
        ip netns exec A ip link add ip6gre$i type ip6gre \
	local 2001:db8:$A::1 remote 2001:db8:$A::2 encaplimit 100
        ip netns exec A ip -6 a a 2001:db8:$i::1/64 dev ip6gre$i
        ip netns exec A ip link set ip6gre$i up

        ip netns exec B ip link add ip6gre$i type ip6gre \
	local 2001:db8:$A::2 remote 2001:db8:$A::1 encaplimit 100
        ip netns exec B ip -6 a a 2001:db8:$i::2/64 dev ip6gre$i
        ip netns exec B ip link set ip6gre$i up
    done

Splat looks like:
kernel BUG at net/core/skbuff.c:110!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
CPU: 0 PID: 7 Comm: kworker/0:1 Not tainted 5.12.0+ #891
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:skb_panic+0x15d/0x15f
Code: 92 fe 4c 8b 4c 24 10 53 8b 4d 70 45 89 e0 48 c7 c7 00 ae 79 83
41 57 41 56 41 55 48 8b 54 24 a6 26 f9 ff <0f> 0b 48 8b 6c 24 20 89
34 24 e8 4a 4e 92 fe 8b 34 24 48 c7 c1 20
RSP: 0018:ffff88810091f820 EFLAGS: 00010282
RAX: 0000000000000089 RBX: ffff8881086e9000 RCX: 0000000000000000
RDX: 0000000000000089 RSI: 0000000000000008 RDI: ffffed1020123efb
RBP: ffff888005f6eac0 R08: ffffed1022fc0031 R09: ffffed1022fc0031
R10: ffff888117e00187 R11: ffffed1022fc0030 R12: 0000000000000028
R13: ffff888008284eb0 R14: 0000000000000ed8 R15: 0000000000000ec0
FS:  0000000000000000(0000) GS:ffff888117c00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8b801c5640 CR3: 0000000033c2c006 CR4: 00000000003706f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ? ip6_mc_hdr.isra.26.constprop.46+0x12a/0x600
 ? ip6_mc_hdr.isra.26.constprop.46+0x12a/0x600
 skb_put.cold.104+0x22/0x22
 ip6_mc_hdr.isra.26.constprop.46+0x12a/0x600
 ? rcu_read_lock_sched_held+0x91/0xc0
 mld_newpack+0x398/0x8f0
 ? ip6_mc_hdr.isra.26.constprop.46+0x600/0x600
 ? lock_contended+0xc40/0xc40
 add_grhead.isra.33+0x280/0x380
 add_grec+0x5ca/0xff0
 ? mld_sendpack+0xf40/0xf40
 ? lock_downgrade+0x690/0x690
 mld_send_initial_cr.part.34+0xb9/0x180
 ipv6_mc_dad_complete+0x15d/0x1b0
 addrconf_dad_completed+0x8d2/0xbb0
 ? lock_downgrade+0x690/0x690
 ? addrconf_rs_timer+0x660/0x660
 ? addrconf_dad_work+0x73c/0x10e0
 addrconf_dad_work+0x73c/0x10e0

Allowing high order page allocation could fix this problem.

Fixes: 72e09ad107e7 ("ipv6: avoid high order allocations")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Wait for mld-sleepable patchset to be merged.

 net/ipv6/mcast.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 0d59efb6b49e..d36ef9d25e73 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1745,10 +1745,7 @@ static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
 		     IPV6_TLV_PADN, 0 };
 
 	/* we assume size > sizeof(ra) here */
-	/* limit our allocations to order-0 page */
-	size = min_t(int, size, SKB_MAX_ORDER(0, 0));
 	skb = sock_alloc_send_skb(sk, size, 1, &err);
-
 	if (!skb)
 		return NULL;
 
-- 
2.17.1

