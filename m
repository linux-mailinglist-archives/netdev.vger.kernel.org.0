Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84956E7829
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 13:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjDSLJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 07:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbjDSLJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 07:09:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6456F7686
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681902537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhnLDPdJRHHLP6BO6DipeYLm7w/AeXwydv11cK/5DSc=;
        b=PKGy0oP26qSCnwS+D0WFfjhPQum9J6GQoCzRdjpJUUdXuohtloL3UsRhuC4I28FQH7bw/Z
        jN+OPYClxwex7T2izobDLCxBHvcp3B7099/ZnNMlm6/nnTrOdnCiqATDoWRT0gBvtQZYkX
        Y0/BJYH0+KQEnYyX1GPDASf3EFndiU0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-lgUTpxG6PrSecXJFNB9Z6Q-1; Wed, 19 Apr 2023 07:08:37 -0400
X-MC-Unique: lgUTpxG6PrSecXJFNB9Z6Q-1
Received: by mail-ed1-f69.google.com with SMTP id v10-20020a50d08a000000b0050675b95c83so9316023edd.4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:08:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681902504; x=1684494504;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FhnLDPdJRHHLP6BO6DipeYLm7w/AeXwydv11cK/5DSc=;
        b=MACsdVopTYvDXLiFepz++jvgtdN1oFtoMKtmS1yJmsp3NgOr0vQw24JhUe/q8GKwb/
         yl8RUmyh/M9EQO2LRXGNZR5fXrBuKcmRec2d0tV8BQxqGR6s03esTRFWsbvYMbwfmPIB
         UFSTT4Xt2dl9boHPV8uRv/HdfCb5BeeVdsq8sI1Kp1cM7pVwJ2sLafaoE6ok8n28uKVz
         KAqcnbdLEu8U6/3hdw1Q7vERjey1rro7P+vDjl1ZJ5g/kGxj8Qef3Oo43xFXTsk0HCe1
         BDmpIICcmfNg84R9eEX/6NzBYhYtbjbf9DVbkv/+mShEj7m5D6qqRKRJKyOBXFvQsBPM
         XuvQ==
X-Gm-Message-State: AAQBX9fkbHzZa2bKy7mgU8Q+QGk4OGZuVnmk21N6tON59bUMjg1Kl7Uy
        AtiS/bynNQEgc/qVNkzQlJ9eH4Y8eLKks1X4sGwm4pxenQpc9h5lkm7WDAZrBTuxUxm5m8lXSYH
        VaZGXhy4i/rOs2+lCSg+u7WLv
X-Received: by 2002:a17:907:971a:b0:94e:e039:98ca with SMTP id jg26-20020a170907971a00b0094ee03998camr2608478ejc.4.1681902504641;
        Wed, 19 Apr 2023 04:08:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZxYurKYcwxC2g/nwhQKogMILeS0qvVv7QaMkKW7K69isYCk41rIm2DjtcMKv1mpNYA0yCSvA==
X-Received: by 2002:a17:907:971a:b0:94e:e039:98ca with SMTP id jg26-20020a170907971a00b0094ee03998camr2608452ejc.4.1681902504268;
        Wed, 19 Apr 2023 04:08:24 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id sd27-20020a1709076e1b00b00953381ea1b7sm1316779ejc.90.2023.04.19.04.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 04:08:23 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <3449df3e-1133-3971-06bb-62dd0357de40@redhat.com>
Date:   Wed, 19 Apr 2023 13:08:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
Subject: Re: issue with inflight pages from page_pool
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
 <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
 <ZD2NSSYFzNeN68NO@lore-desk> <20230417112346.546dbe57@kernel.org>
 <ZD2TH4PsmSNayhfs@lore-desk> <20230417120837.6f1e0ef6@kernel.org>
 <ZD26lb2qdsdX16qa@lore-desk> <20230417163210.2433ae40@kernel.org>
 <ZD5IcgN5s9lCqIgl@lore-desk>
In-Reply-To: <ZD5IcgN5s9lCqIgl@lore-desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/04/2023 09.36, Lorenzo Bianconi wrote:
>> On Mon, 17 Apr 2023 23:31:01 +0200 Lorenzo Bianconi wrote:
>>>> If it's that then I'm with Eric. There are many ways to keep the pages
>>>> in use, no point working around one of them and not the rest :(
>>>
>>> I was not clear here, my fault. What I mean is I can see the returned
>>> pages counter increasing from time to time, but during most of tests,
>>> even after 2h the tcp traffic has stopped, page_pool_release_retry()
>>> still complains not all the pages are returned to the pool and so the
>>> pool has not been deallocated yet.
>>> The chunk of code in my first email is just to demonstrate the issue
>>> and I am completely fine to get a better solution :)
>>
>> Your problem is perhaps made worse by threaded NAPI, you have
>> defer-free skbs sprayed across all cores and no NAPI there to
>> flush them :(
> 
> yes, exactly :)
> 
>>
>>> I guess we just need a way to free the pool in a reasonable amount
>>> of time. Agree?
>>
>> Whether we need to guarantee the release is the real question.
> 
> yes, this is the main goal of my email. The defer-free skbs behaviour seems in
> contrast with the page_pool pending pages monitor mechanism or at least they
> do not work well together.
> 
> @Jesper, Ilias: any input on it?
> 
>> Maybe it's more of a false-positive warning.
>>
>> Flushing the defer list is probably fine as a hack, but it's not
>> a full fix as Eric explained. False positive can still happen.
> 
> agree, it was just a way to give an idea of the issue, not a proper solution.
> 
> Regards,
> Lorenzo
> 
>>
>> I'm ambivalent. My only real request wold be to make the flushing
>> a helper in net/core/dev.c rather than open coded in page_pool.c.

I agree. We need a central defer_list flushing helper

It is too easy to say this is a false-positive warning.
IHMO this expose an issue with the sd->defer_list system.

Lorenzo's test is adding+removing veth devices, which creates and runs
NAPI processing on random CPUs.  After veth netdevices (+NAPI) are
removed, nothing will naturally invoking net_rx_softirq on this CPU.
Thus, we have SKBs waiting on CPUs sd->defer_list.  Further more we will
not create new SKB with this skb->alloc_cpu, to trigger RX softirq IPI
call (trigger_rx_softirq), even if this CPU process and frees SKBs.

I see two solutions:

  (1) When netdevice/NAPI unregister happens call defer_list flushing 
helper.

  (2) Use napi_watchdog to detect if defer_list is (many jiffies) old, 
and then call defer_list flushing helper.


>>
>> Somewhat related - Eric, do we need to handle defer_list in dev_cpu_dead()?

Looks to me like dev_cpu_dead() also need this flushing helper for
sd->defer_list, or at least moving the sd->defer_list to an sd that will
run eventually.

--Jesper

