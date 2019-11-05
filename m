Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D803F058B
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390821AbfKETAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:00:12 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13342 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390404AbfKETAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:00:11 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc1c6bc0000>; Tue, 05 Nov 2019 11:00:12 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 05 Nov 2019 11:00:07 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 05 Nov 2019 11:00:07 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Nov
 2019 19:00:07 +0000
Subject: Re: [PATCH v2 05/18] mm/gup: introduce pin_user_pages*() and FOLL_PIN
To:     Mike Rapoport <rppt@kernel.org>
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
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-6-jhubbard@nvidia.com>
 <20191105131032.GG25005@rapoport-lnx>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <9ac948a4-59bf-2427-2007-e460aad2848a@nvidia.com>
Date:   Tue, 5 Nov 2019 11:00:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191105131032.GG25005@rapoport-lnx>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572980412; bh=ojXJL7Jf2vtMqYP0b7gLz2fp+ItJt4NPdkhylbujo04=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=BS0Skgz5RbNv7FRT3SjRhdwpwr0ecQ8AOgMazMsduNtoC93TjDB3sb+UV4BVm8kS1
         e2YIxx2R9GvEAZtEOkrlW3cAbcdFl/wyRSANMj//120w5PZgTkX7MC1O13jzRSXm0k
         KFRmKs+Z0OYFmlbRMapMiylU4RVjtXOt6K/rgWvnwLDQgPciqV1nCOSRX3qgMUJrsh
         MPxa2/es4pKZhwzhaTFebsG3i4fLxzYnNXRQBChEYKYp2xONV3pwMnS3x1UJtQUm9p
         dbWIIJyjFTTd1aKcwIBzPf2GKUh34tHy3QJ9j5720Clm3FqPmta2g3ZZa8fKcxJoAO
         rGK6L5pnX3YOQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/19 5:10 AM, Mike Rapoport wrote:
...
>> ---
>>  Documentation/vm/index.rst          |   1 +
>>  Documentation/vm/pin_user_pages.rst | 212 ++++++++++++++++++++++
> 
> I think it belongs to Documentation/core-api.

Done:

diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index ab0eae1c153a..413f7d7c8642 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -31,6 +31,7 @@ Core utilities
    generic-radix-tree
    memory-allocation
    mm-api
+   pin_user_pages
    gfp_mask-from-fs-io
    timekeeping
    boot-time-mm


...
>> diff --git a/Documentation/vm/pin_user_pages.rst b/Documentation/vm/pin_user_pages.rst
>> new file mode 100644
>> index 000000000000..3910f49ca98c
>> --- /dev/null
>> +++ b/Documentation/vm/pin_user_pages.rst
>> @@ -0,0 +1,212 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +====================================================
>> +pin_user_pages() and related calls
>> +====================================================
> 
> I know this is too much to ask, but having pin_user_pages() a part of more
> general GUP description would be really great :)
> 

Yes, definitely. But until I saw the reaction to the pin_user_pages() API
family, I didn't want to write too much--it could have all been tossed out
in favor of a whole different API. But now that we've had some initial
reviews, I'm much more confident in being able to write about the larger 
API set.

So yes, I'll put that on my pending list.


...
>> +This document describes the following functions: ::
>> +
>> + pin_user_pages
>> + pin_user_pages_fast
>> + pin_user_pages_remote
>> +
>> + pin_longterm_pages
>> + pin_longterm_pages_fast
>> + pin_longterm_pages_remote
>> +
>> +Basic description of FOLL_PIN
>> +=============================
>> +
>> +A new flag for get_user_pages ("gup") has been added: FOLL_PIN. FOLL_PIN has
> 
> Consider reading this after, say, half a year ;-)
> 

OK, OK. I knew when I wrote that that it was not going to stay new forever, but
somehow failed to write the right thing anyway. :) 

Here's a revised set of paragraphs:

Basic description of FOLL_PIN
=============================

FOLL_PIN and FOLL_LONGTERM are flags that can be passed to the get_user_pages*()
("gup") family of functions. FOLL_PIN has significant interactions and
interdependencies with FOLL_LONGTERM, so both are covered here.

Both FOLL_PIN and FOLL_LONGTERM are internal to gup, meaning that neither
FOLL_PIN nor FOLL_LONGTERM should not appear at the gup call sites. This allows
the associated wrapper functions  (pin_user_pages() and others) to set the
correct combination of these flags, and to check for problems as well.


thanks,

John Hubbard
NVIDIA
