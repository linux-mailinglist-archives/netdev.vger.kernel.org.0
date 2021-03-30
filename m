Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DA534EC81
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhC3Pbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbhC3PbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:31:17 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5530AC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:31:16 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e14so6353501plj.2
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=d7FHqejKIb0N3x9a9aU5vlUB5wV6nVuZngMuH8um7w8=;
        b=UCJ2fnjeziBguMUD+rHwETW7NnRyFnv9rzoWrc64+iEGU6AyTDUxBZix+Bnc/7OUGc
         D/7x+OlMbjjd8K/F/x8uRStRjL83pJtPxP7W038PwjlQAzXvCXqbzhnZVn7mZb7B26aU
         r56+prTT9XGyRR3yZBMP3+dyqMm4bFCeeRUh5wTEmv/VicR8XrhVScdiCLE4BRw2zgYT
         6rhD++viRiKn/oHfs/WS8tkvrhXNZFypGJ9CCY7+ySNnOKwEQ41erwyjJFK5pf0ex3GA
         cRRd3Y2HIrGDbF5a4rTkN7y4El9BH/XA/+IrfWImK3zUqW04Pwh1GrMyWJAi4vU1j7zE
         wolg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d7FHqejKIb0N3x9a9aU5vlUB5wV6nVuZngMuH8um7w8=;
        b=P+OIPVsdngqGroYKnz990MzdPORAxUKoRQ5vhjR51XOWE6dwX67+FKuwDipYxcvELw
         ILILg7aXDbZY+TarZUBZ6VBnlQAcujb2eZg3DP2kwu+jrqEI+GtmtxvDEH/K+hQDNOOc
         wh5hsNSYS5A04dhgdb5CuDLTrRdfBOIFE127ufILBXeYJYWQSCRNRdmfO4k8jukyD6BV
         zr1dVn1UeEcKKo8NSXXqfKlyc/HdF7EpQ/hkfgFGxiwr7DedtbpgqfqqThYmhf3IcSVa
         IHJldgcJm5H77Kihr7/dKujuZDm3FzV7haOwAHOUgJNKIGjsU9XCxjcl2BAcKTFxoTT3
         qJfw==
X-Gm-Message-State: AOAM533P6ha2HEkGn69i+MDC0HGVUrvZHkahD1cNbjj3mRD1GIMKL77Q
        edzCMmlhpPeN3U8MyDOmCfyP1JpPtFHiYw==
X-Google-Smtp-Source: ABdhPJzNgTv1OjfspXYuTEbMxG0iJlQcODT3zOsNOcQ/T+CuKGNKMe0uRYU/nutq2JQEh0XvdcEMbA==
X-Received: by 2002:a17:90a:c201:: with SMTP id e1mr4838103pjt.30.1617118275473;
        Tue, 30 Mar 2021 08:31:15 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 138sm21486554pfv.192.2021.03.30.08.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 08:31:14 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        edumazet@google.com
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] mld: add missing rtnl_lock() in do_ipv6_getsockopt()
Date:   Tue, 30 Mar 2021 15:31:06 +0000
Message-Id: <20210330153106.31614-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip6_mc_msfget() should be called under RTNL because it accesses RTNL
protected data. but the caller doesn't acquire rtnl_lock().
So, data couldn't be protected.
Therefore, it adds rtnl_lock() in do_ipv6_getsockopt(),
which is the caller of ip6_mc_msfget().

Splat looks like:
=============================
WARNING: suspicious RCU usage
5.12.0-rc4+ #480 Tainted: G        W
-----------------------------
include/net/addrconf.h:314 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by sockopt_msfilte/4955:
 #0: ffff88800aa21370 (sk_lock-AF_INET6){+.+.}-{0:0}, at: \
	ipv6_get_msfilter+0xaf/0x190

stack backtrace:
Call Trace:
 dump_stack+0xa4/0xe5
 ip6_mc_find_dev_rtnl+0x117/0x150
 ip6_mc_msfget+0x17d/0x700
 ? lock_acquire+0x191/0x720
 ? ipv6_sock_mc_join_ssm+0x10/0x10
 ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
 ? mark_held_locks+0xb7/0x120
 ? lockdep_hardirqs_on_prepare+0x27c/0x3e0
 ? __local_bh_enable_ip+0xa5/0xf0
 ? lock_sock_nested+0x82/0xf0
 ipv6_get_msfilter+0xc3/0x190
 ? compat_ipv6_get_msfilter+0x300/0x300
 ? lock_downgrade+0x690/0x690
 do_ipv6_getsockopt.isra.6.constprop.13+0x1706/0x29f0
 ? do_ipv6_mcast_group_source+0x150/0x150
 ? __wake_up_common+0x620/0x620
 ? mutex_trylock+0x23f/0x2a0
[ ... ]

Fixes: 88e2ca308094 ("mld: convert ifmcaddr6 to RCU")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

commit 88e2ca308094 ("mld: convert ifmcaddr6 to RCU") is not yet merged
to "net" branch. So, target branch is "net-next"

 net/ipv6/ipv6_sockglue.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index a6804a7e34c1..55dc35e09c68 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1137,9 +1137,12 @@ static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 		val = sk->sk_family;
 		break;
 	case MCAST_MSFILTER:
+		rtnl_lock();
 		if (in_compat_syscall())
-			return compat_ipv6_get_msfilter(sk, optval, optlen);
-		return ipv6_get_msfilter(sk, optval, optlen, len);
+			val = compat_ipv6_get_msfilter(sk, optval, optlen);
+		val = ipv6_get_msfilter(sk, optval, optlen, len);
+		rtnl_unlock();
+		return val;
 	case IPV6_2292PKTOPTIONS:
 	{
 		struct msghdr msg;
-- 
2.17.1

