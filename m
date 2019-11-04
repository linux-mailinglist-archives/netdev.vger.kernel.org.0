Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CABEE92D
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 21:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbfKDUJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 15:09:10 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3877 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbfKDUJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 15:09:09 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc085690000>; Mon, 04 Nov 2019 12:09:14 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 04 Nov 2019 12:09:07 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 04 Nov 2019 12:09:07 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Nov
 2019 20:09:05 +0000
Subject: Re: [PATCH v2 05/18] mm/gup: introduce pin_user_pages*() and FOLL_PIN
To:     Jerome Glisse <jglisse@redhat.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-6-jhubbard@nvidia.com>
 <20191104173325.GD5134@redhat.com>
 <be9de35c-57e9-75c3-2e86-eae50904bbdf@nvidia.com>
 <20191104191811.GI5134@redhat.com>
 <e9656d47-b4a1-da8a-e8cc-ebcfb8cc06d6@nvidia.com>
 <20191104195248.GA7731@redhat.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <25ec4bc0-caaa-2a01-2ae7-2d79663a40e1@nvidia.com>
Date:   Mon, 4 Nov 2019 12:09:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104195248.GA7731@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572898154; bh=AZ3ymuIlfRc3w4rthQkiIY3Jv3VQvtZMfCQrByMbt/I=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=a1s4cFm/krClFLPv0/gGIzoAubroBwrxV++jio7G263hv7Kqd894mJLgyr0Kykvfu
         E22eZRsWgS82IfVuknmQjT6loOqA9gwu9uWFSuwxGjrMpxiVLz3gspis/scqyrUM8C
         V6nOQNjxdOZQpCSi9tZuwj/NT7Qad5kYkY0U2dz2agukymc6b2UDmCgdrtVLwMy+f3
         QtSOoNDJwHdTVrVqqJcnOKhTpEZCUMCLI/PJyjZAopcsX3CoJLmMWVSKvLvEBN88aE
         +2SZRTKEAYlSxIg6b9bcQPtRuIkgnhRasSHve+6EqdhZWTSQoe8j4euTWFVlDE/iaG
         Y8A3JNrgij6ag==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason, a question for you at the bottom.

On 11/4/19 11:52 AM, Jerome Glisse wrote:
...
>> CASE 3: ODP
>> -----------
>> RDMA hardware with page faulting support. Here, a well-written driver doesn't
> 
> CASE3: Hardware with page fault support
> ---------------------------------------
> 
> Here, a well-written ....
> 

Ah, OK. So just drop the first sentence, yes.

...
>>>>>> +	 */
>>>>>> +	gup_flags |= FOLL_REMOTE | FOLL_PIN;
>>>>>
>>>>> Wouldn't it be better to not add pin_longterm_pages_remote() until
>>>>> it can be properly implemented ?
>>>>>
>>>>
>>>> Well, the problem is that I need each call site that requires FOLL_PIN
>>>> to use a proper wrapper. It's the FOLL_PIN that is the focus here, because
>>>> there is a hard, bright rule, which is: if and only if a caller sets
>>>> FOLL_PIN, then the dma-page tracking happens, and put_user_page() must
>>>> be called.
>>>>
>>>> So this leaves me with only two reasonable choices:
>>>>
>>>> a) Convert the call site as above: pin_longterm_pages_remote(), which sets
>>>> FOLL_PIN (the key point!), and leaves the FOLL_LONGTERM situation exactly
>>>> as it has been so far. When the FOLL_LONGTERM situation is fixed, the call
>>>> site *might* not need any changes to adopt the working gup.c code.
>>>>
>>>> b) Convert the call site to pin_user_pages_remote(), which also sets
>>>> FOLL_PIN, and also leaves the FOLL_LONGTERM situation exactly as before.
>>>> There would also be a comment at the call site, to the effect of, "this
>>>> is the wrong call to make: it really requires FOLL_LONGTERM behavior".
>>>>
>>>> When the FOLL_LONGTERM situation is fixed, the call site will need to be
>>>> changed to pin_longterm_pages_remote().
>>>>
>>>> So you can probably see why I picked (a).
>>>
>>> But right now nobody has FOLL_LONGTERM and FOLL_REMOTE. So you should
>>> never have the need for pin_longterm_pages_remote(). My fear is that
>>> longterm has implication and it would be better to not drop this implication
>>> by adding a wrapper that does not do what the name says.
>>>
>>> So do not introduce pin_longterm_pages_remote() until its first user
>>> happens. This is option c)
>>>
>>
>> Almost forgot, though: there is already another user: Infiniband:
>>
>> drivers/infiniband/core/umem_odp.c:646:         npages = pin_longterm_pages_remote(owning_process, owning_mm,
> 
> odp do not need that, i thought the HMM convertion was already upstream
> but seems not, in any case odp do not need the longterm case it only
> so best is to revert that user to gup_fast or something until it get
> converted to HMM.
> 

Note for Jason: the (a) or (b) items are talking about the vfio case, which is
one of the two call sites that now use pin_longterm_pages_remote(), and the
other one is infiniband:

drivers/infiniband/core/umem_odp.c:646:         npages = pin_longterm_pages_remote(owning_process, owning_mm,
drivers/vfio/vfio_iommu_type1.c:353:            ret = pin_longterm_pages_remote(NULL, mm, vaddr, 1,


Jerome, Jason: I really don't want to revert the put_page() to put_user_page() 
conversions that are already throughout the IB driver--pointless churn, right?
I'd rather either delete them in Jason's tree, or go with what I have here
while waiting for the deletion.

Maybe we should just settle on (a) or (b), so that the IB driver ends up with
the wrapper functions? In fact, if it's getting deleted, then I'd prefer leaving
it at (a), since that's simple...

Jason should weigh in on how he wants this to go, with respect to branching
and merging, since it sounds like that will conflict with the hmm branch 
(ha, I'm overdue in reviewing his mmu notifier series, that's what I get for
being late).

thanks,

John Hubbard
NVIDIA
