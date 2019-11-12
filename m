Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED32F9D3F
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKLWnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:43:04 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6590 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLWnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 17:43:03 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcb353a0000>; Tue, 12 Nov 2019 14:42:02 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 14:42:58 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 12 Nov 2019 14:42:58 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 22:42:57 +0000
Subject: Re: [PATCH v3 08/23] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
To:     Jason Gunthorpe <jgg@ziepe.ca>
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191112000700.3455038-1-jhubbard@nvidia.com>
 <20191112000700.3455038-9-jhubbard@nvidia.com>
 <20191112204338.GE5584@ziepe.ca>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <0db36e86-b779-01af-77e7-469af2a2e19c@nvidia.com>
Date:   Tue, 12 Nov 2019 14:42:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191112204338.GE5584@ziepe.ca>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573598522; bh=Y5yk8f3O0SqpmKkLqVvRBWCkW319hAOZ+63Twi/leN0=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=k73DbqVF1ro4BGXqtoOXY8+RqyGGe2g09YDUx2SX8XytMdTG+dmOpX+jHtYX3sy0m
         jqRakpKDfOE8+KOF078kMgEWeRTrM64RVzrIc5oOooDxqIVboTzwD8VSvvTsbdqRvZ
         VUfhjLhHIl5v6iMhsEkxxPV8LaL6dE8RS69ywE4DWS3/QelSGNxpH0rJ4kmEm//y+p
         XXB4Gdx5hRr2SYYAicrcdd+BO7VysNir33yZ/MmfzzivcmZz0JpK+nUr9PhYe4icqS
         koYHksTWwDMw0phfipFOQbYisXKLuZUJMy7LSz/++6j9kUwwcPzjslXYFXKOkRwY0a
         JDLTwENrLW26A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/19 12:43 PM, Jason Gunthorpe wrote:
...
>> -		}
>> +	ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
>> +				    page, vmas, NULL);
>> +	/*
>> +	 * The lifetime of a vaddr_get_pfn() page pin is
>> +	 * userspace-controlled. In the fs-dax case this could
>> +	 * lead to indefinite stalls in filesystem operations.
>> +	 * Disallow attempts to pin fs-dax pages via this
>> +	 * interface.
>> +	 */
>> +	if (ret > 0 && vma_is_fsdax(vmas[0])) {
>> +		ret = -EOPNOTSUPP;
>> +		put_page(page[0]);
>>  	}
> 
> AFAIK this chunk is redundant now as it is some hack to emulate
> FOLL_LONGTERM? So vmas can be deleted too.

Let me first make sure I understand what Dan has in mind for the vma
checking, in the other thread...

> 
> Also unclear why this function has this:
> 
>         up_read(&mm->mmap_sem);
> 
>         if (ret == 1) {
>                 *pfn = page_to_pfn(page[0]);
>                 return 0;
>         }
> 
>         down_read(&mm->mmap_sem);
> 

Yes, that's really odd. It's not good to release and retake the lock
anyway in general (without re-checking things), and  certainly it is
not required to release mmap_sem in order to call page_to_pfn().

I've removed that up_read()/down_read() pair, for v4.


thanks,
-- 
John Hubbard
NVIDIA
