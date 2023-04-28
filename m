Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4786F1BD5
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345685AbjD1Pmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345778AbjD1Pmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:42:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CD72129
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682696511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1H9pPvEM+Js8vhAavaMMOgoamiyAYwUIQKWzoU2WpOs=;
        b=DDQscX4NqrCNjTNDbaIWOOcvmajnm7SbFty0OQAc9MBcd+wWq3y/B6NcnJv2ArEtX8Jx0H
        xXtl4l1YR1nY+r6nfaGyluq2VYj1icNo8n3CqidOLf8fuHxiKLidHr8/htLsXBkZ/OSUN7
        2ko5hucGVmnzprGgIGJzg9bbhDVtcR4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-mpiglGHhOV6kuejTlcj5Ww-1; Fri, 28 Apr 2023 11:41:48 -0400
X-MC-Unique: mpiglGHhOV6kuejTlcj5Ww-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f1763fac8bso64691245e9.1
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682696497; x=1685288497;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1H9pPvEM+Js8vhAavaMMOgoamiyAYwUIQKWzoU2WpOs=;
        b=CO7vL7Lqa3XJ9SBHMsK374W5gNdh4bXTvAsS55fT7E3I3NMAtoGKAR+dUm2K4y6idI
         RmnqCyhM45Eb+duuSfXYae/ZZ8I6VU0MBdYkebt5zMPSt5LdW9WfiIdO8JOxTPYVRD/R
         UAE6/nsbq9DxjMdOJ5TJPUXWBTv8o37K3ibXm3XoL6eNsbUP/BNqjwVe389s4U4QaDje
         ReqQLgcSfviGp78SBMScGXwJg3sKUKanfZ3FsuX5rHLZym9hXvPqRHEcmM3g7Z4qcxQ/
         uuGivBHnbOBcYGDpj6H8Fm2RpHLRXItf9pRkiD8BjxSJ4Php/K0qOrN3iCFJ+lq/7D0q
         yxCg==
X-Gm-Message-State: AC+VfDyWSAk5dIRquy4Hl6ucZG/NkL/25RRRl+OBjpnSewRqikW+Gfav
        erASh0eT/1ewBu0XGeLyiJ4gqh9LfY0NuN5TbgYhOsmcYmLTGGM8Gx7WRlJLYsJ/gGvdrP+rp1j
        GEVKBRRWPvG+e9kPq
X-Received: by 2002:a1c:ed0e:0:b0:3f2:5999:4f2b with SMTP id l14-20020a1ced0e000000b003f259994f2bmr4546932wmh.33.1682696497207;
        Fri, 28 Apr 2023 08:41:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7+nd0elYn4hmRLxdtWbwWjgrHCODyP2os9nbfNCf2KA/02ixLHWZjvg+Rr1dUNu/tXPRuH2w==
X-Received: by 2002:a1c:ed0e:0:b0:3f2:5999:4f2b with SMTP id l14-20020a1ced0e000000b003f259994f2bmr4546874wmh.33.1682696496848;
        Fri, 28 Apr 2023 08:41:36 -0700 (PDT)
Received: from ?IPV6:2003:cb:c726:9300:1711:356:6550:7502? (p200300cbc72693001711035665507502.dip0.t-ipconnect.de. [2003:cb:c726:9300:1711:356:6550:7502])
        by smtp.gmail.com with ESMTPSA id r6-20020a05600c458600b003f195d540d9sm20569992wmo.14.2023.04.28.08.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 08:41:36 -0700 (PDT)
Message-ID: <3f97c798-3598-1729-1981-ab8acb7b5663@redhat.com>
Date:   Fri, 28 Apr 2023 17:41:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <ZEvl717EANEu8113@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
In-Reply-To: <ZEvl717EANEu8113@nvidia.com>
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

On 28.04.23 17:27, Jason Gunthorpe wrote:
> On Fri, Apr 28, 2023 at 05:08:27PM +0200, David Hildenbrand wrote:
> 
>>> I think this is broken today and we should block it. We know from
>>> experiments with RDMA that doing exactly this triggers kernel oop's.
>>
>> I never saw similar reports in the wild (especially targeted at RHEL), so is
>> this still a current issue that has not been mitigated? Or is it just so
>> hard to actually trigger?
> 
> People send RDMA related bug reports to us, and we tell them not to do
> this stuff :)
> 
>>> I'm skeptical that anyone can actually do this combination of things
>>> successfully without getting kernel crashes or file data corruption -
>>> ie there is no real user to break.
>>
>> I am pretty sure that there are such VM users, because on the libvirt level
>> it's completely unclear which features trigger what behavior :/
> 
> IDK, why on earth would anyone want to do this? Using VFIO forces all
> the memory to become resident so what was the point of making it file
> backed in the first place?

As I said, copy-and paste, incremental changes to domain XMLs. I've seen 
some crazy domain XMLs in bug reports.

> 
> I'm skeptical there are real users even if it now requires special
> steps to be crashy/corrupty.

In any case, I think we should document the possible implications of 
this patch. I gave one use case that could be broken.

> 
>>>> Sure, we could warn, or convert individual users using a flag (io_uring).
>>>> But maybe we should invest more energy on a fix?
>>>
>>> It has been years now, I think we need to admit a fix is still years
>>> away. Blocking the security problem may even motivate more people to
>>> work on a fix.
>>
>> Maybe we should make this a topic this year at LSF/MM (again?). At least we
>> learned a lot about GUP, what might work, what might not work, and got a
>> depper understanding (+ motivation to fix? :) ) the issue at hand.
> 
> We keep having the topic.. This is the old argument that the FS people
> say the MM isn't following its inode and dirty lifetime rules and the
> MM people say the FS isn't following its refcounting rules <shrug>

:/ so we have to discuss it ... again I guess.

> 
>>> Security is the primary case where we have historically closed uAPI
>>> items.
>>
>> As this patch
>>
>> 1) Does not tackle GUP-fast
>> 2) Does not take care of !FOLL_LONGTERM
>>
>> I am not convinced by the security argument in regard to this patch.
> 
> It is incremental and a temperature check to see what kind of real
> users exist. We have no idea right now, just speculation.

Right, but again, if we start talking about security it's a different 
thing IMHO.

>> Everything else sounds like band-aids to me, is insufficient, and might
>> cause more harm than actually help IMHO. Especially the gup-fast case is
>> extremely easy to work-around in malicious user space.
> 
> It is true this patch should probably block gup_fast when using
> FOLL_LONGTERM as well, just like we used to do for the DAX check.

Then we'd at least fix the security issue for all FOLL_LONGTERM completely.

-- 
Thanks,

David / dhildenb

