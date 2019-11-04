Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E10EEB30
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfKDVeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:34:10 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10442 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfKDVeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 16:34:10 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc099520001>; Mon, 04 Nov 2019 13:34:10 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 04 Nov 2019 13:34:05 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 04 Nov 2019 13:34:05 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Nov
 2019 21:34:05 +0000
Subject: Re: [PATCH v2 05/18] mm/gup: introduce pin_user_pages*() and FOLL_PIN
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Jerome Glisse <jglisse@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
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
References: <20191103211813.213227-6-jhubbard@nvidia.com>
 <20191104173325.GD5134@redhat.com>
 <be9de35c-57e9-75c3-2e86-eae50904bbdf@nvidia.com>
 <20191104191811.GI5134@redhat.com>
 <e9656d47-b4a1-da8a-e8cc-ebcfb8cc06d6@nvidia.com>
 <20191104195248.GA7731@redhat.com>
 <25ec4bc0-caaa-2a01-2ae7-2d79663a40e1@nvidia.com>
 <20191104203153.GB7731@redhat.com> <20191104203702.GG30938@ziepe.ca>
 <d0890a8b-c349-0515-2570-10e83979836b@nvidia.com>
 <20191104211525.GJ30938@ziepe.ca>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <caaaaf52-490b-6ce1-81d8-675013354c73@nvidia.com>
Date:   Mon, 4 Nov 2019 13:34:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104211525.GJ30938@ziepe.ca>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572903250; bh=vbo/OzrYq7woOdeOQXzDRocZ8qkmDZ2GrWck8Ge0GIw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qKL2SABndBuE0IlTwGECBEmaXKNt9+NUVq+WFlqtOQFVTiU7nDI02BQTOx0obKarz
         gpxOM5Y6JautiKfOu0FtwOKOgDIpCUi5YMn9VF5RbTl9cVhlQsO6c44+kqa1Gmkh8J
         VEKyKNOG6Vqk5nkQbEsBguPgBI2Ja3iUp52oe4dwNevVkVV3ApvpTePgu21U23nzfu
         yfLLAmDkD5PCoZMaxqbgr1s6DM7hOxhvmTI1aiChbyJF4tpKtWS0fJG0BnHlBMS2gJ
         uFSIwTdydwTYYvW23EYrvHjEOYVqNSM3f00rEJ3//HPrJcaJAle1+bmyry6JSVv/h0
         e3DYAyiBVB40w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/19 1:15 PM, Jason Gunthorpe wrote:
...
>> Right, and I thought about this when converting, and realized that the above 
>> code is working around the current gup.c limitations, which are "cannot support
>> gup remote with FOLL_LONGTERM".
> 
> But AFAICT it doesn't have a problem, the protection test is just too
> strict, and I guess the control flow needs a bit of fixing..
> 
> The issue is this:
> 
> static __always_inline long __get_user_pages_locked():
> {
>         if (locked) {
>                 /* if VM_FAULT_RETRY can be returned, vmas become invalid */
>                 BUG_ON(vmas);
>                 /* check caller initialized locked */
>                 BUG_ON(*locked != 1);
>         }
> 
> 
> so remote could be written as:
> 
> if (gup_flags & FOLL_LONGTERM) {
>    if (WARN_ON_ONCE(locked))
>         return -EINVAL;
>    return __gup_longterm_locked(...)
> }
> 
> return __get_user_pages_locked(...)
> 
> ??

Yes, that loosens it up just enough for the vfio case (which doesn't set 
"locked") to get through, great! OK, I'll put that (the above plus 
corresponding vfio fix) in a separate patch first. 

This should clear things up nicely.


thanks,
-- 
John Hubbard
NVIDIA
