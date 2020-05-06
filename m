Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796451C65DA
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 04:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbgEFCYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 22:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgEFCYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 22:24:22 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5ED0C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 19:24:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s10so55984plr.1
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 19:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gQO1LkZ60dF5HMknrfg9kLvQy0GUhB9F3o4BgD3z4kg=;
        b=YrZUsilcKppxucuYMgmoOrzu8SUUck59qWU/Yzw4bGcidcUXM/fW0iJEVqUUj0v0Vx
         Fzvb2Okc4P5Oso5KqUfLvf81kRsRH3nimx4Z5kgQBAUjOD1nYC7/SIRHXQKex+7mYmuV
         OfsYBo1nFpcwbLOillMml2Yt0Bf1yUSZzMAKXgMTMKGBH3cjbEcm/ypVyg6BGK9aFQMc
         DMY0DIBomRlw5SjVc2pYiOLI9Oy/Psw1Cmv4PQbxR8VJeG8PN0H5BN8aajZbwekhmflf
         DXioS3oYdFShmc9CD3lZj6MCmZXl7mvEM0bin2yBYwGupn8tnei9cvj13Zpiiy5uxgkp
         sZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gQO1LkZ60dF5HMknrfg9kLvQy0GUhB9F3o4BgD3z4kg=;
        b=JJfVjypO1U1Hn+tOOBSNiS40/p1Xr4tffcZKDqVjJXR3HNuuE5rso47MjBYaNMOo4I
         YH9LKBLNQQ0raNrwgxPW2qU+HjRBJDvIxVgQ8/TRDUYX0OsAhvpPPGnRn7KlFPOYeruN
         ruB5rhctiCiQYPUOZA/cwXZErCBtlOqmmXkeJ1Fq/hBn5Jy+JL06vwuH0wLWGDJem3VK
         vBQNh/bhpWaeAghbsxHkehN+09UfkOOS+pSCPlmIfGFhqMN04K4W/fVOboH6prARofI1
         F+laOwcAaiYWK+mOiMd18FtJcIo3ic3HqigpPkeu14rvCCO1FFDjOVweaf4K9OYLnEuY
         f8mA==
X-Gm-Message-State: AGi0Pua+sCy43xZluff4TYX7Fnt2XkcXh98fPzIUP09q0ezsE9PL88S0
        UwS3NrXGxQQG2F9XpcD/GKk=
X-Google-Smtp-Source: APiQypLKNhyjfc9CplSIhblhO++PQjm5bBMikRx/E/8KWCS75wT9HW6YQkBzJXofuYc3axKtANaqvg==
X-Received: by 2002:a17:902:d216:: with SMTP id t22mr5653142ply.186.1588731861228;
        Tue, 05 May 2020 19:24:21 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g14sm181793pfh.49.2020.05.05.19.24.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 19:24:20 -0700 (PDT)
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
 <4ea7fb92-c4fb-1a31-d83b-483da2fb7a1a@gmail.com>
 <20200505212325-mutt-send-email-mst@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <71b1b9dd-78e3-9694-2daa-5723355293d4@gmail.com>
Date:   Tue, 5 May 2020 19:24:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505212325-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 6:25 PM, Michael S. Tsirkin wrote:
> On Tue, May 05, 2020 at 06:19:09PM -0700, Eric Dumazet wrote:
>>
>>
>> On 5/5/20 5:43 PM, Michael S. Tsirkin wrote:
>>> On Tue, May 05, 2020 at 03:40:09PM -0700, Eric Dumazet wrote:
>>>>
>>>>
>>>> On 5/5/20 3:30 PM, Thomas Gleixner wrote:
>>>>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>>>>>> On Tue, May 05, 2020 at 02:08:56PM +0200, Thomas Gleixner wrote:
>>>>>>>
>>>>>>> The following lockdep splat happens reproducibly on 5.7-rc4
>>>>>>
>>>>>>> ================================
>>>>>>> WARNING: inconsistent lock state
>>>>>>> 5.7.0-rc4+ #79 Not tainted
>>>>>>> --------------------------------
>>>>>>> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
>>>>>>> ip/356 [HC0[0]:SC1[1]:HE1:SE0] takes:
>>>>>>> f3ee4cd8 (&syncp->seq#2){+.?.}-{0:0}, at: net_rx_action+0xfb/0x390
>>>>>>> {SOFTIRQ-ON-W} state was registered at:
>>>>>>>   lock_acquire+0x82/0x300
>>>>>>>   try_fill_recv+0x39f/0x590
>>>>>>
>>>>>> Weird. Where does try_fill_recv acquire any locks?
>>>>>
>>>>>   u64_stats_update_begin(&rq->stats.syncp);
>>>>>
>>>>> That's a 32bit kernel which uses a seqcount for this. sequence counts
>>>>> are "lock" constructs where you need to make sure that writers are
>>>>> serialized.
>>>>>
>>>>> Actually the problem at hand is that try_fill_recv() is called from
>>>>> fully preemptible context initialy and then from softirq context.
>>>>>
>>>>> Obviously that's for the open() path a non issue, but lockdep does not
>>>>> know about that. OTOH, there is other code which calls that from
>>>>> non-softirq context.
>>>>>
>>>>> The hack below made it shut up. It's obvioulsy not ideal, but at least
>>>>> it let me look at the actual problem I was chasing down :)
>>>>>
>>>>> Thanks,
>>>>>
>>>>>         tglx
>>>>>
>>>>> 8<-----------
>>>>> --- a/drivers/net/virtio_net.c
>>>>> +++ b/drivers/net/virtio_net.c
>>>>> @@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet
>>>>>  			break;
>>>>>  	} while (rq->vq->num_free);
>>>>>  	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
>>>>> +		local_bh_disable();
>>>>
>>>> Or use u64_stats_update_begin_irqsave() whic is a NOP on 64bit kernels
>>>
>>> I applied this, but am still trying to think of something that
>>> is 0 overhead for all configs.
>>> Maybe we can select a lockdep class depending on whether napi
>>> is enabled?
>>
>>
>> Do you _really_ need 64bit counter for stats.kicks on 32bit kernels ?
>>
>> Adding 64bit counters just because we can might be overhead anyway.
> 
> Well 32 bit kernels don't fundamentally kick less than 64 bit ones,
> and we kick more or less per packet, sometimes per batch,
> people expect these to be in sync ..

Well, we left many counters in networking stack as 'unsigned long'
and nobody complained yet of overflows on 32bit kernels.

SNMP agents are used to the fact that counters do overflow.

Problems might happen if the overflows happen too fast, say every 10 seconds,
but other than that, forcing 64bit counters for something which is not
_required_ for the data path is adding pain.

I am mentioning this, because trying to add lockdep stuff and associated
maintenance cost for 32bit kernels in 2020 makes little sense to me,
considering I added include/linux/u64_stats_sync.h 10 years ago.






