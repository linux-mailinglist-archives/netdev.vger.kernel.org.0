Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A033394ADD
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 09:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhE2HEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 03:04:51 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2403 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2HEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 03:04:50 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FsXVC420qz66Rp;
        Sat, 29 May 2021 14:59:31 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 15:03:11 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Sat, 29 May
 2021 15:03:10 +0800
Subject: Re: [PATCH net-next 2/3] net: sched: implement TCQ_F_CAN_BYPASS for
 lockless qdisc
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <olteanv@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>, <edumazet@google.com>,
        <weiwan@google.com>, <cong.wang@bytedance.com>,
        <ap420073@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
References: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
 <1622170197-27370-3-git-send-email-linyunsheng@huawei.com>
 <20210528180012.676797d6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <a6a965ee-7368-d37b-9c70-bba50c67eec9@huawei.com>
 <20210528213218.2b90864c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <ee1a62da-9758-70db-abd3-c5ca2e8e0ce0@huawei.com>
Date:   Sat, 29 May 2021 15:03:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210528213218.2b90864c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/29 12:32, Jakub Kicinski wrote:
> On Sat, 29 May 2021 09:44:57 +0800 Yunsheng Lin wrote:
>>>> @@ -3852,10 +3852,32 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>>>>  	qdisc_calculate_pkt_len(skb, q);
>>>>  
>>>>  	if (q->flags & TCQ_F_NOLOCK) {
>>>> +		if (q->flags & TCQ_F_CAN_BYPASS && nolock_qdisc_is_empty(q) &&
>>>> +		    qdisc_run_begin(q)) {
>>>> +			/* Retest nolock_qdisc_is_empty() within the protection
>>>> +			 * of q->seqlock to ensure qdisc is indeed empty.
>>>> +			 */
>>>> +			if (unlikely(!nolock_qdisc_is_empty(q))) {  
>>>
>>> This is just for the DRAINING case right? 
>>>
>>> MISSED can be set at any moment, testing MISSED seems confusing.  
>>
>> MISSED is only set when there is lock contention, which means it
>> is better not to do the qdisc bypass to avoid out of order packet
>> problem, 
> 
> Avoid as in make less likely? Nothing guarantees other thread is not
> interrupted after ->enqueue and before qdisc_run_begin().
> 
> TBH I'm not sure what out-of-order situation you're referring to,
> there is no ordering guarantee between separate threads trying to
> transmit AFAIU.
A thread need to do the bypass checking before doing enqueuing, so
it means MISSED is set or the trylock fails for the bypass transmiting(
which will set the MISSED after the first trylock), so the MISSED will
always be set before a thread doing a enqueuing, and we ensure MISSED
only be cleared during the protection of q->seqlock, after clearing
MISSED, we do anther round of dequeuing within the protection of
q->seqlock.

So if a thread has taken the q->seqlock and the MISSED is not set yet,
it is allowed to send the packet directly without going through the
qdisc enqueuing and dequeuing process.


> 
> IOW this check is not required for correctness, right?

if a thread has taken the q->seqlock and the MISSED is not set, it means
other thread has not set MISSED after the first trylock and before the
second trylock, which means the enqueuing is not done yet.
So I assume the this check is required for correctness if I understand
your question correctly.

> 
>> another good thing is that we could also do the batch
>> dequeuing and transmiting of packets when there is lock contention.
> 
> No doubt, but did you see the flag get set significantly often here 
> to warrant the double-checking?

No, that is just my guess:)

> 
>>> Is it really worth the extra code?  
>>
>> Currently DRAINING is only set for the netdev queue stopped.
>> We could only use DRAINING to indicate the non-empty of a qdisc,
>> then we need to set the DRAINING evrywhere MISSED is set, that is
>> why I use both DRAINING and MISSED to indicate a non-empty qdisc.


