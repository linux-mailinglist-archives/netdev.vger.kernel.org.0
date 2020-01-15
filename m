Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6193413BA62
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 08:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAOHii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 02:38:38 -0500
Received: from fd.dlink.ru ([178.170.168.18]:46316 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgAOHih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 02:38:37 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id BCF101B21254; Wed, 15 Jan 2020 10:38:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru BCF101B21254
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579073914; bh=CxEiSPavtIlJWlMwr6AuhfGibqHNMwLCY9kUK5W5q30=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=gmIFfkyPm7iywN2d5hK4aX1BTbGnYfpazghsAal7Udzm/YlHKT66E8AVZ7t4B/+Vz
         k1q9WjqvGlMMytMVqviW5Px4tIEIgq6zYg93koqXYOseMEGSXMNw21krlaTuEAVQwz
         KU74WOHtFFH7yj706gojdHFav+KiqJGciyAjd/cM=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 257691B20968;
        Wed, 15 Jan 2020 10:38:21 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 257691B20968
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 243EB1B21422;
        Wed, 15 Jan 2020 10:38:20 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 15 Jan 2020 10:38:20 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 15 Jan 2020 10:38:19 +0300
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
In-Reply-To: <129bf2bc-c0e9-02a3-7d40-0f7920803769@gmail.com>
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <20191230143028.27313-6-alobakin@dlink.ru>
 <ee6f83fd-edf4-5a98-9868-4cbe9e226b9b@gmail.com>
 <ed0ad0246c95a9ee87352d8ddbf0d4a1@dlink.ru>
 <CA+h21hoSoZT+ieaOu8N=MCSqkzey0L6HeoXSyLtHjZztT0S9ug@mail.gmail.com>
 <0002a7388dfd5fb70db4b43a6c521c52@dlink.ru>
 <CA+h21hqZoLrU7nL3Vo0KcmFnOxNxQPwoOVSEd6styyjK7XO+5w@mail.gmail.com>
 <129bf2bc-c0e9-02a3-7d40-0f7920803769@gmail.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <f04b112147bbe35f6e5c73d96c456bd4@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Fainelli wrote 15.01.2020 00:56:
> On 1/13/20 2:28 AM, Vladimir Oltean wrote:
>> On Mon, 13 Jan 2020 at 11:46, Alexander Lobakin <alobakin@dlink.ru> 
>> wrote:
>>> 
>>> Vladimir Oltean wrote 13.01.2020 12:42:
>>>> Hi Alexander,
>>>> 
>>>> On Mon, 13 Jan 2020 at 11:22, Alexander Lobakin <alobakin@dlink.ru>
>>>> wrote:
>>>>> 
>>>>> CPU ports can't be bridged anyway
>>>>> 
>>>>> Regards,
>>>>> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
>>>> 
>>>> The fact that CPU ports can't be bridged is already not ideal.
>>>> One can have a DSA switch with cascaded switches on each port, so it
>>>> acts like N DSA masters (not as DSA links, since the taggers are
>>>> incompatible), with each switch forming its own tree. It is 
>>>> desirable
>>>> that the ports of the DSA switch on top are bridged, so that
>>>> forwarding between cascaded switches does not pass through the CPU.
>>> 
>>> Oh, I see. But currently DSA infra forbids the adding DSA masters to
>>> bridges IIRC. Can't name it good or bad decision, but was introduced
>>> to prevent accidental packet flow breaking on DSA setups.
>>> 
>> 
>> I just wanted to point out that some people are going to be looking at
>> ways by which the ETH_P_XDSA handler can be made to play nice with the
>> master's rx_handler, and that it would be nice to at least not make
>> the limitation worse than it is by converting everything to
>> rx_handlers (which "currently" can't be stacked, from the comments in
>> netdevice.h).
> 
> I am not sure this would change the situation much, today we cannot 
> have
> anything but switch tags travel on the DSA master network device,
> whether we accomplish the RX tap through a special skb->protocol value
> or via rx_handler, it probably does not functionally matter, but it
> could change the performance.

As for now, I think that we should keep this RFC as it is so
developers working with different DSA switches could test it or
implement GRO offload for other taggers like DSA and EDSA, *but*
any future work on this should come only when we'll revise/reimagine
basic DSA packet flow, as we already know (at least me and Florian
reproduce it well) that the current path through unlikely branches
in eth_type_trans() and frame capturing through packet_type is so
suboptimal that nearly destroys overall performance on several
setups.
Switching to net_device::rx_handler() is just one of all the possible
variants, I'm sure we'll find the best solution together.

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
