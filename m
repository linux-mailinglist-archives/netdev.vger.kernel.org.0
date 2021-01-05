Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2D92EA494
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 05:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbhAEE6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 23:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbhAEE6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 23:58:44 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8C9C061793
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 20:58:03 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id f132so34716535oib.12
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 20:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AlUH6PSCxbCX+fmSSUYKDVglU6JQzxbNY5f2fpy1cbM=;
        b=T2OGZ/n3GepPqxvvkGHNM94fmKezqBiUXRp5VUeyVW6hQ1LlmLvQ+xmtyIzEfpMOr8
         aaMqN178oXgXyzyaOWm0f1lJ0o6j4nBQb6OCGvgrEOaBMXt8WbyUaoJKovWkquXdJTi5
         swWSWQpTzbKCOrviI7RVphu/Wa0ZpKAwufAGGnj65l/yTs6adK0+5WT0U/X8VDeLQiRS
         iIIfA9xY+Cb1m+xItXi9aGjtbBKAoy1Hbo6+w33HXHSFQY35milG4ZztoKQud7au3y0J
         L48hrRgEFcFonQAXzV+r+E1A4spE0wtbpBHQ2ePujjwro7pXBZ5ZKeqxqDi+NSw7OTs8
         Ucdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AlUH6PSCxbCX+fmSSUYKDVglU6JQzxbNY5f2fpy1cbM=;
        b=RVXR8ptDclnQ/+E/LwASfOCD+SFNU6OiXrNRoJW6zAIaieBtCT6lJ1loQ2MTGBQpjm
         T8LC0E7VtfJINUW2tMVHUGhvRRZ/KgAHfUHBUMWVHLItA52b53KzeS2wD5RMCybc9jvM
         SG0381LC6Q840YCMyMKZ/KDI/paIAbEg0Eowag5mHs3nQb+oRiixXJDrIITQiBuF3Qj8
         cfuE7G5FJc5JySP4UpxMKiuX0WxjXUiq+l+/e+fREiferiE+Af73n7pDKSV/JFfSLpan
         Ea5KSMf69iAwPqsWlW7FQO8Jk7gSuwe2O9tzuEByY1S2GWZlQOQRUvjg/PYcca3E8AsX
         MHGw==
X-Gm-Message-State: AOAM533ShmFF35GKiI0MdIWU/obTYKmZCeN5q3goIYWyS5FCV3cVAxBE
        3hP8MDj4u30mUZn8ZuXC438=
X-Google-Smtp-Source: ABdhPJyNeDhm6ICwBGjAP4fQkiqsoi7Gji+me7fip5nNEwpMbAyko7FD78BvUCBGKqbAv5mUlblifg==
X-Received: by 2002:a05:6808:199:: with SMTP id w25mr1520535oic.151.1609822683442;
        Mon, 04 Jan 2021 20:58:03 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:e074:7fa1:391b:b88d])
        by smtp.googlemail.com with ESMTPSA id w5sm13267032oow.7.2021.01.04.20.58.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 20:58:02 -0800 (PST)
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
To:     stranche@codeaurora.org
Cc:     Wei Wang <weiwan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
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
 <f10c733a-09f8-2c72-c333-41f9d53e1498@gmail.com>
 <6a314f7da0f41c899926d9e7ba996337@codeaurora.org>
 <839f0ad6-83c1-1df6-c34d-b844c52ba771@gmail.com>
 <9f25d75823a73c6f0f556f0905f931d1@codeaurora.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5905440c-163a-d13e-933e-c9273445a6ed@gmail.com>
Date:   Mon, 4 Jan 2021 21:58:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9f25d75823a73c6f0f556f0905f931d1@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/21 8:05 PM, stranche@codeaurora.org wrote:
> 
> We're able to reproduce the refcount mismatch after some experimentation
> as well.
> Essentially, it consists of
> 1) adding a default route (ip -6 route add dev XXX default)
> 2) forcing the creation of an exception route via manually injecting an
> ICMPv6
> Packet Too Big into the device.
> 3) Replace the default route (ip -6 route change dev XXX default)
> 4) Delete the device. (ip link del XXX)
> 
> After adding a call to flush out the exception cache for the route, the
> mismatch
> is no longer seen:
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 7a0c877..95e4310 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -1215,6 +1215,7 @@ static int fib6_add_rt2node(struct fib6_node *fn,
> struct fib6_info *rt,
>                 }
>                 nsiblings = iter->fib6_nsiblings;
>                 iter->fib6_node = NULL;
> +               rt6_flush_exceptions(iter);
>                 fib6_purge_rt(iter, fn, info->nl_net);
>                 if (rcu_access_pointer(fn->rr_ptr) == iter)
>                         fn->rr_ptr = NULL;

Ah, I see now. rt6_flush_exceptions is called by fib6_del_route, but
that won't handle replace.

If you look at fib6_purge_rt it already has a call to remove pcpu
entries. This call to flush exceptions should go there and the existing
one in fib6_del_route can be removed.

Also, can you add the reproducer as another test case to
tools/testing/selftests/net/pmtu.sh? We definitely need one for this
sequence (route, exceptions, replace route).
