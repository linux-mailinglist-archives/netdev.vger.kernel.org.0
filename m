Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90252D375C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbgLIADy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730574AbgLIADy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:03:54 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A945C0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 16:03:14 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id y74so482667oia.11
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 16:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6uKN3QCyG/lJk4DtG6J6gEFbt2cm51fOACHGUB+3TvM=;
        b=VM9cfBkWfoblwHfkIZ1U30nSLTalSeeVo7R0Jg65BjJpUQKrL5dj2/pT8rvVI2E1Zu
         qGewq4tqDwpCCTDvwkQvCmI+EXE4QpvTGuXLpw56Kbv2upZlquXhGO7lZ96LDVpYU5jC
         7HHlWgK5wXZl1ah7q8f41U5ItTCuf5tYbD9ZWehjoVvsRqoc2KrIlNelSAeC9wMVWsHP
         UJqleK5cG9qRmXDa7UsBde+vcY3d9CbjKZIRdG9nilrYb8RkbW8r/Z0t/NXSznreSYV7
         0A4Y1j92O0/T7DZp5puZS5NfgyBukaT0Sz5sGmh55G4BE33mpIdMER1XKjbLqczxKNlq
         1Ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6uKN3QCyG/lJk4DtG6J6gEFbt2cm51fOACHGUB+3TvM=;
        b=TOOdKHBFmixQ2LjxL1CjKmNe+EYNdNr0VB8vSvhBOfyzQMZWdFp9iwHqJMOyl2Ldto
         WjKRhIEDuVspwHIqelrEeRT0sH6DQl1vSXxeFoZcisoNMcHE8zzUTMau8LB/yYkqgWgz
         qduIf+07lbYDiSszSFbbPqLz/17AFgZZYgT1idPOen8l1Dw46+1LmXG6YXYkezNgTJzB
         PVYjbgVwW8BfkpKnyt36x6oB6nCtCHtSsV4BeEKOjKyE8JM0jkgd1kFMEPTR8LnJoM47
         Mf+kuF6zU3tzJVTwKZCPUTVf+E9EtgOuIhVpFVAzy5O6Tw9sUhpapWEad/+Su+RDQA0g
         K/zA==
X-Gm-Message-State: AOAM53241GQ9EufUODcieraPctXuE+Oqbajz0Sll8sdZL2swvMe9H+4I
        XkUFFC0hqfu8nGakniCtd0I=
X-Google-Smtp-Source: ABdhPJyuNQEdbviIgNIjDe9uPoHMKjq6v8pQxdAiGIcRUACf6y3B2T1TV62P1yclITZZIxtIktlZcw==
X-Received: by 2002:aca:d5c3:: with SMTP id m186mr301792oig.73.1607472193893;
        Tue, 08 Dec 2020 16:03:13 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:64fc:adeb:84f9:fa62])
        by smtp.googlemail.com with ESMTPSA id 9sm84133otl.52.2020.12.08.16.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 16:03:13 -0800 (PST)
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
To:     Wei Wang <weiwan@google.com>, stranche@codeaurora.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
 <56e72b72-685f-925d-db2d-d245c1557987@gmail.com>
 <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
 <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org>
 <CAEA6p_ArQdNp=hQCjrsnAo-Xy22d44b=2KdLp7zO7E7XDA4Fog@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f10c733a-09f8-2c72-c333-41f9d53e1498@gmail.com>
Date:   Tue, 8 Dec 2020 17:03:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_ArQdNp=hQCjrsnAo-Xy22d44b=2KdLp7zO7E7XDA4Fog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/20 2:51 PM, Wei Wang wrote:
> On Tue, Dec 8, 2020 at 11:13 AM <stranche@codeaurora.org> wrote:
>>
>> Hi Wei and Eric,
>>
>> Thanks for the replies.
>>
>> This was reported to us on the 5.4.61 kernel during a customer
>> regression suite, so we don't have an exact reproducer unfortunately.
>>  From the trace logs we've added it seems like this is happening during
>> IPv6 transport mode XFRM data transfer and the device is unregistered in
>> the middle of it, but we've been unable to reproduce it ourselves..
>> We're open to trying out and sharing debug patches if needed though.
>>
> 
> I double checked 5.4.61, and I didn't find any missing fixes in this
> area AFAICT.
> 
>>> rt6_uncached_list_flush_dev() actually tries to replace the inet6_dev
>>> with loopback_dev, and release the reference to the previous inet6_dev
>>> by calling in6_dev_put(), which is actually doing the same thing as
>>> ip6_dst_ifdown(). I don't understand why you say " a reference to the
>>> inet6_dev is simply dropped".
>>
>> Fair. I was going off the semantics used by the dst_dev_put() function
>> which calls dst_ops->ifdown() explicitly. At least in the case of
>> xfrm6_dst_ifdown() this swap of the loopback device and putting the
>> refcount seems like it could be missing a few things.
>>
> 
> Looking more into the xfrm code, I think the major difference between
> xfrm dst and non-xfrm dst is that, xfrm code creates a list of dst
> entries in one dst_entry linked by xfrm_dst_child().
> In xfrm_bundle_create(), which I believe is the main function to
> create xfrm dst bundles, it allocates the main dst entry and its
> children, and it calls xfrm_fill_dst() for each of them. So I think
> each dst in the list (including all the children) are added into the
> uncached_list.
> The difference between the current code in
> rt6_uncached_list_flush_dev() vs dst_ops->ifdown() is that, the
> current code only releases the refcnt to inet6_dev associated with the
> main dst, while xfrm6_dst_ifdown() tries to release inet6_dev
> associated with every dst linked by xfrm_dst_child(). However, since
> xfrm_bundle_create() anyway adds each child dst to the uncached list,
> I don't see how the current code could miss any refcnt.
> BTW, have you tried your previous proposed patch and confirmed it
> would fix the issue?
> 
>>> The additional refcount to the DST is also released by doing the
>>> following:
>>>                         if (rt_dev == dev) {
>>>                                 rt->dst.dev = blackhole_netdev;
>>>                                 dev_hold(rt->dst.dev);
>>>                                 dev_put(rt_dev);
>>>                         }
>>> Am I missing something?
>>
>> That dev_put() is on the actual netdevice struct, not the inet6_dev
>> associated with it. We're seeing many calls to icmp6_dst_alloc() and
>> xfrm6_fill_dst() here, both of which seem to associate a reference to
>> the inet6_dev struct with the DST in addition to the standard dev_hold()
>> on the netdevice during the dst_alloc()/dst_init().
>>
> 
> Could we further distinguish between dst added to the uncached list by
> icmp6_dst_alloc() and xfrm6_fill_dst(), and confirm which ones are the
> ones leaking reference?
> I suspect it would be the xfrm ones, but I think it is worth verifying.
> 

Finally found the reference:

tools/testing/selftests/net/l2tp.sh at one point was triggering a
refcount leak:

https://lore.kernel.org/netdev/20190801235421.8344-1-dsahern@kernel.org/

And then Colin found more problems with it:

https://lore.kernel.org/netdev/450f5abb-5fe8-158d-d267-4334e15f8e58@canonical.com/


running that on a 5.8 kernel on Ubuntu 20.10 did not trigger the
problem. Neither did Ubuntu 20.04 with 5.4.0-51-generic.

Can you run it on your 5.4 version and see?
