Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366881285BE
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 00:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfLTXzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 18:55:06 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10960 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfLTXzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 18:55:05 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfd5f350000>; Fri, 20 Dec 2019 15:54:29 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 20 Dec 2019 15:55:00 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 20 Dec 2019 15:55:00 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Dec
 2019 23:54:55 +0000
Subject: Re: [PATCH v11 00/25] mm/gup: track dma-pinned pages: FOLL_PIN
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
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
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Paul Mackerras" <paulus@samba.org>, Shuah Khan <shuah@kernel.org>,
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
 <20191219210743.GN17227@ziepe.ca> <20191220182939.GA10944@unreal>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <1001a5fc-a71d-9c0f-1090-546c4913d8a2@nvidia.com>
Date:   Fri, 20 Dec 2019 15:54:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191220182939.GA10944@unreal>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576886069; bh=/03FljbsYciU5tHAkbKg2NU1vxam4rPGvNuyvBOvTmI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=oRvXZWdofYZmMnKtHbC887r9WWAfrydUr/UibodWJ1qaNTyMPy3+W8R0NcaZhg7dS
         971HGgJD6LwSffJ62pj2tIvxp3eHI8BXVOtdjk7S3sjdZSz9tGHLzm7ujCZVURuC8a
         irEUmm/OhCMXyR+iqtnm6nCO/xQp89VT1WotayqMgxGp4mpoDDX+NNHJX4q0B3UwU3
         +RvXPnLJz1mCrbJfx3TkKb0L+jPAoTDVjeRU4xrKmbuD30tHozBBlUpnyYWoaOHmat
         YDkXozvEZrxOc0h7qKS+l5AK23MRif8N+YKUGoUxe7vXoCKoEk2wdk8r2SNOo6On86
         EItNjAud0AHkw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/19 10:29 AM, Leon Romanovsky wrote:
...
>> $ ./build.sh
>> $ build/bin/run_tests.py
>>
>> If you get things that far I think Leon can get a reproduction for you
> 
> I'm not so optimistic about that.
> 

OK, I'm going to proceed for now on the assumption that I've got an overflow
problem that happens when huge pages are pinned. If I can get more information,
great, otherwise it's probably enough.

One thing: for your repro, if you know the huge page size, and the system
page size for that case, that would really help. Also the number of pins per
page, more or less, that you'd expect. Because Jason says that only 2M huge 
pages are used...

Because the other possibility is that the refcount really is going negative, 
likely due to a mismatched pin/unpin somehow.

If there's not an obvious repro case available, but you do have one (is it easy
to repro, though?), then *if* you have the time, I could point you to a github
branch that reduces GUP_PIN_COUNTING_BIAS by, say, 4x, by applying this:

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bb44c4d2ada7..8526fd03b978 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1077,7 +1077,7 @@ static inline void put_page(struct page *page)
  * get_user_pages and page_mkclean and other calls that race to set up page
  * table entries.
  */
-#define GUP_PIN_COUNTING_BIAS (1U << 10)
+#define GUP_PIN_COUNTING_BIAS (1U << 8)
 
 void unpin_user_page(struct page *page);
 void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,

If that fails to repro, then we would be zeroing in on the root cause. 

The branch is here (I just tested it and it seems healthy):

git@github.com:johnhubbard/linux.git  pin_user_pages_tracking_v11_with_diags



thanks,
-- 
John Hubbard
NVIDIA
