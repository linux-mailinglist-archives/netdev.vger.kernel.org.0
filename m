Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D806199309
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 12:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgCaKDH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 31 Mar 2020 06:03:07 -0400
Received: from zimbra.alphalink.fr ([217.15.80.77]:40458 "EHLO
        zimbra.alphalink.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729997AbgCaKDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 06:03:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id ACA0C2B520DD;
        Tue, 31 Mar 2020 12:03:04 +0200 (CEST)
Received: from zimbra.alphalink.fr ([127.0.0.1])
        by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id QsJh6RC0iwS9; Tue, 31 Mar 2020 12:03:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id B92B02B52068;
        Tue, 31 Mar 2020 12:03:02 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mail-2-cbv2.admin.alphalink.fr
Received: from zimbra.alphalink.fr ([127.0.0.1])
        by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0Nc3ZhpU5m_N; Tue, 31 Mar 2020 12:03:02 +0200 (CEST)
Received: from Simons-MacBook-Pro.local (94-84-15-217.reverse.alphalink.fr [217.15.84.94])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTPSA id 2B0662B520DE;
        Tue, 31 Mar 2020 12:03:02 +0200 (CEST)
Subject: Re: [PATCH net-next] pppoe: new ioctl to extract per-channel stats
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>
References: <20200326103230.121447-1-s.chopin@alphalink.fr>
 <CAK8P3a2THNOTcx=XMxXRH3RaNYBhsE7gMNx91M8p8D8qUdB-7A@mail.gmail.com>
 <c70371c2-7783-b66a-3108-dbbda383673d@alphalink.fr>
 <CAK8P3a2oWT2yob76QQHDm0z7z6xcVoRDEejj7ro4heQYyWGQ3A@mail.gmail.com>
From:   Simon Chopin <s.chopin@alphalink.fr>
Message-ID: <ce76fc46-74d4-e809-aebd-8c1d44782d86@alphalink.fr>
Date:   Tue, 31 Mar 2020 12:03:01 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2oWT2yob76QQHDm0z7z6xcVoRDEejj7ro4heQYyWGQ3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Arnd,

Le 26/03/2020 à 15:31, Arnd Bergmann a écrit :
> On Thu, Mar 26, 2020 at 2:48 PM Simon Chopin <s.chopin@alphalink.fr> wrote:
>> Le 26/03/2020 à 11:42, Arnd Bergmann a écrit :
>>> The patch looks fine from from an interface design perspective,
>>> but I wonder if you could use a definition that matches the
>>> structure layout and command number for PPPIOCGL2TPSTATS
>>> exactly, rather than a "very similar mechanism" with a subset
>>> of the fields. You would clearly have to pass down a number of
>>> zero fields, but the implementation could be abstracted at a
>>> higher level later.
>>>
>>>       Arnd
>>
>> This sounds like a good idea, indeed. Is what follows what you had in mind ?
>> I'm not too sure about keeping the chan_priv field in this form, my knowledge
>> of alignment issues being relatively superficial. As I understand it, the matching
>> fields in l2tp_ioc_stats should always be packed to 8 bytes as they fall on natural
>> boundaries, but I might be wrong ?
>>
>> diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
>> index a0abc68eceb5..803cbe374fb2 100644
>> --- a/include/uapi/linux/ppp-ioctl.h
>> +++ b/include/uapi/linux/ppp-ioctl.h
>> @@ -79,14 +79,21 @@ struct pppol2tp_ioc_stats {
>>         __aligned_u64   rx_errors;
>>  };
>>
>> -/* For PPPIOCGPPPOESTATS */
>> -struct pppoe_ioc_stats {
>> +struct pppchan_ioc_stats {
>> +       __u8            chan_priv[8];
>>         __aligned_u64   tx_packets;
>>         __aligned_u64   tx_bytes;
>> +       __aligned_u64   tx_errors;
>>         __aligned_u64   rx_packets;
>>         __aligned_u64   rx_bytes;
>> +       __aligned_u64   rx_seq_discards;
>> +       __aligned_u64   rx_oos_packets;
>> +       __aligned_u64   rx_errors;
>>  };
>>
>> +_Static_assert(sizeof(struct pppol2tp_ioc_stats) == sizeof(struct pppchan_ioc_stats), "same size");
>> +_Static_assert((size_t)&((struct pppol2tp_ioc_stats *)0)->tx_packets == (size_t)&((struct pppchan_ioc_stats *)0)->tx_packets, "same offset");
> 
> Conceptually this is what I had in mind, but implementation-wise, I'd suggest
> only having a single structure definition, possibly with a #define like
> 
> #define pppoe_ioc_stats pppchan_ioc_stats
I'm assuming that'd be #define pppol2tp_stats pppchan_ioc_stats ?
> When having two struct definitions, I'd be slightly worried about
> the bitfield causing implementation-defined structure layout,
> so it seems better to only have one definition, even when you cannot
> avoid the bitfield that maybe should not have been used.
>
>>  /*
>>   * Ioctl definitions.
>>   */
>> @@ -123,7 +130,7 @@ struct pppoe_ioc_stats {
>>  #define PPPIOCATTCHAN  _IOW('t', 56, int)      /* attach to ppp channel */
>>  #define PPPIOCGCHAN    _IOR('t', 55, int)      /* get ppp channel number */
>>  #define PPPIOCGL2TPSTATS _IOR('t', 54, struct pppol2tp_ioc_stats)
>> -#define PPPIOCGPPPOESTATS _IOR('t', 53, struct pppoe_ioc_stats)
>> +#define PPPIOCGCHANSTATS _IOR('t', 54, struct pppchan_ioc_stats)
> 
> here I'd do
> 
> #define PPPIOCGCHANSTATS _IOR('t', 54, struct pppchan_ioc_stats)
> #define PPPIOCGL2TPSTATS PPPIOCGCHANSTATS

Thank you for your feedback. I'm probably going to implement a more
generic version at the generic PPP channel instead, though, as,
as noted by Guillaume, those statistics are not for the PPP channel
but for the layer underneath.

However, I'd like to be sure I understand your proposal here :
we'd use a generic pppchan_ioc_stats struct that would be identical
to the current pppol2tp_ioc_stats, including the 3 L2TP-specific fields,
so that we'd retain ABI and API compatibility, and we would simply
#define the current API to the new one?

Cheers,
Simon
