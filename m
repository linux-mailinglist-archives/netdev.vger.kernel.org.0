Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E526331A5
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiKVAyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiKVAxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:53:55 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909EBDEAF0
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:53:54 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id k84so15598348ybk.3
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O6WUOw9T0DV19s/c2TGTrCQrdf4F5EyxA3HYag+nfl0=;
        b=K7uGD5oz/aX87z0dSzQiMLPSWToAYxYdnapsn443FHnDX0Zpnyu7ogdz44QyeZYtkh
         N2soQOhA7Uf54WmfPwkNv8Wh6ohKOfa1RV33ck4avR0Fos+V9s17/WKxkSUAxC5H1lPj
         MHaYxnD5euM+lAJWHkrzN/9sC9BjhZNqYWqqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O6WUOw9T0DV19s/c2TGTrCQrdf4F5EyxA3HYag+nfl0=;
        b=1+qYrdTcSecrolrHNkccsBNbJugtmVNJgHchVYiOnY/iakIg6KfeAL5MCtp4ZE3vCQ
         G8iwaWgRSzLH/bzCCBXT1Lo7CNZN3wl6LDhdpHCo3ar+DYgCMPG7Q85OrnwwATXNQD/D
         fYWcYuNG6STs1eVc9bb0z6wTNYoukA0jK8HzephrqAouS2YunCZqx6HnpdLvIuvpz5sv
         qRMbGTNaFNLbgDQwVStikcfCYXusSJqC9ojkfA2HlGlIJ3SAxhpSKDAA2Th/c+OWb33d
         nEu+HMf7Vt67JCuYCYb7msKg0kGhqgmnbVyUmfarnZ5sIbGXcKYInCi/JIUI8VMewnDV
         qU4w==
X-Gm-Message-State: ANoB5pl2Cpe+3/YL3NH/6uXE4sb4fHm+txetoJ05Ej5/3IGl8u+1wV79
        yOIH6HE9H2Uo3+5rjVyVOmLi/I+mYv2lGgv9mD09gg==
X-Google-Smtp-Source: AA0mqf4EpbJUR3UuJTQ7sbSad4/fl/NT35pwFr98CaDrRMn5fwcn3TSYJxpSSSeDeV2CANvkQa9SkrJLEtQifg4QTpY=
X-Received: by 2002:a05:6902:1825:b0:6de:f09:2427 with SMTP id
 cf37-20020a056902182500b006de0f092427mr1386018ybb.125.1669078433693; Mon, 21
 Nov 2022 16:53:53 -0800 (PST)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Mon, 21 Nov 2022 16:53:43 -0800
Message-ID: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
Subject: Low TCP throughput due to vmpressure with swap enabled
To:     Linux MM <linux-mm@kvack.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
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

Hello,

We have observed a negative TCP throughput behavior from the following commit:

* 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure

It landed back in 2016 in v4.5, so it's not exactly a new issue.

The crux of the issue is that in some cases with swap present the
workload can be unfairly throttled in terms of TCP throughput.

I am able to reproduce this issue in a VM locally on v6.1-rc6 with 8
GiB of RAM with zram enabled.

The setup is fairly simple:

1. Run the following go proxy in one cgroup (it has some memory
ballast to simulate useful memory usage):

* https://gist.github.com/bobrik/2c1a8a19b921fefe22caac21fda1be82

sudo systemd-run --scope -p MemoryLimit=6G go run main.go

2. Run the following fio config in another cgroup to simulate mmapped
page cache usage:

[global]
size=8g
bs=256k
iodepth=256
direct=0
ioengine=mmap
group_reporting
time_based
runtime=86400
numjobs=8
name=randread
rw=randread

[job1]
filename=derp

sudo systemd-run --scope fio randread.fio

3. Run curl to request a large file via proxy:

curl -o /dev/null http://localhost:4444

4. Observe low throughput. The numbers here are dependent on your
location, but in my VM the throughput drops from 60MB/s to 10MB/s
depending on whether fio is running or not.

I can see that this happens because of the commit I mentioned with
some perf tracing:

sudo perf probe --add 'vmpressure:48 memcg->css.cgroup->kn->id scanned
vmpr_scanned=vmpr->scanned reclaimed vmpr_reclaimed=vmpr->reclaimed'
sudo perf probe --add 'vmpressure:72 memcg->css.cgroup->kn->id'

I can record the probes above during curl runtime:

sudo perf record -a -e probe:vmpressure_L48,probe:vmpressure_L72 -- sleep 5

Line 48 allows me to observe scanned and reclaimed page counters, line
72 is the actual throttling.

Here's an example trace showing my go proxy cgroup:

kswapd0 89 [002] 2351.221995: probe:vmpressure_L48: (ffffffed2639dd90)
id=0xf23 scanned=0x140 vmpr_scanned=0x0 reclaimed=0x0
vmpr_reclaimed=0x0
kswapd0 89 [007] 2351.333407: probe:vmpressure_L48: (ffffffed2639dd90)
id=0xf23 scanned=0x2b3 vmpr_scanned=0x140 reclaimed=0x0
vmpr_reclaimed=0x0
kswapd0 89 [007] 2351.333408: probe:vmpressure_L72: (ffffffed2639de2c) id=0xf23

We scanned lots of pages, but weren't able to reclaim anything.

When throttling happens, it's in tcp_prune_queue, where rcv_ssthresh
(TCP window clamp) is set to 4 x advmss:

* https://elixir.bootlin.com/linux/v5.15.76/source/net/ipv4/tcp_input.c#L5373

else if (tcp_under_memory_pressure(sk))
tp->rcv_ssthresh = min(tp->rcv_ssthresh, 4U * tp->advmss);

I can see plenty of memory available in both my go proxy cgroup and in
the system in general:

$ free -h
total used free shared buff/cache available
Mem: 7.8Gi 4.3Gi 104Mi 0.0Ki 3.3Gi 3.3Gi
Swap: 11Gi 242Mi 11Gi

It just so happens that all of the memory is hot and is not eligible
to be reclaimed. Since swap is enabled, the memory is still eligible
to be scanned. If swap is disabled, then my go proxy is not eligible
for scanning anymore (all memory is anonymous, nowhere to reclaim it),
so the whole issue goes away.

Punishing well behaving programs like that doesn't seem fair. We saw
production metals with 200GB page cache out of 384GB of RAM, where a
well behaved proxy with 60GB of RAM + 15GB of swap is throttled like
that. The fact that it only happens with swap makes it extra weird.

I'm not really sure what to do with this. From our end we'll probably
just pass cgroup.memory=nosocket in cmdline to disable this behavior
altogether, since it's not like we're running out of TCP memory (and
we can deal with that better if it ever comes to that). There should
probably be a better general case solution.

I don't know how widespread this issue can be. You need a fair amount
of page cache pressure to try to go to anonymous memory for reclaim to
trigger this.

Either way, this seems like a bit of a landmine.
