Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4BB7FAC83
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 10:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfKMJEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 04:04:51 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2292 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfKMJEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 04:04:51 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcbc7300000>; Wed, 13 Nov 2019 01:04:48 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 Nov 2019 01:04:48 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 Nov 2019 01:04:48 -0800
Received: from [10.2.160.173] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 09:04:48 +0000
Subject: Re: [PATCH v3 00/23] mm/gup: track dma-pinned pages: FOLL_PIN,
 FOLL_LONGTERM
To:     Daniel Vetter <daniel@ffwll.ch>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
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
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <7b671bf9-4d94-f2cc-8453-863acd5a1115@nvidia.com>
Date:   Wed, 13 Nov 2019 01:02:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKMK7uHvk+ti00mCCF2006U003w1dofFg9nSfmZ4bS2Z2pEDNQ@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573635888; bh=WuCLw1mNhRSSrQbzE2XtsJC46JZuOt82gJ5Z6A5sU6M=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qgoX2qy8q+Pz4xwaUpJCPUDYqLc7AOyeowDXx94iSygezEmzpCR7ZZxo0cljsfswu
         ukE0Cm+f0R483iPntRfn/ABXBRqJdTjYQOd5BMk3/+ahH8sNYpooo8xojMC+j2QKMp
         YnZN0Muwss41C3UGdYFy5MS6hRmL0789DFptbHHfPd5vitO0CxsRYBJyPt01+pG4cX
         6cPdl9NwtrthmFzBA5/mOnD1+FGwYZl+/Gsvcsk8njJ9ZjDk+S/T82e3qWgu+CaLxi
         GAWOKJgmoqYLWXc9CemtInbG0/tG5R+23jPdDf2TY9FLXzVWhi+Ia12J1oxABZoP9Y
         i24f/CxZw1J0Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/19 12:22 AM, Daniel Vetter wrote:
...
>>> Why are we doing this? I think things got confused here someplace, as
>>
>>
>> Because:
>>
>> a) These need put_page() calls,  and
>>
>> b) there is no put_pages() call, but there is a release_pages() call that
>> is, arguably, what put_pages() would be.
>>
>>
>>> the comment still says:
>>>
>>> /**
>>>   * put_user_page() - release a gup-pinned page
>>>   * @page:            pointer to page to be released
>>>   *
>>>   * Pages that were pinned via get_user_pages*() must be released via
>>>   * either put_user_page(), or one of the put_user_pages*() routines
>>>   * below.
>>
>>
>> Ohhh, I missed those comments. They need to all be changed over to
>> say "pages that were pinned via pin_user_pages*() or
>> pin_longterm_pages*() must be released via put_user_page*()."
>>
>> The get_user_pages*() pages must still be released via put_page.
>>
>> The churn is due to a fairly significant change in strategy, whis
>> is: instead of changing all get_user_pages*() sites to call
>> put_user_page(), change selected sites to call pin_user_pages*() or
>> pin_longterm_pages*(), plus put_user_page().
> 
> Can't we call this unpin_user_page then, for some symmetry? Or is that
> even more churn?
> 
> Looking from afar the naming here seems really confusing.


That look from afar is valuable, because I'm too close to the problem to see
how the naming looks. :)

unpin_user_page() sounds symmetrical. It's true that it would cause more
churn (which is why I started off with a proposal that avoids changing the
names of put_user_page*() APIs). But OTOH, the amount of churn is proportional
to the change in direction here, and it's really only 10 or 20 lines changed,
in the end.

So I'm open to changing to that naming. It would be nice to hear what others
prefer, too...


thanks,
-- 
John Hubbard
NVIDIA
