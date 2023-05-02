Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0BA6F4419
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbjEBMsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbjEBMsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:48:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6DF1AE
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 05:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683031648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=noovJtisV3i3/mJ6ypDDQD/CpIY5Kq1JwfcpAQCR0K0=;
        b=f24/9+EW8TfpivyXYHYw7+4FosRT3YVIdb1qL7PeBu9fvxfB/gvFsuMeb/Ppyd6SL6heGi
        nCIki0zH6IT9aVQmbPGuS3Awvnx3hF5dqXpl7EA+oX+EFJARK8YYSoIR9vzEAuY9Lb0cXG
        xyzEUGaPcdAvqNOtIQT4SC1Hi54QoRk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-r1oUUmnZPb2tTX1xBSZSlA-1; Tue, 02 May 2023 08:47:27 -0400
X-MC-Unique: r1oUUmnZPb2tTX1xBSZSlA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f195129aa4so22946745e9.2
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 05:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683031646; x=1685623646;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=noovJtisV3i3/mJ6ypDDQD/CpIY5Kq1JwfcpAQCR0K0=;
        b=ENb5daw1d/fG0arEpomNAShVWdkdvKMroDCjfG7ERaC/DZRySI5g4sQEZxxyIVd59A
         8bF+NrgSiekmGxRBUlVj9Sja6J3vsPuvUkfbsJLxy8qYtxQAJ7Jrps2IuyadFjibrkXN
         Pbzo/xNoaVx6foPQuUFBMQOzEXX/EatDzfuXgVkhRa6/ac+QDLiI9OMtjYG2RGq9f6SB
         4W/yePzepSzj8b/hjGKrf+Gl0E+2VhJBQNNUCGkJdkzrXCO2Mq+odTDD6KJNhvIpaG+F
         tzfpGuYublCmxYVoBEEojIRl74AtgLTnbVRCIeKQw1xXOwKoqqDVPN7jLMPSZm3ZiRO9
         hqrw==
X-Gm-Message-State: AC+VfDxSd7lfKTSBCSHN6pvmzSiQE+QHENRuoZ4L/k3vP3tNZlOoz9um
        eyD7jvq+cnlLxpglKOkwSwmTl+gmw/aVjJMZXvdKRi/kKxoWjjAAo31KCkr2tIcEp/pYo2oAVC9
        7GqvvY1Q9nGIMjs4C
X-Received: by 2002:a05:600c:2248:b0:3f1:6fb4:44cf with SMTP id a8-20020a05600c224800b003f16fb444cfmr12040770wmm.28.1683031645997;
        Tue, 02 May 2023 05:47:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ78NzuiYve0rFZCzvbVf8NBNHLrbCADw3oH0ofO5ShJ4Vs4xjCq1x1GvDm/UPbam9KHLtRM0w==
X-Received: by 2002:a05:600c:2248:b0:3f1:6fb4:44cf with SMTP id a8-20020a05600c224800b003f16fb444cfmr12040725wmm.28.1683031645619;
        Tue, 02 May 2023 05:47:25 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id e14-20020adfef0e000000b003063938bf7bsm1389765wro.86.2023.05.02.05.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 05:47:25 -0700 (PDT)
Message-ID: <a597947b-6aba-bd8d-7a97-582fa7f88ad2@redhat.com>
Date:   Tue, 2 May 2023 14:47:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
        Paul McKenney <paulmck@kernel.org>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <20230502111334.GP1597476@hirez.programming.kicks-ass.net>
 <ab66d15a-acd0-4d9b-aa12-49cddd12c6a5@lucifer.local>
 <20230502120810.GD1597538@hirez.programming.kicks-ass.net>
 <20230502124058.GB1597602@hirez.programming.kicks-ass.net>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230502124058.GB1597602@hirez.programming.kicks-ass.net>
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

On 02.05.23 14:40, Peter Zijlstra wrote:
> On Tue, May 02, 2023 at 02:08:10PM +0200, Peter Zijlstra wrote:
> 
>>>>
>>>>
>>>> 	if (folio_test_anon(folio))
>>>> 		return true;
>>>
>>> This relies on the mapping so belongs below the lockdep assert imo.
>>
>> Oh, right you are.
>>
>>>>
>>>> 	/*
>>>> 	 * Having IRQs disabled (as per GUP-fast) also inhibits RCU
>>>> 	 * grace periods from making progress, IOW. they imply
>>>> 	 * rcu_read_lock().
>>>> 	 */
>>>> 	lockdep_assert_irqs_disabled();
>>>>
>>>> 	/*
>>>> 	 * Inodes and thus address_space are RCU freed and thus safe to
>>>> 	 * access at this point.
>>>> 	 */
>>>> 	mapping = folio_mapping(folio);
>>>> 	if (mapping && shmem_mapping(mapping))
>>>> 		return true;
>>>>
>>>> 	return false;
>>>>
>>>>> +}
> 
> So arguably you should do *one* READ_ONCE() load of mapping and
> consistently use that, this means open-coding both folio_test_anon() and
> folio_mapping().

Open-coding folio_test_anon() should not be required. We only care about 
PAGE_MAPPING_FLAGS stored alongside folio->mapping, that will stick 
around until the anon page was freed.

@Lorenzo, you might also want to special-case hugetlb directly using 
folio_test_hugetlb().

-- 
Thanks,

David / dhildenb

