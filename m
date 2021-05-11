Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702BA37A65D
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhEKMPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:15:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2486 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhEKMPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 08:15:07 -0400
Received: from dggeml710-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FfcGV1S42zYd8s;
        Tue, 11 May 2021 20:11:30 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml710-chm.china.huawei.com (10.3.17.140) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 11 May 2021 20:13:57 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 11 May
 2021 20:13:57 +0800
Subject: Re: Re: [PATCH net v6 3/3] net: sched: fix tx action reschedule issue
 with stopped queue
From:   Yunsheng Lin <linyunsheng@huawei.com>
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
References: <1620610956-56306-1-git-send-email-linyunsheng@huawei.com>
 <1620610956-56306-4-git-send-email-linyunsheng@huawei.com>
 <20210510212232.3386c5b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c676404c-f210-b0cb-ced3-5449676055a8@huawei.com>
Message-ID: <8db8e594-9606-2c93-7274-1c180afaadb2@huawei.com>
Date:   Tue, 11 May 2021 20:13:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <c676404c-f210-b0cb-ced3-5449676055a8@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/11 17:04, Yunsheng Lin wrote:
> On 2021/5/11 12:22, Jakub Kicinski wrote:
>> On Mon, 10 May 2021 09:42:36 +0800 Yunsheng Lin wrote:
>>> The netdev qeueue might be stopped when byte queue limit has
>>> reached or tx hw ring is full, net_tx_action() may still be
>>> rescheduled endlessly if STATE_MISSED is set, which consumes
>>> a lot of cpu without dequeuing and transmiting any skb because
>>> the netdev queue is stopped, see qdisc_run_end().
>>>
>>> This patch fixes it by checking the netdev queue state before
>>> calling qdisc_run() and clearing STATE_MISSED if netdev queue is
>>> stopped during qdisc_run(), the net_tx_action() is recheduled
>>> again when netdev qeueue is restarted, see netif_tx_wake_queue().
>>>
>>> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
>>> Reported-by: Michal Kubecek <mkubecek@suse.cz>
>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> Patches 1 and 2 look good to me but this one I'm not 100% sure.
>>
>>> @@ -251,8 +253,10 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
>>>  	*validate = true;
>>>  
>>>  	if ((q->flags & TCQ_F_ONETXQUEUE) &&
>>> -	    netif_xmit_frozen_or_stopped(txq))
>>> +	    netif_xmit_frozen_or_stopped(txq)) {
>>> +		clear_bit(__QDISC_STATE_MISSED, &q->state);
>>>  		return skb;
>>> +	}
>>
>> The queues are woken asynchronously without holding any locks via
>> netif_tx_wake_queue(). Theoretically we can have a situation where:
>>
>> CPU 0                            CPU 1   
>>   .                                .
>> dequeue_skb()                      .
>>   netif_xmit_frozen..() # true     .
>>   .                              [IRQ]
>>   .                              netif_tx_wake_queue()
>>   .                              <end of IRQ>
>>   .                              netif_tx_action()
>>   .                              set MISSED
>>   clear MISSED
>>   return NULL
>> ret from qdisc_restart()
>> ret from __qdisc_run()
>> qdisc_run_end()
>> -> MISSED not set
> 
> Yes, the above does seems to have the above data race.
> 
> As my understanding, there is two ways to fix the above data race:
> 1. do not clear the STATE_MISSED for netif_xmit_frozen_or_stopped()
>    case, just check the netif_xmit_frozen_or_stopped() before
>    calling __netif_schedule() at the end of qdisc_run_end(). This seems
>    to only work with qdisc with TCQ_F_ONETXQUEUE flag because it seems
>    we can only check the netif_xmit_frozen_or_stopped() with q->dev_queue,
>    I am not sure q->dev_queue is pointint to which netdev queue when qdisc
>    is not set with TCQ_F_ONETXQUEUE flag.
> 
> 2. clearing the STATE_MISSED for netif_xmit_frozen_or_stopped() case
>    as this patch does, and protect the __netif_schedule() with q->seqlock
>    for netif_tx_wake_queue(), which might bring unnecessary overhead for
>    non-stopped queue case
> 
> Any better idea?

3. Or check the netif_xmit_frozen_or_stopped() again after clearing
   STATE_MISSED, like below:

   if (netif_xmit_frozen_or_stopped(txq)) {
	  clear_bit(__QDISC_STATE_MISSED, &q->state);

	  /* Make sure the below netif_xmit_frozen_or_stopped()
	   * checking happens after clearing STATE_MISSED.
	   */
	  smp_mb__after_atomic();

	  /* Checking netif_xmit_frozen_or_stopped() again to
	   * make sure __QDISC_STATE_MISSED is set if the
	   * __QDISC_STATE_MISSED set by netif_tx_wake_queue()'s
	   * rescheduling of net_tx_action() is cleared by the
	   * above clear_bit().
	   */
	  if (!netif_xmit_frozen_or_stopped(txq))
	  	set_bit(__QDISC_STATE_MISSED, &q->state);
  }

  It is kind of ugly, but it does seem to fix the above data race too.
  And it seems like a common pattern to deal with the concurrency between
  xmit and NAPI polling, as below:

https://elixir.bootlin.com/linux/v5.12-rc2/source/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c#L1409


> 
>>
>> .
>>
> _______________________________________________
> Linuxarm mailing list -- linuxarm@openeuler.org
> To unsubscribe send an email to linuxarm-leave@openeuler.org
> 

