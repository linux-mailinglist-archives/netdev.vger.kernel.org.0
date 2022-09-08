Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B015B11E5
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiIHBL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIHBLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:11:55 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16631C6B73
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 18:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662599514; x=1694135514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gl3CAgPKh+lxQpjbeFgKpWzUrsdo1vIhUW2F5d88uYc=;
  b=b5bT0nTMj53QTD7CxAmaN+vi86NUI3SFYgt3BZhYtoLra0zTVRONcS3y
   AppLfjBrnuykBnbfJI6kncIkKNjgarvfoTxb/zJgBMpsojC6KV7QTEqob
   8LhwBdjo5XYa1W5Rw18o/AxQxRQrRTIE4kXksPj3vq+FQ/pg6d/+qLKmd
   I=;
X-IronPort-AV: E=Sophos;i="5.93,298,1654560000"; 
   d="scan'208";a="127861729"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-1801e169.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 01:11:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-1801e169.us-west-2.amazon.com (Postfix) with ESMTPS id 907B7C0AB0;
        Thu,  8 Sep 2022 01:11:53 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 8 Sep 2022 01:11:52 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 8 Sep 2022 01:11:50 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v6 net-next 5/6] tcp: Save unnecessary inet_twsk_purge() calls.
Date:   Wed, 7 Sep 2022 18:10:21 -0700
Message-ID: <20220908011022.45342-6-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908011022.45342-1-kuniyu@amazon.com>
References: <20220908011022.45342-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D05UWC002.ant.amazon.com (10.43.162.92) To
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

While destroying netns, we call inet_twsk_purge() in tcp_sk_exit_batch()
and tcpv6_net_exit_batch() for AF_INET and AF_INET6.  These commands
trigger the kernel to walk through the potentially big ehash twice even
though the netns has no TIME_WAIT sockets.

  # ip netns add test
  # ip netns del test

  or

  # unshare -n /bin/true >/dev/null

When tw_refcount is 1, we need not call inet_twsk_purge() at least
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
 net/ipv4/tcp_minisocks.c | 15 +++++++++++++++
 net/ipv6/tcp_ipv6.c      |  2 +-
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 735e957f7f4b..27e8d378c70a 100644
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
index 9aa186af6c44..73e6854ea662 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3206,7 +3206,7 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
 	struct net *net;
 
-	inet_twsk_purge(&tcp_hashinfo, AF_INET);
+	tcp_twsk_purge(net_exit_list, AF_INET);
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		WARN_ON_ONCE(!refcount_dec_and_test(&net->ipv4.tcp_death_row.tw_refcount));
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 2e53981252d9..98c576d4b671 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -347,6 +347,21 @@ void tcp_twsk_destructor(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
+void tcp_twsk_purge(struct list_head *net_exit_list, int family)
+{
+	struct net *net;
+
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		/* The last refcount is decremented in tcp_sk_exit_batch() */
+		if (refcount_read(&net->ipv4.tcp_death_row.tw_refcount) == 1)
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

