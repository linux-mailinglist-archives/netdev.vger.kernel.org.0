Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A35D5AF106
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbiIFQqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237863AbiIFQqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:46:09 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512DC7E038
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 09:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662481601; x=1694017601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TGql0ulHvhFhJoDQvwTVLhNx/rVZJi1wzTK0B8Ok6IE=;
  b=SM1wWBUV3pJovtk36M6aJTyQbpuimibqW5Zpl0E7gALM2ZF44KWWI21O
   sTD+7sRRmm6Z8mOhy9+d1UMwTUwP3z46JcoZnNYyJIwkHp8FlxIRTLWB1
   iGgz6rAjKJciYoF3kDccREHSXDAi1rbGmKNTPY8soPi+eBsRyG+ogaWTw
   4=;
X-IronPort-AV: E=Sophos;i="5.93,294,1654560000"; 
   d="scan'208";a="238170067"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 16:26:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id 6169445108;
        Tue,  6 Sep 2022 16:26:26 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 6 Sep 2022 16:26:25 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 6 Sep 2022 16:26:23 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 net-next 5/6] tcp: Save unnecessary inet_twsk_purge() calls.
Date:   Tue, 6 Sep 2022 09:24:22 -0700
Message-ID: <20220906162423.44410-6-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220906162423.44410-1-kuniyu@amazon.com>
References: <20220906162423.44410-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
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

When tw_refcount is 0, we need not call inet_twsk_purge() at least
for the net.  We can save such unneeded iterations if all netns in
net_exit_list have no TIME_WAIT sockets.  This change eliminates
the tax by the additional unshare() described in the next patch to
guarantee the per-netns ehash size.

Tested:

  # mount -t debugfs none /sys/kernel/debug/
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
 net/ipv4/tcp_ipv4.c      |  2 +-
 net/ipv4/tcp_minisocks.c | 14 ++++++++++++++
 net/ipv6/tcp_ipv6.c      |  2 +-
 4 files changed, 17 insertions(+), 2 deletions(-)

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
index 395e7b82b700..531b833a8056 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3205,7 +3205,7 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
 	struct net *net;
 
-	inet_twsk_purge(&tcp_hashinfo, AF_INET);
+	tcp_twsk_purge(net_exit_list, AF_INET);
 
 	list_for_each_entry(net, net_exit_list, exit_list)
 		tcp_fastopen_ctx_destroy(net);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 2e53981252d9..10d84a854e4d 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -347,6 +347,20 @@ void tcp_twsk_destructor(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
+void tcp_twsk_purge(struct list_head *net_exit_list, int family)
+{
+	struct net *net;
+
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		if (!refcount_read(&net->ipv4.tcp_death_row.tw_refcount))
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
index f9ed47eb9b93..06beed4e23bf 100644
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

