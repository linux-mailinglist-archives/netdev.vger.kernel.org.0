Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38D57590A
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfGYUmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:42:51 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:33933 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfGYUmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 16:42:47 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 11C2B891A9;
        Fri, 26 Jul 2019 08:42:45 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1564087365;
        bh=VizPhgqyp68cQLltl/u4qfW8BE0iqZhkMvIfY/AeUIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Xz/AeljRkO3wQHKubhRTKGfYNRWgMbDiU5H4ieyGNUvN1Zo6KPPahqRpa8HmhwemE
         mqb5mZEtSMLmPUyiYWoAKojihvNypaNrm66kYJuji/UR8h4MJ+85KLwTGxopJWkGV+
         gPWoeG6fOYGk5ppUZP/gWlz6zyjB8O4k3PukCx868VpNXP24uU1j1JgWqNM6jTvAnV
         BcF3acaG2gUoFEvRzP0ddc69zfkjssfoOTJc9P3We4LSHGGhlcoQz5vywLR84jwTuG
         n5uNHcfW3vJVlFdoEY7VZg7ZzwfmdYkCJR/UR89vuJSGIrZuVcKVL8BTAPrn3JfmD2
         ZZsA03fNMmL/g==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d3a14440000>; Fri, 26 Jul 2019 08:42:44 +1200
Received: from brodieg-dl.ws.atlnz.lc (brodieg-dl.ws.atlnz.lc [10.33.22.16])
        by smtp (Postfix) with ESMTP id D319A13EECE;
        Fri, 26 Jul 2019 08:42:46 +1200 (NZST)
Received: by brodieg-dl.ws.atlnz.lc (Postfix, from userid 1718)
        id CA8D8502CCC; Fri, 26 Jul 2019 08:42:44 +1200 (NZST)
From:   Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
To:     davem@davemloft.net, stephen@networkplumber.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, chris.packham@alliedtelesis.co.nz,
        luuk.paulussen@alliedtelesis.co.nz,
        Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
Subject: [PATCH 2/2] ip6mr: Make cache queue length configurable
Date:   Fri, 26 Jul 2019 08:42:30 +1200
Message-Id: <20190725204230.12229-3-brodie.greenfield@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190725204230.12229-1-brodie.greenfield@alliedtelesis.co.nz>
References: <20190725204230.12229-1-brodie.greenfield@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to be able to keep more spaces available in our queue for
processing incoming IPv6 multicast traffic (adding (S,G) entries) - this
lets us learn more groups faster, rather than dropping them at this stage=
.

Signed-off-by: Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
---
 Documentation/networking/ip-sysctl.txt | 8 ++++++++
 include/net/netns/ipv6.h               | 1 +
 net/ipv6/af_inet6.c                    | 1 +
 net/ipv6/ip6mr.c                       | 4 +++-
 net/ipv6/sysctl_net_ipv6.c             | 7 +++++++
 5 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/netwo=
rking/ip-sysctl.txt
index 02f77e932adf..68eada3ca915 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1481,6 +1481,14 @@ skip_notify_on_dev_down - BOOLEAN
 	on userspace caches to track link events and evict routes.
 	Default: false (generate message)
=20
+ip6_mr_cache_queue_length - INTEGER
+	Limit the number of multicast packets we can have in the queue to be
+	resolved.
+	Bear in mind that when an unresolved multicast packet is received,
+	there is an O(n) traversal of the queue. This should be considered
+	if increasing.
+	Default: 10
+
 IPv6 Fragmentation:
=20
 ip6frag_high_thresh - INTEGER
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index ef1ed529f33c..84b58424c799 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -46,6 +46,7 @@ struct netns_sysctl_ipv6 {
 	int max_hbh_opts_len;
 	int seg6_flowlabel;
 	bool skip_notify_on_dev_down;
+	unsigned int ip6_mr_cache_queue_length;
 };
=20
 struct netns_ipv6 {
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d99753b5e39b..6551bb63e5a2 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -856,6 +856,7 @@ static int __net_init inet6_net_init(struct net *net)
 	net->ipv6.sysctl.max_hbh_opts_cnt =3D IP6_DEFAULT_MAX_HBH_OPTS_CNT;
 	net->ipv6.sysctl.max_dst_opts_len =3D IP6_DEFAULT_MAX_DST_OPTS_LEN;
 	net->ipv6.sysctl.max_hbh_opts_len =3D IP6_DEFAULT_MAX_HBH_OPTS_LEN;
+	net->ipv6.sysctl.ip6_mr_cache_queue_length =3D 10;
 	atomic_set(&net->ipv6.fib6_sernum, 1);
=20
 	err =3D ipv6_init_mibs(net);
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index cc01aa3f2b5e..bb445871437e 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1135,6 +1135,7 @@ static int ip6mr_cache_report(struct mr_table *mrt,=
 struct sk_buff *pkt,
 static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
 				  struct sk_buff *skb, struct net_device *dev)
 {
+	struct net *net =3D dev_net(dev);
 	struct mfc6_cache *c;
 	bool found =3D false;
 	int err;
@@ -1153,7 +1154,8 @@ static int ip6mr_cache_unresolved(struct mr_table *=
mrt, mifi_t mifi,
 		 *	Create a new entry if allowable
 		 */
=20
-		if (atomic_read(&mrt->cache_resolve_queue_len) >=3D 10 ||
+		if (atomic_read(&mrt->cache_resolve_queue_len) >=3D
+		    net->ipv6.sysctl.ip6_mr_cache_queue_length ||
 		    (c =3D ip6mr_cache_alloc_unres()) =3D=3D NULL) {
 			spin_unlock_bh(&mfc_unres_lock);
=20
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index e15cd37024fd..a27299d4cc34 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -159,6 +159,13 @@ static struct ctl_table ipv6_table_template[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D proc_dointvec
 	},
+	{
+		.procname	=3D "ip6_mr_cache_queue_length",
+		.data		=3D &init_net.ipv6.sysctl.ip6_mr_cache_queue_length,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D proc_dointvec
+	},
 	{ }
 };
=20
--=20
2.21.0

