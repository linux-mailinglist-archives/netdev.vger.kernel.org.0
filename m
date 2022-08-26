Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C315A1D9E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244374AbiHZAJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244459AbiHZAJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:09:22 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD14C9266;
        Thu, 25 Aug 2022 17:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472536; x=1693008536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lupG/hkxLZYJLRWEjd0CqZVhDdOqba4SPxvt9oRunTM=;
  b=ooxhf8sbRxkJCBtrkZpHUIsVVpKsEMs6KbRph76eu5PfYBfgwOu5BR61
   wKnHLgIxycFMREypk7ErRcmkjk7EPWc5rgr7vi4uORIhMmhm0zqFSPXeq
   qVu2uniGYOM6XeYOKKkXQykaANHkog1uMKzouuA90gOyAGQ0tWFW/BCeM
   g=;
X-IronPort-AV: E=Sophos;i="5.93,264,1654560000"; 
   d="scan'208";a="221028137"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:08:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com (Postfix) with ESMTPS id 31B0B44CFD;
        Fri, 26 Aug 2022 00:08:52 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:08:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:08:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v1 net-next 13/13] udp: Introduce optional per-netns hash table.
Date:   Thu, 25 Aug 2022 17:04:45 -0700
Message-ID: <20220826000445.46552-14-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826000445.46552-1-kuniyu@amazon.com>
References: <20220826000445.46552-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We introduce an optional per-netns hash table for UDP.

With a smaller hash table, we can look up sockets faster and isolate
noisy neighbours.  Also, we can reduce lock contention.

We can control the hash table size by a new sysctl knob.  However,
depending on workloads, it will require very sensitive tuning, so we
disable the feature by default (net.ipv4.udp_child_ehash_entries == 0).
Moreover, we can fall back to using the global hash table in case we
fail to allocate enough memory for a new hash table.

We can check the current hash table size by another read-only sysctl
knob, net.ipv4.udp_hash_entries.  A negative value means the netns
shares the global hash table (per-netns hash table is disabled or
failed to allocate memory).

We could optimise the hash table lookup/iteration further by removing
netns comparison for the per-netns one in the future.  Also, we could
optimise the sparse udp_hslot layout by putting it in udp_table.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 Documentation/networking/ip-sysctl.rst | 20 ++++++++
 include/net/netns/ipv4.h               |  2 +
 net/ipv4/sysctl_net_ipv4.c             | 56 +++++++++++++++++++++
 net/ipv4/udp.c                         | 69 ++++++++++++++++++++++++++
 4 files changed, 147 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 97a0952b11e3..6dc4e2853e39 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1090,6 +1090,26 @@ udp_rmem_min - INTEGER
 udp_wmem_min - INTEGER
 	UDP does not have tx memory accounting and this tunable has no effect.
 
+udp_hash_entries - INTEGER
+	Read-only number of hash buckets for UDP sockets in the current
+	networking namespace.
+
+	A negative value means the networking namespace does not own its
+	hash buckets and shares the initial networking namespace's one.
+
+udp_child_ehash_entries - INTEGER
+	Control the number of hash buckets for UDP sockets in the child
+	networking namespace, which must be set before clone() or unshare().
+
+	The written value except for 0 is rounded up to 2^n.  0 is a special
+	value, meaning the child networking namespace will share the initial
+	networking namespace's hash buckets.
+
+	Note that the child will use the global one in case the kernel
+	fails to allocate enough memory.
+
+	Default: 0
+
 RAW variables
 =============
 
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index c367da5d61e2..a1be7ebb7338 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -200,6 +200,8 @@ struct netns_ipv4 {
 
 	atomic_t dev_addr_genid;
 
+	unsigned int sysctl_udp_child_hash_entries;
+
 #ifdef CONFIG_SYSCTL
 	unsigned long *sysctl_local_reserved_ports;
 	int sysctl_ip_prot_sock;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 03a3187c4705..b3cea3f36463 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -424,6 +424,47 @@ static int proc_tcp_child_ehash_entries(struct ctl_table *table, int write,
 	return 0;
 }
 
+static int proc_udp_hash_entries(struct ctl_table *table, int write,
+				 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct net *net = container_of(table->data, struct net,
+				       ipv4.sysctl_udp_child_hash_entries);
+	int udp_hash_entries;
+	struct ctl_table tbl;
+
+	udp_hash_entries = net->ipv4.udp_table->mask + 1;
+
+	/* A negative number indicates that the child netns
+	 * shares the global udp_table.
+	 */
+	if (!net_eq(net, &init_net) && net->ipv4.udp_table == &udp_table)
+		udp_hash_entries *= -1;
+
+	tbl.data = &udp_hash_entries;
+	tbl.maxlen = sizeof(int);
+
+	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
+}
+
+static int proc_udp_child_hash_entries(struct ctl_table *table, int write,
+				       void *buffer, size_t *lenp, loff_t *ppos)
+{
+	unsigned int udp_child_hash_entries;
+	int ret;
+
+	ret = proc_douintvec(table, write, buffer, lenp, ppos);
+	if (!write || ret)
+		return ret;
+
+	udp_child_hash_entries = READ_ONCE(*(unsigned int *)table->data);
+	if (udp_child_hash_entries)
+		udp_child_hash_entries = roundup_pow_of_two(udp_child_hash_entries);
+
+	WRITE_ONCE(*(unsigned int *)table->data, udp_child_hash_entries);
+
+	return 0;
+}
+
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 					  void *buffer, size_t *lenp,
@@ -1378,6 +1419,21 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_INT_MAX,
 	},
+	{
+		.procname	= "udp_hash_entries",
+		.data		= &init_net.ipv4.sysctl_udp_child_hash_entries,
+		.mode		= 0444,
+		.proc_handler	= proc_udp_hash_entries,
+	},
+	{
+		.procname	= "udp_child_hash_entries",
+		.data		= &init_net.ipv4.sysctl_udp_child_hash_entries,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_udp_child_hash_entries,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
+	},
 	{
 		.procname	= "udp_rmem_min",
 		.data		= &init_net.ipv4.sysctl_udp_rmem_min,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index f4825e38762a..c41306225305 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3309,8 +3309,77 @@ static int __net_init udp_sysctl_init(struct net *net)
 	return 0;
 }
 
+static struct udp_table __net_init *udp_pernet_table_alloc(unsigned int hash_entries)
+{
+	struct udp_table *udptable;
+	int i;
+
+	udptable = kmalloc(sizeof(*udptable), GFP_KERNEL);
+	if (!udptable)
+		goto out;
+
+	udptable->hash = kvmalloc_array(hash_entries * 2,
+					sizeof(struct udp_hslot), GFP_KERNEL);
+	if (!udptable->hash)
+		goto free_table;
+
+	udptable->hash2 = udptable->hash + hash_entries;
+	udptable->mask = hash_entries - 1;
+	udptable->log = ilog2(hash_entries);
+
+	for (i = 0; i < hash_entries; i++) {
+		INIT_HLIST_HEAD(&udptable->hash[i].head);
+		udptable->hash[i].count = 0;
+		spin_lock_init(&udptable->hash[i].lock);
+
+		INIT_HLIST_HEAD(&udptable->hash2[i].head);
+		udptable->hash2[i].count = 0;
+		spin_lock_init(&udptable->hash2[i].lock);
+	}
+
+	return udptable;
+
+free_table:
+	kfree(udptable);
+out:
+	return NULL;
+}
+
+static int __net_init udp_pernet_table_init(struct net *net, struct net *old_net)
+{
+	struct udp_table *udptable;
+	unsigned int hash_entries;
+
+	hash_entries = READ_ONCE(old_net->ipv4.sysctl_udp_child_hash_entries);
+	if (!hash_entries)
+		goto out;
+
+	udptable = udp_pernet_table_alloc(hash_entries);
+	if (udptable)
+		net->ipv4.udp_table = udptable;
+	else
+		pr_warn("Failed to allocate UDP hash table (entries: %u) "
+			"for a netns, fallback to use the global one\n",
+			hash_entries);
+out:
+	return 0;
+}
+
+static void __net_exit udp_pernet_table_free(struct net *net)
+{
+	struct udp_table *udptable = net->ipv4.udp_table;
+
+	if (udptable == &udp_table)
+		return;
+
+	kvfree(udptable->hash);
+	kfree(udptable);
+}
+
 static struct pernet_operations __net_initdata udp_sysctl_ops = {
 	.init	= udp_sysctl_init,
+	.init2	= udp_pernet_table_init,
+	.exit	= udp_pernet_table_free,
 };
 
 #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
-- 
2.30.2

