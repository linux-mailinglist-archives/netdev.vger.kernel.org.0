Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE39CF9FB6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 01:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfKMA7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 19:59:10 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43107 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfKMA7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 19:59:10 -0500
Received: by mail-ot1-f65.google.com with SMTP id l14so118268oti.10
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 16:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bbhHvXUlpKSBxAaen2slRAaR7FABAWW5b4ZHt5uDQAs=;
        b=aNNgsrA5EIFA9nVSCXy/uyenu1ifAR2ZxMR/sDW6HqK6vSTYpxIpmBrjP/vDjDaVnk
         l4xh/AHHGyooUHFp1c42LTwLTpwdgtUaJfWvN3Y7CFSVzmwzvxLUaHQBl+Ibev8TBoid
         2FUFgDLM8vD2vOwzS+IEshtyE4Y+b3ieXpqqo3Mxdly/m4ak6FnwfnCLEy5DGwsI7qq9
         7rFre8WIcpfUZvKl+y7wQa6yOvynR61ZdKROoMobKwRLP3lkc2bkhgPK6DIYIEcGXZ4p
         WUPwy1pR33Kp+/7N+4r5VmPuWnlSLsuN14iR6BROP5kh/8NTzRoeUzJllo7I56/tNtvu
         ttpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bbhHvXUlpKSBxAaen2slRAaR7FABAWW5b4ZHt5uDQAs=;
        b=sLSIPWyaY+tvnJ6IBpck+UGoIwMPbAsK6LFB2rvFyRRs/nlmrutJoswT6+fTt7Hm4U
         Y7fBZBCIMsiithiKCoozx1uyxqqDy00nuPGCTto+5skloUJWG63no5LD56udOWKtUjiO
         rYyyu0xYsaL2PM8LFcwk2ZQgN87vlXoCyX2i9VBU6TGLcO6mleTrmnulY4m14R/IrTjY
         GqMcqBv5NKPu3ItpaFgsFzyPVCBYafuY5XW5PXDAROCKYm85FbqY/qjskoLrcHOXcZJC
         UN2BikPnJf7hU9NFkRia+5TKgZjAtdEq+z9TIQxkw6RX7w2nE4cAsE1OPn8q+iEgAF5I
         wPJg==
X-Gm-Message-State: APjAAAVp0bWLP6YgJURkN29SFQ4iqGugtAmVa80EIyzj9uqq7qB/aaLf
        5iR3/aCCmlcevHaakAAWrApfNGTfF3mDcNetoTRfBw==
X-Google-Smtp-Source: APXvYqwE5wMeaGSIvNyY2BTy28AxuQMGsjlQOMQJ/g9Nuz73c9JXx/mbsafhYfzhqVldWgO1VAvXOO9/vT+g3CHkLek=
X-Received: by 2002:a05:6830:1b70:: with SMTP id d16mr300372ote.71.1573606748988;
 Tue, 12 Nov 2019 16:59:08 -0800 (PST)
MIME-Version: 1.0
References: <20191112000700.3455038-1-jhubbard@nvidia.com> <20191112000700.3455038-9-jhubbard@nvidia.com>
 <20191112204338.GE5584@ziepe.ca> <0db36e86-b779-01af-77e7-469af2a2e19c@nvidia.com>
 <CAPcyv4hAEgw6ySNS+EFRS4yNRVGz9A3Fu1vOk=XtpjYC64kQJw@mail.gmail.com> <20191112234250.GA19615@ziepe.ca>
In-Reply-To: <20191112234250.GA19615@ziepe.ca>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 12 Nov 2019 16:58:57 -0800
Message-ID: <CAPcyv4hwFKmsQpp04rS6diCmZwGtbnriCjfY2ofWV485qT9kzg@mail.gmail.com>
Subject: Re: [PATCH v3 08/23] vfio, mm: fix get_user_pages_remote() and FOLL_LONGTERM
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
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
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 3:43 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Nov 12, 2019 at 02:45:51PM -0800, Dan Williams wrote:
> > On Tue, Nov 12, 2019 at 2:43 PM John Hubbard <jhubbard@nvidia.com> wrote:
> > >
> > > On 11/12/19 12:43 PM, Jason Gunthorpe wrote:
> > > ...
> > > >> -            }
> > > >> +    ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
> > > >> +                                page, vmas, NULL);
> > > >> +    /*
> > > >> +     * The lifetime of a vaddr_get_pfn() page pin is
> > > >> +     * userspace-controlled. In the fs-dax case this could
> > > >> +     * lead to indefinite stalls in filesystem operations.
> > > >> +     * Disallow attempts to pin fs-dax pages via this
> > > >> +     * interface.
> > > >> +     */
> > > >> +    if (ret > 0 && vma_is_fsdax(vmas[0])) {
> > > >> +            ret = -EOPNOTSUPP;
> > > >> +            put_page(page[0]);
> > > >>      }
> > > >
> > > > AFAIK this chunk is redundant now as it is some hack to emulate
> > > > FOLL_LONGTERM? So vmas can be deleted too.
> > >
> > > Let me first make sure I understand what Dan has in mind for the vma
> > > checking, in the other thread...
> >
> > It's not redundant relative to upstream which does not do anything the
> > FOLL_LONGTERM in the gup-slow path... but I have not looked at patches
> > 1-7 to see if something there made it redundant.
>
> Oh, the hunk John had below for get_user_pages_remote() also needs to
> call __gup_longterm_locked() when FOLL_LONGTERM is specified, then
> that calls check_dax_vmas() which duplicates the vma_is_fsdax() check
> above.

Oh true, good eye. It is redundant if it does additionally call
__gup_longterm_locked(), and it needs to do that otherwises it undoes
the CMA migration magic that Aneesh added.

>
> Certainly no caller of FOLL_LONGTERM should have to do dax specific
> VMA checking.

Agree, that was my comment about cleaning up the vma_is_fsdax() check
to be internal to the gup core.
