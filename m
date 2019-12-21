Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C766A1285D1
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 01:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfLUACW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 19:02:22 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17577 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfLUACV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 19:02:21 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfd61010000>; Fri, 20 Dec 2019 16:02:10 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 20 Dec 2019 16:02:20 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 20 Dec 2019 16:02:20 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 21 Dec
 2019 00:02:16 +0000
Subject: Re: [PATCH v11 00/25] mm/gup: track dma-pinned pages: FOLL_PIN
To:     Jan Kara <jack@suse.cz>
CC:     Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Alex Williamson" <alex.williamson@redhat.com>,
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
        Maor Gottlieb <maorg@mellanox.com>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191219132607.GA410823@unreal>
 <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
 <20191220092154.GA10068@quack2.suse.cz>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <b4b720c6-bb65-4928-f94f-618a39781c17@nvidia.com>
Date:   Fri, 20 Dec 2019 16:02:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191220092154.GA10068@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576886530; bh=lYmRHUKxjje08r87sxcrKTHiQd7mjXE1LoyaAhCgFxg=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=f7r38Ma6i3MI9nFSKeDIvPdt5vYrXy+JJsSfP31k7u+2wCxmmNufD1MCidKlHygn3
         9DLRItYTVN4NHfhd0m+R/vw4197VAkr47By2QIcXSjvCdK32rmWdX1HB29Za9NhH9u
         hudNbxuLpZYfSsTqz7cK57z334jwi4I1tLEi9lH/ca1Ff62dT4UIra7e9vrIur0HB5
         JlY4V/uCEY0LG0MxUfhFQE9legwb8M5VcPujH9NTF0fF15bOxKlnVGzri/2jDISypV
         Ta+rQMc92Kz26PG64qcQiVvssdWbJbDYbG+1Hm1r44PlB1G6okvsKpTqDlZ87Fs/zI
         Q76HA4eWaOe1g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/19 1:21 AM, Jan Kara wrote:
...
>> So, ideas and next steps:
>>
>> 1. Assuming that you *are* hitting this, I think I may have to fall back to
>> implementing the "deferred" part of this design, as part of this series, after
>> all. That means:
>>
>>   For the pin/unpin calls at least, stop treating all pages as if they are
>>   a cluster of PAGE_SIZE pages; instead, retrieve a huge page as one page.
>>   That's not how it works now, and the need to hand back a huge array of
>>   subpages is part of the problem. This affects the callers too, so it's not
>>   a super quick change to make. (I was really hoping not to have to do this
>>   yet.)
> 
> Does that mean that you would need to make all GUP users huge page aware?
> Otherwise I don't see how what you suggest would work... And I don't think
> making all GUP users huge page aware is realistic (effort-wise) or even
> wanted (maintenance overhead in all those places).
> 

Well, pretty much yes. It's really just the pin_user_pages*() callers, but
the internals, follow_page() and such, are so interconnected right now that
it would probably blow up into a huge effort, as you point out.

> I believe there might be also a different solution for this: For
> transparent huge pages, we could find a space in 'struct page' of the
> second page in the huge page for proper pin counter and just account pins
> there so we'd have full width of 32-bits for it.
> 
> 								Honza
> 

OK, let me pursue that. Given that I shouldn't need to handle pages
splitting, it should be not *too* bad.

I am starting to think that I should just post the first 9 or so 
prerequisite patches (first 9 patches, plus the v4l2 fix that arguably should 
have been earlier in the sequence I guess), as 5.6 candidates, while I go
back to the drawing board here. 

thanks,
-- 
John Hubbard
NVIDIA
