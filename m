Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D466A3978
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 04:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjB0D01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 22:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjB0D00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 22:26:26 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549951B300;
        Sun, 26 Feb 2023 19:26:25 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id y19so2736395pgk.5;
        Sun, 26 Feb 2023 19:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677468385;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pTAyCDuPVoYFDm79hICx8oCzRbRRaxwQHJnnNpefpDs=;
        b=C7lOgPKf7E4ODsUGG0Zdu0Xd+1rwiz3Wb1CGumFg6Tn0fPttpdu4l4FnLTl9TJZLe5
         G0GpwgWP4xhuhoA80Gi3w3ddGDeg013cCCwX3QbnbsEvrMFqhbqx4egSfqRGJcFiJu00
         j5WLaZ6lihwAHbfBqZkfJgh2fyEcQ9jbrYGCeDjLYNClFGifDEIOKJ+X0x7eU9174Q+s
         0GlSOJ0f6fz0y4UGlbQolSLkPJznqMGLDVLbYRlrNleE+546vN5wBMAScPwiBwZ9FdIO
         vE18YKkAcTcgd1Xnq0Z0XcvfN8WQdTkrjqiCG/JnvpbDu2siPp0yRJo4eir0j02JsGMt
         PUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677468385;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pTAyCDuPVoYFDm79hICx8oCzRbRRaxwQHJnnNpefpDs=;
        b=XNY5wL694dRbOEspcKcZQbjR/QAMpUi5WEgd03PPxw2Xua4hw4mD8ALjn7SLZZPum5
         /RWRsNrZdMtGJTSP02/OLmoJgc2sKZpNzszuUpCEIEwWe855E0jmHjbQ+KEfiA+JbuVD
         GmLE9o84N7vG+2v/dHTH51WDBVpfuErx7g2GmKE8tz4LmE9MvwsioC4BR4Oad5xQRUbR
         eT1wADifUzMO2fEvJh+Q4DR/kZBDiVwkRH92VZoy9BCJXQHXLyKnNoA7jIF3J2TGjS2X
         SL349oeS8Ek9Eggka80JM3qKURO7/7IjZp2xAl/nARYo632Lv67R6X5WJNn0WoTehnGu
         /JAg==
X-Gm-Message-State: AO0yUKXNR0Bc/C/LAhP8uTMGrwK8t1Y27nO886BClgGoF1M839FJG8V0
        t2iAB6tRCA5VX0o9ciBZ8MI=
X-Google-Smtp-Source: AK7set+BHpeXYub5GyComscA4jVqXXcV0BH3PYIc7M0Lp5vLkxSBB4MhIWzvAc0OlrJlIcexvI5lJw==
X-Received: by 2002:aa7:9153:0:b0:5f5:313e:49dd with SMTP id 19-20020aa79153000000b005f5313e49ddmr2147861pfi.1.1677468384720;
        Sun, 26 Feb 2023 19:26:24 -0800 (PST)
Received: from [127.0.0.1] ([103.152.220.17])
        by smtp.gmail.com with ESMTPSA id j18-20020aa78dd2000000b00571cdbd0771sm3095366pfr.102.2023.02.26.19.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Feb 2023 19:26:24 -0800 (PST)
Message-ID: <52faaa10-f3e4-bca9-4bff-6f1ea7d26593@gmail.com>
Date:   Mon, 27 Feb 2023 11:26:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Cc:     Florian Westphal <fw@strlen.de>, borisp@nvidia.com,
        john.fastabend@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, davejwatson@fb.com, aviadye@mellanox.com,
        ilyal@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230224105811.27467-1-hbh25y@gmail.com>
 <20230224120606.GI26596@breakpoint.cc> <20230224105508.4892901f@kernel.org>
 <Y/kck0/+NB+Akpoy@hog> <20230224130625.6b5261b4@kernel.org>
 <Y/kwyS2n4uLn8eD0@hog> <20230224141740.63d5e503@kernel.org>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20230224141740.63d5e503@kernel.org>
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

On 25/2/2023 06:17, Jakub Kicinski wrote:
> On Fri, 24 Feb 2023 22:48:57 +0100 Sabrina Dubroca wrote:
>> 2023-02-24, 13:06:25 -0800, Jakub Kicinski wrote:
>>> On Fri, 24 Feb 2023 21:22:43 +0100 Sabrina Dubroca wrote:
>>   [...]
>>>>
>>>> I suggested a change of locking in do_tls_getsockopt_conf this
>>>> morning [1]. The issue reported last seemed valid, but this patch is not
>>>> at all what I had in mind.
>>>> [1] https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/
>>>
>>> Ack, I read the messages out of order, sorry.
>>>    
>>>> do_tls_setsockopt_conf fills crypto_info immediately from what
>>>> userspace gives us (and clears it on exit in case of failure), which
>>>> getsockopt could see since it's not locking the socket when it checks
>>>> TLS_CRYPTO_INFO_READY. So getsockopt would progress up to the point it
>>>> finally locks the socket, but if setsockopt failed, we could have
>>>> cleared TLS_CRYPTO_INFO_READY and freed iv/rec_seq.
>>>
>>> Makes sense. We should just take the socket lock around all of
>>> do_tls_getsockopt(), then?
>>
>> That would make things simple and consistent. My idea was just taking
>> the existing lock_sock in do_tls_getsockopt_conf out of the switch and
>> put it just above TLS_CRYPTO_INFO_READY.

I know what you mean. I just think lock crypto_info can fix this simply.

The original situation is:

thread1				thread2(do_tls_getsockopt_conf)

lock_sock(sk)
do_tls_setsockopt_conf(crypto_info->cipher_type set)

				crypto_info = xxx
				cctx = &ctx->tx
				if(!TLS_CRYPTO_INFO_READY(crypto_info))
				
tls_set_device_offload(kmalloc cctx->iv)
tls_set_sw_offload(fail and cctx->iv may not set to NULL)
do_tls_setsockopt_conf(set crypto_info->cipher_type to NULL)
release_sock(sk)

				lock_sock(sk)
				memcpy(xxx, cctx->iv, xxx)
				release_sock(sk)

If we lock crypto_info:

thread1				thread2(do_tls_getsockopt_conf)

lock_sock(sk)
do_tls_setsockopt_conf(crypto_info->cipher_type set)			
tls_set_device_offload(kmalloc cctx->iv)
tls_set_sw_offload(fail and cctx->iv may not set to NULL)
do_tls_setsockopt_conf(set crypto_info->cipher_type to NULL)
release_sock(sk)

				lock_sock(sk)
				crypto_info = xxx
				cctx = &ctx->tx
				release_sock(sk)
				if(!TLS_CRYPTO_INFO_READY(crypto_info))
				lock_sock(sk)
				memcpy(xxx, cctx->iv, xxx)
				release_sock(sk)

>>
>> While we're at it, should we move the
>>
>>      ctx->prot_info.version != TLS_1_3_VERSION
>>
>> check in do_tls_setsockopt_no_pad under lock_sock?
> 
> Yes, or READ_ONCE(), same for do_tls_getsockopt_tx_zc() and its access
> on ctx->zerocopy_sendfile.
> 
>>   I don't think that
>> can do anything wrong (we'd have to get past this check just before a
>> failing setsockopt clears crypto_info, and even then we're just
>> reading a bit from the context), it just looks a bit strange. Or just
>> lock the socket around all of do_tls_setsockopt_no_pad, like the other
>> options we have.
> 
> The delayed locking feels like a premature optimization, we'll keep
> having such issues with new options. Hence my vote to lock all of
> do_tls_getsockopt().

In order to reduce ambiguity, I think it may be a good idea only to
lock do_tls_getsockopt_conf() like we did in do_tls_setsockopt()

It will look like:

static int do_tls_getsockopt(struct sock *sk, int optname,
			     char __user *optval, int __user *optlen)
{
	int rc = 0;

	switch (optname) {
	case TLS_TX:
	case TLS_RX:
+		lock_sock(sk);
		rc = do_tls_getsockopt_conf(sk, optval, optlen,
					    optname == TLS_TX);
+		release_sock(sk);
		break;
	case TLS_TX_ZEROCOPY_RO:
		rc = do_tls_getsockopt_tx_zc(sk, optval, optlen);
		break;
	case TLS_RX_EXPECT_NO_PAD:
		rc = do_tls_getsockopt_no_pad(sk, optval, optlen);
		break;
	default:
		rc = -ENOPROTOOPT;
		break;
	}
	return rc;
}

Of cause, I will clean the lock in do_tls_getsockopt_conf(). What do you
guys think?




