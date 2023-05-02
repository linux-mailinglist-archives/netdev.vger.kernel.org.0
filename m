Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341316F4A19
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjEBTGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 15:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjEBTGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 15:06:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E70910E5
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 12:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683054331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0S2yc+ZTNRgoAH3fjxIMA+gbVtscqyIDdigzY2/OjVg=;
        b=H/guvCKTa2jBVSoEMYQDGHzh+3kbmMudX0pl0/Z7AnqBbaxNVAvuLB9vh1lTLs5I4AzDxS
        xH2cvBKBMxcsFXbwu1NN4AkirkFQasEZ1NoeOqGF9qrkXMVAsjhCMkT+WVzKkSOmMwuZh6
        ON2ELAmG8GqkFYh4hSNwSEnuPdO4am8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-ia4W7jJZOMGlN_KQfCSqbw-1; Tue, 02 May 2023 15:05:30 -0400
X-MC-Unique: ia4W7jJZOMGlN_KQfCSqbw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f1749c63c9so12815005e9.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 12:05:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683054329; x=1685646329;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0S2yc+ZTNRgoAH3fjxIMA+gbVtscqyIDdigzY2/OjVg=;
        b=KDDuRmyvSDgULxzBwt5etrLK0pBBtdurpcBCDQqOza2KcrieE6+NkeYtBAXuekBca1
         ziyPrUHnBgv7sQqVAe40ou2V8rnrb7KKZ18VuBrUkPM0in2a4N0kExVUfcuiyrwdk8Mo
         bAOUOsNOSrBoKa7++Ee1byop0f1tzhrag9hutH60RqzzXSC4qIE0AlmpvQCSiWgN7WYz
         Q52tMdFUWpnBiMqg0dwteVAM1CshAG1TRGPRYidw1uNX9pPCEHYDoXQNIqxvMhB0VroL
         IKAvcYigVx04oTvd6CmiU4YRu+WxBB+SqOrHq3Qdsgv+edonsvBJC2dXFY6U1BCJbQio
         n4IA==
X-Gm-Message-State: AC+VfDzq6HQ387pyBUwXI7O/ArgxfIm8KF5sFPlYNu6Gw900lay5qftN
        rn2YJujKifIdW7PPIhHf7IyOTbTg7tTgK6M2magtkrRFOgcd/9vC58nzQ7/cdaTv9xw4LYsZRz1
        joFhHHz5Wuq1wVsYj
X-Received: by 2002:a7b:c015:0:b0:3f1:662a:93d0 with SMTP id c21-20020a7bc015000000b003f1662a93d0mr13370009wmb.15.1683054328800;
        Tue, 02 May 2023 12:05:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5V+NnBCdmD2ICFY88fyR5/MuVWTN0W2FYrYm/F35B55dmr3mxlkomvx8ayNTAEFJ/KlNPdKQ==
X-Received: by 2002:a7b:c015:0:b0:3f1:662a:93d0 with SMTP id c21-20020a7bc015000000b003f1662a93d0mr13369974wmb.15.1683054328421;
        Tue, 02 May 2023 12:05:28 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id m9-20020a7bce09000000b003f049a42689sm36193382wmc.25.2023.05.02.12.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 12:05:27 -0700 (PDT)
Message-ID: <82368bae-b2cc-5d55-6de6-e3283cef063b@redhat.com>
Date:   Tue, 2 May 2023 21:05:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
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
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Mike Rapoport <rppt@linux.ibm.com>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
 <20230502172231.GH1597538@hirez.programming.kicks-ass.net>
 <406fd43a-a051-5fbe-6f66-a43f5e7e7573@redhat.com>
 <20230502185926.GE4253@hirez.programming.kicks-ass.net>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230502185926.GE4253@hirez.programming.kicks-ass.net>
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

On 02.05.23 20:59, Peter Zijlstra wrote:
> On Tue, May 02, 2023 at 07:34:06PM +0200, David Hildenbrand wrote:
>> Now, if we read folio->mapping after checking if the page we pinned is still
>> mapped (PTE unchanged), at least the page we pinned cannot be reused in the
>> meantime. I suspect that we can still read "NULL" on the second read. But
>> whatever we dereference from the first read should still be valid, even if
>> the second read would have returned NULL ("rcu freeing").
> 
> Right, but given it's the compiler adding loads we're not sure what if
> anything it uses and it gets very hard to reason about the code.
> 
> This is where READ_ONCE() helps, we instruct the compiler to only do a
> single load and we can still reason about the code.

I completely agree, and I think we should fix that in 
page_is_secretmem() as well.

-- 
Thanks,

David / dhildenb

