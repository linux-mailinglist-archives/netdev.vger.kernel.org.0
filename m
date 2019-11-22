Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C3B105EC5
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 03:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKVC5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 21:57:00 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4158 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfKVC47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 21:56:59 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd74e740000>; Thu, 21 Nov 2019 18:56:52 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 21 Nov 2019 18:56:51 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 21 Nov 2019 18:56:51 -0800
Received: from [10.2.168.213] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Nov
 2019 02:56:50 +0000
Subject: Re: [PATCH v7 02/24] mm/gup: factor out duplicate code from four
 routines
To:     Jan Kara <jack@suse.cz>
CC:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-3-jhubbard@nvidia.com> <20191121080356.GA24784@lst.de>
 <852f6c27-8b65-547b-89e0-e8f32a4d17b9@nvidia.com>
 <20191121095411.GC18190@quack2.suse.cz>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <9d0846af-2c4f-7cda-dfcb-1f642943afea@nvidia.com>
Date:   Thu, 21 Nov 2019 18:54:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121095411.GC18190@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574391412; bh=qs/HIaIDAchvyMkQnxvFfFcxB81lObthoFNUVM9HFsU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ea5W7/2c5vGNy7OLObdGvq5o0IpGBD08qzI9LgcD4V8BzKvR7hLDcVgsFBzIPWltE
         d8PXmpt/WgSDLuhJB1bSFzEA5jjhwY4dlcU7E+jQRx3TB5rkLOwlZyYegEL3tsBCr8
         8qN6mxRQSSTP+FNbJyR7Zo1HLIMkYFYKo0hlXeg0mt5hFKo6iVEhrdf4E8SgIeOW2y
         us/ORlXUDHvqcnaCH9l42SZAxDz+ZaaZrH8tpmFx0pDTmT79WYa//P0TZxa1PMT2Ec
         60tYwrFVvqZaHos2D7eAOKA1eeY7xDL9USjPj3cYeVVtnic4Fxyow9kLNCXK7YejUg
         or0Rt6li4HM5w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 1:54 AM, Jan Kara wrote:
> On Thu 21-11-19 00:29:59, John Hubbard wrote:
>>>
>>> Otherwise this looks fine and might be a worthwhile cleanup to feed
>>> Andrew for 5.5 independent of the gut of the changes.
>>>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>
>>
>> Thanks for the reviews! Say, it sounds like your view here is that this
>> series should be targeted at 5.6 (not 5.5), is that what you have in mind?
>> And get the preparatory patches (1-9, and maybe even 10-16) into 5.5?
> 
> One more note :) If you are going to push pin_user_pages() interfaces
> (which I'm fine with), it would probably make sense to push also the
> put_user_pages() -> unpin_user_pages() renaming so that that inconsistency
> in naming does not exist in the released upstream kernel.
> 
> 								Honza

Yes, that's what this patch series does. But I'm not sure if "push" here
means, "push out: defer to 5.6", "push (now) into 5.5", or "advocate for"?

I will note that it's not going to be easy to rename in one step, now
that this is being split up. Because various put_user_pages()-based items
are going into 5.5 via different maintainer trees now. Probably I'd need
to introduce unpin_user_page() alongside put_user_page()...thoughts?

thanks,
-- 
John Hubbard
NVIDIA
  
