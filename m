Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274B5584ED7
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 12:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiG2Keq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 06:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiG2Kep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 06:34:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978CE52FEF;
        Fri, 29 Jul 2022 03:34:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id g12so4289589pfb.3;
        Fri, 29 Jul 2022 03:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=e94gu7YvVoXGncc7Fb46746deRoAgBtey9PiV4oNMBI=;
        b=CC+BPpD2SzawpZsy079/Sw5bMt9GXFKnACZP6X9usn4oHMPx+rhfyjP1/URaNcqQ0y
         utrEcEdN6DT5RMELQupuILhLBtNtVIREhFLmGqtNYThVFS95zbtk0S8Jk/QDidFWZnMr
         N6c8GeA/CuiGagsm6bkX62zGSOw9gFi23khjU3udDChl7XlS1vgaTZfUXUcsn4O7cymc
         92fZLZRjBRUIeJ2n72lcenCyPW/+eHrJP+uQzd1UFnDvhRLCzGqxqiv/Q6dRZbssDHCq
         0iN1aaYONy1ROItBfri1N0/en+I9GK8Rld1sOM0HECXHc8R1sxU97uVHcpRW/7N61fpm
         b+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=e94gu7YvVoXGncc7Fb46746deRoAgBtey9PiV4oNMBI=;
        b=qbgR6thuoy1PcsZmFheEwnir7vGf3EXcsiIQNchObJMP9+UxSXkA6aKd4rBrWhAm+E
         jNFyb/a6EoKK5xYHtyBxPCPE0fqcjq1lkARpnArZjAJQEfF7T4wWgzxryl9X4jFeiB94
         8Wx08bzsdxD/2aeaXSxDUUkY53IS+9lR817eoPh1K4FYdqwqhffy+Huik89rLLLad5Qj
         H3aruecdakyh4QPFpcq1YMPgFrltd7PVqB1JmnOpVtqqiEa6GLUkHeDK69ZXToaJe5es
         JHMHxieZflh1KfBFj7woPqY9SP+3lsPa1oZW7A+Fe7zT6y+bl4GuQvN29oN/K/gYv3jJ
         0K3g==
X-Gm-Message-State: AJIora9d4JNmUnWFR2MonXdLBMhBpdQX6fke9RQnnye7CqajidNphZym
        YNP0857a//ZXUOd8gUJirhFTjOZVVcM=
X-Google-Smtp-Source: AGRyM1vtwJglDrNDLrR1gNoHEV0uGHsUOoZMEummUyFbZwwt1kzBJAMnicAtuiNLJ/WSiSuECGfdsw==
X-Received: by 2002:a63:4644:0:b0:41b:6476:1f0f with SMTP id v4-20020a634644000000b0041b64761f0fmr2348720pgk.489.1659090883970;
        Fri, 29 Jul 2022 03:34:43 -0700 (PDT)
Received: from [192.168.50.247] ([129.227.148.126])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090322c100b0016d231e366fsm3302852plg.59.2022.07.29.03.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 03:34:43 -0700 (PDT)
Message-ID: <f77aebb0-129a-bc73-0976-854eeea33ae5@gmail.com>
Date:   Fri, 29 Jul 2022 18:34:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in
 the same lock
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuniyu@amazon.co.jp, richard_siegfried@systemli.org,
        joannelkoong@gmail.com, socketcan@hartkopp.net,
        gerrit@erg.abdn.ac.uk, tomasz@grobelny.oswiecenia.net,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220727080609.26532-1-hbh25y@gmail.com>
 <20220728200139.1e7d9bc6@kernel.org>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220728200139.1e7d9bc6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/7/29 11:01, Jakub Kicinski wrote:
> On Wed, 27 Jul 2022 16:06:09 +0800 Hangyu Hua wrote:
>> In the case of sk->dccps_qpolicy == DCCPQ_POLICY_PRIO, dccp_qpolicy_full
>> will drop a skb when qpolicy is full. And the lock in dccp_sendmsg is
>> released before sock_alloc_send_skb and then relocked after
>> sock_alloc_send_skb. The following conditions may lead dccp_qpolicy_push
>> to add skb to an already full sk_write_queue:
>>
>> thread1--->lock
>> thread1--->dccp_qpolicy_full: queue is full. drop a skb
> 
> This linie should say "not full"?

dccp_qpolicy_full only call dccp_qpolicy_drop when queue is full. You 
can check out qpolicy_prio_full. qpolicy_prio_full will drop a skb to 
make suer there is enough space for the next data. So I think it should 
be "full" here.

> 
>> thread1--->unlock
>> thread2--->lock
>> thread2--->dccp_qpolicy_full: queue is not full. no need to drop.
>> thread2--->unlock
>> thread1--->lock
>> thread1--->dccp_qpolicy_push: add a skb. queue is full.
>> thread1--->unlock
>> thread2--->lock
>> thread2--->dccp_qpolicy_push: add a skb!
>> thread2--->unlock
>>
>> Fix this by moving dccp_qpolicy_full.
>>
>> Fixes: 871a2c16c21b ("dccp: Policy-based packet dequeueing infrastructure")
> 
> This code was added in b1308dc015eb0, AFAICT. Please double check.
> 

My fault. I will fix this.

>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   net/dccp/proto.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
>> index eb8e128e43e8..1a0193823c82 100644
>> --- a/net/dccp/proto.c
>> +++ b/net/dccp/proto.c
>> @@ -736,11 +736,6 @@ int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>   
>>   	lock_sock(sk);
>>   
>> -	if (dccp_qpolicy_full(sk)) {
>> -		rc = -EAGAIN;
>> -		goto out_release;
>> -	}
>> -
>>   	timeo = sock_sndtimeo(sk, noblock);
>>   
>>   	/*
>> @@ -773,6 +768,11 @@ int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>   	if (rc != 0)
>>   		goto out_discard;
>>   
>> +	if (dccp_qpolicy_full(sk)) {
>> +		rc = -EAGAIN;
>> +		goto out_discard;
>> +	}
> 
> Shouldn't this be earlier, right after relocking? Why copy the data etc.
> if we know the queue is full?
> 

You are right. The queue should be checked first after relocking. I will 
send a v2 later.

Thanks,
Hangyu.

>>   	dccp_qpolicy_push(sk, skb);
>>   	/*
>>   	 * The xmit_timer is set if the TX CCID is rate-based and will expire
> 
