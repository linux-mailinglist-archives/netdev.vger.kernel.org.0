Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABECF9DED
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 00:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKLXPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 18:15:11 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41671 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfKLXPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 18:15:10 -0500
Received: by mail-oi1-f194.google.com with SMTP id e9so13518oif.8
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 15:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ahg4ogj/xxSIi3Tz2dndpoesa0PkRLQ36VHrjNwVguE=;
        b=xlO/3o/FAhmPzmX5yHbU6ZNuHn4V9nHbloPGHpZqsb+DPkTsTeMinCTT3P2xrA0A3t
         XjX5crvs+XLSDSgcai6PZWx41nUjrksNl4jkRdGfTQpb6e1yLtFehh/VkrzYDg6mpqa6
         nIua0PamDKkJ2o4Dp1t2Oe3HiXMlIx7Jxg8UopWGV46jcBHLtzfhKxYanb2GfMvC3xgc
         V252jaKpAjhpDskcu/pPNVnV9ekVH+4FC/dXONxMnvQ71JXMw8m5ltg2SL6haNirS3nS
         2zfdpmAUDtoGxjGX0JdEV3chYwlXK5G60EaIDM8oX92yL7sroQqX5o/Sf8CBMjZV3ums
         ZwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ahg4ogj/xxSIi3Tz2dndpoesa0PkRLQ36VHrjNwVguE=;
        b=qhzO5GSj6E+76bOmgHn6qdLoEwAMeHBR24VoKp0DxyWdMt78TSudxdXgWi4Q4txL65
         pZpb+7fFn59VIkK/g6hQzXrp0Q3ZmGsO+Pno+LCLTk1pkE1h6u+CQyRS/77REKUqfTyl
         4gbgxIhcinUDQYO1vqCyu0NErqG0VcmZNIAKRg5nHHd/5lZUiEVFbtWgjAEWWNkhNsuz
         iop6QNhtwHR2sjPLsMkgGanL7kSaQQY/tMiqvj2qdZJDX+ISf7qY8GRH+mGkVqOzce2D
         LZ0iqhQDs+FRczO1eC5I+ntNxQOSgshP9JVEkI8PUYP5SGp++jAlNq3vQ3KEsICu1MSh
         Y2dg==
X-Gm-Message-State: APjAAAUJ5t5oASf6Qw/Xxja6WpgE/RX+f9zGuIe0ryPv3itb0nHrWsBR
        VzIs0I369U1ST1X7Qt7YI0vuRxDnoLSYCA/0UxB7ig==
X-Google-Smtp-Source: APXvYqw0y1/AL1ibfnKpdRZPCFvNtcNTDnagWkblsIboSxBlSGgp0qhR7HkhIvJGPGFUg8U4pz3vKkN+eKromPrOJOY=
X-Received: by 2002:aca:ad52:: with SMTP id w79mr178668oie.149.1573600509804;
 Tue, 12 Nov 2019 15:15:09 -0800 (PST)
MIME-Version: 1.0
References: <20191112000700.3455038-1-jhubbard@nvidia.com> <20191112000700.3455038-9-jhubbard@nvidia.com>
 <CAPcyv4hgKEqoxeQJH9R=YiZosvazj308Kk7jJA1NLxJkNenDcQ@mail.gmail.com>
 <471e513c-833f-2f8b-60db-5d9c56a8f766@nvidia.com> <CAPcyv4it5fxU71uXFHW_WAAXBw4suQvwWTjX0Wru8xKFoz_dbw@mail.gmail.com>
 <729a16cb-3947-c7cb-c57f-6c917d240665@nvidia.com>
In-Reply-To: <729a16cb-3947-c7cb-c57f-6c917d240665@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 12 Nov 2019 15:14:58 -0800
Message-ID: <CAPcyv4gUe__09cnAh3jeFogJH=sGm9U+8axRq_kCASkdbLfNbQ@mail.gmail.com>
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

On Tue, Nov 12, 2019 at 3:08 PM John Hubbard <jhubbard@nvidia.com> wrote:
>
> On 11/12/19 2:43 PM, Dan Williams wrote:
> ...
> > Ah, sorry. This was the first time I had looked at this series and
> > jumped in without reading the background.
> >
> > Your patch as is looks ok, I assume you've removed the FOLL_LONGTERM
> > warning in get_user_pages_remote in another patch?
> >
>
> Actually, I haven't gone quite that far. Actually this patch is the last
> change to that function. Therefore, at the end of this patchset,
> get_user_pages_remote() ends up with this check in it which
> is a less-restrictive version of the warning:
>
>         /*
>          * Current FOLL_LONGTERM behavior is incompatible with
>          * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
>          * vmas. However, this only comes up if locked is set, and there are
>          * callers that do request FOLL_LONGTERM, but do not set locked. So,
>          * allow what we can.
>          */
>         if (gup_flags & FOLL_LONGTERM) {
>                 if (WARN_ON_ONCE(locked))
>                         return -EINVAL;
>         }
>
> Is that OK, or did you want to go further (possibly in a follow-up
> patchset, as I'm hoping to get this one in soon)?

That looks ok. Something to maybe push down into the core in a future
cleanup, but not something that needs to be done now.

> ...
> >>> I think check_vma_flags() should do the ((FOLL_LONGTERM | FOLL_GET) &&
> >>> vma_is_fsdax()) check and that would also remove the need for
> >>> __gup_longterm_locked.
> >>>
> >>
> >> Good idea, but there is still the call to check_and_migrate_cma_pages(),
> >> inside __gup_longterm_locked().  So it's a little more involved and
> >> we can't trivially delete __gup_longterm_locked() yet, right?
> >
> > [ add Aneesh ]
> >
> > Yes, you're right. I had overlooked that had snuck in there. That to
> > me similarly needs to be pushed down into the core with its own FOLL
> > flag, or it needs to be an explicit fixup that each caller does after
> > get_user_pages. The fact that migration silently happens as a side
> > effect of gup is too magical for my taste.
> >
>
> Yes. It's an intrusive side effect that is surprising, and not in a
> "happy surprise" way. :) .   Fixing up the CMA pages by splitting that
> functionality into separate function calls sounds like an improvement
> worth exploring.

Right, future work.
