Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52E14AF0C0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiBIMHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbiBIMEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:04:51 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B45DF28A74;
        Wed,  9 Feb 2022 03:32:36 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id z35so3785565pfw.2;
        Wed, 09 Feb 2022 03:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=xn2w0xfCDJKMhAVqaUxCw+DE0Sr56TdC/5hT2Q2ktAs=;
        b=A8XnlVtay/HPwPvCdYqCHbhrNjAZgJnAz0Xz+ujZCb1gAicdOF7VI2ESb4ZNYoXGY4
         mbx42w8+JYs1lJEgEhd4O11wXPcYLWocSpK165gtGz/ZKBGswmkaiKewGs6yWYvIwgwr
         r9V3K0mEM7Q34JnZkRm6UThjPbsR58FeN7pbOPMVFzjv/u+nlvhpc9HNwCo5/FhQu3JO
         /I8GUUsY2AuvPYjL9ycREBwkHVKoy6GV72mbhqmddW5bR3QjhW3f9GHodCZ8LBGhqxBh
         7St5JZzECmuAR4F/yBUA93iEy3kpuwfxodvIavc1VOLDIPkAWMlOIGC/t1sYk3E7gBVg
         LHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xn2w0xfCDJKMhAVqaUxCw+DE0Sr56TdC/5hT2Q2ktAs=;
        b=Lz1GZznlOV/iI8Nf1C/uYoDlfnb+RBBIhDMkTflCTMCkuunb/PMkTrzw5g5BBBinUY
         u8kzcfxbWFkJ7j8XIPtaaIBjnUtmGzlWXXciv5G7WOz+hukZh34c/hIgoxAXaYQZSnx+
         wkVUYngvs9rWVSoE81jZ/tUeujaYdxrOZV0jssVQe1YmRfHUKo7PCrGEBRC9H8o5I23P
         cMu9vDvL4/2ehqhZ2NxzcVs5bdfFKt1vCzFGNdvodRuy7H1SxeNkX9bTKqNc0f/0Cxuq
         I1qsSXAp1qtRdjrOUVPKge+/xH8KvS6y3jYQ3hnKLxshlqRhfNx5n+KnYhRpxg4lmu4t
         nS2g==
X-Gm-Message-State: AOAM530Pi+PukAKx89W6oral+lMwOclFgYCB3zA7rROsRk+JiULgOO9c
        QWcuA+I+YUWr7VmiaZ9NAT+lShCoEEI=
X-Google-Smtp-Source: ABdhPJxcG2NeFwP2rVZjOP8Uo+Mg/HUX5kmfxwL7u059Fj1k1jCekMP+xiw87WMqt8ide1F3HKlh8g==
X-Received: by 2002:a63:5641:: with SMTP id g1mr1501269pgm.579.1644406355113;
        Wed, 09 Feb 2022 03:32:35 -0800 (PST)
Received: from [192.168.1.100] ([166.111.139.99])
        by smtp.gmail.com with ESMTPSA id f5sm19090505pfc.0.2022.02.09.03.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 03:32:34 -0800 (PST)
Subject: Re: [BUG] net: mellanox: mlx4: possible deadlock in mlx4_xdp_set()
 and mlx4_en_reset_config()
To:     Tariq Toukan <ttoukan.linux@gmail.com>, tariqt@nvidia.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4a850d04-ed6a-5802-7038-a94ad0d466c5@gmail.com>
 <bde548df-cb80-966a-599c-3e1cb8639716@gmail.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <10008665-3a91-f95e-7ecb-994b8e8bcf55@gmail.com>
Date:   Wed, 9 Feb 2022 19:32:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <bde548df-cb80-966a-599c-3e1cb8639716@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/2/9 18:21, Tariq Toukan wrote:
>
>
> On 2/7/2022 5:16 PM, Jia-Ju Bai wrote:
>> Hello,
>>
>> My static analysis tool reports a possible deadlock in the mlx4 
>> driver in Linux 5.16:
>>
>
> Hi Jia-Ju,
> Thanks for your email.
>
> Which static analysis tool do you use? Is it standard one?

Hi Tariq,

Thanks for the reply and explanation :)
I developed this tool by myself, based on LLVM.

>
>> mlx4_xdp_set()
>>    mutex_lock(&mdev->state_lock); --> Line 2778 (Lock A)
>>    mlx4_en_try_alloc_resources()
>>      mlx4_en_alloc_resources()
>>        mlx4_en_destroy_tx_ring()
>>          mlx4_qp_free()
>>            wait_for_completion(&qp->free); --> Line 528 (Wait X)
>
> The refcount_dec_and_test(&qp->refcount)) in mlx4_qp_free() pairs with 
> refcount_set(&qp->refcount, 1); in mlx4_qp_alloc.
> mlx4_qp_event increases and decreasing the refcount while running 
> qp->event(qp, event_type); to protect it from being freed.
>
>>
>> mlx4_en_reset_config()
>>    mutex_lock(&mdev->state_lock); --> Line 3522 (Lock A)
>>    mlx4_en_try_alloc_resources()
>>      mlx4_en_alloc_resources()
>>        mlx4_en_destroy_tx_ring()
>>          mlx4_qp_free()
>>            complete(&qp->free); --> Line 527 (Wake X)
>>
>> When mlx4_xdp_set() is executed, "Wait X" is performed by holding 
>> "Lock A". If mlx4_en_reset_config() is executed at this time, "Wake 
>> X" cannot be performed to wake up "Wait X" in mlx4_xdp_set(), because 
>> "Lock A" has been already hold by mlx4_xdp_set(), causing a possible 
>> deadlock.
>>
>> I am not quite sure whether this possible problem is real and how to 
>> fix it if it is real.
>> Any feedback would be appreciated, thanks :)
>>
>
> Not possible.
> These are two different qps, maintaining two different instances of 
> refcount and complete, following the behavior I described above.

Okay, "there are two different qps" should be the reason of this false 
positive, and my tool cannot identify this reason in static analysis...


Best wishes,
Jia-Ju Bai
