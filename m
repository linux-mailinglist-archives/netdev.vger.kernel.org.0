Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD321EBB42
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfJaXxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:53:42 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7006 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfJaXxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:53:41 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dbb74090000>; Thu, 31 Oct 2019 16:53:46 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 31 Oct 2019 16:53:40 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 31 Oct 2019 16:53:40 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 31 Oct
 2019 23:53:39 +0000
Subject: Re: [PATCH 19/19] Documentation/vm: add pin_user_pages.rst
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-20-jhubbard@nvidia.com>
 <20191031234922.GM14771@iweiny-DESK2.sc.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <85de5845-d403-dc31-4f3b-f006c4a7b2a2@nvidia.com>
Date:   Thu, 31 Oct 2019 16:53:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191031234922.GM14771@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572566026; bh=vjWEFq7fNfPLFBVwJSkbaC93kNFVP4oSS83LfHWMvq4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=huUn94OR5NVpnI/NdJ3vTkz0Aags6KkZKFci9Fz5nHWE/pFd85Cktt11D1CQUWnOi
         UTPR4qv0QPFgv/ONDQLcPNmALzbnAKqxnplv+MLSg0Lt5g7PakxG9E1PUBNwTzA4dg
         k5IpEf3tN9qoIDtETnu//UzIRidkW3Ptv7qB5nHQktouL6xNQxT4kKgi3v8i+IvKdv
         ffAJkGbaVSplOPwrv6cDHUyGv5RC9JGCEhmv/YdTyy6OAb8LAtR2JiVi7nJzrIOI/o
         Ji4iiKunwQFUjG8sIvZShB4w9wwsMfCPKf36InyfzANf6JSqnPhJXe3qBOy7AOjUTp
         IqJ2SDnd3CyHg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 4:49 PM, Ira Weiny wrote:
> On Wed, Oct 30, 2019 at 03:49:30PM -0700, John Hubbard wrote:
>> Document the new pin_user_pages() and related calls
>> and behavior.
>>
>> Thanks to Jan Kara and Vlastimil Babka for explaining the 4 cases
>> in this documentation. (I've reworded it and expanded on it slightly.)
> 
> As I said before I think this may be better in a previous patch where you
> reference it.

Yes, I'll merge this in with patch #5 ("mm/gup: introduce pin_user_pages*()
and FOLL_PIN").

...
>> +TODO: There is also a special case when the pages are DAX pages: in addition to
>> +the above flags, the caller needs something like a layout lease on the
>> +associated file. This is yet to be implemented. When it is implemented, it's
>> +expected that the lease will be a prerequisite to setting FOLL_LONGTERM.
> 
> For now we probably want to leave this note out until we figure out how this is
> going to work.  Best to say something like:
> 
> Some pages, such as DAX pages, can't be pinned with longterm pins and will
> fail.
> 

OK, that is better, I'll use that instead of the "TODO".


thanks,

John Hubbard
NVIDIA
