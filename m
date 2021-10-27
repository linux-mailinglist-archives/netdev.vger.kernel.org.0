Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA8A43D300
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238832AbhJ0Ukv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbhJ0Ukv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:40:51 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751F9C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:38:25 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id c4so4100065pgv.11
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dzLIgVaYVlvkEAqXgda1BDsPtLpNVxBV6/rhzPHY2KI=;
        b=Fpnjgk4YMox/jrMi6hDBFiT7HJ/qxnWj5sOLq1w3jsTSQbR9T8tcmKQOBYmPYztsat
         q30YwwCkWe/Xy6zH5xt34n3suWe5GPslfjnIRn+2y9hcZHFpTsWCcPOVVxDOCP9WPfa7
         nUhqr+AJA1Ifq4FaLZ630OfaxZHFN0GJED82xMU4L/XqCpI+IXSS5/20KfOsqcJQI6Pl
         bYIj61ysnO1Urpvic496WMfBQy6wvT1rQYYhKljJ17Vv+knw3KtxGiMf04sNOvSB6xfX
         x1TLs+3TPUx7PQFPP+HXu19+1CZAXen6WtAqqeARcs0vQgzjugQDic7zFECiItXAV1jx
         WQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dzLIgVaYVlvkEAqXgda1BDsPtLpNVxBV6/rhzPHY2KI=;
        b=Guty3EnH/DOaWZtQBrXXNh2YScqwMdu4C/HS6byV7nzSCPSttQ83tQbYPcr4rk5Lp8
         FGszvIZWrU6vIpk+4V9D4ucrnGnjhTGZ3ADaYDxRdwqXnc9QX57/hOWdz5TXsnDuaRHH
         p5jzoML9rxXSYmYSXlZSHLxLhyCYO5uu9+ZSZEFR4UH0BWYYX9tjJIDRWZ3VE7vbYyEu
         46lIQS4wyEov2qZwKPQQZEza3I7QCtvwJW75iCLNLAyTy//V/7mTdM56Os/BrToJ9PIE
         JFN2a/uqq0mO/aaw5wbP9rTM4J1lcmdemnJ+UcKgrxJsE2wIzdXGvIr5dpegPjJ+fnn0
         rqyQ==
X-Gm-Message-State: AOAM531Vrdibq88Z3i8uz3I1f+dXP1Qt6C0ksdp6MvP7nEJeOf73fUre
        d5ETc9FntgNyeKceHEbMUI1gNj+Yh4U=
X-Google-Smtp-Source: ABdhPJzQ93zreF/zP4NFglSFlTuhqdfdXwR1dhl5rRfPYlE4zXOaW1RxZZuoYMi/HtP9qpXs3vHKzw==
X-Received: by 2002:a63:3c50:: with SMTP id i16mr25152pgn.304.1635367105093;
        Wed, 27 Oct 2021 13:38:25 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id v12sm5198395pju.32.2021.10.27.13.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 13:38:24 -0700 (PDT)
Subject: Re: [PATCH net-next v3 04/17] mptcp: Add handling of outgoing MP_JOIN
 requests
To:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
References: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
 <20200327214853.140669-5-mathew.j.martineau@linux.intel.com>
 <bbbc234b-c597-7294-f044-d90317c6798d@gmail.com>
 <a0c568ca298714e04da75c879f28cb6e3836d813.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4439b5b8-f737-2a3d-be24-b10aa2214aca@gmail.com>
Date:   Wed, 27 Oct 2021 13:38:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a0c568ca298714e04da75c879f28cb6e3836d813.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/27/21 1:45 AM, Paolo Abeni wrote:
> On Tue, 2021-10-26 at 17:54 -0700, Eric Dumazet wrote:
>>

>>
>> What about this fix ?
>>
>> diff --git a/net/mptcp/options.c b/net/mptcp/options.c
>> index 422f4acfb3e6d6d41f6f5f820828eaa40ffaa6b9..9f5edcf562c9f98539256074b8f587c0a64a8693 100644
>> --- a/net/mptcp/options.c
>> +++ b/net/mptcp/options.c
>> @@ -434,12 +434,13 @@ static void schedule_3rdack_retransmission(struct sock *sk)
>>  
>>         /* reschedule with a timeout above RTT, as we must look only for drop */
>>         if (tp->srtt_us)
>> -               timeout = tp->srtt_us << 1;
>> +               timeout = usecs_to_jiffies(tp->srtt_us >> (3-1));
>>         else
>>                 timeout = TCP_TIMEOUT_INIT;
>>  
>>         WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
>>         icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
>> +       timeout += jiffies;
>>         icsk->icsk_ack.timeout = timeout;
>>         sk_reset_timer(sk, &icsk->icsk_delack_timer, timeout);
>>  }
> 
> Thanks Eric for catching this! We need better packetdrill coverage
> here. I would be courious to learn how did you get it? 
> 

I found this because I am evaluating converting the delack timer
to hrtimer for TCP.

Kind of extending the ack compression schem I added for SACK,
but for pure ACKS.

Reducing ACK rate is key to performance, especially for drivers not using GRO.

So I was looking at all uses of icsk_delack_timer in the stack,
seeing how much work I would have to do.


> The patch LGTM, would you formally submit it, or do you prefer we cope
> with the process?
> 
> Thanks!
> 
> Paolo
> 
