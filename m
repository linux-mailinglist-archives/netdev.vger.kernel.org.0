Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252EE2706D8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIRUTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:19:03 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:20188 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgIRUTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:19:03 -0400
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [10.243.128.7])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 2B65E40200F;
        Fri, 18 Sep 2020 13:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1600460342;
        bh=pi2k3C/WWjrjESveZ2nlqFAMuefDSn9zTY7FzKz4zwk=;
        h=Date:To:Subject:From:From;
        b=eY5QXGJ7y3dab3HHMdy6N0RHk+Pf9UZV3p6pnRWBZVPGDdrb+f4D6FKfjx7cD9xom
         +9qqU+fCif67TTVv1a2H2r8xbK+kNgpUPo1xttTT3QQxAOdFtwHSlOEsFDZ8Z053qq
         8eNn+2V5eJQBgoquEL7KCwvTS43bA2YsnFId5mmKKZIVxU63KepkWoCCAu5JCmk5XX
         OCbKGDaQ0Ip5Lqs2xUxy9aTcQrfeCSdbAUKCCTfAgH64RS3T7D5sWU983jxv8kZ+uj
         MejyGgUGOjpAXIaLeOtXoFJvDLY32jm9OeG0bg4WqfVWZXBIz6A3NEZG0uGmzBTC0e
         op8atrAkms2Xg==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id 0931495C0649; Fri, 18 Sep 2020 13:19:01 -0700 (PDT)
Date:   Fri, 18 Sep 2020 13:19:01 -0700
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, ap420073@gmail.com, andriin@fb.com,
        edumazet@google.com, jiri@mellanox.com, ast@kernel.org,
        kuba@kernel.org, davem@davemloft.net, fruggeri@arista.com
Subject: [PATCH v4] net: use exponential backoff in netdev_wait_allrefs
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20200918201902.0931495C0649@us180.sjc.aristanetworks.com>
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

Instead of using a fixed msleep(250), this patch tries an extra
rcu_barrier() followed by an exponential backoff.

Time with this patch on a 5.4 kernel:

real	0m7.704s
user	0m0.385s
sys	0m1.230s

Time without this patch:

real    0m31.522s
user    0m0.438s
sys     0m1.156s

v2: use exponential backoff instead of trying to wake up
    netdev_wait_allrefs.
v3: preserve reverse christmas tree ordering of local variables
v4: try an extra rcu_barrier before the backoff, plus some
    cosmetic changes.

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 net/core/dev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4086d335978c..cef4a5ea24d0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9986,10 +9986,12 @@ EXPORT_SYMBOL(netdev_refcnt_read);
  * We can get stuck here if buggy protocols don't correctly
  * call dev_put.
  */
+#define WAIT_REFS_MIN_MSECS 1
+#define WAIT_REFS_MAX_MSECS 250
 static void netdev_wait_allrefs(struct net_device *dev)
 {
 	unsigned long rebroadcast_time, warning_time;
-	int refcnt;
+	int wait = 0, refcnt;
 
 	linkwatch_forget_dev(dev);
 
@@ -10023,7 +10025,13 @@ static void netdev_wait_allrefs(struct net_device *dev)
 			rebroadcast_time = jiffies;
 		}
 
-		msleep(250);
+		if (!wait) {
+			rcu_barrier();
+			wait = WAIT_REFS_MIN_MSECS;
+		} else {
+			msleep(wait);
+			wait = min(wait << 1, WAIT_REFS_MAX_MSECS);
+		}
 
 		refcnt = netdev_refcnt_read(dev);
 
-- 
2.28.0


