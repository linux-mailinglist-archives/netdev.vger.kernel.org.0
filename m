Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070B5E0FF6
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 04:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388643AbfJWCP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 22:15:56 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44747 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfJWCPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 22:15:55 -0400
Received: by mail-yw1-f68.google.com with SMTP id m13so6933919ywa.11
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 19:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rzxixNa/6RLaUEfvbZnJxMAm0UsnVwfiOu7es9Z5Owo=;
        b=LQ+8ZTvWlFrG0YS/Y63bS8sMZ8NKwxczclXQYGD1GO/G1b42Ju5o/90WITB7kW8uM2
         7kmqNMQJo4t2gMFR0Lz9gFxtgx8ZMj6TX6GCoQlRKoKaM//wC6IlqYDoTz5M9IKYmf4O
         QSr8c5cQBXmpRq9gCu2UgKlC2AHiKxxFq+uvdl9gbyTSoZ80UBLGOFoST5KSKcQHZkTI
         1g+QIANZwPdw02g6cZYj07qNWq3mqqPrsSoYztY2FrQ2NM5TAnHCPXaxwR8WVROmT0jK
         NLkdEf016Ru6B52nTPgLdQ0f6B7uYhNYxUmXTeWPhvMnbusaqB8kl1DV0LkDn6V6vyTu
         Prrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rzxixNa/6RLaUEfvbZnJxMAm0UsnVwfiOu7es9Z5Owo=;
        b=ik0Vtu8K+z0nGmLR9Fg/XAVNdNcSrbA4N8gZCBBMDiLza7sfVwQnUQoMjjb8MNzgPT
         uUCkETacbjg49AEudrNh/3fU/FjdLVJaTPiGSUo1vPX/gN/rhJP1LLVtgN1jtTQswu+U
         O3AXleNONemZcKmrP2VI474uxVOTmVMlxmBJ9NYv6yQ8CxWykdrhnwhb5y3aMFSYNqO9
         jmVpcg/32Rvvaf0EAGy9wfqO0lAkx4Nq3J3JCjZIA1YpicmiA9eRg+nzGNxgK+NqIXy8
         B94wXU+zSBPFhCzvg9m3LqgBRVcRiTzcOz09lC2lXN/VLOpXT3ZzvNW72CnCAxbP22fX
         7pIA==
X-Gm-Message-State: APjAAAW4OOrwjrX15la/j//3A2rduIX3WfIIm6g/vLzzH3mFQNbwmsdp
        9PaGimY1FRFnE/+HcYk+Th4ylmZEZ4L65ZNdOFxabw==
X-Google-Smtp-Source: APXvYqz6iuPaISjGyzp17CQb+tve58/Llc4BPoTDqJUdSolAc4mEff6s9TiVcfhS0JI4rZOsPE967Mehtr8k2ulQL2E=
X-Received: by 2002:a0d:fd03:: with SMTP id n3mr1102070ywf.170.1571796953862;
 Tue, 22 Oct 2019 19:15:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
 <20191022231051.30770-4-xiyou.wangcong@gmail.com> <CANn89i+Y+fMqPbT-YyKcbQOH96+D=U8K4wnNgFkGYtjStKPrEQ@mail.gmail.com>
 <CAM_iQpWxDN7Wm_ar7cStiMnhmmy7RK=BG5k4zwD+K6kbgfPEKw@mail.gmail.com>
In-Reply-To: <CAM_iQpWxDN7Wm_ar7cStiMnhmmy7RK=BG5k4zwD+K6kbgfPEKw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 22 Oct 2019 19:15:41 -0700
Message-ID: <CANn89i+Q5ucKuEAt6rotf2xwappiMgRwL0Cgmvvnk5adYb-o0w@mail.gmail.com>
Subject: Re: [Patch net-next 3/3] tcp: decouple TLP timer from RTO timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 6:10 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Oct 22, 2019 at 4:24 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Oct 22, 2019 at 4:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > Currently RTO, TLP and PROBE0 all share a same timer instance
> > > in kernel and use icsk->icsk_pending to dispatch the work.
> > > This causes spinlock contention when resetting the timer is
> > > too frequent, as clearly shown in the perf report:
> > >
> > >    61.72%    61.71%  swapper          [kernel.kallsyms]                        [k] queued_spin_lock_slowpath
> > >    ...
> > >     - 58.83% tcp_v4_rcv
> > >       - 58.80% tcp_v4_do_rcv
> > >          - 58.80% tcp_rcv_established
> > >             - 52.88% __tcp_push_pending_frames
> > >                - 52.88% tcp_write_xmit
> > >                   - 28.16% tcp_event_new_data_sent
> > >                      - 28.15% sk_reset_timer
> > >                         + mod_timer
> > >                   - 24.68% tcp_schedule_loss_probe
> > >                      - 24.68% sk_reset_timer
> > >                         + 24.68% mod_timer
> > >
> > > This patch decouples TLP timer from RTO timer by adding a new
> > > timer instance but still uses icsk->icsk_pending to dispatch,
> > > in order to minimize the risk of this patch.
> > >
> > > After this patch, the CPU time spent in tcp_write_xmit() reduced
> > > down to 10.92%.
> >
> > What is the exact benchmark you are running ?
> >
> > We never saw any contention like that, so lets make sure you are not
> > working around another issue.
>
> I simply ran 256 parallel netperf with 128 CPU's to trigger this
> spinlock contention, 100% reproducible here.

How many TX/RX queues on the NIC ?
What is the qdisc setup ?

>
> A single netperf TCP_RR could _also_ confirm the improvement:
>
> Before patch:
>
> $ netperf -H XXX -t TCP_RR -l 20
> MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0
> AF_INET to XXX () port 0 AF_INET : first burst 0
> Local /Remote
> Socket Size   Request  Resp.   Elapsed  Trans.
> Send   Recv   Size     Size    Time     Rate
> bytes  Bytes  bytes    bytes   secs.    per sec
>
> 655360 873800 1        1       20.00    17665.59
> 655360 873800
>
>
> After patch:
>
> $ netperf -H XXX -t TCP_RR -l 20
> MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0
> AF_INET to XXX () port 0 AF_INET : first burst 0
> Local /Remote
> Socket Size   Request  Resp.   Elapsed  Trans.
> Send   Recv   Size     Size    Time     Rate
> bytes  Bytes  bytes    bytes   secs.    per sec
>
> 655360 873800 1        1       20.00    18829.31
> 655360 873800
>
> (I have run it for multiple times, just pick a median one here.)
>
> The difference can also be observed by turning off/on TLP without patch.

OK thanks for using something I can repro easily :)

I ran the experiment ten times :

lpaa23:/export/hda3/google/edumazet# echo 3
>/proc/sys/net/ipv4/tcp_early_retrans
lpaa23:/export/hda3/google/edumazet# for f in {1..10}; do
./super_netperf 1 -H lpaa24 -t TCP_RR -l 20; done
  26797
  26850
  25266
  27605
  26586
  26341
  27255
  27532
  26657
  27253


Then disabled tlp, and got no obvious difference

lpaa23:/export/hda3/google/edumazet# echo 0
>/proc/sys/net/ipv4/tcp_early_retrans
lpaa23:/export/hda3/google/edumazet# for f in {1..10}; do
./super_netperf 1 -H lpaa24 -t TCP_RR -l 20; done
  25311
  24658
  27105
  27421
  27604
  24649
  26259
  27615
  27543
  26217

I tried with 256 concurrent flows, and same overall observation about
tlp not changing the numbers.
(In fact I am not even sure we arm RTO at all while doing a TCP_RR)
lpaa23:/export/hda3/google/edumazet# echo 3
>/proc/sys/net/ipv4/tcp_early_retrans
lpaa23:/export/hda3/google/edumazet# for f in {1..10}; do
./super_netperf 256 -H lpaa24 -t TCP_RR -l 20; done
1578682
1572444
1573490
1536378
1514905
1580854
1575949
1578925
1511164
1568213
lpaa23:/export/hda3/google/edumazet# echo 0
>/proc/sys/net/ipv4/tcp_early_retrans
lpaa23:/export/hda3/google/edumazet# for f in {1..10}; do
./super_netperf 256 -H lpaa24 -t TCP_RR -l 20; done
1576228
1578401
1577654
1579506
1570682
1582267
1550069
1530599
1583269
1578830


I wonder if you have some IRQ smp_affinity problem maybe, or some
scheduler strategy constantly migrating your user threads ?

TLP is quite subtle, having two timers instead of one is probably
going to trigger various bugs.
