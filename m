Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EACF104E01
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKUIct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:32:49 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17688 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfKUIct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:32:49 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd64bb20000>; Thu, 21 Nov 2019 00:32:51 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 21 Nov 2019 00:32:47 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 21 Nov 2019 00:32:47 -0800
Received: from [10.2.169.101] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Nov
 2019 08:32:47 +0000
Subject: Re: [PATCH v7 02/24] mm/gup: factor out duplicate code from four
 routines
To:     Christoph Hellwig <hch@lst.de>
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-3-jhubbard@nvidia.com> <20191121080356.GA24784@lst.de>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <852f6c27-8b65-547b-89e0-e8f32a4d17b9@nvidia.com>
Date:   Thu, 21 Nov 2019 00:29:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121080356.GA24784@lst.de>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574325171; bh=zDciOg6KuRn3nxO/F8s9PAXpBobtVEtvpIDiU9i7cho=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=o245NH6j1RBD/91bIgnXA2u+iVZPtUYc4XEd05QhEOZNOiZYzfw/GFcveJvKQudX5
         dLZsGgVUHhvmd1nGNx/JrZ9mxzYaJw5jBv7I9AOtjq55xyJVy978/mkepEaZsZ4Jdh
         F7Q1lJglcDgOm/TfPzXptT+ffg3dPcYqQ/YE2QHKjAn7RuUVlfvjepKyjOT8iLOeP5
         P9RGmGVhbNZZaq2buLl/ZGciWf84d+hZhxGEZwtKDXdTaeOTeOoxk+GuaJBpkc922I
         5UIDntRh0zXkYjneJ/cY0eUs62/fAinVukvPCoGn37W+7eCdxnHrxBHjSsCjqEp6Ly
         txEbXCaryPmyA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 12:03 AM, Christoph Hellwig wrote:
> On Wed, Nov 20, 2019 at 11:13:32PM -0800, John Hubbard wrote:
>> There are four locations in gup.c that have a fair amount of code
>> duplication. This means that changing one requires making the same
>> changes in four places, not to mention reading the same code four
>> times, and wondering if there are subtle differences.
>>
>> Factor out the common code into static functions, thus reducing the
>> overall line count and the code's complexity.
>>
>> Also, take the opportunity to slightly improve the efficiency of the
>> error cases, by doing a mass subtraction of the refcount, surrounded
>> by get_page()/put_page().
>>
>> Also, further simplify (slightly), by waiting until the the successful
>> end of each routine, to increment *nr.
> 
> Any reason for the spurious underscore in the function name?

argghh, I just fixed that, but applied the fix to the wrong patch! So now
patch 17 ("mm/gup: track FOLL_PIN pages") is improperly renaming it, instead
of this patch naming it correctly in the first place. Will fix.

> 
> Otherwise this looks fine and might be a worthwhile cleanup to feed
> Andrew for 5.5 independent of the gut of the changes.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks for the reviews! Say, it sounds like your view here is that this
series should be targeted at 5.6 (not 5.5), is that what you have in mind?
And get the preparatory patches (1-9, and maybe even 10-16) into 5.5?

thanks,
-- 
John Hubbard
NVIDIA
