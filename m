Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9303553C9
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbhDFMY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:24:28 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5121 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhDFMY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:24:26 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FF6941R2VzYTBY;
        Tue,  6 Apr 2021 20:22:16 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 6 Apr 2021 20:24:14 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 6 Apr 2021
 20:24:15 +0800
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Hillf Danton <hdanton@sina.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        "Jike Song" <albcamus@gmail.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        "David Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Josh Hunt <johunt@akamai.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
 <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
 <20210403003537.2032-1-hdanton@sina.com>
 <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
 <CAM_iQpU+YD9AcX_77kqmQkqKMuOtnRh5xoGcz9dRRJTe1OnpBQ@mail.gmail.com>
 <2b99fce1-c235-6083-bd39-cece1f4a0343@huawei.com>
 <20210406073115.3h6zehyteagav3f7@lion.mk-sys.cz>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <30b4e9a4-c0ad-8ac5-0bbb-f186f1caf7a7@huawei.com>
Date:   Tue, 6 Apr 2021 20:24:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210406073115.3h6zehyteagav3f7@lion.mk-sys.cz>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/6 15:31, Michal Kubecek wrote:
> On Tue, Apr 06, 2021 at 10:46:29AM +0800, Yunsheng Lin wrote:
>> On 2021/4/6 9:49, Cong Wang wrote:
>>> On Sat, Apr 3, 2021 at 5:23 AM Jiri Kosina <jikos@kernel.org> wrote:
>>>>
>>>> I am still planning to have Yunsheng Lin's (CCing) fix [1] tested in the
>>>> coming days. If it works, then we can consider proceeding with it,
>>>> otherwise I am all for reverting the whole NOLOCK stuff.
>>>>
>>>> [1] https://lore.kernel.org/linux-can/1616641991-14847-1-git-send-email-linyunsheng@huawei.com/T/#u
>>>
>>> I personally prefer to just revert that bit, as it brings more troubles
>>> than gains. Even with Yunsheng's patch, there are still some issues.
>>> Essentially, I think the core qdisc scheduling code is not ready for
>>> lockless, just look at those NOLOCK checks in sch_generic.c. :-/
>>
>> I am also awared of the NOLOCK checks too:), and I am willing to
>> take care of it if that is possible.
>>
>> As the number of cores in a system is increasing, it is the trend
>> to become lockless, right? Even there is only one cpu involved, the
>> spinlock taking and releasing takes about 30ns on our arm64 system
>> when CONFIG_PREEMPT_VOLUNTARY is enable(ip forwarding testing).
> 
> I agree with the benefits but currently the situation is that we have
> a race condition affecting the default qdisc which is being hit in
> production and can cause serious trouble which is made worse by commit
> 1f3279ae0c13 ("tcp: avoid retransmits of TCP packets hanging in host
> queues") preventing the retransmits of the stuck packet being sent.
> 
> Perhaps rather than patching over current implementation which requires
> more and more complicated hacks to work around the fact that we cannot
> make the "queue is empty" check and leaving the critical section atomic,
> it would make sense to reimplement it in a way which would allow us
> making it atomic.

Yes, reimplementing that is also an option.
But what if reimplemention also has the same problem if we do not find
the root cause of this problem? I think it better to find the root cause
of it first?

> 
> Michal
> 
> 
> .
> 

