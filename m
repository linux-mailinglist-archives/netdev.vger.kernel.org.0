Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F7D382DBC
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 15:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbhEQNn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 09:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbhEQNn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 09:43:56 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6418BC061573;
        Mon, 17 May 2021 06:42:39 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h16so6952348edr.6;
        Mon, 17 May 2021 06:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MM9OT2VX8MANaBDIr+TuHV8Zc0JnQ9RS2VSGzbp47tM=;
        b=RQWlWkYYUNRC/++8UUgVItSQ/HvcwGnE9t1R7h605766oL03MohFulSHuLoz7rVYs5
         aJMxhzAA9yG6gzvDlR4NP4pdb+aytBKTYkoXX6FrPVrEp1OMi51Kr+YR6Gx4RDK3fkyz
         JLxSqFCHFb0UDkL8c5899kViGX1OdDrKLY+JNJ9x1J3CEFitC7qwSYKAZaGUrXKrWvO0
         lQg7gbDL20lu4YztxW0qaKWWDgk8n2tmopF7b5obMvfquRrmB+sW+6U2isQyDJTP11mw
         OS3vRWsn6v2s781mbo61IUc+Qk/NJY4xCDaBxq6QNytf/Xa2uo1OnyB0FfVgWlKbUIlm
         tlvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MM9OT2VX8MANaBDIr+TuHV8Zc0JnQ9RS2VSGzbp47tM=;
        b=OpFehpv3NVhqgc6LeySzZ4FHYJUx7aEr4aC8182FLD8oM5S7cyj/3LNe3T6Rhdq9Pc
         Wp3tP6O1pWAkCiW+sTLdrYzveLl1KioDueFQJ2cXKwvBiRJyr+6wsUuX8aLDxLB05BtR
         3uX504iaySoU2xtdg0rwpMTrr0VQCsS1WjsuvWCiE9qcY/Q4cUZirVQbb9WWQ8eyb4fR
         UHe7jWejMpBPqszJv/AeAIaYJGVUVs+0L/BwB+rWLogXnFAncEOKFXRKH+V5nSOqfcCp
         6Te59uWZOt/1fGIkaJ1l3Uljcx08IbCIBSD2+hE0PQ/INuerUMy1uodzfFm+GU9IHOOU
         Sp5A==
X-Gm-Message-State: AOAM531j2H12ewMYkdrxjlgtd0RlrONWxiXztfw0GQGBX7umGYp325Jo
        5yzIWuSMClFyRKBvsgmw5eWUWlJ/tvJgS3T/G0RmBg==
X-Google-Smtp-Source: ABdhPJx7LPvi5kBu+P9USGsfYUDpcrJ7qUPreOZdz4mFjUPLucLXNfPHWiyQ+yNlkXj3PfQbJIdgFw==
X-Received: by 2002:a05:6402:cb0:: with SMTP id cn16mr79341edb.15.1621258958120;
        Mon, 17 May 2021 06:42:38 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:7d56:ee1e:623f:176f? ([2a04:241e:502:1d80:7d56:ee1e:623f:176f])
        by smtp.gmail.com with ESMTPSA id dn4sm3661628edb.88.2021.05.17.06.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 06:42:37 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [RFC 1/3] tcp: Consider mtu probing for tcp_xmit_size_goal
To:     Eric Dumazet <edumazet@google.com>,
        Matt Mathis <mattmathis@google.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <cover.1620733594.git.cdleonard@gmail.com>
 <52e63f5b41c9604b909badb7fbc593fe1fe77413.1620733594.git.cdleonard@gmail.com>
 <CANn89i+4x+YLVmPNSSiOEB4isQYussWSLqFb5x+0hQ5hyS4j_A@mail.gmail.com>
Message-ID: <e6a3dfab-ccea-1a0c-6fd8-bfca466aefba@gmail.com>
Date:   Mon, 17 May 2021 16:42:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANn89i+4x+YLVmPNSSiOEB4isQYussWSLqFb5x+0hQ5hyS4j_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/21 4:04 PM, Eric Dumazet wrote:
> On Tue, May 11, 2021 at 2:04 PM Leonard Crestez <cdleonard@gmail.com> wrote:
>>
>> According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
>> in order to accumulate enough data" but linux almost never does that.
>>
>> Linux checks for (probe_size + (1 + reorder) * mss_cache) bytes to be
>> available in the send buffer and if that condition is not met it will
>> send anyway using the current MSS. The feature can be made to work by
>> sending very large chunks of data from userspace (for example 128k) but
>> for small writes on fast links tcp mtu probes almost never happen.
> 
> Why should they happen ?
> 
> I am not sure the kernel should perform extra checks just because
> applications are not properly written.

My tests show that application writing a few kb at a time almost never 
trigger MTU probing enough to reach 9200. The reasons for this are very 
difficult for me to understand.

It seems that only writing in very large chunks like 160k makes it 
happen, much more than the size_needed calculated inside tcp_mtu_probing 
(which is about 50k). This seems unreasonable. Ideally linux should try 
to accumulate enough data for a probe (as the RFC suggests) but at least 
it should send probes that fit inside a single userspace write.

I dug a little deeper and what seems to happen is this:

  * size_needed is ~60k
  * once the head of the queue reached size_needed tcp_push_one is 
called which sends everything ignoring MTU probing
  * size_needed is reached again and tcp_push_pending_frames is called. 
At this point the cwnd has shrunk < 11 (due to the previous burst) so 
probing is skipped again in favor of just sending in mss-sized chunks.

This happens repeatedly, a sender-limited app performing periodic 128k 
writes will see MSS stuck below MTU.

I don't understand the push_one logic and why it completely skips mtu 
probing, it seems like an optimization which doesn't take RFC4821 into 
account.

>> This patch tries to take mtu probe into account in tcp_xmit_size_goal, a
>> function which otherwise attempts to accumulate a packet suitable for
>> TSO. No delays are introduced beyond existing autocork heuristics.
> 
> 
> MTU probing should not be attempted for every write().
> This belongs to some kind of slow path, once in a while.

MTU probing is only attempted every 10 minutes but once a probe is 
pending it does have a slight impact on every write. This is already the 
case, tcp_write_xmit calls tcp_mtu_probe almost every time.

I had an idea for reducing the overhead in tcp_size_needed but it turns 
out I was indeed mistaken about what this function does. I thought it 
returned ~mss when all GSO is disabled but this is not so.

>>   static unsigned int tcp_xmit_size_goal(struct sock *sk, u32 mss_now,
>>                                         int large_allowed)
>>   {
>> +       struct inet_connection_sock *icsk = inet_csk(sk);
>>          struct tcp_sock *tp = tcp_sk(sk);
>>          u32 new_size_goal, size_goal;
>>
>>          if (!large_allowed)
>>                  return mss_now;
>> @@ -932,11 +933,19 @@ static unsigned int tcp_xmit_size_goal(struct sock *sk, u32 mss_now,
>>                  tp->gso_segs = min_t(u16, new_size_goal / mss_now,
>>                                       sk->sk_gso_max_segs);
>>                  size_goal = tp->gso_segs * mss_now;
>>          }
>>
>> -       return max(size_goal, mss_now);
>> +       size_goal = max(size_goal, mss_now);
>> +
>> +       if (unlikely(icsk->icsk_mtup.wait_data)) {
>> +               int mtu_probe_size_needed = tcp_mtu_probe_size_needed(sk, NULL);
>> +               if (mtu_probe_size_needed > 0)
>> +                       size_goal = max(size_goal, (u32)mtu_probe_size_needed);
>> +       }
> 
> 
> I think you are mistaken.
> 
> This function usually returns 64KB depending on MSS.
>   Have you really tested this part ?

I assumed that with all gso features disabled this function returns one 
MSS but this is not true. My patch had a positive effect just because I 
made tcp_mtu_probing return "0" instead of "-1" if not enough data is 
queued.

I don't fully understand the implications of that change though. If 
tcp_mtu_probe returns zero what guarantee is there that data will 
eventually be sent even if no further userspace writes happen?

I'd welcome any suggestions.

--
Regards,
Leonard
