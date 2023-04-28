Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2EC6F1CC9
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346150AbjD1Qkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346027AbjD1Qkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:40:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADD25261
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682699997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rWkVvKB+beFGKaX1u6z+cXwjtof0A4OJbagxKAP5YOc=;
        b=cF876kMRNBy1bv43KLhO764QHdjyUalp5pxkEl7SR5QjngVwdZHnxcsg0+yBWwI2KnegWk
        YoYu+eRL7alFyxReyaUoo0CzMGhPuOLIi08q9sJdJQO9/zNnbaWc7LSDUByNbvjGHui8CG
        qGfQ72t6n8lCfMydpNTCn8jSymcLO+g=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-WZLibiOCN16w-PefthbWFA-1; Fri, 28 Apr 2023 12:39:56 -0400
X-MC-Unique: WZLibiOCN16w-PefthbWFA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-5ef4d54d84cso311696d6.0
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:39:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682699995; x=1685291995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rWkVvKB+beFGKaX1u6z+cXwjtof0A4OJbagxKAP5YOc=;
        b=ido2HSyWN3gCGFBHQCgjtdofsshKycFGsjukcNYzswq4UEFRLSTaZLfCjTTKP1qT7N
         keW9Y4hFwt+TUvtKPM8G7G4pCc8QbrOIbf5vc7RIt48ZmaBmVndatIsmF0X7B74MFHwy
         J0wVPtepoHB4CYovw33q2aFQmitgxZwdPF2qNviPLy/SAG/Iy7dzZjfNrUJM3CwHpjnS
         0SaItZ7owAxYCXdfHQB7v5nLa7TunAMy5voXZHTdOek1gpsXOQDzByoggaF+hfm9lnPs
         2Hf2USnSnZoCwtC0qXgZz4+GbqHrk76q7N0tTAs/PNiTvTlFvlvmoZDsxBu0TMifFrsK
         3AjA==
X-Gm-Message-State: AC+VfDzL0ZVTquOhekT/Z46jMGQXhyZFqLm947xKfchmIP+3ls5z62Mk
        FaGO1uHszslBoehX4nxjOl77JXV+FDYBqmME6Ie1qJfFyXLB0/e8XDlhhMGCSFyWEGVw8Q84Fqz
        vclxuHIOa2MVpjZP1
X-Received: by 2002:a05:6214:3002:b0:603:fa46:d368 with SMTP id ke2-20020a056214300200b00603fa46d368mr8548781qvb.1.1682699995623;
        Fri, 28 Apr 2023 09:39:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5JPS7VyAu8Sw9pswc/4Y0KvJbwIs0sXe5VJVf724QrbDRJaDnc8X56jBH6cDgE4mKlziivDA==
X-Received: by 2002:a05:6214:3002:b0:603:fa46:d368 with SMTP id ke2-20020a056214300200b00603fa46d368mr8548725qvb.1.1682699995096;
        Fri, 28 Apr 2023 09:39:55 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id a26-20020a0c8bda000000b005dd8b9345dbsm440012qvc.115.2023.04.28.09.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 09:39:54 -0700 (PDT)
Date:   Fri, 28 Apr 2023 12:39:51 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Kirill A . Shutemov" <kirill@shutemov.name>
Cc:     David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
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
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEv2196tk5yWvgW5@x1n>
References: <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 07:22:07PM +0300, Kirill A . Shutemov wrote:
> On Fri, Apr 28, 2023 at 06:13:03PM +0200, David Hildenbrand wrote:
> > On 28.04.23 18:09, Kirill A . Shutemov wrote:
> > > On Fri, Apr 28, 2023 at 05:43:52PM +0200, David Hildenbrand wrote:
> > > > On 28.04.23 17:34, David Hildenbrand wrote:
> > > > > On 28.04.23 17:33, Lorenzo Stoakes wrote:
> > > > > > On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
> > > > > > > > > 
> > > > > > > > > Security is the primary case where we have historically closed uAPI
> > > > > > > > > items.
> > > > > > > > 
> > > > > > > > As this patch
> > > > > > > > 
> > > > > > > > 1) Does not tackle GUP-fast
> > > > > > > > 2) Does not take care of !FOLL_LONGTERM
> > > > > > > > 
> > > > > > > > I am not convinced by the security argument in regard to this patch.
> > > > > > > > 
> > > > > > > > 
> > > > > > > > If we want to sells this as a security thing, we have to block it
> > > > > > > > *completely* and then CC stable.
> > > > > > > 
> > > > > > > Regarding GUP-fast, to fix the issue there as well, I guess we could do
> > > > > > > something similar as I did in gup_must_unshare():
> > > > > > > 
> > > > > > > If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
> > > > > > > fallback to ordinary GUP. IOW, if we don't know, better be safe.
> > > > > > 
> > > > > > How do we determine it's non-anon in the first place? The check is on the
> > > > > > VMA. We could do it by following page tables down to folio and checking
> > > > > > folio->mapping for PAGE_MAPPING_ANON I suppose?
> > > > > 
> > > > > PageAnon(page) can be called from GUP-fast after grabbing a reference.
> > > > > See gup_must_unshare().
> > > > 
> > > > IIRC, PageHuge() can also be called from GUP-fast and could special-case
> > > > hugetlb eventually, as it's table while we hold a (temporary) reference.
> > > > Shmem might be not so easy ...
> > > 
> > > page->mapping->a_ops should be enough to whitelist whatever fs you want.
> > > 
> > 
> > The issue is how to stabilize that from GUP-fast, such that we can safely
> > dereference the mapping. Any idea?
> > 
> > At least for anon page I know that page->mapping only gets cleared when
> > freeing the page, and we don't dereference the mapping but only check a
> > single flag stored alongside the mapping. Therefore, PageAnon() is fine in
> > GUP-fast context.
> 
> What codepath you are worry about that clears ->mapping on pages with
> non-zero refcount?
> 
> I can only think of truncate (and punch hole). READ_ONCE(page->mapping)
> and fail GUP_fast if it is NULL should be fine, no?
> 
> I guess we should consider if the inode can be freed from under us and the
> mapping pointer becomes dangling. But I think we should be fine here too:
> VMA pins inode and VMA cannot go away from under GUP.

Can vma still go away if during a fast-gup?

> 
> Hm?
> 
> (I didn't look close at GUP for a while and my reasoning might be off.)

Thanks,

-- 
Peter Xu

