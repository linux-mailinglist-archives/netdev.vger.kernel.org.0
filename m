Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188A8F9E03
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 00:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKLXRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 18:17:32 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8581 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLXRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 18:17:31 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcb3d4b0000>; Tue, 12 Nov 2019 15:16:27 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 15:17:23 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 12 Nov 2019 15:17:23 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 23:17:22 +0000
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
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <85987617-9f6b-6bd3-fea2-9f2910d942bd@nvidia.com>
Date:   Tue, 12 Nov 2019 15:17:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hAEgw6ySNS+EFRS4yNRVGz9A3Fu1vOk=XtpjYC64kQJw@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573600587; bh=MjC1bPxvrMSKZyR0vfIkph3DH21vc9F8lPoYeam7DCg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=p3qYKNzVf+yoWXVxXvdWjvLLch3+eBgZBZPzM5iL19+w8RiUo7ZDiZ6gW1HFxWncA
         +kkprqimeUO8SSqHdah/r3BwJo4tDay3qaFNXlfKQCKgL2mn5vpeQtNa9DXVDSKAs9
         R4vcNKCywQ8SHP3DUh8n5njcCPN6pw3P07lAmh8mqH74Fvgl1XHO+C/rjd/05WqSfr
         CbI8v19uMzgduDq6l5KCW1YAmvvVqDA87KUBJVym8vf0Kv0kKAaenl3Op2+6yladeP
         PH6kHbkLvI9QcVfTqnjU+9eG71rPYcWHuFxhGzrL4Y4JAkS0eHU4rmGDiCKR0r+10R
         ZzG6cdcgSU6Ww==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/19 2:45 PM, Dan Williams wrote:
> On Tue, Nov 12, 2019 at 2:43 PM John Hubbard <jhubbard@nvidia.com> wrote:
>>
>> On 11/12/19 12:43 PM, Jason Gunthorpe wrote:
>> ...
>>>> -            }
>>>> +    ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
>>>> +                                page, vmas, NULL);
>>>> +    /*
>>>> +     * The lifetime of a vaddr_get_pfn() page pin is
>>>> +     * userspace-controlled. In the fs-dax case this could
>>>> +     * lead to indefinite stalls in filesystem operations.
>>>> +     * Disallow attempts to pin fs-dax pages via this
>>>> +     * interface.
>>>> +     */
>>>> +    if (ret > 0 && vma_is_fsdax(vmas[0])) {
>>>> +            ret = -EOPNOTSUPP;
>>>> +            put_page(page[0]);
>>>>      }
>>>
>>> AFAIK this chunk is redundant now as it is some hack to emulate
>>> FOLL_LONGTERM? So vmas can be deleted too.
>>
>> Let me first make sure I understand what Dan has in mind for the vma
>> checking, in the other thread...
> 
> It's not redundant relative to upstream which does not do anything the
> FOLL_LONGTERM in the gup-slow path... but I have not looked at patches
> 1-7 to see if something there made it redundant.
> 

There is nothing in patches 1-7 that would make it redundant. 

About the only thing that you might find interesting in that subset is
patch 4 ("mm: devmap: refactor 1-based refcounting for ZONE_DEVICE pages"),
for devmap and ZONE_DEVICE interest. But it doesn't affect this
discussion directly.


thanks,
-- 
John Hubbard
NVIDIA
