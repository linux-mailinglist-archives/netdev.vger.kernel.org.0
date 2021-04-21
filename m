Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAED366379
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 03:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbhDUBxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 21:53:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3088 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhDUBxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 21:53:17 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FQ3PL2rC4zWPtY;
        Wed, 21 Apr 2021 09:48:54 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 21 Apr 2021 09:52:42 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 21 Apr
 2021 09:52:41 +0800
Subject: Re: [PATCH net v4 1/2] net: sched: fix packet stuck problem for
 lockless qdisc
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <olteanv@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andriin@fb.com>,
        <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <pabeni@redhat.com>, <mzhivich@akamai.com>,
        <johunt@akamai.com>, <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>
References: <1618535809-11952-1-git-send-email-linyunsheng@huawei.com>
 <1618535809-11952-2-git-send-email-linyunsheng@huawei.com>
 <20210419152946.3n7adsd355rfeoda@lion.mk-sys.cz>
 <20210419235503.eo77f6s73a4d25oh@lion.mk-sys.cz>
 <20210420203459.h7top4zogn56oa55@lion.mk-sys.cz>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <80d64438-e3e5-e861-4da0-f6c89e3c73f7@huawei.com>
Date:   Wed, 21 Apr 2021 09:52:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210420203459.h7top4zogn56oa55@lion.mk-sys.cz>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/21 4:34, Michal Kubecek wrote:
> On Tue, Apr 20, 2021 at 01:55:03AM +0200, Michal Kubecek wrote:
>> On Mon, Apr 19, 2021 at 05:29:46PM +0200, Michal Kubecek wrote:
>>>
>>> As pointed out in the discussion on v3, this patch may result in
>>> significantly higher CPU consumption with multiple threads competing on
>>> a saturated outgoing device. I missed this submission so that I haven't
>>> checked it yet but given the description of v3->v4 changes above, it's
>>> quite likely that it suffers from the same problem.
>>
>> And it indeed does. However, with the additional patch from the v3
>> discussion, the numbers are approximately the same as with an unpatched
>> mainline kernel.
>>
>> As with v4, I tried this patch on top of 5.12-rc7 with real devices.
>> I used two machines with 10Gb/s Intel ixgbe NICs, sender has 16 CPUs
>> (2 8-core CPUs with HT disabled) and 16 Rx/Tx queues, receiver has
>> 48 CPUs (2 12-core CPUs with HT enabled) and 48 Rx/Tx queues.
>>
>>   threads    5.12-rc7    5.12-rc7 + v4    5.12-rc7 + v4 + stop
>>      1        25.1%          38.1%            22.9%
>>      8        66.2%         277.0%            74.1%
>>     16        90.1%         150.7%            91.0%
>>     32       107.2%         272.6%           108.3%
>>     64       116.3%         487.5%           118.1%
>>    128       126.1%         946.7%           126.9%
>>
>> (The values are normalized to one core, i.e. 100% corresponds to one
>> fully used logical CPU.)
> 
> I repeated the tests few more times and with more iterations and it
> seems the problem rather was that the CPU utilization numbers are not
> very stable, in particular with number of connections/threads close to
> the number of CPUs and Tx queues. Refined results (and also other tests)
> show that full 3-patch series performs similar to unpatched 5.12-rc7
> (within the margin of statistical error).

Thanks for the clarifying.
I did a similar test yesterday(using 10Gb netdev and the iperf tool I has),
the initial result suggested the same.

> 
> However, I noticed something disturbing in the results of a simple
> 1-thread TCP_STREAM test (client sends data through a TCP connection to
> server using long writes, we measure the amount of data received by the
> server):
> 
>   server: 172.17.1.1, port 12543
>   iterations: 20, threads: 1, test length: 30
>   test: TCP_STREAM, message size: 1048576
>   
>   1     927403548.4 B/s,  avg   927403548.4 B/s, mdev           0.0 B/s (  0.0%)
>   2    1176317172.1 B/s,  avg  1051860360.2 B/s, mdev   124456811.8 B/s ( 11.8%), confid. +/-  1581348251.3 B/s (150.3%)
>   3     927335837.8 B/s,  avg  1010352186.1 B/s, mdev   117354970.3 B/s ( 11.6%), confid. +/-   357073677.2 B/s ( 35.3%)
>   4    1176728045.1 B/s,  avg  1051946150.8 B/s, mdev   124576544.7 B/s ( 11.8%), confid. +/-   228863127.8 B/s ( 21.8%)
>   5    1176788216.3 B/s,  avg  1076914563.9 B/s, mdev   122102985.3 B/s ( 11.3%), confid. +/-   169478943.5 B/s ( 15.7%)
>   6    1158167055.1 B/s,  avg  1090456645.8 B/s, mdev   115504209.5 B/s ( 10.6%), confid. +/-   132805140.8 B/s ( 12.2%)
>   7    1176243474.4 B/s,  avg  1102711907.0 B/s, mdev   111069717.1 B/s ( 10.1%), confid. +/-   110956822.2 B/s ( 10.1%)
>   8    1176771142.8 B/s,  avg  1111969311.5 B/s, mdev   106744173.5 B/s (  9.6%), confid. +/-    95417120.0 B/s (  8.6%)
>   9    1176206364.6 B/s,  avg  1119106761.8 B/s, mdev   102644185.2 B/s (  9.2%), confid. +/-    83685200.5 B/s (  7.5%)
>   10   1175888409.4 B/s,  avg  1124784926.6 B/s, mdev    98855550.5 B/s (  8.8%), confid. +/-    74537085.1 B/s (  6.6%)
>   11   1176541407.6 B/s,  avg  1129490061.2 B/s, mdev    95422224.8 B/s (  8.4%), confid. +/-    67230249.7 B/s (  6.0%)
>   12    934185352.8 B/s,  avg  1113214668.9 B/s, mdev   106114984.5 B/s (  9.5%), confid. +/-    70420712.5 B/s (  6.3%)
>   13   1176550558.1 B/s,  avg  1118086660.3 B/s, mdev   103339448.9 B/s (  9.2%), confid. +/-    65002902.4 B/s (  5.8%)
>   14   1176521808.8 B/s,  avg  1122260599.5 B/s, mdev   100711151.3 B/s (  9.0%), confid. +/-    60333655.0 B/s (  5.4%)
>   15   1176744840.8 B/s,  avg  1125892882.3 B/s, mdev    98240838.2 B/s (  8.7%), confid. +/-    56319052.3 B/s (  5.0%)
>   16   1176593778.5 B/s,  avg  1129061688.3 B/s, mdev    95909740.8 B/s (  8.5%), confid. +/-    52771633.5 B/s (  4.7%)
>   17   1176583967.4 B/s,  avg  1131857116.5 B/s, mdev    93715582.2 B/s (  8.3%), confid. +/-    49669258.6 B/s (  4.4%)
>   18   1176853301.8 B/s,  avg  1134356904.5 B/s, mdev    91656530.2 B/s (  8.1%), confid. +/-    46905244.8 B/s (  4.1%)
>   19   1176592845.7 B/s,  avg  1136579848.8 B/s, mdev    89709043.8 B/s (  7.9%), confid. +/-    44424855.9 B/s (  3.9%)
>   20   1176608117.3 B/s,  avg  1138581262.2 B/s, mdev    87871692.6 B/s (  7.7%), confid. +/-    42193098.5 B/s (  3.7%)
>   all                     avg  1138581262.2 B/s, mdev    87871692.6 B/s (  7.7%), confid. +/-    42193098.5 B/s (  3.7%)
> 
> Each line shows result of one 30 second long test and average, mean
> deviation and 99% confidence interval half width through the iterations
> so far. While 17 iteration results are essentially the wire speed minus
> TCP overhead, iterations 1, 3 and 12 are more than 20% lower. As results
> of the same test on unpatched 5.12-rc7 are much more consistent (the
> lowest iteration result through the whole test was 1175939718.3 and the
> mean deviation only 276889.1 B/s), it doesn't seeem to be just a random
> fluctuation.

I think I need to relearn the statistial math to understand the above
"99% confidence interval half width ":)

But the problem do not seems related too much with "99% confidence
interval half width ", but with "mean deviation"?

I tried using netperf, which seems only show throughput of 9415.06
(10^6bits/sec) using 10G netdev. which tool did you used to show the
above number?

> 
> I'll try to find out what happens in these outstanding iterations.

As my understanding, if there is only one thread, the first spin_trylock()
is likely to return true for the xmiting thread, unless the scheduled
net_tx_action() cause the xmiting thread's spin_trylock() returning false?

Thanks for comprehensive testing and analysing.

> 
> Michal
> 
> .
> 

