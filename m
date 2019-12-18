Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B5125681
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLRWSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:18:50 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8926 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfLRWSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 17:18:47 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfaa5ba0000>; Wed, 18 Dec 2019 14:18:34 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 18 Dec 2019 14:18:44 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 18 Dec 2019 14:18:44 -0800
Received: from [10.2.165.11] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Dec
 2019 22:18:43 +0000
Subject: Re: [PATCH v11 01/25] mm/gup: factor out duplicate code from four
 routines
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
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
        Christoph Hellwig <hch@lst.de>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191216222537.491123-2-jhubbard@nvidia.com>
 <20191218155211.emcegdp5uqgorfwe@box>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <5719efc4-e560-b3d9-8d1f-3ae289bed289@nvidia.com>
Date:   Wed, 18 Dec 2019 14:15:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191218155211.emcegdp5uqgorfwe@box>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576707514; bh=A0thRHEqnXg6dZZRQ3XItHq709pByy7GtW01Hq1OCoc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ScM+7x8q8mWlcIQciYsHkNMCacR+c0EXHDYwd9LQIuUPf7aoJ2FVBW026iU1SWAnl
         ltogqGk6aIee+Km4SQR7f32cksncAyW4lNLn2TYKFrtJdbIHsrOldxBh5IaPhHdDqE
         sdIpDxyyx+Jf8CyjrZWs/sYEpgdFVpjkjtWEpt4nJp1e7SjqwB5Cu2GqZfKBuKVEar
         BRhkAV/MDLjwytEs34akliPwG7VvslpNx0c0XwWMRq9z3Nwumj3m+z4SVir8YPvZEf
         vV7cvsqLQ3VGt46WIl4RoFGnV1Qa4B1dL2lodfVBrgXk2TIEVopJfv3Sggeyd8NtB5
         Kn8oXib8wW5/w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/19 7:52 AM, Kirill A. Shutemov wrote:
> On Mon, Dec 16, 2019 at 02:25:13PM -0800, John Hubbard wrote:
>> +static void put_compound_head(struct page *page, int refs)
>> +{
>> +	/* Do a get_page() first, in case refs == page->_refcount */
>> +	get_page(page);
>> +	page_ref_sub(page, refs);
>> +	put_page(page);
>> +}
> 
> It's not terribly efficient. Maybe something like:
> 
> 	VM_BUG_ON_PAGE(page_ref_count(page) < ref, page);
> 	if (refs > 2)
> 		page_ref_sub(page, refs - 1);
> 	put_page(page);
> 
> ?

OK, but how about this instead? I don't see the need for a "2", as that
is a magic number that requires explanation. Whereas "1" is not a magic
number--here it means: either there are "many" (>1) refs, or not.

And the routine won't be called with refs less than about 32 (2MB huge
page, 64KB base page == 32 subpages) anyway.

	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
	/*
	 * Calling put_page() for each ref is unnecessarily slow. Only the last
	 * ref needs a put_page().
	 */
	if (refs > 1)
		page_ref_sub(page, refs - 1);
	put_page(page);


thanks,
-- 
John Hubbard
NVIDIA
  
