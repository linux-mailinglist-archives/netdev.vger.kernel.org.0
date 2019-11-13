Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2840CFB9DB
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKMUay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:30:54 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5469 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfKMUax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:30:53 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcc67fb0000>; Wed, 13 Nov 2019 12:30:51 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 Nov 2019 12:30:48 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 Nov 2019 12:30:48 -0800
Received: from [10.2.160.107] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 20:30:47 +0000
Subject: Re: [PATCH v3 00/23] mm/gup: track dma-pinned pages: FOLL_PIN,
 FOLL_LONGTERM
To:     Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf <bpf@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        <kvm@vger.kernel.org>, <linux-block@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        netdev <netdev@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20191112000700.3455038-1-jhubbard@nvidia.com>
 <20191112203802.GD5584@ziepe.ca>
 <02fa935c-3469-b766-b691-5660084b60b9@nvidia.com>
 <CAKMK7uHvk+ti00mCCF2006U003w1dofFg9nSfmZ4bS2Z2pEDNQ@mail.gmail.com>
 <7b671bf9-4d94-f2cc-8453-863acd5a1115@nvidia.com>
 <20191113101210.GD6367@quack2.suse.cz>
 <20191113114311.GP23790@phenom.ffwll.local>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <283b121d-f526-f43f-de45-dc2f8318d860@nvidia.com>
Date:   Wed, 13 Nov 2019 12:28:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191113114311.GP23790@phenom.ffwll.local>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573677051; bh=w2mV+XepuxnOtihiYgL/XuqwUYU2QI7jYfF/MppVAWE=;
        h=X-PGP-Universal:Subject:To:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=K3ELKy0LEaE4Frm6QQ4jLw8cJF3zobatTYiyQ/Vg2jO630IkqTksnY4sEeXMrgt5a
         b46qAh7TsgPVJKCPcTPIoUnjxNn6h2xUdpivOkXuz3queuSeoxqaSFBxc3yHdAdKf1
         weqLMTvKu8Vs4tf6la1SbXQc5ZvBvuc6pK240FvHmEYJ0o2WePNqZANag+FSCa5U1i
         2iyzSKadjF0T/uRVrR4KM4Ey20Bg7sJaaQBcaSS9Pr1q7odGMaBmeJ4hRBriIHKA4P
         1LTpfohPn7iHAuSCtXbApQkiiVLKyUBXMKbsJDCLOd3JNZEji1iUk1dM5atghZtAzC
         EJVJspvV4f3sw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/19 3:43 AM, Daniel Vetter wrote:
...
>>>> Can't we call this unpin_user_page then, for some symmetry? Or is that
>>>> even more churn?
>>>>
>>>> Looking from afar the naming here seems really confusing.
>>>
>>>
>>> That look from afar is valuable, because I'm too close to the problem to see
>>> how the naming looks. :)
>>>
>>> unpin_user_page() sounds symmetrical. It's true that it would cause more
>>> churn (which is why I started off with a proposal that avoids changing the
>>> names of put_user_page*() APIs). But OTOH, the amount of churn is proportional
>>> to the change in direction here, and it's really only 10 or 20 lines changed,
>>> in the end.
>>>
>>> So I'm open to changing to that naming. It would be nice to hear what others
>>> prefer, too...
>>
>> FWIW I'd find unpin_user_page() also better than put_user_page() as a
>> counterpart to pin_user_pages().
> 
> One more point from afar on pin/unpin: We use that a lot in graphics for
> permanently pinned graphics buffer objects. Which really only should be
> used for scanout. So at least graphics folks should have an appropriate
> mindset and try to make sure we don't overuse this stuff.
> -Daniel
> 

OK, Ira also likes "unpin", and so far no one has said *anything* in favor
of the "put_user_page" names, so I think we have a winner! I'll change the
names to unpin_user_page*().


thanks,
-- 
John Hubbard
NVIDIA
