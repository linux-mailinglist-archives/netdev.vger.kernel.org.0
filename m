Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCBC0F34F9
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbfKGQur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:50:47 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45818 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKGQuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:50:46 -0500
Received: by mail-io1-f68.google.com with SMTP id v17so1951210iol.12
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8pJsE2kS9TsEP1oqy6OGfrcIbIwIayjG3PTseSDa1tc=;
        b=e0d4ENHB34RA1N4Xnx2GovISvWAHMMER/vPg9FD4kEPHvV07zp2qV76FkSG/hUXQdJ
         w0QyuICXs/LxlfiGgB4ent35VgyEY68dWH3sIJNo0txEViTQF4bEgWAJCfQTGNBLepCn
         LRsdKDe7vkZZ3iZkZ2pDKLXJMgp8K8oWx/GLaoDdrbaIbGtlXHco8nDLoci93xKoTg3r
         vXrGj9qFIuO68x9ZK8R3QkQc+WfRtC9izZNQ38E/4tX/VuPEa1YvK2G/qdcTYjknr9r9
         jDeiMIwnQE5sx/nXCZ2HGJRVv5Zgf3gJP+OsvLYh+1uJkDtzoY+mWvd24pWfRghFSvHz
         iTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8pJsE2kS9TsEP1oqy6OGfrcIbIwIayjG3PTseSDa1tc=;
        b=IbE2ZljgKxaMt06v/xvImHjkmNxQJy0ASNvA5KZcs/cEiYI+sLaH6YoBT0NEKdlWYb
         tSX+/FWvATZCc9k+rInlFNDbG+dzxFzj/fBfS+8uQKykuZAWnYEjOd6t9t/oAiCmLuDs
         0Z9ujtSjVjfMK4M4qpeJZKMoHsOvHH8BcQ3G0ohZzJ1Vuj3pXhwBTmuB17EO1+BFjuML
         2y6ZOrNxskUQtCtADmlSphszjd6phNvesenG8sCKXQ2kRhm+ak6mEvUO5nsiX6X2jY2f
         gSuuQq3RTsqUuWx9SBy4Ycy+Rwh+a3BV5eRAYffWAHYAPhsqWjWHB7rgkkpZRykZhGbU
         AFfQ==
X-Gm-Message-State: APjAAAVfTYe1rW18rd/M7fGgiyuKcq44D0KBICGXL2HDnMiVDByzna2x
        UthIzKsBq8fJEk3j5y6ygfg=
X-Google-Smtp-Source: APXvYqyxcwkLEi5xeo8kDrED8vgNqcGT7JyX0mPw36Shr/7SOqTik3GJPboXjbdQZ5mK7sPa1/yJgw==
X-Received: by 2002:a02:1948:: with SMTP id b69mr5044101jab.30.1573145445948;
        Thu, 07 Nov 2019 08:50:45 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:48b9:89c9:cd6f:19d4])
        by smtp.googlemail.com with ESMTPSA id v28sm383587ill.74.2019.11.07.08.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 08:50:45 -0800 (PST)
Subject: Re: [PATCH net] ipv6: fixes rt6_probe() and fib6_nh->last_probe init
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20191107024509.87121-1-edumazet@google.com>
 <094aedc7-3303-7f27-25eb-a32523faa5b7@gmail.com>
 <CANn89iJbwZ9TqC_ry2O9QCzp3SJtUcXept_SkKY=DEMTP61zwg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <aa337d1c-28cb-6e63-6603-f9d54b51d2c9@gmail.com>
Date:   Thu, 7 Nov 2019 09:50:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CANn89iJbwZ9TqC_ry2O9QCzp3SJtUcXept_SkKY=DEMTP61zwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/19 9:45 AM, Eric Dumazet wrote:
> On Thu, Nov 7, 2019 at 8:37 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 11/6/19 7:45 PM, Eric Dumazet wrote:
>>> While looking at a syzbot KCSAN report [1], I found multiple
>>> issues in this code :
>>>
>>> 1) fib6_nh->last_probe has an initial value of 0.
>>>
>>>    While probably okay on 64bit kernels, this causes an issue
>>>    on 32bit kernels since the time_after(jiffies, 0 + interval)
>>>    might be false ~24 days after boot (for HZ=1000)
>>>
>>> 2) The data-race found by KCSAN
>>>    I could use READ_ONCE() and WRITE_ONCE(), but we also can
>>>    take the opportunity of not piling-up too many rt6_probe_deferred()
>>>    works by using instead cmpxchg() so that only one cpu wins the race.
>>>
>>
>> ...
>>
>>> Fixes: cc3a86c802f0 ("ipv6: Change rt6_probe to take a fib6_nh")
>>
>> That commit only moves the location of last_probe, from fib6_info into
>> fib6_nh. Given that I would expect the same problem to exist with the
>> previous code. Agree? Point being should this be backported to older
>> stable releases since said commit is new to 5.2?
> 
> Yes, the commit adding last probe went in 4.19
> 
> Fixes: f547fac624be ("ipv6: rate-limit probes for neighbourless routes")
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
