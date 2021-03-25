Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1ACC3486D2
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 03:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbhCYCJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 22:09:05 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3499 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbhCYCIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 22:08:51 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4F5T4f3KKvzRTnV;
        Thu, 25 Mar 2021 10:06:58 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML403-HUB.china.huawei.com (10.3.17.33) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 25 Mar 2021 10:08:48 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Thu, 25 Mar
 2021 10:08:48 +0800
Subject: Re: [PATCH net v2] net: sched: fix packet stuck problem for lockless
 qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
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
        Josh Hunt <johunt@akamai.com>,
        "Jike Song" <albcamus@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
References: <1616552677-39016-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpXAedg31hPx674u4Q4fj0DweADPSn0n_KghgRBWDoOOfw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <364d994a-9234-fe52-a8ad-ab17934e6205@huawei.com>
Date:   Thu, 25 Mar 2021 10:08:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXAedg31hPx674u4Q4fj0DweADPSn0n_KghgRBWDoOOfw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/25 3:20, Cong Wang wrote:
> On Tue, Mar 23, 2021 at 7:24 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>> @@ -176,8 +207,23 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>>  static inline void qdisc_run_end(struct Qdisc *qdisc)
>>  {
>>         write_seqcount_end(&qdisc->running);
>> -       if (qdisc->flags & TCQ_F_NOLOCK)
>> +       if (qdisc->flags & TCQ_F_NOLOCK) {
>>                 spin_unlock(&qdisc->seqlock);
>> +
>> +               /* qdisc_run_end() is protected by RCU lock, and
>> +                * qdisc reset will do a synchronize_net() after
>> +                * setting __QDISC_STATE_DEACTIVATED, so testing
>> +                * the below two bits separately should be fine.
> 
> Hmm, why synchronize_net() after setting this bit is fine? It could
> still be flipped right after you test RESCHEDULE bit.

That depends on when it will be fliped again.

As I see:
1. __QDISC_STATE_DEACTIVATED is set during dev_deactivate() process,
   which should also wait for all process related to "test_bit(
   __QDISC_STATE_NEED_RESCHEDULE, &q->state)" to finish by calling
   synchronize_net() and checking some_qdisc_is_busy().

2. it is cleared during dev_activate() process.

And dev_deactivate() and dev_activate() is protected by RTNL lock, or
serialized by linkwatch.

> 
> 
>> +                * For qdisc_run() in net_tx_action() case, we
>> +                * really should provide rcu protection explicitly
>> +                * for document purposes or PREEMPT_RCU.
>> +                */
>> +               if (unlikely(test_bit(__QDISC_STATE_NEED_RESCHEDULE,
>> +                                     &qdisc->state) &&
>> +                            !test_bit(__QDISC_STATE_DEACTIVATED,
>> +                                      &qdisc->state)))
> 
> Why do you want to test __QDISC_STATE_DEACTIVATED bit at all?
> dev_deactivate_many() will wait for those scheduled but being
> deactivated, so what's the problem of scheduling it even with this bit?

The problem I tried to fix is:

  CPU0(calling dev_deactivate)   CPU1(calling qdisc_run_end)   CPU2(calling tx_atcion)
             .                       __netif_schedule()                   .
             .                     set __QDISC_STATE_SCHED                .
             .                                .                           .
clear __QDISC_STATE_DEACTIVATED               .                           .
     synchronize_net()                        .                           .
             .                                .                           .
             .                                .              clear __QDISC_STATE_SCHED
             .                                .                           .
 some_qdisc_is_busy() return false            .                           .
             .                                .                           .
             .                                .                      qdisc_run()

some_qdisc_is_busy() checks if the qdisc is busy by checking __QDISC_STATE_SCHED
and spin_is_locked(&qdisc->seqlock) for lockless qdisc, and some_qdisc_is_busy()
return false for CPU0 because CPU2 has cleared the __QDISC_STATE_SCHED and has not
taken the qdisc->seqlock yet, qdisc is clearly still busy when qdisc_run() is run
by CPU2 later.

So you are right, testing __QDISC_STATE_DEACTIVATED does not completely solve
the above data race, and there are __netif_schedule() called by dev_requeue_skb()
and __qdisc_run() too, which need the same fixing.

So will remove the __QDISC_STATE_DEACTIVATED testing for this patch first, and
deal with it later.

> 
> Thanks.
> 
> .
> 

