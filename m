Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A9414F20C
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgAaSTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:19:36 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:36643 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgAaSTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 13:19:36 -0500
Received: by mail-io1-f65.google.com with SMTP id d15so9207976iog.3;
        Fri, 31 Jan 2020 10:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c8i1GlKInlXyN29xwVsz2/AwFCxW5o2ypUfu5ITlzRY=;
        b=Sf0Ptb03U35DGJ7wylQ0dAs6FQUPlkNKMKX4E04EOWICW9PDZP1sV3I+9Mg05AkdMs
         yoOh6VuWR64rPBSGk6LMEZImeLl80RM1R6FwdXk4WX+mWCWbLPUGdXBxQwMtg/EgvMbR
         +jfAZJ09295ytpQW6b2ulVgE+c8f3xHB3hK8wrfrVDcC3QYbv0J+Z+GILXtbK3XwiHTJ
         8jsFQqj/D6/bFkPZRCbYKp9yZeYOxn8zx3s0599ykKBXiVJntPHn5geFpLus6SqDOWni
         M2StTip5BgKKwJveXYeL+Kz6Ddbw/KlxwEBkVexFDlbEo8VzTGEWrZj+7YkMatcXxULI
         4Yig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c8i1GlKInlXyN29xwVsz2/AwFCxW5o2ypUfu5ITlzRY=;
        b=tFxE2gVEkmS3ciDmj07mmEAZGyV7K6fLF5llj/saF+r1jm26lYxM9ZN/NH62YpyPV/
         RCOplfpeKlEpslQUffem3K+EZaj3omOGWVcS6y1dC/Niofl/9nB/7XVY8x1tBY9hOlDy
         r3pVbFPnpIbbR2mlP/u/SZP3x06tgok/RuzX8DpAIybus+d4GarNDpyzTJ1vIhFnMz3Z
         GHZadMKeADYUIxduvn9fSjztHCP0V+a3oi9pJyjM++NNeaADVfIhWrCrPdk/EgZHFuGi
         xlBTB7q55qPcKbfZaFbDtG+GZMtbSuO39lLgmLdv5arM/1jiulrK+0KtRiAt7LfeZW2j
         hFAg==
X-Gm-Message-State: APjAAAVgS2JkTWed3W1ybGO/5YRCGQQg9snnzWip/yT4/OPiBiWmYO2Q
        HYiEJ7tGDRJK/y3ojQ4NfbetoeHj
X-Google-Smtp-Source: APXvYqy4Fu0s+h1yZg5wMFoMycKioZaG7S+3BtI06GDfKvNq+GTOzFz3vJ36/F4bq4GlMueNUdnG5A==
X-Received: by 2002:a65:420d:: with SMTP id c13mr11908567pgq.101.1580494357755;
        Fri, 31 Jan 2020 10:12:37 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id ev5sm8578011pjb.4.2020.01.31.10.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 10:12:36 -0800 (PST)
Subject: Re: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is
 received
To:     Neal Cardwell <ncardwell@google.com>, sjpark@amazon.com
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, shuah@kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, sj38.park@gmail.com,
        aams@amazon.com, SeongJae Park <sjpark@amazon.de>,
        Yuchung Cheng <ycheng@google.com>
References: <20200131122421.23286-1-sjpark@amazon.com>
 <20200131122421.23286-3-sjpark@amazon.com>
 <CADVnQyk9xevY0kA9Sm9S9MOBNvcuiY+7YGBtGuoue+r+eizyOA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dd146bac-4e8a-4119-2d2b-ce6bf2daf7ce@gmail.com>
Date:   Fri, 31 Jan 2020 10:12:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CADVnQyk9xevY0kA9Sm9S9MOBNvcuiY+7YGBtGuoue+r+eizyOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/31/20 7:10 AM, Neal Cardwell wrote:
> On Fri, Jan 31, 2020 at 7:25 AM <sjpark@amazon.com> wrote:
>>
>> From: SeongJae Park <sjpark@amazon.de>
>>
>> When closing a connection, the two acks that required to change closing
>> socket's status to FIN_WAIT_2 and then TIME_WAIT could be processed in
>> reverse order.  This is possible in RSS disabled environments such as a
>> connection inside a host.
>>
>> For example, expected state transitions and required packets for the
>> disconnection will be similar to below flow.
>>
>>          00 (Process A)                         (Process B)
>>          01 ESTABLISHED                         ESTABLISHED
>>          02 close()
>>          03 FIN_WAIT_1
>>          04             ---FIN-->
>>          05                                     CLOSE_WAIT
>>          06             <--ACK---
>>          07 FIN_WAIT_2
>>          08             <--FIN/ACK---
>>          09 TIME_WAIT
>>          10             ---ACK-->
>>          11                                     LAST_ACK
>>          12 CLOSED                              CLOSED
> 
> AFAICT this sequence is not quite what would happen, and that it would
> be different starting in line 8, and would unfold as follows:
> 
>           08                                     close()
>           09                                     LAST_ACK
>           10             <--FIN/ACK---
>           11 TIME_WAIT
>           12             ---ACK-->
>           13 CLOSED                              CLOSED
> 
> 
>> The acks in lines 6 and 8 are the acks.  If the line 8 packet is
>> processed before the line 6 packet, it will be just ignored as it is not
>> a expected packet,
> 
> AFAICT that is where the bug starts.
> 
> AFAICT, from first principles, when process A receives the FIN/ACK it
> should move to TIME_WAIT even if it has not received a preceding ACK.
> That's because ACKs are cumulative. So receiving a later cumulative
> ACK conveys all the information in the previous ACKs.
> 
> Also, consider the de facto standard state transition diagram from
> "TCP/IP Illustrated, Volume 2: The Implementation", by Wright and
> Stevens, e.g.:
> 
>   https://courses.cs.washington.edu/courses/cse461/19sp/lectures/TCPIP_State_Transition_Diagram.pdf
> 
> This first-principles analysis agrees with the Wright/Stevens diagram,
> which says that a connection in FIN_WAIT_1 that receives a FIN/ACK
> should move to TIME_WAIT.
> 
> This seems like a faster and more robust solution than installing
> special timers.
> 
> Thoughts?


This is orthogonal I think.

No matter how hard we fix the other side, we should improve the active side.

Since we send a RST, sending the SYN a few ms after the RST seems way better
than waiting 1 second as if we received no packet at all.

Receiving this ACK tells us something about networking health, no need
to be very cautious about the next attempt.

Of course, if you have a fix for the passive side, that would be nice to review !



