Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3752D5877
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 11:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388756AbgLJKog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 05:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgLJKo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 05:44:29 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0FBC061793
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 02:43:49 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id k10so4211393wmi.3
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 02:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6c9t4cnf3DvAPdhFWGATkIFEAIlNdLosBaBfkPc2QEA=;
        b=V6znspd0dc3v5ui9xolGs19QGbmOwM4RPyYmEVbvbxpHq3wxrgvC0Gvv0JR9ax+bGz
         P4mqsSbHwfEVSR7EZntJYe2hpS7k8Xs6NrYwpwrnrabDe5A8RHq4KrqHCQci60X3Cri2
         wWMHBzmtsGaMAPPW5z6p8J/mM/fxDMj+/AkF0eQ7hwYKJERrYBITit1+e47y/G5n2PgR
         dK1EPJpn5xNq/cxZw3ueANjW8EOtTkcmBNLAiSR3b3QO4jyly3BhhvrxAAwWaJH6bOGb
         wN73ilhNxx5N5bjHzWycTCYU1hARjokkf/ZJcmb7HHyjq70G6rM8ZYSu5D4h2HVXRjN1
         djNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6c9t4cnf3DvAPdhFWGATkIFEAIlNdLosBaBfkPc2QEA=;
        b=Uk3jOOlu7+7IzrkVAlZBRyIKjoRn/Pu8poXefJTcs81ZuDoUeK9JTPgzdyc6oCqNt/
         1tI8ICt+6tkWQUhF21Za/2eTQvu9oMWdmR1pkYtnZEBpn9JVt79Src5zH9zwl2aJmW2f
         U8glSLryL5wZL3QcKaYE0wCtxdS1gaU7fBikEI0SXduFk2zGA5C6BJUmf3GRqOUrs4Ay
         +eH7cqvEKl1f5d9MBGPOF+gWLojCGrIaowZpVjifO+6EDicXsYWRknzEldgDzAmtioWc
         gvtMcr0LWcBQH3X2XwZ49XInX0J7kLYvbsGIrT5PKUXF+BsXPkz6KQbxYdMvRlxq4P8A
         8Dlg==
X-Gm-Message-State: AOAM531TDQ85PCHGb98YjwjtDKKZQlc4j8tpR2wRDZoYO97jk1Wbw1p8
        W0k1XHX9hgNBnitD4C43mZY=
X-Google-Smtp-Source: ABdhPJyl7IpbgI685L+4f1rfoLN7ylhfUT1gytIpX8+HlFxnnE2s5yE4EWgsFjJLLMgYUFFRlHH9fw==
X-Received: by 2002:a7b:c751:: with SMTP id w17mr7287865wmk.121.1607597027913;
        Thu, 10 Dec 2020 02:43:47 -0800 (PST)
Received: from [192.168.8.116] ([37.171.242.50])
        by smtp.gmail.com with ESMTPSA id v20sm9571385wra.19.2020.12.10.02.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 02:43:47 -0800 (PST)
Subject: Re: [PATCH net] tcp: fix cwnd-limited bug for TSO deferral where we
 send nothing
To:     Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Neal Cardwell <ncardwell.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20201209035759.1225145-1-ncardwell.kernel@gmail.com>
 <20201209161403.47177093@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <HE1PR0701MB229928A122B9AAF4EF66322AC2CB0@HE1PR0701MB2299.eurprd07.prod.outlook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <944d0a94-1ec1-539b-a463-b762ebf5ed8f@gmail.com>
Date:   Thu, 10 Dec 2020 11:43:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0701MB229928A122B9AAF4EF66322AC2CB0@HE1PR0701MB2299.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/20 10:50 AM, Ingemar Johansson S wrote:
> Hi
> Slighty off topic 
> It is a smaller mystery why I am listed as having reported this artifact ?. 
> I don't have any memory that I did so.. strange 😐. 
> 

I think this was your report :

https://mailarchive.ietf.org/arch/msg/tcpm/3U--r1vC81blOfZ5JwAYWIbm4vE/

Have fun !

> Regards
> Ingemar
> 
>> -----Original Message-----
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: den 10 december 2020 01:14
>> To: Neal Cardwell <ncardwell.kernel@gmail.com>
>> Cc: David Miller <davem@davemloft.net>; netdev@vger.kernel.org; Neal
>> Cardwell <ncardwell@google.com>; Ingemar Johansson S
>> <ingemar.s.johansson@ericsson.com>; Yuchung Cheng
>> <ycheng@google.com>; Soheil Hassas Yeganeh <soheil@google.com>; Eric
>> Dumazet <edumazet@google.com>
>> Subject: Re: [PATCH net] tcp: fix cwnd-limited bug for TSO deferral where we
>> send nothing
>>
>> On Tue,  8 Dec 2020 22:57:59 -0500 Neal Cardwell wrote:
>>> From: Neal Cardwell <ncardwell@google.com>
>>>
>>> When cwnd is not a multiple of the TSO skb size of N*MSS, we can get
>>> into persistent scenarios where we have the following sequence:
>>>
>>> (1) ACK for full-sized skb of N*MSS arrives
>>>   -> tcp_write_xmit() transmit full-sized skb with N*MSS
>>>   -> move pacing release time forward
>>>   -> exit tcp_write_xmit() because pacing time is in the future
>>>
>>> (2) TSQ callback or TCP internal pacing timer fires
>>>   -> try to transmit next skb, but TSO deferral finds remainder of
>>>      available cwnd is not big enough to trigger an immediate send
>>>      now, so we defer sending until the next ACK.
>>>
>>> (3) repeat...
>>>
>>> So we can get into a case where we never mark ourselves as
>>> cwnd-limited for many seconds at a time, even with
>>> bulk/infinite-backlog senders, because:
>>>
>>> o In case (1) above, every time in tcp_write_xmit() we have enough
>>> cwnd to send a full-sized skb, we are not fully using the cwnd
>>> (because cwnd is not a multiple of the TSO skb size). So every time we
>>> send data, we are not cwnd limited, and so in the cwnd-limited
>>> tracking code in tcp_cwnd_validate() we mark ourselves as not
>>> cwnd-limited.
>>>
>>> o In case (2) above, every time in tcp_write_xmit() that we try to
>>> transmit the "remainder" of the cwnd but defer, we set the local
>>> variable is_cwnd_limited to true, but we do not send any packets, so
>>> sent_pkts is zero, so we don't call the cwnd-limited logic to update
>>> tp->is_cwnd_limited.
>>>
>>> Fixes: ca8a22634381 ("tcp: make cwnd-limited checks measurement-based,
>>> and gentler")
>>> Reported-by: Ingemar Johansson <ingemar.s.johansson@ericsson.com>
>>> Signed-off-by: Neal Cardwell <ncardwell@google.com>
>>> Signed-off-by: Yuchung Cheng <ycheng@google.com>
>>> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>
>> Applied, thank you!
