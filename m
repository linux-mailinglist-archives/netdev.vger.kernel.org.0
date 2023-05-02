Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6986F457A
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbjEBNtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbjEBNtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:49:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D95E618D
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 06:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683035269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3J2uAw/ly+PNbny+QW1yUQ6DEbuSoPG3Zwu6k/I8hM=;
        b=fozI/mZc92pFL+/0eqXM3yQCfGfxEs2OJ8Ej0lP6qiI7zyeYU2nFSNzP5myYt21CmZ+uws
        D3VVy/Mqp6z0WQpvHaWNv6ZKXCEfnMswAAwGuiUmb96k3WpdxO+A6pviy+mPMW+TzVfJk8
        5KTFTf+mh3BLGDDbB/aab3fzHbr0BVI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-tzh_vAgEOyONHalFqZSyow-1; Tue, 02 May 2023 09:47:48 -0400
X-MC-Unique: tzh_vAgEOyONHalFqZSyow-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f321e60feaso12548155e9.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 06:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683035267; x=1685627267;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J3J2uAw/ly+PNbny+QW1yUQ6DEbuSoPG3Zwu6k/I8hM=;
        b=j9cYix4cmbQn17NOJO1S9cxIUNca5YlVhLCnIku2lyA2YD4/60W98N704SWJnMt6qe
         4wIMuCXHSDPY65CSbbs13KbQ9ysWdcABtlUKEJPBNli3c6BFt3WdD0gS0D8aPdR4ouxT
         wrlSkWlt9jgzTDKdZHMQfe/lkAs66UK7SDdwr3ZWMFA2wVCpzabkZweigNBZJo7z9mGZ
         /VAtzdbXcytrZKOO2ail2ekz2BSVgYG5FDR1+LBUJF0U3Eq9LlVurdGKOiX4T6m9i0Jm
         GqwkO7w8nHywck9R3QnItI9h6yjGdtPtL3XRFHlqO9uzi3SZzHU/fveFrXa7gDJJ7IF/
         NdZw==
X-Gm-Message-State: AC+VfDxUnBnxDD7uIERD5T2z2bdwp4qZdjtFBldJJ+idokm8vpaWtGld
        wY/amQnn/GIJ0p+dDXQhUEjJUGBWw+2z9BA0YF9ldV2flAQMRz2F+HOV4/6I23WAZrj+GWGFMnj
        F4g91T5mamHY70AVL
X-Received: by 2002:a1c:7404:0:b0:3f1:92aa:4eb8 with SMTP id p4-20020a1c7404000000b003f192aa4eb8mr13150705wmc.16.1683035267231;
        Tue, 02 May 2023 06:47:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5erONwJ74D2u4zUQpg0uPdUPwazWaMyXU9Kn1O6BpFG7TQ1T86Oqm9RgmLypMPcZwuJndm2g==
X-Received: by 2002:a1c:7404:0:b0:3f1:92aa:4eb8 with SMTP id p4-20020a1c7404000000b003f192aa4eb8mr13150657wmc.16.1683035266844;
        Tue, 02 May 2023 06:47:46 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c00d300b003f17eaae2c9sm35746626wmm.1.2023.05.02.06.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 06:47:45 -0700 (PDT)
Message-ID: <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
Date:   Tue, 2 May 2023 15:47:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
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
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <ZFEL20GQdomXGxko@nvidia.com>
 <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
 <ZFER5ROgCUyywvfe@nvidia.com>
 <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
 <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.05.23 15:43, Matthew Rosato wrote:
> On 5/2/23 9:39 AM, David Hildenbrand wrote:
>> On 02.05.23 15:36, Jason Gunthorpe wrote:
>>> On Tue, May 02, 2023 at 03:28:40PM +0200, David Hildenbrand wrote:
>>>> On 02.05.23 15:10, Jason Gunthorpe wrote:
>>>>> On Tue, May 02, 2023 at 03:04:27PM +0200, Christian Borntraeger wrote:
>>>>> \> > We can reintroduce a flag to permit exceptions if this is really broken, are you
>>>>>>> able to test? I don't have an s390 sat around :)
>>>>>>
>>>>>> Matt (Rosato on cc) probably can. In the end, it would mean having
>>>>>>      <memoryBacking>
>>>>>>        <source type="file"/>
>>>>>>      </memoryBacking>
>>>>>
>>>>> This s390 code is the least of the problems, after this series VFIO
>>>>> won't startup at all with this configuration.
>>>>
>>>> Good question if the domain would fail to start. I recall that IOMMUs for
>>>> zPCI are special on s390x. [1]
>>>
>>> Not upstream they aren't.
>>>
>>>> Well, zPCI is special. I cannot immediately tell when we would trigger
>>>> long-term pinning.
>>>
>>> zPCI uses the standard IOMMU stuff, so it uses a normal VFIO container
>>> and the normal pin_user_pages() path.
>>
>>
>> @Christian, Matthew: would we pin all guest memory when starting the domain (IIRC, like on x86-64) and fail early, or only when the guest issues rpcit instructions to map individual pages?
>>
> 
> Eventually we want to implement a mechanism where we can dynamically pin in response to RPCIT.
> 

Okay, so IIRC we'll fail starting the domain early, that's good. And if 
we pin all guest memory (instead of small pieces dynamically), there is 
little existing use for file-backed RAM in such zPCI configurations 
(because memory cannot be reclaimed either way if it's all pinned), so 
likely there are no real existing users.

> However, per Jason's prior suggestion, the initial implementation for s390 nesting via iommufd will pin all of guest memory when starting the domain.  I have something already working via iommufd built on top of the nesting infrastructure patches and QEMU iommufd series that are floating around; needs some cleanup, hoping to send an RFC in the coming weeks.  I can CC you if you'd like.

Yes, please.

-- 
Thanks,

David / dhildenb

