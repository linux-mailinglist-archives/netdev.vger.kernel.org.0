Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E0A4305BD
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 02:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241286AbhJQAoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 20:44:21 -0400
Received: from mail-ssdrsserver2.hostinginterface.eu ([185.185.85.90]:56749
        "EHLO mail-ssdrsserver2.hostinginterface.eu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233536AbhJQAoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 20:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bobbriscoe.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oPMUlkOyXBqTuIEX28TSkhOTfBQK0lY35BLKLALfWUc=; b=cwp3oHdKnsR0Z+zZhuYtL9l6ki
        isY8Dnj8c0WxSI2NP61u+GbnIu72UOm4ppvRYkAlgQfSAx3j26dydusiI0VaEFs3Wt4xRKcBDDfTa
        /MjPQU4/yPVdx7VWOjkU8C24HlUw3alJWYn2sQ7ngYFQdbZllvxJsm7Ra5ep9ezqakCp2+I8D6/AC
        xkLnbCtbrbaCCt6pJpkUKY5Qwz2WBr+Y30Vutg8lQOMgiSvC+ay6RXIEbngzaHg7fTg4Mhln3Ry5f
        HI1gFeYSiwoTpPjAbTCyUiNNnxpHWPVf8+1J1923gGjCD2FELeoFi/HptRFozPK33oWbvoYUDBcyc
        uzxz8KFg==;
Received: from 67.153.238.178.in-addr.arpa ([178.238.153.67]:37674 helo=[192.168.1.11])
        by ssdrsserver2.hostinginterface.eu with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <ietf@bobbriscoe.net>)
        id 1mbuFp-00Bnu4-FW; Sun, 17 Oct 2021 01:42:10 +0100
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
To:     Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com>
 <9608bf7c-a6a2-2a30-2d96-96bd1dfb25e3@bobbriscoe.net>
 <CANn89iKavhJGi0NE873v+qCjZL=NRbMjVCsLJJv2o9nXyDSmUQ@mail.gmail.com>
 <CADVnQyn5qjonOejvmsQh+KJ04NV0f+NoGWXB-AQBPXLUkqPU6w@mail.gmail.com>
From:   Bob Briscoe <ietf@bobbriscoe.net>
Message-ID: <c4534ad7-672f-9459-bb22-46bf504231ff@bobbriscoe.net>
Date:   Sun, 17 Oct 2021 01:42:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CADVnQyn5qjonOejvmsQh+KJ04NV0f+NoGWXB-AQBPXLUkqPU6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ssdrsserver2.hostinginterface.eu
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bobbriscoe.net
X-Get-Message-Sender-Via: ssdrsserver2.hostinginterface.eu: authenticated_id: in@bobbriscoe.net
X-Authenticated-Sender: ssdrsserver2.hostinginterface.eu: in@bobbriscoe.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric, (thanks Neal)

On 15/10/2021 16:49, Neal Cardwell wrote:
> On Fri, Oct 15, 2021 at 10:08 AM Eric Dumazet <edumazet@google.com> wrote:
>> On Fri, Oct 15, 2021 at 5:59 AM Bob Briscoe <ietf@bobbriscoe.net> wrote:
>>> Eric,
>>>
>>> Because the threshold is in time units, I suggest the condition for
>>> exceeding it needs to be AND'd with (*backlog > mtu), otherwise you can
>>> get 100% solid marking at low link rates.
>>>
>>> When ce_threshold is for DCs, low link rates are unlikely.
>>> However, given ce_threshold_ect1 is mainly for the Internet, during
>>> testing with 1ms threshold we encountered solid marking at low link
>>> rates, so we had to add a 1 packet floor:
>>> https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726.pdf
>>>
>>> Sorry to chime in after your patch went to net-next.
>>>
>> What you describe about a minimal backlog was already there with
>> ce_threshold handling ?
> For my education, do you have a pointer to where the ce_threshold
> marking logic has a minimum backlog size requirement in packets or
> bytes? AFAICT the ce_threshold marking in include/net/codel_impl.h
> happens regardless of the current size of the backlog.

[BB] When I checked before my original posting, the only check for 
single packet backlog was within should_drop() here:
https://elixir.bootlin.com/linux/latest/source/include/net/codel_impl.h#L125
However, whether or not that causes should_drop() to return false, 
codel_dequeue() still always falls through to the ce_threshold marking 
after end:
https://elixir.bootlin.com/linux/latest/source/include/net/codel_impl.h#L249


>
>> Or is it something exclusive to L4S ?
> I don't think it's exclusive to L4S. I think Bob is raising a general
> issue about improving ECN marking based on ce_threshold. My
> interpretation of Bob's point is that there is sort of a quantization
> issue at very low link speeds, where the serialization delay for a
> packet is at or above the ce_threshold delay. In such cases it seems
> there can be behavior where the bottleneck marks every packet CE all
> the time, causing any ECN-based algorithm (even DCTCP) to suffer poor
> utilization.
>
> I suppose with a fixed-speed link the operator could adjust the
> ce_threshold based on the serialization delays implied by the link
> speed, but perhaps in general this is infeasible due to variable-speed
> (e.g., radio) links.
>
> I guess perhaps this could be reproduced/tested with DCTCP (using
> ECT(0)), a ce_threshold of 1ms (for ECT(0)), and an emulated
> bottleneck link speed with a serialization delay well above 1ms (so a
> link speed well below 12Mbps).

[BB] Yes.

>
>> This deserves a separate patch, if anything :)
> Agreed, in the Linux development model this would make sense as a
> separate patch, since it is conceptually separate and there do not
> need to be any dependencies between the two changes. :-)

[BB] Sure. We'll see to it.

The (loose/indirect) dependency I saw was just that ce_threshold_ect1 
opens up the possibility of using the ce_threshold on the public 
Internet not just in DCs. So low rate links become a certainty, rather 
than a mere theoretical possibility.



Bob

>
> neal

-- 
________________________________________________________________
Bob Briscoe                               http://bobbriscoe.net/

