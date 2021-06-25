Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E343B3CFF
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 09:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhFYHGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 03:06:50 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:60016 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhFYHGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 03:06:49 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 3704E800056;
        Fri, 25 Jun 2021 09:04:28 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 09:04:28 +0200
Received: from moon.secunet.de (172.18.26.121) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 25 Jun
 2021 09:04:27 +0200
Date:   Fri, 25 Jun 2021 09:04:10 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Christian Perle <christian.perle@secunet.com>,
        Antony Antony <antony.antony@secunet.com>
Subject: [PATCH net-next] ipv6: Add sysctl for RA default route table number
Message-ID: <32de887afdc7d6851e7c53d27a21f1389bb0bd0f.1624604535.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
References: <cover.1619775297.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1619775297.git.antony.antony@secunet.com>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Perle <christian.perle@secunet.com>

Default routes learned from router advertisements(RA) are always placed
in main routing table. For policy based routing setups one may
want a different table for default routes. This commit adds a sysctl
to make table number for RA default routes configurable.

examples:
sysctl net.ipv6.route.defrtr_table
sysctl -w net.ipv6.route.defrtr_table=42
ip -6 route show table 42

Signed-off-by: Christian Perle <christian.perle@secunet.com>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 include/net/netns/ipv6.h |  1 +
 net/ipv6/route.c         | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index bde0b7adb4a3..0eb599ee621a 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -53,6 +53,7 @@ struct netns_sysctl_ipv6 {
 	int seg6_flowlabel;
 	bool skip_notify_on_dev_down;
 	u8 fib_notify_on_flag_change;
+	u32 ip6_rt_defrtr_table;
 };
 
 struct netns_ipv6 {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7b756a7dc036..5c561f5b7618 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4336,7 +4336,7 @@ struct fib6_info *rt6_get_dflt_router(struct net *net,
 				     const struct in6_addr *addr,
 				     struct net_device *dev)
 {
-	u32 tb_id = l3mdev_fib_table(dev) ? : RT6_TABLE_DFLT;
+	u32 tb_id = l3mdev_fib_table(dev) ? : net->ipv6.sysctl.ip6_rt_defrtr_table;
 	struct fib6_info *rt;
 	struct fib6_table *table;
 
@@ -4371,7 +4371,7 @@ struct fib6_info *rt6_add_dflt_router(struct net *net,
 				     u32 defrtr_usr_metric)
 {
 	struct fib6_config cfg = {
-		.fc_table	= l3mdev_fib_table(dev) ? : RT6_TABLE_DFLT,
+		.fc_table	= l3mdev_fib_table(dev) ? : net->ipv6.sysctl.ip6_rt_defrtr_table,
 		.fc_metric	= defrtr_usr_metric,
 		.fc_ifindex	= dev->ifindex,
 		.fc_flags	= RTF_GATEWAY | RTF_ADDRCONF | RTF_DEFAULT |
@@ -6391,6 +6391,13 @@ static struct ctl_table ipv6_route_table_template[] = {
 		.extra1		=	SYSCTL_ZERO,
 		.extra2		=	SYSCTL_ONE,
 	},
+	{
+		.procname	=	"defrtr_table",
+		.data		=	&init_net.ipv6.sysctl.ip6_rt_defrtr_table,
+		.maxlen		=	sizeof(u32),
+		.mode		=	0644,
+		.proc_handler	=	proc_dointvec,
+	},
 	{ }
 };
 
@@ -6415,6 +6422,7 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 		table[8].data = &net->ipv6.sysctl.ip6_rt_min_advmss;
 		table[9].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
 		table[10].data = &net->ipv6.sysctl.skip_notify_on_dev_down;
+		table[11].data = &net->ipv6.sysctl.ip6_rt_defrtr_table;
 
 		/* Don't export sysctls to unprivileged users */
 		if (net->user_ns != &init_user_ns)
@@ -6486,6 +6494,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.sysctl.ip6_rt_mtu_expires = 10*60*HZ;
 	net->ipv6.sysctl.ip6_rt_min_advmss = IPV6_MIN_MTU - 20 - 40;
 	net->ipv6.sysctl.skip_notify_on_dev_down = 0;
+	net->ipv6.sysctl.ip6_rt_defrtr_table = RT6_TABLE_DFLT;
 
 	net->ipv6.ip6_rt_gc_expire = 30*HZ;
 
-- 
2.20.1

