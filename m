Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963036E1EB5
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 10:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjDNIrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 04:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjDNIrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 04:47:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A627869A
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681461949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jtKule5cCcyqyPq2pv9TaY6xpy2YCEMXl+IOjFFdODU=;
        b=T7AC/MwB/Z9CExpj26ZomyN6QWA6uImxVAVexdDibPM7Dby26FcoPRx9dSlTz3bFzvaqKM
        lFiaJqo7hRG2Q/itd6PBtSA2oxxqXhyqxDDegEjzqu8VEcfgWf9tUN58jpB/hBKovf/d/l
        n8g32udSUH8YvcmZ53cdA+eUyf77ZDg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-bYEYEil8NvejpkdaMFiUbA-1; Fri, 14 Apr 2023 04:45:47 -0400
X-MC-Unique: bYEYEil8NvejpkdaMFiUbA-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5066c9c2ed6so947108a12.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681461946; x=1684053946;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jtKule5cCcyqyPq2pv9TaY6xpy2YCEMXl+IOjFFdODU=;
        b=W+KUbHBY/2soL4SVWRP9zWD80ZgluB9otyYw4ryAA1wHGTQVjYug3Xn/+bLeJNWi5+
         zT3egm6T+dsB7N4lbhdFwep5NjWXV1Q/qNSRb4U7n0MyDtJ5fMcYUjPzE9GiemTWc+/k
         RB6IZ9vws444ZplzlOLgnk9iZonMfnG3KY48Vkfgvy2u6cd3vx5amA/qLVxf9oAl4nlD
         TTl+X2TTfsWADorm4k9olHGvaEjexxa54Scb2fg/tusozw3Zo2BkxhKr7xN/S4N8gTgD
         a7NE0MyEpg/Sw3UhHA8ZaM/uphRcVbHwbiZtUpo2ramaZUUFtyr4NzcqvxXlAlJahn/m
         ibpw==
X-Gm-Message-State: AAQBX9fw43Kz674JKTOVBfTJ85YIs0kSWhiKE6Lo11jPCexATQuhji6X
        9NxzSv/QhRmT9/D0paTF6CAaZxxvBvAAyPxpZ0X6gc2IQJaMEUmpdH0b15aLr4m3YHudXimlRHP
        7eFJhBREq6hdEs10t
X-Received: by 2002:aa7:dc18:0:b0:4fd:1ff0:2291 with SMTP id b24-20020aa7dc18000000b004fd1ff02291mr5236858edu.18.1681461946691;
        Fri, 14 Apr 2023 01:45:46 -0700 (PDT)
X-Google-Smtp-Source: AKy350aIvDB7PvGIjVpj4pi/OMiHuf3399+K7HWUEjL05e0x20Qk3xE7By8QzqInujlO1rabIPxBgQ==
X-Received: by 2002:aa7:dc18:0:b0:4fd:1ff0:2291 with SMTP id b24-20020aa7dc18000000b004fd1ff02291mr5236848edu.18.1681461946354;
        Fri, 14 Apr 2023 01:45:46 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id hs13-20020a1709073e8d00b0094ece70481csm1121806ejc.197.2023.04.14.01.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 01:45:45 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <dad5f7fc-dfa8-3aa9-ec4f-9e220e6f400f@redhat.com>
Date:   Fri, 14 Apr 2023 10:45:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, alexander.duyck@gmail.com,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next v2 2/3] page_pool: allow caching from safely
 localized NAPI
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
References: <20230413042605.895677-1-kuba@kernel.org>
 <20230413042605.895677-3-kuba@kernel.org>
In-Reply-To: <20230413042605.895677-3-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13/04/2023 06.26, Jakub Kicinski wrote:
> Recent patches to mlx5 mentioned a regression when moving from
> driver local page pool to only using the generic page pool code.
> Page pool has two recycling paths (1) direct one, which runs in
> safe NAPI context (basically consumer context, so producing
> can be lockless); and (2) via a ptr_ring, which takes a spin
> lock because the freeing can happen from any CPU; producer
> and consumer may run concurrently.
> 
> Since the page pool code was added, Eric introduced a revised version
> of deferred skb freeing. TCP skbs are now usually returned to the CPU
> which allocated them, and freed in softirq context. This places the
> freeing (producing of pages back to the pool) enticingly close to
> the allocation (consumer).
> 
> If we can prove that we're freeing in the same softirq context in which
> the consumer NAPI will run - lockless use of the cache is perfectly fine,
> no need for the lock.
> 
> Let drivers link the page pool to a NAPI instance. If the NAPI instance
> is scheduled on the same CPU on which we're freeing - place the pages
> in the direct cache.
> 
> With that and patched bnxt (XDP enabled to engage the page pool, sigh,
> bnxt really needs page pool work :() I see a 2.6% perf boost with
> a TCP stream test (app on a different physical core than softirq).
> 
> The CPU use of relevant functions decreases as expected:
> 
>    page_pool_refill_alloc_cache   1.17% -> 0%
>    _raw_spin_lock                 2.41% -> 0.98%
> 
> Only consider lockless path to be safe when NAPI is scheduled
> - in practice this should cover majority if not all of steady state
> workloads. It's usually the NAPI kicking in that causes the skb flush.
> 
> The main case we'll miss out on is when application runs on the same
> CPU as NAPI. In that case we don't use the deferred skb free path.
> 
> Reviewed-by: Tariq Toukan<tariqt@nvidia.com>
> Signed-off-by: Jakub Kicinski<kuba@kernel.org>
> ---
> v1:
>   - s/in_napi/napi_safe/
> rfc v2:https://lore.kernel.org/all/20230405232100.103392-1-kuba@kernel.org/
>   - plumb thru "are we in NAPI" bool rather than guessing based
>     on softirq && !hardirq
> 
> CC:hawk@kernel.org
> CC:ilias.apalodimas@linaro.org
> ---
>   Documentation/networking/page_pool.rst |  1 +
>   include/linux/netdevice.h              |  3 +++
>   include/linux/skbuff.h                 | 20 +++++++++++++-------
>   include/net/page_pool.h                |  3 ++-
>   net/core/dev.c                         |  3 +++
>   net/core/page_pool.c                   | 15 +++++++++++++--
>   net/core/skbuff.c                      |  4 ++--
>   7 files changed, 37 insertions(+), 12 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

BTW, does it matter if I ack with <hawk@kernel.org> or <brouer@redhat.com> ?

e.g. does the patchwork automation scripts, need to maintainer email to 
match?

--Jesper

