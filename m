Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445AAF9FD7
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfKMBIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:08:14 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9626 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKMBIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 20:08:13 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcb577a0001>; Tue, 12 Nov 2019 17:08:11 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 17:08:08 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 12 Nov 2019 17:08:08 -0800
Received: from MacBook-Pro-10.local (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 01:08:07 +0000
Subject: Re: [PATCH v3 08/23] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
To:     Dan Williams <dan.j.williams@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
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
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, KVM list <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Netdev <netdev@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20191112000700.3455038-1-jhubbard@nvidia.com>
 <20191112000700.3455038-9-jhubbard@nvidia.com>
 <20191112204338.GE5584@ziepe.ca>
 <0db36e86-b779-01af-77e7-469af2a2e19c@nvidia.com>
 <CAPcyv4hAEgw6ySNS+EFRS4yNRVGz9A3Fu1vOk=XtpjYC64kQJw@mail.gmail.com>
 <20191112234250.GA19615@ziepe.ca>
 <CAPcyv4hwFKmsQpp04rS6diCmZwGtbnriCjfY2ofWV485qT9kzg@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <28355eb0-4ee5-3418-b430-59302d15b478@nvidia.com>
Date:   Tue, 12 Nov 2019 17:08:07 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hwFKmsQpp04rS6diCmZwGtbnriCjfY2ofWV485qT9kzg@mail.gmail.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573607291; bh=wl9HqaOmiz62D7VoXo7FjyMU54D3XRSGYP3F6kh9mOM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=BVU7rtLSKH40gEcG6jSN5CiYgtuH0Fsti8jOVN/t2cAsa7Lm+CfaOZ/cPBpKb/4pw
         t2vrd447reb2cZaNtW1CrBBDCDSmRKvz10axjxdYouKdjIwayolxMRUvbWVZvRVnkG
         svn8sgOn4uKeOQZMstm5QEuB1y1OABbj5Qg0iRg3RASWgUP54Ma2UJ/YLgr8iKpjqC
         Mji+oXkSdbgJiidbxXQS/C9y8AEU32Ewa2NYrZGcfO6vFwup2ff4CZ6OIxWxJdqYtM
         ZNX94L/R/d+iS0MKljVZcNT6wxULepfnHo9F4Q3KqGJu8/w+Vf+0hpqV8JvGKGhjvb
         RkKNrnEIsYK7Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/19 4:58 PM, Dan Williams wrote:
...
>>> It's not redundant relative to upstream which does not do anything the
>>> FOLL_LONGTERM in the gup-slow path... but I have not looked at patches
>>> 1-7 to see if something there made it redundant.
>>
>> Oh, the hunk John had below for get_user_pages_remote() also needs to
>> call __gup_longterm_locked() when FOLL_LONGTERM is specified, then
>> that calls check_dax_vmas() which duplicates the vma_is_fsdax() check
>> above.
> 
> Oh true, good eye. It is redundant if it does additionally call
> __gup_longterm_locked(), and it needs to do that otherwises it undoes
> the CMA migration magic that Aneesh added.
> 

OK. So just to be clear, I'll be removing this from the patch:

	/*
	 * The lifetime of a vaddr_get_pfn() page pin is
	 * userspace-controlled. In the fs-dax case this could
	 * lead to indefinite stalls in filesystem operations.
	 * Disallow attempts to pin fs-dax pages via this
	 * interface.
	 */
	if (ret > 0 && vma_is_fsdax(vmas[0])) {
		ret = -EOPNOTSUPP;
		put_page(page[0]);
  	}

(and the declaration of "vmas", as well).

thanks,
-- 
John Hubbard
NVIDIA
