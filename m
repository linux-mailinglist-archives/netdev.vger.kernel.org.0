Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36257E225D
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388691AbfJWSOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:14:34 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:38775 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388645AbfJWSOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 14:14:34 -0400
Received: by mail-vs1-f65.google.com with SMTP id b123so14400888vsb.5
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 11:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UF7D/vQGYYb7ttu+KZ4qIs9WS2yhz1r0JMxao19zQlQ=;
        b=wUQt9RvswUfm9oyjOOY7JZcP55iFM79ANf64YiD0ZR2mAnuaETMDtTTzuqXHrrR/lc
         CqICTdAOsPYHQOtF0xfpYY9WKMZNAXpXGyJWBBwF7s139Yxs8j45DUUKwnd8jGjcWdVF
         AzcE24LawXPwnJ54VicavSk0N1BBm6ifPoC/uNZXRA7lxnxV+y7tAwazRWZDpXoUQi6s
         jpOX2iP4YIxXiUraeodslAY/F3IGxPrmS5q+h3TKy9mcKi/M6wR79zvU8+XzRPjr1hjL
         jQkS25LpAFRA2dHxBnSvA9iluVE1afAtXvR73eS92mgkY9nwidWb0hBU2W5YzpBl9e67
         oIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UF7D/vQGYYb7ttu+KZ4qIs9WS2yhz1r0JMxao19zQlQ=;
        b=Gs7s19sfDymBh1rUs3ckGqnBlbM66B0Nt8gzCFWLA5s7g0a3RNaECiJ5BJuxa6u89C
         nApnyzNVVt3kSn45DQKWbClroP3bv3qwe3n71u5M3R5jA+U5M5f4rPT0qf5GOFVsOkTM
         vkxK+s+xOZUnbXLuJT59YyBenzDNC48oqOjKWe4HPWQyaEPpWsk5k0O36ozbdTSX/1J6
         wkQRF6nvpSMdG69p3gjPq3NeQjqaTeXbI7GyB5auP7pd33hNpbxeDJmLr8Pz0BxAGXa0
         UOObt6+Xwoj6u7jrVUElFKNjzPAxZ0Cywvbck/E6opm/T4gJaXWFXbAcp8z/KHc4oR5L
         9GIQ==
X-Gm-Message-State: APjAAAVJkn2yy4BkLqgq/0/rYCINPRicp882S42vs+qcqCi2OfyTHDOO
        pZatwDcmKkno8T22lj18W+IsIEtPOnhPK2CZ3Buvsw==
X-Google-Smtp-Source: APXvYqwi/qWCHRGLva6trKXcm2InfbttDq6YFm0FZM9Mz1BApYHGNNEZ3ExHclW6vIIYPgl3Z+z2rdWhFcYCUxgcjoM=
X-Received: by 2002:a05:6102:11a:: with SMTP id z26mr4371871vsq.47.1571854472027;
 Wed, 23 Oct 2019 11:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
 <20191022231051.30770-4-xiyou.wangcong@gmail.com> <CANn89i+Y+fMqPbT-YyKcbQOH96+D=U8K4wnNgFkGYtjStKPrEQ@mail.gmail.com>
 <CAM_iQpWxDN7Wm_ar7cStiMnhmmy7RK=BG5k4zwD+K6kbgfPEKw@mail.gmail.com>
 <CANn89i+Q5ucKuEAt6rotf2xwappiMgRwL0Cgmvvnk5adYb-o0w@mail.gmail.com> <CAM_iQpWah2M2tG=+eRS86VtjknTiBC42DSwdHB8USpXgRsfWjw@mail.gmail.com>
In-Reply-To: <CAM_iQpWah2M2tG=+eRS86VtjknTiBC42DSwdHB8USpXgRsfWjw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 23 Oct 2019 11:14:20 -0700
Message-ID: <CANn89iKNAg9gwe-ZLSoknwG6-XS44aRZrEv4pDeiON50uXv-0A@mail.gmail.com>
Subject: Re: [Patch net-next 3/3] tcp: decouple TLP timer from RTO timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 10:40 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Oct 22, 2019 at 7:15 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Oct 22, 2019 at 6:10 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Tue, Oct 22, 2019 at 4:24 PM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Tue, Oct 22, 2019 at 4:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > Currently RTO, TLP and PROBE0 all share a same timer instance
> > > > > in kernel and use icsk->icsk_pending to dispatch the work.
> > > > > This causes spinlock contention when resetting the timer is
> > > > > too frequent, as clearly shown in the perf report:
> > > > >
> > > > >    61.72%    61.71%  swapper          [kernel.kallsyms]                        [k] queued_spin_lock_slowpath
> > > > >    ...
> > > > >     - 58.83% tcp_v4_rcv
> > > > >       - 58.80% tcp_v4_do_rcv
> > > > >          - 58.80% tcp_rcv_established
> > > > >             - 52.88% __tcp_push_pending_frames
> > > > >                - 52.88% tcp_write_xmit
> > > > >                   - 28.16% tcp_event_new_data_sent
> > > > >                      - 28.15% sk_reset_timer
> > > > >                         + mod_timer
> > > > >                   - 24.68% tcp_schedule_loss_probe
> > > > >                      - 24.68% sk_reset_timer
> > > > >                         + 24.68% mod_timer
> > > > >
> > > > > This patch decouples TLP timer from RTO timer by adding a new
> > > > > timer instance but still uses icsk->icsk_pending to dispatch,
> > > > > in order to minimize the risk of this patch.
> > > > >
> > > > > After this patch, the CPU time spent in tcp_write_xmit() reduced
> > > > > down to 10.92%.
> > > >
> > > > What is the exact benchmark you are running ?
> > > >
> > > > We never saw any contention like that, so lets make sure you are not
> > > > working around another issue.
> > >
> > > I simply ran 256 parallel netperf with 128 CPU's to trigger this
> > > spinlock contention, 100% reproducible here.
> >
> > How many TX/RX queues on the NIC ?
>
> 60 queues (default), 25Gbps NIC, mlx5.
>
> > What is the qdisc setup ?
>
> fq_codel, which is default here. Its parameters are default too.
>
> >
> > >
> > > A single netperf TCP_RR could _also_ confirm the improvement:
> > >
> > > Before patch:
> > >
> > > $ netperf -H XXX -t TCP_RR -l 20
> > > MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0
> > > AF_INET to XXX () port 0 AF_INET : first burst 0
> > > Local /Remote
> > > Socket Size   Request  Resp.   Elapsed  Trans.
> > > Send   Recv   Size     Size    Time     Rate
> > > bytes  Bytes  bytes    bytes   secs.    per sec
> > >
> > > 655360 873800 1        1       20.00    17665.59
> > > 655360 873800
> > >
> > >
> > > After patch:
> > >
> > > $ netperf -H XXX -t TCP_RR -l 20
> > > MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0
> > > AF_INET to XXX () port 0 AF_INET : first burst 0
> > > Local /Remote
> > > Socket Size   Request  Resp.   Elapsed  Trans.
> > > Send   Recv   Size     Size    Time     Rate
> > > bytes  Bytes  bytes    bytes   secs.    per sec
> > >
> > > 655360 873800 1        1       20.00    18829.31
> > > 655360 873800
> > >
> > > (I have run it for multiple times, just pick a median one here.)
> > >
> > > The difference can also be observed by turning off/on TLP without patch.
> >
> > OK thanks for using something I can repro easily :)
> >
> > I ran the experiment ten times :
>
> How many CPU's do you have?
>
>
> >
> > lpaa23:/export/hda3/google/edumazet# echo 3
> > >/proc/sys/net/ipv4/tcp_early_retrans
> > lpaa23:/export/hda3/google/edumazet# for f in {1..10}; do
> > ./super_netperf 1 -H lpaa24 -t TCP_RR -l 20; done
> >   26797
> >   26850
> >   25266
> >   27605
> >   26586
> >   26341
> >   27255
> >   27532
> >   26657
> >   27253
> >
> >
> > Then disabled tlp, and got no obvious difference
> >
> > lpaa23:/export/hda3/google/edumazet# echo 0
> > >/proc/sys/net/ipv4/tcp_early_retrans
> > lpaa23:/export/hda3/google/edumazet# for f in {1..10}; do
> > ./super_netperf 1 -H lpaa24 -t TCP_RR -l 20; done
> >   25311
> >   24658
> >   27105
> >   27421
> >   27604
> >   24649
> >   26259
> >   27615
> >   27543
> >   26217
> >
> > I tried with 256 concurrent flows, and same overall observation about
> > tlp not changing the numbers.
> > (In fact I am not even sure we arm RTO at all while doing a TCP_RR)
>
> In case you misunderstand, the CPU profiling I used is captured
> during 256 parallel TCP_STREAM.

When I asked you the workload, you gave me TCP_RR output, not TCP_STREAM :/

"A single netperf TCP_RR could _also_ confirm the improvement:"
