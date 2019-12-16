Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32607121C9E
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 23:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfLPWV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 17:21:56 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11660 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLPWVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 17:21:55 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df803630000>; Mon, 16 Dec 2019 14:21:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 16 Dec 2019 14:21:50 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 16 Dec 2019 14:21:50 -0800
Received: from [10.2.165.205] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Dec
 2019 22:21:49 +0000
Subject: Re: [PATCH v11 23/25] mm/gup: track FOLL_PIN pages
To:     Jan Kara <jack@suse.cz>
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
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20191212101741.GD10065@quack2.suse.cz>
 <20191214032617.1670759-1-jhubbard@nvidia.com>
 <20191216125353.GF22157@quack2.suse.cz>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <86297621-0200-01db-923b-9f8d3ee87354@nvidia.com>
Date:   Mon, 16 Dec 2019 14:18:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191216125353.GF22157@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576534883; bh=YMhg/Haff63lefKvHJkcKDJlwsa7xb5b4lrnUemlU7g=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=amsVlFr4hw9MYNrHr5/DYyX51JWA4Fkp/OrGL5Hbx4jMwoyI9BWBiyVnsOuxsMRIB
         iaLSTfEX4Yqo/iVj68XTBu0YqNDpOKgLZv4iJJL9jXaVCKbZ5JRpa2udb5A5igVcw2
         1sJ9NO2FUwaGqY/GZOYBsW4L6j0KjdlhAuITY2UHIyczf/OJ5Ld/YorqU0JPKNcd1d
         I994/z/XcmSLl51Zt+AHfBnbzOf+k0FilaRTGpdBKRUjSH3tUdnc5ed7upp7HB/ZdP
         yPbbF1+4hTs972ehSF2pBSOHKp1BKWsgCDOuYbNfow5D4LRa3DPocQgihOq0BFqmMR
         WOmZ1eSWqtu/A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/19 4:53 AM, Jan Kara wrote:
...

> I'd move this still a bit higher - just after VM_BUG_ON_PAGE() and before
> if (flags & FOLL_TOUCH) test. Because touch_pmd() can update page tables
> and we don't won't that if we're going to fail the fault.
> 

Done. I'll post a full v11 series shortly.

> With this fixed, the patch looks good to me so you can then add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 

btw, thanks for the thorough review of this critical patch (and for your
patience with my mistakes). I really appreciate it, and this patchset would
not have made it this far without your detailed help and explanations.


thanks,
-- 
John Hubbard
NVIDIA
