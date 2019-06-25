Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5B8525B7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 09:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfFYH65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 03:58:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbfFYH64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 03:58:56 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 996E2C1EB21B;
        Tue, 25 Jun 2019 07:58:50 +0000 (UTC)
Received: from [10.36.116.166] (ovpn-116-166.ams2.redhat.com [10.36.116.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CE665C22F;
        Tue, 25 Jun 2019 07:58:48 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, "Song Liu" <songliubraving@fb.com>,
        "Yonghong Song" <yhs@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: add xsk_ring_prod__free() function
Date:   Tue, 25 Jun 2019 09:58:47 +0200
Message-ID: <271605C0-55F6-45EA-A169-298B62911BEC@redhat.com>
In-Reply-To: <CAEf4Bzb7A5abJaxxrS5sudCE=Ca0C9rY0B23OjK8c2RCCx=Y6g@mail.gmail.com>
References: <49d3ddb42f531618584f60c740d9469e5406e114.1561130674.git.echaudro@redhat.com>
 <CAEf4BzZsmH+4A0dADeXYUDqeEK9N_-PVqzHW_=vPytjEX1hqTA@mail.gmail.com>
 <1C59E98E-7F4B-4FCA-AB95-68D3819C489C@redhat.com>
 <CAEf4Bzb7A5abJaxxrS5sudCE=Ca0C9rY0B23OjK8c2RCCx=Y6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 25 Jun 2019 07:58:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24 Jun 2019, at 18:42, Andrii Nakryiko wrote:

> On Mon, Jun 24, 2019 at 2:37 AM Eelco Chaudron <echaudro@redhat.com> 
> wrote:
>>
>>
>>
>> On 21 Jun 2019, at 21:13, Andrii Nakryiko wrote:
>>
>>> On Fri, Jun 21, 2019 at 8:26 AM Eelco Chaudron <echaudro@redhat.com>
>>> wrote:
>>>>
>>>> When an AF_XDP application received X packets, it does not mean X
>>>> frames can be stuffed into the producer ring. To make it easier for
>>>> AF_XDP applications this API allows them to check how many frames 
>>>> can
>>>> be added into the ring.
>>>>
>>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>>> ---
>>>>  tools/lib/bpf/xsk.h | 6 ++++++
>>>>  1 file changed, 6 insertions(+)
>>>>
>>>> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
>>>> index 82ea71a0f3ec..86f3d485e957 100644
>>>> --- a/tools/lib/bpf/xsk.h
>>>> +++ b/tools/lib/bpf/xsk.h
>>>> @@ -95,6 +95,12 @@ static inline __u32 xsk_prod_nb_free(struct
>>>> xsk_ring_prod *r, __u32 nb)
>>>>         return r->cached_cons - r->cached_prod;
>>>>  }
>>>>
>>>> +static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)
>>>
>>> This is a very bad name choice. __free is used for functions that 
>>> free
>>> memory and resources. One function below I see avail is used in the
>>> name, why not xsk_ring_prog__avail?
>>
>> Must agree that free sound like you are freeing entries… However, I
>> just kept the naming already in the API/file (see above,
>> xsk_prod_nb_free()).
>> Reading the code there is a difference as xx_avail() means available
>> filled entries, where xx_free() means available free entries.
>>
>> So I could rename it to xsk_ring_prod__nb_free() maybe?
>
> I'm fine with __nb_free, yes. Thanks!

Ok, will rework the patch and use xsk_ring_prod__nb_free(). Will also 
take Magnus suggestion into account, and create a cached version (and 
use it internally).

>>
>> Forgot to include Magnus in the email, so copied him in, for some
>> comments.
>>
>>>> +{
>>>> +       r->cached_cons = *r->consumer + r->size;
>>>> +       return r->cached_cons - r->cached_prod;
>>>> +}
>>>> +
>>>>  static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, 
>>>> __u32
>>>> nb)
>>>>  {
>>>>         __u32 entries = r->cached_prod - r->cached_cons;
>>>> --
>>>> 2.20.1
>>>>
