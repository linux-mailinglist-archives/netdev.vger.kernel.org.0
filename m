Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9998D1012DD
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 06:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfKSFRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 00:17:31 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5661 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSFRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 00:17:30 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd37aeb0000>; Mon, 18 Nov 2019 21:17:32 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 18 Nov 2019 21:17:29 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 18 Nov 2019 21:17:29 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Nov
 2019 05:17:28 +0000
Subject: Re: [PATCH v5 10/24] mm/gup: introduce pin_user_pages*() and FOLL_PIN
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
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
 <20191115055340.1825745-11-jhubbard@nvidia.com>
 <20191118101601.GF17319@quack2.suse.cz>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <aa15a76f-7054-2db2-4a47-8fbe1594295a@nvidia.com>
Date:   Mon, 18 Nov 2019 21:17:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191118101601.GF17319@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574140652; bh=j4L4ESflFWPcWXUSa4QBFr0g8LzukvpI57j3tX0u+LI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=HbjIjhLqDGlCz9fdO9WJ5XZ1MylRhdOt3hOrXOPV4rhTnQVDZpbMvOZlSwNGJc66E
         /dS/T8ygBehTtSzMJwZ3TOTHElFkCJKdPHvXGZaLpQt9mjPgsblK2PBNnMrg02Wmdh
         9Qm8oCkWiYkFORrigI0hEzL7aY7iY3cHZ1DrJYjhRQ5sx+Tmm0Tw8QlCh7Z2iKTLps
         yMslWIbYXkh6S/YZKISH7oHSmmR+hcZRdC+ZCjemhpD6kLdzSXTQ0ykjer3SCrjsmC
         1w7ai76vYnn+iNTaSLHytmXdlQYChVn5NpYDDm4H81+ayvHDf9eTllSFjtIJNz8Xoj
         cb1UR17mTvf1w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 2:16 AM, Jan Kara wrote:
> On Thu 14-11-19 21:53:26, John Hubbard wrote:
>>  /*
>> - * NOTE on FOLL_LONGTERM:
>> + * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
>> + * other. Here is what they mean, and how to use them:
>>   *
>>   * FOLL_LONGTERM indicates that the page will be held for an indefinite time
>> - * period _often_ under userspace control.  This is contrasted with
>> - * iov_iter_get_pages() where usages which are transient.
>> + * period _often_ under userspace control.  This is in contrast to
>> + * iov_iter_get_pages(), where usages which are transient.
>                           ^^^ when you touch this, please fix also the
> second sentense. It doesn't quite make sense to me... I'd probably write
> there "whose usages are transient" but maybe you can come up with something
> even better.

Fixed, using your wording, as I didn't see any obvious improvements beyond that.



thanks,
-- 
John Hubbard
NVIDIA


> 
> Otherwise the patch looks good to me so feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 
