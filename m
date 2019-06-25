Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E845570E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732903AbfFYSVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:21:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38048 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfFYSVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:21:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so18998814wrs.5
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:20:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pHXn/oXijnPhxKbzH9Dce5cPW6eiiOtMpHg7PFsf77s=;
        b=foEMgRF4AIkaUvGA6MeaS6F8yypcXeQs4MS+YlFPnEJo4cO1AZMySPlM9/cpZ66edj
         bohYrhy2XgqU3Bus/sBZLDS6sWTeEiC6iVfVvGRH50dsubMGAWAxx5QBoNe20tGm1BrA
         2ubXJKUTUATZP2pi1rgpPAa0czb7ZGA21ox9v0ea1kNcirjl+uB+a0Phmt+a4O3g4mRY
         c8cE5qhPbdAuFt9XQIhCd+B1G9qyankcgeb9KH2PfcpRfPEqBTZN+4ftF8f3/Vklab+T
         de5keOWBb9IUY7ZFCvfTISRVmjyLjn1rdH8CKKRhhwwHOB4aCaSLVNe+N+H168qZIxaU
         VCiA==
X-Gm-Message-State: APjAAAW3Lbah1QAuofInOlMGcGwqyC+UUg5NY2PfFth5MHXG7AvBvKn+
        VMdXbLrhN+rq0m9ydeEFCRPBOWLGnfKTWoXx/zY=
X-Google-Smtp-Source: APXvYqzbUptIs53qBbkJj0Vfqj3HxvNzdNa3aFm5X7mZQi80n7wbC0/Dzr4T4Ra+T97CyHqWIyi30gcaatCSHGQ1/8w=
X-Received: by 2002:adf:dbd2:: with SMTP id e18mr1947505wrj.110.1561486858993;
 Tue, 25 Jun 2019 11:20:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
 <20190621205935.og7ajx57j7usgycq@breakpoint.cc> <CAOftzPi5SO_tZeoEs1Apd5np=Sd2fFUPm1oome_31=rMqSD-=g@mail.gmail.com>
 <b6baadcb-29af-82f1-bebe-56d5f45b12e6@gmail.com>
In-Reply-To: <b6baadcb-29af-82f1-bebe-56d5f45b12e6@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Tue, 25 Jun 2019 11:20:46 -0700
Message-ID: <CAOftzPgOOy_jDXgBO2dJFGUU9cnAVCaXtD66R8VH3yXe7NpM7g@mail.gmail.com>
Subject: Re: Removing skb_orphan() from ip_rcv_core()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Joe Stringer <joe@wand.net.nz>, Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 11:37 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 6/24/19 8:17 PM, Joe Stringer wrote:
> > On Fri, Jun 21, 2019 at 1:59 PM Florian Westphal <fw@strlen.de> wrote:
> >> Joe Stringer <joe@wand.net.nz> wrote:
> >>> However, if I drop these lines then I end up causing sockets to
> >>> release references too many times. Seems like if we don't orphan the
> >>> skb here, then later logic assumes that we have one more reference
> >>> than we actually have, and decrements the count when it shouldn't
> >>> (perhaps the skb_steal_sock() call in __inet_lookup_skb() which seems
> >>> to assume we always have a reference to the socket?)
> >>
> >> We might be calling the wrong destructor (i.e., the one set by tcp
> >> receive instead of the one set at tx time)?
> >
> > Hmm, interesting thought. Sure enough, with a bit of bpftrace
> > debugging we find it's tcp_wfree():
> >
> > $ cat ip_rcv.bt
> > #include <linux/skbuff.h>
> >
> > kprobe:ip_rcv {
> >        $sk = ((struct sk_buff *)arg0)->sk;
> >        $des = ((struct sk_buff *)arg0)->destructor;
> >        if ($sk) {
> >                if ($des) {
> >                        printf("received %s on %s with sk destructor %s
> > set\n", str(arg0), str(arg1), ksym($des));
> >                        @ip4_stacks[kstack] = count();
> >                }
> >        }
> > }
> > $ sudo bpftrace ip_rcv.bt
> > Attaching 1 probe...
> > received  on eth0 with sk destructor tcp_wfree set
> > ^C
> >
> > @ip4_stacks[
> >    ip_rcv+1
> >    __netif_receive_skb+24
> >    process_backlog+179
> >    net_rx_action+304
> >    __do_softirq+220
> >    do_softirq_own_stack+42
> >    do_softirq.part.17+70
> >    __local_bh_enable_ip+101
> >    ip_finish_output2+421
> >    __ip_finish_output+187
> >    ip_finish_output+44
> >    ip_output+109
> >    ip_local_out+59
> >    __ip_queue_xmit+368
> >    ip_queue_xmit+16
> >    __tcp_transmit_skb+1303
> >    tcp_connect+2758
> >    tcp_v4_connect+1135
> >    __inet_stream_connect+214
> >    inet_stream_connect+59
> >    __sys_connect+237
> >    __x64_sys_connect+26
> >    do_syscall_64+90
> >    entry_SYSCALL_64_after_hwframe+68
> > ]: 1
> >
> > Is there a solution here where we call the destructor if it's not
> > sock_efree()? When the socket is later stolen, it will only return the
> > reference via a call to sock_put(), so presumably at that point in the
> > stack we already assume that the skb->destructor is not one of these
> > other destructors (otherwise we wouldn't release the resources
> > correctly).
> >
>
> What was the driver here ? In any case, the following patch should help.
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index eeacebd7debbe6a55daedb92f00afd48051ebaf8..5075b4b267af7057f69fcb935226fce097a920e2 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3699,6 +3699,7 @@ static __always_inline int ____dev_forward_skb(struct net_device *dev,
>                 return NET_RX_DROP;
>         }
>
> +       skb_orphan(skb);
>         skb_scrub_packet(skb, true);
>         skb->priority = 0;
>         return 0;

Looks like it was bridge in the end, found by attaching a similar
bpftrace program to __dev_forward_sk(). Interestingly enough, the
device attached to the skb reported its name as "eth0" despite not
having such a named link or named bridge that I could find anywhere
via "ip link" / "brctl show"..

    __dev_forward_skb+1
   dev_hard_start_xmit+151
   __dev_queue_xmit+1928
   dev_queue_xmit+16
   br_dev_queue_push_xmit+123
   br_forward_finish+69
   __br_forward+327
   br_forward+204
   br_dev_xmit+598
   dev_hard_start_xmit+151
   __dev_queue_xmit+1928
   dev_queue_xmit+16
   neigh_resolve_output+339
   ip_finish_output2+402
   __ip_finish_output+187
   ip_finish_output+44
   ip_output+109
   ip_local_out+59
   __ip_queue_xmit+368
   ip_queue_xmit+16
   __tcp_transmit_skb+1303
   tcp_connect+2758
   tcp_v4_connect+1135
   __inet_stream_connect+214
   inet_stream_connect+59
   __sys_connect+237
   __x64_sys_connect+26
   do_syscall_64+90
   entry_SYSCALL_64_after_hwframe+68

So I guess something like this could be another alternative:

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 82225b8b54f5..c2de2bb35080 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -65,6 +65,7 @@ EXPORT_SYMBOL_GPL(br_dev_queue_push_xmit);

int br_forward_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
{
+       skb_orphan(skb);
       skb->tstamp = 0;
       return NF_HOOK(NFPROTO_BRIDGE, NF_BR_POST_ROUTING,
                      net, sk, skb, NULL, skb->dev,
