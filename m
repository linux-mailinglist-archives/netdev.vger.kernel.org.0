Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B39F3667E8
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbhDUJZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:25:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3090 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238010AbhDUJZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:25:44 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FQFRP0GCLzWYmx;
        Wed, 21 Apr 2021 17:21:21 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 21 Apr 2021 17:25:07 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 21 Apr
 2021 17:25:06 +0800
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
 <80d64438-e3e5-e861-4da0-f6c89e3c73f7@huawei.com>
 <20210421053123.wdq3kwlvf72kwtch@lion.mk-sys.cz>
 <6a8dea49-3a3e-4172-1d65-5dbcb0125eda@huawei.com>
 <20210421084428.xbjgoi4r2d6t65gy@lion.mk-sys.cz>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b3dacf14-0fb6-0cad-8b85-f5c8d7cd97ef@huawei.com>
Date:   Wed, 21 Apr 2021 17:25:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210421084428.xbjgoi4r2d6t65gy@lion.mk-sys.cz>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/21 16:44, Michal Kubecek wrote:
> On Wed, Apr 21, 2021 at 04:21:54PM +0800, Yunsheng Lin wrote:
>>
>> I tried using below shell to simulate your testcase:
>>
>> #!/bin/sh
>>
>> for((i=0; i<20; i++))
>> do
>>         taskset -c 0-31 netperf -t TCP_STREAM -H 192.168.100.2 -l 30 -- -m 1048576
>> done
>>
>> And I got a quite stable result: 9413~9416 (10^6bits/sec) for 10G netdev.
> 
> Perhaps try it without the taskset, in my test, there was only one
> connection.

Just tried, and got the similar result as above.

> 
>>>
>>>   https://github.com/mkubecek/nperf
>>>
>>> It is still raw and a lot of features are missing but it can be already
>>> used for multithreaded TCP_STREAM and TCP_RR tests. In particular, the
>>> output above was with
>>>
>>>   nperf -H 172.17.1.1 -l 30 -i 20 --exact -t TCP_STREAM -M 1
>>
>> I tried your nperf too, unfortunately it does not seem to work on my
>> system(arm64), which exits very quickly and output the blow result:
>>
>> root@(none):/home# nperf -H 192.168.100.2 -l 30 -i 20 --exact -t TCP_STREAM -M 1
>> server: 192.168.100.2, port 12543
>> iterations: 20, threads: 1, test length: 30
>> test: TCP_STREAM, message size: 1048576
>>
>> 1             4.0 B/s,  avg           4.0 B/s, mdev           0.0 B/s (  0.0%)
> [...]
> 
> Did you start nperfd on the other side? (It plays a role similar to
> netserver for netperf.) Few days ago I noticed that there is something
> wrong with error handling in case of failed connection but didn't get to
> fixing it yet.

Yes, I did. If I did not start nperfd, I got "connect: Connection refused"
as below:

nperf -H 192.168.100.2 -l 30 -i 20 --exact -t TCP_STREAM -M 1
server: 192.168.100.2, port 12543
iterations: 20, threads: 1, test length: 30
test: TCP_STREAM, message size: 1048576

connect: Connection refused
failed to connect to '192.168.100.2'
1             4.0 B/s,  avg           4.0 B/s, mdev           0.0 B/s (  0.0%)
connect: Connection refused
failed to connect to '192.168.100.2'
2             4.0 B/s,  avg           4.0 B/s, mdev           0.0 B/s (  0.0%), confid. +/-           0.0 B/s (  0.0%)
connect: Connection refused
failed to connect to '192.168.100.2'



> 
> I'll try running some tests also on other architectures, including arm64
> and s390x (to catch potential endinanity issues).
> 
> Michal
> 
> .
> 

