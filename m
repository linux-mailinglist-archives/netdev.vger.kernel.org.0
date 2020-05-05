Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFB21C640D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 00:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgEEWkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 18:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgEEWkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 18:40:13 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D5CC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 15:40:12 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f8so170917plt.2
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 15:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YncV9CUGG2f+ezKZApwaV6IO5AUde9KegofVoeADXyc=;
        b=MXTWNrp0SFeRW0JSfQmGTi7j7P7r63vWiQDhImFAwbLHYpgjLdR7cEDeYhf7FfCnUA
         x9s8JfnjSp5kZ78sZU47MMShiqIgTtgiS6RfxbJ6saQnd8GBqOl5QovpN68CN/4MoWmg
         fEhuprmhQhalvbjWaGHyXCeSV9WfDrbtpWPjryWYkOwIZHQDlC5YimTqVP3wda6nkUVR
         sbAwYW03QcxVetylQyaQf3PparUuJc/WY79lrbA1minl2mjSqhEn8LS3S/ZKrkWsOj3H
         9RFWiGVD7w1BIampcSMqJRhp2gbrvnffF7uSC3eMumsEkIu/58z3foFeBJCtVDrQWJA6
         DRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YncV9CUGG2f+ezKZApwaV6IO5AUde9KegofVoeADXyc=;
        b=TLo6S9fmiMH1TlKS24OLqbsxw6CMY8DP/UxoU4Lh1HnaekI5A+zC5HZwXAAvvqqbP2
         T5Sxpjv3r+b82cnmK5CAXZ5eEbMAinKFWtqm5Nw1BIm57EccJJw2FBdw4tpL3jfSVikL
         LMzVguZRQNuSCvSFxIsBXcpFY47Ek09Qg9bLAP1gkoDsD0un4f/MgjT2xtGyxflnArWX
         SLrB8rTY1XF8OzEvFUsn5F65conVez3I7HrOKMbhLIoW3TYMtHvyG/BwKEMQ7b6RaOkM
         lqenRDNbI0jt14f0m++8emEsmxzxpMChWItNOZxf8FhnSo4mHJJzFkJX50WwTQZG/SLk
         1Hpw==
X-Gm-Message-State: AGi0PubUawMlInTUStnh2sZmg/OA3J0kv1zNVEBQG7+/dDSQ2vBA7PDy
        jJQH7y77K7/kvpTzRc4tUtw=
X-Google-Smtp-Source: APiQypIox1Da9Q7h1v4wZvboKyiRfuNWuAMu4VuHxnIgDJf4rm61QnaolhB3k+TL88iv6s68pEhuwA==
X-Received: by 2002:a17:90a:fb4e:: with SMTP id iq14mr5597868pjb.146.1588718411681;
        Tue, 05 May 2020 15:40:11 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c10sm15114pfm.50.2020.05.05.15.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 15:40:11 -0700 (PDT)
Subject: Re: [BUG] Inconsistent lock state in virtnet poll
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <87lfm6oa7b.fsf@nanos.tec.linutronix.de>
 <20200505120352-mutt-send-email-mst@kernel.org>
 <87v9lanher.fsf@nanos.tec.linutronix.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <98c4d934-5a27-1cf7-119a-ce0c5a501864@gmail.com>
Date:   Tue, 5 May 2020 15:40:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87v9lanher.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 3:30 PM, Thomas Gleixner wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
>> On Tue, May 05, 2020 at 02:08:56PM +0200, Thomas Gleixner wrote:
>>>
>>> The following lockdep splat happens reproducibly on 5.7-rc4
>>
>>> ================================
>>> WARNING: inconsistent lock state
>>> 5.7.0-rc4+ #79 Not tainted
>>> --------------------------------
>>> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
>>> ip/356 [HC0[0]:SC1[1]:HE1:SE0] takes:
>>> f3ee4cd8 (&syncp->seq#2){+.?.}-{0:0}, at: net_rx_action+0xfb/0x390
>>> {SOFTIRQ-ON-W} state was registered at:
>>>   lock_acquire+0x82/0x300
>>>   try_fill_recv+0x39f/0x590
>>
>> Weird. Where does try_fill_recv acquire any locks?
> 
>   u64_stats_update_begin(&rq->stats.syncp);
> 
> That's a 32bit kernel which uses a seqcount for this. sequence counts
> are "lock" constructs where you need to make sure that writers are
> serialized.
> 
> Actually the problem at hand is that try_fill_recv() is called from
> fully preemptible context initialy and then from softirq context.
> 
> Obviously that's for the open() path a non issue, but lockdep does not
> know about that. OTOH, there is other code which calls that from
> non-softirq context.
> 
> The hack below made it shut up. It's obvioulsy not ideal, but at least
> it let me look at the actual problem I was chasing down :)
> 
> Thanks,
> 
>         tglx
> 
> 8<-----------
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet
>  			break;
>  	} while (rq->vq->num_free);
>  	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
> +		local_bh_disable();

Or use u64_stats_update_begin_irqsave() whic is a NOP on 64bit kernels

>  		u64_stats_update_begin(&rq->stats.syncp);
>  		rq->stats.kicks++;
>  		u64_stats_update_end(&rq->stats.syncp);
> +		local_bh_enable();
>  	}
>  
>  	return !oom;
> 
