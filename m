Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B61A39CF66
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 15:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhFFN6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 09:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbhFFN6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 09:58:47 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C015C061766;
        Sun,  6 Jun 2021 06:56:42 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id og14so16763926ejc.5;
        Sun, 06 Jun 2021 06:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B0rXVH93m1esrgniY56F67/MKQHZRua4qaFSgZhso5A=;
        b=ZYJHPypwgqvPHEKh1lmmeAFviUz4jHRgvSd46LPFYJXXYtCax3Qq2jUvKxk6r/bDUb
         E1WP+81lV0p6dZ5ka+qUqhx/jbHC7Juk8TQzrh8POdjA5iq5dd8tES+luGdWE3WumfIP
         DLLYlOzaHOGPFU4OHA8KGwLth77X9IRSe6rf+LnHjas313S4YWSGj5cVwPk2UvgEPjWQ
         1lcF9LMUxV7Sb0Y2dIyWi89JiEReP6GIp0rJqapAWqLMB/T9oAk3qVVafZYhO6CeWAC5
         l4X0jwNeOupuMdCKjMaM7DeSnVSRClLivIszgZsr/bV2DedL+IPpg2UpkQRJKzXIKIbX
         CAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B0rXVH93m1esrgniY56F67/MKQHZRua4qaFSgZhso5A=;
        b=C8wdUmMRjSiFLpSDYQWRL0r7qE4Si1OvaZU6KI2y+rR+pxg2WAP6Vv9rkpqApOMh/V
         VWoqEWt78rkZ47j3cm6ByNFzjpoLgE5p9SBnWdrFHMCwYa/eWg5dFUaGYHok7oSRowM7
         S2+z7HF4iPG8MgtI3UVL+fjIX/A8BLRNkcgwZn3KZHwzUKPxmfPSVF2EFu6eJ/aguJKo
         m6FeFR8vWEGFAw2v4squd0Kh0m6rsw+y9dp0JqgQ4oCrUJnGQoGpFqX4AabOlIa9wfYA
         H6i78EMroERZ2ACLYMm7OvYPytwjA88RT3uB32OKnHNS1MThkvI0q6GT3bEnb69kUbwb
         N1Dg==
X-Gm-Message-State: AOAM531m/yGCe4gX4hgmPgB1sYWI465JU0aUSm6fd9mZnPveDBer9oJn
        yh/NDOmJzkmbW7EXIa5XJok=
X-Google-Smtp-Source: ABdhPJzpzEG2M15A2d5WKbqVxjoSicjIl9ze9LY5kLBANp+FhBMFBy7rvOLF91TPoLFOTASzqqAJsA==
X-Received: by 2002:a17:906:2bd3:: with SMTP id n19mr13710286ejg.210.1622987800696;
        Sun, 06 Jun 2021 06:56:40 -0700 (PDT)
Received: from [192.168.0.108] ([77.124.85.114])
        by smtp.gmail.com with ESMTPSA id n13sm2269048edx.30.2021.06.06.06.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 06:56:40 -0700 (PDT)
Subject: Re: [PATCH net-next v6 3/5] page_pool: Allow drivers to hint on SKB
 recycling
To:     Matteo Croce <mcroce@linux.microsoft.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Yunsheng Lin <linyunsheng@huawei.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
References: <20210521161527.34607-1-mcroce@linux.microsoft.com>
 <20210521161527.34607-4-mcroce@linux.microsoft.com>
 <badedf51-ce74-061d-732c-61d0678180b3@huawei.com>
 <YLnnaRLMlnm+LKwX@iliass-mbp>
 <722e5567-d8ee-228c-978e-9d5966257bb1@gmail.com>
 <CAFnufp3rWwFgknBUBy9mHB36zpTKRiTeUAFeJXKVvp2DzvG3bw@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <63a4ea45-9938-3106-9eda-0f7e8fe079ce@gmail.com>
Date:   Sun, 6 Jun 2021 16:56:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAFnufp3rWwFgknBUBy9mHB36zpTKRiTeUAFeJXKVvp2DzvG3bw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/2021 7:34 PM, Matteo Croce wrote:
> On Sat, Jun 5, 2021 at 6:06 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 6/4/21 2:42 AM, Ilias Apalodimas wrote:
>>> [...]
>>>>> +   /* Driver set this to memory recycling info. Reset it on recycle.
>>>>> +    * This will *not* work for NIC using a split-page memory model.
>>>>> +    * The page will be returned to the pool here regardless of the
>>>>> +    * 'flipped' fragment being in use or not.
>>>>> +    */
>>>>
>>>> I am not sure I understand how does the last part of comment related
>>>> to the code below, as there is no driver using split-page memory model
>>>> will reach here because those driver will not call skb_mark_for_recycle(),
>>>> right?
>>>>
>>>
>>> Yes the comment is there to prohibit people (mlx5 only actually) to add the
>>> recycling bit on their driver.  Because if they do it will *probably* work
>>> but they might get random corrupted packets which will be hard to debug.
>>>
>>
>> What's the complexity for getting it to work with split page model?
>> Since 1500 is the default MTU, requiring a page per packet means a lot
>> of wasted memory.
> 
> We could create a new memory model, e.g. MEM_TYPE_PAGE_SPLIT, and
> restore the behavior present in the previous versions of this serie,
> which is, save xdp_mem_info in struct page.
> As this could slightly impact the performances, this can be added in a
> future change when the drivers which are doing it want to use this
> recycling api.
> 

page-split model doesn't only help reduce memory waste, but increase 
cache-locality, especially for aggregated GRO SKBs.

I'm looking forward to integrating the page-pool SKB recycling API into 
mlx5e datapath. For this we need it to support the page-split model.

Let's see what's missing and how we can help making this happen.

Regards,
Tariq
