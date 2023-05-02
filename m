Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E246F4882
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbjEBQju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbjEBQjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:39:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94A41704
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 09:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683045538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//ueAGz3V8W57PcJ5eJNuZMKi6dMcIUI5CwGFhgH/3E=;
        b=cWMvu6h8uufQ46QoRckkWZjxo5hhvga6v9Cm2XrpblclYyw3SnEZXI/TqTIwZKzI1oT9VQ
        AW9W/me3WwyXqmKGl6bQTUBd78kMtnK6WcswKNGbFKuk+OHz6A0XFRwfg0YlkKMpesnTqb
        HrWTZqFzG8eaEGwxl+mI32oN1wVbMm8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-6viyi31YNyWZB3ldKHjaLg-1; Tue, 02 May 2023 12:38:57 -0400
X-MC-Unique: 6viyi31YNyWZB3ldKHjaLg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-2ff4bc7a770so2353730f8f.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 09:38:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683045536; x=1685637536;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=//ueAGz3V8W57PcJ5eJNuZMKi6dMcIUI5CwGFhgH/3E=;
        b=Dt8xXhhdp+nyPOCtKmmpxbLZ2IK1VjPnCuhGjyD2TY4pJh2IJHy+bp33RD37jPBKKY
         ndMFBlBUXcpOP1rVVRWXCvgi/vF9g9OI0l7/c+iOe+DLGh2p2sQum31rDgE0RchDC/ug
         Zd6jXru0wM4E5cSvcnkZoyAESAMqKL/wMf5cNo/W204qrIgnz2iEX5NlbhvKkBeOEEcl
         nD8zfzYAAY+JOTwtdkTRUelK0o2NxFmJZikEQz2laYvkIruDAPgEgv7ReC+/zA0lzcYi
         K0XpWnNmUipjR9JNlL3Czc+sEKm7OWJ6Q0sq73QTuj8FZ26GT+qMeEUAPjc4qHF0mjx1
         jtPA==
X-Gm-Message-State: AC+VfDydy6COhuZ//WXUFJY4d4STzuuTcNP/+ZXEZdPWqTt4kFkgrZup
        bYQhmJ7gNixejSZPH57iNAb2fHSWHw9Pen5eZNGOGnKIgBLZXxo5B7hRoXCQiumm2TZuti7gMpz
        eDaLq4c3l62q4ZChz
X-Received: by 2002:adf:e70c:0:b0:306:343a:aede with SMTP id c12-20020adfe70c000000b00306343aaedemr3147818wrm.65.1683045536334;
        Tue, 02 May 2023 09:38:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6EmG3a0XC/sdR5E9/CYjrZuR0kZDQoMEtH1BB1xSpjm98KMTPPAbET06MnmTllLBOKtehSVA==
X-Received: by 2002:adf:e70c:0:b0:306:343a:aede with SMTP id c12-20020adfe70c000000b00306343aaedemr3147785wrm.65.1683045535940;
        Tue, 02 May 2023 09:38:55 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id e14-20020adfef0e000000b003063938bf7bsm1902212wro.86.2023.05.02.09.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 09:38:55 -0700 (PDT)
Message-ID: <56696a72-24fa-958e-e6a1-7a17c9e54081@redhat.com>
Date:   Tue, 2 May 2023 18:38:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 1/3] mm/mmap: separate writenotify and dirty tracking
 logic
Content-Language: en-US
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
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <72a90af5a9e4445a33ae44efa710f112c2694cb1.1683044162.git.lstoakes@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <72a90af5a9e4445a33ae44efa710f112c2694cb1.1683044162.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

On 02.05.23 18:34, Lorenzo Stoakes wrote:
> vma_wants_writenotify() is specifically intended for setting PTE page table
> flags, accounting for existing PTE flag state and whether that might
> already be read-only while mixing this check with a check whether the
> filesystem performs dirty tracking.
> 
> Separate out the notions of dirty tracking and a PTE write notify checking
> in order that we can invoke the dirty tracking check from elsewhere.
> 
> Note that this change introduces a very small duplicate check of the
> separated out vm_ops_needs_writenotify(). This is necessary to avoid making
> vma_needs_dirty_tracking() needlessly complicated (e.g. passing a
> check_writenotify flag or having it assume this check was already
> performed). This is such a small check that it doesn't seem too egregious
> to do this.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   include/linux/mm.h |  1 +
>   mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
>   2 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 27ce77080c79..7b1d4e7393ef 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2422,6 +2422,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
>   #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>   					    MM_CP_UFFD_WP_RESOLVE)
>   
> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
>   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
>   static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>   {
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5522130ae606..295c5f2e9bd9 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1475,6 +1475,31 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>   }
>   #endif /* __ARCH_WANT_SYS_OLD_MMAP */
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

Sorry for not noticing this earlier, but ...

what about MAP_PRIVATE mappings? When we write, we populate an anon 
page, which will work as expected ... because we don't have to notify 
the fs?

I think you really also want the "If it was private or non-writable, the 
write bit is already clear */" part as well and remove "false" in that case.

Or was there a good reason to disallow private mappings as well?

-- 
Thanks,

David / dhildenb

