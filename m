Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 351CB80076
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 20:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbfHBSw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 14:52:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5322 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfHBSwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 14:52:55 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d44868e0000>; Fri, 02 Aug 2019 11:53:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 02 Aug 2019 11:52:53 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 02 Aug 2019 11:52:53 -0700
Received: from [10.2.171.217] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 2 Aug
 2019 18:52:52 +0000
Subject: Re: [PATCH 16/34] drivers/tee: convert put_page() to put_user_page*()
To:     Jens Wiklander <jens.wiklander@linaro.org>,
        <john.hubbard@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <amd-gfx@lists.freedesktop.org>, <ceph-devel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <devel@lists.orangefs.org>,
        <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        <linux-block@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-nfs@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-xfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <sparclinux@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802022005.5117-17-jhubbard@nvidia.com>
 <CAHUa44G++iiwU62jj7QH=V3sr4z26sf007xrwWLPw6AAeMLAEw@mail.gmail.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <23cc9ac3-4b03-9187-aae6-d64ba8cfca00@nvidia.com>
Date:   Fri, 2 Aug 2019 11:51:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAHUa44G++iiwU62jj7QH=V3sr4z26sf007xrwWLPw6AAeMLAEw@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564771982; bh=CFAZPyZ9nyhPuztKsk/cdMMUIvZ+gPTM3kJiO5Miqjw=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ot3YKf5tvKuqvfXnHFOaqaBQdxJLPGhqZRpe5CvAqHZLCjzw07N/807rN30ol1bdm
         nSwbs6gHuJ0OhztqkvSHwPR2slPtTDH8B6O0PTm5jeGujoQh8m+xI16KJQgg3RcoMR
         UmCB87Ti9N/9lxRub68goKft4A4cSSIx2dfCYEbKRo3lQGuFQW16SKp/EWIKLGs/zO
         EK17YqQ1lGvgW/45aW7/Z5pzy0Gf5VysXOYCi076on7MtH51Ov9Uy2W59ssEl2aP4N
         G3YJtwUCv04lDB6y7cBERLsZUR9V90J5rUhO14bUw0xWFxWN4jqCBXztLnN9RVkDQG
         l2CwayAFuEHwg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 11:29 PM, Jens Wiklander wrote:
> On Fri, Aug 2, 2019 at 4:20 AM <john.hubbard@gmail.com> wrote:
>>
>> From: John Hubbard <jhubbard@nvidia.com>
>>
>> For pages that were retained via get_user_pages*(), release those pages
>> via the new put_user_page*() routines, instead of via put_page() or
>> release_pages().
>>
>> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
>> ("mm: introduce put_user_page*(), placeholder versions").
>>
>> Cc: Jens Wiklander <jens.wiklander@linaro.org>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>> ---
>>   drivers/tee/tee_shm.c | 10 ++--------
>>   1 file changed, 2 insertions(+), 8 deletions(-)
> 
> Acked-by: Jens Wiklander <jens.wiklander@linaro.org>
> 
> I suppose you're taking this via your own tree or such.
> 

Hi Jens,

Thanks for the ACK! I'm expecting that Andrew will take this through his
-mm tree, unless he pops up and says otherwise.

thanks,
-- 
John Hubbard
NVIDIA
