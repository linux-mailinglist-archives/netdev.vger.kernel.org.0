Return-Path: <netdev+bounces-3177-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F19705E32
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9ACE281345
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:41:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFD917FF;
	Wed, 17 May 2023 03:41:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6497A17E0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C7FC433EF;
	Wed, 17 May 2023 03:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684294878;
	bh=NIToN/GOEQREMjQHLE++rceqjjyh3crWeo+NXw3wODI=;
	h=From:To:Cc:Subject:Date:From;
	b=b1FeEocmdH+opKJdLYLKXC7smjOsUCOmPvdXMbedFHwXCXIeSIMl0DMUPHQ3vRc4U
	 S5c2Q8iY+cgy9b6xvvhfN66KoT0F8iMD/WE4umT4YBwN62hQpq7OJ6ULdyjo9nnfZV
	 cOLdxl87ss9YBJam+fy+o/gZOOV/cJC/ZuPPkOHqfajj/jGhRcDo0NTo501zBWuYre
	 +e83LU6eQHd2MwF2VsMJiaMrU9w17Eihkwndr4zp06X95Urq531arLu5yqubRmP2D+
	 3IBfj258iAsiuIJgPzyF83ORFQH9tIvOpyPlPmYAiovV/fyHfLArIVRReY45Ri8lsI
	 gWYjVyxYiS8fA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	angus.chen@jaguarmicro.com,
	Jakub Kicinski <kuba@kernel.org>,
	Ido Schimmel <idosch@idosch.org>,
	syzbot+a5e719ac7c268e414c95@syzkaller.appspotmail.com,
	syzbot+a03fd670838d927d9cd8@syzkaller.appspotmail.com
Subject: [PATCH net-next] Revert "net: Remove low_thresh in ip defrag"
Date: Tue, 16 May 2023 20:41:12 -0700
Message-Id: <20230517034112.1261835-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit b2cbac9b9b28730e9e53be20b6cdf979d3b9f27e.

We have multiple reports of obvious breakage from this patch.

Reported-by: Ido Schimmel <idosch@idosch.org>
Link: https://lore.kernel.org/all/ZGIRWjNcfqI8yY8W@shredder/
Link: https://lore.kernel.org/all/CADJHv_sDK=0RrMA2FTZQV5fw7UQ+qY=HG21Wu5qb0V9vvx5w6A@mail.gmail.com/
Reported-by: syzbot+a5e719ac7c268e414c95@syzkaller.appspotmail.com
Reported-by: syzbot+a03fd670838d927d9cd8@syzkaller.appspotmail.com
Fixes: b2cbac9b9b28 ("net: Remove low_thresh in ip defrag")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/nf_conntrack-sysctl.rst |  1 -
 include/net/inet_frag.h                          |  1 +
 net/ieee802154/6lowpan/reassembly.c              |  9 +++++----
 net/ipv4/ip_fragment.c                           | 13 ++++++++-----
 net/ipv6/netfilter/nf_conntrack_reasm.c          |  9 +++++----
 net/ipv6/reassembly.c                            |  9 +++++----
 6 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 9ca356bc7217..8b1045c3b59e 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -55,7 +55,6 @@ nf_conntrack_frag6_high_thresh - INTEGER
 	nf_conntrack_frag6_low_thresh is reached.
 
 nf_conntrack_frag6_low_thresh - INTEGER
-	(Obsolete since linux-4.17)
 	default 196608
 
 	See nf_conntrack_frag6_low_thresh
diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 8543e740891a..325ad893f624 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -13,6 +13,7 @@
 struct fqdir {
 	/* sysctls */
 	long			high_thresh;
+	long			low_thresh;
 	int			timeout;
 	int			max_dist;
 	struct inet_frags	*f;
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index 3ba4c0f27af9..a91283d1e5bf 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -318,7 +318,7 @@ int lowpan_frag_rcv(struct sk_buff *skb, u8 frag_type)
 }
 
 #ifdef CONFIG_SYSCTL
-static unsigned long lowpanfrag_low_thresh_unuesd = IPV6_FRAG_LOW_THRESH;
+
 static struct ctl_table lowpan_frags_ns_ctl_table[] = {
 	{
 		.procname	= "6lowpanfrag_high_thresh",
@@ -374,9 +374,9 @@ static int __net_init lowpan_frags_ns_sysctl_register(struct net *net)
 	}
 
 	table[0].data	= &ieee802154_lowpan->fqdir->high_thresh;
-	table[0].extra1 = &lowpanfrag_low_thresh_unuesd;
-	table[1].data   = &lowpanfrag_low_thresh_unuesd;
-	table[1].extra2 = &ieee802154_lowpan->fqdir->high_thresh;
+	table[0].extra1	= &ieee802154_lowpan->fqdir->low_thresh;
+	table[1].data	= &ieee802154_lowpan->fqdir->low_thresh;
+	table[1].extra2	= &ieee802154_lowpan->fqdir->high_thresh;
 	table[2].data	= &ieee802154_lowpan->fqdir->timeout;
 
 	hdr = register_net_sysctl(net, "net/ieee802154/6lowpan", table);
@@ -451,6 +451,7 @@ static int __net_init lowpan_frags_init_net(struct net *net)
 		return res;
 
 	ieee802154_lowpan->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
+	ieee802154_lowpan->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	ieee802154_lowpan->fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = lowpan_frags_ns_sysctl_register(net);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 0db5eb3dec83..69c00ffdcf3e 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -553,7 +553,7 @@ EXPORT_SYMBOL(ip_check_defrag);
 
 #ifdef CONFIG_SYSCTL
 static int dist_min;
-static unsigned long ipfrag_low_thresh_unused;
+
 static struct ctl_table ip4_frags_ns_ctl_table[] = {
 	{
 		.procname	= "ipfrag_high_thresh",
@@ -609,9 +609,9 @@ static int __net_init ip4_frags_ns_ctl_register(struct net *net)
 
 	}
 	table[0].data	= &net->ipv4.fqdir->high_thresh;
-	table[0].extra1 = &ipfrag_low_thresh_unused;
-	table[1].data	= &ipfrag_low_thresh_unused;
-	table[1].extra2 = &net->ipv4.fqdir->high_thresh;
+	table[0].extra1	= &net->ipv4.fqdir->low_thresh;
+	table[1].data	= &net->ipv4.fqdir->low_thresh;
+	table[1].extra2	= &net->ipv4.fqdir->high_thresh;
 	table[2].data	= &net->ipv4.fqdir->timeout;
 	table[3].data	= &net->ipv4.fqdir->max_dist;
 
@@ -674,9 +674,12 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 	 * A 64K fragment consumes 129736 bytes (44*2944)+200
 	 * (1500 truesize == 2944, sizeof(struct ipq) == 200)
 	 *
-	 * We will commit 4MB at one time. Should we cross that limit.
+	 * We will commit 4MB at one time. Should we cross that limit
+	 * we will prune down to 3MB, making room for approx 8 big 64K
+	 * fragments 8x128k.
 	 */
 	net->ipv4.fqdir->high_thresh = 4 * 1024 * 1024;
+	net->ipv4.fqdir->low_thresh  = 3 * 1024 * 1024;
 	/*
 	 * Important NOTE! Fragment queue must be destroyed before MSL expires.
 	 * RFC791 is wrong proposing to prolongate timer each fragment arrival
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index dc8a2854e7f3..d13240f13607 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -42,7 +42,7 @@ static struct nft_ct_frag6_pernet *nf_frag_pernet(struct net *net)
 }
 
 #ifdef CONFIG_SYSCTL
-static unsigned long nf_conntrack_frag6_low_thresh_unused = IPV6_FRAG_LOW_THRESH;
+
 static struct ctl_table nf_ct_frag6_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_frag6_timeout",
@@ -82,10 +82,10 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 	nf_frag = nf_frag_pernet(net);
 
 	table[0].data	= &nf_frag->fqdir->timeout;
-	table[1].data	= &nf_conntrack_frag6_low_thresh_unused;
-	table[1].extra2 = &nf_frag->fqdir->high_thresh;
+	table[1].data	= &nf_frag->fqdir->low_thresh;
+	table[1].extra2	= &nf_frag->fqdir->high_thresh;
 	table[2].data	= &nf_frag->fqdir->high_thresh;
-	table[2].extra1 = &nf_conntrack_frag6_low_thresh_unused;
+	table[2].extra1	= &nf_frag->fqdir->low_thresh;
 
 	hdr = register_net_sysctl(net, "net/netfilter", table);
 	if (hdr == NULL)
@@ -500,6 +500,7 @@ static int nf_ct_net_init(struct net *net)
 		return res;
 
 	nf_frag->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
+	nf_frag->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	nf_frag->fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = nf_ct_frag6_sysctl_register(net);
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index eb8373c25675..5bc8a28e67f9 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -416,7 +416,7 @@ static const struct inet6_protocol frag_protocol = {
 };
 
 #ifdef CONFIG_SYSCTL
-static unsigned long ip6_frags_low_thresh_unused = IPV6_FRAG_LOW_THRESH;
+
 static struct ctl_table ip6_frags_ns_ctl_table[] = {
 	{
 		.procname	= "ip6frag_high_thresh",
@@ -465,9 +465,9 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 
 	}
 	table[0].data	= &net->ipv6.fqdir->high_thresh;
-	table[0].extra1 = &ip6_frags_low_thresh_unused;
-	table[1].data   = &ip6_frags_low_thresh_unused;
-	table[1].extra2 = &net->ipv6.fqdir->high_thresh;
+	table[0].extra1	= &net->ipv6.fqdir->low_thresh;
+	table[1].data	= &net->ipv6.fqdir->low_thresh;
+	table[1].extra2	= &net->ipv6.fqdir->high_thresh;
 	table[2].data	= &net->ipv6.fqdir->timeout;
 
 	hdr = register_net_sysctl(net, "net/ipv6", table);
@@ -536,6 +536,7 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 		return res;
 
 	net->ipv6.fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
+	net->ipv6.fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	net->ipv6.fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = ip6_frags_ns_sysctl_register(net);
-- 
2.40.1


