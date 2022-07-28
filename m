Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9E2583642
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbiG1BWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiG1BWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:22:50 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714421CFEE
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 18:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658971370; x=1690507370;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/F/wiwC4iTgLXU/0ihP8NeNPJS5FhbA0ZTIjeYn++uc=;
  b=Pi+LZGE7nmAt4nUD6XhzJgZIXCX9WmPngBfaquSrC4iKYPElqgvhJOR2
   8+bHywpdpL/glI6aVMZq7lJEgovmYu/bqcITdt+ejyDwgE4QLL6c72Mrl
   8FsBEsBf9dQkpm2/m0WT5zo4WV74chaoUJj+lj4nE+jgFI6CDKdUfImVG
   s=;
X-IronPort-AV: E=Sophos;i="5.93,196,1654560000"; 
   d="scan'208";a="223198493"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-fc41acad.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 01:22:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-fc41acad.us-east-1.amazon.com (Postfix) with ESMTPS id 4C665C08D6;
        Thu, 28 Jul 2022 01:22:36 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 28 Jul 2022 01:22:35 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.111) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Thu, 28 Jul 2022 01:22:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
CC:     Lorenzo Colitti <lorenzo@google.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Ayushman Dutta <ayudutta@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>,
        <syzbot+a8430774139ec3ab7176@syzkaller.appspotmail.com>
Subject: [PATCH v2 net] net: ping6: Fix memleak in ipv6_renew_options().
Date:   Wed, 27 Jul 2022 18:22:20 -0700
Message-ID: <20220728012220.46918-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.111]
X-ClientProxiedBy: EX13D28UWB002.ant.amazon.com (10.43.161.140) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we close ping6 sockets, some resources are left unfreed because
pingv6_prot is missing sk->sk_prot->destroy().  As reported by
syzbot [0], just three syscalls leak 96 bytes and easily cause OOM.

    struct ipv6_sr_hdr *hdr;
    char data[24] = {0};
    int fd;

    hdr = (struct ipv6_sr_hdr *)data;
    hdr->hdrlen = 2;
    hdr->type = IPV6_SRCRT_TYPE_4;

    fd = socket(AF_INET6, SOCK_DGRAM, NEXTHDR_ICMP);
    setsockopt(fd, IPPROTO_IPV6, IPV6_RTHDR, data, 24);
    close(fd);

To fix memory leaks, let's add a destroy function.

Note the socket() syscall checks if the GID is within the range of
net.ipv4.ping_group_range.  The default value is [1, 0] so that no
GID meets the condition (1 <= GID <= 0).  Thus, the local DoS does
not succeed until we change the default value.  However, at least
Ubuntu/Fedora/RHEL loosen it.

    $ cat /usr/lib/sysctl.d/50-default.conf
    ...
    -net.ipv4.ping_group_range = 0 2147483647

Also, there could be another path reported with these options, and
some of them require CAP_NET_RAW.

  setsockopt
      IPV6_ADDRFORM (inet6_sk(sk)->pktoptions)
      IPV6_RECVPATHMTU (inet6_sk(sk)->rxpmtu)
      IPV6_HOPOPTS (inet6_sk(sk)->opt)
      IPV6_RTHDRDSTOPTS (inet6_sk(sk)->opt)
      IPV6_RTHDR (inet6_sk(sk)->opt)
      IPV6_DSTOPTS (inet6_sk(sk)->opt)
      IPV6_2292PKTOPTIONS (inet6_sk(sk)->opt)

  getsockopt
      IPV6_FLOWLABEL_MGR (inet6_sk(sk)->ipv6_fl_list)

For the record, I left a different splat with syzbot's one.

  unreferenced object 0xffff888006270c60 (size 96):
    comm "repro2", pid 231, jiffies 4294696626 (age 13.118s)
    hex dump (first 32 bytes):
      01 00 00 00 44 00 00 00 00 00 00 00 00 00 00 00  ....D...........
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<00000000f6bc7ea9>] sock_kmalloc (net/core/sock.c:2564 net/core/sock.c:2554)
      [<000000006d699550>] do_ipv6_setsockopt.constprop.0 (net/ipv6/ipv6_sockglue.c:715)
      [<00000000c3c3b1f5>] ipv6_setsockopt (net/ipv6/ipv6_sockglue.c:1024)
      [<000000007096a025>] __sys_setsockopt (net/socket.c:2254)
      [<000000003a8ff47b>] __x64_sys_setsockopt (net/socket.c:2265 net/socket.c:2262 net/socket.c:2262)
      [<000000007c409dcb>] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
      [<00000000e939c4a9>] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

[0]: https://syzkaller.appspot.com/bug?extid=a8430774139ec3ab7176

Fixes: 6d0bfe226116 ("net: ipv6: Add IPv6 support to the ping socket.")
Reported-by: syzbot+a8430774139ec3ab7176@syzkaller.appspotmail.com
Reported-by: Ayushman Dutta <ayudutta@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
v2:
  - Remove ip6_flush_pending_frames() (Jakub Kicinski)

v1: offlist
---
 net/ipv6/ping.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index ecf3a553a0dc..8c6c2d82c1cd 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -22,6 +22,11 @@
 #include <linux/proc_fs.h>
 #include <net/ping.h>
 
+static void ping_v6_destroy(struct sock *sk)
+{
+	inet6_destroy_sock(sk);
+}
+
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -181,6 +186,7 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
+	.destroy =	ping_v6_destroy,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,
-- 
2.30.2

