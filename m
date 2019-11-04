Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DFDEE8FD
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbfKDTxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:53:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57118 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728758AbfKDTxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572897187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5YqXY05LcZm45Xoi2n7UBvKIcNMM7euzmr8OM5rBxks=;
        b=LUW4vh9DupPlwYYAvMF55kZVVVFWE5LTVgcI6qTLMGAv0rM1uq6knqm6oneXGw1pmdE9yO
        2gxroMmOMOeP2KxyWk4bUFpYENWCTdD45CJ5A/zESEu9E4VCB0GZIOIPckGwcTXSZgBkwZ
        vGXCQuhogjiN32Ln2RlaMOAF6laugS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-ZQL91USHOcmTk___p7nkiA-1; Mon, 04 Nov 2019 14:53:03 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 760D1107ACC2;
        Mon,  4 Nov 2019 19:52:58 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E8A5B1FC;
        Mon,  4 Nov 2019 19:52:49 +0000 (UTC)
Date:   Mon, 4 Nov 2019 14:52:48 -0500
From:   Jerome Glisse <jglisse@redhat.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 05/18] mm/gup: introduce pin_user_pages*() and FOLL_PIN
Message-ID: <20191104195248.GA7731@redhat.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-6-jhubbard@nvidia.com>
 <20191104173325.GD5134@redhat.com>
 <be9de35c-57e9-75c3-2e86-eae50904bbdf@nvidia.com>
 <20191104191811.GI5134@redhat.com>
 <e9656d47-b4a1-da8a-e8cc-ebcfb8cc06d6@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <e9656d47-b4a1-da8a-e8cc-ebcfb8cc06d6@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: ZQL91USHOcmTk___p7nkiA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 11:30:32AM -0800, John Hubbard wrote:
> On 11/4/19 11:18 AM, Jerome Glisse wrote:
> > On Mon, Nov 04, 2019 at 11:04:38AM -0800, John Hubbard wrote:
> >> On 11/4/19 9:33 AM, Jerome Glisse wrote:
> >> ...
> >>>
> >>> Few nitpick belows, nonetheless:
> >>>
> >>> Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>
> >>> [...]
> >>>> +
> >>>> +CASE 3: ODP
> >>>> +-----------
> >>>> +(Mellanox/Infiniband On Demand Paging: the hardware supports
> >>>> +replayable page faulting). There are GUP references to pages servin=
g as DMA
> >>>> +buffers. For ODP, MMU notifiers are used to synchronize with page_m=
kclean()
> >>>> +and munmap(). Therefore, normal GUP calls are sufficient, so neithe=
r flag
> >>>> +needs to be set.
> >>>
> >>> I would not include ODP or anything like it here, they do not use
> >>> GUP anymore and i believe it is more confusing here. I would how-
> >>> ever include some text in this documentation explaining that hard-
> >>> ware that support page fault is superior as it does not incur any
> >>> of the issues described here.
> >>
> >> OK, agreed, here's a new write up that I'll put in v3:
> >>
> >>
> >> CASE 3: ODP
> >> -----------
> >=20
> > ODP is RDMA, maybe Hardware with page fault support instead
> >=20
> >> Advanced, but non-CPU (DMA) hardware that supports replayable page fau=
lts.
>=20
> OK, so:
>=20
>     "RDMA hardware with page faulting support."
>=20
> for the first sentence.

I would drop RDMA completely, RDMA is just one example, they are GPU, FPGA =
and
others that are in that category. See below

>=20
>=20
> >> Here, a well-written driver doesn't normally need to pin pages at all.=
 However,
> >> if the driver does choose to do so, it can register MMU notifiers for =
the range,
> >> and will be called back upon invalidation. Either way (avoiding page p=
inning, or
> >> using MMU notifiers to unpin upon request), there is proper synchroniz=
ation with=20
> >> both filesystem and mm (page_mkclean(), munmap(), etc).
> >>
> >> Therefore, neither flag needs to be set.
> >=20
> > In fact GUP should never be use with those.
>=20
>=20
> Yes. The next paragraph says that, but maybe not strong enough.
>=20
>=20
> >>
> >> It's worth mentioning here that pinning pages should not be the first =
design
> >> choice. If page fault capable hardware is available, then the software=
 should
> >> be written so that it does not pin pages. This allows mm and filesyste=
ms to
> >> operate more efficiently and reliably.
>=20
> Here's what we have after the above changes:
>=20
> CASE 3: ODP
> -----------
> RDMA hardware with page faulting support. Here, a well-written driver doe=
sn't

CASE3: Hardware with page fault support
---------------------------------------

Here, a well-written ....


> normally need to pin pages at all. However, if the driver does choose to =
do so,
> it can register MMU notifiers for the range, and will be called back upon
> invalidation. Either way (avoiding page pinning, or using MMU notifiers t=
o unpin
> upon request), there is proper synchronization with both filesystem and m=
m
> (page_mkclean(), munmap(), etc).
>=20
> Therefore, neither flag needs to be set.
>=20
> In this case, ideally, neither get_user_pages() nor pin_user_pages() shou=
ld be=20
> called. Instead, the software should be written so that it does not pin p=
ages.=20
> This allows mm and filesystems to operate more efficiently and reliably.
>=20
> >>> [...]
> >>>
> >>>> @@ -1014,7 +1018,16 @@ static __always_inline long __get_user_pages_=
locked(struct task_struct *tsk,
> >>>>  =09=09BUG_ON(*locked !=3D 1);
> >>>>  =09}
> >>>> =20
> >>>> -=09if (pages)
> >>>> +=09/*
> >>>> +=09 * FOLL_PIN and FOLL_GET are mutually exclusive. Traditional beh=
avior
> >>>> +=09 * is to set FOLL_GET if the caller wants pages[] filled in (but=
 has
> >>>> +=09 * carelessly failed to specify FOLL_GET), so keep doing that, b=
ut only
> >>>> +=09 * for FOLL_GET, not for the newer FOLL_PIN.
> >>>> +=09 *
> >>>> +=09 * FOLL_PIN always expects pages to be non-null, but no need to =
assert
> >>>> +=09 * that here, as any failures will be obvious enough.
> >>>> +=09 */
> >>>> +=09if (pages && !(flags & FOLL_PIN))
> >>>>  =09=09flags |=3D FOLL_GET;
> >>>
> >>> Did you look at user that have pages and not FOLL_GET set ?
> >>> I believe it would be better to first fix them to end up
> >>> with FOLL_GET set and then error out if pages is !=3D NULL but
> >>> nor FOLL_GET or FOLL_PIN is set.
> >>>
> >>
> >> I was perhaps overly cautious, and didn't go there. However, it's prob=
ably
> >> doable, given that there was already the following in __get_user_pages=
():
> >>
> >>     VM_BUG_ON(!!pages !=3D !!(gup_flags & FOLL_GET));
> >>
> >> ...which will have conditioned people and code to set FOLL_GET togethe=
r with
> >> pages. So I agree that the time is right.
> >>
> >> In order to make bisecting future failures simpler, I can insert a pat=
ch right=20
> >> before this one, that changes the FOLL_GET setting into an assert, lik=
e this:
> >>
> >> diff --git a/mm/gup.c b/mm/gup.c
> >> index 8f236a335ae9..be338961e80d 100644
> >> --- a/mm/gup.c
> >> +++ b/mm/gup.c
> >> @@ -1014,8 +1014,8 @@ static __always_inline long __get_user_pages_loc=
ked(struct task_struct *tsk,
> >>                 BUG_ON(*locked !=3D 1);
> >>         }
> >> =20
> >> -       if (pages)
> >> -               flags |=3D FOLL_GET;
> >> +       if (pages && WARN_ON_ONCE(!(gup_flags & FOLL_GET)))
> >> +               return -EINVAL;
> >> =20
> >>         pages_done =3D 0;
> >>         lock_dropped =3D false;
> >>
> >>
> >> ...and then add in FOLL_PIN, with this patch.
> >=20
> > looks good but double check that it should not happens, i will try
> > to check on my side too.
>=20
> Yes, I'll look.
>=20
> ...
> >>>> +=09 */
> >>>> +=09gup_flags |=3D FOLL_REMOTE | FOLL_PIN;
> >>>
> >>> Wouldn't it be better to not add pin_longterm_pages_remote() until
> >>> it can be properly implemented ?
> >>>
> >>
> >> Well, the problem is that I need each call site that requires FOLL_PIN
> >> to use a proper wrapper. It's the FOLL_PIN that is the focus here, bec=
ause
> >> there is a hard, bright rule, which is: if and only if a caller sets
> >> FOLL_PIN, then the dma-page tracking happens, and put_user_page() must
> >> be called.
> >>
> >> So this leaves me with only two reasonable choices:
> >>
> >> a) Convert the call site as above: pin_longterm_pages_remote(), which =
sets
> >> FOLL_PIN (the key point!), and leaves the FOLL_LONGTERM situation exac=
tly
> >> as it has been so far. When the FOLL_LONGTERM situation is fixed, the =
call
> >> site *might* not need any changes to adopt the working gup.c code.
> >>
> >> b) Convert the call site to pin_user_pages_remote(), which also sets
> >> FOLL_PIN, and also leaves the FOLL_LONGTERM situation exactly as befor=
e.
> >> There would also be a comment at the call site, to the effect of, "thi=
s
> >> is the wrong call to make: it really requires FOLL_LONGTERM behavior".
> >>
> >> When the FOLL_LONGTERM situation is fixed, the call site will need to =
be
> >> changed to pin_longterm_pages_remote().
> >>
> >> So you can probably see why I picked (a).
> >=20
> > But right now nobody has FOLL_LONGTERM and FOLL_REMOTE. So you should
> > never have the need for pin_longterm_pages_remote(). My fear is that
> > longterm has implication and it would be better to not drop this implic=
ation
> > by adding a wrapper that does not do what the name says.
> >=20
> > So do not introduce pin_longterm_pages_remote() until its first user
> > happens. This is option c)
> >=20
>=20
> Almost forgot, though: there is already another user: Infiniband:
>=20
> drivers/infiniband/core/umem_odp.c:646:         npages =3D pin_longterm_p=
ages_remote(owning_process, owning_mm,

odp do not need that, i thought the HMM convertion was already upstream
but seems not, in any case odp do not need the longterm case it only
so best is to revert that user to gup_fast or something until it get
converted to HMM.

Cheers,
J=E9r=F4me

