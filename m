Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6487E1034C4
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 08:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfKTHDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 02:03:13 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11798 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfKTHDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 02:03:12 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd4e52b0000>; Tue, 19 Nov 2019 23:03:07 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 Nov 2019 23:03:11 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 Nov 2019 23:03:11 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Nov
 2019 07:03:10 +0000
Subject: Re: [PATCH v6 15/24] fs/io_uring: set FOLL_PIN via pin_user_pages()
To:     Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
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
        Jason Gunthorpe <jgg@ziepe.ca>,
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
References: <20191119081643.1866232-1-jhubbard@nvidia.com>
 <20191119081643.1866232-16-jhubbard@nvidia.com>
 <2ae65d1b-a3eb-74ed-afce-c493de5bbfd3@kernel.dk>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <42c80c0a-ad2c-fe74-babd-57680882c7e2@nvidia.com>
Date:   Tue, 19 Nov 2019 23:03:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <2ae65d1b-a3eb-74ed-afce-c493de5bbfd3@kernel.dk>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574233387; bh=ccH+u52vDWCSpx4Mj41DBPFk4Bnr7E1/buLUhbEm50I=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=aoAjA12TDjtYHcqzP6KlOL/T+xFannzF2Ut7WBeMCWKWq7l/9YzjhnMxWFHzZfpR5
         Iws/71eVjdglCRCFx0borbQjrcWdlbhRBVNYLCTSxJhf+kal1fvOFNYQqlhw4wL9J6
         MFYFTVnA4OaNermjnVJWu68MlONq0QSjgN/vAiaH7Huv88r7BI/N2hl/4JJ3pl29Td
         suI6xx3hgozM4FOPwAaNkBjGwwYRC1+cHh6/xlUHPqKTdx1Jisq/17DuqUYf/0K2Yd
         KJ8+BKNAyQOQiWBn8l76F+wCEq0it7z2sVeN/sAFeVR43NYKvAY4EyGL+PsQeLhyI4
         eAwjKJTXDphsw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 8:10 AM, Jens Axboe wrote:
> On 11/19/19 1:16 AM, John Hubbard wrote:
>> Convert fs/io_uring to use the new pin_user_pages() call, which sets
>> FOLL_PIN. Setting FOLL_PIN is now required for code that requires
>> tracking of pinned pages, and therefore for any code that calls
>> put_user_page().
>>
>> In partial anticipation of this work, the io_uring code was already
>> calling put_user_page() instead of put_page(). Therefore, in order to
>> convert from the get_user_pages()/put_page() model, to the
>> pin_user_pages()/put_user_page() model, the only change required
>> here is to change get_user_pages() to pin_user_pages().
>>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> 
> You dropped my reviewed-by now... Given the file, you'd probably want
> to keep that.

Hi Jens,

Yes, I was being too conservative I guess. I changed the patch somewhat
and dropped the reviewed-by because of those changes...I'm adding it
back for v7 based on this, thanks!

thanks,
-- 
John Hubbard
NVIDIA
 
