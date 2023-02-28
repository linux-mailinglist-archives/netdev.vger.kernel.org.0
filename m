Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5D36A50CE
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 02:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjB1BsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 20:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjB1BsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 20:48:18 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BB6113F6;
        Mon, 27 Feb 2023 17:48:18 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id u5so5445989plq.7;
        Mon, 27 Feb 2023 17:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677548898;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fuxi2Ph3dEYFWBIK3fO91ydoj6EsxhxaDYSbv7nd3WE=;
        b=VAAOPUL78BN21OwPsprfQRfAf30U3pzgxqqyEYoe8C1XqDjGb1LwY0nkNVIcbYxgg4
         7nYUgKpG83puWKH7RnbbA8mO9sj9w27fiV/CF7pnudykRKY+T766q/3nI58dzXiiIODG
         Lbee5ri15Na+KQI3iMLbDgnyclh8o9nR5p/PU+wqVyqc6Uyj8DRkhhfn9bIdMlwrgSvG
         tl2paUoQcfKsRRV5IWtBQVX5/beEFxCQBMUTjfQYD1J4CFX37uX8peZxis8Vj1ZnKQnB
         QAtoqvtJlwPNnm7KN9OzqI+8BOm4uuBU15z10ZhK1djSzkU094r0KB+Xvq+gsLe1XRLq
         L5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677548898;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fuxi2Ph3dEYFWBIK3fO91ydoj6EsxhxaDYSbv7nd3WE=;
        b=uSjiH4vDmuIqUv3Dt00coH3yh1tcGd7VTgXSUfyDUlGV7ApKWzTgexJ9vTJ3GYpQOJ
         wHdCgmTWhnbYzxoTzctMG9AtXmMhXjKd4ReAXxcdtbFt74gjQzh3AEFCqlU7RNC/5WN7
         hJfKiy4zBap9/frCoLL47UN2b0zGXZ0ybSZMdYV8nnGoSawtUCz3pTFTPCfjPvSV2Nrz
         0rXiwbbRZr8DAQoYvINvXaC/6WTHeXAQYQ8rb06re568JKzCzojJPA9DUugKe0o1pT5W
         81fOVI9zfizT/e1CaDUuR7wtYsCSugVv29203zvIzAMh0E+hD/i05/7+Hag/sUkFVBTD
         T3Fg==
X-Gm-Message-State: AO0yUKXdPPeKkQLfveO6yLSwhBiwaaV1MWBuZ6C74Q5AyZm9IpR+rQSk
        m4sboSTg0drm1A/0bgw2WgQ=
X-Google-Smtp-Source: AK7set92pp9hYlZRbO//Og6UNuQDneFPXto5iP7xKBLSU2HL0C1TFOd8MW8dQJu5IKU8tyyNc4RifQ==
X-Received: by 2002:a17:903:32c4:b0:19a:a2e7:64de with SMTP id i4-20020a17090332c400b0019aa2e764demr1256410plr.0.1677548897584;
        Mon, 27 Feb 2023 17:48:17 -0800 (PST)
Received: from [127.0.0.1] ([103.152.220.17])
        by smtp.gmail.com with ESMTPSA id b21-20020a170902d31500b001994a0f3380sm5140002plc.265.2023.02.27.17.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 17:48:16 -0800 (PST)
Message-ID: <12305071-c136-f39f-9450-bdaad08137b2@gmail.com>
Date:   Tue, 28 Feb 2023 09:48:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Florian Westphal <fw@strlen.de>, borisp@nvidia.com,
        john.fastabend@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, davejwatson@fb.com, aviadye@mellanox.com,
        ilyal@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230224105811.27467-1-hbh25y@gmail.com>
 <20230224120606.GI26596@breakpoint.cc> <20230224105508.4892901f@kernel.org>
 <Y/kck0/+NB+Akpoy@hog> <20230224130625.6b5261b4@kernel.org>
 <Y/kwyS2n4uLn8eD0@hog> <20230224141740.63d5e503@kernel.org>
 <52faaa10-f3e4-bca9-4bff-6f1ea7d26593@gmail.com>
 <20230227110750.6988fca5@kernel.org>
Content-Language: en-US
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20230227110750.6988fca5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/2/2023 03:07, Jakub Kicinski wrote:
> On Mon, 27 Feb 2023 11:26:18 +0800 Hangyu Hua wrote:
>> In order to reduce ambiguity, I think it may be a good idea only to
>> lock do_tls_getsockopt_conf() like we did in do_tls_setsockopt()
>>
>> It will look like:
>>
>> static int do_tls_getsockopt(struct sock *sk, int optname,
>> 			     char __user *optval, int __user *optlen)
>> {
>> 	int rc = 0;
>>
>> 	switch (optname) {
>> 	case TLS_TX:
>> 	case TLS_RX:
>> +		lock_sock(sk);
>> 		rc = do_tls_getsockopt_conf(sk, optval, optlen,
>> 					    optname == TLS_TX);
>> +		release_sock(sk);
>> 		break;
>> 	case TLS_TX_ZEROCOPY_RO:
>> 		rc = do_tls_getsockopt_tx_zc(sk, optval, optlen);
>> 		break;
>> 	case TLS_RX_EXPECT_NO_PAD:
>> 		rc = do_tls_getsockopt_no_pad(sk, optval, optlen);
>> 		break;
>> 	default:
>> 		rc = -ENOPROTOOPT;
>> 		break;
>> 	}
>> 	return rc;
>> }
>>
>> Of cause, I will clean the lock in do_tls_getsockopt_conf(). What do you
>> guys think?
> 
> I'd suggest to take the lock around the entire switch statement.

I get it. I will send a v2 later.

Thanks,
Hangyu
