Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C0A644006
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiLFJoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiLFJoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:44:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BA61D325
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670319789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eGk91IPw6rbq/lI/vrTCbPQIiPbKWWsypyMlB5hlmTM=;
        b=W3fiXALKHBRfD1MyPEFJ6TLp3CAru5APKx0HHWb5ddRMLbg7wWI5q3v8TowQpBjZKvoaP9
        wm8lfNKNoEuS3XQ1hwr+rKWANTKpMxm6XR1sn/XfWHQKd6lEmD6n1GNaW5HZG8mNgWlhpG
        r1cyv3GuUwxWLVp+WntrgJZbNBEPL30=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-13-PV0X8m-DNdyBu56_Fs73cQ-1; Tue, 06 Dec 2022 04:43:08 -0500
X-MC-Unique: PV0X8m-DNdyBu56_Fs73cQ-1
Received: by mail-ed1-f70.google.com with SMTP id h8-20020a056402280800b0046af59e0986so7792693ede.22
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 01:43:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGk91IPw6rbq/lI/vrTCbPQIiPbKWWsypyMlB5hlmTM=;
        b=YZe6CD87JYeAoSiI+Hinf+RWYY9vI67K0mdzNE9kqOV4wTw5XZaQiUfKgwB9VoZkNy
         plPmmOhNGBxd4K6Gb9isM3lqpb4y2Lan1MXN4Wt/+xjt76qN9Q0qyTur1To8+nrM+eOt
         mUvAOhWbOILiFS8pBvqK62obN4Iq9mcawjemyqrdPfHTqlrKcdYh90hzqdRfdM0xp40o
         k7LPRcFozIgBddx9+8M0JVQpE+Px6eDbRYc1BlzfL3En4jw921nM6KZGEzDiXz4cpAQu
         4jEWLgSLs61MJPcKxGjB5eONPADzhKI0QaIXTVWS7XFogiMzQpnLbgl8tV3Wjq69KMmt
         FQIQ==
X-Gm-Message-State: ANoB5pk189dGvQEgIGcvz8kr4etnL0gl7Bek0gmztPbyq2VEhMP9CtWf
        vqr6Emb8SvAQ5P+E+7RDqSve7XTOvv9176YtEYOn4Zg1PXfFtQtsAHU++Ofwp5vzWg5fPCq4bMl
        HfabQfePP1wBU/r5B
X-Received: by 2002:a17:906:c250:b0:7c0:9bc2:a7f0 with SMTP id bl16-20020a170906c25000b007c09bc2a7f0mr23342988ejb.59.1670319787369;
        Tue, 06 Dec 2022 01:43:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5x6dYtNeE9lF9+PVXBxLxdQwb29ESPvaO0wDftxcCEfVz2CMlpyhLRkpA66Tnw8lus39qxVQ==
X-Received: by 2002:a17:906:c250:b0:7c0:9bc2:a7f0 with SMTP id bl16-20020a170906c25000b007c09bc2a7f0mr23342978ejb.59.1670319787127;
        Tue, 06 Dec 2022 01:43:07 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id u14-20020a056402110e00b0046af63521a2sm776580edv.29.2022.12.06.01.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:43:06 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <7cfbcde0-9d17-0a89-49ae-942a80c63feb@redhat.com>
Date:   Tue, 6 Dec 2022 10:43:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/24] Split page pools from struct page
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20221130220803.3657490-1-willy@infradead.org>
 <cfe0b2ca-824d-3a52-423a-f8262f12fabe@redhat.com>
 <Y44c1KKE797U3kCM@casper.infradead.org>
In-Reply-To: <Y44c1KKE797U3kCM@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/12/2022 17.31, Matthew Wilcox wrote:
> On Mon, Dec 05, 2022 at 04:34:10PM +0100, Jesper Dangaard Brouer wrote:
>> I have a micro-benchmark [1][2], that I want to run on this patchset.
>> Reducing the asm code 'text' size is less likely to improve a
>> microbenchmark. The 100Gbit mlx5 driver uses page_pool, so perhaps I can
>> run a packet benchmark that can show the (expected) performance improvement.
>>
>> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
>> [2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c
> 
> Appreciate it!  I'm not expecting any performance change outside noise,
> but things do surprise me.  I'd appreciate it if you'd test with a
> "distro" config, ie enabling CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
> we show the most expensive case.
> 

I have CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y BUT it isn't default
runtime enabled.

Should I also choose CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
or enable it via sysctl ?

  $ grep -H . /proc/sys/vm/hugetlb_optimize_vmemmap
  /proc/sys/vm/hugetlb_optimize_vmemmap:0

--Jesper

