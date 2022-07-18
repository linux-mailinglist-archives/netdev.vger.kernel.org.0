Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD736577C89
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 09:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiGRH0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 03:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiGRH0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 03:26:43 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC0B13D6A
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 00:26:41 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id i206so19349681ybc.5
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 00:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G/O+nA8IRarEaPu/Sbcqdo7w1oDJ8qCTdmZXXIvRgVc=;
        b=aJlcdfo82G2xKvu8vmY6Ncl+QfcHzXLnOctCCh1gnot21/CAy88IXp/2yDjU73uIjz
         9KpMV1uWIjMqnyjsHbIZwI1iU6Dpjt2tepq85X20T0XYVMKmWAXLVxDj+dDnO1/Dfd8S
         1AWmAUWJGwnUD2jsqoQsWb/JyurDPEwKEoEukuPwVk9vpwFx7wXaaHiMX2ABtaJO5WgB
         pmTgG9ZkKe91DYyqD+eh93OAnqh/c6lUbqGB7BlzThe2mDqvjjcwKisXk71NkxdFskJZ
         2rjyTT/lxYXXEMBn92r5joOtrx4h7NuceOuTwwRDv3NxD4XLo84dnS0Bs5ojQvrhTed0
         0+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G/O+nA8IRarEaPu/Sbcqdo7w1oDJ8qCTdmZXXIvRgVc=;
        b=XWFecPi6n3kMj5hk0KUueBQhh+H44/0n+kRbmuuGxvKouMm9SKW4uAttp73cy/NYcp
         YNUdibM43qQYIHmw6olrfhG4h+lbDTOoQrC06IVfuaEi1L/spP6pbKsfn6SvA1mXR+FF
         7efrXYGQe75+oTYGGcB9iNv5OG1wQGSFt9exDwWw5M0f+4DD73MxdNdyhAyRJBQ4MndW
         4w4VKhyyG6naAWKXjoJ8+cVAqZ8BKRgmkZseEYSZo3WFh52/pfkUUCIhxULXKGHqkpWi
         a3DTVHgpZPio5MoUszEzLwsKZezcx/yQmGZcvyv36cKN8/VGNKik2fMR/5IG1Y/eeT9Z
         2XOg==
X-Gm-Message-State: AJIora8BduRLOYEWJ8AoX+C8Wr/SsF9TXQsaftd9ApWptHhxaliGad0k
        SNrsnYRSPkmFXr2A1L6rR6ihA+OIfiYW8nzjZiGtLcoszUW3MA==
X-Google-Smtp-Source: AGRyM1uobfss8QtsMS+nlk8LKRTEySR7F3HyNeI0X/HHJFsokvhhQrXLjlR0/uDrItqNXsEJWLfH5DsEBT45btoZEnI=
X-Received: by 2002:a25:aacc:0:b0:66f:f1ca:409c with SMTP id
 t70-20020a25aacc000000b0066ff1ca409cmr14417061ybi.36.1658129200711; Mon, 18
 Jul 2022 00:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220709222029.297471-1-xiyou.wangcong@gmail.com>
 <CANn89iJSQh-5DAhEL4Fh5ZDrtY47y0Mo9YJbG-rnj17pdXqoXA@mail.gmail.com> <YtQ/Np8DZBJVFO3l@pop-os.localdomain>
In-Reply-To: <YtQ/Np8DZBJVFO3l@pop-os.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 18 Jul 2022 09:26:29 +0200
Message-ID: <CANn89iLLANJLHG+_uUu5Z+V64BMCsYHRgCHVHENhZiMOrVUtMw@mail.gmail.com>
Subject: Re: [Patch bpf-next] tcp: fix sock skb accounting in tcp_read_skb()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 6:56 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Jul 12, 2022 at 03:20:37PM +0200, Eric Dumazet wrote:
> > On Sun, Jul 10, 2022 at 12:20 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > Before commit 965b57b469a5 ("net: Introduce a new proto_ops
> > > ->read_skb()"), skb was not dequeued from receive queue hence
> > > when we close TCP socket skb can be just flushed synchronously.
> > >
> > > After this commit, we have to uncharge skb immediately after being
> > > dequeued, otherwise it is still charged in the original sock. And we
> > > still need to retain skb->sk, as eBPF programs may extract sock
> > > information from skb->sk. Therefore, we have to call
> > > skb_set_owner_sk_safe() here.
> > >
> > > Fixes: 965b57b469a5 ("net: Introduce a new proto_ops ->read_skb()")
> > > Reported-and-tested-by: syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com
> > > Tested-by: Stanislav Fomichev <sdf@google.com>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  net/ipv4/tcp.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > index 9d2fd3ced21b..c6b1effb2afd 100644
> > > --- a/net/ipv4/tcp.c
> > > +++ b/net/ipv4/tcp.c
> > > @@ -1749,6 +1749,7 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
> > >                 int used;
> > >
> > >                 __skb_unlink(skb, &sk->sk_receive_queue);
> > > +               WARN_ON(!skb_set_owner_sk_safe(skb, sk));
> > >                 used = recv_actor(sk, skb);
> > >                 if (used <= 0) {
> > >                         if (!copied)
> > > --
> > > 2.34.1
> > >
> >
> > I am reading tcp_read_skb(),it seems to have other bugs.
> > I wonder why syzbot has not caught up yet.
>
> As you mentioned this here I assume you suggest I should fix all bugs in
> one patch? (I am fine either way in this case, only slightly prefer to fix
> one bug in each patch for readability.)

I only wonder that after fixing all bugs, we might end up with  tcp_read_sk()
being a clone of tcp_read_sock() :/

syzbot has a relevant report:

------------[ cut here ]------------
cleanup rbuf bug: copied 301B4426 seq 301B4426 rcvnxt 302142E8
WARNING: CPU: 0 PID: 3744 at net/ipv4/tcp.c:1567
tcp_cleanup_rbuf+0x11d/0x5b0 net/ipv4/tcp.c:1567
Modules linked in:
CPU: 0 PID: 3744 Comm: kworker/0:7 Not tainted
5.19.0-rc5-syzkaller-01095-gedb2c3476db9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 06/29/2022
Workqueue: events nsim_dev_trap_report_work
RIP: 0010:tcp_cleanup_rbuf+0x11d/0x5b0 net/ipv4/tcp.c:1567
Code: ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e d7 03 00 00 8b 8d 38
08 00 00 44 89 e2 44 89 f6 48 c7 c7 20 82 df 8a e8 94 d8 58 01 <0f> 0b
e8 cc 84 a0 f9 48 8d bd 88 07 00 00 48 b8 00 00 00 00 00 fc
RSP: 0018:ffffc90000007700 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 000000000004fef7 RCX: 0000000000000000
RDX: ffff8880201abb00 RSI: ffffffff8160d438 RDI: fffff52000000ed2
RBP: ffff888016819800 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000103 R11: 0000000000000001 R12: 00000000301b4426
R13: 0000000000000000 R14: 00000000301b4426 R15: 00000000301b4426
FS: 0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020c55000 CR3: 0000000075009000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<IRQ>
tcp_read_skb+0x29e/0x430 net/ipv4/tcp.c:1775
sk_psock_verdict_data_ready+0x9d/0xc0 net/core/skmsg.c:1209
tcp_data_ready+0x106/0x520 net/ipv4/tcp_input.c:4985
tcp_data_queue+0x1bb2/0x4c60 net/ipv4/tcp_input.c:5059
tcp_rcv_established+0x82f/0x20e0 net/ipv4/tcp_input.c:5984
tcp_v4_do_rcv+0x66c/0x9b0 net/ipv4/tcp_ipv4.c:1661
tcp_v4_rcv+0x343b/0x3940 net/ipv4/tcp_ipv4.c:2078
ip_protocol_deliver_rcu+0xa3/0x7c0 net/ipv4/ip_input.c:205
ip_local_deliver_finish+0x2e8/0x4c0 net/ipv4/ip_input.c:233
NF_HOOK include/linux/netfilter.h:307 [inline]
NF_HOOK include/linux/netfilter.h:301 [inline]
ip_local_deliver+0x1aa/0x200 net/ipv4/ip_input.c:254
dst_input include/net/dst.h:461 [inline]
ip_rcv_finish+0x1cb/0x2f0 net/ipv4/ip_input.c:437
NF_HOOK include/linux/netfilter.h:307 [inline]
NF_HOOK include/linux/netfilter.h:301 [inline]
ip_rcv+0xaa/0xd0 net/ipv4/ip_input.c:557
__netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5480
__netif_receive_skb+0x24/0x1b0 net/core/dev.c:5594
process_backlog+0x3a0/0x7c0 net/core/dev.c:5922
__napi_poll+0xb3/0x6e0 net/core/dev.c:6506
napi_poll net/core/dev.c:6573 [inline]
net_rx_action+0x9c1/0xd90 net/core/dev.c:6684
__do_softirq+0x29b/0x9c2 kernel/softirq.c:571
do_softirq.part.0+0xde/0x130 kernel/softirq.c:472
</IRQ>
<TASK>
do_softirq kernel/softirq.c:464 [inline]
__local_bh_enable_ip+0x102/0x120 kernel/softirq.c:396
spin_unlock_bh include/linux/spinlock.h:394 [inline]
nsim_dev_trap_report drivers/net/netdevsim/dev.c:814 [inline]
nsim_dev_trap_report_work+0x84d/0xba0 drivers/net/netdevsim/dev.c:840
process_one_work+0x996/0x1610 kernel/workqueue.c:2289
worker_thread+0x665/0x1080 kernel/workqueue.c:2436
kthread+0x2e9/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
</TASK>------------[ cut here ]------------
cleanup rbuf bug: copied 301B4426 seq 301B4426 rcvnxt 302142E8
WARNING: CPU: 0 PID: 3744 at net/ipv4/tcp.c:1567
tcp_cleanup_rbuf+0x11d/0x5b0 net/ipv4/tcp.c:1567
Modules linked in:
CPU: 0 PID: 3744 Comm: kworker/0:7 Not tainted
5.19.0-rc5-syzkaller-01095-gedb2c3476db9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 06/29/2022
Workqueue: events nsim_dev_trap_report_work
RIP: 0010:tcp_cleanup_rbuf+0x11d/0x5b0 net/ipv4/tcp.c:1567
Code: ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e d7 03 00 00 8b 8d 38
08 00 00 44 89 e2 44 89 f6 48 c7 c7 20 82 df 8a e8 94 d8 58 01 <0f> 0b
e8 cc 84 a0 f9 48 8d bd 88 07 00 00 48 b8 00 00 00 00 00 fc
RSP: 0018:ffffc90000007700 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 000000000004fef7 RCX: 0000000000000000
RDX: ffff8880201abb00 RSI: ffffffff8160d438 RDI: fffff52000000ed2
RBP: ffff888016819800 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000103 R11: 0000000000000001 R12: 00000000301b4426
R13: 0000000000000000 R14: 00000000301b4426 R15: 00000000301b4426
FS: 0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020c55000 CR3: 0000000075009000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<IRQ>
tcp_read_skb+0x29e/0x430 net/ipv4/tcp.c:1775
sk_psock_verdict_data_ready+0x9d/0xc0 net/core/skmsg.c:1209
tcp_data_ready+0x106/0x520 net/ipv4/tcp_input.c:4985
tcp_data_queue+0x1bb2/0x4c60 net/ipv4/tcp_input.c:5059
tcp_rcv_established+0x82f/0x20e0 net/ipv4/tcp_input.c:5984
tcp_v4_do_rcv+0x66c/0x9b0 net/ipv4/tcp_ipv4.c:1661
tcp_v4_rcv+0x343b/0x3940 net/ipv4/tcp_ipv4.c:2078
ip_protocol_deliver_rcu+0xa3/0x7c0 net/ipv4/ip_input.c:205
ip_local_deliver_finish+0x2e8/0x4c0 net/ipv4/ip_input.c:233
NF_HOOK include/linux/netfilter.h:307 [inline]
NF_HOOK include/linux/netfilter.h:301 [inline]
ip_local_deliver+0x1aa/0x200 net/ipv4/ip_input.c:254
dst_input include/net/dst.h:461 [inline]
ip_rcv_finish+0x1cb/0x2f0 net/ipv4/ip_input.c:437
NF_HOOK include/linux/netfilter.h:307 [inline]
NF_HOOK include/linux/netfilter.h:301 [inline]
ip_rcv+0xaa/0xd0 net/ipv4/ip_input.c:557
__netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5480
__netif_receive_skb+0x24/0x1b0 net/core/dev.c:5594
process_backlog+0x3a0/0x7c0 net/core/dev.c:5922
__napi_poll+0xb3/0x6e0 net/core/dev.c:6506
napi_poll net/core/dev.c:6573 [inline]
net_rx_action+0x9c1/0xd90 net/core/dev.c:6684
__do_softirq+0x29b/0x9c2 kernel/softirq.c:571
do_softirq.part.0+0xde/0x130 kernel/softirq.c:472
</IRQ>
<TASK>
do_softirq kernel/softirq.c:464 [inline]
__local_bh_enable_ip+0x102/0x120 kernel/softirq.c:396
spin_unlock_bh include/linux/spinlock.h:394 [inline]
nsim_dev_trap_report drivers/net/netdevsim/dev.c:814 [inline]
nsim_dev_trap_report_work+0x84d/0xba0 drivers/net/netdevsim/dev.c:840
process_one_work+0x996/0x1610 kernel/workqueue.c:2289
worker_thread+0x665/0x1080 kernel/workqueue.c:2436
kthread+0x2e9/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
</TASK>

>
> >
> > It ignores the offset value from tcp_recv_skb(), this looks wrong to me.
> > The reason tcp_read_sock() passes a @len parameter is that is it not
> > skb->len, but (skb->len - offset)
>
> If I understand tcp_recv_skb() correctly it only returns an offset for a
> partial read of an skb. IOW, if we always read an entire skb at a time,
> offset makes no sense here, right?
>
> >
> > Also if recv_actor(sk, skb) returns 0, we probably still need to
> > advance tp->copied_seq,
> > for instance if skb had a pure FIN (and thus skb->len == 0), since you
> > removed the skb from sk_receive_queue ?
>
> Doesn't the following code handle this case?
>
>         if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
>                 consume_skb(skb);
>                 ++seq;
>                 break;
>         }
>
> which is copied from tcp_read_sock()...

I do not think this is enough, because you can break from the loop
before doing this  check about TCPHDR_FIN,
after skb has been unlinked from sk_receive_queue. TCP won't be able
to catch FIN.

__skb_unlink(skb, &sk->sk_receive_queue);
used = recv_actor(sk, skb);
if (used <= 0) {
    if (!copied)
        copied = used;
    break;                         /// HERE ///
}
seq += used;
copied += used;

if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {



>
> Thanks.
