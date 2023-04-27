Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F92E6F0E58
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 00:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344240AbjD0Wbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 18:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjD0Wbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 18:31:34 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B6335BD;
        Thu, 27 Apr 2023 15:31:32 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f19ab99540so67153545e9.2;
        Thu, 27 Apr 2023 15:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682634690; x=1685226690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tz2Oe11qyxiYiSKtmA55j9wYjhw20hI2uSu41zqX+7w=;
        b=H7l3XrCoP1F1mVcVwHaFBZLKOTBxg58ut5KWhPQfU+rskv21YXCP71iy0xd/C2X+2i
         GSLRMqozWYyC8v6c+koK+iE4GwfIkKYePBM6H19osCBU8TqCPGAAVvBgppJGlhNjMvEQ
         a0Z9VGLNoqz05Bb09d1BFuki6UqNPWlQMC6PIA4kwOzT7VKseaogAxzNHcvi7325nIYo
         PElQp42+0dmvXFe4PatAoFcfFWYVPxKjfFdgIiHuJYC3WytwVfSqY8Tt4YfXhLOMZGU6
         uTpHIc4y8u1cqx7Uc9i/lIu/BMsYry6GEkAo3+3W/E75w9P5+Jtp+KxDdzelrciYb5cs
         h+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682634690; x=1685226690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tz2Oe11qyxiYiSKtmA55j9wYjhw20hI2uSu41zqX+7w=;
        b=G/PbgHoniwQVsiiri1DYuDVnJ0TrVaODYQ6JnvyqcDFshfbEsl0XJLBUfA9dmcOoOy
         UT8/ek1btTJt+SrdFjxlplHmoYA2CVoPGzO//et+ILBJqvU2tzLcdhzMX7jx1VQr6L6l
         2mrX3MkcJGQUase7wj3/nX52YE+XDIUesQDsTdLJKtQzZ1pPjSWD3StVxKBXePHz8+Ni
         aRHmHL17OG1yQmVbA8IL6e8gevCtXLrRRMqaAMitoBbhShOtGJRcGvKdGnU0GGRLN2G6
         iSOdEV14869iOKQ3JAnuEC2xLuM0Ug0ddmHLr6XmEmMSy1EB74BqdvkfPXBvatR5dEU0
         AZ/w==
X-Gm-Message-State: AC+VfDyFoKUPgnX3opo+O5Z/3bXRTR3hnJbuP56iF02Pg6xRN35ckqpK
        g6rX0TZeDkud5S6XtOM4CuY=
X-Google-Smtp-Source: ACHHUZ6l/jbczQYmNlznJ9f1JTg0eUFvInHsnpdLhbBGzb0Ztabbf48grSYT65gbfC3vSau2+Qd0/g==
X-Received: by 2002:a7b:c008:0:b0:3f1:7a18:942e with SMTP id c8-20020a7bc008000000b003f17a18942emr2349590wmb.6.1682634690422;
        Thu, 27 Apr 2023 15:31:30 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id h16-20020a05600c315000b003f173a2b2f6sm26145371wmo.12.2023.04.27.15.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 15:31:29 -0700 (PDT)
Date:   Thu, 27 Apr 2023 23:31:28 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v4] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <09e4a2b5-fb4f-447e-a8b1-ffbba75c5e37@lucifer.local>
References: <3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com>
 <7a3ff186-09c4-1059-9cdf-9e793f985251@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a3ff186-09c4-1059-9cdf-9e793f985251@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 05:52:09PM -0700, John Hubbard wrote:
> On 4/25/23 16:15, Lorenzo Stoakes wrote:
> > GUP does not correctly implement write-notify semantics, nor does it
> > guarantee that the underlying pages are correctly dirtied, which could lead
> > to a kernel oops or data corruption when writing to file-backed mappings.
> >
> > This is only relevant when the mappings are file-backed and the underlying
> > file system requires folio dirty tracking. File systems which do not, such
> > as shmem or hugetlb, are not at risk and therefore can be written to
> > without issue.
> >
> > Unfortunately this limitation of GUP has been present for some time and
> > requires future rework of the GUP API in order to provide correct write
> > access to such mappings.
> >
> > In the meantime, we add a check for the most broken GUP case -
> > FOLL_LONGTERM - which really under no circumstances can safely access
> > dirty-tracked file mappings.
> >
>
> Hi Lorenzo,
>
> As I mentioned in a sub-thread [1], it would be a nice touch to include
> your more detailed write-up, and a link to Jan Kara's original report,
> here.

Ack will do.

>
>
> > As part of this change we separate out vma_needs_dirty_tracking() as a
> > helper function to determine this, which is distinct from
> > vma_wants_writenotify() which is specific to determining which PTE flags to
> > set.
>
> This, I think should go in a separate cleanup patch, because it is
> (nearly) the same behavior. More notes below on this.
>
> More notes below:
>
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > ---
> > v4:
> > - Split out vma_needs_dirty_tracking() from vma_wants_writenotify() to reduce
> >    duplication and update to use this in the GUP check. Note that both separately
> >    check vm_ops_needs_writenotify() as the latter needs to test this before the
> >    vm_pgprot_modify() test, resulting in vma_wants_writenotify() checking this
> >    twice, however it is such a small check this should not be egregious.
> >
> > v3:
> > - Rebased on latest mm-unstable as of 24th April 2023.
> > - Explicitly check whether file system requires folio dirtying. Note that
> >    vma_wants_writenotify() could not be used directly as it is very much focused
> >    on determining if the PTE r/w should be set (e.g. assuming private mapping
> >    does not require it as already set, soft dirty considerations).
> > - Tested code against shmem and hugetlb mappings - confirmed that these are not
> >    disallowed by the check.
> > - Eliminate FOLL_ALLOW_BROKEN_FILE_MAPPING flag and instead perform check only
> >    for FOLL_LONGTERM pins.
> > - As a result, limit check to internal GUP code.
> >   https://lore.kernel.org/all/23c19e27ef0745f6d3125976e047ee0da62569d4.1682406295.git.lstoakes@gmail.com/
> >
> > v2:
> > - Add accidentally excluded ptrace_access_vm() use of
> >    FOLL_ALLOW_BROKEN_FILE_MAPPING.
> > - Tweak commit message.
> > https://lore.kernel.org/all/c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com/
> >
> > v1:
> > https://lore.kernel.org/all/f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com/
> >
> >   include/linux/mm.h |  1 +
> >   mm/gup.c           | 26 +++++++++++++++++++++++++-
> >   mm/mmap.c          | 37 ++++++++++++++++++++++++++++---------
> >   3 files changed, 54 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 37554b08bb28..f7da02fc89c6 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
> >   #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
> >   					    MM_CP_UFFD_WP_RESOLVE)
> > +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
> >   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
> >   static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
> >   {
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 1f72a717232b..53652453037c 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -959,16 +959,37 @@ static int faultin_page(struct vm_area_struct *vma,
> >   	return 0;
> >   }
> > +/*
> > + * Writing to file-backed mappings which require folio dirty tracking using GUP
> > + * is a fundamentally broken operation as kernel write access to GUP mappings
> > + * may not adhere to the semantics expected by a file system.
> > + */
> > +static inline bool can_write_file_mapping(struct vm_area_struct *vma,
> > +					  unsigned long gup_flags)
>
> Perhaps name this:
>         writeable_file_mapping_allowed()
>
> ? "can" is more about "is this possible", whereas the goal here is
> to express, "should this be allowed".

Yes I struggled a bit with how best to name this, I think your suggestion
is better

>
> Also a silly tiny nit: let's omit the "inline" keyword, down here in this
> .c file, and let the compiler work that out instead. "static" should suffice.

Ack, I saw some inconsistency in gup.c about this so wondered which way to
go, obviously it's not really all that useful here (compiler will inline if
it wants)

>
> > +{
> > +	/* If we aren't pinning then no problematic write can occur. */
> > +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> > +		return true;
> > +
> > +	/* We limit this check to the most egregious case - a long term pin. */
> > +	if (!(gup_flags & FOLL_LONGTERM))
> > +		return true;
> > +
> > +	/* If the VMA requires dirty tracking then GUP will be problematic. */
> > +	return vma_needs_dirty_tracking(vma);
> > +}
> > +
> >   static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> >   {
> >   	vm_flags_t vm_flags = vma->vm_flags;
> >   	int write = (gup_flags & FOLL_WRITE);
> >   	int foreign = (gup_flags & FOLL_REMOTE);
> > +	bool vma_anon = vma_is_anonymous(vma);
>
> This name:
>
>        bool file_backed = !vma_is_anonymous(vma);
>
> would lead to a slightly better reading experience below.

Well you see, I'm not so sure about that, because vma_is_anonymous() checks
vm_ops == NULL not vm_file == NULL which can be the case for a special
mapping like VDSO that is not in fact file-backed :) the horror, the
horror.

>
> Sorry for the small naming and documentation comments here,
> it's just what I do. :)
>
>
> >   	if (vm_flags & (VM_IO | VM_PFNMAP))
> >   		return -EFAULT;
> > -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> > +	if ((gup_flags & FOLL_ANON) && !vma_anon)
> >   		return -EFAULT;
> >   	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> > @@ -978,6 +999,9 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> >   		return -EFAULT;
> >   	if (write) {
> > +		if (!vma_anon && !can_write_file_mapping(vma, gup_flags))
> > +			return -EFAULT;
> > +
> >   		if (!(vm_flags & VM_WRITE)) {
> >   			if (!(gup_flags & FOLL_FORCE))
> >   				return -EFAULT;
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 536bbb8fa0ae..aac638dd22cf 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1475,6 +1475,32 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
> >   }
> >   #endif /* __ARCH_WANT_SYS_OLD_MMAP */
> > +/* Do VMA operations imply write notify is required? */
> > +static inline bool vm_ops_needs_writenotify(
>
> This "inline" should also be omitted, imho.
>

Same comment as before as to why I did that, but ack

> > +	const struct vm_operations_struct *vm_ops)
> > +{
> > +	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
> > +}
> > +
> > +/*
> > + * Does this VMA require the underlying folios to have their dirty state
> > + * tracked?
> > + */
> > +bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
> > +{
> > +	/* Does the filesystem need to be notified? */
> > +	if (vm_ops_needs_writenotify(vma->vm_ops))
> > +		return true;
> > +
> > +	/* Specialty mapping? */
> > +	if (vma->vm_flags & VM_PFNMAP)
> > +		return false;
> > +
> > +	/* Can the mapping track the dirty pages? */
> > +	return vma->vm_file && vma->vm_file->f_mapping &&
> > +		mapping_can_writeback(vma->vm_file->f_mapping);
> > +}
> > +
> >   /*
> >    * Some shared mappings will want the pages marked read-only
> >    * to track write events. If so, we'll downgrade vm_page_prot
> > @@ -1484,14 +1510,13 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
> >   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
> >   {
> >   	vm_flags_t vm_flags = vma->vm_flags;
> > -	const struct vm_operations_struct *vm_ops = vma->vm_ops;
> >   	/* If it was private or non-writable, the write bit is already clear */
> >   	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
> >   		return 0;
> >   	/* The backer wishes to know when pages are first written to? */
> > -	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
> > +	if (vm_ops_needs_writenotify(vma->vm_ops))
>
> OK, so here we are calling vm_ops_needs_writenotify(), that's the
> first call. And then...
>
> >   		return 1;
> >   	/* The open routine did something to the protections that pgprot_modify
> > @@ -1511,13 +1536,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
> >   	if (userfaultfd_wp(vma))
> >   		return 1;
> > -	/* Specialty mapping? */
> > -	if (vm_flags & VM_PFNMAP)
> > -		return 0;
> > -
> > -	/* Can the mapping track the dirty pages? */
> > -	return vma->vm_file && vma->vm_file->f_mapping &&
> > -		mapping_can_writeback(vma->vm_file->f_mapping);
> > +	return vma_needs_dirty_tracking(vma);
>
> ...and now we call it again. I think once should be enough, though.

Right, this was intentional (I think I mentioned it in the revision
notes?), because there is a conundrum here - the invocation from
vma_wants_writenotify() needs to check this _first_ before performing the
_other_ checks in vma_needs_dirty_tracking(), but external calls need all
the checks. It'd be ugly to pass a boolean to see if we should check this
or not, and it's hardly an egregious duplication for the _computer_
(something likely in a cache line != NULL) which aids readability and
reduces duplication for the _reader_ of the code for a path that is
inherently slow (likely going to fault in pages etc.)

I think it'd be confusing to have yet another split into
vma_can_track_dirty() or whatever because then suddenly for the check to be
meaningful you have to _always_ check 2 things.

Other options like passing an output parameter or returning something other
than boolean are equally distasteful.

>
> Also, with the exception of that double call to
> vm_ops_needs_writenotify(), these changes to mmap.c are code cleanup
> that has the same behavior as before. As such, it's better to separate
> them out from this patch whose goal is very much to change behavior.

It's not really cleanup, it's separating out some of the logic explicitly
to be used in this new context, without which the separation would not be
useful, so I feel it's a bit over the top to turn a small single patch into
two simply to avoid this.

>
>
> [1] https://lore.kernel.org/all/1b9e3406-c08e-b97c-d46f-22f36535d9e5@nvidia.com/
>
> thanks,
> --
> John Hubbard
> NVIDIA
>

Thanks for the review, I will respin with the suggestions (other than ones
I don't quite agree with as explained above) and a clearer description in
line with Mika's suggestions.

Hopefully we can move closer to this actually getting some
reviewed/acked-by tags soon :)
