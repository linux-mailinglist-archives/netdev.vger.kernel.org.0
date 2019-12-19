Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED16125BA1
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLSGwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:52:47 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43680 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfLSGwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 01:52:46 -0500
Received: by mail-ot1-f66.google.com with SMTP id p8so5860721oth.10
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 22:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhLbadWhXkT8uLUvoIQHEOPXZo986OHkQZmNW5JELSg=;
        b=SiBKFSWbGZ/DlTuqAeJWCQJfko4CpkONzPTdXHk5ITfn6wjNPKckEYMfWXVa2KjE/9
         EnvKM5uCkbPNuMcmnnmOIL13PX8cysvho7VLWXbG/qQdn+K7/fzi8Ww4DNnz531U3iaT
         ek1DixOnTmNKqPks25kBzv6fRlRYJb99R8rIhogy+n5/aKHmuRVk2bVwwFWgffjz3noA
         ZerH0bwQzplUBLkBL/JrHxP9P4K0mBWvBTnlliMpof9I4Sttm4IJTOIKoWl16jE3wTmG
         IAzt5ZvdYfPhwgyAVURwEUcOXBJqNdhdpF54lEQXTrtdeMxzkaBCmBvpJo6eizOwHL7A
         6gAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhLbadWhXkT8uLUvoIQHEOPXZo986OHkQZmNW5JELSg=;
        b=TRrnqGUqVv+/WbjSgE135ZaFFhMdOcWDNg7R1SuZ1edYQ4WYFs6Yp5a8wokJkWNzXM
         0zavp/V1ycHYuIcVd/VKSwYT0ToP+f6R4IiGCvoUNTcMznZWB4Ag7qfQ8yMtgOXrnue/
         W5u8T1MZPohr/QJ79HxKZjE/JYsxMzIZ45LIRhO3eIxZbF1nuIaItClgLE4OclM7fqPl
         UuEIqQC8wmie2sMbYHa+am5U1obrTzsA30nS7A0ZB2fbQUeXzNgynQ0XD7gYjqoSFYws
         +OhGWsPCQTBdc+kG4mHAu2HUWjQxzV25XhqJ5pup52eq7qgzg7EVXj3se7ycOGwEVDRn
         SFpw==
X-Gm-Message-State: APjAAAXsQ4nTWQ6vELtr7V6/3x4CyT0h9+cvT9KnbpZSLbm3sZ6lnXXB
        0HONt9cOlstrOSYMHUF6TCgr1z3kJcko813veEOoew==
X-Google-Smtp-Source: APXvYqx2SQBCxtdPGsjOU3QNzNDjKuhpt1dAk9YJbVoUKqLIltD16iivCU1omckA5/EjvPPrP0sP5CVaNkhukyqv6+8=
X-Received: by 2002:a9d:6f11:: with SMTP id n17mr7085591otq.126.1576738365531;
 Wed, 18 Dec 2019 22:52:45 -0800 (PST)
MIME-Version: 1.0
References: <20191216222537.491123-1-jhubbard@nvidia.com> <20191216222537.491123-5-jhubbard@nvidia.com>
 <CAPcyv4hQBMxYMurxG=Vwh0=FKWoT3z-Kf=dqES1-icRV5bLwKg@mail.gmail.com> <d0a99e75-0175-0f31-f176-8c37c18a4108@nvidia.com>
In-Reply-To: <d0a99e75-0175-0f31-f176-8c37c18a4108@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 18 Dec 2019 22:52:34 -0800
Message-ID: <CAPcyv4j+Zgom17UZ-6Njkij1R0UQ=vUQdnaEZj9qDezEUJSZGg@mail.gmail.com>
Subject: Re: [PATCH v11 04/25] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
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
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 9:51 PM John Hubbard <jhubbard@nvidia.com> wrote:
>
> On 12/18/19 9:27 PM, Dan Williams wrote:
> ...
> >> @@ -461,5 +449,5 @@ void __put_devmap_managed_page(struct page *page)
> >>          page->mapping = NULL;
> >>          page->pgmap->ops->page_free(page);
> >>   }
> >> -EXPORT_SYMBOL(__put_devmap_managed_page);
> >> +EXPORT_SYMBOL(free_devmap_managed_page);
> >
> > This patch does not have a module consumer for
> > free_devmap_managed_page(), so the export should move to the patch
> > that needs the new export.
>
> Hi Dan,
>
> OK, I know that's a policy--although it seems quite pointless here given
> that this is definitely going to need an EXPORT.
>
> At the moment, the series doesn't use it in any module at all, so I'll just
> delete the EXPORT for now.
>
> >
> > Also the only reason that put_devmap_managed_page() is EXPORT_SYMBOL
> > instead of EXPORT_SYMBOL_GPL is that there was no practical way to
> > hide the devmap details from evey module in the kernel that did
> > put_page(). I would expect free_devmap_managed_page() to
> > EXPORT_SYMBOL_GPL if it is not inlined into an existing exported
> > static inline api.
> >
>
> Sure, I'll change it to EXPORT_SYMBOL_GPL when the time comes. We do have
> to be careful that we don't shut out normal put_page() types of callers,
> but...glancing through the current callers, that doesn't look to be a problem.
> Good. So it should be OK to do EXPORT_SYMBOL_GPL here.
>
> Are you *sure* you don't want to just pre-emptively EXPORT now, and save
> looking at it again?

I'm positive. There is enough history for "trust me the consumer is
coming" turning out not to be true to justify the hassle in my mind. I
do trust you, but things happen.
