Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0869A1C656E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 03:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgEFBTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 21:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbgEFBTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 21:19:13 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F60C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 18:19:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a32so54655pje.5
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 18:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SHtHjBbrz6ngkuSGZfuNCXTxIEGSX0I3GY9p6w6N3Pg=;
        b=i1bzUR9e9A1KDtkv5tvQE8VUcQmMyUudQy02eEuTwz8rINB5T+6793mNzybByBdF87
         B4QCBcqLwdDXgz20SUR98myYZLI5oy7KolQqUuYqkmtojfVZsN0BzT1RYLpDfmwnKvlA
         SXTnqFCtQrW4+kSiiUOr+Y+FFuqPvAthPLfymRX17n/3CijuaQUVc+zsjsU4HS/ef8Qs
         uP+pt8uXDETQ1NH11UM0ZQGQGW9zLQv4KD/yg4ncznjDyqnnMmnlFO3AXfxYNHxc2gj5
         7r25lYqIf4nnXKD/Gnycv64SQ1p85OFc6ErEDZ5P/4ShHCi2YjsNO5fUwGFObW4TtDtl
         kU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SHtHjBbrz6ngkuSGZfuNCXTxIEGSX0I3GY9p6w6N3Pg=;
        b=exEJE7dHdpoabWIjEwvkwocXFOu9pk0spDw9S5KPOYq6Zwwlt6uIq+GMHMZrnGQgWQ
         TqMY+AesmL4aNh0j9TKFwybpIV+R1M8MFyvSHawNCxD8U4OGe+N7V399OSadXpj6rGVk
         lfrzq0P2zBg9WK5EE7/vuxKYI+wGkw4AV28LuiV2cv3GloRC4fI2YfRMXtNTCzTDbNIo
         oEkiXLc6ZGlOd1MJ9CSni1Y+pw37wqYDkJBaVE4mmAnKqO0Q17b+29M0Km1KF4o1oI/n
         F9+7dJFsKCcAPHKDu9eqHp0wkfEo1uyO5xEI4T8RHBmU4SzPQipOewxZpzE2OOhNyU1+
         xIfw==
X-Gm-Message-State: AGi0PuYePIPa1J3E/BeNZNkxiliNJkOC2CvUlsuGQ946l9Lbfc/i1oNH
        uM4nImtm4F9C1NcLZ+U8FOs=
X-Google-Smtp-Source: APiQypKo7NWDC/AtOXwx8szsB0y1vXhn1wIPvO26+gpbJQrpW4gNacrJt/Pkqk7aAo/UOJEK3gyc+g==
X-Received: by 2002:a17:90a:a608:: with SMTP id c8mr6274568pjq.90.1588727952487;
        Tue, 05 May 2020 18:19:12 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l5sm290090pgt.92.2020.05.05.18.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 18:19:11 -0700 (PDT)
Subject: Re: [BUG] Inconsistent lock state in virtnet poll
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <87lfm6oa7b.fsf@nanos.tec.linutronix.de>
 <20200505120352-mutt-send-email-mst@kernel.org>
 <87v9lanher.fsf@nanos.tec.linutronix.de>
 <98c4d934-5a27-1cf7-119a-ce0c5a501864@gmail.com>
 <20200505204015-mutt-send-email-mst@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4ea7fb92-c4fb-1a31-d83b-483da2fb7a1a@gmail.com>
Date:   Tue, 5 May 2020 18:19:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505204015-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 5:43 PM, Michael S. Tsirkin wrote:
> On Tue, May 05, 2020 at 03:40:09PM -0700, Eric Dumazet wrote:
>>
>>
>> On 5/5/20 3:30 PM, Thomas Gleixner wrote:
>>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>>>> On Tue, May 05, 2020 at 02:08:56PM +0200, Thomas Gleixner wrote:
>>>>>
>>>>> The following lockdep splat happens reproducibly on 5.7-rc4
>>>>
>>>>> ================================
>>>>> WARNING: inconsistent lock state
>>>>> 5.7.0-rc4+ #79 Not tainted
>>>>> --------------------------------
>>>>> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
>>>>> ip/356 [HC0[0]:SC1[1]:HE1:SE0] takes:
>>>>> f3ee4cd8 (&syncp->seq#2){+.?.}-{0:0}, at: net_rx_action+0xfb/0x390
>>>>> {SOFTIRQ-ON-W} state was registered at:
>>>>>   lock_acquire+0x82/0x300
>>>>>   try_fill_recv+0x39f/0x590
>>>>
>>>> Weird. Where does try_fill_recv acquire any locks?
>>>
>>>   u64_stats_update_begin(&rq->stats.syncp);
>>>
>>> That's a 32bit kernel which uses a seqcount for this. sequence counts
>>> are "lock" constructs where you need to make sure that writers are
>>> serialized.
>>>
>>> Actually the problem at hand is that try_fill_recv() is called from
>>> fully preemptible context initialy and then from softirq context.
>>>
>>> Obviously that's for the open() path a non issue, but lockdep does not
>>> know about that. OTOH, there is other code which calls that from
>>> non-softirq context.
>>>
>>> The hack below made it shut up. It's obvioulsy not ideal, but at least
>>> it let me look at the actual problem I was chasing down :)
>>>
>>> Thanks,
>>>
>>>         tglx
>>>
>>> 8<-----------
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet
>>>  			break;
>>>  	} while (rq->vq->num_free);
>>>  	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
>>> +		local_bh_disable();
>>
>> Or use u64_stats_update_begin_irqsave() whic is a NOP on 64bit kernels
> 
> I applied this, but am still trying to think of something that
> is 0 overhead for all configs.
> Maybe we can select a lockdep class depending on whether napi
> is enabled?


Do you _really_ need 64bit counter for stats.kicks on 32bit kernels ?

Adding 64bit counters just because we can might be overhead anyway.

> 
> 
>>>  		u64_stats_update_begin(&rq->stats.syncp);
>>>  		rq->stats.kicks++;
>>>  		u64_stats_update_end(&rq->stats.syncp);
>>> +		local_bh_enable();
>>>  	}
>>>  
>>>  	return !oom;
>>>
> 
