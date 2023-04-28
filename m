Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE196F1711
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 13:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345910AbjD1L7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 07:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjD1L7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 07:59:36 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F2E1FCB;
        Fri, 28 Apr 2023 04:59:33 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f1763ee8f8so67503365e9.1;
        Fri, 28 Apr 2023 04:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682683172; x=1685275172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2xg6dCreX0Yc2ceYgkbqCv85MTaDymUpMLfbwPs59o8=;
        b=Bk8mibJoc2tK2IXpxP3Dq7vl1EFi1LE+D3n/CH0OypzYJFz2A5hbvSVjkPcGT32NpK
         OAssr33qv2GELUv2yb2mPG+mtRemyIxHIWgH6Xqxj3o/tj8DBrs+8IBk6L6arvDub5mm
         hXSYMWrSUNsxyfU1+z8KIfEmo6pcUH3FkMMLTSo4sCOyLOwDAmDgoHXfbbd+CAdEaLR7
         0xNvjVPcd/D3X2TjaO9CUHzu4L3qVaA059VcAy1GTrz3a+1jNSGZ2MQegvi2RXdrrgHO
         um3YI4WuRp7gaMGOPVIZakr8Zyq92+gdoMZ85W+KmOiZ+KBbPoKlOGz2NYyL/EuzppRc
         sOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682683172; x=1685275172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2xg6dCreX0Yc2ceYgkbqCv85MTaDymUpMLfbwPs59o8=;
        b=ew9SipzvAEu2aDbp7jwFJ3L2LCGpZSD01Sk0vEtKlFqJlpEAykzDsMdv75IceC4jes
         xmR9gb+ISi8C4xLe7FR+1Jo6PjvARebxxlZ5PVTXpsK8t8pIPm/3+selMZXsN1p026zj
         XUHLYH+EHsW6gU0wDhZ5FLMweGn82/nDKm7r+8O/EdeP2/Co4/fltpKwYrrONLW+4aPH
         wgdgcanfR7Eu2VmyGCDBrLCd1xbQk73VxYvx9CMO8DZ1tz/j1Lpuc3gLFVv/8lDvf8BU
         mYm/KDxgj8FLieVS1dOXZdejh1YujwBWSzy1y/lt31+bWPTzfeixMznf2hNwsu+14JRX
         tm6A==
X-Gm-Message-State: AC+VfDwT73py5F4a514RJhMV7Dvj9FtzUCbKykO/ApYEYCFDDwrm4pLu
        RY7lYO0P+dB34w3szj1ZPSU=
X-Google-Smtp-Source: ACHHUZ4AUdSV9XqlBgx2nC/fn40x8q2t0LtNOLA1WZPv2u2AjvcRcIxnJmUjwhtuTTY2WJg1wepEpw==
X-Received: by 2002:a05:600c:215:b0:3f0:9c6c:54a0 with SMTP id 21-20020a05600c021500b003f09c6c54a0mr3908056wmi.2.1682683171524;
        Fri, 28 Apr 2023 04:59:31 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id hg7-20020a05600c538700b003f1940fe278sm20718917wmb.7.2023.04.28.04.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 04:59:30 -0700 (PDT)
Date:   Fri, 28 Apr 2023 12:59:30 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <6b4481f1-8e0f-4b52-a6a1-63b9c4e0549f@lucifer.local>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 12:42:32AM +0100, Lorenzo Stoakes wrote:
> Writing to file-backed mappings which require folio dirty tracking using
> GUP is a fundamentally broken operation, as kernel write access to GUP
> mappings do not adhere to the semantics expected by a file system.
>
> A GUP caller uses the direct mapping to access the folio, which does not
> cause write notify to trigger, nor does it enforce that the caller marks
> the folio dirty.
>
> The problem arises when, after an initial write to the folio, writeback
> results in the folio being cleaned and then the caller, via the GUP
> interface, writes to the folio again.
>
> As a result of the use of this secondary, direct, mapping to the folio no
> write notify will occur, and if the caller does mark the folio dirty, this
> will be done so unexpectedly.
>
> For example, consider the following scenario:-
>
> 1. A folio is written to via GUP which write-faults the memory, notifying
>    the file system and dirtying the folio.
> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>    the PTE being marked read-only.
> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>    direct mapping.
> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>    (though it does not have to).
>
> This results in both data being written to a folio without writenotify, and
> the folio being dirtied unexpectedly (if the caller decides to do so).
>
> This issue was first reported by Jan Kara [1] in 2018, where the problem
> resulted in file system crashes.
>
> This is only relevant when the mappings are file-backed and the underlying
> file system requires folio dirty tracking. File systems which do not, such
> as shmem or hugetlb, are not at risk and therefore can be written to
> without issue.
>
> Unfortunately this limitation of GUP has been present for some time and
> requires future rework of the GUP API in order to provide correct write
> access to such mappings.
>
> However, for the time being we introduce this check to prevent the most
> egregious case of this occurring, use of the FOLL_LONGTERM pin.
>
> These mappings are considerably more likely to be written to after
> folios are cleaned and thus simply must not be permitted to do so.
>
> As part of this change we separate out vma_needs_dirty_tracking() as a
> helper function to determine this which is distinct from
> vma_wants_writenotify() which is specific to determining which PTE flags to
> set.
>
> [1]:https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/
>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  include/linux/mm.h |  1 +
>  mm/gup.c           | 41 ++++++++++++++++++++++++++++++++++++++++-
>  mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
>  3 files changed, 68 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 37554b08bb28..f7da02fc89c6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
>  #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>  					    MM_CP_UFFD_WP_RESOLVE)
>
> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
>  int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
>  static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>  {
> diff --git a/mm/gup.c b/mm/gup.c
> index 1f72a717232b..d36a5db9feb1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -959,16 +959,51 @@ static int faultin_page(struct vm_area_struct *vma,
>  	return 0;
>  }
>
> +/*
> + * Writing to file-backed mappings which require folio dirty tracking using GUP
> + * is a fundamentally broken operation, as kernel write access to GUP mappings
> + * do not adhere to the semantics expected by a file system.
> + *
> + * Consider the following scenario:-
> + *
> + * 1. A folio is written to via GUP which write-faults the memory, notifying
> + *    the file system and dirtying the folio.
> + * 2. Later, writeback is triggered, resulting in the folio being cleaned and
> + *    the PTE being marked read-only.
> + * 3. The GUP caller writes to the folio, as it is mapped read/write via the
> + *    direct mapping.
> + * 4. The GUP caller, now done with the page, unpins it and sets it dirty
> + *    (though it does not have to).
> + *
> + * This results in both data being written to a folio without writenotify, and
> + * the folio being dirtied unexpectedly (if the caller decides to do so).
> + */
> +static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
> +					   unsigned long gup_flags)
> +{
> +	/* If we aren't pinning then no problematic write can occur. */
> +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> +		return true;
> +
> +	/* We limit this check to the most egregious case - a long term pin. */
> +	if (!(gup_flags & FOLL_LONGTERM))
> +		return true;
> +
> +	/* If the VMA requires dirty tracking then GUP will be problematic. */
> +	return vma_needs_dirty_tracking(vma);
> +}
> +
>  static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>  {
>  	vm_flags_t vm_flags = vma->vm_flags;
>  	int write = (gup_flags & FOLL_WRITE);
>  	int foreign = (gup_flags & FOLL_REMOTE);
> +	bool vma_anon = vma_is_anonymous(vma);
>
>  	if (vm_flags & (VM_IO | VM_PFNMAP))
>  		return -EFAULT;
>
> -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> +	if ((gup_flags & FOLL_ANON) && !vma_anon)
>  		return -EFAULT;
>
>  	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> @@ -978,6 +1013,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>  		return -EFAULT;
>
>  	if (write) {
> +		if (!vma_anon &&
> +		    !writeable_file_mapping_allowed(vma, gup_flags))
> +			return -EFAULT;
> +
>  		if (!(vm_flags & VM_WRITE)) {
>  			if (!(gup_flags & FOLL_FORCE))
>  				return -EFAULT;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 536bbb8fa0ae..7b6344d1832a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1475,6 +1475,31 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>  }
>  #endif /* __ARCH_WANT_SYS_OLD_MMAP */
>
> +/* Do VMA operations imply write notify is required? */
> +static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
> +{
> +	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
> +}
> +
> +/*
> + * Does this VMA require the underlying folios to have their dirty state
> + * tracked?
> + */
> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
> +{
> +	/* Does the filesystem need to be notified? */
> +	if (vm_ops_needs_writenotify(vma->vm_ops))
> +		return true;
> +
> +	/* Specialty mapping? */
> +	if (vma->vm_flags & VM_PFNMAP)
> +		return false;
> +
> +	/* Can the mapping track the dirty pages? */
> +	return vma->vm_file && vma->vm_file->f_mapping &&
> +		mapping_can_writeback(vma->vm_file->f_mapping);
> +}
> +
>  /*
>   * Some shared mappings will want the pages marked read-only
>   * to track write events. If so, we'll downgrade vm_page_prot
> @@ -1484,14 +1509,13 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>  int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>  {
>  	vm_flags_t vm_flags = vma->vm_flags;
> -	const struct vm_operations_struct *vm_ops = vma->vm_ops;
>
>  	/* If it was private or non-writable, the write bit is already clear */
>  	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
>  		return 0;
>
>  	/* The backer wishes to know when pages are first written to? */
> -	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
> +	if (vm_ops_needs_writenotify(vma->vm_ops))
>  		return 1;
>
>  	/* The open routine did something to the protections that pgprot_modify
> @@ -1511,13 +1535,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>  	if (userfaultfd_wp(vma))
>  		return 1;
>
> -	/* Specialty mapping? */
> -	if (vm_flags & VM_PFNMAP)
> -		return 0;
> -
> -	/* Can the mapping track the dirty pages? */
> -	return vma->vm_file && vma->vm_file->f_mapping &&
> -		mapping_can_writeback(vma->vm_file->f_mapping);
> +	return vma_needs_dirty_tracking(vma);
>  }
>
>  /*
> --
> 2.40.0

Apologies, for some reason I forgot to include the revision list in that
patch, enclosed below:-

v5:
- Rebased on latest mm-unstable as of 25th April 2023.
- Some small refactorings suggested by John.
- Added an extended description of the problem in the comment around
  writeable_file_mapping_allowed() for clarity.
- Updated commit message as suggested by Mika and John.

v4:
- Split out vma_needs_dirty_tracking() from vma_wants_writenotify() to
  reduce duplication and update to use this in the GUP check. Note that
  both separately check vm_ops_needs_writenotify() as the latter needs to
  test this before the vm_pgprot_modify() test, resulting in
  vma_wants_writenotify() checking this twice, however it is such a small
  check this should not be egregious.
https://lore.kernel.org/all/3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com/

v3:
- Rebased on latest mm-unstable as of 24th April 2023.
- Explicitly check whether file system requires folio dirtying. Note that
  vma_wants_writenotify() could not be used directly as it is very much focused
  on determining if the PTE r/w should be set (e.g. assuming private mapping
  does not require it as already set, soft dirty considerations).
- Tested code against shmem and hugetlb mappings - confirmed that these are not
  disallowed by the check.
- Eliminate FOLL_ALLOW_BROKEN_FILE_MAPPING flag and instead perform check only
  for FOLL_LONGTERM pins.
- As a result, limit check to internal GUP code.
 https://lore.kernel.org/all/23c19e27ef0745f6d3125976e047ee0da62569d4.1682406295.git.lstoakes@gmail.com/

v2:
- Add accidentally excluded ptrace_access_vm() use of
  FOLL_ALLOW_BROKEN_FILE_MAPPING.
- Tweak commit message.
https://lore.kernel.org/all/c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com/

v1:
https://lore.kernel.org/all/f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com/
