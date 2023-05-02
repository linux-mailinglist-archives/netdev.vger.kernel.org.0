Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6DD6F45A0
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbjEBN60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbjEBN6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:58:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D721119
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 06:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683035856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BFKZppZmpvZn37NH6T+y3WQHfsa5GEZZMAq/yDgIM88=;
        b=SBQeuithexmoHOGfYqdB3Xg9kiLElAIoKMqwWx/eC/2oz9SJlx4j8O659/dars36YDBLCn
        WwffOlkt2KjmDQzY5rIO0qg5f40AtQmoKm6R1WKsaFTWaNvxpSTVPB8DAY7Y5EPtNMMwvw
        bAnUuXmUyiMKRIl+sH/rHtY6DGmUGV4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-Uw6HY6dlPUqp-dy9FUTE7w-1; Tue, 02 May 2023 09:57:34 -0400
X-MC-Unique: Uw6HY6dlPUqp-dy9FUTE7w-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f1793d6363so11522415e9.1
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 06:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683035854; x=1685627854;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BFKZppZmpvZn37NH6T+y3WQHfsa5GEZZMAq/yDgIM88=;
        b=F5HoqJSaKrIrcHCnuvuYWqgpAIO89qWNZMMhHrkTL6V6Z4tiR3PEhgJ/c/WXbtOAaj
         bCKiyxUfhYC1K5DRfPyWo1r9VNVgqmvbUvlpXMEfe4Y7ZD+gkI/Gt4I6vTvi84+GB0ly
         gWxuwJvsW1rD1e8KDZ0alqpEreCcu2xmGsp1bGvVeQnt4MUMkXeLIwaclJg52ZM9jipT
         UDTRkT4wByKEatu6CsaLSOU3FkuwoUUpy8ZWHKpwHa8RcfEgp/WtJTnHCrjrboDT/g39
         GSWaGlcY+faPk4xeQ2FSSUk81qay2xZ+BIK3FTHdT2p01X01HRgWtxdw1I2D+IfrHwZl
         DxzA==
X-Gm-Message-State: AC+VfDwiLq6qkQ8IOWOwrlCFCGkSOh6z7kBC1nEZtyUIlNvTwHvj3UkP
        R5CyX4DdXkySxNZ+N4wOWAgCjhKHxyLn5ftOPiGbk/gj5v/27gAQNRYsWpEfGNRAXQVvkzS6X2w
        jx0yh5Miw+/VaqO1G
X-Received: by 2002:a05:600c:3787:b0:3f1:9540:d5fe with SMTP id o7-20020a05600c378700b003f19540d5femr11730785wmr.21.1683035853687;
        Tue, 02 May 2023 06:57:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4h+z02B2dd70XZKfnqJ5spQ0OHCTBKNIKA8Em6ryzkITiNSlT8DvH2K/BVtegqd1JIECFQbA==
X-Received: by 2002:a05:600c:3787:b0:3f1:9540:d5fe with SMTP id o7-20020a05600c378700b003f19540d5femr11730752wmr.21.1683035853338;
        Tue, 02 May 2023 06:57:33 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm51382271wmq.1.2023.05.02.06.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 06:57:32 -0700 (PDT)
Message-ID: <1ffbbfb7-6bca-0ab0-1a96-9ca81d5fa373@redhat.com>
Date:   Tue, 2 May 2023 15:57:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
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
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
References: <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <ZFEL20GQdomXGxko@nvidia.com>
 <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
 <ZFER5ROgCUyywvfe@nvidia.com>
 <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
 <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
 <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
 <ZFEVQmFGL3GxZMaf@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
In-Reply-To: <ZFEVQmFGL3GxZMaf@nvidia.com>
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

On 02.05.23 15:50, Jason Gunthorpe wrote:
> On Tue, May 02, 2023 at 03:47:43PM +0200, David Hildenbrand wrote:
>>> Eventually we want to implement a mechanism where we can dynamically pin in response to RPCIT.
>>
>> Okay, so IIRC we'll fail starting the domain early, that's good. And if we
>> pin all guest memory (instead of small pieces dynamically), there is little
>> existing use for file-backed RAM in such zPCI configurations (because memory
>> cannot be reclaimed either way if it's all pinned), so likely there are no
>> real existing users.
> 
> Right, this is VFIO, the physical HW can't tolerate not having pinned
> memory, so something somewhere is always pinning it.
> 
> Which, again, makes it weird/wrong that this KVM code is pinning it
> again :\

IIUC, that pinning is not for ordinary IOMMU / KVM memory access. It's 
for passthrough of (adapter) interrupts.

I have to speculate, but I guess for hardware to forward interrupts to 
the VM, it has to pin the special guest memory page that will receive 
the indications, to then configure (interrupt) hardware to target the 
interrupt indications to that special guest page (using a host physical 
address).

-- 
Thanks,

David / dhildenb

