Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE32EE986
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 21:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbfKDUcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 15:32:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729413AbfKDUcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 15:32:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572899529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0t18qmWA+5595eIOsjZ92rtvApF9YJpqwJyzz983FX4=;
        b=FVZW2lpbqvJiFchSK8aK7TQ9NwyyxRFD1Ign9yZL1JLBHWgbSbWYQ4imG4817IKAuO9etR
        /nl6nKfrBIiWIQbR79GpgQAvTmulbRXrRjjGz9NCRiFgJFzMCFLzoJXRzJ14AfAU1gsA7m
        Y73CzaOudHWDz0takN06dgWR9UrEn80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-Z6X9SXkoPpydpMlPq3lbmg-1; Mon, 04 Nov 2019 15:32:05 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39197477;
        Mon,  4 Nov 2019 20:32:01 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE494600C4;
        Mon,  4 Nov 2019 20:31:54 +0000 (UTC)
Date:   Mon, 4 Nov 2019 15:31:53 -0500
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
Message-ID: <20191104203153.GB7731@redhat.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-6-jhubbard@nvidia.com>
 <20191104173325.GD5134@redhat.com>
 <be9de35c-57e9-75c3-2e86-eae50904bbdf@nvidia.com>
 <20191104191811.GI5134@redhat.com>
 <e9656d47-b4a1-da8a-e8cc-ebcfb8cc06d6@nvidia.com>
 <20191104195248.GA7731@redhat.com>
 <25ec4bc0-caaa-2a01-2ae7-2d79663a40e1@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <25ec4bc0-caaa-2a01-2ae7-2d79663a40e1@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Z6X9SXkoPpydpMlPq3lbmg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 12:09:05PM -0800, John Hubbard wrote:
> Jason, a question for you at the bottom.
>=20
> On 11/4/19 11:52 AM, Jerome Glisse wrote:
> ...
> >> CASE 3: ODP
> >> -----------
> >> RDMA hardware with page faulting support. Here, a well-written driver =
doesn't
> >=20
> > CASE3: Hardware with page fault support
> > ---------------------------------------
> >=20
> > Here, a well-written ....
> >=20
>=20
> Ah, OK. So just drop the first sentence, yes.
>=20
> ...
> >>>>>> +=09 */
> >>>>>> +=09gup_flags |=3D FOLL_REMOTE | FOLL_PIN;
> >>>>>
> >>>>> Wouldn't it be better to not add pin_longterm_pages_remote() until
> >>>>> it can be properly implemented ?
> >>>>>
> >>>>
> >>>> Well, the problem is that I need each call site that requires FOLL_P=
IN
> >>>> to use a proper wrapper. It's the FOLL_PIN that is the focus here, b=
ecause
> >>>> there is a hard, bright rule, which is: if and only if a caller sets
> >>>> FOLL_PIN, then the dma-page tracking happens, and put_user_page() mu=
st
> >>>> be called.
> >>>>
> >>>> So this leaves me with only two reasonable choices:
> >>>>
> >>>> a) Convert the call site as above: pin_longterm_pages_remote(), whic=
h sets
> >>>> FOLL_PIN (the key point!), and leaves the FOLL_LONGTERM situation ex=
actly
> >>>> as it has been so far. When the FOLL_LONGTERM situation is fixed, th=
e call
> >>>> site *might* not need any changes to adopt the working gup.c code.
> >>>>
> >>>> b) Convert the call site to pin_user_pages_remote(), which also sets
> >>>> FOLL_PIN, and also leaves the FOLL_LONGTERM situation exactly as bef=
ore.
> >>>> There would also be a comment at the call site, to the effect of, "t=
his
> >>>> is the wrong call to make: it really requires FOLL_LONGTERM behavior=
".
> >>>>
> >>>> When the FOLL_LONGTERM situation is fixed, the call site will need t=
o be
> >>>> changed to pin_longterm_pages_remote().
> >>>>
> >>>> So you can probably see why I picked (a).
> >>>
> >>> But right now nobody has FOLL_LONGTERM and FOLL_REMOTE. So you should
> >>> never have the need for pin_longterm_pages_remote(). My fear is that
> >>> longterm has implication and it would be better to not drop this impl=
ication
> >>> by adding a wrapper that does not do what the name says.
> >>>
> >>> So do not introduce pin_longterm_pages_remote() until its first user
> >>> happens. This is option c)
> >>>
> >>
> >> Almost forgot, though: there is already another user: Infiniband:
> >>
> >> drivers/infiniband/core/umem_odp.c:646:         npages =3D pin_longter=
m_pages_remote(owning_process, owning_mm,
> >=20
> > odp do not need that, i thought the HMM convertion was already upstream
> > but seems not, in any case odp do not need the longterm case it only
> > so best is to revert that user to gup_fast or something until it get
> > converted to HMM.
> >=20
>=20
> Note for Jason: the (a) or (b) items are talking about the vfio case, whi=
ch is
> one of the two call sites that now use pin_longterm_pages_remote(), and t=
he
> other one is infiniband:
>=20
> drivers/infiniband/core/umem_odp.c:646:         npages =3D pin_longterm_p=
ages_remote(owning_process, owning_mm,
> drivers/vfio/vfio_iommu_type1.c:353:            ret =3D pin_longterm_page=
s_remote(NULL, mm, vaddr, 1,

vfio should be reverted until it can be properly implemented.
The issue is that when you fix the implementation you might
break vfio existing user and thus regress the kernel from user
point of view. So i rather have the change to vfio reverted,
i believe it was not well understood when it got upstream,
between in my 5.4 tree it is still gup_remote not longterm.


> Jerome, Jason: I really don't want to revert the put_page() to put_user_p=
age()=20
> conversions that are already throughout the IB driver--pointless churn, r=
ight?
> I'd rather either delete them in Jason's tree, or go with what I have her=
e
> while waiting for the deletion.
>=20
> Maybe we should just settle on (a) or (b), so that the IB driver ends up =
with
> the wrapper functions? In fact, if it's getting deleted, then I'd prefer =
leaving
> it at (a), since that's simple...
>=20
> Jason should weigh in on how he wants this to go, with respect to branchi=
ng
> and merging, since it sounds like that will conflict with the hmm branch=
=20
> (ha, I'm overdue in reviewing his mmu notifier series, that's what I get =
for
> being late).
>=20
> thanks,
>=20
> John Hubbard
> NVIDIA

