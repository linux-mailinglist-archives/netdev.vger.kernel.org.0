Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988D4741FB
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 01:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbfGXXX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 19:23:27 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2928 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfGXXX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 19:23:26 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d38e8730000>; Wed, 24 Jul 2019 16:23:31 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 24 Jul 2019 16:23:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 24 Jul 2019 16:23:23 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 24 Jul
 2019 23:23:22 +0000
Subject: Re: [PATCH 00/12] block/bio, fs: convert put_page() to
 put_user_page*()
To:     Christoph Hellwig <hch@infradead.org>, <john.hubbard@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        <ceph-devel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-cifs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <samba-technical@lists.samba.org>,
        <v9fs-developer@lists.sourceforge.net>,
        <virtualization@lists.linux-foundation.org>
References: <20190724042518.14363-1-jhubbard@nvidia.com>
 <20190724061750.GA19397@infradead.org>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <17f12f3d-981e-a717-c8e5-bfbbfb7ec1a3@nvidia.com>
Date:   Wed, 24 Jul 2019 16:23:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724061750.GA19397@infradead.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564010611; bh=U/byz8o3kezigETW8hWUjg+JqkNm/y0Q4UHjAnDVaRI=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=POKycPna3sFHaptSpPG8JFNhdv+KWPJt4Fqq7qra/U5uujHxVhga0mA2hyYe3oLWO
         rvMjdBQgQaYdhe3tYVq3xzWzC7PXLH9gVg6v6GfrdnHKhzPSXOdrUzDa4Sfy+FpWme
         AYx8XN4QHijtxUQThz9jDsFglp/BwmD6wmVyo2Ou4HoX36ySg8r0DnnWDfRMrkzmXC
         XvSXsG7L9llJHump4bjV4yoH02Li7EYgdYhEFhGR3d1oO3a9DGx7nb70VEc+guaDrP
         BAn4DIKE83X0lqImHCnmIIbgjVMdzz9Q4ePUhHR77cnRWD+JGehn4V8I2IYZgTvKbn
         0ENu9Hbk0xmXw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 11:17 PM, Christoph Hellwig wrote:
> On Tue, Jul 23, 2019 at 09:25:06PM -0700, john.hubbard@gmail.com wrote:
>> * Store, in the iov_iter, a "came from gup (get_user_pages)" parameter.
>>   Then, use the new iov_iter_get_pages_use_gup() to retrieve it when
>>   it is time to release the pages. That allows choosing between put_page=
()
>>   and put_user_page*().
>>
>> * Pass in one more piece of information to bio_release_pages: a "from_gu=
p"
>>   parameter. Similar use as above.
>>
>> * Change the block layer, and several file systems, to use
>>   put_user_page*().
>=20
> I think we can do this in a simple and better way.  We have 5 ITER_*
> types.  Of those ITER_DISCARD as the name suggests never uses pages, so
> we can skip handling it.  ITER_PIPE is rejected =D1=96n the direct I/O pa=
th,
> which leaves us with three.
>=20
> Out of those ITER_BVEC needs a user page reference, so we want to call

               ^ ITER_IOVEC, I hope. Otherwise I'm hopeless lost. :)

> put_user_page* on it.  ITER_BVEC always already has page reference,
> which means in the block direct I/O path path we alread don't take
> a page reference.  We should extent that handling to all other calls
> of iov_iter_get_pages / iov_iter_get_pages_alloc.  I think we should
> just reject ITER_KVEC for direct I/O as well as we have no users and
> it is rather pointless.  Alternatively if we see a use for it the
> callers should always have a life page reference anyway (or might
> be on kmalloc memory), so we really should not take a reference either.
>=20
> In other words:  the only time we should ever have to put a page in
> this patch is when they are user pages.  We'll need to clean up
> various bits of code for that, but that can be done gradually before
> even getting to the actual put_user_pages conversion.
>=20

Sounds great. I'm part way into it and it doesn't look too bad. The main
question is where to scatter various checks and assertions, to keep
the kvecs out of direct I/0. Or at least keep the gups away from=20
direct I/0.


thanks,
--=20
John Hubbard
NVIDIA
