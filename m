Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C8A105C43
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfKUVui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:50:38 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8904 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfKUVuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:50:37 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd706a70001>; Thu, 21 Nov 2019 13:50:32 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 21 Nov 2019 13:50:35 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 21 Nov 2019 13:50:35 -0800
Received: from [10.2.168.213] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Nov
 2019 21:50:35 +0000
Subject: Re: [PATCH v7 02/24] mm/gup: factor out duplicate code from four
 routines
To:     Jan Kara <jack@suse.cz>
CC:     Christoph Hellwig <hch@lst.de>,
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
        Ira Weiny <ira.weiny@intel.com>,
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-3-jhubbard@nvidia.com> <20191121080356.GA24784@lst.de>
 <852f6c27-8b65-547b-89e0-e8f32a4d17b9@nvidia.com>
 <20191121094908.GB18190@quack2.suse.cz>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <ecd0a178-3890-5fad-2313-11b3df907f9f@nvidia.com>
Date:   Thu, 21 Nov 2019 13:47:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121094908.GB18190@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574373032; bh=kU5UGk7rYta5qBqyhgDE8hfKXijiGAD2NIzjPl1Hld4=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=DnacKCm2GFnxzRow8XHHjnv9A3uMI6LI6SiIGhg9bKcp76MqPQ8kF1M27y/KaRAbw
         xxowc8Q3DyiD2kAcAm0nQ17JpX8GvIrqJ8uSjriDnOLoj/h1UR33AwThcGRh+kdiFs
         sIZ9xwXRicfai3imhi7lfxcAqYrkI8TWeVUm4/7D0SDPmiW6FMWhSFSQx92VV4EoOz
         XFN+VtOdWxZk+dXcyMd50CRCI5bozfozwO/LAtNo36xbQ2gRR/BBiAeTLEx8hKdZSK
         Fx3jsqI8EasMtw1tkRf01vJb8NeCgZkxRIPz/M0TVfxHrLLklLoxP+jEnZwmUVejAC
         k2q6xFFz7w7hA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 1:49 AM, Jan Kara wrote:
> On Thu 21-11-19 00:29:59, John Hubbard wrote:
>> On 11/21/19 12:03 AM, Christoph Hellwig wrote:
>>> Otherwise this looks fine and might be a worthwhile cleanup to feed
>>> Andrew for 5.5 independent of the gut of the changes.
>>>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>
>>
>> Thanks for the reviews! Say, it sounds like your view here is that this
>> series should be targeted at 5.6 (not 5.5), is that what you have in mind?
>> And get the preparatory patches (1-9, and maybe even 10-16) into 5.5?
> 
> Yeah, actually I feel the same. The merge window is going to open on Sunday
> and the series isn't still fully baked and happily sitting in linux-next
> (and larger changes should really sit in linux-next for at least a week,
> preferably two, before the merge window opens to get some reasonable test
> coverage).  So I'd take out the independent easy patches that are already
> reviewed, get them merged into Andrew's (or whatever other appropriate
> tree) now so that they get at least a week of testing in linux-next before
> going upstream.  And the more involved bits will have to wait for 5.6 -
> which means let's just continue working on them as we do now because
> ideally in 4 weeks we should have them ready with all the reviews so that
> they can be picked up and integrated into linux-next.
> 
> 								Honza

OK, thanks for spelling it out. I'll shift over to getting the easy patches
prepared for 5.5, for now.

thanks,
-- 
John Hubbard
NVIDIA
