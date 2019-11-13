Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26237FA369
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730360AbfKMCJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:09:13 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7386 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728220AbfKMCJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 21:09:11 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcb65c50002>; Tue, 12 Nov 2019 18:09:09 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 18:09:09 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 12 Nov 2019 18:09:09 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 02:09:09 +0000
Subject: Re: [PATCH v3 08/23] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
To:     Dan Williams <dan.j.williams@intel.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
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
References: <20191112000700.3455038-1-jhubbard@nvidia.com>
 <20191112000700.3455038-9-jhubbard@nvidia.com>
 <20191112204338.GE5584@ziepe.ca>
 <0db36e86-b779-01af-77e7-469af2a2e19c@nvidia.com>
 <CAPcyv4hAEgw6ySNS+EFRS4yNRVGz9A3Fu1vOk=XtpjYC64kQJw@mail.gmail.com>
 <20191112234250.GA19615@ziepe.ca>
 <CAPcyv4hwFKmsQpp04rS6diCmZwGtbnriCjfY2ofWV485qT9kzg@mail.gmail.com>
 <28355eb0-4ee5-3418-b430-59302d15b478@nvidia.com>
 <CAPcyv4hdYZ__3+KJHh+0uX--f-U=pLiZfdO0JDhyBE-nZ=i4FQ@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <c6f035f5-8290-2bc0-a645-d63e3a47f588@nvidia.com>
Date:   Tue, 12 Nov 2019 18:09:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hdYZ__3+KJHh+0uX--f-U=pLiZfdO0JDhyBE-nZ=i4FQ@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573610949; bh=B6pkyHmGh6yhjKCidrVzgID/vhDeCAvfXP4nK4Pk4sU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=RV5dPXEXGk2wPs6itxn+ysd+tryNIcHtFe7cNPEDa6fUJR+mqhDFmpWJh1cxUznfM
         u/dSVfFdxe/eLLU3UZJsFyG0KQve3tMf4SbX/eLAZ3PsvXvDC9d9Vo1jj5Z6rn0Yor
         1EXyMK0mBMr99qCD9+AZ++P4gO+L3VPJHPXksjDueAgSTRvM0AvLDqBIchBRO93HWN
         flXai7XrgmMwanL4FueloUnCWoIRpUo5voQGwqOd0jdXOidJNNwAYlQZLipkiht6xZ
         1PIwF7tPrWLfM+J/GXeR6mCfSxY22FrqYpx7yQ6peaaRvxPNUSU6UqLCTPNv27OnhW
         6xjI9w2mLclog==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/19 5:35 PM, Dan Williams wrote:
> On Tue, Nov 12, 2019 at 5:08 PM John Hubbard <jhubbard@nvidia.com> wrote:
>>
>> On 11/12/19 4:58 PM, Dan Williams wrote:
>> ...
>>>>> It's not redundant relative to upstream which does not do anything the
>>>>> FOLL_LONGTERM in the gup-slow path... but I have not looked at patches
>>>>> 1-7 to see if something there made it redundant.
>>>>
>>>> Oh, the hunk John had below for get_user_pages_remote() also needs to
>>>> call __gup_longterm_locked() when FOLL_LONGTERM is specified, then
>>>> that calls check_dax_vmas() which duplicates the vma_is_fsdax() check
>>>> above.
>>>
>>> Oh true, good eye. It is redundant if it does additionally call
>>> __gup_longterm_locked(), and it needs to do that otherwises it undoes
>>> the CMA migration magic that Aneesh added.
>>>
>>
>> OK. So just to be clear, I'll be removing this from the patch:
>>
>>         /*
>>          * The lifetime of a vaddr_get_pfn() page pin is
>>          * userspace-controlled. In the fs-dax case this could
>>          * lead to indefinite stalls in filesystem operations.
>>          * Disallow attempts to pin fs-dax pages via this
>>          * interface.
>>          */
>>         if (ret > 0 && vma_is_fsdax(vmas[0])) {
>>                 ret = -EOPNOTSUPP;
>>                 put_page(page[0]);
>>         }
>>
>> (and the declaration of "vmas", as well).
> 
> ...and add a call to __gup_longterm_locked internal to
> get_user_pages_remote(), right?
> 

Yes, and thanks for double-checking. I think I got a little dizzy following
the call stack there. :)  And now I see that this also affects the
implementation of pin_longterm_pages_remote(), because that will need the
same logic that get_user_pages_remote() has. 



thanks,
-- 
John Hubbard
NVIDIA
