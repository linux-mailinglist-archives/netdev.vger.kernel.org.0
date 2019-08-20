Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E4995AC7
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbfHTJRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:17:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:52917 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbfHTJRz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 05:17:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 02:17:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,408,1559545200"; 
   d="scan'208";a="169026483"
Received: from arappl-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.53.140])
  by orsmga007.jf.intel.com with ESMTP; 20 Aug 2019 02:17:47 -0700
Subject: Re: general protection fault in xsk_poll
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+c82697e3043781e08802@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org,
        yhs@fb.com
References: <20190820033154.9112-1-hdanton@sina.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <8a10ea50-fe61-55fd-0be4-5dff56d7effd@intel.com>
Date:   Tue, 20 Aug 2019 11:17:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820033154.9112-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-08-20 05:31, Hillf Danton wrote:
> 
> On Mon, 19 Aug 2019 18:18:06 -0700
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    da657043 Add linux-next specific files for 20190819
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=16af124c600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=739a9b3ab3d8c770
>> dashboard link: https://syzkaller.appspot.com/bug?extid=c82697e3043781e08802
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109e1922600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1445bf02600000
>>
>> The bug was bisected to:
>>
>> commit 77cd0d7b3f257fd0e3096b4fdcff1a7d38e99e10
>> Author: Magnus Karlsson <magnus.karlsson@intel.com>
>> Date:   Wed Aug 14 07:27:17 2019 +0000
>>
>>       xsk: add support for need_wakeup flag in AF_XDP rings
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e1ea4c600000
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=17e1ea4c600000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13e1ea4c600000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
>> Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
>>
>> kasan: CONFIG_KASAN_INLINE enabled
>> kasan: GPF could be caused by NULL-ptr deref or user memory access
>> general protection fault: 0000 [#1] PREEMPT SMP KASAN
>> CPU: 1 PID: 7959 Comm: syz-executor611 Not tainted 5.3.0-rc5-next-20190819 #68
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> RIP: 0010:xsk_poll+0x95/0x540 net/xdp/xsk.c:386
>> Code: 80 3c 02 00 0f 85 70 04 00 00 4c 8b a3 88 04 00 00 48 b8 00 00 00 00
>> 00 fc ff df 49 8d bc 24 96 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48
>> 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 bf 03 00 00
>> RSP: 0018:ffff8880926f7850 EFLAGS: 00010207
>> RAX: dffffc0000000000 RBX: ffff88809a141700 RCX: ffffffff859b07aa
>> RDX: 0000000000000012 RSI: ffffffff859b07c4 RDI: 0000000000000096
>> RBP: ffff8880926f7880 R08: ffff88809698a580 R09: ffffed1013428329
>> R10: ffffed1013428328 R11: ffff88809a141947 R12: 0000000000000000
>> R13: 0000000000000304 R14: ffff888095d4d840 R15: ffff888092bdd020
>> FS:  0000555557529880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000020000280 CR3: 0000000098281000 CR4: 00000000001406e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>    sock_poll+0x15e/0x480 net/socket.c:1256
>>    vfs_poll include/linux/poll.h:90 [inline]
>>    do_pollfd fs/select.c:859 [inline]
>>    do_poll fs/select.c:907 [inline]
>>    do_sys_poll+0x7c2/0xde0 fs/select.c:1001
>>    __do_sys_ppoll fs/select.c:1101 [inline]
>>    __se_sys_ppoll fs/select.c:1081 [inline]
>>    __x64_sys_ppoll+0x259/0x310 fs/select.c:1081
>>    do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> RIP: 0033:0x440159
>> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
>> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
>> ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007ffd9fbd16e8 EFLAGS: 00000246 ORIG_RAX: 000000000000010f
>> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440159
>> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000020000280
>> RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004019e0
>> R13: 0000000000401a70 R14: 0000000000000000 R15: 0000000000000000
>> Modules linked in:
>> ---[ end trace da907175426b4065 ]---
> 
> Add umem check.
> 
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -381,9 +381,9 @@ static unsigned int xsk_poll(struct file
>   	struct sock *sk = sock->sk;
>   	struct xdp_sock *xs = xdp_sk(sk);
>   	struct net_device *dev = xs->dev;
> -	struct xdp_umem *umem = xs->umem;
> +	struct xdp_umem *umem = READ_ONCE(xs->umem);
>   
> -	if (umem->need_wakeup)
> +	if (umem && umem->need_wakeup)
>   		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
>   						umem->need_wakeup);
>   
> --
> 

Thanks!

What do you think about making it a bit more generic, like:

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index ee4428a892fa..08bed5e92af4 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -356,13 +356,20 @@ static int xsk_generic_xmit(struct sock *sk, 
struct msghdr *m,
  	return err;
  }

+static bool xsk_is_bound(struct xdp_sock *xs)
+{
+	struct net_device *dev = READ_ONCE(xs->dev);
+
+	return dev && xs->state == XSK_BOUND;
+}
+
  static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t 
total_len)
  {
  	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
  	struct sock *sk = sock->sk;
  	struct xdp_sock *xs = xdp_sk(sk);

-	if (unlikely(!xs->dev))
+	if (unlikely(!xsk_is_bound(xs)))
  		return -ENXIO;
  	if (unlikely(!(xs->dev->flags & IFF_UP)))
  		return -ENETDOWN;
@@ -383,6 +390,9 @@ static unsigned int xsk_poll(struct file *file, 
struct socket *sock,
  	struct net_device *dev = xs->dev;
  	struct xdp_umem *umem = xs->umem;

+	if (unlikely(!xsk_is_bound(xs)))
+		return mask;
+
  	if (umem->need_wakeup)
  		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
  						umem->need_wakeup);
@@ -417,7 +427,7 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
  {
  	struct net_device *dev = xs->dev;

-	if (!dev || xs->state != XSK_BOUND)
+	if (!xsk_is_bound(xs))
  		return;

  	xs->state = XSK_UNBOUND;
