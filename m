Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73649F34B5
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbfKGQhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:37:10 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:34034 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfKGQhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:37:10 -0500
Received: by mail-il1-f193.google.com with SMTP id p6so2396045ilp.1
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fbxt9+Q0Dd5QJ+emDAStoI6XfnHtpyiX9FQANUbLngw=;
        b=VSw4UOqqNohrKM+RdptAvY/iTag4PG7I7QVHbEIEboYRok7HOF12t9F0+OhV0H9ChT
         PhM6m1zFmB1pi0CZXprdHmMOao44IvdeTXZR3ZqMoL77kmHzoGtxG9zp8F7en5pAuSRr
         CiOhDZogMSwR0UWnX8YkwBwQVV+a7CD6zYYfxgWOwcgJbbnevCJbecEM5EXvXEdX1iSM
         msEq3Hf/aEvxerOXC4WYMEPA282yByMsNNqN5PUMyvEVpvegjanpRb6MTBmaZ5k2UisN
         J3KZCazMHCa1EWW9cwp2XoaalQkiJaw6g5TVFC5KyLcr8z0l19YXownPm5sAA7YXFQj+
         H66Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fbxt9+Q0Dd5QJ+emDAStoI6XfnHtpyiX9FQANUbLngw=;
        b=QzcckxbkwvqUpDOIZailZVd6V3s0X4hMQj2LDoyJyeA6G3njlAWh1BCT/TYrU9Zs4i
         NRcfKXAvVdPKqumRhCpYbGGib4TsbIG6UUeQ4Pjq2+8LCGbvFgyloMqDJRqjGhleJLW0
         jJ2jMOd60+GeAwUNP9qr+2XiwINk17R91nXerA33+jIhbFo2TvzodgM0fl2CoxdWdw09
         NCmE2CGG6GZ6W6Kmt5QT9QXe0ApzjovNyL6ntR5va1yN1SSs2A0FnpCmCXXzIzDlTv4J
         8tZDfvDzIyldfM9lYO2b+WvPJKoJbu32XZt5uhrbrErPIEUNZzCp0GZEIy5Nezomgmcn
         jDoA==
X-Gm-Message-State: APjAAAXItxyUsUGC8rqJBYEydt/nfIlIBdOP1Nbc2RgTuTRP+7iB3F9r
        EM5BQEc7qC9QX+QCqrvwtaU=
X-Google-Smtp-Source: APXvYqxYSzmh6UWsNderExb+gZgiD5EqLHN/QJkUQBd6ef4x1UBQ64HbQY/2iPnTe3rUtR88+TG9/A==
X-Received: by 2002:a92:8498:: with SMTP id y24mr5400705ilk.89.1573144629714;
        Thu, 07 Nov 2019 08:37:09 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:48b9:89c9:cd6f:19d4])
        by smtp.googlemail.com with ESMTPSA id b6sm196692ioc.79.2019.11.07.08.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 08:37:08 -0800 (PST)
Subject: Re: [PATCH net] ipv6: fixes rt6_probe() and fib6_nh->last_probe init
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20191107024509.87121-1-edumazet@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <094aedc7-3303-7f27-25eb-a32523faa5b7@gmail.com>
Date:   Thu, 7 Nov 2019 09:37:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191107024509.87121-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/19 7:45 PM, Eric Dumazet wrote:
> While looking at a syzbot KCSAN report [1], I found multiple
> issues in this code :
> 
> 1) fib6_nh->last_probe has an initial value of 0.
> 
>    While probably okay on 64bit kernels, this causes an issue
>    on 32bit kernels since the time_after(jiffies, 0 + interval)
>    might be false ~24 days after boot (for HZ=1000)
> 
> 2) The data-race found by KCSAN
>    I could use READ_ONCE() and WRITE_ONCE(), but we also can
>    take the opportunity of not piling-up too many rt6_probe_deferred()
>    works by using instead cmpxchg() so that only one cpu wins the race.
> 

...

> Fixes: cc3a86c802f0 ("ipv6: Change rt6_probe to take a fib6_nh")

That commit only moves the location of last_probe, from fib6_info into
fib6_nh. Given that I would expect the same problem to exist with the
previous code. Agree? Point being should this be backported to older
stable releases since said commit is new to 5.2?

