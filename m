Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1313013CF2E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgAOVeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:34:22 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14312 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgAOVeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:34:21 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1f85210000>; Wed, 15 Jan 2020 13:33:21 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 15 Jan 2020 13:34:16 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 15 Jan 2020 13:34:16 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 15 Jan
 2020 21:34:16 +0000
Subject: Re: [PATCH v12 11/22] mm/gup: introduce pin_user_pages*() and
 FOLL_PIN
To:     Christoph Hellwig <hch@infradead.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
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
        Mike Rapoport <rppt@linux.ibm.com>
References: <20200107224558.2362728-1-jhubbard@nvidia.com>
 <20200107224558.2362728-12-jhubbard@nvidia.com>
 <20200115153020.GF19546@infradead.org>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <1a0ee1db-5528-86a8-0713-3d820fbdf4ad@nvidia.com>
Date:   Wed, 15 Jan 2020 13:34:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200115153020.GF19546@infradead.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579124001; bh=87Rlq6x45ruVW7JTVYUJt0mWD3kN4xgsTUgpHaSTwOs=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=dbP5SmA0QfbUlmT548bubiJAkEQguNXb+B22BE0nnic910e/52B3pTFYwo0R9gnOk
         /mlFxNBraLMyXPTecP1trRDknv0CWyUqRUhn8AvgRKQEt/OrYnrlJ5ltQrtwu2/iZG
         uXyWe/Tp3/8o2BssD5h12JhA8/Qf+tvLIUVBAfdgHpiHf/vpXBUQ/a29w86sKWsdhS
         xLP+ysLSXK1OimxyU8GqDxRUN80ueCmWM+W82ScjqhN2l7u6YLSbkEfUVc40jSw+4n
         1alFBQ4/aOAizIIaeTPZN6p/1uIoYyQqWqSWRALwuOXb5xR9ZMfEIX7FqzbdBDPZRO
         IYaka2FAJgWiw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 7:30 AM, Christoph Hellwig wrote:
> On Tue, Jan 07, 2020 at 02:45:47PM -0800, John Hubbard wrote:
>> Introduce pin_user_pages*() variations of get_user_pages*() calls,
>> and also pin_longterm_pages*() variations.
>>
>> For now, these are placeholder calls, until the various call sites
>> are converted to use the correct get_user_pages*() or
>> pin_user_pages*() API.
> 
> What do the pure placeholders buy us?  The API itself looks ok,
> but until it actually is properly implemented it doesn't help at
> all, and we've had all kinds of bad experiences with these sorts
> of stub APIs.
> 

Hi Christoph,

Absolutely agreed, and in fact, after spending some time in this area I 
am getting a much better understanding of just how problematic "this will 
be used soon" APIs really are. However, this is not quite that case.

The following things make this different from a "pure placeholder" API:

1) These APIs are all exercised in the following patches in this series, 
unless I've overlooked one, and

2) The pages are actually tracked in the very next patch that I want to
post. That patch was posted as part of the v11 series [1], but 
Leon Romanovsky reported a problem with it, and so I'm going to add in
the ability to handle larger "pin" refcounts for the huge page cases.

Meanwhile, I wanted to get these long-simmering simpler preparatory
patches submitted, because it's clear that the API is unaffected by the
huge page refcount fix. (That fix will likely use the second struct page of
the compound page, to count up higher.)


[1] https://lore.kernel.org/r/20191216222537.491123-24-jhubbard@nvidia.com  
    [PATCH v11 23/25] mm/gup: track FOLL_PIN pages

thanks,
-- 
John Hubbard
NVIDIA
