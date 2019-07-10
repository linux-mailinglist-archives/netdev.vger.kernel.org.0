Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0B964C10
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfGJS2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:28:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40166 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbfGJS2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:28:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so3492009wrl.7
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v33Ah81f8LPy5DE3n1JaAu2WPBHstNxMONaHIkkt6fs=;
        b=UFHUyLuJnksUaHZcLjS2mFyOHj1YVvCe5mABYLXBjeVBh8k7hs5l9nPxJWQl3feWWY
         VGQzdTyuNzagbQ+GowLjIKpIb8KyqqFysZz9WT0pyDkFPzKu7/fEiQFJiZKxPR2vzbSg
         tlo2K4aOQGKom1l4CySrQE4Crssw4Q1rPn4+lOwePx+kQGi//AjgbexMHZ+WS/T/zNu0
         9pIu/5M+6x3z4cblfVRhlipGY6qGzF0VVxIChxgHkXbErekPUSBgkLhRl7SO14h0YJO2
         KigEkGIQeS1Pq2C5GbfZMOXQlZQnZ9GQSR34trpY0Rqzqtl+oRxkRjTjtj8DSsztbVxd
         Ru0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v33Ah81f8LPy5DE3n1JaAu2WPBHstNxMONaHIkkt6fs=;
        b=HSb2WVPq2f17KbMQqI+4Nfunz7hPdK2B03KEjtCBQyo5lslzj3C7uleOgkPOcoptrC
         kSqTy/lU53iD8Ch5S3VFDASa6MmKlL4zezbnEhqqQmF4uWnqfXD5yD1nAb5D/Gybhomq
         WvuF9wWnGsYv8agOaErVRZlXCPq7sWWJIDyWE0GhA6GG0aOdg4L1cyM7oqsoPgJjSqX4
         DSTKKt+R+GanuK1xNxoUWvRqtPpp+gNCwj0wpbNaNdzhW4s5RnnChJ9RB/KXBtIsPvDS
         TXUGF6vlUGbVCTQ3GqVG7xLbzbpQIU2s75cdDA43EX8NTxctBWggH6PZ11J8dD44P3Kr
         urmQ==
X-Gm-Message-State: APjAAAU9BY3pOyO3AzDnXO+SBcJb/HSNibjf3mpIBLL1gfSuY8YcDejt
        8aQvLJ8rYSPCtqlip3CyodwPmzjN
X-Google-Smtp-Source: APXvYqw3QRFcrSb5B2iy+eKzVKiryjk5ub4uTsMqhoHwtF5VII0fJ1kuDNgcMsfRChD7ncjVWYkwzw==
X-Received: by 2002:adf:c594:: with SMTP id m20mr6664555wrg.126.1562783324365;
        Wed, 10 Jul 2019 11:28:44 -0700 (PDT)
Received: from [192.168.8.147] (31.172.185.81.rev.sfr.net. [81.185.172.31])
        by smtp.gmail.com with ESMTPSA id h6sm2062966wre.82.2019.07.10.11.28.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 11:28:43 -0700 (PDT)
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
To:     "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>,
        Christoph Paasch <christoph.paasch@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
Date:   Wed, 10 Jul 2019 20:28:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/19 8:23 PM, Prout, Andrew - LLSC - MITLL wrote:
> On 6/17/19 8:19 PM, Christoph Paasch wrote:
>>
>> Yes, this does the trick for my packetdrill-test.
>>
>> I wonder, is there a way we could end up in a situation where we can't
>> retransmit anymore?
>> For example, sk_wmem_queued has grown so much that the new test fails.
>> Then, if we legitimately need to fragment in __tcp_retransmit_skb() we
>> won't be able to do so. So we will never retransmit. And if no ACK
>> comes back in to make some room we are stuck, no?
> 
> We seem to be having exactly this problem. We’re running on the 4.14 branch. After recently updating our kernel, we’ve been having a problem with TCP connections stalling / dying off without disconnecting. They're stuck and never recover.
> 
> I bisected the problem to 4.14.127 commit 9daf226ff92679d09aeca1b5c1240e3607153336 (commit f070ef2ac66716357066b683fb0baf55f8191a2e upstream): tcp: tcp_fragment() should apply sane memory limits. That lead me to this thread.
> 
> Our environment is a supercomputing center: lots of servers interconnected with a non-blocking 10Gbit ethernet network. We’ve zeroed in on the problem in two situations: remote users on VPN accessing large files via samba and compute jobs using Intel MPI over TCP/IP/ethernet. It certainly affects other situations, many of our workloads have been unstable since this patch went into production, but those are the two we clearly identified as they fail reliably every time. We had to take the system down for unscheduled maintenance to roll back to an older kernel.
> 
> The TCPWqueueTooBig count is incrementing when the problem occurs.
> 
> Using ftrace/trace-cmd on an affected process, it appears the call stack is:
> run_timer_softirq
> expire_timers
> call_timer_fn
> tcp_write_timer
> tcp_write_timer_handler
> tcp_retransmit_timer
> tcp_retransmit_skb
> __tcp_retransmit_skb
> tcp_fragment
> 
> Andrew Prout
> MIT Lincoln Laboratory Supercomputing Center
> 

What was the kernel version you used exactly ?

This problem is supposed to be fixed in v4.14.131

