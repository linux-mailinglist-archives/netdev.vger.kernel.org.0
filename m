Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D108562D38
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiGAH5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235810AbiGAH5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:57:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 374746EE97
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 00:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656662220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fIrKXBVyZdoDvQRp8apiHHZa1MCXdxr3bOtHIpyaBs4=;
        b=ExnejWWeTWV2H7KO9LKHxRxBHrotI0nuYnpQcTW0YfOzKgWVmELTpN55emYNL5ERiwqJ4p
        bRId6tO9IoRG0FiT64hmwlugGSQyBwVMDDkvc4vMrRCmf2U1K0H5bYDJ6VHiabnivD8cJy
        8eJJy9LZVm74Ai73Tchf8ZylkjMDoi0=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-DHoJU_9lOpODNwQnCg4Qqg-1; Fri, 01 Jul 2022 03:56:59 -0400
X-MC-Unique: DHoJU_9lOpODNwQnCg4Qqg-1
Received: by mail-lj1-f197.google.com with SMTP id b40-20020a2ebc28000000b0025c047ea79dso198773ljf.23
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 00:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=fIrKXBVyZdoDvQRp8apiHHZa1MCXdxr3bOtHIpyaBs4=;
        b=Up1hbDJRQ3CCpfb8SC3pz2bcHytTSHF+bZMf9d9QsjmyGlxV4nJ0GbGGYvmNj8b6WO
         Y+FczMtsiZDy0hRJ9gLvQ8NNdbqDIM2AoXgND3r6juvTirYyfdipLYyv5WamE7RqgZix
         H3cLl+XKmv8GQ8Wk/hzfzL80MFjsD8nXg2s5pAuraaTcl8iDR9xdrQXzXAplOIzCsn0L
         Le6INshcErj8zP8kyNl2H41xWvO/vQBpR8tViP8np6O82saKxqSzrTCAQS/fI8G97L1o
         tdX54a0R3HfSjMPpRAM5hpcaE9jN+F+yfNAGaq+uVBk3LMdA+bS4xDn4XEeFTSW36nvZ
         h1xA==
X-Gm-Message-State: AJIora/5yirzTMT3j50oZrbcwigzSZGyiED8Pq0InkazdIhjbMiAVg6T
        qs5Xp42gO7gXMdSG6+YRyZFH9s1CdRvgxeVOIkD0dmSGdt/KziKUzLtwLpzQsForNsSP4Hmpro9
        6iPuM4tISc2Fek+jM
X-Received: by 2002:a2e:8787:0:b0:25b:efd1:2064 with SMTP id n7-20020a2e8787000000b0025befd12064mr6527173lji.369.1656662218019;
        Fri, 01 Jul 2022 00:56:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vJT4/sVGIa3RjZL7cGY2WKjApKKjg8AkzsZnAqMr1q7eNiOijDvdHMIC1bGPpnOayRioNyrA==
X-Received: by 2002:a2e:8787:0:b0:25b:efd1:2064 with SMTP id n7-20020a2e8787000000b0025befd12064mr6527159lji.369.1656662217812;
        Fri, 01 Jul 2022 00:56:57 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id v10-20020a2e924a000000b0025bc62c1cafsm1959760ljg.44.2022.07.01.00.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 00:56:57 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <728b4c15-8114-e253-5d45-a5610882f891@redhat.com>
Date:   Fri, 1 Jul 2022 09:56:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com, jbrouer@redhat.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, lorenzo@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, lipeng321@huawei.com, chenhao288@hisilicon.com
Subject: Re: [PATCH net-next v2] net: page_pool: optimize page pool page
 allocation in NUMA scenario
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <20220629133305.15012-1-huangguangbin2@huawei.com>
 <20220630211534.6d1c32da@kernel.org>
In-Reply-To: <20220630211534.6d1c32da@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01/07/2022 06.15, Jakub Kicinski wrote:
> On Wed, 29 Jun 2022 21:33:05 +0800 Guangbin Huang wrote:
>> +#ifdef CONFIG_NUMA
>> +	pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() : pool->p.nid;
>> +#else
>> +	/* Ignore pool->p.nid setting if !CONFIG_NUMA */
>> +	pref_nid = NUMA_NO_NODE;
>> +#endif
> 
> Please factor this out to a helper, this is a copy of the code from
> page_pool_refill_alloc_cache() and #ifdefs are a little yuck.
> 

I would say simply use 'pool->p.nid' in the call to
alloc_pages_bulk_array_node() and drop this optimization (that was
copy-pasted from fast-path).

The optimization avoids one reading from memory compile time depending
on CONFIG_NUMA.  It is *not* worth doing in this code path which is even
named "slow" (__page_pool_alloc_pages_slow).

--Jesper

