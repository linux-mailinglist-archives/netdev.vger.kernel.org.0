Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B60E13BE62
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 12:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbgAOL3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 06:29:35 -0500
Received: from mail.dlink.ru ([178.170.168.18]:52690 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729758AbgAOL3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 06:29:35 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id D134F1B214CE; Wed, 15 Jan 2020 14:29:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru D134F1B214CE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579087770; bh=pO09eBH+n2lZ2OjGmzhiwfRxx2EMdmCQb5JHVBFGHaw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=TLm8Uwbs63ejdOX+QIzsxiKpZR/52pRnRaFuqmERw9mazHMuOOCtyRO4a3PYKR03n
         YJQFSgnjQllEQuNuMitrk2zRjPNJRhAWK/KeECfOmgJL/Wf4pruJNSvdrkml/pfgrw
         qi1wiA4aE3xCbCdAmSlXZXFHfQ06U0EshTDyBbD8=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-96.3 required=7.5 tests=BAYES_99,BAYES_999,
        URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 1451B1B202CB;
        Wed, 15 Jan 2020 14:29:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 1451B1B202CB
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id A45281B20AE9;
        Wed, 15 Jan 2020 14:29:14 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 15 Jan 2020 14:29:14 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 15 Jan 2020 14:29:14 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH RFC net-next 05/19] net: dsa: tag_ar9331: add GRO
 callbacks
In-Reply-To: <f04b112147bbe35f6e5c73d96c456bd4@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <20191230143028.27313-6-alobakin@dlink.ru>
 <ee6f83fd-edf4-5a98-9868-4cbe9e226b9b@gmail.com>
 <ed0ad0246c95a9ee87352d8ddbf0d4a1@dlink.ru>
 <CA+h21hoSoZT+ieaOu8N=MCSqkzey0L6HeoXSyLtHjZztT0S9ug@mail.gmail.com>
 <0002a7388dfd5fb70db4b43a6c521c52@dlink.ru>
 <CA+h21hqZoLrU7nL3Vo0KcmFnOxNxQPwoOVSEd6styyjK7XO+5w@mail.gmail.com>
 <129bf2bc-c0e9-02a3-7d40-0f7920803769@gmail.com>
 <f04b112147bbe35f6e5c73d96c456bd4@dlink.ru>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <82f4cd224d0d0b2b689048a82d790a6e@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin wrote 15.01.2020 10:38:
> Florian Fainelli wrote 15.01.2020 00:56:
>> On 1/13/20 2:28 AM, Vladimir Oltean wrote:
>>> On Mon, 13 Jan 2020 at 11:46, Alexander Lobakin <alobakin@dlink.ru> 
>>> wrote:
>>>> 
>>>> Vladimir Oltean wrote 13.01.2020 12:42:
>>>>> Hi Alexander,
>>>>> 
>>>>> On Mon, 13 Jan 2020 at 11:22, Alexander Lobakin <alobakin@dlink.ru>
>>>>> wrote:
>>>>>> 
>>>>>> CPU ports can't be bridged anyway
>>>>>> 
>>>>>> Regards,
>>>>>> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
>>>>> 
>>>>> The fact that CPU ports can't be bridged is already not ideal.
>>>>> One can have a DSA switch with cascaded switches on each port, so 
>>>>> it
>>>>> acts like N DSA masters (not as DSA links, since the taggers are
>>>>> incompatible), with each switch forming its own tree. It is 
>>>>> desirable
>>>>> that the ports of the DSA switch on top are bridged, so that
>>>>> forwarding between cascaded switches does not pass through the CPU.
>>>> 
>>>> Oh, I see. But currently DSA infra forbids the adding DSA masters to
>>>> bridges IIRC. Can't name it good or bad decision, but was introduced
>>>> to prevent accidental packet flow breaking on DSA setups.
>>>> 
>>> 
>>> I just wanted to point out that some people are going to be looking 
>>> at
>>> ways by which the ETH_P_XDSA handler can be made to play nice with 
>>> the
>>> master's rx_handler, and that it would be nice to at least not make
>>> the limitation worse than it is by converting everything to
>>> rx_handlers (which "currently" can't be stacked, from the comments in
>>> netdevice.h).
>> 
>> I am not sure this would change the situation much, today we cannot 
>> have
>> anything but switch tags travel on the DSA master network device,
>> whether we accomplish the RX tap through a special skb->protocol value
>> or via rx_handler, it probably does not functionally matter, but it
>> could change the performance.
> 
> As for now, I think that we should keep this RFC as it is so
> developers working with different DSA switches could test it or
> implement GRO offload for other taggers like DSA and EDSA, *but*
> any future work on this should come only when we'll revise/reimagine
> basic DSA packet flow, as we already know (at least me and Florian
> reproduce it well) that the current path through unlikely branches
> in eth_type_trans() and frame capturing through packet_type is so
> suboptimal that nearly destroys overall performance on several
> setups.

Well, I had enough free time today to write and test sort of
blueprint-like DSA via .rx_handler() to compare it with the current
flow and get at least basic picture of what's going on.

I chose a 600 MHz UP MIPS system to make a difference more noticeable
as more powerful systems tend to mitigate plenty of different "heavy"
corners and misses.
Ethernet driver for CPU port uses BQL and DIM, as well as hardware TSO.
A minimal GRO over DSA is also enabled. The codebase is Linux 5.5-rc6.
I use simple VLAN NAT (with nft flow offload), iperf3, IPv4 + TCP.

Mainline DSA Rx processing, one flow:

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-60.00  sec  4.30 GBytes   615 Mbits/sec  2091   sender
[  5]   0.00-60.01  sec  4.30 GBytes   615 Mbits/sec         receiver

10 flows:

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-60.00  sec   414 MBytes  57.9 Mbits/sec  460    sender
[  5]   0.00-60.01  sec   413 MBytes  57.7 Mbits/sec         receiver
[  7]   0.00-60.00  sec   392 MBytes  54.8 Mbits/sec  497    sender
[  7]   0.00-60.01  sec   391 MBytes  54.6 Mbits/sec         receiver
[  9]   0.00-60.00  sec   391 MBytes  54.6 Mbits/sec  438    sender
[  9]   0.00-60.01  sec   389 MBytes  54.4 Mbits/sec         receiver
[ 11]   0.00-60.00  sec   383 MBytes  53.5 Mbits/sec  472    sender
[ 11]   0.00-60.01  sec   382 MBytes  53.4 Mbits/sec         receiver
[ 13]   0.00-60.00  sec   404 MBytes  56.5 Mbits/sec  466    sender
[ 13]   0.00-60.01  sec   403 MBytes  56.3 Mbits/sec         receiver
[ 15]   0.00-60.00  sec   453 MBytes  63.4 Mbits/sec  490    sender
[ 15]   0.00-60.01  sec   452 MBytes  63.1 Mbits/sec         receiver
[ 17]   0.00-60.00  sec   461 MBytes  64.4 Mbits/sec  430    sender
[ 17]   0.00-60.01  sec   459 MBytes  64.2 Mbits/sec         receiver
[ 19]   0.00-60.00  sec   365 MBytes  51.0 Mbits/sec  493    sender
[ 19]   0.00-60.01  sec   364 MBytes  50.9 Mbits/sec         receiver
[ 21]   0.00-60.00  sec   407 MBytes  56.9 Mbits/sec  517    sender
[ 21]   0.00-60.01  sec   405 MBytes  56.7 Mbits/sec         receiver
[ 23]   0.00-60.00  sec   486 MBytes  68.0 Mbits/sec  458    sender
[ 23]   0.00-60.01  sec   484 MBytes  67.7 Mbits/sec         receiver
[SUM]   0.00-60.00  sec  4.06 GBytes   581 Mbits/sec  4721   sender
[SUM]   0.00-60.01  sec  4.04 GBytes   579 Mbits/sec         receiver

.rx_handler(), one flow:

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-60.00  sec  4.40 GBytes   630 Mbits/sec  853    sender
[  5]   0.00-60.01  sec  4.40 GBytes   630 Mbits/sec         receiver

And 10:

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-60.00  sec   440 MBytes  61.5 Mbits/sec  551    sender
[  5]   0.00-60.01  sec   439 MBytes  61.4 Mbits/sec         receiver
[  7]   0.00-60.00  sec   455 MBytes  63.6 Mbits/sec  496    sender
[  7]   0.00-60.01  sec   454 MBytes  63.4 Mbits/sec         receiver
[  9]   0.00-60.00  sec   484 MBytes  67.7 Mbits/sec  532    sender
[  9]   0.00-60.01  sec   483 MBytes  67.5 Mbits/sec         receiver
[ 11]   0.00-60.00  sec   598 MBytes  83.6 Mbits/sec  452    sender
[ 11]   0.00-60.01  sec   596 MBytes  83.3 Mbits/sec         receiver
[ 13]   0.00-60.00  sec   427 MBytes  59.7 Mbits/sec  539    sender
[ 13]   0.00-60.01  sec   426 MBytes  59.5 Mbits/sec         receiver
[ 15]   0.00-60.00  sec   469 MBytes  65.5 Mbits/sec  466    sender
[ 15]   0.00-60.01  sec   467 MBytes  65.3 Mbits/sec         receiver
[ 17]   0.00-60.00  sec   463 MBytes  64.7 Mbits/sec  472    sender
[ 17]   0.00-60.01  sec   462 MBytes  64.5 Mbits/sec         receiver
[ 19]   0.00-60.00  sec   533 MBytes  74.5 Mbits/sec  447    sender
[ 19]   0.00-60.01  sec   532 MBytes  74.3 Mbits/sec         receiver
[ 21]   0.00-60.00  sec   444 MBytes  62.1 Mbits/sec  527    sender
[ 21]   0.00-60.01  sec   443 MBytes  61.9 Mbits/sec         receiver
[ 23]   0.00-60.00  sec   500 MBytes  69.9 Mbits/sec  449    sender
[ 23]   0.00-60.01  sec   499 MBytes  69.8 Mbits/sec         receiver
[SUM]   0.00-60.00  sec  4.70 GBytes   673 Mbits/sec  4931   sender
[SUM]   0.00-60.01  sec  4.69 GBytes   671 Mbits/sec         receiver

Pretty significant stats. This happens not only because we get rid of
out-of-line unlikely() branches (which are natural killers, at least
on MIPS), but also because we don't need to call netif_receive_skb()
for the second time -- we might just return RX_HANDLER_ANOTHER and
Rx path becomes then not much longer than in case of simple VLAN tag
removal (_net/core/dev.c:5056_).

This should get more attention and tests on a wide variety of other
systems, of course.

> Switching to net_device::rx_handler() is just one of all the possible
> variants, I'm sure we'll find the best solution together.
> 
> Regards,
> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
