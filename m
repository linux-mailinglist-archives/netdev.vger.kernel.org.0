Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E71EB76C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbfJaSnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:43:43 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9937 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbfJaSnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:43:42 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dbb2b600000>; Thu, 31 Oct 2019 11:43:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 31 Oct 2019 11:43:38 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 31 Oct 2019 11:43:38 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 31 Oct
 2019 18:43:37 +0000
Subject: Re: [PATCH 02/19] mm/gup: factor out duplicate code from four
 routines
To:     Ira Weiny <ira.weiny@intel.com>
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-3-jhubbard@nvidia.com>
 <20191031183549.GC14771@iweiny-DESK2.sc.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <75b557f7-24b2-740c-2640-2f914d131600@nvidia.com>
Date:   Thu, 31 Oct 2019 11:43:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191031183549.GC14771@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572547424; bh=tVTQ7w70LzXRWNozMw5pcweYnGaSw6wKS7taKOoMvgQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ItGdt9jPwuaxZEwBZAmOs6QRw3y1ekRCXIkAk884e9fffuoHSkMv3IXuQ7vsU8mJ+
         6sn7OAiE4sod/01pqRwiHcd242kDvH4VxxD334MsuTzmzdN+z2Tf4SkqA4hAm5RUgb
         DQz3BJUfTbN/krdQz9Fy07dfiumXVmkiVCv2liRNNsMOm+vluNn2/EZjBIhVCKbXA7
         WVHpKyr4oMIxF6v1Zhp2z85oNzL7rjapLTslb3D5k7UtqTOOxnqps/GxGVAfXIr7tc
         /ZNTHbsdctd0KY29GLOk6czDGwBpbgAriROyniZOORRqIrKjgDjOEDFf1BfnHlTH/3
         EDGo/Nn1OpOQw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 11:35 AM, Ira Weiny wrote:
> On Wed, Oct 30, 2019 at 03:49:13PM -0700, John Hubbard wrote:
...
>> +
>> +static void __remove_refs_from_head(struct page *page, int refs)
>> +{
>> +	/* Do a get_page() first, in case refs == page->_refcount */
>> +	get_page(page);
>> +	page_ref_sub(page, refs);
>> +	put_page(page);
>> +}
> 
> I wonder if this is better implemented as "put_compound_head()"?  To match the
> try_get_compound_head() call below?

Hi Ira,

Good idea, I'll rename it to that.

> 
>> +
>> +static int __huge_pt_done(struct page *head, int nr_recorded_pages, int *nr)
>> +{
>> +	*nr += nr_recorded_pages;
>> +	SetPageReferenced(head);
>> +	return 1;
> 
> When will this return anything but 1?
> 

Never, but it saves a line at all four call sites, by having it return like that.

I could see how maybe people would prefer to just have it be a void function,
and return 1 directly at the call sites. Since this was a lower line count I
thought maybe it would be slightly better, but it's hard to say really.

thanks,

John Hubbard
NVIDIA
