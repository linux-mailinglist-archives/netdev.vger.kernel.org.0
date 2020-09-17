Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313B126D0F7
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 04:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgIQCFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 22:05:46 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:48774 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQCFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 22:05:45 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 22:05:45 EDT
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [10.243.128.7])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 2AF3A402016;
        Wed, 16 Sep 2020 19:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1600308021;
        bh=SvKZ8Kw+7/Bi01muC9TH1YqAsEfXrFdMBkoXYal1lOs=;
        h=Date:To:Subject:From:From;
        b=1kI4KZdkY+YqXhUYEhHQBgob2rVjUyakuHf0KPaqggchgPsjFOO2JnxBMDha4jalu
         6NQHa6Sl3VatjzyEqa4GZFRB1irUGQDWGBhqRnFmL+g9xk8qNfAS5Avz1fyxyM4fvg
         I40LMqaG2cuBGIYHVbKqGCPmIQvV491c4gqGz+JQg/BZN0fVGsTDdK2MhoDp9V9eDQ
         58tj0qaaKj2cilXo2xgIUfsIOydqXVlEaXBR12ZVMODkg+GqiptMQZtH4Tc2rbL7ga
         JQFAVJdisg8cfUgbrNIFgrhJZV3w8Ew+Rp6GLj1HJk8H6ikrDH4cGTSaK9bH6+IzoL
         Gf2vz40DJjqiw==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id 0860995C06B9; Wed, 16 Sep 2020 19:00:20 -0700 (PDT)
Date:   Wed, 16 Sep 2020 19:00:20 -0700
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, ap420073@gmail.com, andriin@fb.com,
        edumazet@google.com, jiri@mellanox.com, ast@kernel.org,
        kuba@kernel.org, davem@davemloft.net, fruggeri@arista.com
Subject: [PATCH] net: make netdev_wait_allrefs wake-able
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20200917020021.0860995C06B9@us180.sjc.aristanetworks.com>
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

This patch converts the msleep(250) into a wake-able wait,
allowing dev_put to wake up netdev_wait_allrefs.

Time with this patch on a 5.4 kernel:

real	0m7.494s
user	0m0.403s
sys	0m1.197s

Time without this patch:

real	0m31.522s
user	0m0.438s
sys	0m1.156s

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>

---
 include/linux/netdevice.h | 6 ++++++
 net/core/dev.c            | 5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b0e303f6603f..3bbae238c11d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1795,6 +1795,7 @@ enum netdev_priv_flags {
  *
  *	@needs_free_netdev:	Should unregister perform free_netdev?
  *	@priv_destructor:	Called from unregister
+ *	@destroy_task:		Task waiting for refcount to drop to 0
  *	@npinfo:		XXX: need comments on this one
  * 	@nd_net:		Network namespace this network device is inside
  *
@@ -2089,6 +2090,7 @@ struct net_device {
 
 	bool needs_free_netdev;
 	void (*priv_destructor)(struct net_device *dev);
+	struct task_struct	*destroy_task;
 
 #ifdef CONFIG_NETPOLL
 	struct netpoll_info __rcu	*npinfo;
@@ -3873,7 +3875,11 @@ void netdev_run_todo(void);
  */
 static inline void dev_put(struct net_device *dev)
 {
+	struct task_struct *destroy_task = dev->destroy_task;
+
 	this_cpu_dec(*dev->pcpu_refcnt);
+	if (destroy_task)
+		wake_up_process(destroy_task);
 }
 
 /**
diff --git a/net/core/dev.c b/net/core/dev.c
index 4086d335978c..795c3d39e807 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9994,6 +9994,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
 	linkwatch_forget_dev(dev);
 
 	rebroadcast_time = warning_time = jiffies;
+	dev->destroy_task = current;
 	refcnt = netdev_refcnt_read(dev);
 
 	while (refcnt != 0) {
@@ -10023,7 +10024,8 @@ static void netdev_wait_allrefs(struct net_device *dev)
 			rebroadcast_time = jiffies;
 		}
 
-		msleep(250);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ/4);
 
 		refcnt = netdev_refcnt_read(dev);
 
@@ -10033,6 +10035,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
 			warning_time = jiffies;
 		}
 	}
+	dev->destroy_task = NULL;
 }
 
 /* The sequence is:
-- 
2.28.0


