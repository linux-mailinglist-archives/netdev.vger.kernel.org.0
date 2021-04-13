Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA6435D57C
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 04:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240977AbhDMC5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 22:57:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5130 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237380AbhDMC5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 22:57:04 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FK9Dt4vwTzYVxH;
        Tue, 13 Apr 2021 10:54:38 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML403-HUB.china.huawei.com (10.3.17.33) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 13 Apr 2021 10:56:43 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 13 Apr
 2021 10:56:43 +0800
Subject: Re: [PATCH net v3] net: sched: fix packet stuck problem for lockless
 qdisc
To:     Hillf Danton <hdanton@sina.com>
CC:     Juergen Gross <jgross@suse.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiri Kosina <JKosina@suse.com>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
 <20210409090909.1767-1-hdanton@sina.com>
 <20210412032111.1887-1-hdanton@sina.com>
 <20210412072856.2046-1-hdanton@sina.com>
 <20210413022129.2203-1-hdanton@sina.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <57ace28a-93bb-6581-bbba-18d77a9871f7@huawei.com>
Date:   Tue, 13 Apr 2021 10:56:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210413022129.2203-1-hdanton@sina.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/13 10:21, Hillf Danton wrote:
> On Mon, 12 Apr 2021 20:00:43  Yunsheng Lin wrote:
>>
>> Yes, the below patch seems to fix the data race described in
>> the commit log.
>> Then what is the difference between my patch and your patch below:)
> 
> Hehe, this is one of the tough questions over a bounch of weeks.
> 
> If a seqcount can detect the race between skb enqueue and dequeue then we
> cant see any excuse for not rolling back to the point without NOLOCK.

I am not sure I understood what you meant above.

As my understanding, the below patch is essentially the same as
your previous patch, the only difference I see is it uses qdisc->pad
instead of __QDISC_STATE_NEED_RESCHEDULE.

So instead of proposing another patch, it would be better if you
comment on my patch, and make improvement upon that.

> 
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -632,6 +632,7 @@ static int pfifo_fast_enqueue(struct sk_
>  			return qdisc_drop(skb, qdisc, to_free);
>  	}
>  
> +	qdisc->pad++;

As has been mentioned:
Doing updating in pfifo_fast_enqueue() unconditionally does not
seems to be performance friendly, which is something my patch
tries to avoid as much as possible.

>  	qdisc_update_stats_at_enqueue(qdisc, pkt_len);
>  	return NET_XMIT_SUCCESS;
>  }
> @@ -642,6 +643,7 @@ static struct sk_buff *pfifo_fast_dequeu
>  	struct sk_buff *skb = NULL;
>  	int band;
>  
> +	qdisc->pad = 0;
>  	for (band = 0; band < PFIFO_FAST_BANDS && !skb; band++) {
>  		struct skb_array *q = band2list(priv, band);
>  
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -176,8 +176,12 @@ static inline bool qdisc_run_begin(struc
>  static inline void qdisc_run_end(struct Qdisc *qdisc)
>  {
>  	write_seqcount_end(&qdisc->running);
> -	if (qdisc->flags & TCQ_F_NOLOCK)
> +	if (qdisc->flags & TCQ_F_NOLOCK) {
>  		spin_unlock(&qdisc->seqlock);
> +
> +		if (qdisc->pad != 0)
> +			__netif_schedule(qdisc);
> +	}
>  }
>  
>  static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
> 
> .
> 

