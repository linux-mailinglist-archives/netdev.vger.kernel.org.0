Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9649D3664DD
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 07:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhDUFcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 01:32:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:52094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhDUFb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 01:31:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 739CBACB1;
        Wed, 21 Apr 2021 05:31:25 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D7CEB60789; Wed, 21 Apr 2021 07:31:23 +0200 (CEST)
Date:   Wed, 21 Apr 2021 07:31:23 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, olteanv@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        edumazet@google.com, weiwan@google.com, cong.wang@bytedance.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        mkl@pengutronix.de, linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        pabeni@redhat.com, mzhivich@akamai.com, johunt@akamai.com,
        albcamus@gmail.com, kehuan.feng@gmail.com, a.fatoum@pengutronix.de,
        atenart@kernel.org, alexander.duyck@gmail.com, hdanton@sina.com,
        jgross@suse.com, JKosina@suse.com
Subject: Re: [PATCH net v4 1/2] net: sched: fix packet stuck problem for
 lockless qdisc
Message-ID: <20210421053123.wdq3kwlvf72kwtch@lion.mk-sys.cz>
References: <1618535809-11952-1-git-send-email-linyunsheng@huawei.com>
 <1618535809-11952-2-git-send-email-linyunsheng@huawei.com>
 <20210419152946.3n7adsd355rfeoda@lion.mk-sys.cz>
 <20210419235503.eo77f6s73a4d25oh@lion.mk-sys.cz>
 <20210420203459.h7top4zogn56oa55@lion.mk-sys.cz>
 <80d64438-e3e5-e861-4da0-f6c89e3c73f7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80d64438-e3e5-e861-4da0-f6c89e3c73f7@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 09:52:40AM +0800, Yunsheng Lin wrote:
> On 2021/4/21 4:34, Michal Kubecek wrote:
> > However, I noticed something disturbing in the results of a simple
> > 1-thread TCP_STREAM test (client sends data through a TCP connection to
> > server using long writes, we measure the amount of data received by the
> > server):
> > 
> >   server: 172.17.1.1, port 12543
> >   iterations: 20, threads: 1, test length: 30
> >   test: TCP_STREAM, message size: 1048576
> >   
> >   1     927403548.4 B/s,  avg   927403548.4 B/s, mdev           0.0 B/s (  0.0%)
> >   2    1176317172.1 B/s,  avg  1051860360.2 B/s, mdev   124456811.8 B/s ( 11.8%), confid. +/-  1581348251.3 B/s (150.3%)
> >   3     927335837.8 B/s,  avg  1010352186.1 B/s, mdev   117354970.3 B/s ( 11.6%), confid. +/-   357073677.2 B/s ( 35.3%)
> >   4    1176728045.1 B/s,  avg  1051946150.8 B/s, mdev   124576544.7 B/s ( 11.8%), confid. +/-   228863127.8 B/s ( 21.8%)
> >   5    1176788216.3 B/s,  avg  1076914563.9 B/s, mdev   122102985.3 B/s ( 11.3%), confid. +/-   169478943.5 B/s ( 15.7%)
> >   6    1158167055.1 B/s,  avg  1090456645.8 B/s, mdev   115504209.5 B/s ( 10.6%), confid. +/-   132805140.8 B/s ( 12.2%)
> >   7    1176243474.4 B/s,  avg  1102711907.0 B/s, mdev   111069717.1 B/s ( 10.1%), confid. +/-   110956822.2 B/s ( 10.1%)
> >   8    1176771142.8 B/s,  avg  1111969311.5 B/s, mdev   106744173.5 B/s (  9.6%), confid. +/-    95417120.0 B/s (  8.6%)
> >   9    1176206364.6 B/s,  avg  1119106761.8 B/s, mdev   102644185.2 B/s (  9.2%), confid. +/-    83685200.5 B/s (  7.5%)
> >   10   1175888409.4 B/s,  avg  1124784926.6 B/s, mdev    98855550.5 B/s (  8.8%), confid. +/-    74537085.1 B/s (  6.6%)
> >   11   1176541407.6 B/s,  avg  1129490061.2 B/s, mdev    95422224.8 B/s (  8.4%), confid. +/-    67230249.7 B/s (  6.0%)
> >   12    934185352.8 B/s,  avg  1113214668.9 B/s, mdev   106114984.5 B/s (  9.5%), confid. +/-    70420712.5 B/s (  6.3%)
> >   13   1176550558.1 B/s,  avg  1118086660.3 B/s, mdev   103339448.9 B/s (  9.2%), confid. +/-    65002902.4 B/s (  5.8%)
> >   14   1176521808.8 B/s,  avg  1122260599.5 B/s, mdev   100711151.3 B/s (  9.0%), confid. +/-    60333655.0 B/s (  5.4%)
> >   15   1176744840.8 B/s,  avg  1125892882.3 B/s, mdev    98240838.2 B/s (  8.7%), confid. +/-    56319052.3 B/s (  5.0%)
> >   16   1176593778.5 B/s,  avg  1129061688.3 B/s, mdev    95909740.8 B/s (  8.5%), confid. +/-    52771633.5 B/s (  4.7%)
> >   17   1176583967.4 B/s,  avg  1131857116.5 B/s, mdev    93715582.2 B/s (  8.3%), confid. +/-    49669258.6 B/s (  4.4%)
> >   18   1176853301.8 B/s,  avg  1134356904.5 B/s, mdev    91656530.2 B/s (  8.1%), confid. +/-    46905244.8 B/s (  4.1%)
> >   19   1176592845.7 B/s,  avg  1136579848.8 B/s, mdev    89709043.8 B/s (  7.9%), confid. +/-    44424855.9 B/s (  3.9%)
> >   20   1176608117.3 B/s,  avg  1138581262.2 B/s, mdev    87871692.6 B/s (  7.7%), confid. +/-    42193098.5 B/s (  3.7%)
> >   all                     avg  1138581262.2 B/s, mdev    87871692.6 B/s (  7.7%), confid. +/-    42193098.5 B/s (  3.7%)
> > 
> > Each line shows result of one 30 second long test and average, mean
> > deviation and 99% confidence interval half width through the iterations
> > so far. While 17 iteration results are essentially the wire speed minus
> > TCP overhead, iterations 1, 3 and 12 are more than 20% lower. As results
> > of the same test on unpatched 5.12-rc7 are much more consistent (the
> > lowest iteration result through the whole test was 1175939718.3 and the
> > mean deviation only 276889.1 B/s), it doesn't seeem to be just a random
> > fluctuation.
> 
> I think I need to relearn the statistial math to understand the above
> "99% confidence interval half width ":)

An easy way to understand it is that if the last column shows 42 MB/s,
it means that with 99% confidence (probability), the measured average
is within 42 MB/s off the actual one.

> But the problem do not seems related too much with "99% confidence
> interval half width ", but with "mean deviation"?

Mean deviation is a symptom here. What worries me is that most results
show the same value (corresponding to fully saturated line) with very
little variation, in some iterations (1, 3 and 12 here) we can suddenly
see much lower value (by ~2.5 GB/s, i.e. 20-25%). And as each iteration
runs the connection for 30 seconds, it cannot be just some short glitch.

I managed to get tcpdump captures yesterday but they are huge even with
"-s 128" (client ~5.6 GB, server ~9.0 GB) so that working with them is
rather slow so I did not find anything interesting yet.

> I tried using netperf, which seems only show throughput of 9415.06
> (10^6bits/sec) using 10G netdev. which tool did you used to show the
> above number?

9415.06 * 10^6 b/s is 1176.9 * 10^6 B/s so it's about the same as the
numbers above (the good ones, that is). As this was part of a longer
test trying different thread counts from 1 to 128, I was using another
utility I started writing recently:

  https://github.com/mkubecek/nperf

It is still raw and a lot of features are missing but it can be already
used for multithreaded TCP_STREAM and TCP_RR tests. In particular, the
output above was with

  nperf -H 172.17.1.1 -l 30 -i 20 --exact -t TCP_STREAM -M 1

The results are with 1 thread so that they should be also reproducible
with netperf too. But it needs to be repeated enough times, when
I wanted to get the packet captures, I did 40 iterations and only two of
them showed lower result.

Michal
