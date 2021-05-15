Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2430381528
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 04:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbhEOC0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 22:26:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2986 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbhEOC0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 22:26:40 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fhq1s0Z3Vzlbrx;
        Sat, 15 May 2021 10:23:13 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 15 May 2021 10:25:26 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Sat, 15 May
 2021 10:25:25 +0800
Subject: Re: [PATCH net v8 1/3] net: sched: fix packet stuck problem for
 lockless qdisc
To:     Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "Wei Wang" <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        Josh Hunt <johunt@akamai.com>, Jike Song <albcamus@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "Hillf Danton" <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, "Michal Kubecek" <mkubecek@suse.cz>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>
References: <1620959218-17250-1-git-send-email-linyunsheng@huawei.com>
 <1620959218-17250-2-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpXWgYQxf8Ba-D4JQJMPUaR9MBfQFTLFCHWJMVq9PcUWRg@mail.gmail.com>
 <20210514163923.53f39888@kicinski-fedora-PC1C0HJN>
 <CAM_iQpXZNASp7+kA=OoCVbXuReAtOzHnqMn8kFUVfi9_qWe_kw@mail.gmail.com>
 <20210514171759.5572c8f0@kicinski-fedora-PC1C0HJN>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <def859b3-b6ea-7338-38eb-3f18ec3d60c2@huawei.com>
Date:   Sat, 15 May 2021 10:25:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210514171759.5572c8f0@kicinski-fedora-PC1C0HJN>
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

On 2021/5/15 8:17, Jakub Kicinski wrote:
> On Fri, 14 May 2021 16:57:29 -0700 Cong Wang wrote:
>> On Fri, May 14, 2021 at 4:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>
>>> On Fri, 14 May 2021 16:36:16 -0700 Cong Wang wrote:  
>>  [...]  
>>>>
>>>> We have test_and_clear_bit() which is atomic, test_bit()+clear_bit()
>>>> is not.  
>>>
>>> It doesn't have to be atomic, right? I asked to split the test because
>>> test_and_clear is a locked op on x86, test by itself is not.  
>>
>> It depends on whether you expect the code under the true condition
>> to run once or multiple times, something like:
>>
>> if (test_bit()) {
>>   clear_bit();
>>   // this code may run multiple times
>> }
>>
>> With the atomic test_and_clear_bit(), it only runs once:
>>
>> if (test_and_clear_bit()) {
>>   // this code runs once
>> }

I am not sure if the above really matter when the test and clear
does not need to be atomic.

In order for the above to happens, the MISSED has to set between
test and clear, right?

>>
>> This is why __netif_schedule() uses test_and_set_bit() instead of
>> test_bit()+set_bit().

I think test_and_set_bit() is needed in __netif_schedule() mainly
because STATE_SCHED is also used to indicate if the qdisc is in
sd->output_queue, so it has to be atomic.

> 
> Thanks, makes sense, so hopefully the MISSED-was-set case is not common
> and we can depend on __netif_schedule() to DTRT, avoiding the atomic op
> in the common case.
> 
> .
> 

