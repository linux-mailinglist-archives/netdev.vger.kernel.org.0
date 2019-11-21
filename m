Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89810104E96
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfKUI5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:57:48 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10315 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfKUI5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:57:47 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd651870000>; Thu, 21 Nov 2019 00:57:43 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 21 Nov 2019 00:57:42 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 21 Nov 2019 00:57:42 -0800
Received: from [10.2.169.101] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Nov
 2019 08:57:41 +0000
Subject: Re: [PATCH v7 05/24] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
To:     Christoph Hellwig <hch@lst.de>
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
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
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
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-6-jhubbard@nvidia.com> <20191121080555.GC24784@lst.de>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <c5f8750f-af82-8aec-ce70-116acf24fa82@nvidia.com>
Date:   Thu, 21 Nov 2019 00:54:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121080555.GC24784@lst.de>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574326663; bh=YGQbxCYiHGws7JmssYZZfu4b/BH3QCdRJ1MPzdi8DdI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FbrZ4378j2iyBO9hvWSMloyNdNsTUz/psuT/NCUARgzB35AW0Wq9ueJvfblZCosk7
         /+/rxtO6ichr/aFPIlD7xLBQtc9hq7EFIF6lCnNn9hnclEWNCKgA7YoyhRbt/m4Vsk
         wRmCgWdXHHISljd4LjYmGbzccrPj5+Fa1JlqaI75caluLphJJldJZkgCWUPC0xholt
         6X13AINTENnATeVUOSXXiPHblxU1cCkaaO1aE9kIv76y0chkTgEt3S0BIhZzBbKb9q
         pD1vYn6vGejSUU1Vf+Wlw9+f+WagzvL/JI66W61oW1V6Mdo52NCQD9IyiBTxjX+ttQ
         VAYphrAfRS+XQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 12:05 AM, Christoph Hellwig wrote:
> So while this looks correct and I still really don't see the major
> benefit of the new code organization, especially as it bloats all
> put_page callers.
> 
> I'd love to see code size change stats for an allyesconfig on this
> commit.
> 

Right, I'm running that now, will post the results. (btw, if there is
a script and/or standard format I should use, I'm all ears. I'll dig
through lwn...)



thanks,
-- 
John Hubbard
NVIDIA
