Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B385BC266
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 07:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiISFCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 01:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiISFCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 01:02:40 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACC81AD84
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 22:02:38 -0700 (PDT)
Received: from fsav114.sakura.ne.jp (fsav114.sakura.ne.jp [27.133.134.241])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28J52aiE045450;
        Mon, 19 Sep 2022 14:02:36 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav114.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp);
 Mon, 19 Sep 2022 14:02:36 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28J52X8x045431
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 19 Sep 2022 14:02:35 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <f1567517-5614-2b2a-b42d-4c26433de3b2@I-love.SAKURA.ne.jp>
Date:   Mon, 19 Sep 2022 14:02:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: WARNING: locking bug in inet_autobind
Content-Language: en-US
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        syzbot <syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
References: <00000000000033a0120588fac894@google.com>
 <693b572a-6436-14e6-442c-c8f2f361ed94@I-love.SAKURA.ne.jp>
 <YydimPlesKO+4QKG@boqun-archlinux>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YydimPlesKO+4QKG@boqun-archlinux>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/09/19 3:25, Boqun Feng wrote:
> On Mon, Sep 19, 2022 at 12:52:45AM +0900, Tetsuo Handa wrote:
>> syzbot is reporting locking bug in inet_autobind(), for
>> commit 37159ef2c1ae1e69 ("l2tp: fix a lockdep splat") started
>> calling 
>>
>>   lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class, "l2tp_sock")
>>
>> in l2tp_tunnel_create() (which is currently in l2tp_tunnel_register()).
>> How can we fix this problem?
>>
> 
> Just a theory, it seems that we have a memory corruption happened for
> lockdep_set_class_and_name(), in l2tp_tunnel_register(), the "sk" gets
> published before lockdep_set_class_and_name():
> 
> 	tunnel->sock = sk;
> 	...
> 	lockdep_set_class_and_name(&sk->sk_lock.slock,...);
> 
> And what could happen is that sock_lock_init() races with the
> l2tp_tunnel_register(), which results into two
> lockdep_set_class_and_name()s race with each other.
> 
> Anyway, "sk" should not be published until its lock gets properly
> initialized, could you try the following (untested)? Looks to me all
> other code around the lockdep_set_class_and_name() should be moved
> upwards, but I don't want to pretend I'm an expert ;-)

This diff did not help.

  ------------[ cut here ]------------
  Looking for class "l2tp_sock" with key l2tp_socket_class, but found a different class "slock-AF_INET6" with the same key
  WARNING: CPU: 1 PID: 14195 at kernel/locking/lockdep.c:940 look_up_lock_class+0xcc/0x140
  Modules linked in:
  CPU: 1 PID: 14195 Comm: a.out Not tainted 6.0.0-rc6-dirty #863
  Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
  RIP: 0010:look_up_lock_class+0xcc/0x140

A roughly simplified reproducer (be unlikely able to reproduce) is shown below.

----------------------------------------
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <linux/if_pppox.h>

int main(int argc, char *argv[])
{
        const int fd0 = socket(AF_PPPOX, SOCK_STREAM, 1);
        const int fd1 = socket(AF_INET6, SOCK_DGRAM, IPPROTO_IP);
        struct sockaddr_pppol2tp addr0 = {
                .sa_family = AF_PPPOX, .sa_protocol = 1, .pppol2tp.fd = fd1, /* AF_INET6 UDP socket. */
                .pppol2tp.addr.sin_port = htons(1),
                .pppol2tp.addr.sin_addr = htonl(INADDR_LOOPBACK),
                .pppol2tp.s_tunnel = 2
        };
        struct sockaddr_in6 addr1 = { .sin6_family = AF_INET6, .sin6_port = htons(0), .sin6_addr = in6addr_loopback };
        if (fork() == 0) {
                connect(fd1, (struct sockaddr *) &addr1, sizeof(addr1)); /* Invoke inet_autobind() due to .sin6_port = htons(0). */
                _exit(0);
        }
        connect(fd0, (struct sockaddr *) &addr0, sizeof(addr0)); /* Call lockdep_set_class_and_name(sk) of already published fd1. */
        return 0;
}
----------------------------------------

The reproducer is creating two file descriptors via socket(AF_PPPOX, SOCK_STREAM, 1)
and socket(AF_INET6, SOCK_DGRAM, IPPROTO_IP).

The connect() on AF_PPPOX socket calls l2tp_tunnel_register() via pppol2tp_connect().
l2tp_tunnel_register() changes an already published socket's "sk" which can be reached
via file descriptor using sockfd_lookup(). And for this reproducer, a "sk" created via
socket(AF_INET6, SOCK_DGRAM, IPPROTO_IP) is modified by the connect() on AF_PPPOX socket.

But since this file descriptor is visible to userspace, the userspace can concurrently
call connect() on AF_INET6 socket (which invokes inet_autobind() by passing port == 0)
using this file descriptor. As a result, spin_lock_bh(&sk->sk_lock.slock) from
lock_sock_nested(sk) from lock_sock(sk) from inet_autobind() from inet_dgram_connect()
finds that there already is a class "slock-AF_INET6" which would have been a normal
result if l2tp_tunnel_register() did not call
lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class, "l2tp_sock")
on this AF_INET6 socket.

It seems like a race condition, for a debug printk() patch shown below suggested that
this happens when lock_sock(sk) and lockdep_set_class_and_name(&sk->sk_lock.slock) ran
in parallel.

----------------------------------------
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 3ca0cc467886..57b31d06b0e1 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -174,6 +174,8 @@ static int inet_autobind(struct sock *sk)
 {
 	struct inet_sock *inet;
 	/* We may need to bind the socket. */
+	if (!strcmp(current->comm, "a.out"))
+		pr_info("inet_autobind(sk=%px)\n", sk);
 	lock_sock(sk);
 	inet = inet_sk(sk);
 	if (!inet->inet_num) {
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7499c51b1850..1bb14b19bca0 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1509,8 +1509,12 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
 	sk->sk_destruct = &l2tp_tunnel_destruct;
+	if (!strcmp(current->comm, "a.out"))
+		pr_info("l2tp_tunnel_register(sk=%px) before\n", sk);
 	lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class,
 				   "l2tp_sock");
+	if (!strcmp(current->comm, "a.out"))
+		pr_info("l2tp_tunnel_register(sk=%px) after\n", sk);
 	sk->sk_allocation = GFP_ATOMIC;
 
 	trace_register_tunnel(tunnel);
----------------------------------------

----------------------------------------
[  229.873612][T41464] l2tp_core: l2tp_tunnel_register(sk=ffff8880148a7800) before
[  229.873619][T41464] l2tp_core: l2tp_tunnel_register(sk=ffff8880148a7800) after
[  229.873654][T41465] IPv4: inet_autobind(sk=ffff8880148a7800)
[  229.879263][T41468] IPv4: inet_autobind(sk=ffff8880d63a1e00)
[  229.879264][T41467] l2tp_core: l2tp_tunnel_register(sk=ffff8880d63a1e00) before
[  229.879272][T41468] ------------[ cut here ]------------
[  229.879272][T41467] l2tp_core: l2tp_tunnel_register(sk=ffff8880d63a1e00) after
[  229.879275][T41468] Looking for class "l2tp_sock" with key l2tp_socket_class, but found a different class "slock-AF_INET6" with the same key
[  229.879932][T41450] l2tp_core: l2tp_tunnel_register(sk=ffff88807c416180) after
[  229.882029][T41468] WARNING: CPU: 0 PID: 41468 at kernel/locking/lockdep.c:940 look_up_lock_class+0xcc/0x140
[  229.888126][T41471] IPv4: inet_autobind(sk=ffff88807c410000)
[  229.888126][T41470] l2tp_core: l2tp_tunnel_register(sk=ffff88807c410000) before
[  229.888134][T41470] l2tp_core: l2tp_tunnel_register(sk=ffff88807c410000) after
[  229.889140][T41468] Modules linked in:
[  230.006548][T41468] CPU: 0 PID: 41468 Comm: a.out Not tainted 6.0.0-rc6-00001-g7def00e9a851-dirty #871
[  230.009327][T41468] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  230.012117][T41468] RIP: 0010:look_up_lock_class+0xcc/0x140
[  230.014633][T41468] Code: 8b 17 48 c7 c0 90 42 4b 88 48 39 c2 74 c4 f6 05 dd 31 dc 01 01 75 bb c6 05 d4 31 dc 01 01 48 c7 c7 26 5e f3 85 e8 f4 17 4c fc <0f> 0b eb a4 e8 5b c1 93 fd 48 c7 c7 fd 4c 19 86 89 de e8 c5 06 ff
[  230.020534][T41468] RSP: 0018:ffffc90013bc3ba0 EFLAGS: 00010046
[  230.023183][T41468] RAX: 4ca7765a49bbb600 RBX: ffffffff8837db90 RCX: ffff8880d5ddd580
[  230.025998][T41468] RDX: 0000000000000000 RSI: 0000000080000201 RDI: 0000000000000000
[  230.028984][T41468] RBP: 0000000000000001 R08: ffffffff8136457a R09: 0000000000000000
[  230.031785][T41468] R10: ffffffff81366013 R11: ffff8880d5ddd580 R12: 0000000000000000
[  230.034512][T41468] R13: ffff8880d63a1eb0 R14: 0000000000000000 R15: 0000000000000000
[  230.037347][T41468] FS:  00007efccdb44640(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[  230.040207][T41468] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  230.042940][T41468] CR2: 00007efccdb43ef8 CR3: 0000000011a99000 CR4: 00000000000506f0
[  230.045741][T41468] Call Trace:
[  230.048282][T41468]  <TASK>
[  230.050869][T41468]  register_lock_class+0x48/0x300
[  230.053474][T41468]  __lock_acquire+0x87/0x3340
[  230.056057][T41468]  ? __lock_acquire+0x65f/0x3340
[  230.058852][T41468]  ? console_trylock_spinning+0x187/0x2c0
[  230.061637][T41468]  lock_acquire+0xc6/0x1d0
[  230.064189][T41468]  ? lock_sock_nested+0x56/0xa0
[  230.066753][T41468]  ? lock_sock_nested+0x56/0xa0
[  230.069337][T41468]  _raw_spin_lock_bh+0x31/0x40
[  230.071879][T41468]  ? lock_sock_nested+0x56/0xa0
[  230.074527][T41468]  lock_sock_nested+0x56/0xa0
[  230.077195][T41468]  inet_dgram_connect+0xd7/0x1c0
[  230.079829][T41468]  __sys_connect+0x137/0x150
[  230.082440][T41468]  ? syscall_enter_from_user_mode+0x2e/0x1d0
[  230.085198][T41468]  ? lockdep_hardirqs_on+0x8d/0x130
[  230.087957][T41468]  __x64_sys_connect+0x18/0x20
[  230.090690][T41468]  do_syscall_64+0x3d/0x90
[  230.093232][T41468]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
----------------------------------------

But unfortunately reordering

  tunnel->sock = sk;
  ...
  lockdep_set_class_and_name(&sk->sk_lock.slock,...);

by

  lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class, "l2tp_sock");
  smp_store_release(&tunnel->sock, sk);

does not help, for connect() on AF_INET6 socket is not finding this "sk" by
accessing tunnel->sock.

