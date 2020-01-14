Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7762D13B37F
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 21:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgANUPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 15:15:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13500 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgANUPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 15:15:11 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1e21390001>; Tue, 14 Jan 2020 12:14:49 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 14 Jan 2020 12:15:09 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 14 Jan 2020 12:15:09 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Jan
 2020 20:15:09 +0000
Subject: Re: [PATCH v12 00/22] mm/gup: prereqs to track dma-pinned pages:
 FOLL_PIN
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
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
References: <20200107224558.2362728-1-jhubbard@nvidia.com>
 <2a9145d4-586e-6489-64e4-0c54f47afaa1@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <9d7f3c1a-6020-bdec-c513-80c5399e55d7@nvidia.com>
Date:   Tue, 14 Jan 2020 12:15:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2a9145d4-586e-6489-64e4-0c54f47afaa1@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579032890; bh=wLxNzNFRStaOZ7jAQIV4tH1wBKaWmBKZBOUdkq/PVGQ=;
        h=X-PGP-Universal:Subject:From:To:CC:References:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=bNQcHd+kt2S6qArSD90PMkNX5LSRoo2toPf1fdY/D3ysgVjnnuMPbcBLvU4mGjBbT
         LR4uZiIEi3/mAViybdXB1PH001dny/ndD230xDMGlhs7NAYpQR6mGLaj5Fl0H44uol
         s/WH8SaFGbiYHrC+Jf2F7bChe3A2NqguquLvhseggPHll2epR/FoT6c0YMA6JGSKkp
         eSDWR40pps95gbxdKKvy2DClT3lBSMdUwcemTQnf2Jrxy6nLuQLIDhcegQ+kyGcscI
         uknj/1R1Mw2ETSzcXASW/vo/Q3g+SHupTZUPph9j3ZAnq/QlpAxhi10ckpA46Ke/0I
         HjefW3dJ5Akvg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/20 2:07 PM, John Hubbard wrote:
> On 1/7/20 2:45 PM, John Hubbard wrote:
>> Hi,
>>
>> The "track FOLL_PIN pages" would have been the very next patch, but it is
>> not included here because I'm still debugging a bug report from Leon.
>> Let's get all of the prerequisite work (it's been reviewed) into the tree
>> so that future reviews are easier. It's clear that any fixes that are
>> required to the tracking patch, won't affect these patches here.
>>
>> This implements an API naming change (put_user_page*() -->
>> unpin_user_page*()), and also adds FOLL_PIN page support, up to
>> *but not including* actually tracking FOLL_PIN pages. It extends
>> the FOLL_PIN support to a few select subsystems. More subsystems will
>> be added in follow up work.
>>
> 
> Hi Andrew and all,
> 
> To clarify: I'm hoping that this series can go into 5.6.
> 
> Meanwhile, I'm working on tracking down and solving the problem that Leon
> reported, in the "track FOLL_PIN pages" patch, and that patch is not part of
> this series.
> 

Hi Andrew and all,

Any thoughts on this?

As for the not-included-yet tracking patch, my local testing still suggests the
need to allow for larger refcounts of huge pages (in other words, I can write a test
to pin huge pages many times, and overflow with the same backtrace that Leon has
reported).

The second struct page (I recall Jan suggested) can hold those, so I'm going to proceed
with that approach, while waiting to see if Leon has any more test data for me.

Again, I think this series is worth getting out of the way, in the meantime.


thanks,
-- 
John Hubbard
NVIDIA
