Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F73EBAD0
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbfJaXqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:46:54 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7772 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbfJaXqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:46:52 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dbb726c0000>; Thu, 31 Oct 2019 16:46:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 31 Oct 2019 16:46:46 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 31 Oct 2019 16:46:46 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 31 Oct
 2019 23:46:45 +0000
Subject: Re: [PATCH 08/19] mm/process_vm_access: set FOLL_PIN via
 pin_user_pages_remote()
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-9-jhubbard@nvidia.com>
 <20191031233519.GH14771@iweiny-DESK2.sc.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <7e79d9b5-772e-3628-4a60-65efc2f490c5@nvidia.com>
Date:   Thu, 31 Oct 2019 16:46:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191031233519.GH14771@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572565613; bh=Ni3MG24cn6KOx2mpKQf1IX0uBXAOxI/S5ACFQstwCH0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Fl9ftqk4J63wpZ0nmIiycLWCL11bYX50L+387BZ180hQh//V0Vp2ib5lF+gUyjqai
         BUNKoNlXTqc57g1YISa4wLoDF8FDUSOEDk//A2D/giSdADgbBgvBgvcIBixm1N1+Zk
         H8cgPXG2CeU33ioP0ErDWx6EuJtDE7b8cwg7DR730s9O71+39F8ouq+P6zklOCkkR4
         oDUx19ikJNj9J8uGqwUijC3VwpTpRuFvJG1fW6Ohvn+piDj3I1HEee28haJHWEOnTW
         Uwhe+F8yMyQV4WRYSdi28gKVURtaIyz8Dwtt8DEOye19K0wcNBp+Nz8BepqnA7FG/T
         4uFqHk6o1ZuLQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 4:35 PM, Ira Weiny wrote:
> On Wed, Oct 30, 2019 at 03:49:19PM -0700, John Hubbard wrote:
>> Convert process_vm_access to use the new pin_user_pages_remote()
>> call, which sets FOLL_PIN. Setting FOLL_PIN is now required for
>> code that requires tracking of pinned pages.
>>
>> Also, release the pages via put_user_page*().
>>
>> Also, rename "pages" to "pinned_pages", as this makes for
>> easier reading of process_vm_rw_single_vec().
> 
> Ok...  but it made review a bit harder...
> 

Yes, sorry about that. After dealing with "pages means struct page *[]"
for all this time, having an "int pages" just was a step too far for
me here. :)

Thanks for working through it. 


thanks,

John Hubbard
NVIDIA



> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> 


>>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>> ---
>>  mm/process_vm_access.c | 28 +++++++++++++++-------------
>>  1 file changed, 15 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
>> index 357aa7bef6c0..fd20ab675b85 100644
>> --- a/mm/process_vm_access.c
>> +++ b/mm/process_vm_access.c
>> @@ -42,12 +42,11 @@ static int process_vm_rw_pages(struct page **pages,
>>  		if (copy > len)
>>  			copy = len;
>>  
>> -		if (vm_write) {
>> +		if (vm_write)
>>  			copied = copy_page_from_iter(page, offset, copy, iter);
>> -			set_page_dirty_lock(page);
>> -		} else {
>> +		else
>>  			copied = copy_page_to_iter(page, offset, copy, iter);
>> -		}
>> +
>>  		len -= copied;
>>  		if (copied < copy && iov_iter_count(iter))
>>  			return -EFAULT;
>> @@ -96,7 +95,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
>>  		flags |= FOLL_WRITE;
>>  
>>  	while (!rc && nr_pages && iov_iter_count(iter)) {
>> -		int pages = min(nr_pages, max_pages_per_loop);
>> +		int pinned_pages = min(nr_pages, max_pages_per_loop);
>>  		int locked = 1;
>>  		size_t bytes;
>>  
>> @@ -106,14 +105,15 @@ static int process_vm_rw_single_vec(unsigned long addr,
>>  		 * current/current->mm
>>  		 */
>>  		down_read(&mm->mmap_sem);
>> -		pages = get_user_pages_remote(task, mm, pa, pages, flags,
>> -					      process_pages, NULL, &locked);
>> +		pinned_pages = pin_user_pages_remote(task, mm, pa, pinned_pages,
>> +						     flags, process_pages,
>> +						     NULL, &locked);
>>  		if (locked)
>>  			up_read(&mm->mmap_sem);
>> -		if (pages <= 0)
>> +		if (pinned_pages <= 0)
>>  			return -EFAULT;
>>  
>> -		bytes = pages * PAGE_SIZE - start_offset;
>> +		bytes = pinned_pages * PAGE_SIZE - start_offset;
>>  		if (bytes > len)
>>  			bytes = len;
>>  
>> @@ -122,10 +122,12 @@ static int process_vm_rw_single_vec(unsigned long addr,
>>  					 vm_write);
>>  		len -= bytes;
>>  		start_offset = 0;
>> -		nr_pages -= pages;
>> -		pa += pages * PAGE_SIZE;
>> -		while (pages)
>> -			put_page(process_pages[--pages]);
>> +		nr_pages -= pinned_pages;
>> +		pa += pinned_pages * PAGE_SIZE;
>> +
>> +		/* If vm_write is set, the pages need to be made dirty: */
>> +		put_user_pages_dirty_lock(process_pages, pinned_pages,
>> +					  vm_write);
>>  	}
>>  
>>  	return rc;
>> -- 
>> 2.23.0
>>
