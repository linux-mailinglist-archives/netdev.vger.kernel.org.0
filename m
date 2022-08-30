Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3F85A6CF4
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 21:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiH3TRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 15:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiH3TQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 15:16:52 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22866A499
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 12:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661887011; x=1693423011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b3Byx9LpyVVRCD6Cc9T3C09NLY+EG542BJqLca9XEwQ=;
  b=j7VwsIUQN9lHf1MnSXHxb73PBav1mNogncJnmHGXKM3B4+AKXWYeRSeA
   +FB9yCgiexDbhp4UjsBLYqJ9rMdtxed5C/lTVTMCaJoaJBGCV9MWGodHS
   oWAmolb5M/ygApHguBNvEORyAgZkZMYrot3XKTlucRgfzRt/ZvFFZh9rf
   A=;
X-IronPort-AV: E=Sophos;i="5.93,275,1654560000"; 
   d="scan'208";a="235790184"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 19:16:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com (Postfix) with ESMTPS id 061BE44DD0;
        Tue, 30 Aug 2022 19:16:49 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 30 Aug 2022 19:16:46 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 30 Aug 2022 19:16:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 4/5] tcp: Save unnecessary inet_twsk_purge() calls.
Date:   Tue, 30 Aug 2022 12:15:17 -0700
Message-ID: <20220830191518.77083-5-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220830191518.77083-1-kuniyu@amazon.com>
References: <20220830191518.77083-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D18UWA001.ant.amazon.com (10.43.160.11) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While destroying netns, we call inet_twsk_purge() in tcp_sk_exit_batch()
and tcpv6_net_exit_batch() for AF_INET and AF_INET6.  These commands
trigger the kernel to walk through the potentially big ehash twice even
though the netns has no TIME_WAIT sockets.

  # ip netns add test
  # ip netns del test

  or

  # unshare -n /bin/true >/dev/null

AF_INET6 uses module_init() to be loaded after AF_INET which uses
fs_initcall(), so tcpv6_net_ops is always registered after tcp_sk_ops.
Also, we clean up netns in the reverse order, so tcpv6_net_exit_batch()
is always called before tcp_sk_exit_batch().

The characteristic enables us to save such unneeded iterations when all
netns in net_exit_list have no tw sockets.  This change eliminates the
tax by the additional unshare() described in the next patch to guarantee
the per-netns ehash size.

Tested:

  # echo cleanup_net > /sys/kernel/debug/tracing/set_ftrace_filter
  # echo inet_twsk_purge >> /sys/kernel/debug/tracing/set_ftrace_filter
  # echo function > /sys/kernel/debug/tracing/current_tracer
  # cat ./add_del_unshare.sh
  for i in `seq 1 40`
  do
      (for j in `seq 1 100` ; do  unshare -n /bin/true >/dev/null ; done) &
  done
  wait;
  # ./add_del_unshare.sh

Before the patch:

  # cat /sys/kernel/debug/tracing/trace_pipe
    kworker/u128:0-8       [031] ...1.   174.162765: cleanup_net <-process_one_work
    kworker/u128:0-8       [031] ...1.   174.240796: inet_twsk_purge <-cleanup_net
    kworker/u128:0-8       [032] ...1.   174.244759: inet_twsk_purge <-tcp_sk_exit_batch
    kworker/u128:0-8       [034] ...1.   174.290861: cleanup_net <-process_one_work
    kworker/u128:0-8       [039] ...1.   175.245027: inet_twsk_purge <-cleanup_net
    kworker/u128:0-8       [046] ...1.   175.290541: inet_twsk_purge <-tcp_sk_exit_batch
    kworker/u128:0-8       [037] ...1.   175.321046: cleanup_net <-process_one_work
    kworker/u128:0-8       [024] ...1.   175.941633: inet_twsk_purge <-cleanup_net
    kworker/u128:0-8       [025] ...1.   176.242539: inet_twsk_purge <-tcp_sk_exit_batch

After:

  # cat /sys/kernel/debug/tracing/trace_pipe
    kworker/u128:0-8       [038] ...1.   428.116174: cleanup_net <-process_one_work
    kworker/u128:0-8       [038] ...1.   428.262532: cleanup_net <-process_one_work
    kworker/u128:0-8       [030] ...1.   429.292645: cleanup_net <-process_one_work

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/tcp.h        |  1 +
 net/ipv4/tcp_ipv4.c      |  6 ++++--
 net/ipv4/tcp_minisocks.c | 24 ++++++++++++++++++++++++
 net/ipv6/tcp_ipv6.c      |  2 +-
 4 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index d10962b9f0d0..f60996c1d7b3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -346,6 +346,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
 void tcp_rcv_space_adjust(struct sock *sk);
 int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp);
 void tcp_twsk_destructor(struct sock *sk);
+void tcp_twsk_purge(struct list_head *net_exit_list, int family);
 ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
 			struct pipe_inode_info *pipe, size_t len,
 			unsigned int flags);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b07930643b11..f4a502d57d45 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3109,8 +3109,10 @@ static void __net_exit tcp_sk_exit(struct net *net)
 	if (net->ipv4.tcp_congestion_control)
 		bpf_module_put(net->ipv4.tcp_congestion_control,
 			       net->ipv4.tcp_congestion_control->owner);
-	if (refcount_dec_and_test(&tcp_death_row->tw_refcount))
+	if (refcount_dec_and_test(&tcp_death_row->tw_refcount)) {
 		kfree(tcp_death_row);
+		net->ipv4.tcp_death_row = NULL;
+	}
 }
 
 static int __net_init tcp_sk_init(struct net *net)
@@ -3210,7 +3212,7 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
 	struct net *net;
 
-	inet_twsk_purge(&tcp_hashinfo, AF_INET);
+	tcp_twsk_purge(net_exit_list, AF_INET);
 
 	list_for_each_entry(net, net_exit_list, exit_list)
 		tcp_fastopen_ctx_destroy(net);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 361aad67c6d6..9168c5a33344 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -347,6 +347,30 @@ void tcp_twsk_destructor(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
+void tcp_twsk_purge(struct list_head *net_exit_list, int family)
+{
+	struct net *net;
+
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		if (!net->ipv4.tcp_death_row)
+			continue;
+
+		/* AF_INET6 using module_init() is always registered after
+		 * AF_INET using fs_initcall() and cleaned up in the reverse
+		 * order.
+		 *
+		 * The last refcount is decremented later in tcp_sk_exit().
+		 */
+		if (IS_ENABLED(CONFIG_IPV6) && family == AF_INET6 &&
+		    refcount_read(&net->ipv4.tcp_death_row->tw_refcount) == 1)
+			continue;
+
+		inet_twsk_purge(&tcp_hashinfo, family);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(tcp_twsk_purge);
+
 /* Warning : This function is called without sk_listener being locked.
  * Be sure to read socket fields once, as their value could change under us.
  */
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 27b2fd98a2c4..9cbc7f0d7149 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2229,7 +2229,7 @@ static void __net_exit tcpv6_net_exit(struct net *net)
 
 static void __net_exit tcpv6_net_exit_batch(struct list_head *net_exit_list)
 {
-	inet_twsk_purge(&tcp_hashinfo, AF_INET6);
+	tcp_twsk_purge(net_exit_list, AF_INET6);
 }
 
 static struct pernet_operations tcpv6_net_ops = {
-- 
2.30.2

