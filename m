Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBA66F44FD
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbjEBN3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbjEBN3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:29:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E385B92
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 06:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683034125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IROBYfVezUGUOMHt+Xf+RoziNZv7xK7RsTQX0q9IseM=;
        b=HwCmDOsxVeDP30hvheU4OJ+dXmcM7Cnj/B8kPx2//x4qVUhWecQCHF431MMymBlEIRcXlV
        jSsd5L2mUd0fnRuQAsLP1HHbGNLEuoD180qSXZySxoXVpxfNnX8hUWyRB/jro4Qj/HgUl7
        SkiF7FBIYnreHJtAh/d1d+TqH0gTrk4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-9-RJ9RKwPP6YN4damR5MSw-1; Tue, 02 May 2023 09:28:44 -0400
X-MC-Unique: 9-RJ9RKwPP6YN4damR5MSw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f315735edeso105233615e9.1
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 06:28:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683034124; x=1685626124;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IROBYfVezUGUOMHt+Xf+RoziNZv7xK7RsTQX0q9IseM=;
        b=UG9hnBLw+moq2WUPcyvbIPxUnKU6r2J92iC3RMDfyrBRvgyArv9XjeZyO/bUjfntMg
         R2CY2xlDu0ws29kqXsdT9K8u2JhTd5WKKollzKL5+m9i+h3EN+zQsQdlEYIhL5fRyP1P
         jRg9sVu71W8HhqBU5q1HPqtNWya/Emb9hv1DrcB72K1LXjlLXIEVjEx07fumzqY7xFqU
         2FDSlijr//prDZl1qMeRiY8DNRpg+PIVgYU/Gb+T6MgzmNX4Y0MqPE2uoUZrlx4qMn8n
         PsyRHKwWpgCvsv/wE6X/VN3ZLmtBvmTcNl9tjov/SVidkq3brIH3iAfx0uLPPTk3mZwH
         Wo/w==
X-Gm-Message-State: AC+VfDwZR42muceeIAYzs7OujyHSSNFhB8DlbtEJRK6TpQY634v3TtA1
        OcG2BOVeQgaBC0VEJ/Durc5rmhBdvVNEkIr2Px5Osp7ZTSWPTeM6kWqISGQ1oA5d3qsVq6775of
        1IUYvZ33+Fq4qhTy3
X-Received: by 2002:a7b:c7c4:0:b0:3f1:6f57:6fd1 with SMTP id z4-20020a7bc7c4000000b003f16f576fd1mr12572141wmk.9.1683034123616;
        Tue, 02 May 2023 06:28:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4zyzv2s4Kee5M/SxJ733JQIlFSdNxIYqlUKU4njxydWjKV07txCkKBkKlNa6sh0b/vYPOUXQ==
X-Received: by 2002:a7b:c7c4:0:b0:3f1:6f57:6fd1 with SMTP id z4-20020a7bc7c4000000b003f16f576fd1mr12572106wmk.9.1683034123289;
        Tue, 02 May 2023 06:28:43 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id p5-20020a05600c468500b003f18141a016sm38716313wmo.18.2023.05.02.06.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 06:28:42 -0700 (PDT)
Message-ID: <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
Date:   Tue, 2 May 2023 15:28:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
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
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <ZFEL20GQdomXGxko@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
In-Reply-To: <ZFEL20GQdomXGxko@nvidia.com>
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

On 02.05.23 15:10, Jason Gunthorpe wrote:
> On Tue, May 02, 2023 at 03:04:27PM +0200, Christian Borntraeger wrote:
> \> > We can reintroduce a flag to permit exceptions if this is really broken, are you
>>> able to test? I don't have an s390 sat around :)
>>
>> Matt (Rosato on cc) probably can. In the end, it would mean having
>>    <memoryBacking>
>>      <source type="file"/>
>>    </memoryBacking>
> 
> This s390 code is the least of the problems, after this series VFIO
> won't startup at all with this configuration.

Good question if the domain would fail to start. I recall that IOMMUs 
for zPCI are special on s390x. [1]

Well, zPCI is special. I cannot immediately tell when we would trigger 
long-term pinning.

[1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg875728.html

-- 
Thanks,

David / dhildenb

