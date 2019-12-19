Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EE9125C0B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 08:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfLSHg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 02:36:29 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4230 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfLSHg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 02:36:29 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfb28710000>; Wed, 18 Dec 2019 23:36:17 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 18 Dec 2019 23:36:27 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 18 Dec 2019 23:36:27 -0800
Received: from [10.2.165.11] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 07:36:25 +0000
Subject: Re: [PATCH v11 04/25] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
To:     Dan Williams <dan.j.williams@intel.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
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
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191216222537.491123-5-jhubbard@nvidia.com>
 <CAPcyv4hQBMxYMurxG=Vwh0=FKWoT3z-Kf=dqES1-icRV5bLwKg@mail.gmail.com>
 <d0a99e75-0175-0f31-f176-8c37c18a4108@nvidia.com>
 <CAPcyv4j+Zgom17UZ-6Njkij1R0UQ=vUQdnaEZj9qDezEUJSZGg@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <a9782048-0c6a-b906-2bd6-3800269f4b01@nvidia.com>
Date:   Wed, 18 Dec 2019 23:33:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j+Zgom17UZ-6Njkij1R0UQ=vUQdnaEZj9qDezEUJSZGg@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576740978; bh=AwGIHszd33R/kLZlUt1Z4JwwlD2NSoQAiltNw2UIah0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=rn2yGjgwQ9+/2v2mcxWjrZFxdrk3/eEgjxRU1LJiuOVyjVOa62J0tvoTcmLOK6fXS
         xTiiEKdaSrRaYvKoHJFISdC+5xDr9wuGKGy6eL+p8mnXTv3WmxTBQ5uSD1vNUHW7Zv
         FL1u5zml1dT0aGOGbVIB8FGZRe/vZmwx0E0SfZqPp5XPLjqF6k+D7FwuHs+yKnEljh
         6K2DgflrDdhvNm7j657NcorkWkt+15POYkE/QPPC6A7qk9vcVVLh/jftFFqBiaLSef
         +CbFHF0Oi6KJR9YDOdsjceXX460BQcgisIE59hm4mMu6iV3pT5dz1gvUWjcugiRrZC
         tT/WLbmWB9r/w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/19 10:52 PM, Dan Williams wrote:
> On Wed, Dec 18, 2019 at 9:51 PM John Hubbard <jhubbard@nvidia.com> wrote:
>>
>> On 12/18/19 9:27 PM, Dan Williams wrote:
>> ...
>>>> @@ -461,5 +449,5 @@ void __put_devmap_managed_page(struct page *page)
>>>>           page->mapping = NULL;
>>>>           page->pgmap->ops->page_free(page);
>>>>    }
>>>> -EXPORT_SYMBOL(__put_devmap_managed_page);
>>>> +EXPORT_SYMBOL(free_devmap_managed_page);
>>>
>>> This patch does not have a module consumer for
>>> free_devmap_managed_page(), so the export should move to the patch
>>> that needs the new export.
>>
>> Hi Dan,
>>
>> OK, I know that's a policy--although it seems quite pointless here given
>> that this is definitely going to need an EXPORT.
>>
>> At the moment, the series doesn't use it in any module at all, so I'll just
>> delete the EXPORT for now.
>>
>>>
>>> Also the only reason that put_devmap_managed_page() is EXPORT_SYMBOL
>>> instead of EXPORT_SYMBOL_GPL is that there was no practical way to
>>> hide the devmap details from evey module in the kernel that did
>>> put_page(). I would expect free_devmap_managed_page() to
>>> EXPORT_SYMBOL_GPL if it is not inlined into an existing exported
>>> static inline api.
>>>
>>
>> Sure, I'll change it to EXPORT_SYMBOL_GPL when the time comes. We do have
>> to be careful that we don't shut out normal put_page() types of callers,
>> but...glancing through the current callers, that doesn't look to be a problem.
>> Good. So it should be OK to do EXPORT_SYMBOL_GPL here.
>>
>> Are you *sure* you don't want to just pre-emptively EXPORT now, and save
>> looking at it again?
> 
> I'm positive. There is enough history for "trust me the consumer is
> coming" turning out not to be true to justify the hassle in my mind. I
> do trust you, but things happen.
> 

OK, it's deleted locally. Thanks for looking at the patch. I'll post a v12 series
that includes the change, once it looks like reviews are slowing down.


thanks,
-- 
John Hubbard
NVIDIA
