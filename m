Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861E239C9BF
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 18:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhFEQIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 12:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFEQIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 12:08:36 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFB0C061766;
        Sat,  5 Jun 2021 09:06:37 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so12212382otl.3;
        Sat, 05 Jun 2021 09:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hsUvo0Z31jHzTyWdPjams5W26nQJVQkDf7AjZ09gvvE=;
        b=m9kPfzBycC3YKOIS3oTGC+mz9M6QD9nWpdY+FEYYsQQqupPC0rDpP2NxFTw/t4I+GQ
         Izga7S2Lgj2/pFSbCRYAx0DYbPAS88YcZhMb1L5T0QrPnj8Oxy06Vebsdvbl3jrt40Zx
         tUbfohpD7ZO1reTbhit9yiGi0PC8qm5sZ6LFDCJ4iOFFixmKCEGfxiARED2LEmzlpTDE
         io+IRZjwh6FMvvFwPQeMn4oy/EXc8Gv4teeLtkSVSSk2ao6mEvcqTeL5UhBFU7tKGJ08
         I2iRL1/TGLiY2CByVGEQoK1DhUReOWRRYwBpIGOhc6XUI0WzNt1afSOY+nzhX4m2w68u
         0izA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hsUvo0Z31jHzTyWdPjams5W26nQJVQkDf7AjZ09gvvE=;
        b=g4aRNRoygleR19zOQXv/YHI8NSG/G6+UT5qkWgScT3yWuYGyIahAEgQJWUnJn7lKz1
         RfGJO/Q/jVK0hPzxZuwl3LNePdAyXHk+zrDxEM7bHJSmiWSCPe/3/jZt1P9Go0RgymOX
         JTONBZBEWubG+z8bsdk8KJ4g0xTolX9pmpNsdPeRqB3Gf9UAPnWHqUX4r8Hq/VuI7IDq
         avl3t4q8QoNAnnVqKWusi21LhvrJFEbSd3C3GtUzAoNqpYrzqD5Nu1OYtRuyKSZXQjLV
         qCyA3xK7qkinc+7sbaHQH+jokSbwNpUzaWSvBNH17uwYlbe9WiybgWJv+kEa117N2ez4
         0M9g==
X-Gm-Message-State: AOAM532XmyqCfzK34UpjMMg+vUBfupJjDU6yJM0GHvyQWwxgDzlCP9DY
        uORKkxz5ZROnO9eZPM0sC6U=
X-Google-Smtp-Source: ABdhPJxbglEED8yHHBv9b4qHkZGzEGhMuNGEOQ5HAC6n9QkPLmPeHoddwQhhjIdxRMn2SRlpIzi9xw==
X-Received: by 2002:a9d:870:: with SMTP id 103mr1920466oty.44.1622909195740;
        Sat, 05 Jun 2021 09:06:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id q26sm1200218otn.0.2021.06.05.09.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jun 2021 09:06:35 -0700 (PDT)
Subject: Re: [PATCH net-next v6 3/5] page_pool: Allow drivers to hint on SKB
 recycling
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <722e5567-d8ee-228c-978e-9d5966257bb1@gmail.com>
Date:   Sat, 5 Jun 2021 10:06:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YLnnaRLMlnm+LKwX@iliass-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/21 2:42 AM, Ilias Apalodimas wrote:
> [...]
>>> +	/* Driver set this to memory recycling info. Reset it on recycle.
>>> +	 * This will *not* work for NIC using a split-page memory model.
>>> +	 * The page will be returned to the pool here regardless of the
>>> +	 * 'flipped' fragment being in use or not.
>>> +	 */
>>
>> I am not sure I understand how does the last part of comment related
>> to the code below, as there is no driver using split-page memory model
>> will reach here because those driver will not call skb_mark_for_recycle(),
>> right?
>>
> 
> Yes the comment is there to prohibit people (mlx5 only actually) to add the
> recycling bit on their driver.  Because if they do it will *probably* work
> but they might get random corrupted packets which will be hard to debug.
> 

What's the complexity for getting it to work with split page model?
Since 1500 is the default MTU, requiring a page per packet means a lot
of wasted memory.
