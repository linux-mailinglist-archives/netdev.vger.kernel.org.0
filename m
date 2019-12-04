Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF1F112158
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 03:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfLDCU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 21:20:28 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43214 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfLDCU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 21:20:27 -0500
Received: by mail-pl1-f195.google.com with SMTP id q16so2465872plr.10
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 18:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e0Hc3M00YYLfDrn2zHyhOuMtbWm4AU9KT8BmLgOCglk=;
        b=PZ+idJAXMQYJHIgsrYT5DQoZJJc5mNZB29gXz2hhu9g+4iHAxWoPRLx/9EJrXAVL3o
         WFLrR04586dlmZqZDn/VOYl5GVidnJYkkMbmTlddnurDsHlP86EjVXYtSy8HDzcq66Z+
         WYfxS4faaP35Toa23szIaptwGMmUkkJsAf5TDGsEgudSMcbZJxE9tb34lXUzLnbD1s4r
         LtsuZOWF7cWnztFIgxxlD8ozK0+D2zKqLufZ9eiJIG4UIoGH+RTQp+wgpdeuC48yMMpY
         k26fQ4RywUWzDLMvnOXbvMdb9bvI4k5thU76atQxUIv4XWl2mpxbQJRVNs1wJZBWX2FN
         dCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e0Hc3M00YYLfDrn2zHyhOuMtbWm4AU9KT8BmLgOCglk=;
        b=oXJm/pp5RN+T2cd2VBJQM80kMTCR4Mug/DSyW1lUSqpIt2X1lCQNfNW4/Uoy0H51bv
         caZErbAFtqTFlCXmfTqRyMrGnPrBaKJ48DK7AtvvFYHEur/ohiqb3+/lMTq1pxrKkiE2
         ykjgl2w3uYzaPNvsAmzaOsEEkCb5z0IbphHkbePgIuYq4ZsW/QR7+nDzkeuAgJY3GaSw
         HpViC5N2ktPRSM/PRKWt7IxEYTitXbtmY9QZvV0mpTsLoT4BB1SEpyVap5AV6XTMjGB7
         3di8wcSeI2A29JmfghYrkSYx9mEhY0NSGRj1Iq+C8GwqJ4Anvw/JgrugQ7yAUINYf+7D
         dRog==
X-Gm-Message-State: APjAAAVQWJqKIWfKcj4/dUC5DgNhifP9OGIpWPGXcF3LQIjGmkzwHcJb
        X8f2x+nWKgv4JEgpNfWDU2E=
X-Google-Smtp-Source: APXvYqxJ11XIjAXzjzZxQWjZ02HV26nYSzPUpMd8i3gBGe6+tJ2c/QYm95Fgl27Tkw4Z46l1hZth/A==
X-Received: by 2002:a17:90a:218c:: with SMTP id q12mr790515pjc.0.1575426026750;
        Tue, 03 Dec 2019 18:20:26 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 129sm5510772pfw.71.2019.12.03.18.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 18:20:25 -0800 (PST)
Subject: Re: [PATCH net] tcp: Avoid time_after32() underflow when handling
 syncookies
To:     Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
References: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
 <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com>
 <20191202215143.GA13231@linux.home>
 <CANn89i+k3+NN8=5fD9RN4BnPT5dei=iKJaps_0vmcMNQwC58mw@mail.gmail.com>
 <20191204004654.GA22999@linux.home>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d6b6e3c4-cae6-6127-7bda-235a00d351ef@gmail.com>
Date:   Tue, 3 Dec 2019 18:20:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191204004654.GA22999@linux.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/19 4:46 PM, Guillaume Nault wrote:
> On Mon, Dec 02, 2019 at 02:23:35PM -0800, Eric Dumazet wrote:
>> On Mon, Dec 2, 2019 at 1:51 PM Guillaume Nault <gnault@redhat.com> wrote:
>>>
>>> On Thu, Nov 28, 2019 at 02:04:19PM -0800, Eric Dumazet wrote:
>>>> On Thu, Nov 28, 2019 at 1:36 PM Guillaume Nault <gnault@redhat.com> wrote:
>>>>>
>>>>> In tcp_synq_overflow() and tcp_synq_no_recent_overflow(), the
>>>>> time_after32() call might underflow and return the opposite of the
>>>>> expected result.
>>>>>
>>>>> This happens after socket initialisation, when ->synq_overflow_ts and
>>>>> ->rx_opt.ts_recent_stamp are still set to zero. In this case, they
>>>>> can't be compared reliably to the current value of jiffies using
>>>>> time_after32(), because jiffies may be too far apart (especially soon
>>>>> after system startup, when it's close to 2^32).
>>>>>
>>>>> In such a situation, the erroneous time_after32() result prevents
>>>>> tcp_synq_overflow() from updating ->synq_overflow_ts and
>>>>> ->rx_opt.ts_recent_stamp, so the problem remains until jiffies wraps
>>>>> and exceeds HZ.
>>>>>
>>>>> Practical consequences should be quite limited though, because the
>>>>> time_after32() call of tcp_synq_no_recent_overflow() would also
>>>>> underflow (unless jiffies wrapped since the first time_after32() call),
>>>>> thus detecting a socket overflow and triggering the syncookie
>>>>> verification anyway.
>>>>>
>>>>> Also, since commit 399040847084 ("bpf: add helper to check for a valid
>>>>> SYN cookie") and commit 70d66244317e ("bpf: add bpf_tcp_gen_syncookie
>>>>> helper"), tcp_synq_overflow() and tcp_synq_no_recent_overflow() can be
>>>>> triggered from BPF programs. Even though such programs would normally
>>>>> pair these two operations, so both underflows would compensate each
>>>>> other as described above, we'd better avoid exposing the problem
>>>>> outside of the kernel networking stack.
>>>>>
>>>>> Let's fix it by initialising ->rx_opt.ts_recent_stamp and
>>>>> ->synq_overflow_ts to a value that can be safely compared to jiffies
>>>>> using time_after32(). Use "jiffies - TCP_SYNCOOKIE_VALID - 1", to
>>>>> indicate that we're not in a socket overflow phase.
>>>>>
>>>>
>>>> A listener could be live for one year, and flip its ' I am under
>>>> synflood' status every 24 days (assuming HZ=1000)
>>>>
>>>> You only made sure the first 24 days are ok, but the problem is still there.
>>>>
>>>> We need to refresh the values, maybe in tcp_synq_no_recent_overflow()
>>>>
>>> Yes, but can't we refresh it in tcp_synq_overflow() instead? We
>>> basically always want to update the timestamp, unless it's already in
>>> the [last_overflow, last_overflow + HZ] interval:
>>>
>>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>>> index 36f195fb576a..1a3d76dafba8 100644
>>> --- a/include/net/tcp.h
>>> +++ b/include/net/tcp.h
>>> @@ -494,14 +494,16 @@ static inline void tcp_synq_overflow(const struct sock *sk)
>>>                 reuse = rcu_dereference(sk->sk_reuseport_cb);
>>>                 if (likely(reuse)) {
>>>                         last_overflow = READ_ONCE(reuse->synq_overflow_ts);
>>> -                       if (time_after32(now, last_overflow + HZ))
>>> +                       if (time_before32(now, last_overflow) ||
>>> +                           time_after32(now, last_overflow + HZ))
>>>                                 WRITE_ONCE(reuse->synq_overflow_ts, now);
>>>                         return;
>>>                 }
>>>         }
>>>
>>>         last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
>>> -       if (time_after32(now, last_overflow + HZ))
>>> +       if (time_before32(now, last_overflow) ||
>>> +           time_after32(now, last_overflow + HZ))
>>>                 tcp_sk(sk)->rx_opt.ts_recent_stamp = now;
>>>  }
>>>
>>> This way, tcp_synq_no_recent_overflow() should always have a recent
>>> timestamp to work on, unless tcp_synq_overflow() wasn't called. But I
>>> can't see this case happening for a legitimate connection (unless I've
>>> missed something of course).
>>>
>>> One could send an ACK without a SYN and get into this situation, but
>>> then the timestamp value doesn't have too much importance since we have
>>> to drop the connection anyway. So, even though an expired timestamp
>>> could let the packet pass the tcp_synq_no_recent_overflow() test, the
>>> syncookie validation would fail. So the packet is correctly rejected in
>>> any case.
>>
>> But the bug never has been that we could accept an invalid cookie
>> (this is unlikely because of the secret matching)
>>
> I didn't mean that it was. Maybe I wasn't clear, but this last
> paragraph was there just to explain why I didn't address the stray
> ACK scenario: such packets are correctly rejected anyway (yes we could
> be more efficient at it, but that wasn't the original purpose of the
> patch).
> 
>> The bug was that even if we have not sent recent SYNCOOKIES, we would
>> still try to validate a cookie when a stray packet comes.
>>
> I realise that I misunderstood your original answer. I was looking at
> this problem from a different angle: my original intend was to fix the
> legitimate syncookie packet case.
> 
> Stale last_overflow timestamps can cause tcp_synq_overflow() to reject
> valid packets in the following situation:
> 
>   * tcp_synq_overflow() is called while jiffies is not within the
>     (last_overflow + HZ, last_overflow + HZ + 2^31] interval. So the
>     stale last_overflow timestamp isn't updated because
>     time_after32(jiffies, last_overflow + HZ) returns false.
> 
>   * Then tcp_synq_no_recent_overflow() is called, jiffies might have
>     increased a bit, but can still be in the (last_overflow + TCP_SYNCOOKIE_VALID,
>     last_overflow + TCP_SYNCOOKIE_VALID + 2^31] interval. If so,
>     time_after32(jiffies, last_overflow + TCP_SYNCOOKIE_VALID) returns
>     true and the packet is rejected.
> 
> The case is unlikely, and whenever it happens, it can't last more than
> two minutes. But the problem is now exposed to BPF programs and the fix
> is small, so I think it's worth considering it. Admittedly my original
> submission wasn't complete. Checking that jiffies is outside of the
> [last_overflow, last_overflow + HZ] interval, as in my second proposal,
> should fix the problem completely.
> 
>> In the end, the packet would be dropped anyway, but we could drop the
>> packet much faster.
>>
>> Updating timestamps in tcp_synq_overflow() is not going to work if we
>> never call it :)
>>
>> I believe tcp_synq_no_recent_overflow() is the right place to add the fix.
>>
> Are you talking about a flood of stray ACKs (just to be sure we're on
> the same page here)? If so, I guess tcp_synq_no_recent_overflow() is
> our only chance to update last_overflow. But do we really need it?
> 
> I think tcp_synq_no_recent_overflow() should first check if jiffies
> isn't within the [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID]
> interval. Currently, we just test that it's not within
> (last_overflow + TCP_SYNCOOKIE_VALID - 2^31, last_overflow + TCP_SYNCOOKIE_VALID].
> That leaves a lot of room for stale timestamps to erroneously trigger
> syncookie verification. By reducing the interval, we'd make sure that
> only values that are undistinguishable from accurate fresh overflow
> timestamps can trigger syncookie verification.
> 
> The only bad scenario that'd remain is if a stray ACK flood happens
> when last_overflow is stale and jiffies is within the
> (last_overflow, last_overflow + TCP_SYNCOOKIE_VALID) interval. If the
> flood starts while we're in this state, then I fear that we can't do
> anything but to wait for jiffies to exeed the interval's upper bound
> (2 minutes max) and to rely on syncookies verification to reject stray
> ACKs in the mean time. For cases where the flood starts before
> jiffies enters that interval, then refreshing last_overflow in
> tcp_synq_no_recent_overflow() would prevent jiffies from entering the
> interval for the duration of the flood. last_overflow would have to be
> set TCP_SYNCOOKIE_VALID seconds in the past. But since we have
> no synchronisation with tcp_synq_overflow(), we'd have a race where
> tcp_synq_overflow() would refresh last_overflow (entering
> syncookie validation mode) and tcp_synq_no_recent_overflow() would
> immediately move it backward (leaving syncookie validation mode). We'd
> have to wait for the next SYN to finally reach a stable state with
> syncookies validation re-enabled. This is a bit far fetched, and
> requires a stray ACK arriving at the same moment a SYN flood is
> detected. Still, I feel that moving last_overflow backward in
> tcp_synq_no_recent_overflow() is a bit dangerous.
> 


Sorry I am completely lost with this amount of text.

Whatever solution you come up with, make sure it covers all the points
that have been raised.

Thanks.
