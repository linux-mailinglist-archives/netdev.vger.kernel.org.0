Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47A86EF08C
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbjDZI6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239845AbjDZI63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:58:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A09140DE
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 01:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682499461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qRhtGeXRPBB+p4cr9w0INOAc893fzDgBw6gSZ9r4K6o=;
        b=a/75T1GFpRzl1Z+jnp1c8vfEAAmvoM6nz//Vqf/CpG6jniPqbdbcDSDTkQ0IsvxWHfH802
        TEvCS6h+58xDEelPQcT9K8IsRUwNsQBS3D3QFw/zEm6fzmqkb3agAHDE6TYvJs5VmLFyfO
        FSOIMZPHqjPXd/4sr1rc/lmzSOwRuAo=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-brAR0SV5MH2zQ3K2fs0ICw-1; Wed, 26 Apr 2023 04:57:40 -0400
X-MC-Unique: brAR0SV5MH2zQ3K2fs0ICw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2a892a9ef31so29039281fa.3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 01:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682499459; x=1685091459;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qRhtGeXRPBB+p4cr9w0INOAc893fzDgBw6gSZ9r4K6o=;
        b=TAn4fLvnVLcwmCpOrkiBDknIMxHfR36b+l7UhsDHcnrZqxmfp2nZHWton28EfvSKqY
         Odwc9mNLgGirvwdv7zUV1f6RJIrUZ9Fg4vciRUjsQ05bGJV+y14wkgliDwvIMZJw9TH/
         PEofNo3UMuI3GqyNOuU0iAoDvqN2c6CuTINBlSwsqvfU54btdmUuckr/HF5XEutQmLPg
         OGRrDTAK02caXqMJjTWs3XgcuW+UP5BRcFqT8+GSvJbl4P+IZ0KcXWpbwJgcovihTDk3
         DDjTruH/qaJaz0ku4K0/mBBcuVaJCSQXEhR2tNRpmJtQSyMToQfOkFczAHtErfIHFsHT
         zy0A==
X-Gm-Message-State: AAQBX9fFdOmGG/PPgpaJcaXA0WgRumZEhTHRhh2d3cxcpRbEVIM4s8mo
        5AvNyfaER2U3mUUrdaicGZDhNVczuMwQ0E1QRi1ImAhgduCqO2ow+8hM56R9lxbMTMru+US7FO3
        D2IrbQMSY0ZPZvek=
X-Received: by 2002:a2e:6a14:0:b0:29b:d2f1:de9b with SMTP id f20-20020a2e6a14000000b0029bd2f1de9bmr4142466ljc.47.1682499458889;
        Wed, 26 Apr 2023 01:57:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yx9BB81vQR6fLd3lXwJ35Cz4Jj1Udt07gGaFpg1cOTHMdrnGmkcWc2ganLveGb7dCQC1foHQ==
X-Received: by 2002:a2e:6a14:0:b0:29b:d2f1:de9b with SMTP id f20-20020a2e6a14000000b0029bd2f1de9bmr4142423ljc.47.1682499458568;
        Wed, 26 Apr 2023 01:57:38 -0700 (PDT)
Received: from [192.168.1.121] (85-23-48-202.bb.dnainternet.fi. [85.23.48.202])
        by smtp.gmail.com with ESMTPSA id y4-20020a2e9d44000000b002aa4713b925sm1793633ljj.21.2023.04.26.01.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 01:57:37 -0700 (PDT)
Message-ID: <3562046e-1625-8536-910c-111d38acc346@redhat.com>
Date:   Wed, 26 Apr 2023 11:57:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4] mm/gup: disallow GUP writing to file-backed mappings
 by default
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
        David Hildenbrand <david@redhat.com>
References: <3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com>
 <a68fa8f2-8619-63ff-3525-ede7ed1f0a9f@redhat.com>
 <5ffd7f32-d236-4da4-93f7-c2fe39a6e035@lucifer.local>
 <aa0d9a98-7dd1-0188-d382-5835cf1ddf3a@redhat.com>
 <b7f8daba-1250-4a45-895e-cbb20cc6c2dd@lucifer.local>
 <831f0d02-7671-97bf-a968-e2e5bf92dfd7@redhat.com> <ZEjjz_zqynWj0Kcc@murray>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mpenttil@redhat.com>
In-Reply-To: <ZEjjz_zqynWj0Kcc@murray>
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



On 26.4.2023 11.41, Lorenzo Stoakes wrote:
> On Wed, Apr 26, 2023 at 10:30:03AM +0300, Mika Penttilä wrote:
> 
> [snip]
> 
>>> The issue is how dirtying works. Typically for a dirty-tracking mapping the
>>> kernel makes the mapping read-only, then when a write fault occurs,
>>> writenotify is called and the folio is marked dirty. This way the file
>>> system knows which files to writeback, then after writeback it 'cleans'
>>> them, restoring the read-only mapping and relying on the NEXT write marking
>>> write notifying and marking the folio dirty again.
>>>
>>
>> I know how the dirty tracking works :). And gup itself actually triggers the
>> _first_ fault on a read only pte.
> 
> I'm sure you don't mean to, but this comes off as sarcastic, 'I know how X
> works :)' is not a helpful comment. However, equally apologies if I seemed
> patronising, not intentional, I am just trying to be as clear as possible,
> which always risks sounding that way :)

Absolutely didn't mean that way, and thanks for being clear here!
> 
> Regardless, this is a very good point! I think I was a little too implicit
> in the whole 'at any time the kernel chooses to write to this writenotify
> won't happen', and you are absolutely right in that we are not clear enough
> about that.
> 
>>
>> So the problem is accessing the page after that, somewehere in future. I
>> think this is something you should write on the description. Because,
>> technically, GUP itself works and does invoke the write notify. So the
>> misleading part is you say in the description it doesn't. While you mean a
>> later write, from a driver or such, doesn't.
>>
> 
> Ack, agreed this would be a useful improvement. Will fix on next spin!

Yes thanks, think so, at least found myself going thru and wondering 
what's wrong with the gup code itself, and not the later usage scenario...

> 
> [snip]
> 


--Mika

