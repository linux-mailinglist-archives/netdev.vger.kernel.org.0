Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396FB2B7452
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgKRCrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:47:31 -0500
Received: from novek.ru ([213.148.174.62]:50840 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgKRCra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 21:47:30 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id BFFF4502C3D;
        Wed, 18 Nov 2020 05:47:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru BFFF4502C3D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605667659; bh=74yBwqYc+gDVhID6MkFMazkdiOhm4869LFqVujhQqys=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TKBr4hSxS4ikScZPOGAc1ngRrGrkrW080YwiNBPcrEl4hdAN8GEoeZ+DFUXYtX7Ia
         o6f69AQXsqESsN3xwTyTRrhLr2Y/rBp3a4ewc0nfqsdyCV/zboJjV6n9vAndFkoUJS
         x/pAAGknLkAEKyjwyOpmRQ/3FMYtTHvXj3nQHrhM=
Subject: Re: [net] net/tls: missing received data after fast remote close
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
References: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
 <20201117143847.2040f609@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <71f25f4d-a92c-8c56-da34-9d6f7f808c18@novek.ru>
 <20201117175344.2a29859a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <33ede124-583b-4bdd-621b-638bbca1a6c8@novek.ru>
Date:   Wed, 18 Nov 2020 02:47:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201117175344.2a29859a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.11.2020 01:53, Jakub Kicinski wrote:
> On Wed, 18 Nov 2020 00:50:48 +0000 Vadim Fedorenko wrote:
>> On 17.11.2020 22:38, Jakub Kicinski wrote:
>>> On Sun, 15 Nov 2020 14:43:48 +0300 Vadim Fedorenko wrote:
>>>> In case when tcp socket received FIN after some data and the
>>>> parser haven't started before reading data caller will receive
>>>> an empty buffer.
>>> This is pretty terse, too terse for me to understand..
>> The flow is simple. Server sends small amount of data right after the
>> connection is configured and closes the connection. In this case
>> receiver sees TLS Handshake data, configures TLS socket right after
>> Change Cipher Spec record. While the configuration is in process, TCP
>> socket receives small Application Data record, Encrypted Alert record
>> and FIN packet. So the TCP socket changes sk_shutdown to RCV_SHUTDOWN
>> and sk_flag with SK_DONE bit set.
> Thanks! That's clear. This is a race, right, you can't trigger
> it reliably?
It is triggered in the test cases usually but nit always. To trigger
this problem always I just add some delay before setsockopt() call.
This delay leaves sometime for kernel to receive all the data from
sender in test case.
> BTW please feel free to add your cases to the tls selftest in
> tools/testing/selftests.
Sure, will add this case in selftests.
>
>>>> This behavior differs from plain TCP socket and
>>>> leads to special treating in user-space. Patch unpauses parser
>>>> directly if we have unparsed data in tcp receive queue.
>>> Sure, but why is the parser paused? Does it pause itself on FIN?
>> No, it doesn't start even once. The trace looks like:
>>
>> tcp_recvmsg is called
>> tcp_recvmsg returns 1 (Change Cipher Spec record data)
>> tls_setsockopt is called
>> tls_setsockopt returns
>> tls_recvmsg is called
>> tls_recvmsg returns 0
>> __strp_recv is called
>> stack
>>           __strp_recv+1
>>           tcp_read_sock+169
>>           strp_read_sock+104
>>           strp_work+68
>>           process_one_work+436
>>           worker_thread+80
>>           kthread+276
>>           ret_from_fork+34tls_read_size called
>>
>> So it looks like strp_work was scheduled after tls_recvmsg and
>> nothing triggered parser because all the data was received before
>> tls_setsockopt ended the configuration process.
> Um. That makes me think we need to flush_work() on the strparser after
> we configure rx tls, no? Or __unpause at the right time instead of
> dealing with the async nature of strp_check_rcv()?
I'm not sure that flush_work() will do right way in this case. Because:
1. The work is idle after tls_sw_strparser_arm()
2. The strparser needs socket lock to do it's work - that could be a
deadlock because setsockopt_conf already holds socket lock. I'm not
sure that it's a good idea to unlock socket just to wait the strparser.

The async nature of parser is OK for classic HTTPS server/client case
because it's very good to have parsed record before actual call to recvmsg
or splice_read is done. The code inside the loop in tls_wait_data is slow
path - maybe just move the check and the __unpause in this slow path?
