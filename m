Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F252C3D35
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 11:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgKYKHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 05:07:04 -0500
Received: from www62.your-server.de ([213.133.104.62]:60964 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgKYKHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 05:07:04 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1khrhT-00035U-Am; Wed, 25 Nov 2020 11:06:59 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1khrhT-000Fbj-4f; Wed, 25 Nov 2020 11:06:59 +0100
Subject: Re: [PATCH][V2] libbpf: add support for canceling cached_cons advance
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Li RongQing <lirongqing@baidu.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
References: <1606202474-8119-1-git-send-email-lirongqing@baidu.com>
 <CAJ8uoz0WNm6no8NRehgUH5RiGgvjJkKeD-Yyoah8xJerpLhgdg@mail.gmail.com>
 <fe9eeaa5-d40a-9be4-a96b-cdd80095da47@iogearbox.net>
 <CAJ8uoz1JdmHc9nwa4cY20S-GN62RAJUEPGY4LcmdTM4FjuGTow@mail.gmail.com>
 <aa4cdc17-1e54-7782-2b64-14d7a3ac892e@iogearbox.net>
 <CAJ8uoz2F3F_w8o1uBzOdxqy5Z1pcg4g4kqG22FnxrQ4+pY5UKg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <542d88a0-71c0-6d1f-e949-b375d0ac8369@iogearbox.net>
Date:   Wed, 25 Nov 2020 11:06:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz2F3F_w8o1uBzOdxqy5Z1pcg4g4kqG22FnxrQ4+pY5UKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25998/Tue Nov 24 14:16:50 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/20 10:13 AM, Magnus Karlsson wrote:
> On Wed, Nov 25, 2020 at 10:02 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 11/25/20 9:30 AM, Magnus Karlsson wrote:
>>> On Tue, Nov 24, 2020 at 10:58 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> On 11/24/20 9:12 AM, Magnus Karlsson wrote:
>>>>> On Tue, Nov 24, 2020 at 8:33 AM Li RongQing <lirongqing@baidu.com> wrote:
>>>>>>
>>>>>> Add a new function for returning descriptors the user received
>>>>>> after an xsk_ring_cons__peek call. After the application has
>>>>>> gotten a number of descriptors from a ring, it might not be able
>>>>>> to or want to process them all for various reasons. Therefore,
>>>>>> it would be useful to have an interface for returning or
>>>>>> cancelling a number of them so that they are returned to the ring.
>>>>>>
>>>>>> This patch adds a new function called xsk_ring_cons__cancel that
>>>>>> performs this operation on nb descriptors counted from the end of
>>>>>> the batch of descriptors that was received through the peek call.
>>>>>>
>>>>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>>>>> [ Magnus Karlsson: rewrote changelog ]
>>>>>> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
>>>>>> ---
>>>>>> diff with v1: fix the building, and rewrote changelog
>>>>>>
>>>>>>     tools/lib/bpf/xsk.h | 6 ++++++
>>>>>>     1 file changed, 6 insertions(+)
>>>>>>
>>>>>> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
>>>>>> index 1069c46364ff..1719a327e5f9 100644
>>>>>> --- a/tools/lib/bpf/xsk.h
>>>>>> +++ b/tools/lib/bpf/xsk.h
>>>>>> @@ -153,6 +153,12 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
>>>>>>            return entries;
>>>>>>     }
>>>>>>
>>>>>> +static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons,
>>>>>> +                                        size_t nb)
>>>>>> +{
>>>>>> +       cons->cached_cons -= nb;
>>>>>> +}
>>>>>> +
>>>>>>     static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
>>>>>>     {
>>>>>>            /* Make sure data has been read before indicating we are done
>>>>>> --
>>>>>> 2.17.3
>>>>>
>>>>> Thank you RongQing.
>>>>>
>>>>> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
>>>>
>>>> @Magnus: shouldn't the xsk_ring_cons__cancel() nb type be '__u32 nb' instead?
>>>
>>> All the other interfaces have size_t as the type for "nb". It is kind
>>> of weird as a __u32 would have made more sense, but cannot actually
>>> remember why I chose a size_t two years ago. But for consistency with
>>> the other interfaces, let us keep it a size_t for now. I will do some
>>> research around the reason.
>>
>> It's actually a bit of a mix currently which is what got me confused:
>>
>> static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
>> static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
>> static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod, size_t nb, __u32 *idx)
>> static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, size_t nb)
>> static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons, size_t nb, __u32 *idx)
>> static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
>>
>> (I can take it in as-is, but would be nice to clean it up a bit to avoid confusion.)
> 
> Hmm, that is confusing indeed. Well, the best choice would be __u32
> everywhere since the ring pointers themselves are __u32. But I am
> somewhat afraid of changing an API. Can we guarantee that a change
> from size_t to __u32 will not break some user's compilation? Another
> option would be to clean this up next year when we will very likely
> produce a 1.0 version of this API and at that point we can change some
> things. What do you think would be the best approach?

Given they're all inlines, imho, risk should be fairly low to switch all to __u32.
I would probably go and verify first with DPDK as main user of the lib and/or write
some test cases to see if compiler spills any new warnings and the like, but if not
the case then we should do it for bpf-next so this has plenty of exposure in the
meantime. Any nb large than u32 max is a bug in any case.

Thanks,
Daniel
