Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E86D126F88
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLSVQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:16:47 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10406 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLSVQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:16:46 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfbe8b30000>; Thu, 19 Dec 2019 13:16:35 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 19 Dec 2019 13:16:45 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 19 Dec 2019 13:16:45 -0800
Received: from [10.2.165.11] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 21:16:42 +0000
Subject: Re: [PATCH v11 00/25] mm/gup: track dma-pinned pages: FOLL_PIN
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191219132607.GA410823@unreal>
 <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
 <20191219210743.GN17227@ziepe.ca>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <42a3e5c1-6301-db0b-5d09-212edf5ecf2a@nvidia.com>
Date:   Thu, 19 Dec 2019 13:13:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191219210743.GN17227@ziepe.ca>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576790195; bh=e+stzM4MKJvMbnHvF2MQtGYZPTDUXmhAC++H/dKblxU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=DpAgGRtLU03goQ45lwT7ONh8PGmHo2uEl58mvIXxDE1nHXoSem5kfykU7etb/JcJL
         /yvdQuNedqWs+SUfVSLa4E60NrM+DSMnCAe2ItTu7yCQ5BHkbAsDg8Mpyow9MA1pYC
         3jVYe0GuNI9xJv3hjbBlrnChECIJB3Q5siLf6V5xGWCqbhXjMLlDdPH405dRvVKPVH
         0B/YfWOP+8DomZJl09OCXT8zLxeag4uByq64+u082UEQpj/kDFhFOsIPO4HgJs9I5d
         GI+vJAY5OMeBcbGVYpOeSe0O73rRuIYou0nCs6Mvptf4ghAI7UtlU7flZFGsoZAujM
         ZE4962uBaaz9A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/19 1:07 PM, Jason Gunthorpe wrote:
> On Thu, Dec 19, 2019 at 12:30:31PM -0800, John Hubbard wrote:
>> On 12/19/19 5:26 AM, Leon Romanovsky wrote:
>>> On Mon, Dec 16, 2019 at 02:25:12PM -0800, John Hubbard wrote:
>>>> Hi,
>>>>
>>>> This implements an API naming change (put_user_page*() -->
>>>> unpin_user_page*()), and also implements tracking of FOLL_PIN pages. It
>>>> extends that tracking to a few select subsystems. More subsystems will
>>>> be added in follow up work.
>>>
>>> Hi John,
>>>
>>> The patchset generates kernel panics in our IB testing. In our tests, we
>>> allocated single memory block and registered multiple MRs using the single
>>> block.
>>>
>>> The possible bad flow is:
>>>    ib_umem_geti() ->
>>>     pin_user_pages_fast(FOLL_WRITE) ->
>>>      internal_get_user_pages_fast(FOLL_WRITE) ->
>>>       gup_pgd_range() ->
>>>        gup_huge_pd() ->
>>>         gup_hugepte() ->
>>>          try_grab_compound_head() ->
>>
>> Hi Leon,
>>
>> Thanks very much for the detailed report! So we're overflowing...
>>
>> At first look, this seems likely to be hitting a weak point in the
>> GUP_PIN_COUNTING_BIAS-based design, one that I believed could be deferred
>> (there's a writeup in Documentation/core-api/pin_user_page.rst, lines
>> 99-121). Basically it's pretty easy to overflow the page->_refcount
>> with huge pages if the pages have a *lot* of subpages.
>>
>> We can only do about 7 pins on 1GB huge pages that use 4KB subpages.
> 
> Considering that establishing these pins is entirely under user
> control, we can't have a limit here.

There's already a limit, it's just a much larger one. :) What does "no limit"
really mean, numerically, to you in this case?

> 
> If the number of allowed pins are exhausted then the
> pin_user_pages_fast() must fail back to the user.


I'll poke around the IB call stack and see how much of that return path
is in place, if any. Because it's the same situation for get_user_pages_fast().
This code just added a warning on overflow so we could spot it early.

> 
>> 3. It would be nice if I could reproduce this. I have a two-node mlx5 Infiniband
>> test setup, but I have done only the tiniest bit of user space IB coding, so
>> if you have any test programs that aren't too hard to deal with that could
>> possibly hit this, or be tweaked to hit it, I'd be grateful. Keeping in mind
>> that I'm not an advanced IB programmer. At all. :)
> 
> Clone this:
> 
> https://github.com/linux-rdma/rdma-core.git
> 
> Install all the required deps to build it (notably cython), see the README.md
> 
> $ ./build.sh
> $ build/bin/run_tests.py
> 
> If you get things that far I think Leon can get a reproduction for you
> 

OK, here goes.

thanks,
-- 
John Hubbard
NVIDIA
