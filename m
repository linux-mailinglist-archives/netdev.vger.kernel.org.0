Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12095F9D50
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfKLWnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:43:33 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42170 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbfKLWn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 17:43:26 -0500
Received: by mail-oi1-f195.google.com with SMTP id i185so16430157oif.9
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 14:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SwaaHNLQ6Cwcgbew071VEYLmiCBwwXoXuuoAi+2uA2o=;
        b=Jq7Ptqpebw7UGAIdEQ/unEBsB7QbaXVZNTWXCanS5nvK3elyglZtGcUaQ89X7Thh8h
         IAM86ORfnzN6917rhUVFsUy3UD57DPR+XlrbhhZ/NXNnmHMPvg4XpzzSKBe4NqErKRUy
         bZxd+tm9M+MwB7qsXrtdhh4D3/L98cHAZWd0Ns8kuwxv1QWg3yEpu0lT5cnjJPtGKrYR
         anyG20BRg0b0DeF7mLr0STZrxT4BCOm+zZEBDW3gpHBI3V/JOgKkFou2F3URCWxql04L
         MQNOT/7KMRt8tV9Ump9WAqJ7q3xqWRAJd3iDm6wl8QcfVduDF9h8k23QxQ9DnzN60j3u
         /xqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SwaaHNLQ6Cwcgbew071VEYLmiCBwwXoXuuoAi+2uA2o=;
        b=JPEbxgGEs4Ol+IMEMXmfh0/X+6dQA6BkkNAE/RCzfCDK6d74ljoOa0YQXm0kuog6WB
         tcozVax8mqndRARagyDrlZzq5AySgXhFG3xI10kEyF8MYkDuNvGwq/Dvco5lcjjlXckH
         N+LRItXw05F5KbTsy4NQdJf6+nvJw4hGayrNQjDyOUhJgHcO3wkP120k3zvfiZjmWmto
         f3K5VSqbmAe83XXiSJ/xFgsn62dqgwj9USq29B7hIG8pwBjVOIrU0qzHbBAhmt8VexlM
         E+AKJVL1hsBYlel/en3RkiPHyOQ/rlVpxNy5YL57yXWOBNhn27/O617yim8OH5jxFCSo
         IxLQ==
X-Gm-Message-State: APjAAAV6x/LWF/U4gfhheUxXv2sTfD+Rma+zwhT2Is1WDMBCpe2pkbY2
        DYpETrKHMtHz3MRoHUGkTT4qAlGcxCWFXoF0urR/Kg==
X-Google-Smtp-Source: APXvYqxLBopeTTnZkVho8CVk6N+hGkn5uHiE62zpra+sAfITZV3BdLQKTEc55Ljq6ZrLX2Tr24PR9eCQkyGplH1DN48=
X-Received: by 2002:aca:ead7:: with SMTP id i206mr135827oih.0.1573598604957;
 Tue, 12 Nov 2019 14:43:24 -0800 (PST)
MIME-Version: 1.0
References: <20191112000700.3455038-1-jhubbard@nvidia.com> <20191112000700.3455038-9-jhubbard@nvidia.com>
 <CAPcyv4hgKEqoxeQJH9R=YiZosvazj308Kk7jJA1NLxJkNenDcQ@mail.gmail.com> <471e513c-833f-2f8b-60db-5d9c56a8f766@nvidia.com>
In-Reply-To: <471e513c-833f-2f8b-60db-5d9c56a8f766@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 12 Nov 2019 14:43:14 -0800
Message-ID: <CAPcyv4it5fxU71uXFHW_WAAXBw4suQvwWTjX0Wru8xKFoz_dbw@mail.gmail.com>
Subject: Re: [PATCH v3 08/23] vfio, mm: fix get_user_pages_remote() and FOLL_LONGTERM
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, KVM list <kvm@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Netdev <netdev@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 2:24 PM John Hubbard <jhubbard@nvidia.com> wrote:
>
> On 11/12/19 1:57 PM, Dan Williams wrote:
> ...
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index d864277ea16f..017689b7c32b 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -348,24 +348,20 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
> >>                 flags |= FOLL_WRITE;
> >>
> >>         down_read(&mm->mmap_sem);
> >> -       if (mm == current->mm) {
> >> -               ret = get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
> >> -                                    vmas);
> >> -       } else {
> >> -               ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
> >> -                                           vmas, NULL);
> >> -               /*
> >> -                * The lifetime of a vaddr_get_pfn() page pin is
> >> -                * userspace-controlled. In the fs-dax case this could
> >> -                * lead to indefinite stalls in filesystem operations.
> >> -                * Disallow attempts to pin fs-dax pages via this
> >> -                * interface.
> >> -                */
> >> -               if (ret > 0 && vma_is_fsdax(vmas[0])) {
> >> -                       ret = -EOPNOTSUPP;
> >> -                       put_page(page[0]);
> >> -               }
> >> +       ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
> >> +                                   page, vmas, NULL);
> >
> > Hmm, what's the point of passing FOLL_LONGTERM to
> > get_user_pages_remote() if get_user_pages_remote() is not going to
> > check the vma? I think we got to this code state because the
>
> FOLL_LONGTERM is short-lived in this location, because patch 23
> ("mm/gup: remove support for gup(FOLL_LONGTERM)") removes it, after
> callers are changed over to pin_longterm_pages*().
>
> So FOLL_LONGTERM is not doing much now, but it is basically a marker for
> "change gup(FOLL_LONGTERM) to pin_longterm_pages()", and patch 18
> actually makes that change.
>
> And then pin_longterm_pages*() is, in turn, a way to mark all the
> places that need file system and/or user space interactions (layout
> leases, etc), as per "Case 2: RDMA" in the new
> Documentation/vm/pin_user_pages.rst.

Ah, sorry. This was the first time I had looked at this series and
jumped in without reading the background.

Your patch as is looks ok, I assume you've removed the FOLL_LONGTERM
warning in get_user_pages_remote in another patch?

>
> > get_user_pages() vs get_user_pages_remote() split predated the
> > introduction of FOLL_LONGTERM.
>
> Yes. And I do want clean this up as I go, so we don't end up with
> stale concepts lingering in gup.c...
>
> >
> > I think check_vma_flags() should do the ((FOLL_LONGTERM | FOLL_GET) &&
> > vma_is_fsdax()) check and that would also remove the need for
> > __gup_longterm_locked.
> >
>
> Good idea, but there is still the call to check_and_migrate_cma_pages(),
> inside __gup_longterm_locked().  So it's a little more involved and
> we can't trivially delete __gup_longterm_locked() yet, right?

[ add Aneesh ]

Yes, you're right. I had overlooked that had snuck in there. That to
me similarly needs to be pushed down into the core with its own FOLL
flag, or it needs to be an explicit fixup that each caller does after
get_user_pages. The fact that migration silently happens as a side
effect of gup is too magical for my taste.
