Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB8F6F4A47
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjEBTYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 15:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjEBTYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 15:24:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70650198D
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 12:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683055439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eebKb+TsagwbVZx+TXwlGTIKwC3csstjJ30OZt/ChDs=;
        b=N0RrYGx84OSY/3AbOyF1cT9Wnbvm2WS43etMQyg28Q/bwTkj2d50mOY6XVrcZluemlPTuG
        je+sJkJKr4vMjsl4XU+USpdoS/Ysi+4E1BNrKFFgfHKE7FcT2YFwRaP7jEMJ2ANbIFgJEk
        0mQVxmV4AQQVY7HbBo3ags7kZGXwxek=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-oXXKIy2vN1uZi2d0kcdNmw-1; Tue, 02 May 2023 15:23:58 -0400
X-MC-Unique: oXXKIy2vN1uZi2d0kcdNmw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30479b764f9so1173298f8f.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 12:23:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683055437; x=1685647437;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eebKb+TsagwbVZx+TXwlGTIKwC3csstjJ30OZt/ChDs=;
        b=mAAHGLGuSLJk4+nar9I8qNJ/vjr7JUHgN7naz0/ccklXHNiY+Qf9FZc1oDn+ATq2BI
         MWbfXAbKDz1cuBJsS8XjdvhORln4ZzBhOSfJp1R0nLJpg64rPLPEERweIv6C0gOJAzxy
         Yu40xcc6FZ/Qun1SYMJzaLAbIlr1vHrFnI+Sht8ifcoq9kreSQJv8K60HfTcSzF7TDS8
         pgvkf8om93EUsa6Q0KP6YMQBaWAkOHddjZIF24N52VyYsnkyAym/ngfeL6DXZXrjsACg
         AK5kMW8VqK5gyKaCpeemk0/vOISRYoApr9a8IxmcpDwjcv2EPcYJaZmE3Q5A6xTq+qoq
         gtig==
X-Gm-Message-State: AC+VfDxapgkqjvI1Zb1Mo9niDXho6wcR/NVblXHC5p29AXB4DZxg2CCl
        rDvqHWgXcN0KrNCpanemmoXyeqpK2t5KEla9PJBEHL8OqZTX1mp8DjopyGlWCrgmcscQYoLio3X
        N29rfnWG6wU/I1aSP
X-Received: by 2002:a5d:4e08:0:b0:2fe:2775:6067 with SMTP id p8-20020a5d4e08000000b002fe27756067mr12850040wrt.28.1683055437190;
        Tue, 02 May 2023 12:23:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ52sK3ZU3tbew+lQjq4BZTENLqPkH6FqYjfheHwv6rwX9tRJiuLFtrfQqzjGEl3dyA8PVf5BQ==
X-Received: by 2002:a5d:4e08:0:b0:2fe:2775:6067 with SMTP id p8-20020a5d4e08000000b002fe27756067mr12849995wrt.28.1683055436775;
        Tue, 02 May 2023 12:23:56 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm52367092wmq.1.2023.05.02.12.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 12:23:56 -0700 (PDT)
Message-ID: <d8fa7322-8fab-b693-2075-3f5f2253ef88@redhat.com>
Date:   Tue, 2 May 2023 21:23:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
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
References: <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
 <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
 <ZFEqTo+l/S8IkBQm@nvidia.com> <ZFEtKe/XcnC++ACZ@x1n>
 <ZFEt/ot6VKOgW1mT@nvidia.com>
 <4fd5f74f-3739-f469-fd8a-ad0ea22ec966@redhat.com>
 <ZFE07gfyp0aTsSmL@nvidia.com>
 <1f29fe90-1482-7435-96bd-687e991a4e5b@redhat.com>
 <ZFE4A7HbM9vGhACI@nvidia.com>
 <6681789f-f70e-820d-a185-a17e638dfa53@redhat.com>
 <ZFFMXswUwsQ6lRi5@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZFFMXswUwsQ6lRi5@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.05.23 19:46, Jason Gunthorpe wrote:
> On Tue, May 02, 2023 at 06:32:23PM +0200, David Hildenbrand wrote:
>> On 02.05.23 18:19, Jason Gunthorpe wrote:
>>> On Tue, May 02, 2023 at 06:12:39PM +0200, David Hildenbrand wrote:
>>>
>>>>> It missses the general architectural point why we have all these
>>>>> shootdown mechanims in other places - plares are not supposed to make
>>>>> these kinds of assumptions. When the userspace unplugs the memory from
>>>>> KVM or unmaps it from VFIO it is not still being accessed by the
>>>>> kernel.
>>>>
>>>> Yes. Like having memory in a vfio iommu v1 and doing the same (mremap,
>>>> munmap, MADV_DONTNEED, ...). Which is why we disable MADV_DONTNEED (e.g.,
>>>> virtio-balloon) in QEMU with vfio.
>>>
>>> That is different, VFIO has it's own contract how it consumes the
>>> memory from the MM and VFIO breaks all this stuff.
>>>
>>> But when you tell VFIO to unmap the memory it doesn't keep accessing
>>> it in the background like this does.
>>
>> To me, this is similar to when QEMU (user space) triggers
>> KVM_S390_ZPCIOP_DEREG_AEN, to tell KVM to disable AIF and stop using the
>> page (1) When triggered by the guest explicitly (2) when resetting the VM
>> (3) when resetting the virtual PCI device / configuration.
>>
>> Interrupt gets unregistered from HW (which stops using the page), the pages
>> get unpinned. Pages get no longer used.
>>
>> I guess I am still missing (a) how this is fundamentally different (b) how
>> it could be done differently.
> 
> It uses an address that is already scoped within the KVM memory map
> and uses KVM's gpa_to_gfn() to translate it to some pinnable page
> 
> It is not some independent thing like VFIO, it is explicitly scoped
> within the existing KVM structure and it does not follow any mutations
> that are done to the gpa map through the usual KVM APIs.

Right, it consumes guest physical addresses that are translated via the KVM memslots.
Agreed that it does not (and possibly cannot easily) update the hardware when the KVM
mapping (memslots) would ever change.

I guess it's also not documented that this is not supported.

> 
>> I'd really be happy to learn how a better approach would look like that does
>> not use longterm pinnings.
> 
> Sounds like the FW sadly needs pinnings. This is why I said it looks
> like DMA. If possible it would be better to get the pinning through
> VFIO, eg as a mdev
> 
> Otherwise, it would have been cleaner if this was divorced from KVM
> and took in a direct user pointer, then maybe you could make the
> argument is its own thing with its own lifetime rules. (then you are
> kind of making your own mdev)

It would be cleaner if user space would translate the GPA to a HVA and provid
  that, agreed ...

> 
> Or, perhaps, this is really part of some radical "irqfd" that we've
> been on and off talking about specifically to get this area of
> interrupt bypass uAPI'd properly..

Most probably. It's one of these very special cases ... thankfully:

$ git grep -i longterm | grep kvm
arch/s390/kvm/pci.c:    npages = pin_user_pages_fast(hva, 1, FOLL_WRITE | FOLL_LONGTERM, pages);
arch/s390/kvm/pci.c:            npages = pin_user_pages_fast(hva, 1, FOLL_WRITE | FOLL_LONGTERM,


-- 
Thanks,

David / dhildenb

