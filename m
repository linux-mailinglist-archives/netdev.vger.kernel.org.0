Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ADC6F46CB
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbjEBPKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbjEBPKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:10:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C0F1BDC
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 08:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683040153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bRYNJVFhwseCiL0jjUQStKX5TCOrfxvVONgPXFtg6uM=;
        b=h9UTPArUOjj4wy24ooornwKrelIyLQzD1sh/jOv5yTDKFiyiyvke1RQ/fSLflKFyNBEmGC
        wRnbavjFY4PriPlFg1Jt5lNOqwavQa/jbNumE00PUJwxlWovqcXuXF+Mdl5J2OnexJ5mAw
        G8Rd+sDlUWGrnAlA0F3qqIHHTKU4dZs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-WGOQiGWoOxmwrbwgTpKP8g-1; Tue, 02 May 2023 11:09:10 -0400
X-MC-Unique: WGOQiGWoOxmwrbwgTpKP8g-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f250e9e090so12430255e9.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 08:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683040149; x=1685632149;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bRYNJVFhwseCiL0jjUQStKX5TCOrfxvVONgPXFtg6uM=;
        b=Geh1ImYYbAXHx6tVD1jh0xjV1m1Il2a37bErGaENH+fPgtWVjaPNwqlWmcUJBvGONX
         DDQQNouIZ04eetcdE2KY0D9po+ZYiRKo+hs2FCX6H1SSEc1YGTnBcfwPJMtNdwMQ7IZI
         8CE0l/eHW8pAkUan+jSa49NJS0wYB5HPD51Tl5TUeLTe8lQ1p470oTmlYn3hKy+HcwCx
         mEk3wrJDVocHmZ1pTsW9kkx+E6WgIKC2iL5FodtyKbujGVyvlcXyPvLKac5D+wIz1LFS
         w6QFuleZHzjr+Rc3wdu5ymY+sqqdg5ksGWmOVA3KmZ+4JtLu/g1crlN961TQaoP+kjJd
         K/gw==
X-Gm-Message-State: AC+VfDxW7sLFDreqYesYc6T52GPA82548q1717wQ6TRW2oIWyJ8iy3mI
        aypVCuF1k/PGY0tb2lj8PhoxIkTM8zKrrYccSCIvYTy/P6iB2BQQqrfHr3MtmnxL2JNtcYFPegX
        zqdKOW1jOsgg+GAPS
X-Received: by 2002:a1c:7710:0:b0:3f1:6527:df05 with SMTP id t16-20020a1c7710000000b003f16527df05mr13078876wmi.22.1683040149567;
        Tue, 02 May 2023 08:09:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6fWNjXb+x1RTqs+C4cbBtsb27FdAaquHZ29RbX4irITUmwGCH1YeZ2ULrHO1qwL0l1qzelew==
X-Received: by 2002:a1c:7710:0:b0:3f1:6527:df05 with SMTP id t16-20020a1c7710000000b003f16527df05mr13078837wmi.22.1683040149211;
        Tue, 02 May 2023 08:09:09 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id d23-20020a1c7317000000b003f325f0e020sm13416157wmb.47.2023.05.02.08.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 08:09:08 -0700 (PDT)
Message-ID: <1f3231c0-34b2-1e78-0bf0-f32d5b67811d@redhat.com>
Date:   Tue, 2 May 2023 17:09:06 +0200
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
 <1d4c9258-9423-7411-e722-8f6865b18886@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <1d4c9258-9423-7411-e722-8f6865b18886@linux.ibm.com>
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

On 02.05.23 15:56, Matthew Rosato wrote:
> On 5/2/23 9:50 AM, Jason Gunthorpe wrote:
>> On Tue, May 02, 2023 at 03:47:43PM +0200, David Hildenbrand wrote:
>>>> Eventually we want to implement a mechanism where we can dynamically pin in response to RPCIT.
>>>
>>> Okay, so IIRC we'll fail starting the domain early, that's good. And if we
>>> pin all guest memory (instead of small pieces dynamically), there is little
>>> existing use for file-backed RAM in such zPCI configurations (because memory
>>> cannot be reclaimed either way if it's all pinned), so likely there are no
>>> real existing users.
>>
>> Right, this is VFIO, the physical HW can't tolerate not having pinned
>> memory, so something somewhere is always pinning it.
> 
> I might have mis-explained above.
> 
> With iommufd nesting, we will pin everything upfront as a starting point.
> 
> The current usage of vfio type1 iommu for s390 does not pin the entirety of guest memory upfront, it happens as guest RPCITs occur / type1 mappings are made.

... so, after the domain started successfully on the libvirt/QEMU side ? :/

It would be great to confirm that. There might be a BUG in patch #2 (see 
my reply to patch #2) that might not allow you to reproduce it right now.

-- 
Thanks,

David / dhildenb

