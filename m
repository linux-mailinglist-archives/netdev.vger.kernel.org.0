Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C9EFC00B
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 07:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfKNGIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 01:08:15 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16008 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfKNGIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 01:08:14 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dccef4c0000>; Wed, 13 Nov 2019 22:08:12 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 Nov 2019 22:08:13 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 Nov 2019 22:08:13 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Nov
 2019 06:08:12 +0000
Subject: Re: [PATCH v4 09/23] mm/gup: introduce pin_user_pages*() and FOLL_PIN
From:   John Hubbard <jhubbard@nvidia.com>
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
 <3850aa22-6f03-bd2b-024f-5736c4461199@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <7c590a1a-25c6-a8e7-d471-8855ceea8606@nvidia.com>
Date:   Wed, 13 Nov 2019 22:08:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3850aa22-6f03-bd2b-024f-5736c4461199@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573711692; bh=DIdS7z+upWWwriggk7xvQh6W6C7nto/Dlb+Yd8YHyyo=;
        h=X-PGP-Universal:Subject:From:To:CC:References:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=f9GCQv7TfzjvQX+YKkhiJDV/kP32g+HvR9S+vDLbLe8tqa50A8oxNI045niH9oWR6
         Q+cRQMMuOwkhrc3UyHNB5dnYTxj30KiXA71H5zxupkKbZfd2ps9XV2bsxg1JSEMDdw
         qf9Vcd6U4xnrGLaZQaGULc5hp7BtrN3TQq1+4QNeiyHZ0EANBdTplhxuReTGSebwB/
         f90gLRmPU4TtSLCTxR2K8crrcttWruVUEFFlnGiNse7TapK6yl28TNAEQQYeEakb+c
         3z6jTyDq+9/ON54Pzsd2O5eKTbjzgyBeQwB7ztFRyxIYohzwkLXX9l0JxAXtOLXL+I
         x4TC/t1hFahNQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/19 3:22 PM, John Hubbard wrote:
> On 11/13/19 2:43 AM, Jan Kara wrote:
> ...
>> How does FOLL_PIN result in grabbing (at least normal, for now) page reference?
>> I didn't find that anywhere in this patch but it is a prerequisite to
>> converting any user to pin_user_pages() interface, right?
> 
> 
> ohhh, I messed up on this intermediate patch: it doesn't quite stand alone as
> it should, as you noticed. To correct this, I can do one of the following:
> 
> a) move the new pin*() routines into the later patch 16 ("mm/gup:
> track FOLL_PIN pages"), or
> 
> b) do a temporary thing here, such as setting FOLL_GET and adding a TODO,
> within the pin*() implementations. And this switching it over to FOLL_PIN
> in patch 16.
> 
> I'm thinking (a) is less error-prone, so I'm going with that unless someone
> points out that that is stupid. :)
> 

OK, just to save anyone from wasting time reading the above: (a) is, in fact,
stupid, after all. ha. That is because pin_user_pages() is called in the 
intervening patches.
 
So anyway, I'll work out an ordering to fix it up, it's not complicated.


thanks,
-- 
John Hubbard
NVIDIA

