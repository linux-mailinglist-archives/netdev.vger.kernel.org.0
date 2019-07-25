Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A19475909
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfGYUmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:42:47 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:33926 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfGYUmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 16:42:45 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 975E3886BF;
        Fri, 26 Jul 2019 08:42:43 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1564087363;
        bh=/ncGicRhpT0Jrx1YkKh+dSzX+9GKtXbzCjm1aNfcRSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Mj8rGhz9WR2zuei1Id6GbebcDCnt4fDSYvT9YXu8gVKmSlJrrq5shV70AHpNTKYxp
         mgSnkbzZrUMSqn832gUCAxp9VTcKN8XGtB1A0yWDWGSWWD5kXOKSVC7KDKTxBhf1Ws
         1vTnETwXwyL2XQoNAwefNuCxXFMFs6B3WDQpk3APtwfJZQzNcPrZZs7GDXevoRx8Lz
         GZeXEkw4LstGlNPzFNPejOjU0/ufS0G+Bx01EDNbA4hXDTCWF5FOrrJsf3E02ivYRk
         t3Z/PS67jyX96gk9mK+RvZvLz8h9rmwQ7YjDjuV128dy7vfPet/P8N8SV0bjBqUNCU
         pajEc3B3h9uxA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d3a14430000>; Fri, 26 Jul 2019 08:42:43 +1200
Received: from brodieg-dl.ws.atlnz.lc (brodieg-dl.ws.atlnz.lc [10.33.22.16])
        by smtp (Postfix) with ESMTP id 5C19613EECE;
        Fri, 26 Jul 2019 08:42:45 +1200 (NZST)
Received: by brodieg-dl.ws.atlnz.lc (Postfix, from userid 1718)
        id 53920502CCC; Fri, 26 Jul 2019 08:42:43 +1200 (NZST)
From:   Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
To:     davem@davemloft.net, stephen@networkplumber.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, chris.packham@alliedtelesis.co.nz,
        luuk.paulussen@alliedtelesis.co.nz,
        Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
Subject: [PATCH 1/2] ipmr: Make cache queue length configurable
Date:   Fri, 26 Jul 2019 08:42:29 +1200
Message-Id: <20190725204230.12229-2-brodie.greenfield@alliedtelesis.co.nz>
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
processing incoming multicast traffic (adding (S,G) entries) - this lets
us learn more groups faster, rather than dropping them at this stage.

Signed-off-by: Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
---
 Documentation/networking/ip-sysctl.txt | 8 ++++++++
 include/net/netns/ipv4.h               | 1 +
 net/ipv4/af_inet.c                     | 1 +
 net/ipv4/ipmr.c                        | 4 +++-
 net/ipv4/sysctl_net_ipv4.c             | 7 +++++++
 5 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/netwo=
rking/ip-sysctl.txt
index acdfb5d2bcaa..02f77e932adf 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -887,6 +887,14 @@ ip_local_reserved_ports - list of comma separated ra=
nges
=20
 	Default: Empty
=20
+ip_mr_cache_queue_length - INTEGER
+	Limit the number of multicast packets we can have in the queue to be
+	resolved.
+	Bear in mind that when an unresolved multicast packet is received,
+	there is an O(n) traversal of the queue. This should be considered
+	if increasing.
+	Default: 10
+
 ip_unprivileged_port_start - INTEGER
 	This is a per-namespace sysctl.  It defines the first
 	unprivileged port in the network namespace.  Privileged ports
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 104a6669e344..3411d3f18d51 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -187,6 +187,7 @@ struct netns_ipv4 {
 	int sysctl_igmp_max_msf;
 	int sysctl_igmp_llm_reports;
 	int sysctl_igmp_qrv;
+	unsigned int sysctl_ip_mr_cache_queue_length;
=20
 	struct ping_group_range ping_group_range;
=20
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 0dfb72c46671..8e25538bdb1e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1827,6 +1827,7 @@ static __net_init int inet_init_net(struct net *net=
)
 	net->ipv4.sysctl_igmp_llm_reports =3D 1;
 	net->ipv4.sysctl_igmp_qrv =3D 2;
=20
+	net->ipv4.sysctl_ip_mr_cache_queue_length =3D 10;
 	return 0;
 }
=20
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index ddbf8c9a1abb..c6a6c3e453a9 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1127,6 +1127,7 @@ static int ipmr_cache_unresolved(struct mr_table *m=
rt, vifi_t vifi,
 				 struct sk_buff *skb, struct net_device *dev)
 {
 	const struct iphdr *iph =3D ip_hdr(skb);
+	struct net *net =3D dev_net(dev);
 	struct mfc_cache *c;
 	bool found =3D false;
 	int err;
@@ -1142,7 +1143,8 @@ static int ipmr_cache_unresolved(struct mr_table *m=
rt, vifi_t vifi,
=20
 	if (!found) {
 		/* Create a new entry if allowable */
-		if (atomic_read(&mrt->cache_resolve_queue_len) >=3D 10 ||
+		if (atomic_read(&mrt->cache_resolve_queue_len) >=3D
+		    net->ipv4.sysctl_ip_mr_cache_queue_length ||
 		    (c =3D ipmr_cache_alloc_unres()) =3D=3D NULL) {
 			spin_unlock_bh(&mfc_unres_lock);
=20
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index ba0fc4b18465..78ae86e8c6cb 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -784,6 +784,13 @@ static struct ctl_table ipv4_net_table[] =3D {
 		.proc_handler	=3D proc_dointvec
 	},
 #ifdef CONFIG_IP_MULTICAST
+	{
+		.procname	=3D "ip_mr_cache_queue_length",
+		.data		=3D &init_net.ipv4.sysctl_ip_mr_cache_queue_length,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D proc_dointvec
+	},
 	{
 		.procname	=3D "igmp_qrv",
 		.data		=3D &init_net.ipv4.sysctl_igmp_qrv,
--=20
2.21.0

