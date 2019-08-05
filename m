Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F81827BD
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 00:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbfHEWyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 18:54:38 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17712 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbfHEWyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 18:54:38 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d48b3b50000>; Mon, 05 Aug 2019 15:54:45 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 05 Aug 2019 15:54:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 05 Aug 2019 15:54:36 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 5 Aug
 2019 22:54:35 +0000
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
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <c35aa2bf-c830-9e57-78ca-9ce6fb6cb53b@nvidia.com>
Date:   Mon, 5 Aug 2019 15:54:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724061750.GA19397@infradead.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565045686; bh=su7Un7Lsr0IB37YVHfSyk5WWru26t8lLPZpTgkOrxAY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=MABsVuv2G9BzGpy+DkzIhxi90zmgNTMYOagd/ashPLcDOi2sWU6YznkbyPDv/xcq/
         O5RFeXAwmCAh/JO0LO+ze2NEhPe2n+psweVYXa8pjERXCCCfGYTxQ9SDkc4s4KNR59
         NLyb52q+/1fN+RE5h7a69JZCsNpaL7gcHJobrCC7E9UqWrmG9ACN7VwIX7DKaTA/Rb
         eRaFep1AoazjTxyXxT6Tx1JQhDVjP38m4xzwGlHYvs4ZQCYA68yceeG7xda5nxeUcP
         Q7wlfmFbcUA/T+jBVHNbqmQyCuHaQMhgKiqtQK78vKYLrwPUcmbghr4B0X7IdrZjfb
         e4QZrUIdtNMcg==
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

Hi Christoph,

Are you working on anything like this? Or on the put_user_bvec() idea?
Please let me know, otherwise I'll go in and implement something here.


thanks,
--=20
John Hubbard
NVIDIA

> Out of those ITER_BVEC needs a user page reference, so we want to call
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
