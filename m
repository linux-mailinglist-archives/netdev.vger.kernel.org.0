Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04ED820795F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391238AbgFXQm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391226AbgFXQm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:42:26 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB917C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:42:26 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k6so1256104pll.9
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6pxaXQppJ1NtFfT4bm1fjAmNyPG9fa55KVp8t6t9aUw=;
        b=NMg3/Xl8xJ+buVhg5JEdxHiY1mTS0iJhQLCOVZrjLXMVwto1jAhphFG3Kt4c2sx/d/
         zaIs368VIQsKNRy9Jj0o1N96BaDaPdMIaevqZ/co7YtmLEKmp7kqPqyVEXW9RE+feb9u
         TdafrEm8zspnkOCcBKElG15HolW1aHtU55MItPmlYYfibmUZEozcs9qNSWFacxAnF7NW
         X6/SfSp0scxr9wIo8x8TONSs9ug9dOZ86btg9Id8zqQuG2Xc3ZGx66SlX8gm0HCldTfN
         VT/mA4/z9OA8c6+Vys5ojtBh9rWvbqO+qH9HT+3qH1qdPq02n4T5u7/5dLKBSCZ1EC0h
         61Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6pxaXQppJ1NtFfT4bm1fjAmNyPG9fa55KVp8t6t9aUw=;
        b=Q0PZrRft4fEWbL1IDXmYD69DDz13Bi0ounuQo59FvbPTye5mgwA9n8FZHzeq3kFXqG
         dXp/Z+7GbXsAd2O4O0uSnKJ430G/LrKgjFAH068xcgl76SUccE8+y+TgJiUo89JPT6Z4
         1Fw46UzZumxY2UoJP+jV4fjMSbLKC2QMvh0cISkJ7yTrADMi8GEV460CVCZzXW5VK483
         dxiHlaQOi1uwxb+KG8fkWHWUcp/BsZLbkkrvYJmLhnMXHy+pZN8u/iM3yYw5Jcwili3M
         lg8XuT8DdvIyXoO+YtDJKM60wupHTSUE5SItv4ni4RYkTs4aayzecr5y25TA3Ghxurzb
         UUnQ==
X-Gm-Message-State: AOAM532+O5hP17HVXHWraW6s1660KYxASAoapleqU2aP0owdZM/nnJFS
        L4qeWMFSSyi6sQQujX5J5Ew=
X-Google-Smtp-Source: ABdhPJzH9KzpJRoEkEdWN/eaB4iVmgK3tBS4C6JHAGB+cybdaefmMtw7TiR3frxJnvFTyfsoA+DRDQ==
X-Received: by 2002:a17:90b:3746:: with SMTP id ne6mr30030336pjb.166.1593016946025;
        Wed, 24 Jun 2020 09:42:26 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y12sm3026153pfo.182.2020.06.24.09.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 09:42:24 -0700 (PDT)
Subject: Re: [PATCH] IPv6: Fix CPU contention on FIB6 GC
To:     Oliver Herms <oliver.peter.herms@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20200622205355.GA869719@tws>
 <32da6a56-0217-acda-c12c-49f7c74275ef@gmail.com>
 <3230b95a-1ce0-b569-3d00-f7063ae9f1d9@gmail.com>
 <20200623220650.kymq7vbqiogvnsj3@lion.mk-sys.cz>
 <5be2063d-2433-54af-194d-fd4628974f29@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <04671504-5ee4-7cfa-7b28-9e7f15c9f607@gmail.com>
Date:   Wed, 24 Jun 2020 09:42:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <5be2063d-2433-54af-194d-fd4628974f29@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/20 3:34 AM, Oliver Herms wrote:
> On 24.06.20 00:06, Michal Kubecek wrote:
>> On Tue, Jun 23, 2020 at 01:30:29AM +0200, Oliver Herms wrote:
>>>
>>> I'm encountering the issues due to cache entries that are created by 
>>> tnl_update_pmtu. However, I'm going to address that issue in another thread
>>> and patch.
>>>
>>> As entries in the cache can be caused on many ways this should be fixed on the GC
>>> level.
>>
>> Actually, not so many as starting with (IIRC) 4.2, IPv6 routing cache is
>> only used for exceptions (like PMTU), not for regular lookup results.
>>
> 
> Hi Michal,
> 
> Right. That is the intention. But reality is, that when sending IPv6 with an 
> MPLS encap route into a SIT/FOU tunnel, a cache entry is being created for every single
> destination on the tunnel. Now that IS a bug by itself and I'll shortly submit a 
> patch that should fix that issue.

Thanks !

> 
> However, when a tunnel uses PMTU, and a tunnel source received an ICMP packet too big
> for the tunnel destination, that triggers creation of IPv6 route cache entries
> (and for IPv4 entries in the corresponding data structure) for every destination for which
> packets are sent through the tunnel.
> 
> Both these attributes,
> 1. the presence or absence of, maybe spoofed, ICMP packet too big messages for the tunnel
> 2. the number of flows through a tunnel (attackers could just create more flows)
> are not fully under control by an operator.
> 
> Thus the assumption that if only max_size would be big enough, it would solve the problem, 
> it not correct.

Our intention is to get rid of the IPv6 garbage collection, so we need to make sure
we do not rely on it ;)

> 
> Regarding your argument making the limit "softer":
> There is only 2 functions that use/lock fib6_gc_lock:
> 1. fib6_net_init
> 2. fib6_run_gc 
> 
> fib6_net_init is only called when the network namespace is initialized.
> 
> fib6_run_gc clears all entries that are subject to garbage collection.
> There is no gain in doing that N times (with N = amount of CPUs) and spinlocking all CPUs. 
> Cleaning once is enough. A GC run is so short, that by the time the GC run is finished, 
> there's most probably no new entry in the cache that is ready to be removed.
> And even if there is. The next call to ip6_dst_gc will happen when a new entry
> is added to the cache. Thus I can't see how my patch makes time limit softer.
> 

This are really minor implementation details, we need to find the root cause.

