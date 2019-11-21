Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D36105CA3
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 23:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKUWZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 17:25:15 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14864 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfKUWZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 17:25:14 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd70ecc0001>; Thu, 21 Nov 2019 14:25:17 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 21 Nov 2019 14:25:13 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 21 Nov 2019 14:25:13 -0800
Received: from [10.2.168.213] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Nov
 2019 22:25:13 +0000
Subject: Re: [PATCH v7 05/24] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
To:     Dan Williams <dan.j.williams@intel.com>
CC:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
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
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, KVM list <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Netdev <netdev@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-6-jhubbard@nvidia.com> <20191121080555.GC24784@lst.de>
 <c5f8750f-af82-8aec-ce70-116acf24fa82@nvidia.com>
 <CAPcyv4jzDfxFAnAYc6g8Zz=3DweQFEBLBQyA_tSDP2Wy-RoA4A@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <461d6611-0cfb-dd13-f827-0db1ff8a9f2d@nvidia.com>
Date:   Thu, 21 Nov 2019 14:22:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jzDfxFAnAYc6g8Zz=3DweQFEBLBQyA_tSDP2Wy-RoA4A@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574375117; bh=D/eKIo+FJi5bpXqwJfXr6PJt8uCFLnCZclyeodxgmoA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=QiiyQjBd99PA4tfLyLMiUlQLWaGQU2+co6FamS71fAjNe7NqeNYDH8w7d2wRbOpAp
         FO2FB4fRVvM6b8p6VFBEfZcwYG6pgVEpA9JmE6+ROgRRGxXCqZY/+YxPczpJznwImd
         p6u80IPFPE4x/PJetPMB9IpPtmHNp690Ig3KD/FI3Pg1Spw0uK9yY10oBbvhOlh90u
         VDHu/ArBa3unFu4nkBBDe7Ce1Uz+1D/XrvQ7tfArBFBClI1tdcdtAK+LKBrbmv90AQ
         ydolBZYKkzfeBhYUC0ZjSrXWwqBfaUR0ElhSrvf057yQhGgjhUwUU8jj5KSdyTH5QE
         YNZVYalLmeVQg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 8:59 AM, Dan Williams wrote:
> On Thu, Nov 21, 2019 at 12:57 AM John Hubbard <jhubbard@nvidia.com> wrote:
>>
>> On 11/21/19 12:05 AM, Christoph Hellwig wrote:
>>> So while this looks correct and I still really don't see the major
>>> benefit of the new code organization, especially as it bloats all
>>> put_page callers.
>>>
>>> I'd love to see code size change stats for an allyesconfig on this
>>> commit.
>>>
>>
>> Right, I'm running that now, will post the results. (btw, if there is
>> a script and/or standard format I should use, I'm all ears. I'll dig
>> through lwn...)
>>
> 
> Just run:
> 
>      size vmlinux
> 

Beautiful. I thought it would involve a lot more. Here's results:

linux.git (Linux 5.4-rc8+):
==============================================
   text	   data	    bss	    dec	    hex	filename
227578032	213267935	76877984	517723951	1edbd72f	vmlinux


With patches 4 and 5 applied to linux.git:
==========================================
   text	   data	    bss	    dec	    hex	filename
229698560	213288379	76853408	519840347	1efc225b	vmlinux


Analysis:
=========

This increased the size of text by 0.93%. Which is a measurable bloat, so
the inlining really is undesirable here, yes. I'll do it differently.

thanks,
-- 
John Hubbard
NVIDIA
