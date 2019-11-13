Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6BDFBC84
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 00:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKMXZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 18:25:27 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2241 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfKMXZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 18:25:26 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcc90a80004>; Wed, 13 Nov 2019 15:24:24 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 Nov 2019 15:25:20 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 Nov 2019 15:25:20 -0800
Received: from [10.2.160.107] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 23:25:19 +0000
Subject: Re: [PATCH v4 09/23] mm/gup: introduce pin_user_pages*() and FOLL_PIN
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
        Mike Rapoport <rppt@linux.ibm.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-10-jhubbard@nvidia.com>
 <20191113104308.GE6367@quack2.suse.cz>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <3850aa22-6f03-bd2b-024f-5736c4461199@nvidia.com>
Date:   Wed, 13 Nov 2019 15:22:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191113104308.GE6367@quack2.suse.cz>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573687464; bh=1TmaF+0LQcsFxIIl+yPUdlXgPu3Pw2KrYq1UfrZmOD8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Sgh8xQ9PPxEDYPCTK8yOmdqruurqzstpkQQJWGvT1ZuKvcNIm+LQ3r9aXrqQ9mszQ
         Bu049858Sw2Icc5D17nHXFv2uQsdcr4xPrIX8xdiYxeSGVqbXJlpqaWLWE4t3jzM99
         VuF91a2IBcxPvt3YPz/EF6VJnVwIt20m+YRBQJGScCmijzBCG+FdMVkUIYoHIR7z6o
         jEChHIr4nyoheDQl2TBz15vaUAtG/VbXtnMxK3XkWyGpUbFva3/BqFu3QAkjswSCIq
         sTwbFrrL1y3TY1TtnjqKRKFpvyNb5gHvpkqf+On66KeiFfk826TpWgO2QQef8bajR8
         NyLLnJaaEwbcQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/19 2:43 AM, Jan Kara wrote:
...
> How does FOLL_PIN result in grabbing (at least normal, for now) page reference?
> I didn't find that anywhere in this patch but it is a prerequisite to
> converting any user to pin_user_pages() interface, right?


ohhh, I messed up on this intermediate patch: it doesn't quite stand alone as
it should, as you noticed. To correct this, I can do one of the following:

a) move the new pin*() routines into the later patch 16 ("mm/gup:
track FOLL_PIN pages"), or

b) do a temporary thing here, such as setting FOLL_GET and adding a TODO,
within the pin*() implementations. And this switching it over to FOLL_PIN
in patch 16.

I'm thinking (a) is less error-prone, so I'm going with that unless someone
points out that that is stupid. :)


...
> I was somewhat wondering about the number of functions you add here. So we
> have:> 
> pin_user_pages()
> pin_user_pages_fast()
> pin_user_pages_remote()
> 
> and then longterm variants:
> 
> pin_longterm_pages()
> pin_longterm_pages_fast()
> pin_longterm_pages_remote()
> 
> and obviously we have gup like:
> get_user_pages()
> get_user_pages_fast()
> get_user_pages_remote()
> ... and some other gup variants ...
> 
> I think we really should have pin_* vs get_* variants as they are very
> different in terms of guarantees and after conversion, any use of get_*
> variant in non-mm code should be closely scrutinized. OTOH pin_longterm_*
> don't look *that* useful to me and just using pin_* instead with
> FOLL_LONGTERM flag would look OK to me and somewhat reduce the number of
> functions which is already large enough? What do people think? I don't feel
> too strongly about this but wanted to bring this up.
> 
> 								Honza

Sounds just right to me, and I see that Dan and Ira also like it.
So I'll proceed with that.

thanks,
-- 
John Hubbard
NVIDIA
