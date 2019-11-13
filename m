Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF7DFB9C9
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfKMU1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:27:24 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11058 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfKMU1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:27:23 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcc66ef0001>; Wed, 13 Nov 2019 12:26:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 13 Nov 2019 12:27:19 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 13 Nov 2019 12:27:19 -0800
Received: from [10.2.160.107] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 20:27:18 +0000
Subject: Re: [PATCH v4 09/23] mm/gup: introduce pin_user_pages*() and FOLL_PIN
To:     Ira Weiny <ira.weiny@intel.com>
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
        "David S . Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
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
        Mike Rapoport <rppt@linux.ibm.com>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-10-jhubbard@nvidia.com>
 <20191113185902.GB12915@iweiny-DESK2.sc.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <d5b14492-45a9-914e-92db-29592c3634e5@nvidia.com>
Date:   Wed, 13 Nov 2019 12:24:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191113185902.GB12915@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573676784; bh=ZP9QEqV97zzS7vyaMLJBGQGSKGW2tyNWtWpkiSoCJc4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=blBmwo40hUXWDReswYBJ9TKWl7H2L/k0XDDTqLc9LkITedj/TfVhMrycxbdicryg9
         h3wCNANbDFiVSj6oyHjfFnRbLVuCRi3pWpRJRe/jbCLOFnYnWP5+VYQpU1VxmX02Oe
         x63ynn9Lg49xuQZl/cSCofyxC/5cUmsD/0Qztzy4aTmtjHXl5koB/p/oGnI3O50jC6
         JimPfnxSS5Hd9PocW7OekFWFS3ot4vxXyyvMqqBzeRQ9mC6jlTWwR4/WgqeBc/ncw1
         PM3rgjSIKR9vLy74nuxe2z7dV2iTNewdvjl7FyfEINYcs/7W4YGwW/FeVW7CmMMCVV
         2lZpQK+CR/Twg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/19 10:59 AM, Ira Weiny wrote:
> On Tue, Nov 12, 2019 at 08:26:56PM -0800, John Hubbard wrote:
>> Introduce pin_user_pages*() variations of get_user_pages*() calls,
>> and also pin_longterm_pages*() variations.
>>
>> These variants all set FOLL_PIN, which is also introduced, and
>> thoroughly documented.
>>
>> The pin_longterm*() variants also set FOLL_LONGTERM, in addition
>> to FOLL_PIN:
>>
>>      pin_user_pages()
>>      pin_user_pages_remote()
>>      pin_user_pages_fast()
>>
>>      pin_longterm_pages()
>>      pin_longterm_pages_remote()
>>      pin_longterm_pages_fast()
> 
> At some point in this conversation I thought we were going to put in "unpin_*"
> versions of these.
> 
> Is that still in the plans?
> 

Why yes it is! :)  Daniel Vetter and Jan Kara both already weighed in [1],
in favor of "unpin_user_page*()", rather than "put_user_page*()".

I'll change those names.

[1] https://lore.kernel.org/r/20191113101210.GD6367@quack2.suse.cz


thanks,
-- 
John Hubbard
NVIDIA
