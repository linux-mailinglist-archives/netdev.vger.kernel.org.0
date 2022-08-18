Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F18598B2C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiHRS3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344857AbiHRS3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:29:02 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D6F50725
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660847340; x=1692383340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3HO+MwBSYm0js8rRLBWuk9u9lswyw8cnQMtvZ/wyzO4=;
  b=RlX1lMwGVV43/rDAws8HBse67SIsk6zEMBOG5jjdSkngIlUeSsMhRIW6
   eN3wLoMS0RM1hOOdw6qrkxF5vwr9oz4xmnG+6QpB2wpZKu4dUF9gJC5UP
   TljK2BiM2dUgK4BgO9LyekeamhESJ9MrRPJXsotbOmPZhDG8ws3qpOofS
   A=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="1045727699"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 18:28:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com (Postfix) with ESMTPS id B37894C0162;
        Thu, 18 Aug 2022 18:28:56 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 18:28:56 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 18:28:54 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net 06/17] net: Fix data-races around sysctl_optmem_max.
Date:   Thu, 18 Aug 2022 11:26:42 -0700
Message-ID: <20220818182653.38940-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818182653.38940-1-kuniyu@amazon.com>
References: <20220818182653.38940-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
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

While reading sysctl_optmem_max, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/core/bpf_sk_storage.c | 5 +++--
 net/core/filter.c         | 9 +++++----
 net/core/sock.c           | 8 +++++---
 net/ipv4/ip_sockglue.c    | 6 +++---
 net/ipv6/ipv6_sockglue.c  | 4 ++--
 5 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 1b7f385643b4..94374d529ea4 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -310,11 +310,12 @@ BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, map, struct sock *, sk)
 static int bpf_sk_storage_charge(struct bpf_local_storage_map *smap,
 				 void *owner, u32 size)
 {
+	int optmem_max = READ_ONCE(sysctl_optmem_max);
 	struct sock *sk = (struct sock *)owner;
 
 	/* same check as in sock_kmalloc() */
-	if (size <= sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
+	if (size <= optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + size < optmem_max) {
 		atomic_add(size, &sk->sk_omem_alloc);
 		return 0;
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index c4f14ad82029..c191db80ce93 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1214,10 +1214,11 @@ void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp)
 static bool __sk_filter_charge(struct sock *sk, struct sk_filter *fp)
 {
 	u32 filter_size = bpf_prog_size(fp->prog->len);
+	int optmem_max = READ_ONCE(sysctl_optmem_max);
 
 	/* same check as in sock_kmalloc() */
-	if (filter_size <= sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + filter_size < sysctl_optmem_max) {
+	if (filter_size <= optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + filter_size < optmem_max) {
 		atomic_add(filter_size, &sk->sk_omem_alloc);
 		return true;
 	}
@@ -1548,7 +1549,7 @@ int sk_reuseport_attach_filter(struct sock_fprog *fprog, struct sock *sk)
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-	if (bpf_prog_size(prog->len) > sysctl_optmem_max)
+	if (bpf_prog_size(prog->len) > READ_ONCE(sysctl_optmem_max))
 		err = -ENOMEM;
 	else
 		err = reuseport_attach_prog(sk, prog);
@@ -1615,7 +1616,7 @@ int sk_reuseport_attach_bpf(u32 ufd, struct sock *sk)
 		}
 	} else {
 		/* BPF_PROG_TYPE_SOCKET_FILTER */
-		if (bpf_prog_size(prog->len) > sysctl_optmem_max) {
+		if (bpf_prog_size(prog->len) > READ_ONCE(sysctl_optmem_max)) {
 			err = -ENOMEM;
 			goto err_prog_put;
 		}
diff --git a/net/core/sock.c b/net/core/sock.c
index 303af52f3b79..95abf4604d88 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2536,7 +2536,7 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
 
 	/* small safe race: SKB_TRUESIZE may differ from final skb->truesize */
 	if (atomic_read(&sk->sk_omem_alloc) + SKB_TRUESIZE(size) >
-	    sysctl_optmem_max)
+	    READ_ONCE(sysctl_optmem_max))
 		return NULL;
 
 	skb = alloc_skb(size, priority);
@@ -2554,8 +2554,10 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
  */
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority)
 {
-	if ((unsigned int)size <= sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
+	int optmem_max = READ_ONCE(sysctl_optmem_max);
+
+	if ((unsigned int)size <= optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + size < optmem_max) {
 		void *mem;
 		/* First do the add, to avoid the race if kmalloc
 		 * might sleep.
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index a8a323ecbb54..e49a61a053a6 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -772,7 +772,7 @@ static int ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval, int optlen)
 
 	if (optlen < GROUP_FILTER_SIZE(0))
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max)
+	if (optlen > READ_ONCE(sysctl_optmem_max))
 		return -ENOBUFS;
 
 	gsf = memdup_sockptr(optval, optlen);
@@ -808,7 +808,7 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < size0)
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max - 4)
+	if (optlen > READ_ONCE(sysctl_optmem_max) - 4)
 		return -ENOBUFS;
 
 	p = kmalloc(optlen + 4, GFP_KERNEL);
@@ -1233,7 +1233,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 
 		if (optlen < IP_MSFILTER_SIZE(0))
 			goto e_inval;
-		if (optlen > sysctl_optmem_max) {
+		if (optlen > READ_ONCE(sysctl_optmem_max)) {
 			err = -ENOBUFS;
 			break;
 		}
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 222f6bf220ba..e0dcc7a193df 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -210,7 +210,7 @@ static int ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < GROUP_FILTER_SIZE(0))
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max)
+	if (optlen > READ_ONCE(sysctl_optmem_max))
 		return -ENOBUFS;
 
 	gsf = memdup_sockptr(optval, optlen);
@@ -244,7 +244,7 @@ static int compat_ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < size0)
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max - 4)
+	if (optlen > READ_ONCE(sysctl_optmem_max) - 4)
 		return -ENOBUFS;
 
 	p = kmalloc(optlen + 4, GFP_KERNEL);
-- 
2.30.2

