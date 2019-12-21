Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31627128C02
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 01:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfLVACZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 19:02:25 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3582 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfLVACY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 19:02:24 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfeb2820001>; Sat, 21 Dec 2019 16:02:11 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sat, 21 Dec 2019 16:02:22 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sat, 21 Dec 2019 16:02:22 -0800
Received: from [10.2.167.41] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 22 Dec
 2019 00:02:18 +0000
Subject: Re: [PATCH v11 00/25] mm/gup: track dma-pinned pages: FOLL_PIN
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
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
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
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
        Maor Gottlieb <maorg@mellanox.com>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191219132607.GA410823@unreal>
 <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
 <20191219210743.GN17227@ziepe.ca> <20191220182939.GA10944@unreal>
 <1001a5fc-a71d-9c0f-1090-546c4913d8a2@nvidia.com>
 <20191221100843.GB13335@unreal>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <9261f37b-5932-4580-cbc8-f591b0b33b2a@nvidia.com>
Date:   Sat, 21 Dec 2019 15:59:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191221100843.GB13335@unreal>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576972931; bh=95pYs1E9YJXlQbksWpOmj6qddfnejBQ8umGtr6ZpFwY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Ih1gQcFIGgKg5n193VWHK/fpuYOWnxEAjDWwUpeL0db+IZfCrijIZXMmxlXytkJAy
         GyHybquB0rAC4PSC5fyYYOxPtnlJHJXbYbE1OnuToKQzSNtOX1E6jCjMDILoLbqZ4V
         OX5Q1eZnL4jcgn4z6z9ok9K0mg+OyYm6pC3L/Y0Cn97KIjBe5Xa80wOPiCj7nBJ7Qf
         tzyFw5L1dY/NfwyZ7ZrE7k0OMtxXiptqvzxEOmfi4Y/W4Mi7z2d4dMo373vMb2W5ZL
         8xmwOO+L537Cy6K9gc3OcvyItc0amK8uE6k5ZFJ8R4rau7j4DfEX/idektDGaSQXw9
         Z/MQNsIwlLFsA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21/19 2:08 AM, Leon Romanovsky wrote:
> On Fri, Dec 20, 2019 at 03:54:55PM -0800, John Hubbard wrote:
>> On 12/20/19 10:29 AM, Leon Romanovsky wrote:
>> ...
>>>> $ ./build.sh
>>>> $ build/bin/run_tests.py
>>>>
>>>> If you get things that far I think Leon can get a reproduction for you
>>>
>>> I'm not so optimistic about that.
>>>
>>
>> OK, I'm going to proceed for now on the assumption that I've got an overflow
>> problem that happens when huge pages are pinned. If I can get more information,
>> great, otherwise it's probably enough.
>>
>> One thing: for your repro, if you know the huge page size, and the system
>> page size for that case, that would really help. Also the number of pins per
>> page, more or less, that you'd expect. Because Jason says that only 2M huge
>> pages are used...
>>
>> Because the other possibility is that the refcount really is going negative,
>> likely due to a mismatched pin/unpin somehow.
>>
>> If there's not an obvious repro case available, but you do have one (is it easy
>> to repro, though?), then *if* you have the time, I could point you to a github
>> branch that reduces GUP_PIN_COUNTING_BIAS by, say, 4x, by applying this:
> 
> I'll see what I can do this Sunday.
> 

The other data point that might shed light on whether it's a mismatch (this only
works if the system is not actually crashing, though), is checking the new
vmstat items, like this:

$ grep foll_pin /proc/vmstat
nr_foll_pin_requested 16288188
nr_foll_pin_returned 16288188

...but OTOH, if you've got long-term pins, then those are *supposed* to be
mismatched, so it only really helps in between tests.

thanks,
-- 
John Hubbard
NVIDIA
