Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5E8710B0
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 06:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732570AbfGWEnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 00:43:05 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7889 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730761AbfGWEnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 00:43:04 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3690560000>; Mon, 22 Jul 2019 21:43:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 22 Jul 2019 21:43:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 22 Jul 2019 21:43:02 -0700
Received: from [10.2.164.38] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 23 Jul
 2019 04:43:01 +0000
Subject: Re: [PATCH 3/3] net/xdp: convert put_page() to put_user_page*()
To:     Ira Weiny <ira.weiny@intel.com>, <john.hubbard@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, <netdev@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>,
        <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190722223415.13269-1-jhubbard@nvidia.com>
 <20190722223415.13269-4-jhubbard@nvidia.com>
 <20190723002534.GA10284@iweiny-DESK2.sc.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <a4e9b293-11f8-6b3c-cf4d-308e3b32df34@nvidia.com>
Date:   Mon, 22 Jul 2019 21:41:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723002534.GA10284@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563856982; bh=6Lt/z2MUaW0HLuGN6nPZXpx+R7NECtbBk4FafHzD+OU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Qa3lZLE8Kf/RL8KhFgPo9Jkt7HFiKw1Is4rV87XoFGEKvWzwvIu+hxfTzr2uraY59
         XErNMpPf1Qu2zCNLtYfVRqCa3/zsPozeqvDkM44qxxIpWE47R8YoLoPjAb9uunMk0+
         2+b5UcPkOzZtt+IdgVMrvpTMyr/Pdu3kowZiYCl3u00yAyQSmsitBmCoJle4OhJXpe
         bMuJ8grmilp9xNLC2hggYcxZ/uAvyWeQge9toK1cze9EOdK1UUkTm+VI05DdS87kNs
         cGOrzWdia2G/F74bOT0v75OXAOE8VdSB9dSxGpUKwW6BkxObVy2erx/jSiG+ZKKb1I
         5O4vdoqzeZX4g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/19 5:25 PM, Ira Weiny wrote:
> On Mon, Jul 22, 2019 at 03:34:15PM -0700, john.hubbard@gmail.com wrote:
>> From: John Hubbard <jhubbard@nvidia.com>
>>
>> For pages that were retained via get_user_pages*(), release those pages
>> via the new put_user_page*() routines, instead of via put_page() or
>> release_pages().
>>
>> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
>> ("mm: introduce put_user_page*(), placeholder versions").
>>
>> Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>> ---
>>   net/xdp/xdp_umem.c | 9 +--------
>>   1 file changed, 1 insertion(+), 8 deletions(-)
>>
>> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>> index 83de74ca729a..0325a17915de 100644
>> --- a/net/xdp/xdp_umem.c
>> +++ b/net/xdp/xdp_umem.c
>> @@ -166,14 +166,7 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
>>  =20
>>   static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>>   {
>> -	unsigned int i;
>> -
>> -	for (i =3D 0; i < umem->npgs; i++) {
>> -		struct page *page =3D umem->pgs[i];
>> -
>> -		set_page_dirty_lock(page);
>> -		put_page(page);
>> -	}
>> +	put_user_pages_dirty_lock(umem->pgs, umem->npgs);
>=20
> What is the difference between this and
>=20
> __put_user_pages(umem->pgs, umem->npgs, PUP_FLAGS_DIRTY_LOCK);
>=20
> ?

No difference.

>=20
> I'm a bit concerned with adding another form of the same interface.  We s=
hould
> either have 1 call with flags (enum in this case) or multiple calls.  Giv=
en the
> previous discussion lets move in the direction of having the enum but don=
't
> introduce another caller of the "old" interface.

I disagree that this is a "problem". There is no maintenance pitfall here; =
there
are merely two ways to call the put_user_page*() API. Both are correct, and
neither one will get you into trouble.

Not only that, but there is ample precedent for this approach in other
kernel APIs.

>=20
> So I think on this patch NAK from me.
>=20
> I also don't like having a __* call in the exported interface but there i=
s a
> __get_user_pages_fast() call so I guess there is precedent.  :-/
>=20

I thought about this carefully, and looked at other APIs. And I noticed tha=
t
things like __get_user_pages*() are how it's often done:

* The leading underscores are often used for the more elaborate form of the
call (as oppposed to decorating the core function name with "_flags", for
example).

* There are often calls in which you can either call the simpler form, or t=
he
form with flags and additional options, and yes, you'll get the same result=
.

Obviously, this stuff is all subject to a certain amount of opinion, but I
think I'm on really solid ground as far as precedent goes. So I'm pushing
back on the NAK... :)

thanks,
--=20
John Hubbard
NVIDIA

