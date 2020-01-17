Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C79E1141119
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgAQSs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:48:26 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34127 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgAQSs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 13:48:26 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so12093282pgf.1;
        Fri, 17 Jan 2020 10:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uf2grPri+Pk70ySyorIWRt3xOE6amIrsICg9f4UOiek=;
        b=jQRQTldyPxOJDIzuGEiFZ7SbwJbDbJJZIZJtShG+tPkycNQT1BrpN5BPde5niFnHKu
         qCTwnSpXS7gL1IRfmnw6K2RtOQCqhGRHemIr4uGyUTmKeXqLJ2qgo40JAhrYjRce3u5u
         6HwQyNb8ABAznP5xHcoxVfEeVq+3YY0WIuQSxZNF1Olw7PQwFGzecFHc4JZgDjULHNrt
         dv2LrSbKaxXlqUAS9bBlBqGVxrhcA7sqfD806e/OpXBG0K2Dt43ABqD51Y0Ffe2Oi5WM
         s7hZ9w9FtGIDpELVVJ74Rf2jQYkhep+KLV4mvfiANFL5c5UhVB6x6+rBvJrbogB9Bct8
         TDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uf2grPri+Pk70ySyorIWRt3xOE6amIrsICg9f4UOiek=;
        b=PXBmw1XeVYMcVFsTcZ9QvYAuXBT6yGMgvwxpfGFq3rZSgGVSKdHt+UsuI7+oRp7ftD
         aEnJaS+REEcMoho/s18Lp1yNDF08PZgG6TyYsHKvrUnmdPtwX3XKbRU0UBXHXYAMhGxz
         VRXbIiW8uOEtrY02hMdSbIGRqAhIOKSrnNLkKj/wd+VqXQj5QeF5SMQaKkXIncgkgf/p
         VS2rSBF5KstTz6Uyb/adfHpXRlcRQLocs4Y9NfNYEk+mrEXbQSq9p0T4XBpGThGAvfho
         cpr++wsdH6vLgzXMzbQ7IWCtBImgJoRJnW4MaazSNzIQYNHoFPNYlZKAyEuJkN6/aQzJ
         T3jg==
X-Gm-Message-State: APjAAAXJx6JEDBSRQGSGcbtOYGVhc1Oxj88rWlIRgK46ZtgsrBFU8wAU
        oT2tWv0AaGAMYb1eAr3kqWc=
X-Google-Smtp-Source: APXvYqyvXwmbIo2pROIrbwWIUHlo1UI2+KfXA/vCZHjGuwWa9d4r5hP8/q1nJyTRTwffia3TMmlJ5w==
X-Received: by 2002:aa7:9816:: with SMTP id e22mr4382433pfl.229.1579286905813;
        Fri, 17 Jan 2020 10:48:25 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id v15sm8304050pju.15.2020.01.17.10.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 10:48:25 -0800 (PST)
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
To:     Arvind Sankar <nivedita@alum.mit.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jinyuqi@huawei.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        guoyang2@huawei.com, Will Deacon <will@kernel.org>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net>
 <7e6c6202-24bb-a532-adde-d53dd6fb14c3@gmail.com>
 <20200117180324.GA2623847@rani.riverdale.lan>
 <94573cea-a833-9b48-6581-8cc5cdd19b89@gmail.com>
 <20200117183800.GA2649345@rani.riverdale.lan>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <45224c36-9941-aae5-aca4-e2c8e3723355@gmail.com>
Date:   Fri, 17 Jan 2020 10:48:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200117183800.GA2649345@rani.riverdale.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/20 10:38 AM, Arvind Sankar wrote:
> On Fri, Jan 17, 2020 at 10:16:45AM -0800, Eric Dumazet wrote:
>> Wasńt it the case back in 2016 already for linux-4.8 ?
>>
>> What will prevent someone to send another report to netdev/lkml ?
>>
>>  -fno-strict-overflow support is not a prereq for CONFIG_UBSAN.
>>
>> Fact that we kept in lib/ubsan.c and lib/test_ubsan.c code for 
>> test_ubsan_add_overflow() and test_ubsan_sub_overflow() is disturbing.
>>
> 
> No, it was bumped in 2018 in commit cafa0010cd51 ("Raise the minimum
> required gcc version to 4.6"). That raised it from 3.2 -> 4.6.
> 

This seems good to me, for gcc at least.

Maybe it is time to enfore -fno-strict-overflow in KBUILD_CFLAGS 
instead of making it conditional.

Thanks.
