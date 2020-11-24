Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE732C339C
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 22:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388366AbgKXV6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 16:58:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:37058 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731696AbgKXV6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 16:58:08 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1khgK4-0007RJ-L4; Tue, 24 Nov 2020 22:58:04 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1khgK4-000Bqf-Fk; Tue, 24 Nov 2020 22:58:04 +0100
Subject: Re: [PATCH][V2] libbpf: add support for canceling cached_cons advance
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Li RongQing <lirongqing@baidu.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
References: <1606202474-8119-1-git-send-email-lirongqing@baidu.com>
 <CAJ8uoz0WNm6no8NRehgUH5RiGgvjJkKeD-Yyoah8xJerpLhgdg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fe9eeaa5-d40a-9be4-a96b-cdd80095da47@iogearbox.net>
Date:   Tue, 24 Nov 2020 22:58:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz0WNm6no8NRehgUH5RiGgvjJkKeD-Yyoah8xJerpLhgdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25998/Tue Nov 24 14:16:50 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/20 9:12 AM, Magnus Karlsson wrote:
> On Tue, Nov 24, 2020 at 8:33 AM Li RongQing <lirongqing@baidu.com> wrote:
>>
>> Add a new function for returning descriptors the user received
>> after an xsk_ring_cons__peek call. After the application has
>> gotten a number of descriptors from a ring, it might not be able
>> to or want to process them all for various reasons. Therefore,
>> it would be useful to have an interface for returning or
>> cancelling a number of them so that they are returned to the ring.
>>
>> This patch adds a new function called xsk_ring_cons__cancel that
>> performs this operation on nb descriptors counted from the end of
>> the batch of descriptors that was received through the peek call.
>>
>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>> [ Magnus Karlsson: rewrote changelog ]
>> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
>> ---
>> diff with v1: fix the building, and rewrote changelog
>>
>>   tools/lib/bpf/xsk.h | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
>> index 1069c46364ff..1719a327e5f9 100644
>> --- a/tools/lib/bpf/xsk.h
>> +++ b/tools/lib/bpf/xsk.h
>> @@ -153,6 +153,12 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
>>          return entries;
>>   }
>>
>> +static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons,
>> +                                        size_t nb)
>> +{
>> +       cons->cached_cons -= nb;
>> +}
>> +
>>   static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
>>   {
>>          /* Make sure data has been read before indicating we are done
>> --
>> 2.17.3
> 
> Thank you RongQing.
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

@Magnus: shouldn't the xsk_ring_cons__cancel() nb type be '__u32 nb' instead?

Thanks,
Daniel
