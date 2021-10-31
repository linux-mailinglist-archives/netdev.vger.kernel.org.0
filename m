Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C695A441139
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 23:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhJaWcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 18:32:41 -0400
Received: from mail-ssdrsserver2.hostinginterface.eu ([185.185.85.90]:43287
        "EHLO mail-ssdrsserver2.hostinginterface.eu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230309AbhJaWcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 18:32:39 -0400
X-Greylist: delayed 2345 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Oct 2021 18:32:38 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bobbriscoe.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c4B6FH9wNTqPIXLv/fXuwhhE1Kmx6zZ5pCpnAenFzPs=; b=uDUKSJ2W6aChl7kNKjVVgyikQg
        D2pmbHLbIzxlA/iqpmJzhmEWQrS6eCXQVNa4AsrbMSVHc5hthH4bHNSV0U3S0g6S2fALx3O110dgh
        OMxMhqKD5SvSW0TuL/08yIpUO4VJqE/qzMcBJT2uFpbHXWFBEjiLVKyCWlYIKNZ7MvT7dCbJkJQDu
        Zp0pRhfkckjMEjZLdRLA3jg9ZsnwfSkw+cSHPcawokNIzT3z+wrtgwJj4GsHvTBRYtsZHpkO7gqEJ
        9vTnyRTYuSav/cciT+1SPZcr7ClPADN2xtLlAijK6MqA1AwTnM6GN6iiHHhpwIkSufY1ujP9NfHiI
        y6/slnkg==;
Received: from 67.153.238.178.in-addr.arpa ([178.238.153.67]:52906 helo=[192.168.1.11])
        by ssdrsserver2.hostinginterface.eu with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <research@bobbriscoe.net>)
        id 1mhIjE-0007vu-Hd; Sun, 31 Oct 2021 21:51:00 +0000
Subject: Re: [PATCH net-next] fq_codel: avoid under-utilization with
 ce_threshold at low link rates
To:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     Asad Sajjad Ahmed <asadsa@ifi.uio.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        Olga Albisser <olga@albisser.org>
References: <20211028191500.47377-1-asadsa@ifi.uio.no>
 <CADVnQykDUB4DgUaV0rd6-OKafO+F6w=BRfxviuZ_MJLY3xMV+Q@mail.gmail.com>
 <CANn89iLcTNHCudo-9=RLR1N3o1T0QgVvbedwXeTaFFo5RdMzkg@mail.gmail.com>
From:   Bob Briscoe <research@bobbriscoe.net>
Message-ID: <70dec481-1573-b63d-fd61-2e018535d0fa@bobbriscoe.net>
Date:   Sun, 31 Oct 2021 21:50:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLcTNHCudo-9=RLR1N3o1T0QgVvbedwXeTaFFo5RdMzkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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

Eric,

On 29/10/2021 15:53, Eric Dumazet wrote:
> On Fri, Oct 29, 2021 at 6:54 AM Neal Cardwell <ncardwell@google.com> wrote:
>> On Thu, Oct 28, 2021 at 3:15 PM Asad Sajjad Ahmed <asadsa@ifi.uio.no> wrote:
>>> Commit "fq_codel: generalise ce_threshold marking for subset of traffic"
>>> [1] enables ce_threshold to be used in the Internet, not just in data
>>> centres.
>>>
>>> Because ce_threshold is in time units, it can cause poor utilization at
>>> low link rates when it represents <1 packet.
>>> E.g., if link rate <12Mb/s ce_threshold=1ms is <1500B packet.
>>>
>>> So, suppress ECN marking unless the backlog is also > 1 MTU.
>>>
>>> A similar patch to [1] was tested on an earlier kernel, and a similar
>>> one-packet check prevented poor utilization at low link rates [2].
>>>
>>> [1] commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subset of traffic")
>>>
>>> [2] See right hand column of plots at the end of:
>>> https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726.pdf
>>>
>>> Signed-off-by: Asad Sajjad Ahmed <asadsa@ifi.uio.no>
>>> Signed-off-by: Olga Albisser <olga@albisser.org>
>>> ---
>>>   include/net/codel_impl.h | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
>>> index 137d40d8cbeb..4e3e8473e776 100644
>>> --- a/include/net/codel_impl.h
>>> +++ b/include/net/codel_impl.h
>>> @@ -248,7 +248,8 @@ static struct sk_buff *codel_dequeue(void *ctx,
>>>                                                      vars->rec_inv_sqrt);
>>>          }
>>>   end:
>>> -       if (skb && codel_time_after(vars->ldelay, params->ce_threshold)) {
>>> +       if (skb && codel_time_after(vars->ldelay, params->ce_threshold) &&
>>> +           *backlog > params->mtu) {
> I think this idea would apply to codel quite well.  (This helper is
> common to codel and fq_codel)
>
> But with fq_codel my thoughts are:
>
> *backlog is the backlog of the qdisc, not the backlog for the flow,

[BB] Ah. Hadn't appreciated that. Thanks.

We were modelling this on a check of (*backlog <= params->mtu) in 
codel_should_drop(), which I thought was similarly checking for low link 
rate in fq_codel and codel. But didn't do our homework properly...

> and it includes the packet currently being removed from the queue.
>
> Setting ce_threshold to 1ms while the link rate is 12Mbs sounds
> misconfiguration to me.

[BB] The idea was meant to be that you don't have to know the drain rate 
of the queue. This additional check was meant to suppress marking
     if (ldelay > ce_threshold) && !(qlen > 1).

ce_threshold = 1ms was only an example, nonetheless we had tested that 
config down to 4Mb/s with two flows. We AND'd ce_threshold with a check 
for qlen >1 packet and we still got >95% link utilization, as shown in 
the plots referenced via [2], e.g. Fig 4. But checking qlen would have 
disrupted the code somewhat, so we had hoped to be able to add a check 
of the /queue/'s backlog instead, thinking it was conveniently already 
available.

[2] See right hand column of plots at the end of:
https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726.pdf

We were conscious that this could have suppressed marking of a queue of 
more than one small packet, as long as ldelay also exceeded 
ce_threshold, but we figured that would do no great harm.

> Even if this flow has to transmit one tiny packet every minute, it
> will get CE mark
> just because at least one packet from an elephant flow is currently
> being sent to the wire.
>
> BQL won't prevent that at least one packet is being processed while
> the tiny packet
> is coming into fq_codel qdisc.

[BB] Yes, now we understand it's the backlog of the whole qdisc, this 
isn't the behaviour we intended.

> vars->ldelay = now - skb_time_func(skb);
>
> For tight ce_threshold, vars->ldelay would need to be replaced by
>
> now - (time of first codel_dequeue() after this skb has been queued).
> This seems a bit hard to implement cheaply.

[BB] We'll think whether we can do the qlen check less disruptively.


Bob

>
>
>
>
>>>                  bool set_ce = true;
>>>
>>>                  if (params->ce_threshold_mask) {
>>> --
>> Sounds like a good idea, and looks good to me.
>>
>> Acked-by: Neal Cardwell <ncardwell@google.com>
>>
>> Eric, what do you think?
>>
>> neal

-- 
________________________________________________________________
Bob Briscoe                               http://bobbriscoe.net/

