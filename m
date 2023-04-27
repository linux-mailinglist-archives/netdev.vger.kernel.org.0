Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C9E6F0476
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 12:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbjD0Ksu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 06:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjD0Kss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 06:48:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9F45263
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 03:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682592453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CN4GzFrEzUhAvKDGVknjzHxbBE0SJI9sNk2pKF0RC24=;
        b=U/yIiHiFWvtzpLZ6JUBeCGjUHiVJ3a/k3E3lN7TEWZ4YA3YpgJejsAUn0o1TALdL9+F2br
        V3ZeoB1Yo+i/HM7pfz9gy8iWHMOgkQE+cDsViQVqSnhLr+F/gKiS0dgUuJjGlQr4Xazw9+
        /Xwj15lVoVYMg/vVR8pfUcJ0VuQUaQo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-buknVa6MNAOk4lYMgZhAGQ-1; Thu, 27 Apr 2023 06:47:32 -0400
X-MC-Unique: buknVa6MNAOk4lYMgZhAGQ-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-506a597d3c3so9905816a12.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 03:47:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682592451; x=1685184451;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CN4GzFrEzUhAvKDGVknjzHxbBE0SJI9sNk2pKF0RC24=;
        b=AR0CZJwNUPScQ20o8O5OQVQwFCn47QG8NosqhhM9SYd6/6wPPYu7hyLk4sSr8MKdDK
         R7JrifdxPa5wtsF8IYSszzQq7Mk6+VSueHGYR0sM+92Ivc1Y3JLEF76PqdrZ+56XnadN
         +cQ+vtt61GY4csZPx+ai+eVPDXYV3aAvsA6LHN+SjUAxkqG6cu5JIvJY77bE9MD6idYC
         rgfP7aPpGW5AiGMKby6U56YER99WXq930Tv20hCwS7ZQh85dc0ZGrG0kl/JA9FQ13EIU
         bvCPsQ9+bSVyaSKzp04fwHv4wOxNVr1+Q9G8YaATCvfh4Tj5PD6FkBGkI1R/u0WLzivf
         q+fQ==
X-Gm-Message-State: AC+VfDwaQaAWt/917s2pwy7XdE6n/3+NuMeAliQc8FypUkjV8wIKJhS6
        RNfGUBkqPY0qVT1J7knw5s22XhvzJtBkJiRTSfh+nslp8YWOcg22BCzEL3pluaYYwRp8WNKYLHg
        b/ZKn1Ez9f53Y3VsR
X-Received: by 2002:a17:906:58c3:b0:95f:bbb0:6d2d with SMTP id e3-20020a17090658c300b0095fbbb06d2dmr1530985ejs.63.1682592451114;
        Thu, 27 Apr 2023 03:47:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7RzAsvWcEWh4jrQ03LV133GzxBlh06v8I/TxapHgut9EY0o+iO2PLcuimRa13SoVIrTImaMg==
X-Received: by 2002:a17:906:58c3:b0:95f:bbb0:6d2d with SMTP id e3-20020a17090658c300b0095fbbb06d2dmr1530950ejs.63.1682592450699;
        Thu, 27 Apr 2023 03:47:30 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id ku15-20020a170907788f00b009571293d6acsm8373416ejc.59.2023.04.27.03.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 03:47:30 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e0bbcd20-77ec-4dc9-ada9-94aaf4ea44bb@redhat.com>
Date:   Thu, 27 Apr 2023 12:47:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Cc:     brouer@redhat.com, lorenzo@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org
Subject: Re: [PATCH RFC net-next/mm V1 1/3] page_pool: Remove workqueue in new
 shutdown scheme
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>
References: <168244288038.1741095.1092368365531131826.stgit@firesoul>
 <168244293875.1741095.10502498932946558516.stgit@firesoul>
 <48661b51-1cbb-e3e0-a909-6d0a1532733a@huawei.com>
In-Reply-To: <48661b51-1cbb-e3e0-a909-6d0a1532733a@huawei.com>
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



On 27/04/2023 02.57, Yunsheng Lin wrote:
> On 2023/4/26 1:15, Jesper Dangaard Brouer wrote:
>> @@ -609,6 +609,8 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
>>   		recycle_stat_inc(pool, ring_full);
>>   		page_pool_return_page(pool, page);
>>   	}
>> +	if (pool->p.flags & PP_FLAG_SHUTDOWN)
>> +		page_pool_shutdown_attempt(pool);
> 
> It seems we have allowed page_pool_shutdown_attempt() to be called
> concurrently here, isn't there a time window between atomic_inc_return_relaxed()
> and page_pool_inflight() for pool->pages_state_release_cnt, which may cause
> double calling of page_pool_free()?
> 

Yes, I think that is correct.
I actually woke up this morning thinking of this case of double freeing,
and this time window.  Thanks for spotting and confirming this issue.

Basically: Two concurrent CPUs executing page_pool_shutdown_attempt() 
can both end-up seeing inflight equal zero, resulting in both of them 
kfreeing the memory (in page_pool_free()) as they both think they are 
the last user of PP instance.

I've been thinking how to address this.
This is my current idea:

(1) Atomic variable inc and test (or cmpxchg) that resolves last user race.
(2) Defer free to call_rcu callback to let other CPUs finish.
(3) Might need rcu_read_lock() in page_pool_shutdown_attempt().

--Jesper

