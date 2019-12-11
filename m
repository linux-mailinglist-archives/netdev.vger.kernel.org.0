Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876C5119FF5
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 01:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfLKA1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 19:27:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9928 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfLKA1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 19:27:49 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df037ed0000>; Tue, 10 Dec 2019 16:27:25 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 10 Dec 2019 16:27:47 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 10 Dec 2019 16:27:47 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Dec
 2019 00:27:46 +0000
Received: from [10.110.48.28] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Dec
 2019 00:27:45 +0000
Subject: Re: [PATCH v8 23/26] mm/gup: pass flags arg to __gup_device_*
 functions
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
        "Mike Kravetz" <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        "Shuah Khan" <shuah@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        <bpf@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <kvm@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20191209225344.99740-1-jhubbard@nvidia.com>
 <20191209225344.99740-24-jhubbard@nvidia.com>
 <20191210124957.GG1551@quack2.suse.cz>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <017cb337-99f0-785c-7fd9-223d3f05e840@nvidia.com>
Date:   Tue, 10 Dec 2019 16:27:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210124957.GG1551@quack2.suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576024046; bh=qun8cg/sHOBwx96E42yhjWjklRPzRNtkdXEjGWJis9k=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ZsA1gWWzEMoxNw4sGMBn0IB6PCN0ayjG1bjHlLTvRKvZNYWfFY6GadphhHH5/oXSG
         JeeIACrDEldkCsiwLSqi7Sb/+s/lrstUEM6ZSkaa3ocFKRVk5BHiT+XSKQ7ZrvWG+N
         y0FLTJm8bSQI8BERNijJq98G8+9Vm3vXUx29fLwfgq+J6rOLjwbNTnpcEijsnqylin
         SaZDw8jS4hgJd1nkfZeanVmYjGG39ms/U3WiHxJYVbPGGDJYFEo916VNZt+5U5P0Or
         fjh47kokYfS4lafjqrrwAa0dWo+eZljJp5xfyflXDQpDbHXAnqoG/R22NwcPm4jWYI
         CAgkYrlfpd8+A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 4:49 AM, Jan Kara wrote:
> On Mon 09-12-19 14:53:41, John Hubbard wrote:
>> A subsequent patch requires access to gup flags, so pass the flags
>> argument through to the __gup_device_* functions.
>>
>> Also placate checkpatch.pl by shortening a nearby line.
>>
>> TODO: Christoph Hellwig requested folding this into the patch the uses
>> the gup flags arguments.
> 
> You should probably implement this TODO? :)
> 
> 								Honza

Yes. Done for v9.

thanks,
-- 
John Hubbard
NVIDIA
