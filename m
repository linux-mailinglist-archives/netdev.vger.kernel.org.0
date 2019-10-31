Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C029EBAB3
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbfJaXnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:43:21 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6542 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfJaXnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:43:20 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dbb719b0000>; Thu, 31 Oct 2019 16:43:23 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 31 Oct 2019 16:43:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 31 Oct 2019 16:43:17 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 31 Oct
 2019 23:43:17 +0000
Subject: Re: [PATCH 05/19] mm/gup: introduce pin_user_pages*() and FOLL_PIN
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
 <20191030224930.3990755-6-jhubbard@nvidia.com>
 <20191031231503.GF14771@iweiny-DESK2.sc.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <f37f7727-4e19-2488-4db8-91feb72ace12@nvidia.com>
Date:   Thu, 31 Oct 2019 16:43:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191031231503.GF14771@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572565403; bh=PrJ35wWczmWpdy8SkgccuWUsoQYieyO1GnA2qpEHC/A=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=WcECVR+iSXkISjovnYPdLc0VuZ56KulHWxjHPNkHamdnVkeg8Qni2kb2nQWiZpF0R
         uHERsJFKafYQzmBPtdM38PPqlW9hVOG53FvDZ5P/CxOEzhou6QhRqcQ9N12GqgYgNp
         /wHowk2nkXrYaCJhmEFLqJYYfo78cS3l7gi+SGvxI9D5IHER/CaM/qs9FgQ9C1/ITB
         55hcdTY0VgK3qlFmt0zG/WKLy9ecbOZj0gkPVF2N0VtGLv24a1MPDNGxZaK/MyTkD4
         GQ5q+uS/VQIxS/skRMHIwldhmJ5+XRyQaWgtFy880BgX2uhvtBtgNacphnrNm0S54P
         UIFLHD8GyGD5Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 4:15 PM, Ira Weiny wrote:
> On Wed, Oct 30, 2019 at 03:49:16PM -0700, John Hubbard wrote:
...
>> + * FOLL_PIN indicates that a special kind of tracking (not just page->_refcount,
>> + * but an additional pin counting system) will be invoked. This is intended for
>> + * anything that gets a page reference and then touches page data (for example,
>> + * Direct IO). This lets the filesystem know that some non-file-system entity is
>> + * potentially changing the pages' data. In contrast to FOLL_GET (whose pages
>> + * are released via put_page()), FOLL_PIN pages must be released, ultimately, by
>> + * a call to put_user_page().
>> + *
>> + * FOLL_PIN is similar to FOLL_GET: both of these pin pages. They use different
>> + * and separate refcounting mechanisms, however, and that means that each has
>> + * its own acquire and release mechanisms:
>> + *
>> + *     FOLL_GET: get_user_pages*() to acquire, and put_page() to release.
>> + *
>> + *     FOLL_PIN: pin_user_pages*() or pin_longterm_pages*() to acquire, and
>> + *               put_user_pages to release.
>> + *
>> + * FOLL_PIN and FOLL_GET are mutually exclusive.
> 
> You mean the flags are mutually exclusive for any single call, correct?
> Because my first thought was that you meant that a page which was pin'ed can't
> be "got".  Which I don't think is true or necessary...

Yes, you are correct. And yes you can absolutely mix get_user_pages() and 
pin_user_pages() calls on the same page(s).

OK, I'll change the wording to "mutually exclusive for a given function call".

> 
>> + *
>> + * Please see Documentation/vm/pin_user_pages.rst for more information.
> 
> NIT: I think we should include this file as part of this patch...

heh. I kept hopping back and forth on this, because I've seen other patchsets that
often put Documentation/ into its own patch. But you're right, of course: it's
not right to refer to items that are not here until a later patch. I'll merge
patch 19 into this one, then.

...
>> @@ -1603,11 +1630,25 @@ static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
>>   * and mm being operated on are the current task's and don't allow
>>   * passing of a locked parameter.  We also obviously don't pass
>>   * FOLL_REMOTE in here.
>> + *
>> + * A note on gup_flags: FOLL_PIN should only be set internally by the
>> + * pin_user_page*() and pin_longterm_*() APIs, never directly by the caller.
>> + * That's in order to help avoid mismatches when releasing pages:
>> + * get_user_pages*() pages must be released via put_page(), while
>> + * pin_user_pages*() pages must be released via put_user_page().
> 
> Rather than put this here should we put it next to the definition of FOLL_PIN?
> Because now we have this text 2x...  :-/
> 

OK, I'll move it up next to FOLL_PIN, and get rid of the 2x places in gup.c


...
>> +long pin_longterm_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
>> +			       unsigned long start, unsigned long nr_pages,
>> +			       unsigned int gup_flags, struct page **pages,
>> +			       struct vm_area_struct **vmas, int *locked)
>> +{
>> +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
>> +	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * FIXME: as noted in the get_user_pages_remote() implementation, it
>> +	 * is not yet possible to safely set FOLL_LONGTERM here. FOLL_LONGTERM
>> +	 * needs to be set, but for now the best we can do is a "TODO" item.
>> +	 */
> 
> Wait?  Why can't we set FOLL_LONGTERM here?  pin_* are new calls which are not
> used yet right?

Nope, not quite! See patch #14 ("vfio, mm: pin_longterm_pages (FOLL_PIN) and 
put_user_page() conversion"), in which I'm converting an existing 
get_user_pages_remote() caller.

> 
> You set it in the other new pin_* functions?
> 

Yes I did. Because those work already in their gup() counterparts.

thanks,

John Hubbard
NVIDIA
