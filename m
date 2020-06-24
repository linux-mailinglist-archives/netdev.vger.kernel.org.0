Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70623207149
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390450AbgFXKez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388005AbgFXKex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:34:53 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D770C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 03:34:53 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g20so889211edm.4
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 03:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D58gnDob/9VjS9eldnd+//oSXEmdQdEZ7l2Xqb1y+GQ=;
        b=ew5DR34zDxw2QPCXqbhVUZAmQxXDAlgRX6NOclxN82WUYabFoiBwmTJIVzGN6IcxyQ
         FuW+3y2M7R1MjoqUoCUdbeopZhiWsNYaGgoGSrJ7aCJwW0MmrNM18WQKhf0GlyPzLJAZ
         O0ErXD5nP1LDt1jOR2YjndiJEtULtAcrQ1/zZ+HuCEBo5QOfEh6gbLcrSekzDEYzlt9F
         DnmV+ywZZ0f4p2rRz826ler4N/VoHrIMxOakozaDyAQpBpabNH4trldkrm8utvvzhfeR
         /2q1XetVb6+7opdtGppZy9bKfRnyZ6cQmI6FmQJghzZMz1EeNgPb59uX+T3Ob9ACffHB
         Qn7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D58gnDob/9VjS9eldnd+//oSXEmdQdEZ7l2Xqb1y+GQ=;
        b=CuX8BecsiVzzkA1xhw2xA69zkmd+wf4q7nhdyTX//RDiUWc/C1lFWNE9iGxc0RhT2k
         j48k/iyQ/1ZVAuHZz3kF0u060fCbP+XcwC6s1m5EeLlLY95tYtSUIwNVdsgyJK+iOe0k
         GugnP8E2vBQu6sn6Ih0WjVh9LammM4SMenb8eYKP+Pc+VkCTXsv3cPjkM5SmhnZeLJev
         wogWa+C92tMwiCc5ioSobl7kxW15tPPSgT+yX6MSoF3VdI8oSEjJ8ezMDpWUKPs17Ey3
         BObEC+j6q5U+8H4l9yCMvelVnUXRlwWJ5KZnks2JhHxdJSgasx+6Dr65ty59tMDcS7Pe
         z0Vg==
X-Gm-Message-State: AOAM532p4zbM3MurMZKyxLmMS9b8njl4M/DiMBOojmJqfFybIZPCgCw3
        Or92zwTwZouyZN/Hym4DEUs=
X-Google-Smtp-Source: ABdhPJxPLyo4BmwD83Tk2DlVsN6G60zyYvvDFiuSmlx/moWEQbLzsbbU4zNVK9s5UCuVB3mVadNtBg==
X-Received: by 2002:aa7:d74c:: with SMTP id a12mr26407425eds.369.1592994891725;
        Wed, 24 Jun 2020 03:34:51 -0700 (PDT)
Received: from ?IPv6:2a0f:6480:3:1:e96f:c7f:ef7f:cae1? ([2a0f:6480:3:1:e96f:c7f:ef7f:cae1])
        by smtp.gmail.com with ESMTPSA id i9sm15216738ejv.44.2020.06.24.03.34.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 03:34:51 -0700 (PDT)
Subject: Re: [PATCH] IPv6: Fix CPU contention on FIB6 GC
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20200622205355.GA869719@tws>
 <32da6a56-0217-acda-c12c-49f7c74275ef@gmail.com>
 <3230b95a-1ce0-b569-3d00-f7063ae9f1d9@gmail.com>
 <20200623220650.kymq7vbqiogvnsj3@lion.mk-sys.cz>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <5be2063d-2433-54af-194d-fd4628974f29@gmail.com>
Date:   Wed, 24 Jun 2020 12:34:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623220650.kymq7vbqiogvnsj3@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.06.20 00:06, Michal Kubecek wrote:
> On Tue, Jun 23, 2020 at 01:30:29AM +0200, Oliver Herms wrote:
>>
>> I'm encountering the issues due to cache entries that are created by 
>> tnl_update_pmtu. However, I'm going to address that issue in another thread
>> and patch.
>>
>> As entries in the cache can be caused on many ways this should be fixed on the GC
>> level.
> 
> Actually, not so many as starting with (IIRC) 4.2, IPv6 routing cache is
> only used for exceptions (like PMTU), not for regular lookup results.
> 

Hi Michal,

Right. That is the intention. But reality is, that when sending IPv6 with an 
MPLS encap route into a SIT/FOU tunnel, a cache entry is being created for every single
destination on the tunnel. Now that IS a bug by itself and I'll shortly submit a 
patch that should fix that issue.

However, when a tunnel uses PMTU, and a tunnel source received an ICMP packet too big
for the tunnel destination, that triggers creation of IPv6 route cache entries
(and for IPv4 entries in the corresponding data structure) for every destination for which
packets are sent through the tunnel.

Both these attributes,
1. the presence or absence of, maybe spoofed, ICMP packet too big messages for the tunnel
2. the number of flows through a tunnel (attackers could just create more flows)
are not fully under control by an operator.

Thus the assumption that if only max_size would be big enough, it would solve the problem, 
it not correct.

Regarding your argument making the limit "softer":
There is only 2 functions that use/lock fib6_gc_lock:
1. fib6_net_init
2. fib6_run_gc 

fib6_net_init is only called when the network namespace is initialized.

fib6_run_gc clears all entries that are subject to garbage collection.
There is no gain in doing that N times (with N = amount of CPUs) and spinlocking all CPUs. 
Cleaning once is enough. A GC run is so short, that by the time the GC run is finished, 
there's most probably no new entry in the cache that is ready to be removed.
And even if there is. The next call to ip6_dst_gc will happen when a new entry
is added to the cache. Thus I can't see how my patch makes time limit softer.

Kind Regards
Oliver
