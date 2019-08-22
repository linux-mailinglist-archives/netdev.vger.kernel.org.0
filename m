Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3803799099
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfHVKVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfHVKVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:21:00 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85B685946B;
        Thu, 22 Aug 2019 10:20:59 +0000 (UTC)
Received: from [10.36.116.150] (ovpn-116-150.ams2.redhat.com [10.36.116.150])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BD3E600CD;
        Thu, 22 Aug 2019 10:20:57 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Magnus Karlsson" <magnus.karlsson@gmail.com>
Cc:     "Network Development" <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v4] libbpf: add xsk_ring_prod__nb_free() function
Date:   Thu, 22 Aug 2019 12:20:56 +0200
Message-ID: <E7EF70C8-4ECA-4B9B-9D43-657B826D52EC@redhat.com>
In-Reply-To: <CAJ8uoz1kQXgMUydktY3ci=8fjneUDW9B=qOGHzEQY1MvBThu8A@mail.gmail.com>
References: <d1773613833e2824f95c3adbe46bff757280c16e.1565790591.git.echaudro@redhat.com>
 <CAJ8uoz3MszznV7McpttcVauQ5vgSiOpfT7J=63BNbruVwjFQBQ@mail.gmail.com>
 <BC1D077F-1601-451D-A396-1C129B185DD3@redhat.com>
 <CAJ8uoz2v_48F6BuMkG7RPUymjQ2XL4hdPbeZu2R6SoarHSP47A@mail.gmail.com>
 <CAJ8uoz1kQXgMUydktY3ci=8fjneUDW9B=qOGHzEQY1MvBThu8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 22 Aug 2019 10:20:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21 Aug 2019, at 16:53, Magnus Karlsson wrote:

> On Wed, Aug 21, 2019 at 4:14 PM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
>>
>> On Wed, Aug 21, 2019 at 3:46 PM Eelco Chaudron <echaudro@redhat.com> 
>> wrote:
>>>
>>>
>>>
>>> On 21 Aug 2019, at 15:11, Magnus Karlsson wrote:
>>>
>>>> On Wed, Aug 14, 2019 at 3:51 PM Eelco Chaudron 
>>>> <echaudro@redhat.com>
>>>> wrote:
>>>>>
>>>>> When an AF_XDP application received X packets, it does not mean X
>>>>> frames can be stuffed into the producer ring. To make it easier 
>>>>> for
>>>>> AF_XDP applications this API allows them to check how many frames 
>>>>> can
>>>>> be added into the ring.
>>>>>
>>>>> The patch below looks like a name change only, but the xsk_prod__
>>>>> prefix denotes that this API is exposed to be used by 
>>>>> applications.
>>>>>
>>>>> Besides, if you set the nb value to the size of the ring, you will
>>>>> get the exact amount of slots available, at the cost of 
>>>>> performance
>>>>> (you touch shared state for sure). nb is there to limit the
>>>>> touching of the shared state.
>>>>>
>>>>> Also the example xdpsock application has been modified to use this
>>>>> new API, so it's also able to process flows at a 1pps rate on veth
>>>>> interfaces.
>
> 1 pps! That is not that impressive ;-).
>
>>>> My apologies for the late reply and thank you for working on this. 
>>>> So
>>>> what kind of performance difference do you see with your modified
>>>> xdpsock application on a regular NIC for txpush and l2fwd? If there 
>>>> is
>>>> basically no difference or it is faster, we can go ahead and accept
>>>> this. But if the difference is large, we might consider to have two
>>>> versions of txpush and l2fwd as the regular NICs do not need this. 
>>>> Or
>>>> we optimize your code so that it becomes as fast as the previous
>>>> version.
>>>
>>> For both operation modes, I ran 5 test with and without the changes
>>> applied using an iexgb connecting to a XENA tester. The throughput
>>> numbers were within the standard deviation, so no noticeable 
>>> performance
>>> gain or drop.
>>
>> Sounds good, but let me take your patches for a run on something
>> faster, just to make sure we are CPU bound. Will get back.
>
> I ran some experiments and with two cores (app on one, softirq on
> another) there is no impact since the application core has cycles to
> spare. But if you run it on a single core the drop is 1- 2% for l2fwd.
> I think this is ok since your version is a better example and more
> correct. Just note that your patch did not apply cleanly to bpf-next,
> so please rebase it, resubmit and I will ack it.

Just sent out a v5 which is a tested rebase on the latest bpf-next.


<SNIP>
