Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD225E094
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 11:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfGCJKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 05:10:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbfGCJKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 05:10:39 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5626B8AE4D;
        Wed,  3 Jul 2019 09:10:39 +0000 (UTC)
Received: from [10.36.116.85] (ovpn-116-85.ams2.redhat.com [10.36.116.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E3CAE5BBA4;
        Wed,  3 Jul 2019 09:10:37 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Magnus Karlsson" <magnus.karlsson@gmail.com>
Cc:     "Network Development" <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: add xsk_ring_prod__nb_free() function
Date:   Wed, 03 Jul 2019 11:10:30 +0200
Message-ID: <B0DB9024-43D8-4DBA-A588-15154B82D413@redhat.com>
In-Reply-To: <CAJ8uoz3BoLiM04WW=91wYryrVBqj5GDsL5mvDaAyBAv-6MNbsQ@mail.gmail.com>
References: <d4692ea57ba7a3fe33549fc6222fb8aea5a4225e.1561537968.git.echaudro@redhat.com>
 <CAJ8uoz3BoLiM04WW=91wYryrVBqj5GDsL5mvDaAyBAv-6MNbsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 03 Jul 2019 09:10:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28 Jun 2019, at 12:14, Magnus Karlsson wrote:

> On Wed, Jun 26, 2019 at 10:33 AM Eelco Chaudron <echaudro@redhat.com> 
> wrote:
>>
>> When an AF_XDP application received X packets, it does not mean X
>> frames can be stuffed into the producer ring. To make it easier for
>> AF_XDP applications this API allows them to check how many frames can
>> be added into the ring.
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>>
>> v1 -> v2
>>  - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
>>  - Add caching so it will only touch global state when needed
>>
>>  tools/lib/bpf/xsk.h | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
>> index 82ea71a0f3ec..6acb81102346 100644
>> --- a/tools/lib/bpf/xsk.h
>> +++ b/tools/lib/bpf/xsk.h
>> @@ -76,11 +76,11 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons 
>> *rx, __u32 idx)
>>         return &descs[idx & rx->mask];
>>  }
>>
>> -static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 
>> nb)
>> +static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 
>> nb)
>>  {
>>         __u32 free_entries = r->cached_cons - r->cached_prod;
>>
>> -       if (free_entries >= nb)
>> +       if (free_entries >= nb && nb != 0)
>>                 return free_entries;
>
> Thanks Eelco for the patch. Is the test nb != 0 introduced here so
> that the function will continue with the refresh from the global state
> when nb is set to 0? If so, could a user not instead just set the nb
> parameter to the size of the ring? This would always trigger a
> refresh, except when the number of free entries is equal to the size
> of the ring, but then we do not need the refresh anyway. This would
> eliminate the nb != 0 test that you introduced from the fast path.

Will remove this change from the fast path, and your suggestion can be 
used if circumvention of the cache is needed. Will sent out a v3 soon...

>>         /* Refresh the local tail pointer.
>> @@ -110,7 +110,7 @@ static inline __u32 xsk_cons_nb_avail(struct 
>> xsk_ring_cons *r, __u32 nb)
>>  static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod 
>> *prod,
>>                                             size_t nb, __u32 *idx)
>>  {
>> -       if (xsk_prod_nb_free(prod, nb) < nb)
>> +       if (xsk_prod__nb_free(prod, nb) < nb)
>>                 return 0;
>>
>>         *idx = prod->cached_prod;
>> --
>> 2.20.1
>>
