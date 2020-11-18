Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57642B8608
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgKRUvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:51:36 -0500
Received: from novek.ru ([213.148.174.62]:37186 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbgKRUvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:51:35 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A0AC5502C3D;
        Wed, 18 Nov 2020 23:51:43 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A0AC5502C3D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605732705; bh=ly0ArQZr/tdGMDOwRWGyTfdVDVIgyeYFdmB2LrvioLw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=EB9GSvMgX9p6naSfiyC7nk/WQycvAx0aJIladXff1RlgUsOdj6mWHXBSEVsQRrW56
         b8NfV0SK3Sjd3QPAt4ZXRN7z//fgSnt1Qw/owARktJJb9+KFe5srf1JnCFQeAqRh5S
         siPC5UpN0XzmTKqTpvg+kssulHZ9z4Rz7J4kr5zU=
Subject: Re: [net] net/tls: missing received data after fast remote close
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
References: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
 <20201117143847.2040f609@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <71f25f4d-a92c-8c56-da34-9d6f7f808c18@novek.ru>
 <20201117175344.2a29859a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <33ede124-583b-4bdd-621b-638bbca1a6c8@novek.ru>
 <20201118082336.6513c6c0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <3c3f9b9d-0fef-fb62-25f8-c9f17ec43a69@novek.ru>
Date:   Wed, 18 Nov 2020 20:51:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201118082336.6513c6c0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.11.2020 16:23, Jakub Kicinski wrote:
> On Wed, 18 Nov 2020 02:47:24 +0000 Vadim Fedorenko wrote:
>>>>>> This behavior differs from plain TCP socket and
>>>>>> leads to special treating in user-space. Patch unpauses parser
>>>>>> directly if we have unparsed data in tcp receive queue.
>>>>> Sure, but why is the parser paused? Does it pause itself on FIN?
>>>> No, it doesn't start even once. The trace looks like:
>>>>
>>>> tcp_recvmsg is called
>>>> tcp_recvmsg returns 1 (Change Cipher Spec record data)
>>>> tls_setsockopt is called
>>>> tls_setsockopt returns
>>>> tls_recvmsg is called
>>>> tls_recvmsg returns 0
>>>> __strp_recv is called
>>>> stack
>>>>            __strp_recv+1
>>>>            tcp_read_sock+169
>>>>            strp_read_sock+104
>>>>            strp_work+68
>>>>            process_one_work+436
>>>>            worker_thread+80
>>>>            kthread+276
>>>>            ret_from_fork+34tls_read_size called
>>>>
>>>> So it looks like strp_work was scheduled after tls_recvmsg and
>>>> nothing triggered parser because all the data was received before
>>>> tls_setsockopt ended the configuration process.
>>> Um. That makes me think we need to flush_work() on the strparser after
>>> we configure rx tls, no? Or __unpause at the right time instead of
>>> dealing with the async nature of strp_check_rcv()?
>> I'm not sure that flush_work() will do right way in this case. Because:
>> 1. The work is idle after tls_sw_strparser_arm()
> Not sure what you mean by idle, it queues the work via strp_check_rcv().
>
>> 2. The strparser needs socket lock to do it's work - that could be a
>> deadlock because setsockopt_conf already holds socket lock. I'm not
>> sure that it's a good idea to unlock socket just to wait the strparser.
> Ack, I meant in do_tls_setsockopt() after the lock is released.
>
>> The async nature of parser is OK for classic HTTPS server/client case
>> because it's very good to have parsed record before actual call to recvmsg
>> or splice_read is done. The code inside the loop in tls_wait_data is slow
>> path - maybe just move the check and the __unpause in this slow path?
> Yeah, looking closer this problem can arise after we start as well :/
>
> How about we move the __unparse code into the loop tho? Seems like this
> could help with latency. Right now AFAICT we get a TCP socket ready
> notification, which wakes the waiter for no good reason and makes
> strparser queue its work, the work then will call tls_queue() ->
> data_ready waking the waiting thread second time this time with the
> record actually parsed.
>
> Did I get that right? Should the waiter not cancel the work on the
> first wake up and just kick of the parsing itself?
I was thinking of the same solution too, but simple check of emptyness of
socket's receive queue is not working in case when we have partial record
in queue - __unpause will return without changing ctx->skb and still having
positive value in socket queue and we will have blocked loop until new data
is received or strp_abort_strp is fired because of timeout. If you could
suggest proper condition to break the loop it would be great.

Or probably I misunderstood what loop did you mean exactly?


