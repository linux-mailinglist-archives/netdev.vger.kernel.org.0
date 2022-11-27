Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DD6639920
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 02:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiK0BZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 20:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiK0BZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 20:25:04 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C36D15835
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 17:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669512303; x=1701048303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s/QbdGHkwLsjHemmMsOU1BGmeOr+XeI+Em63E4ALBHg=;
  b=CwMVBhZSY0CtoqPeBW+VtR/+sMjU1a9cSgLhNVB3+GNohZykRdpSvCp+
   4Glto78vh6/NQTnQu4CFeIGm4yDThDg9kxZ2P27iITziJEebWfrkMoICN
   isPNb18+DUjB1YO/v07tq8agLc3wbKCaiy3TKzvUhm9ejEMi3aiPJF3cE
   A=;
X-IronPort-AV: E=Sophos;i="5.96,197,1665446400"; 
   d="scan'208";a="243982975"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2022 01:24:57 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id E330681A5D;
        Sun, 27 Nov 2022 01:24:54 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 27 Nov 2022 01:24:54 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Sun, 27 Nov 2022 01:24:50 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Felipe Gasper <felipe@felipegasper.com>,
        Wei Chen <harperchen1110@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "Kuniyuki Iwashima" <kuni1840@gmail.com>, <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH v2 net 1/2] af_unix: Get user_ns from in_skb in unix_diag_get_exact().
Date:   Sun, 27 Nov 2022 10:24:11 +0900
Message-ID: <20221127012412.37969-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221127012412.37969-1-kuniyu@amazon.com>
References: <20221127012412.37969-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D44UWB001.ant.amazon.com (10.43.161.32) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wei Chen reported a NULL deref in sk_user_ns() [0][1], and Paolo diagnosed
the root cause: in unix_diag_get_exact(), the newly allocated skb does not
have sk. [2]

We must get the user_ns from the NETLINK_CB(in_skb).sk and pass it to
sk_diag_fill().

[0]:
BUG: kernel NULL pointer dereference, address: 0000000000000270
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 12bbce067 P4D 12bbce067 PUD 12bc40067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 27942 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:sk_user_ns include/net/sock.h:920 [inline]
RIP: 0010:sk_diag_dump_uid net/unix/diag.c:119 [inline]
RIP: 0010:sk_diag_fill+0x77d/0x890 net/unix/diag.c:170
Code: 89 ef e8 66 d4 2d fd c7 44 24 40 00 00 00 00 49 8d 7c 24 18 e8
54 d7 2d fd 49 8b 5c 24 18 48 8d bb 70 02 00 00 e8 43 d7 2d fd <48> 8b
9b 70 02 00 00 48 8d 7b 10 e8 33 d7 2d fd 48 8b 5b 10 48 8d
RSP: 0018:ffffc90000d67968 EFLAGS: 00010246
RAX: ffff88812badaa48 RBX: 0000000000000000 RCX: ffffffff840d481d
RDX: 0000000000000465 RSI: 0000000000000000 RDI: 0000000000000270
RBP: ffffc90000d679a8 R08: 0000000000000277 R09: 0000000000000000
R10: 0001ffffffffffff R11: 0001c90000d679a8 R12: ffff88812ac03800
R13: ffff88812c87c400 R14: ffff88812ae42210 R15: ffff888103026940
FS:  00007f08b4e6f700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000270 CR3: 000000012c58b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 unix_diag_get_exact net/unix/diag.c:285 [inline]
 unix_diag_handler_dump+0x3f9/0x500 net/unix/diag.c:317
 __sock_diag_cmd net/core/sock_diag.c:235 [inline]
 sock_diag_rcv_msg+0x237/0x250 net/core/sock_diag.c:266
 netlink_rcv_skb+0x13e/0x250 net/netlink/af_netlink.c:2564
 sock_diag_rcv+0x24/0x40 net/core/sock_diag.c:277
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x38f/0x500 net/socket.c:2476
 ___sys_sendmsg net/socket.c:2530 [inline]
 __sys_sendmsg+0x197/0x230 net/socket.c:2559
 __do_sys_sendmsg net/socket.c:2568 [inline]
 __se_sys_sendmsg net/socket.c:2566 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2566
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x4697f9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f08b4e6ec48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffdb36bc6c0
 </TASK>
Modules linked in:
CR2: 0000000000000270

[1]: https://lore.kernel.org/netdev/CAO4mrfdvyjFpokhNsiwZiP-wpdSD0AStcJwfKcKQdAALQ9_2Qw@mail.gmail.com/
[2]: https://lore.kernel.org/netdev/e04315e7c90d9a75613f3993c2baf2d344eef7eb.camel@redhat.com/

Fixes: cae9910e7344 ("net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Diagnosed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/diag.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index 105f522a89fe..616b55c5b890 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -114,14 +114,16 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 	return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
 }
 
-static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
+static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb,
+			    struct user_namespace *user_ns)
 {
-	uid_t uid = from_kuid_munged(sk_user_ns(nlskb->sk), sock_i_uid(sk));
+	uid_t uid = from_kuid_munged(user_ns, sock_i_uid(sk));
 	return nla_put(nlskb, UNIX_DIAG_UID, sizeof(uid_t), &uid);
 }
 
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_req *req,
-		u32 portid, u32 seq, u32 flags, int sk_ino)
+			struct user_namespace *user_ns,
+			u32 portid, u32 seq, u32 flags, int sk_ino)
 {
 	struct nlmsghdr *nlh;
 	struct unix_diag_msg *rep;
@@ -167,7 +169,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 		goto out_nlmsg_trim;
 
 	if ((req->udiag_show & UDIAG_SHOW_UID) &&
-	    sk_diag_dump_uid(sk, skb))
+	    sk_diag_dump_uid(sk, skb, user_ns))
 		goto out_nlmsg_trim;
 
 	nlmsg_end(skb, nlh);
@@ -179,7 +181,8 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 }
 
 static int sk_diag_dump(struct sock *sk, struct sk_buff *skb, struct unix_diag_req *req,
-		u32 portid, u32 seq, u32 flags)
+			struct user_namespace *user_ns,
+			u32 portid, u32 seq, u32 flags)
 {
 	int sk_ino;
 
@@ -190,7 +193,7 @@ static int sk_diag_dump(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	if (!sk_ino)
 		return 0;
 
-	return sk_diag_fill(sk, skb, req, portid, seq, flags, sk_ino);
+	return sk_diag_fill(sk, skb, req, user_ns, portid, seq, flags, sk_ino);
 }
 
 static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
@@ -214,7 +217,7 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 				goto next;
 			if (!(req->udiag_states & (1 << sk->sk_state)))
 				goto next;
-			if (sk_diag_dump(sk, skb, req,
+			if (sk_diag_dump(sk, skb, req, sk_user_ns(skb->sk),
 					 NETLINK_CB(cb->skb).portid,
 					 cb->nlh->nlmsg_seq,
 					 NLM_F_MULTI) < 0) {
@@ -282,7 +285,8 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 	if (!rep)
 		goto out;
 
-	err = sk_diag_fill(sk, rep, req, NETLINK_CB(in_skb).portid,
+	err = sk_diag_fill(sk, rep, req, sk_user_ns(NETLINK_CB(in_skb).sk),
+			   NETLINK_CB(in_skb).portid,
 			   nlh->nlmsg_seq, 0, req->udiag_ino);
 	if (err < 0) {
 		nlmsg_free(rep);
-- 
2.30.2

