Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1C8911F1
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 18:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfHQQ0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 12:26:46 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32902 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbfHQQ0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 12:26:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id p77so5240504wme.0
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 09:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CVSENXFHSp/QDVNj+aZZD32VbLeXr6l59st3bGQHu0Y=;
        b=DuhOOtaihMdKw/gmyqB5kKUfWvVAU+NL5eijKH7n8OQYAaoM9cat5kHZmCRbCznJNB
         rb7+0mUujqrLuoumdA6g6Ms4LlUZFnCuMJx+ZK6C5Tl8qIWoQKlXA3cQvzHzogMuP8sa
         vwPLNL5v5YyToRJ1OMUlr7/4zoz5mwTVmO4K2choOF9xFnEZTt1QtbdCl57hFiYLMDJF
         N+1Lzj7hs4BTnH3nEqoSMbSKOy0Xv3pBvXmzMPih0+LhlD1QyPWF4C5LwSc4lHl1d4iW
         Mg7e2EQ5VvmDs1AEcM4/ZPw6eAdEcyI9IJFUHsFCWgMMIPyl4eMiD4wqFX6KbGHkrrr2
         FtFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CVSENXFHSp/QDVNj+aZZD32VbLeXr6l59st3bGQHu0Y=;
        b=q0p/uNnLmJcPtdVttnLTGORhAf3KlqIvIRmyyupL7KPHas0L598xwVQUjrgJD7ob9y
         tjhfYz6tv/r83ydBsR06yX5SYc6Vpug37Ng5cS9YlXtqv1EhzL7uCrA8hIWHB8opyyXp
         0BVWz++FeSkk/e51TmahBD3EUenvJhYRuPO37mvp3zbGMHfrLZiS1iiOTp3DG8egE8s6
         RX/XB5VaP7opDbc7T6E7mttS3pLgqd43fgYpxH2LtMgeVj4n4ox9iYUxBTyqUbdhiqXu
         QV2mz1Gqe1d5ecjnLfvSwKmhVnjS/dnbY7O1DHDxsrenP452oeeKXbLGbCVnOzYh7DBq
         P4Yg==
X-Gm-Message-State: APjAAAUOCb9CY5DngMAjdrRQHLvWGlaUODfbFZEAbH1p88eoyWL1G4X2
        xqp6qP3QevT1C/+daeajCAU=
X-Google-Smtp-Source: APXvYqzcOoA++F3gFxQarBrFsfsfopHjrBzwlRW8TZ38t3a6AQpz8seDzMx76CqFLWfffh4g1PsV3w==
X-Received: by 2002:a1c:c78d:: with SMTP id x135mr12217859wmf.82.1566059204227;
        Sat, 17 Aug 2019 09:26:44 -0700 (PDT)
Received: from [192.168.8.147] (129.171.185.81.rev.sfr.net. [81.185.171.129])
        by smtp.gmail.com with ESMTPSA id s64sm17572510wmf.16.2019.08.17.09.26.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 09:26:42 -0700 (PDT)
Subject: Re: [PATCH net] tcp: make sure EPOLLOUT wont be missed
To:     Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vladimir Rutsky <rutsky@google.com>
References: <20190817042622.91497-1-edumazet@google.com>
 <b9ab6b03-664c-eb81-0fbd-6f696276d9aa@akamai.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c31d7c04-9d6f-aefb-500e-5b9b635ff221@gmail.com>
Date:   Sat, 17 Aug 2019 18:26:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <b9ab6b03-664c-eb81-0fbd-6f696276d9aa@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/19 4:19 PM, Jason Baron wrote:
> 
> 
> On 8/17/19 12:26 AM, Eric Dumazet wrote:
>> As Jason Baron explained in commit 790ba4566c1a ("tcp: set SOCK_NOSPACE
>> under memory pressure"), it is crucial we properly set SOCK_NOSPACE
>> when needed.
>>
>> However, Jason patch had a bug, because the 'nonblocking' status
>> as far as sk_stream_wait_memory() is concerned is governed
>> by MSG_DONTWAIT flag passed at sendmsg() time :
>>
>>     long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
>>
>> So it is very possible that tcp sendmsg() calls sk_stream_wait_memory(),
>> and that sk_stream_wait_memory() returns -EAGAIN with SOCK_NOSPACE
>> cleared, if sk->sk_sndtimeo has been set to a small (but not zero)
>> value.
> 
> Is MSG_DONTWAIT not set in this case? The original patch was intended
> only for the explicit non-blocking case. The epoll manpage says:
> "EPOLLET flag should use nonblocking file descriptors". So the original
> intention was not to impact the blocking case. This seems to me like
> a different use-case.
>

I guess the problem is how we define 'non-blocking' ...

SO_SNDTIMEO can be used by application to implement a variation of non-blocking,
by waiting for a socket event with a short timeout, to maybe recover
from memory pressure conditions in a more efficient way than simply looping.

Note that the man page for epoll() only _suggests_ to use nonblocking file descriptors.

<quote>
       The  suggested  way  to use epoll as an edge-triggered (EPOLLET)
       interface is as follows:

              i   with nonblocking file descriptors; and

              ii  by  waiting  for  an  event  only  after  read(2)  or
                  write(2) return EAGAIN.
</quote>








