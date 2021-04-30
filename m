Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C4836F452
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 05:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhD3DP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 23:15:57 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3410 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhD3DPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 23:15:55 -0400
Received: from dggeml755-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FWcq10F4yz5wC4;
        Fri, 30 Apr 2021 11:11:57 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml755-chm.china.huawei.com (10.1.199.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 30 Apr 2021 11:15:03 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 30 Apr
 2021 11:15:01 +0800
Subject: Re: [PATCH net v4 1/2] net: sched: fix packet stuck problem for
 lockless qdisc
From:   Yunsheng Lin <linyunsheng@huawei.com>
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
 <b3dacf14-0fb6-0cad-8b85-f5c8d7cd97ef@huawei.com>
 <a6abb3d8-f857-14e1-4212-a12df36027cf@huawei.com>
 <e90e662d-ace1-1f32-6050-861db0a7e976@huawei.com>
Message-ID: <f06355b4-2b00-fc52-4d9d-9c866436e559@huawei.com>
Date:   Fri, 30 Apr 2021 11:15:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <e90e662d-ace1-1f32-6050-861db0a7e976@huawei.com>
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

On 2021/4/30 11:11, Yunsheng Lin wrote:
> On 2021/4/23 17:42, Yunsheng Lin wrote:
>> On 2021/4/21 17:25, Yunsheng Lin wrote:
>>> On 2021/4/21 16:44, Michal Kubecek wrote:
>>>
>>>>
>>>> I'll try running some tests also on other architectures, including arm64
>>>> and s390x (to catch potential endinanity issues).
>>
>> I tried debugging nperf in arm64, with the below patch:
>>
>> Any idea what went wrong here?
>>
>> Also, Would you mind running netperf to see if there is similar issue
>> in your system?
> 
> Hi, Michal
>     I was able to reproduce the fluctuation for one thread TCP_STREAM test,

I was *not* able
Sorry for the typo.

> So I am assuming it may more related to test environment or nperf issue.
> 
>    I plan to send v5 with netdev queue stopped handling after the golden
> holiday in china. If there is any issue with patchset, please let me know,
> thanks.
> 
>>
>>>>
>>>> Michal
>>>>
>>>> .
>>>>
>>>
>>>
>>> .
>>>
>>
>>
>> .
>>
> 
> 
> .
> 

