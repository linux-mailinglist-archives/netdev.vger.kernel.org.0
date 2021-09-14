Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A249540B4B0
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 18:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhINQdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 12:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhINQda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 12:33:30 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62299C061764
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 09:32:13 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id n30so10096135pfq.5
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 09:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f4JwzT5yQfmhEs8lyajudsDeDRO8K4qEzjzoZEm2I94=;
        b=cmSZwgjjm5IQyrV+2lu8qX1WjFE3d9B7lCY4K7APv+Me9L3CxMaZLbzmVDNkRwoEm0
         OWpkTSSELSXcwPIN6+XxiDhiRJ+tg9gpBxYZz/rowVme+uHYLh0aWZtrGQfT4t1uf/VJ
         eeZSxZvaSx+p7rIEfF5qq/ppz3jvpepktl2dXplUdMCkv1M/pKJ2gM0LlkazS5fQe1YZ
         UHy0XHpa89weeQZ9MJvFiYb/+JX3XhVbVqrwJXKxQuQmqb7WiuK3z8z5n/rAu64BKTUh
         /jsS/2PD0x363hgz2cHXhCIIZ3Z7cubOYSiavqb5igCmVd/IPkzzIBXczjT6k7bdlwDU
         1kTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f4JwzT5yQfmhEs8lyajudsDeDRO8K4qEzjzoZEm2I94=;
        b=6MUPNiVF2b4NcPQomPbQ3rkT6NpVH/yNkkETHqUKQAvm4k5aSjMb3IUYiAutQBbwOA
         lpq5bzTxcXhfDJsmchq+VillYjfVQ5XD7bCYG66PIxMeiDi9zCD8JqE4My8QhFmLxCAz
         osLzfKXRDeGqlGZyIzVK6LK0BAcNjsZIxTme6xm9LLhztTEoSiULv2tDfRpLeo6UAFaj
         qiHfA+QpzMIEAFOk8PwRYcgzGftCElku8vzZ52bVWqhL01lD/LN0WIkKAPFgLybWscm3
         kn2+t7/atBRyyEvm2UFq8gt6hT1qDR9oSm89l3CwFxGlNzicOSurq4M5QsrhgqD14UPd
         UONQ==
X-Gm-Message-State: AOAM531YDeFJl5oqXyvllKsUO0XSfKHE+kEkswD51OGZxtL2nLivwr+L
        OZrqu6cbv4/M449077V4mlWUMGs52v0=
X-Google-Smtp-Source: ABdhPJyS86g27EBkP2vrliWdX+U/y70ZDAFmxum05nF6B+of05jZfFco31JDNVCCfxgqDuk8hM0dcQ==
X-Received: by 2002:a05:6a00:23cf:b0:3e2:4622:da6d with SMTP id g15-20020a056a0023cf00b003e24622da6dmr5769533pfc.18.1631637132487;
        Tue, 14 Sep 2021 09:32:12 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j11sm10956280pfa.10.2021.09.14.09.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 09:32:11 -0700 (PDT)
Subject: Re: [RFC net] net: stream: don't purge sk_error_queue without holding
 its lock
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     willemb@google.com, netdev@vger.kernel.org
References: <20210913223850.660578-1-kuba@kernel.org>
 <3b5549a2-cb0e-0dc1-3cb3-00d15a74873b@gmail.com>
 <20210914071836.46813650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c945d4ee-591c-7c38-8322-3fb9db0f104f@gmail.com>
Date:   Tue, 14 Sep 2021 09:32:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210914071836.46813650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/21 7:18 AM, Jakub Kicinski wrote:
> On Mon, 13 Sep 2021 22:14:00 -0700 Eric Dumazet wrote:
>> On 9/13/21 3:38 PM, Jakub Kicinski wrote:
>>> sk_stream_kill_queues() can be called when there are still
>>> outstanding skbs to transmit. Those skbs may try to queue
>>> notifications to the error queue (e.g. timestamps).
>>> If sk_stream_kill_queues() purges the queue without taking
>>> its lock the queue may get corrupted.
>>>
>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> ---
>>> Sending as an RFC for review, compile-tested only.
>>>
>>> Seems far more likely that I'm missing something than that
>>> this has been broken forever and nobody noticed :S
>>> ---
>>>  net/core/stream.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/core/stream.c b/net/core/stream.c
>>> index 4f1d4aa5fb38..7c585088f394 100644
>>> --- a/net/core/stream.c
>>> +++ b/net/core/stream.c
>>> @@ -196,7 +196,7 @@ void sk_stream_kill_queues(struct sock *sk)
>>>  	__skb_queue_purge(&sk->sk_receive_queue);
>>>  
>>>  	/* Next, the error queue. */
>>> -	__skb_queue_purge(&sk->sk_error_queue);
>>> +	skb_queue_purge(&sk->sk_error_queue);
>>>  
>>>  	/* Next, the write queue. */
>>>  	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
>>
>> This should not be needed.
>>
>> By definition, sk_stream_kill_queues() is only called when there is no
>> more references on the sockets.
>>
>> So all outstanding packets must have been orphaned or freed.
> 
> I don't see the wait anywhere, would you mind spelling it out?
> My (likely flawed) understanding is that inet_sock_destruct() gets
> called when refs are gone (via sk->sk_destruct).


> 
> But tcp_disconnect() + tcp_close() seem to happily call
> inet_csk_destroy_sock() -> sk_stream_kill_queues() with outstanding
> sk_wmem_alloc refs.

tcp_disconnect() should probably leave the error queue as is.

For some reason I thought your report was about inet_sock_destruct()

tcp_disconnect() has always been full of bugs, it is surprising real applications
(not fuzzers) are still trying to use it.

> 
>> Anyway, Linux-2.6.12-rc2 had no timestamps yet.
> 
> I see, thanks, if some form of the patch stands perhaps:
> 
> Fixes: cb9eff097831 ("net: new user space API for time stamping of incoming and outgoing packets")
> 

Except that this patch wont prevent a packet being added to sk_error_queue
right after skb_queue_purge(&sk->sk_error_queue).

If you think there is a bug, it must be fixed in another way.

IMO, preventing err packets from a prior session being queued after a tcp_disconnect()
is rather hard. We should not even try (packets could be stuck for hours in a qdisc)

