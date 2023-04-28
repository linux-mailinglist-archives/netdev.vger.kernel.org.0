Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29326F1A65
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 16:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345870AbjD1OVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 10:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjD1OVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 10:21:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF06E44
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 07:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682691653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gv0P60I1m+zx490TNpqDLMm/gN26L3C73hsWxl2z9Eg=;
        b=Ks4BYZkJ+QdbQmvMnrhgGLw2PXJ8BOaGOy0An/6fYyqi3Z7JApbNKkI/mw+gnPZngBYMlf
        h0KNCV3w+yRPSqoA5lqn+P6q/UzStbMBiBjTxae9W+v/KaMQ0CDIZFyDt+aDIsFLftYzrR
        Q0Y9V2DY/LxdDZ4q6ax9VzEkxjkGefo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-log7kdhWMGG_wQZNUwhztw-1; Fri, 28 Apr 2023 10:20:51 -0400
X-MC-Unique: log7kdhWMGG_wQZNUwhztw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f195129aa4so53103035e9.2
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 07:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682691650; x=1685283650;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gv0P60I1m+zx490TNpqDLMm/gN26L3C73hsWxl2z9Eg=;
        b=jj3HijQzLYeRgJCeix88nIkAIQvPKCBVnA1cgCF9YaycBI2Ppr7wITJHH68VpfqAEA
         1Wg1UV9E0zE875peYqB1RjqE+htvrl1MUlWvgFfW43l44lQGcPZCqpEBiWIvvtOKLrHa
         dBSBBOuLdHP2VUNR8ooUqid1zzv0G7G2tQeqPV3JtHtfurvcoTHTKXxI60gCeVgCfoUp
         1a/sjmSzeyAHh31syE4uSNzK3+Q1WLJdkZlURP8SCz7iRBGdEO8g36SeTgixaoi0Ubqf
         BppMPIEc+6NbE4mrLjaUAmXgRIvOpm4XulEbQqsX8QBDFfjkV5OufDHELN6VgKmX+g3d
         fwGw==
X-Gm-Message-State: AC+VfDwljrEdy2yur1zwWehz1ucZxtI8atk3Mq0uTbjeOLq1s//e5vna
        yKpY+zIKNI7I7YEbLHmSbkQpRiPbwkxYpbsp8ESzZb+TJFwcq1NxUDL/C5IF5l6PBkYl94o2JBO
        SjViZlYK9vhZ5wsJw
X-Received: by 2002:a1c:f706:0:b0:3f2:5028:a54d with SMTP id v6-20020a1cf706000000b003f25028a54dmr4286852wmh.0.1682691649674;
        Fri, 28 Apr 2023 07:20:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Ef+6JXTWHdAiFME6ae0mlQwifNq9sneotXxTQMRQu6YRP1y3jjdZfpGN/dZmsrEadhA0T1g==
X-Received: by 2002:a1c:f706:0:b0:3f2:5028:a54d with SMTP id v6-20020a1cf706000000b003f25028a54dmr4286805wmh.0.1682691649225;
        Fri, 28 Apr 2023 07:20:49 -0700 (PDT)
Received: from ?IPV6:2003:cb:c726:9300:1711:356:6550:7502? (p200300cbc72693001711035665507502.dip0.t-ipconnect.de. [2003:cb:c726:9300:1711:356:6550:7502])
        by smtp.gmail.com with ESMTPSA id z4-20020a05600c0a0400b003ef4cd057f5sm28589070wmp.4.2023.04.28.07.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 07:20:48 -0700 (PDT)
Message-ID: <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
Date:   Fri, 28 Apr 2023 16:20:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
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
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
In-Reply-To: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for jumping in late, I'm on vacation :)

On 28.04.23 01:42, Lorenzo Stoakes wrote:
> Writing to file-backed mappings which require folio dirty tracking using
> GUP is a fundamentally broken operation, as kernel write access to GUP
> mappings do not adhere to the semantics expected by a file system.
> 
> A GUP caller uses the direct mapping to access the folio, which does not
> cause write notify to trigger, nor does it enforce that the caller marks
> the folio dirty.

How should we enforce it? It would be a BUG in the GUP user.

> 
> The problem arises when, after an initial write to the folio, writeback
> results in the folio being cleaned and then the caller, via the GUP
> interface, writes to the folio again.
> 
> As a result of the use of this secondary, direct, mapping to the folio no
> write notify will occur, and if the caller does mark the folio dirty, this
> will be done so unexpectedly.

Right, in mprotect() code we only allow upgrading write permissions in 
this case if the pte is dirty, so we always go via the pagefault path.

> 
> For example, consider the following scenario:-
> 
> 1. A folio is written to via GUP which write-faults the memory, notifying
>     the file system and dirtying the folio.
> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>     the PTE being marked read-only.


How would that be triggered? Would that writeback triggered by e.g., 
fsync that Jan tried to tackle recently?


> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>     direct mapping.
> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>     (though it does not have to).
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


This change has the potential to break existing setups. Simple example: 
libvirt domains configured for file-backed VM memory that also has a 
vfio device configured. It can easily be configured by users (evolving 
VM configuration, copy-paste etc.). And it works from a VM perspective, 
because the guest memory is essentially stale once the VM is shutdown 
and the pages were unpinned. At least we're not concerned about stale 
data on disk.

With your changes, such VMs would no longer start, breaking existing 
user setups with a kernel update.

I don't really see a lot of reasons to perform this change now. It's 
been known to be problematic for a long time. People are working on a 
fix (I see Jan is already CCed, CCing Dave and Christop). FOLL_LONGTERM 
check is only handling some of the problematic cases, so it's not even a 
complete blocker.

I know, Jason und John will disagree, but I don't think we want to be 
very careful with changing the default.

Sure, we could warn, or convert individual users using a flag 
(io_uring). But maybe we should invest more energy on a fix?




> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>   include/linux/mm.h |  1 +
>   mm/gup.c           | 41 ++++++++++++++++++++++++++++++++++++++++-
>   mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
>   3 files changed, 68 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 37554b08bb28..f7da02fc89c6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
>   #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>   					    MM_CP_UFFD_WP_RESOLVE)
> 
> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
>   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
>   static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>   {
> diff --git a/mm/gup.c b/mm/gup.c
> index 1f72a717232b..d36a5db9feb1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -959,16 +959,51 @@ static int faultin_page(struct vm_area_struct *vma,
>   	return 0;
>   }
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

FOLL_LONGTERM only applies to FOLL_PIN. This check can be dropped.

> +
> +	/* We limit this check to the most egregious case - a long term pin. */
> +	if (!(gup_flags & FOLL_LONGTERM))
> +		return true;
> +
> +	/* If the VMA requires dirty tracking then GUP will be problematic. */
> +	return vma_needs_dirty_tracking(vma);
> +}
> +
>   static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>   {
>   	vm_flags_t vm_flags = vma->vm_flags;
>   	int write = (gup_flags & FOLL_WRITE);
>   	int foreign = (gup_flags & FOLL_REMOTE);
> +	bool vma_anon = vma_is_anonymous(vma);
> 
>   	if (vm_flags & (VM_IO | VM_PFNMAP))
>   		return -EFAULT;
> 
> -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> +	if ((gup_flags & FOLL_ANON) && !vma_anon)
>   		return -EFAULT;
> 
>   	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> @@ -978,6 +1013,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>   		return -EFAULT;
> 
>   	if (write) {
> +		if (!vma_anon &&
> +		    !writeable_file_mapping_allowed(vma, gup_flags))
> +			return -EFAULT;
> +
>   		if (!(vm_flags & VM_WRITE)) {
>   			if (!(gup_flags & FOLL_FORCE))
>   				return -EFAULT;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 536bbb8fa0ae..7b6344d1832a 100644
> --- a/mm/mmap.c


I'm probably missing something, why don't we have to handle GUP-fast 
(having said that, it's hard to handle ;) )? The sequence you describe 
above should apply to GUP-fast as well, no?

1) Pin writable mapped page using GUP-fast
2) Trigger writeback
3) Write to page via pin
4) Unpin and set dirty


-- 
Thanks,

David / dhildenb

