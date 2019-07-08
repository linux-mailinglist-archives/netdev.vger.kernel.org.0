Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9D561C0D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbfGHJDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:03:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727352AbfGHJDB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 05:03:01 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DECE981F25;
        Mon,  8 Jul 2019 09:02:59 +0000 (UTC)
Received: from [10.36.116.197] (ovpn-116-197.ams2.redhat.com [10.36.116.197])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C19E608A4;
        Mon,  8 Jul 2019 09:02:56 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Magnus Karlsson" <magnus.karlsson@gmail.com>
Cc:     "Daniel Borkmann" <daniel@iogearbox.net>,
        "Network Development" <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: add xsk_ring_prod__nb_free() function
Date:   Mon, 08 Jul 2019 11:02:55 +0200
Message-ID: <657FF257-B598-4AF6-8ADB-775424A893E1@redhat.com>
In-Reply-To: <CAJ8uoz0LjXMaVgnf7_UkfRwN2Dx11m1Th5FXyf1vgGWDd5Tswg@mail.gmail.com>
References: <ea49f66f73aedcdade979605dab6b2474e2dc4cb.1562145300.git.echaudro@redhat.com>
 <c86151f8-9a16-d2e4-a888-d0836ff3c10a@iogearbox.net>
 <CAJ8uoz0LjXMaVgnf7_UkfRwN2Dx11m1Th5FXyf1vgGWDd5Tswg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 08 Jul 2019 09:03:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6 Jul 2019, at 11:57, Magnus Karlsson wrote:

> On Fri, Jul 5, 2019 at 4:35 PM Daniel Borkmann <daniel@iogearbox.net> 
> wrote:
>>
>> On 07/03/2019 02:52 PM, Eelco Chaudron wrote:
>>> When an AF_XDP application received X packets, it does not mean X
>>> frames can be stuffed into the producer ring. To make it easier for
>>> AF_XDP applications this API allows them to check how many frames 
>>> can
>>> be added into the ring.
>>>
>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>
>> The commit log as it is along with the code is a bit too confusing 
>> for
>> readers. After all you only do a rename below. It would need to 
>> additionally
>> state that the rename is as per libbpf convention (xyz__ prefix) in 
>> order to
>> denote that this API is exposed to be used by applications.
>>
>> Given you are doing this for xsk_prod_nb_free(), should we do the 
>> same for
>> xsk_cons_nb_avail() as well? Extending XDP sample app would be 
>> reasonable
>> addition as well in this context.
>
> Sorry for the late reply Eelco. My e-mail filter is apparently not set
> up correctly since it does not catch mails where I am on the CC line.
> Will fix.
>
> At the same time you are rewording the commit log according to
> Daniel's suggestion, could you please also add a line or two
> explaining how to use the nb parameter? If you set it to the size of
> the ring, you will get the exact amount of slots available, at the
> cost of performance (you touch shared state for sure). nb is there to
> limit the touching of shared state. The same kind of comment in the
> header file would be great too.

Will do this and change the example to use this new function, so it will 
work when sending single packets to it.

I’m on PTO in two days, so will do this once I’m back rather than 
try to rush it in.

>
> Have you found any use of the  xsk_cons_nb_avail() function from your
> sample application? If so, let us add it to the public API.

The problem is the xsk_ring_prod__reserve() API, it return 0 if the 
available nb’s < requested nb’s. So in order to reserve enough slots 
we have frame buffers available we need to know how many slots are 
available, hence we need the __nb_fee() function.

For the related xsk_ring_cons__peek() function we do not need this, as 
it will return the available entries requested or less.

>
> Thanks: Magnus
>
>>> ---
>>>
>>> v2 -> v3
>>>  - Removed cache by pass option
>>>
>>> v1 -> v2
>>>  - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
>>>  - Add caching so it will only touch global state when needed
>>>
>>>  tools/lib/bpf/xsk.h | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
>>> index 82ea71a0f3ec..3411556e04d9 100644
>>> --- a/tools/lib/bpf/xsk.h
>>> +++ b/tools/lib/bpf/xsk.h
>>> @@ -76,7 +76,7 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons 
>>> *rx, __u32 idx)
>>>       return &descs[idx & rx->mask];
>>>  }
>>>
>>> -static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 
>>> nb)
>>> +static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, 
>>> __u32 nb)
>>>  {
>>>       __u32 free_entries = r->cached_cons - r->cached_prod;
>>>
>>> @@ -110,7 +110,7 @@ static inline __u32 xsk_cons_nb_avail(struct 
>>> xsk_ring_cons *r, __u32 nb)
>>>  static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod 
>>> *prod,
>>>                                           size_t nb, __u32 *idx)
>>>  {
>>> -     if (xsk_prod_nb_free(prod, nb) < nb)
>>> +     if (xsk_prod__nb_free(prod, nb) < nb)
>>>               return 0;
>>>
>>>       *idx = prod->cached_prod;
>>>
>>
