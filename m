Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052931A4CFE
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 02:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDKAtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 20:49:41 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:38546 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgDKAtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 20:49:40 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Apr 2020 20:49:40 EDT
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 27A6A1A402BF; Fri, 10 Apr 2020 17:43:20 -0700 (PDT)
Date:   Fri, 10 Apr 2020 17:43:20 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     netdev@vger.kernel.org
Cc:     courmisch@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at net/phonet/socket.c:LINE!
Message-ID: <20200411004320.py2cashe4edsjdzp@shells.gnugeneration.com>
References: <00000000000062b41d05a2ea82b0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000062b41d05a2ea82b0@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello peeps,

I stared a bit at the code surrounding this report, and maybe someone more
familiar with the network stack can clear something up for me real quick:

> RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline]

net/phonet/socket.c:
202 static int pn_socket_autobind(struct socket *sock)
203 {
204         struct sockaddr_pn sa;
205         int err;
206 
207         memset(&sa, 0, sizeof(sa));
208         sa.spn_family = AF_PHONET;
209         err = pn_socket_bind(sock, (struct sockaddr *)&sa,
210                                 sizeof(struct sockaddr_pn));
211         if (err != -EINVAL)
212                 return err;
213         BUG_ON(!pn_port(pn_sk(sock->sk)->sobject));
214         return 0; /* socket was already bound */
215 }

line 213 is the BUG_ON for !sock->sk->sobject, a phonet-specific member:

include/net/phonet/phonet.h:
 23 struct pn_sock {
 24         struct sock     sk;
 25         u16             sobject;
 26         u16             dobject;
 27         u8              resource;
 28 };

pn_socket_autobind() expects that to be non-null whenever pn_socket_bind()
returns -EINVAL, which seems odd, but the comment claims it's already bound,
let's look at pn_socket_bind():

net/phonet/socket.c:
156 static int pn_socket_bind(struct socket *sock, struct sockaddr *addr, int len)
157 {
158         struct sock *sk = sock->sk;
159         struct pn_sock *pn = pn_sk(sk);
160         struct sockaddr_pn *spn = (struct sockaddr_pn *)addr;
161         int err;
162         u16 handle;
163         u8 saddr;
164 
165         if (sk->sk_prot->bind)
166                 return sk->sk_prot->bind(sk, addr, len);
167 
168         if (len < sizeof(struct sockaddr_pn))
169                 return -EINVAL;
170         if (spn->spn_family != AF_PHONET)
171                 return -EAFNOSUPPORT;
172 
173         handle = pn_sockaddr_get_object((struct sockaddr_pn *)addr);
174         saddr = pn_addr(handle);
175         if (saddr && phonet_address_lookup(sock_net(sk), saddr))
176                 return -EADDRNOTAVAIL;
177 
178         lock_sock(sk); 
179         if (sk->sk_state != TCP_CLOSE || pn_port(pn->sobject)) {
180                 err = -EINVAL; /* attempt to rebind */
181                 goto out;
182         }
183         WARN_ON(sk_hashed(sk));
184         mutex_lock(&port_mutex);
185         err = sk->sk_prot->get_port(sk, pn_port(handle));
186         if (err)
187                 goto out_port;
188 
189         /* get_port() sets the port, bind() sets the address if applicable */
190         pn->sobject = pn_object(saddr, pn_port(pn->sobject));
191         pn->resource = spn->spn_resource;
192 
193         /* Enable RX on the socket */
194         err = sk->sk_prot->hash(sk);
195 out_port:
196         mutex_unlock(&port_mutex);
197 out:
198         release_sock(sk);
199         return err;
200 }


The first return branch in there simply hands off the bind to and indirection
sk->sk_prot->bind() if present.  This smells ripe for breaking the assumptions
of that BUG_ON().  I'm assuming there's no point for such an indirection if not
to enable a potentially non-phonet-ops hook, otherwise we'd just be do the
bind.  If not, isn't this plain recursive?  Color me confused.  Will other
bind() implementations return -EINVAL when already bound with sobject set? no.

Furthermore, -EINVAL is also returned when len < sizeof(struct sockaddr_pn),
maybe the rebind case should return -EADDRINUSE instead of -EINVAL?

I must be missing some things.

Regards,
Vito Caputo


On Fri, Apr 10, 2020 at 12:16:17AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    b93cfb9c net: icmp6: do not select saddr from iif when rou..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=13501d2be00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=94a7f1dec460ee83
> dashboard link: https://syzkaller.appspot.com/bug?extid=2dc91e7fc3dea88b1e8a
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> kernel BUG at net/phonet/socket.c:213!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 8394 Comm: syz-executor.4 Not tainted 5.6.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline]
> RIP: 0010:pn_socket_autobind+0x13c/0x160 net/phonet/socket.c:202
> Code: 44 05 00 00 00 00 00 44 89 e0 48 8b 4c 24 58 65 48 33 0c 25 28 00 00 00 75 23 48 83 c4 60 5b 5d 41 5c 41 5d c3 e8 b4 ad 41 fa <0f> 0b e8 9d 56 7f fa eb 9f e8 b6 56 7f fa e9 6d ff ff ff e8 0c dd
> RSP: 0018:ffffc900034cfda8 EFLAGS: 00010212
> RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc90011d66000
> RDX: 0000000000000081 RSI: ffffffff873183dc RDI: 0000000000000003
> RBP: 1ffff92000699fb5 R08: ffff8880620f61c0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f84223c9700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004d8730 CR3: 000000005cce0000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  pn_socket_listen+0x40/0x200 net/phonet/socket.c:399
>  __sys_listen+0x17d/0x250 net/socket.c:1696
>  __do_sys_listen net/socket.c:1705 [inline]
>  __se_sys_listen net/socket.c:1703 [inline]
>  __x64_sys_listen+0x50/0x70 net/socket.c:1703
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x45c889
> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f84223c8c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
> RAX: ffffffffffffffda RBX: 00007f84223c96d4 RCX: 000000000045c889
> RDX: 0000000000000000 RSI: 000000000000007d RDI: 0000000000000003
> RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 0000000000000712 R14: 00000000004c9e2d R15: 000000000076bf0c
> Modules linked in:
> ---[ end trace 65d6f1331216c544 ]---
> RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline]
> RIP: 0010:pn_socket_autobind+0x13c/0x160 net/phonet/socket.c:202
> Code: 44 05 00 00 00 00 00 44 89 e0 48 8b 4c 24 58 65 48 33 0c 25 28 00 00 00 75 23 48 83 c4 60 5b 5d 41 5c 41 5d c3 e8 b4 ad 41 fa <0f> 0b e8 9d 56 7f fa eb 9f e8 b6 56 7f fa e9 6d ff ff ff e8 0c dd
> RSP: 0018:ffffc900034cfda8 EFLAGS: 00010212
> RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc90011d66000
> RDX: 0000000000000081 RSI: ffffffff873183dc RDI: 0000000000000003
> RBP: 1ffff92000699fb5 R08: ffff8880620f61c0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f84223c9700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000076c000 CR3: 000000005cce0000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
