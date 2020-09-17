Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E826926E99A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIQXty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:49:54 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:37114 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQXty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:49:54 -0400
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [10.243.128.7])
        by smtp.aristanetworks.com (Postfix) with ESMTP id E53F0402CF6;
        Thu, 17 Sep 2020 16:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1600386593;
        bh=3mGeEJtfpy/OYgDYPcjZMbm1NYXeXX6f8ds3K0JrI0Y=;
        h=Date:To:Subject:From:From;
        b=1YdG9jLlZA2OFGLtwHTY0x1Rmo2WvWtLLqc3zqGSisVBBHF6+B1vucCmaxbqxAUPy
         x0Hk7xwQvhhVMx2XE/3eSeGnJT+MB6WaXOsXxQ+gcagOKnkQV6x9dH6Vaz3OVrLNy8
         nFbf7SrhkXxVMY8aiFUnEFlj0UqnaerltpSbZxd7VGAhDc0yLsbzVuMxeSIKPAWE9T
         WzjO1Pi3/V/qlQMikinyvkUGAVh1zOtoLq8/Bp77SFnV9THszv/Qofch6m3jPVYGH4
         MYweUOOJ8JYnYnVVgFg0SQSZsVChrqHigrZg7ZuiwZXAZ9FcJ+b4JBAGv5CquAVTjw
         lP4xhA02dQWCg==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id CB1D295C0A69; Thu, 17 Sep 2020 16:49:53 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:49:53 -0700
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, ap420073@gmail.com, andriin@fb.com,
        edumazet@google.com, jiri@mellanox.com, ast@kernel.org,
        kuba@kernel.org, davem@davemloft.net, fruggeri@arista.com
Subject: [PATCH v3] net: use exponential backoff in netdev_wait_allrefs
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20200917234953.CB1D295C0A69@us180.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The combination of aca_free_rcu, introduced in commit 2384d02520ff
("net/ipv6: Add anycast addresses to a global hashtable"), and
fib6_info_destroy_rcu, introduced in commit 9b0a8da8c4c6 ("net/ipv6:
respect rcu grace period before freeing fib6_info"), can result in
an extra rcu grace period being needed when deleting an interface,
with the result that netdev_wait_allrefs ends up hitting the msleep(250),
which is considerably longer than the required grace period.
This can result in long delays when deleting a large number of interfaces,
and it can be observed with this script:

ns=dummy-ns
NIFS=100

ip netns add $ns
ip netns exec $ns ip link set lo up
ip netns exec $ns sysctl net.ipv6.conf.default.disable_ipv6=0
ip netns exec $ns sysctl net.ipv6.conf.default.forwarding=1

for ((i=0; i<$NIFS; i++))
do
        if=eth$i
        ip netns exec $ns ip link add $if type dummy
        ip netns exec $ns ip link set $if up
        ip netns exec $ns ip -6 addr add 2021:$i::1/120 dev $if
done

for ((i=0; i<$NIFS; i++))
do
        if=eth$i
        ip netns exec $ns ip link del $if
done

ip netns del $ns

This patch uses exponential backoff instead of the fixed msleep(250)
to get out of the loop faster.

Time with this patch on a 5.4 kernel:

real	0m8.199s
user	0m0.402s
sys	0m1.213s

Time without this patch:

real	0m31.522s
user	0m0.438s
sys	0m1.156s

v2: use exponential backoff instead of trying to wake up
    netdev_wait_allrefs.
v3: preserve reverse christmas tree ordering of local variables

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 net/core/dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4086d335978c..e5fa60cb8832 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9986,9 +9986,12 @@ EXPORT_SYMBOL(netdev_refcnt_read);
  * We can get stuck here if buggy protocols don't correctly
  * call dev_put.
  */
+#define MIN_MSLEEP	((unsigned int)16)
+#define MAX_MSLEEP	((unsigned int)250)
 static void netdev_wait_allrefs(struct net_device *dev)
 {
 	unsigned long rebroadcast_time, warning_time;
+	unsigned int wait = MIN_MSLEEP;
 	int refcnt;
 
 	linkwatch_forget_dev(dev);
@@ -10023,7 +10026,8 @@ static void netdev_wait_allrefs(struct net_device *dev)
 			rebroadcast_time = jiffies;
 		}
 
-		msleep(250);
+		msleep(wait);
+		wait = min(wait << 1, MAX_MSLEEP);
 
 		refcnt = netdev_refcnt_read(dev);
 
-- 
2.28.0
