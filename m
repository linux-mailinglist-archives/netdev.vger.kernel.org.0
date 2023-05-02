Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC296F4850
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbjEBQdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbjEBQdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:33:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E87B1BE5
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 09:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683045149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r1Y9ZHlSDmHQJFAVnELAl0311AMMIMNb4a19zH7pdjw=;
        b=dDham+9XI17xYA3sgv7XlxWUWmE8eqTWi2COMao/YJuCKF949TSXAcIqRfoTEm+5Sz94eZ
        uVOVKSY5tkWKIL+tnVYMzxyGso7tQpZ4AZhabmaAiPo8MYhXjid9MUWB87DHvM9/olFbs3
        nfor2wJuAPPWfszY2ZpA5rppAS1q1mw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-KjcJsbejNOm98gzukgrcfQ-1; Tue, 02 May 2023 12:32:27 -0400
X-MC-Unique: KjcJsbejNOm98gzukgrcfQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f33f8ffa95so8900225e9.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 09:32:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683045146; x=1685637146;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r1Y9ZHlSDmHQJFAVnELAl0311AMMIMNb4a19zH7pdjw=;
        b=DyJilofYH6R5l8xV3cP1iYvXpCsSZgjHgiXWu3vyc7fPdy071R/jxm7QJJVxxSY06e
         DNs+eawDGt0Y/4iPth4n/wMeY1XsT+eMWjdkPLDDCSe5Wwb0Blg6uoflMz3FN152N6d7
         qccbtbuAMYtBEAgIpvMnO+o87BxF4oXCc1L6mKCbPDKzqhFIAIJXeTEFEzPpqy3eTpka
         GaeOaC+uYITBP0VbeSAqzKoQWI9w+4Yz6tGiqmSxOV8YauGcapjhPkrv7htKQEFbn1LG
         Aeb7KnyrbjtEGmbGt3xBcavbzFHnS3MkX8/1ihUf56jJ+Lk06Hgs2q8j4c11kWYF4d7X
         iq+g==
X-Gm-Message-State: AC+VfDxPyHO1Qznyxpc9CuSOW1S0ZC2+WayLwxO/9mJd1KpoIEkuvFi/
        rHliSgonzERtgH+Utz1jMQP9bIGHxCwFDZxIg3z31INxjt6y5sbZe5MH9e86sUNJLjMhQAYNoGv
        iG0SsICmiSCJw9Ky9
X-Received: by 2002:a1c:ed13:0:b0:3f1:70a2:ceb5 with SMTP id l19-20020a1ced13000000b003f170a2ceb5mr12419693wmh.13.1683045146466;
        Tue, 02 May 2023 09:32:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7p+ImTRga1SD1m+KPY+ssu9CtAR9wKLd9W6rRm22/MRxLwFhs/WFpL//bdAy4L2m8Bf5dmkg==
X-Received: by 2002:a1c:ed13:0:b0:3f1:70a2:ceb5 with SMTP id l19-20020a1ced13000000b003f170a2ceb5mr12419652wmh.13.1683045146112;
        Tue, 02 May 2023 09:32:26 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id m36-20020a05600c3b2400b003edc4788fa0sm40176251wms.2.2023.05.02.09.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 09:32:25 -0700 (PDT)
Message-ID: <6681789f-f70e-820d-a185-a17e638dfa53@redhat.com>
Date:   Tue, 2 May 2023 18:32:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
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
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>
References: <1ffbbfb7-6bca-0ab0-1a96-9ca81d5fa373@redhat.com>
 <ZFEYblElll3pWtn5@nvidia.com>
 <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
 <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
 <ZFEqTo+l/S8IkBQm@nvidia.com> <ZFEtKe/XcnC++ACZ@x1n>
 <ZFEt/ot6VKOgW1mT@nvidia.com>
 <4fd5f74f-3739-f469-fd8a-ad0ea22ec966@redhat.com>
 <ZFE07gfyp0aTsSmL@nvidia.com>
 <1f29fe90-1482-7435-96bd-687e991a4e5b@redhat.com>
 <ZFE4A7HbM9vGhACI@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
In-Reply-To: <ZFE4A7HbM9vGhACI@nvidia.com>
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

On 02.05.23 18:19, Jason Gunthorpe wrote:
> On Tue, May 02, 2023 at 06:12:39PM +0200, David Hildenbrand wrote:
> 
>>> It missses the general architectural point why we have all these
>>> shootdown mechanims in other places - plares are not supposed to make
>>> these kinds of assumptions. When the userspace unplugs the memory from
>>> KVM or unmaps it from VFIO it is not still being accessed by the
>>> kernel.
>>
>> Yes. Like having memory in a vfio iommu v1 and doing the same (mremap,
>> munmap, MADV_DONTNEED, ...). Which is why we disable MADV_DONTNEED (e.g.,
>> virtio-balloon) in QEMU with vfio.
> 
> That is different, VFIO has it's own contract how it consumes the
> memory from the MM and VFIO breaks all this stuff.
> 
> But when you tell VFIO to unmap the memory it doesn't keep accessing
> it in the background like this does.

To me, this is similar to when QEMU (user space) triggers 
KVM_S390_ZPCIOP_DEREG_AEN, to tell KVM to disable AIF and stop using the 
page (1) When triggered by the guest explicitly (2) when resetting the 
VM (3) when resetting the virtual PCI device / configuration.

Interrupt gets unregistered from HW (which stops using the page), the 
pages get unpinned. Pages get no longer used.

I guess I am still missing (a) how this is fundamentally different (b) 
how it could be done differently.

I'd really be happy to learn how a better approach would look like that 
does not use longterm pinnings.

I don't see an easy way to not use longterm pinnings. When using mmu 
notifiers and getting notified about unmapping of a page (for whatever 
reason ... migration, swapout, unmap), you'd have to disable aif. But 
when to reenable it (maybe there would be a way)? Also, I'm not sure if 
this could even be visible by the guest, if it's suddenly no longer enabled.

Something for the s390x people to explore ... if HW would be providing a 
way to deal with that somehow.

-- 
Thanks,

David / dhildenb

