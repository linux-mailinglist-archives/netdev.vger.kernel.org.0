Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7718BED474
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 20:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbfKCTxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 14:53:45 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9104 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbfKCTxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 14:53:44 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dbf30480000>; Sun, 03 Nov 2019 11:53:45 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sun, 03 Nov 2019 11:53:38 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sun, 03 Nov 2019 11:53:38 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 3 Nov
 2019 19:53:37 +0000
Subject: Re: [PATCH 19/19] Documentation/vm: add pin_user_pages.rst
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-20-jhubbard@nvidia.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <58d3ef87-85ef-a69d-5cf7-1719ff356048@nvidia.com>
Date:   Sun, 3 Nov 2019 11:53:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191030224930.3990755-20-jhubbard@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572810825; bh=rTG1L9aHJoAtL42CYzuRVvyOXz7jlR1h5ExQz/00LXg=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=hz45cfuI6ZB24IXq0tlVG+4gOOw0rO1aR3a1v+mNE3URSP536c/QI/nw4iVi4Q3Fg
         ZvhfjRg3c8U4Zeed5IN0S8La0/yhKPqXLcaka8zujsYCnTFzskkYWmX6ZMKm85uc53
         903Xo+ojBBu648JazllTkreHad3wmqcM3sQfIPNK3XPWIubatS+4uPpiaSake+maws
         O3mb+7lTk0b/qWmINewSdXIPlnBwUrlkcxoUQTGi1jJWPWnSrL74fzVKeEWjMvAjbH
         5wXYgJG8qyFZYCSM/zx8jBY5FMvGDHZIQbt9J9oHql6kjp+O+lMMcuF1F8/mAcyFV4
         Yo4Vz3wx3lQSQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19 3:49 PM, John Hubbard wrote:
...
> +* struct page may not be increased in size for this, and all fields are already
> +  used.
> +
> +* Given the above, we can overload the page->_refcount field by using, sort of,
> +  the upper bits in that field for a dma-pinned count. "Sort of", means that,
> +  rather than dividing page->_refcount into bit fields, we simple add a medium-
> +  large value (GUP_PIN_COUNTING_BIAS, initially chosen to be 1024: 10 bits) to
> +  page->_refcount. This provides fuzzy behavior: if a page has get_page() called
> +  on it 1024 times, then it will appear to have a single dma-pinned count.
> +  And again, that's acceptable.
> +
> +This also leads to limitations: there are only 32-10==22 bits available for a
> +counter that increments 10 bits at a time.
> +

The above claim is just a "bit" too optimistic, by one bit: page->_refcount, being 
an atomic_t which uses a signed int (and we use the sign bit to check for overflow),
only has 31 total bits available for actual counting, not 32.

I'll adjust the documentation in v2, to account for this.

thanks,

John Hubbard
NVIDIA

