Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEFD711CA76
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbfLLKSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:18:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35175 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728550AbfLLKSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 05:18:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576145925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/RV3uj+8NHFPspwJjX2GHWhoPU20m5g/wC7g2NGzOqk=;
        b=WpJjMYnLUmX280p5lLrvAxdWW2AMa4Wed5mZE52AvgBMGynCgZigewtPcYywTeI1xecpV8
        MO/GzZb1GSQ/brLgS6ME1LLyqm6Ys0d63uRg6sxYysQhONmiPe0So5Q8ThINmiai0R1Ot4
        nDd3YezO3WegXmmWgei4jtKlZTZNBEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-nF9-gOzXNBGscKAqVK7CSQ-1; Thu, 12 Dec 2019 05:18:41 -0500
X-MC-Unique: nF9-gOzXNBGscKAqVK7CSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2671800D41;
        Thu, 12 Dec 2019 10:18:39 +0000 (UTC)
Received: from carbon (ovpn-200-20.brq.redhat.com [10.40.200.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C503B5D9C9;
        Thu, 12 Dec 2019 10:18:33 +0000 (UTC)
Date:   Thu, 12 Dec 2019 11:18:31 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <mhocko@kernel.org>, <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        brouer@redhat.com,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@intel.com>
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Message-ID: <20191212111831.2a9f05d3@carbon>
In-Reply-To: <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
        <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
        <20191211194933.15b53c11@carbon>
        <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
        <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 09:34:14 +0800
Yunsheng Lin <linyunsheng@huawei.com> wrote:

> +CC Michal, Peter, Greg and Bjorn
> Because there has been disscusion about where and how the NUMA_NO_NODE
> should be handled before.
>=20
> On 2019/12/12 5:24, Saeed Mahameed wrote:
> > On Wed, 2019-12-11 at 19:49 +0100, Jesper Dangaard Brouer wrote: =20
> >> On Sat, 7 Dec 2019 03:52:41 +0000
> >> Saeed Mahameed <saeedm@mellanox.com> wrote:
> >> =20
> >>> I don't think it is correct to check that the page nid is same as
> >>> numa_mem_id() if pool is NUMA_NO_NODE. In such case we should allow
> >>> all  pages to recycle, because you can't assume where pages are
> >>> allocated from and where they are being handled. =20
> >>
> >> I agree, using numa_mem_id() is not valid, because it takes the numa
> >> node id from the executing CPU and the call to __page_pool_put_page()
> >> can happen on a remote CPU (e.g. cpumap redirect, and in future
> >> SKBs).
> >>
> >> =20
> >>> I suggest the following:
> >>>
> >>> return !page_pfmemalloc() &&=20
> >>> ( page_to_nid(page) =3D=3D pool->p.nid || pool->p.nid =3D=3D NUMA_NO_=
NODE ); =20
> >>
> >> Above code doesn't generate optimal ASM code, I suggest:
> >>
> >>  static bool pool_page_reusable(struct page_pool *pool, struct page *p=
age)
> >>  {
> >> 	return !page_is_pfmemalloc(page) &&
> >> 		pool->p.nid !=3D NUMA_NO_NODE &&
> >> 		page_to_nid(page) =3D=3D pool->p.nid;
> >>  }
> >> =20
> >=20
> > this is not equivalent to the above. Here in case pool->p.nid is
> > NUMA_NO_NODE, pool_page_reusable() will always be false.
> >=20
> > We can avoid the extra check in data path.
> > How about avoiding NUMA_NO_NODE in page_pool altogether, and force
> > numa_mem_id() as pool->p.nid when user requests NUMA_NO_NODE at page
> > pool init, as already done in alloc_pages_node().  =20
>=20
> That means we will not support page reuse mitigation for NUMA_NO_NODE,
> which is not same semantic that alloc_pages_node() handle NUMA_NO_NODE,
> because alloc_pages_node() will allocate the page based on the node
> of the current running cpu.

True, as I wrote (below) my code defines semantics as: that a page_pool
configured with NUMA_NO_NODE means skip NUMA checks, and allow recycle
regardless of NUMA node page belong to.  It seems that you want another
semantics.

I'm open to other semantics. My main concern is performance.  The
page_pool fast-path for driver recycling use-case of XDP_DROP, have
extreme performance requirements, as it needs to compete with driver
local recycle tricks (else we cannot use page_pool to simplify drivers).
The extreme performance target is 100Gbit/s =3D 148Mpps =3D 6.72ns, and
in practice I'm measuring 25Mpps =3D 40ns with Mlx5 driver (single q),
and Bj=C3=B8rn is showing 30 Mpps =3D 33.3ns with i40e.  At this level every
cycle/instruction counts.

=20
> Also, There seems to be a wild guessing of the node id here, which has
> been disscussed before and has not reached a agreement yet.
>=20
> >=20
> > which will imply recycling without adding any extra condition to the
> > data path.

I love code that moves thing out of our fast-path.

> >=20
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index a6aefe989043..00c99282a306 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -28,6 +28,9 @@ static int page_pool_init(struct page_pool *pool,
> > =20
> >         memcpy(&pool->p, params, sizeof(pool->p));
> > =20
> > +	/* overwrite to allow recycling.. */
> > +       if (pool->p.nid =3D=3D NUMA_NO_NODE)=20
> > +               pool->p.nid =3D numa_mem_id();=20
> > +

The problem is that page_pool_init() is can be initiated from a random
CPU, first at driver setup/bringup, and later at other queue changes
that can be started via ethtool or XDP attach. (numa_mem_id() picks
from running CPU).

As Yunsheng mentioned elsewhere, there is also a dev_to_node() function.
Isn't that what we want in a place like this?


One issue with dev_to_node() is that in case of !CONFIG_NUMA it returns
NUMA_NO_NODE (-1).  (And device_initialize() also set it to -1).  Thus,
in that case we set pool->p.nid =3D 0, as page_to_nid() will also return
zero in that case (as far as I follow the code).


> > After a quick look, i don't see any reason why to keep NUMA_NO_NODE in
> > pool->p.nid..=20
> >=20
> >  =20
> >> I have compiled different variants and looked at the ASM code
> >> generated by GCC.  This seems to give the best result.
> >>
> >> =20
> >>> 1) never recycle emergency pages, regardless of pool nid.
> >>> 2) always recycle if pool is NUMA_NO_NODE. =20
> >>
> >> Yes, this defines the semantics, that a page_pool configured with
> >> NUMA_NO_NODE means skip NUMA checks.  I think that sounds okay...
> >>
> >> =20
> >>> the above change should not add any overhead, a modest branch
> >>> predictor will handle this with no effort. =20
> >>
> >> It still annoys me that we keep adding instructions to this code
> >> hot-path (I counted 34 bytes and 11 instructions in my proposed
> >> function).
> >>
> >> I think that it might be possible to move these NUMA checks to
> >> alloc-side (instead of return/recycles side as today), and perhaps
> >> only on slow-path when dequeuing from ptr_ring (as recycles that
> >> call __page_pool_recycle_direct() will be pinned during NAPI).
> >> But lets focus on a smaller fix for the immediate issue...
> >> =20
> >=20
> > I know. It annoys me too, but we need recycling to work in
> > production : where rings/napi can migrate and numa nodes can be
> > NUMA_NO_NODE :-(.
> >=20
> >  =20

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

