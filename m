Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705D225FDA8
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgIGPyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:54:19 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:39026 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730011AbgIGOuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:50:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U8F-iz8_1599489875;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0U8F-iz8_1599489875)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Sep 2020 22:44:35 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideo Aoki <haoki@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net/sock: don't drop udp packets if udp_mem[2] not reached
Date:   Mon,  7 Sep 2020 22:44:35 +0800
Message-Id: <20200907144435.43165-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We encoutered udp packets drop under a pretty low pressure
with net.ipv4.udp_mem[0] set to a small value (4096).

After some tracing and debugging, we found that for udp
protocol, __sk_mem_raise_allocated() will possiblly drop
packets if:
  udp_mem[0] < udp_prot.memory_allocated < udp_mem[2]

That's because __sk_mem_raise_allocated() didn't handle
the above condition for protocols like udp who doesn't
have sk_has_memory_pressure()

We can reproduce this with the following condition
1. udp_mem[0] is relateive small,
2. net.core.rmem_default/max > udp_mem[0] * 4K
3. The udp server receive slowly, causing the udp_prot->memory_allocated
   exceed udp_mem[0], but still under udp_mem[2]

I wrote a test script to reproduce this:
https://github.com/dust-li/kernel-test/blob/master/exceed_udp_mem_min_drop/exceed_udp_mem_min_drop.sh

Obviously, we should not drop packets when udp_prot.memory_allocated
just exceed udp_mem[0] but still under hard limit.

For protocols with memory_pressure callbacks (like TCP), this is
not a problem, because there is an extra check:
```
  if (sk_has_memory_pressure(sk)) {
  	u64 alloc;

  	if (!sk_under_memory_pressure(sk))
  		return 1;
  	alloc = sk_sockets_allocated_read_positive(sk);
  	if (sk_prot_mem_limits(sk, 2) > alloc *
  			sk_mem_pages(sk->sk_wmem_queued +
  				atomic_read(&sk->sk_rmem_alloc) +
  				sk->sk_forward_alloc))
  		return 1;
  }
```

But UDP didn't check this, so I add an extra check here
to make sure UDP packets are not dropped until the hard limit
is reached.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/core/sock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 6c5c6b18eff4..fed8211d8dbe 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2648,6 +2648,12 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 				 atomic_read(&sk->sk_rmem_alloc) +
 				 sk->sk_forward_alloc))
 			return 1;
+	} else {
+		/* for prots without memory_pressure callbacks, we should not
+		 * drop until hard limit reached
+		 */
+		if (allocated <= sk_prot_mem_limits(sk, 2))
+			return 1;
 	}
 
 suppress_allocation:
-- 
2.19.1.3.ge56e4f7

