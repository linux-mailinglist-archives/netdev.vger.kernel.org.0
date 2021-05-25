Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8A638FF24
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhEYKcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbhEYKbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:31:39 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A31C061343
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:05 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gb17so28471558ejc.8
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OhjoyM/l8POvYFU9+0cpieRBGW2V3/WOA/e6FC0yJtI=;
        b=TIuZl6T5seXcW//VFSzZGPltSXvjEIcARu3XLIARtYVm9bJ1pjxzG1Kvd03P/od97h
         tQPcOxPSr16OvxgSZopAJy/1ocngI0mssOcNwCweXxbFwAiFwVc3ubs+K+EsicxmtEdE
         QfTyK0+QixbC9tW4H04np4XzDDkJkegHNZpyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OhjoyM/l8POvYFU9+0cpieRBGW2V3/WOA/e6FC0yJtI=;
        b=lY3ndl1Qd3yqfTWL8bx7xo2nyyFT8RPVcHiBsQeYCj0rWZE8aI3VH0lRl1F7hTcp0s
         3w3t4jTNH1qd594N34E1lyho9LFl8VzoT0YSO2CAdCm+W1UNgURSIow6MuXHabFiCq7g
         IjiUn4eGN6Dg8GeGUxMc+m/qKF+r5KEvsZNKL9vk04RKHOxsZcN+h8f8EX0XP8zWQTJZ
         hd9IKGqGsBKMDDntWAb3vhl2/ONF+NqL1dSftUwJQ8buh4SqmrBKLfiLLUUegMLLvAKA
         T2tsOaGYT1lO5ncYkbxETXtn8mbkZjCBzO4YuWuxdq5DHk1cNqIlCMY4HzMdbQpBaW8g
         6xvQ==
X-Gm-Message-State: AOAM533hghi2tfaD0eZrHvYobsPqzdTganWoN9Ae9DtoCopZfxH7oDIV
        QlJ9DzDG/O11FzOzA0H0zquH7Q==
X-Google-Smtp-Source: ABdhPJwonXu0+/ENSOsdsxzHoGsFEd8apOO5yrUj7TMJSFuBjz29/U1eF/GLpkB+bo3IzlQTDCWyqw==
X-Received: by 2002:a17:906:c218:: with SMTP id d24mr27292775ejz.363.1621938604443;
        Tue, 25 May 2021 03:30:04 -0700 (PDT)
Received: from [192.168.1.149] ([80.208.74.47])
        by smtp.gmail.com with ESMTPSA id p10sm455647ejc.14.2021.05.25.03.30.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 03:30:03 -0700 (PDT)
Subject: Re: [PATCH 1/2] lib: test_scanf: Fix incorrect use of type_min() with
 unsigned types
To:     Richard Fitzgerald <rf@opensource.cirrus.com>, pmladek@suse.com,
        rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        andriy.shevchenko@linux.intel.com, w@1wt.eu, lkml@sdf.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.cirrus.com,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
References: <20210524155941.16376-1-rf@opensource.cirrus.com>
 <20210524155941.16376-2-rf@opensource.cirrus.com>
 <a3396d45-4720-ee30-6493-b19f90c74e54@rasmusvillemoes.dk>
 <0650840d-1b7d-3bc0-c04f-3a22ddc1ced1@opensource.cirrus.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <ce344f9a-b184-3bc5-2873-b741047d292d@rasmusvillemoes.dk>
Date:   Tue, 25 May 2021 12:30:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <0650840d-1b7d-3bc0-c04f-3a22ddc1ced1@opensource.cirrus.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/2021 12.10, Richard Fitzgerald wrote:
> On 25/05/2021 10:55, Rasmus Villemoes wrote:
>> On 24/05/2021 17.59, Richard Fitzgerald wrote:
>>> sparse was producing warnings of the form:
>>>
>>>   sparse: cast truncates bits from constant value (ffff0001 becomes 1)
>>>
>>> The problem was that value_representable_in_type() compared unsigned
>>> types
>>> against type_min(). But type_min() is only valid for signed types
>>> because
>>> it is calculating the value -type_max() - 1.
> 
> Ok, I see I was wrong about that. It does in fact work safely. Do you
> want me to update the commit message to remove this?

Well, it was the "is only valid for signed types" I reacted to, so yes,
please reword.

>> ... and casts that to (T), so it does produce 0 as it should. E.g. for
>> T==unsigned char, we get
>>
>> #define type_min(T) ((T)((T)-type_max(T)-(T)1))
>> (T)((T)-255 - (T)1)
>> (T)(-256)
>>
> 
> sparse warns about those truncating casts.

That's sad. As the comments and commit log indicate, I was very careful
to avoid gcc complaining, even with various -Wfoo that are not normally
enabled in a kernel build. I think sparse is wrong here. Cc += Luc.



>>> diff --git a/lib/test_scanf.c b/lib/test_scanf.c
>>> index 8d577aec6c28..48ff5747a4da 100644
>>> --- a/lib/test_scanf.c
>>> +++ b/lib/test_scanf.c
>>> @@ -187,8 +187,8 @@ static const unsigned long long numbers[]
>>> __initconst = {
>>>   #define value_representable_in_type(T, val)                     \
>>>   (is_signed_type(T)                                 \
>>>       ? ((long long)(val) >= type_min(T)) && ((long long)(val) <=
>>> type_max(T)) \
>>> -    : ((unsigned long long)(val) >= type_min(T)) &&                 \
>>> -      ((unsigned long long)(val) <= type_max(T)))
>>> +    : ((unsigned long long)(val) <= type_max(T)))
>>
>>
>> With or without this, these tests are tautological when T is "long long"
>> or "unsigned long long". I don't know if that is intended. But it won't,
>> say, exclude ~0ULL if that is in the numbers[] array from being treated
>> as fitting in a "long long".
> 
> I don't entirely understand your comment. But the point of the test is
> to exclude values that can't be represented by a type shorter than
> long long or unsigned long long.

Right. But ~0ULL aka 0xffffffffffffffffULL is in that numbers[] array,
and that value cannot be represented in a "long long". Yet the test
still proceeds to do a test with it, AFAICT first sprinting it with
"%lld", then reading it back with "%lld". The first will produce -1,
which of course does fit, and the test case passes. I was just wondering
if this is really intended.

Rasmus
