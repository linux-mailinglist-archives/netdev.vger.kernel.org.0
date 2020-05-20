Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8501DB791
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 16:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgETO6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 10:58:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37802 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgETO6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 10:58:30 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jbQAi-00064e-MU; Wed, 20 May 2020 14:58:16 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH net-next] ipv6/route: inherit max_sizes from current netns
Date:   Wed, 20 May 2020 16:58:06 +0200
Message-Id: <20200520145806.3746944-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During NorthSec (cf. [1]) a very large number of unprivileged
containers and nested containers are run during the competition to
provide a safe environment for the various teams during the event. Every
year a range of feature requests or bug reports come out of this and
this year's no different.
One of the containers was running a simple VPN server. There were about
1.5k users connected to this VPN over ipv6 and the container was setup
with about 100 custom routing tables when it hit the max_sizes routing
limit. After this no new connections could be established anymore,
pinging didn't work anymore; you get the idea.

The kernel helpfully logs a message pointing out that bumping max_sizes
should be considered to fix that problem. Here's where it gets tricky.
Routing tables are namespaced and as such max_sizes along with the other
sysctls is a per-netns limit, not a global limit. Each network namespace
by default gets a limit of 4096 routes. Network namespaces owned by the
initial user namespace can change this limit afterwards but network
namespaces owned by non-initial user namespaces can't.

The workload outlined is not an uncommon one. Running VPNs in
unprivileged containers for a large number of users is something people
do and in general large routing tables in unprivileged containers are
pretty common.

There are multiple ways to fix or at least alleviate the problem:
1. Fully namespace at least max_sizes. Right now the max_sizes sysctl
   doesn't show up in network namespaces owned by non-initial user
   namespaces and hence, can't be written to by user namespace root. We
   could simply expose it to non-initial network namespaces owned by
   non-initial user namespaces.
   This solution is the cleanest one conceptually: each container
   already has a separate routing table regardless if privileged or
   unprivileged so allow them to determine the size of it too. The issue
   I see with this solution is that it would potentially make it easier
   to dos the system or even exceed kernel memory. If I'm not mistaken,
   a container could bump max_sizes to INT_MAX(2147483647) and keep
   allocating routes.
   An argument against this worry is that this is technically already
   possible by simply creating a huge number of network namespaces, each
   with a 4096 route limit and allocating 4096 routes in each of them.
   An unprivileged user could for example create at least
   /proc/sys/user/max_net_namespaces network namespaces. The limit on
   the number of network namespaces on my host is e.g. 62690 which means
   256778240 routes. So by exposing max_sizes we don't really add a new
   attack surface.
2. Namespace max_sizes but limiting it to init_net.sysctl.max_sizes. This
   would mean that a container would start with the 4096 limit but if
   the initial network namespace bumps max_sizes later the container
   could bump it too. This has two problems, first the container doesn't
   know what the host bumped max_sizes too and would need to guess by
   trying to write a larger value. Second, this would break network
   namespaces owned by the initial user namespace as they would suddenly
   be limited by the initial network namespace.
3. Inherit the limit from the initial network namespace at
   container/network namespace creation time. This would mean we don't
   fully namespace max_sizes but allow the host to set a limit that it
   is fine with each container to inherit.
   That sounds acceptable but will mean that a nested container can e.g.
   get a larger max_sizes value than the container it was created in.
4. Inherit the limit from the current network namespace. This to means
   we don't fully namespace max_sizes but allow the current network
   namespace to choose a limit it is comfortable with inheriting.

[1]: https://nsec.io/
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 net/ipv6/route.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a52ec1b86432..cf951d147e3a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6246,6 +6246,7 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 static int __net_init ip6_route_net_init(struct net *net)
 {
 	int ret = -ENOMEM;
+	struct net *current_net = current->nsproxy->net_ns;
 
 	memcpy(&net->ipv6.ip6_dst_ops, &ip6_dst_ops_template,
 	       sizeof(net->ipv6.ip6_dst_ops));
@@ -6294,9 +6295,9 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.fib6_routes_require_src = 0;
 #endif
 #endif
-
 	net->ipv6.sysctl.flush_delay = 0;
-	net->ipv6.sysctl.ip6_rt_max_size = 4096;
+	net->ipv6.sysctl.ip6_rt_max_size =
+		READ_ONCE(current_net->ipv6.sysctl.ip6_rt_max_size);
 	net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
 	net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
 	net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;

base-commit: 4f65e2f483b6f764c15094d14dd53dda048a4048
-- 
2.26.2

