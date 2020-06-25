Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B605B209AF4
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 10:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390460AbgFYICs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 04:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgFYICr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 04:02:47 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D338C061573
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 01:02:47 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ga4so4988327ejb.11
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 01:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WVxYWxtf4uiR7XU2GQotenhgA8bkGHvbt36SFR7GHlE=;
        b=L8KxjbitPipA0A1QRgTMR+hElCPZygBFA4COTvGdajQtY2JqJVeMU+d51fBKwPGCJM
         eI8Fn2M9W2P2XQcXWYsaeG9YF7+DibQx2FyHjiJ4Q0KvebHm0C+hByA9F1WtgLZfKPb2
         w1itmi7OitZq855TrnjyRb9KD/LyUXpDxs8acw1lwvGWrzi3V/NsThHf2MBX7MWZ7Fx1
         VvmDejHpiMi8ylqGWfO0s58Glo66OuhyE69J8OejjIg9PyoEqmi37o3EuIYY1rtUvqaH
         djcodrce6rSMJVGXx+6MXi/9tYEW3z+Awsj7MMQborqA14FTaEhWVvaAx6Hc/kGyUB6z
         DLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WVxYWxtf4uiR7XU2GQotenhgA8bkGHvbt36SFR7GHlE=;
        b=j0A312Y3OOfNYTl66OsRNWqpKo10oBnfSAdsuhNQzFeHbzA9HrY3I5oP/bLLRp47dM
         38eUB4hNgdSvJ4THE1lHO2IleivNZKvEUGqxr/5ZST+95xfFSD2UXvLEWJ9DGVNXOQx7
         nPs7l4OzfUWaIEgPGYDbE5EnfjnxDHWIJvQKcfMV7OeR1+/uZz6A/nPP7FrHOvimrPf5
         /kffvVoR3EcpASigjq+v0JdJBoeqsJF+/2oGmssu03DVioMwWwh8NDpiDTGiqx/Q+sOa
         FqP2kvw/iDfF48l8H2i1NT0xUmUjGzakZGDxRQ2gZZENR4qPDm6NquKVrKlDEMD1cOYU
         o7GA==
X-Gm-Message-State: AOAM531HEvqoY3cwne6kMC6T55pVlvq/FQhtvXbYWYQmRUltv8zoQMij
        To7K53TGTiqW5Bjkx4RXFeE=
X-Google-Smtp-Source: ABdhPJzk341p0sFq/riE+YXZECSjq0btoEktdTfyaJ5EKbvJJb1RLk/3Be/f4BL+ceByNxnHfDzA5w==
X-Received: by 2002:a17:906:824c:: with SMTP id f12mr18797864ejx.443.1593072165631;
        Thu, 25 Jun 2020 01:02:45 -0700 (PDT)
Received: from ?IPv6:2a0f:6480:3:1:e96f:c7f:ef7f:cae1? ([2a0f:6480:3:1:e96f:c7f:ef7f:cae1])
        by smtp.gmail.com with ESMTPSA id n5sm8697233eja.70.2020.06.25.01.02.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 01:02:45 -0700 (PDT)
Subject: Re: [PATCH] IPv6: Fix CPU contention on FIB6 GC
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
References: <20200622205355.GA869719@tws>
 <32da6a56-0217-acda-c12c-49f7c74275ef@gmail.com>
 <3230b95a-1ce0-b569-3d00-f7063ae9f1d9@gmail.com>
 <20200623220650.kymq7vbqiogvnsj3@lion.mk-sys.cz>
 <5be2063d-2433-54af-194d-fd4628974f29@gmail.com>
 <04671504-5ee4-7cfa-7b28-9e7f15c9f607@gmail.com>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <30113998-dd9a-b104-8953-d32a42770343@gmail.com>
Date:   Thu, 25 Jun 2020 10:02:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <04671504-5ee4-7cfa-7b28-9e7f15c9f607@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.06.20 18:42, Eric Dumazet wrote:
> 
> Our intention is to get rid of the IPv6 garbage collection, so we need to make sure
> we do not rely on it ;)

Hi Eric,

I can't really follow. Did you mean to get rid of the GC or the route cache?
And what is the plan? Separate structures for routes, ND and MTU exceptions as with IPv4?

However, I have a few questions regarding the FIB6.
After a few days of crawling through all this code, to me it looks like there is three types
of objects in the FIB6: Regular routes, neighbor discovery entries, MTU exceptions.
The latter two should then be subject to GC?

And regarding calling the GC from dst_alloc(): What is dst_entries_get_fast(ops) there
supposed to return? Number of entries in the FIB? Only MTU exceptions? MTU exceptions and
ND entries? 

> 
>>
>> Regarding your argument making the limit "softer":
>> There is only 2 functions that use/lock fib6_gc_lock:
>> 1. fib6_net_init
>> 2. fib6_run_gc 
>>
>> fib6_net_init is only called when the network namespace is initialized.
>>
>> fib6_run_gc clears all entries that are subject to garbage collection.
>> There is no gain in doing that N times (with N = amount of CPUs) and spinlocking all CPUs. 
>> Cleaning once is enough. A GC run is so short, that by the time the GC run is finished, 
>> there's most probably no new entry in the cache that is ready to be removed.
>> And even if there is. The next call to ip6_dst_gc will happen when a new entry
>> is added to the cache. Thus I can't see how my patch makes time limit softer.
>>
> 
> This are really minor implementation details, we need to find the root cause.
> 

Which root cause do you mean? For the entries to exist? Sure. Done and solved
(see my other patch). 

However, I think it still makes sense to make sure the GC can not block all CPUs (ever)
as it just never makes any sense. There is no real gain but the huge risk of heavy CPU
lock contention (freezing multiple CPUs for substantial amounts of time) when things go wrong. 
And they do go wrong (Murphy). 

There is two risks we have to look at:
1. The risk of heavy CPU lockups in softirq for substantial amounts of time (and the more CPUs
the machine has, the worse it gets)
2. The risk of temporarily consuming a little more RAM.

To me option 2 is much better as locked up CPUs are definitely killing production services (always),
while using a little more RAM can eventually cause the same result, it most likely won't as most likely 
there will be a few kb/mb of free RAM to store a few unneeded entries for a few microseconds.

I'm curious what reason there could be to stick to option 1.

Kind Regards
Oliver
