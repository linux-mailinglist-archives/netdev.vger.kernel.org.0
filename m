Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B276439B4
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 00:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbiLEX5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 18:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbiLEX5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 18:57:52 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35D165E5
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 15:57:50 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id q190so3599531iod.10
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 15:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GSIqPXduJlFanom97XBLoEuLvh8SiPtbTgxfQXMpbc0=;
        b=kkNSWN2zeC0fdFsxdmzfipXeOEUbzILOt6EOpxumoJHrTAPZ0+VK8dI4YAfrt/x3Vj
         bD2vugxlIPivNs94+1JmU2kQhkNfkJelQhRN6Kh6mAUpm5HuNKWpp3/Am305Pvi03tkq
         1UJ4F995pxzAwdmAF2yiwfmtZdXbllziUDo54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GSIqPXduJlFanom97XBLoEuLvh8SiPtbTgxfQXMpbc0=;
        b=QmuTg7I0/BM+qYtJsV1k9KkjKCwbtrcQ7o8aIc/1nIW8J4ms8CYh8mdgt8sFY/96cc
         GmegUt//T5dlHXlY+bAZsE3TGnMZZUornMihCos4PL+3cv9sFnApFagF4s1HJJMW8oXR
         ME29Q+kOL/xgM3O2nNQwwNkIH3fOtxGpeTBAnDR9EBDUCB+6hpNqBBgXjFY8VFOfXU/o
         n3HULWnx5tY17C+o3kNKg+LCCuNtw02t0w9xrcgJcH+4BbSvleYFjFgAcayTx55BR7CO
         1tyaVkDJnqHQOuqe6AhBFlVvjL/h1bjRxWKHWo5cA4VLm693bGd8MyZ3aHt2ylWXC8jV
         BojA==
X-Gm-Message-State: ANoB5pl5yKgEn5utyrZakn64SgEzC9AtwTjUTxbWqSOlWiagu76OdXoB
        ykwBado3xKM0JhVn0fUkQ785Jaj//QrQ+sQ5w2rtOw==
X-Google-Smtp-Source: AA0mqf5VoIOH9QFbpAB4o5gTYC527MWyFJflUGxzkBDyOuWYxJkHGOEqztGfwWZZIsMDaPdg2v2T/g3kgrpW4+z/cTo=
X-Received: by 2002:a02:ce9a:0:b0:389:e42b:89fb with SMTP id
 y26-20020a02ce9a000000b00389e42b89fbmr17113953jaq.281.1670284669913; Mon, 05
 Dec 2022 15:57:49 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org> <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com> <Y4T43Tc54vlKjTN0@cmpxchg.org>
In-Reply-To: <Y4T43Tc54vlKjTN0@cmpxchg.org>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Mon, 5 Dec 2022 15:57:39 -0800
Message-ID: <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 10:07 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Tue, Nov 22, 2022 at 05:28:24PM -0800, Ivan Babrou wrote:
> > On Tue, Nov 22, 2022 at 2:11 PM Ivan Babrou <ivan@cloudflare.com> wrote:
> > >
> > > On Tue, Nov 22, 2022 at 12:05 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > >
> > > > On Mon, Nov 21, 2022 at 04:53:43PM -0800, Ivan Babrou wrote:
> > > > > Hello,
> > > > >
> > > > > We have observed a negative TCP throughput behavior from the following commit:
> > > > >
> > > > > * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
> > > > >
> > > > > It landed back in 2016 in v4.5, so it's not exactly a new issue.
> > > > >
> > > > > The crux of the issue is that in some cases with swap present the
> > > > > workload can be unfairly throttled in terms of TCP throughput.
> > > >
> > > > Thanks for the detailed analysis, Ivan.
> > > >
> > > > Originally, we pushed back on sockets only when regular page reclaim
> > > > had completely failed and we were about to OOM. This patch was an
> > > > attempt to be smarter about it and equalize pressure more smoothly
> > > > between socket memory, file cache, anonymous pages.
> > > >
> > > > After a recent discussion with Shakeel, I'm no longer quite sure the
> > > > kernel is the right place to attempt this sort of balancing. It kind
> > > > of depends on the workload which type of memory is more imporant. And
> > > > your report shows that vmpressure is a flawed mechanism to implement
> > > > this, anyway.
> > > >
> > > > So I'm thinking we should delete the vmpressure thing, and go back to
> > > > socket throttling only if an OOM is imminent. This is in line with
> > > > what we do at the system level: sockets get throttled only after
> > > > reclaim fails and we hit hard limits. It's then up to the users and
> > > > sysadmin to allocate a reasonable amount of buffers given the overall
> > > > memory budget.
> > > >
> > > > Cgroup accounting, limiting and OOM enforcement is still there for the
> > > > socket buffers, so misbehaving groups will be contained either way.
> > > >
> > > > What do you think? Something like the below patch?
> > >
> > > The idea sounds very reasonable to me. I can't really speak for the
> > > patch contents with any sort of authority, but it looks ok to my
> > > non-expert eyes.
> > >
> > > There were some conflicts when cherry-picking this into v5.15. I think
> > > the only real one was for the "!sc->proactive" condition not being
> > > present there. For the rest I just accepted the incoming change.
> > >
> > > I'm going to be away from my work computer until December 5th, but
> > > I'll try to expedite my backported patch to a production machine today
> > > to confirm that it makes the difference. If I can get some approvals
> > > on my internal PRs, I should be able to provide the results by EOD
> > > tomorrow.
> >
> > I tried the patch and something isn't right here.
>
> Thanks for giving it a sping.
>
> > With the patch applied I'm capped at ~120MB/s, which is a symptom of a
> > clamped window.
> >
> > I can't find any sockets with memcg->socket_pressure = 1, but at the
> > same time I only see the following rcv_ssthresh assigned to sockets:
>
> Hm, I don't see how socket accounting would alter the network behavior
> other than through socket_pressure=1.
>
> How do you look for that flag? If you haven't yet done something
> comparable, can you try with tracing to rule out sampling errors?

Apologies for a delayed reply, I took a week off away from computers.

I looked with bpftrace (from my bash_history):

$ sudo bpftrace -e 'kprobe:tcp_try_rmem_schedule { @sk[cpu] = arg0; }
kretprobe:tcp_try_rmem_schedule { $arg = @sk[cpu]; if ($arg) { $sk =
(struct sock *) $arg; $id = $sk->sk_memcg->css.cgroup->kn->id;
$socket_pressure = $sk->sk_memcg->socket_pressure; if ($id == 21379) {
printf("id = %d, socket_pressure = %d\n", $id, $socket_pressure); } }
}'

I tried your patch on top of v6.1-rc8 (where it produced no conflicts)
in my vm and it still gave me low numbers and nothing in
/sys/kernel/debug/tracing/trace. To be extra sure, I changed it from
trace_printk to just printk and it still didn't show up in dmesg, even
with constant low throughput:

ivan@vm:~$ curl -o /dev/null https://sim.cfperf.net/cached-assets/zero-5g.bin
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
 14 4768M   14  685M    0     0  12.9M      0  0:06:08  0:00:52  0:05:16 13.0M

I still saw clamped rcv_ssthresh:

$ sudo ss -tinm dport 443
State                  Recv-Q                  Send-Q
                 Local Address:Port
  Peer Address:Port                  Process
ESTAB                  0                       0
                     10.2.0.15:35800
162.159.136.82:443
skmem:(r0,rb2577228,t0,tb46080,f0,w0,o0,bl0,d0) cubic rto:201
rtt:0.42/0.09 ato:40 mss:1460 pmtu:1500 rcvmss:1440 advmss:1460
cwnd:10 bytes_sent:12948 bytes_acked:12949 bytes_received:2915062731
segs_out:506592 segs_in:2025111 data_segs_out:351 data_segs_in:2024911
send 278095238bps lastsnd:824 lastrcv:154 lastack:154 pacing_rate
556190472bps delivery_rate 47868848bps delivered:352 app_limited
busy:147ms rcv_rtt:0.011 rcv_space:82199 rcv_ssthresh:5840
minrtt:0.059 snd_wnd:65535 tcp-ulp-tls rxconf: none txconf: none

I also tried with my detection program for ebpf_exporter (fexit based version):

* https://github.com/cloudflare/ebpf_exporter/pull/172/files

Which also showed signs of a clamped window:

# HELP ebpf_exporter_tcp_window_clamps_total Number of times that TCP
window was clamped to a low value
# TYPE ebpf_exporter_tcp_window_clamps_total counter
ebpf_exporter_tcp_window_clamps_total 53887

In fact, I can replicate this with just curl to a public URL and fio running,

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 066166aebbef..134b623bee6a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7211,6 +7211,7 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
>                 goto success;
>         }
>         memcg->socket_pressure = 1;
> +       trace_printk("skmem charge failed nr_pages=%u gfp=%pGg\n", nr_pages, &gfp_mask);
>         if (gfp_mask & __GFP_NOFAIL) {
>                 try_charge(memcg, gfp_mask, nr_pages);
>                 goto success;
