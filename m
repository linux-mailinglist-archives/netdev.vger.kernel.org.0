Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 018A210DB51
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 22:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfK2Vro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 16:47:44 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6093 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfK2Vro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 16:47:44 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de192010000>; Fri, 29 Nov 2019 13:47:46 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 29 Nov 2019 13:47:42 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 29 Nov 2019 13:47:42 -0800
Received: from [10.2.169.205] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Nov
 2019 21:47:41 +0000
Subject: Re: [PATCH v2 17/19] powerpc: book3s64: convert to pin_user_pages()
 and put_user_page()
To:     Jan Kara <jack@suse.cz>
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191125231035.1539120-1-jhubbard@nvidia.com>
 <20191125231035.1539120-18-jhubbard@nvidia.com>
 <20191129112315.GB1121@quack2.suse.cz>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <cb3e2acc-0a83-4053-fbcc-6d75dc47f174@nvidia.com>
Date:   Fri, 29 Nov 2019 13:44:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191129112315.GB1121@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575064066; bh=tMvn6asqZgJ/8yczcC9lnf1pHEf7TJzCvRVZqLzUEIk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=P515JTdy70KP3oimNK/fSAtObgW4JDQsh/LN+dj31w7qtgH6JUdGJYKS3j5J8enBM
         oN04vymJSqszX58P75QNc1cW3k/Ll0LB9zwNlmlBWaR7zw2qd7/o9t2Cy3EugW3wgY
         XBlQyEsBEMcfywkDPj201lclcvfOCs5gFzs/O+2QmSmHzciD31eTMBkNB0W6VGXEOL
         BbnrGM91l0GAwjLm+XJmL4eoGQAce5JVCz6FfueQA4/sc24hO2mmz2R1mloKHyP2Ej
         3q1StOVbP0t0OEBFEGay8puwUyC8jwyLEftGIYNcVrkaz5szmNasFETh2Ir0Xi5Q1g
         8xDwDUM/1ii9A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/19 3:23 AM, Jan Kara wrote:
> On Mon 25-11-19 15:10:33, John Hubbard wrote:
>> 1. Convert from get_user_pages() to pin_user_pages().
>>
>> 2. As required by pin_user_pages(), release these pages via
>> put_user_page(). In this case, do so via put_user_pages_dirty_lock().
>>
>> That has the side effect of calling set_page_dirty_lock(), instead
>> of set_page_dirty(). This is probably more accurate.
> 
> Maybe more accurate but it doesn't work for mm_iommu_unpin(). As I'm
> checking mm_iommu_unpin() gets called from RCU callback which is executed
> interrupt context and you cannot lock pages from such context. So you need
> to queue work from the RCU callback and then do the real work from the
> workqueue...
> 
> 								Honza

ah yes, fixed locally. (In order to avoid  distracting people during the merge
window, I won't post any more versions of the series until the merge window is
over, unless a maintainer tells me that any of these patches are desired for
5.5.)

With that, we are back to a one-line diff for this part:

@@ -215,7 +214,7 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_mem_t *mem)
                 if (mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY)
                         SetPageDirty(page);
  
-               put_page(page);
+               put_user_page(page);
                 mem->hpas[i] = 0;
         }
  }

btw, I'm also working on your feedback for patch 17 (mm/gup: track FOLL_PIN pages [1]),
from a few days earlier, it's not being ignored, I'm just trying to avoid distracting
people during the merge window.

[1] https://lore.kernel.org/r/20191121093941.GA18190@quack2.suse.cz

thanks,
-- 
John Hubbard
NVIDIA
