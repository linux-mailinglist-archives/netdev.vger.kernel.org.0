Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737C66F4450
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbjEBMyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbjEBMyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:54:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749A5526B
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 05:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683032005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X2TPQPGBRapYWkLRNRk6kGJOLk5A8AsKc2WUiv6CjPA=;
        b=ElRw7vqWGmeaDmBIJm+L5gnzuh+lFwUUFqA1MRclkMZ6vfZ58jY9vPLmmUOa5onl8nq7qu
        V+d9fQOXk9A5p/rvZ6fEORBJr8jSe729f40YtyJ3IQRnGl9jwkPHcosHKZ01I6nPX34frh
        dhN/cquyIPpS3G5KEr9D+z25p6gsr30=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-vWStyCb1PHiB1dMgwbGYxQ-1; Tue, 02 May 2023 08:53:24 -0400
X-MC-Unique: vWStyCb1PHiB1dMgwbGYxQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3062e5d0cd3so743122f8f.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 05:53:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683032003; x=1685624003;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X2TPQPGBRapYWkLRNRk6kGJOLk5A8AsKc2WUiv6CjPA=;
        b=MZ+VW95f4XY0HviW2iSOKWt+gee3RU6PAmhlzI1Xy/pNV5bAELouMQB3noYfXS9iOL
         zeH2zdkCeEoHlDhVWBWWZw+OkZhQ0bSXgI7dYQSTfuqqSoiBLYYAS9Dh69Z+Z66FS5AR
         ILK+CLmTvN8SNrgC/x4mztBMMFFkb/FEFH26Ojcidvl8useIIDyEeoyX7LfA5e6NDJXd
         MZ6fAtWjol4eFUBoiLKXrzx8buUEpzWIH3xC00ZWQue615qAcxwV2F9UxFfaUOwnEnK4
         IjoijCaNtzvZnsj1dh18VbjWyTSYGFko3J7bwjkdystrc+DzncHnVXtKWMH1vrTyBxSj
         2alw==
X-Gm-Message-State: AC+VfDyEd4Zvoo/rIGBt6ZvyXeKm6gY37Yx1YkRjZAaFFT+SwHh/Rg0u
        5S5M8A2/k88UvxnHG1Md4W2TOOM+KzWis3CzlORq8NKGXZRGvXUJMrNWm3NUUfORcUFWGnEufJs
        QwOFVmdHcIeKDByiZ
X-Received: by 2002:adf:ef52:0:b0:306:b48:3fc4 with SMTP id c18-20020adfef52000000b003060b483fc4mr8043860wrp.31.1683032003218;
        Tue, 02 May 2023 05:53:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Cfsg1j/co21vSt2yZ/61REwJ8d2UCVlkvTI/GFET2pOmQ2nrdxza2I7BtE39yTpyDuURYEA==
X-Received: by 2002:adf:ef52:0:b0:306:b48:3fc4 with SMTP id c18-20020adfef52000000b003060b483fc4mr8043814wrp.31.1683032002215;
        Tue, 02 May 2023 05:53:22 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id u12-20020adfdd4c000000b0030635735a57sm2320577wrm.60.2023.05.02.05.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 05:53:21 -0700 (PDT)
Message-ID: <482f0c6e-ca5f-d0c2-1d99-ca26f70565df@redhat.com>
Date:   Tue, 2 May 2023 14:53:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
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
        Paul McKenney <paulmck@kernel.org>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <20230502111334.GP1597476@hirez.programming.kicks-ass.net>
 <ab66d15a-acd0-4d9b-aa12-49cddd12c6a5@lucifer.local>
 <20230502120810.GD1597538@hirez.programming.kicks-ass.net>
 <20230502124058.GB1597602@hirez.programming.kicks-ass.net>
 <a597947b-6aba-bd8d-7a97-582fa7f88ad2@redhat.com>
 <4529b057-19ae-408b-8433-7d220f1871c0@lucifer.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <4529b057-19ae-408b-8433-7d220f1871c0@lucifer.local>
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

On 02.05.23 14:52, Lorenzo Stoakes wrote:
> On Tue, May 02, 2023 at 02:47:22PM +0200, David Hildenbrand wrote:
>> On 02.05.23 14:40, Peter Zijlstra wrote:
>>> On Tue, May 02, 2023 at 02:08:10PM +0200, Peter Zijlstra wrote:
>>>
>>>>>>
>>>>>>
>>>>>> 	if (folio_test_anon(folio))
>>>>>> 		return true;
>>>>>
>>>>> This relies on the mapping so belongs below the lockdep assert imo.
>>>>
>>>> Oh, right you are.
>>>>
>>>>>>
>>>>>> 	/*
>>>>>> 	 * Having IRQs disabled (as per GUP-fast) also inhibits RCU
>>>>>> 	 * grace periods from making progress, IOW. they imply
>>>>>> 	 * rcu_read_lock().
>>>>>> 	 */
>>>>>> 	lockdep_assert_irqs_disabled();
>>>>>>
>>>>>> 	/*
>>>>>> 	 * Inodes and thus address_space are RCU freed and thus safe to
>>>>>> 	 * access at this point.
>>>>>> 	 */
>>>>>> 	mapping = folio_mapping(folio);
>>>>>> 	if (mapping && shmem_mapping(mapping))
>>>>>> 		return true;
>>>>>>
>>>>>> 	return false;
>>>>>>
>>>>>>> +}
>>>
>>> So arguably you should do *one* READ_ONCE() load of mapping and
>>> consistently use that, this means open-coding both folio_test_anon() and
>>> folio_mapping().
>>
>> Open-coding folio_test_anon() should not be required. We only care about
>> PAGE_MAPPING_FLAGS stored alongside folio->mapping, that will stick around
>> until the anon page was freed.
>>
> 
> Ack, good point!
> 
>> @Lorenzo, you might also want to special-case hugetlb directly using
>> folio_test_hugetlb().
>>
> 
> I already am :) I guess you mean when I respin along these lines? Will port
> that across to.

Ha, I only stared at that reply, good! :)

-- 
Thanks,

David / dhildenb

