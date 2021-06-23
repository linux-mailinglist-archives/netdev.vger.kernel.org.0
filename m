Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97B63B1FFF
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 20:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhFWSH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 14:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWSH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 14:07:26 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38381C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 11:05:09 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m3so2221399wms.4
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 11:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H7dKmu/zpADYcapjkH1ZgRam6f1VCzGPNlFuBmGpob8=;
        b=YBOeZPdP2jkdyuKImuGUpDhPTvc2kouwhGDqNE0toWZwEIG1MF+vB/stBNdxLkddzK
         72bwxscUvlvRzyNv/1lVXLBzBzJT58o39jihAQRB+CUBxXkdl5elYorIacauNc8vv9s8
         Pr7wB+3bjg8K8wgqX0fhWzB3xcpBa6lXY+E8PGL3U6GCKXYs75VA/FKYyFqPSiz6uKRy
         NiUTJqlrGwH2DeDCZeqDeXrLy9U7dGX2/2jUkkFsoYbvfj3FcwvRIz5a3cvgXSczqNK4
         LzX9PZVMrjJxcrkwRFVuyjwjMr23g4ixhUD4h7rdvx4gHIEJaoMv+xdy/us2cDtIiDxE
         eXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H7dKmu/zpADYcapjkH1ZgRam6f1VCzGPNlFuBmGpob8=;
        b=KKfP6QTfWgvGlncl3LoHNQdKvkN/82zq29URTgeOyl8ETPkttnm8qioIQGfXj3zaSY
         MbsLViLQU2iBLKW5z6cXurSKpETHavkoDzEzzOofF9aOzZGreqOPWugmoO4LytujWcHy
         Kx7wTLkgWreAWOxVBei49wgZ/gbqpHGTCgFIR6gyvXoCUFzKR6/+nWRM/M1cr/SYACxl
         uGSO0q5jsOOayHsILYxbv1RFZMvEgx1zvIfdL67yIS+9zlERcn9KqmbGwIgOPbkJ6eJK
         vFq0+ssF5IT7Bp9RONqQga68Je8guWqHeDaUyMd9bYzt2beB5mkWz3mat4+FDudwpCcS
         2QXQ==
X-Gm-Message-State: AOAM532po96Iwmb5pf2ZbovLo3WE+isuPSDXoShWwfh7sSPEoxG12jCr
        kffveCLEx1J9YEMGPsH7OgE=
X-Google-Smtp-Source: ABdhPJxYvotArPE5Y1848SwdMe2diYioo6B8NKbH8fXz8xQAt2JZM+/ukvytbv4PP6KwFPUhGPYitw==
X-Received: by 2002:a05:600c:224a:: with SMTP id a10mr1146995wmm.154.1624471507907;
        Wed, 23 Jun 2021 11:05:07 -0700 (PDT)
Received: from [192.168.98.98] (8.249.23.93.rev.sfr.net. [93.23.249.8])
        by smtp.gmail.com with ESMTPSA id t82sm653026wmf.22.2021.06.23.11.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 11:05:07 -0700 (PDT)
Subject: Re: [PATCH net-next v3] net: ip: avoid OOM kills with large UDP sends
 over loopback
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
References: <20210623162328.2197645-1-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d4de9fa3-3170-af6e-719a-4c809dca81b4@gmail.com>
Date:   Wed, 23 Jun 2021 20:05:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210623162328.2197645-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 6:23 PM, Jakub Kicinski wrote:
> Dave observed number of machines hitting OOM on the UDP send
> path. The workload seems to be sending large UDP packets over
> loopback. Since loopback has MTU of 64k kernel will try to
> allocate an skb with up to 64k of head space. This has a good
> chance of failing under memory pressure. What's worse if
> the message length is <32k the allocation may trigger an
> OOM killer.
> 
> This is entirely avoidable, we can use an skb with page frags.
> 
> af_unix solves a similar problem by limiting the head
> length to SKB_MAX_ALLOC. This seems like a good and simple
> approach. It means that UDP messages > 16kB will now
> use fragments if underlying device supports SG, if extra
> allocator pressure causes regressions in real workloads
> we can switch to trying the large allocation first and
> falling back.
> 
> Reported-by: Dave Jones <dsj@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

