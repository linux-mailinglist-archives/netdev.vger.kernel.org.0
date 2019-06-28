Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 127EF59969
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfF1LuL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 07:50:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfF1LuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:50:11 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D217688306;
        Fri, 28 Jun 2019 11:50:03 +0000 (UTC)
Received: from [10.36.116.200] (ovpn-116-200.ams2.redhat.com [10.36.116.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3A46608D0;
        Fri, 28 Jun 2019 11:49:45 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>, davem@davemloft.net,
        netdev@vger.kernel.org, "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Daniel Borkmann" <borkmann@iogearbox.net>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        xdp-newbies@vger.kernel.org
Subject: Re: XDP multi-buffer incl. jumbo-frames (Was: [RFC V1 net-next 1/1]
 net: ena: implement XDP drop support)
Date:   Fri, 28 Jun 2019 13:49:43 +0200
Message-ID: <5127F708-7CDD-4471-9767-D8C87DC23888@redhat.com>
In-Reply-To: <87y31m884a.fsf@toke.dk>
References: <20190623070649.18447-1-sameehj@amazon.com>
 <20190623070649.18447-2-sameehj@amazon.com> <20190623162133.6b7f24e1@carbon>
 <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com>
 <20190626103829.5360ef2d@carbon>
 <CC99D6DE-5B6B-42F3-8D68-7F9AFF1712FF@redhat.com> <87y31m884a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 28 Jun 2019 11:50:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28 Jun 2019, at 9:46, Toke Høiland-Jørgensen wrote:

> "Eelco Chaudron" <echaudro@redhat.com> writes:
>
>> On 26 Jun 2019, at 10:38, Jesper Dangaard Brouer wrote:
>>
>>> On Tue, 25 Jun 2019 03:19:22 +0000
>>> "Machulsky, Zorik" <zorik@amazon.com> wrote:
>>>
>>>> ﻿On 6/23/19, 7:21 AM, "Jesper Dangaard Brouer" 
>>>> <brouer@redhat.com>
>>>> wrote:
>>>>
>>>>     On Sun, 23 Jun 2019 10:06:49 +0300 <sameehj@amazon.com> wrote:
>>>>
>>>>     > This commit implements the basic functionality of drop/pass
>>>> logic in the
>>>>     > ena driver.
>>>>
>>>>     Usually we require a driver to implement all the XDP return
>>>> codes,
>>>>     before we accept it.  But as Daniel and I discussed with Zorik
>>>> during
>>>>     NetConf[1], we are going to make an exception and accept the
>>>> driver
>>>>     if you also implement XDP_TX.
>>>>
>>>>     As we trust that Zorik/Amazon will follow and implement
>>>> XDP_REDIRECT
>>>>     later, given he/you wants AF_XDP support which requires
>>>> XDP_REDIRECT.
>>>>
>>>> Jesper, thanks for your comments and very helpful discussion during
>>>> NetConf! That's the plan, as we agreed. From our side I would like 
>>>> to
>>>> reiterate again the importance of multi-buffer support by xdp 
>>>> frame.
>>>> We would really prefer not to see our MTU shrinking because of xdp
>>>> support.
>>>
>>> Okay we really need to make a serious attempt to find a way to 
>>> support
>>> multi-buffer packets with XDP. With the important criteria of not
>>> hurting performance of the single-buffer per packet design.
>>>
>>> I've created a design document[2], that I will update based on our
>>> discussions: [2]
>>> https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
>>>
>>> The use-case that really convinced me was Eric's packet 
>>> header-split.
>>>
>>>
>>> Lets refresh: Why XDP don't have multi-buffer support:
>>>
>>> XDP is designed for maximum performance, which is why certain
>>> driver-level
>>> use-cases were not supported, like multi-buffer packets (like
>>> jumbo-frames).
>>> As it e.g. complicated the driver RX-loop and memory model handling.
>>>
>>> The single buffer per packet design, is also tied into eBPF
>>> Direct-Access
>>> (DA) to packet data, which can only be allowed if the packet memory 
>>> is
>>> in
>>> contiguous memory.  This DA feature is essential for XDP 
>>> performance.
>>>
>>>
>>> One way forward is to define that XDP only get access to the first
>>> packet buffer, and it cannot see subsequent buffers.  For XDP_TX and
>>> XDP_REDIRECT to work then XDP still need to carry pointers (plus
>>> len+offset) to the other buffers, which is 16 bytes per extra 
>>> buffer.
>>
>>
>> I’ve seen various network processor HW designs, and they normally 
>> get
>> the first x bytes (128 - 512) which they can manipulate
>> (append/prepend/insert/modify/delete).
>>
>> There are designs where they can “page in” the additional 
>> fragments
>> but it’s expensive as it requires additional memory transfers. But 
>> the
>> majority do not care (cannot change) the remaining fragments. Can 
>> also
>> not think of a reason why you might want to remove something at the 
>> end
>> of the frame (thinking about routing/forwarding needs here).
>>
>> If we do want XDP to access other fragments we could do this through 
>> a
>> helper which swaps the packet context?
>
> Yeah, I was also going to suggest a helper for that. It doesn't
> necessarily need to swap the packet context, it could just return a 
> new
> pointer?

Yes that will work, my head was still thinking ASICs where there is 
limited SRAM space…
