Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF191F04D4
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 19:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390682AbfKESQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 13:16:32 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11085 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390476AbfKESQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 13:16:31 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc1bc810000>; Tue, 05 Nov 2019 10:16:33 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 05 Nov 2019 10:16:27 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 05 Nov 2019 10:16:27 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Nov
 2019 18:16:25 +0000
Subject: Re: [PATCH 09/19] drm/via: set FOLL_PIN via pin_user_pages_fast()
To:     Ira Weiny <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-10-jhubbard@nvidia.com>
 <20191031233628.GI14771@iweiny-DESK2.sc.intel.com>
 <20191104181055.GP10326@phenom.ffwll.local>
 <48d22c77-c313-59ff-4847-bc9a9813b8a7@nvidia.com>
 <20191105094936.GZ10326@phenom.ffwll.local>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <9b9637f4-34e0-a665-a9c8-8fd59ff71063@nvidia.com>
Date:   Tue, 5 Nov 2019 10:16:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191105094936.GZ10326@phenom.ffwll.local>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572977793; bh=R0RxaBiDFTq2JKu4s4y6dD52czu96JnYA/nMzL9A6aE=;
        h=X-PGP-Universal:Subject:To:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ZSBhPlkU00U2SId5ohXT4qfb7S3CRfF2QxUJyZ0MYASa23SxluEpDZf1THjnsB9k6
         3RTrsq64bDaJH6/fLXRNFkXaPhRm5A6gkx6RZdlDie0bGzD/RBx0po9cAdeDcz/1hI
         lKGfT57a8xEYWihKfruZKPu2iv+9HpU34riNOb6hU1aeKe+Fw0TM0CdzQuEAMyVnn3
         zPBLdfbRqsxHTlb9Dt1LPnE+4oLXwLOgCALb/FxR0bVQqL9MMuMnHnx6cwBXcGJC2q
         423PWzhyAI/MHMUhEHpOr+pguDR21zYFt0jsH+WX73ZsVIDhQ9aKqbWLguXDJ6ZEPH
         qkWctNU3sUmkw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/19 1:49 AM, Daniel Vetter wrote:
> On Mon, Nov 04, 2019 at 11:20:38AM -0800, John Hubbard wrote:
>> On 11/4/19 10:10 AM, Daniel Vetter wrote:
>>> On Thu, Oct 31, 2019 at 04:36:28PM -0700, Ira Weiny wrote:
>>>> On Wed, Oct 30, 2019 at 03:49:20PM -0700, John Hubbard wrote:
>>>>> Convert drm/via to use the new pin_user_pages_fast() call, which sets
>>>>> FOLL_PIN. Setting FOLL_PIN is now required for code that requires
>>>>> tracking of pinned pages, and therefore for any code that calls
>>>>> put_user_page().
>>>>>
>>>>
>>>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>>>
>>> No one's touching the via driver anymore, so feel free to merge this
>>> through whatever tree suits best (aka I'll drop this on the floor and
>>> forget about it now).
>>>
>>> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>>
>>
>> OK, great. Yes, in fact, I'm hoping Andrew can just push the whole series
>> in through the mm tree, because that would allow it to be done in one 
>> shot, in 5.5
> 
> btw is there more? We should have a bunch more userptr stuff in various
> drivers, so was really surprised that drm/via is the only thing in your
> series.


There is more, but:

1) Fortunately, the opt-in nature of FOLL_PIN allows converting a few call
sites at a time. And so this patchset limits itself to converting the bare
minimum required to get started, which is: 

    a) calls sites that have already been converted to put_user_page(), 
       and

    b) call sites that set FOLL_LONGTERM.

So yes, follow-up patches will be required. This is not everything.
In fact, if I can fix this series up quickly enough that it makes it into
mmotm soon-ish, then there may be time to get some follow-patches on top
of it, in time for 5.5.


2) If I recall correctly, Jerome and maybe others are working to remove
as many get_user_pages() callers from drm as possible, and instead use
a non-pinned page approach, with mmu notifiers instead.  I'm not sure of
the exact status of that work, but I see that etnaviv, amdgpu, i915, and
radeon still call gup() in linux-next.

Anyway, some of those call sites will disappear. Although I'd expect a 
few to remain, because I doubt the simpler GPUs can support page faulting.



thanks,

John Hubbard
NVIDIA
