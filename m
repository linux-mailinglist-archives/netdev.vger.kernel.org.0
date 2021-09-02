Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D6A3FE899
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 06:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhIBEtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 00:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhIBEta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 00:49:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B5FC061575;
        Wed,  1 Sep 2021 21:48:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so572027pjx.5;
        Wed, 01 Sep 2021 21:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RcBfOJG+plA9w2gh1ieESzMOZXJ0qVsChyqVj/Wv7Lc=;
        b=KxS/pt35ZJuE/8U6FwwbNUBm9nKLaAYOXbOcR0vwdU9gd1IpFnJmhbHRPo70wzfPoo
         Nzffhfv+XfUKe++zelGugfs/cx57xppm8MH9e5CdvozXNnYTUmwXsxZY6U7ZJZJKlCOE
         c54U8Ts51pTJL/xC+QpOUhyyoUeEn1q9+oMTDMc8ALz63aUgZ4sFgQY/0Vl1DQ6YdLy/
         c9cnbQpO8N7O3On4c2WyGWe1IRbG8STsarS6dnq8oUFtq79O5AIF9yM4mVN+rUruH7uH
         FilaRs3MC4Ry/bbJ0zZBxLW6DInWu7uDglXrAEOcm7XCR5ZDxTpL/91QGtc2oRsMuhzU
         UNjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RcBfOJG+plA9w2gh1ieESzMOZXJ0qVsChyqVj/Wv7Lc=;
        b=NTwDGrmPHIIjbJBR1ASD53zNTVwZZRJfAfXzQ+WV4h7RFlJHGhdmO+O58CcSVqCHdO
         Ow+eYd217m+SZPSvKHLnF9VPFng1ZUjNBTU9sTrmLb38LxMV4QkBXB7EP2ghyGt9L1Qn
         SzPTqTvlUVbKQUzMkpGDlRfiE/Aos1RcCutFHhqqqABwRyzdwodyX8oUJGuG8fNZ0Ttm
         P1K2LMwcLfCcPTLYmIbnJToiD5QNa7/zoNWBvqt+yYAfZY/r5KfDb6NsXdRvl+ivnaHB
         /0tOyRNWkT0A1W/HBIZ3gSWpfwpZsfwUJjpWzcR9EWqxgYIyuxBgEAIsipoxYtxO36Uj
         6hGQ==
X-Gm-Message-State: AOAM532l6XDgC3cBdDItLQyT9mP2Xokvs0lQPq5BgL5vud3K8tNr1Tx2
        DbGzCsRrZc+8rICw5Ga/z6I=
X-Google-Smtp-Source: ABdhPJxs7RhdOaZjA3Pr3iaEqZgDr0DQh0QuLoAMTKsA+t22xPEI3RrVdqu+5UkZeAnHgprzieTLiA==
X-Received: by 2002:a17:90a:6289:: with SMTP id d9mr1687195pjj.234.1630558111961;
        Wed, 01 Sep 2021 21:48:31 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f9sm574679pjq.36.2021.09.01.21.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 21:48:31 -0700 (PDT)
Subject: Re: [PATCH net-next v4] skb_expand_head() adjust skb->truesize
 incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <b653692b-1550-e17a-6c51-894832c56065@virtuozzo.com>
 <ee5b763a-c39d-80fd-3dd4-bca159b5f5ac@virtuozzo.com>
 <ce783b33-c81f-4760-1f9e-90b7d8c51fd7@gmail.com>
 <b7c2cb05-7307-f04e-530e-89fc466aa83f@virtuozzo.com>
 <ef7ccff8-700b-79c2-9a82-199b9ed3d95b@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <67740366-7f1b-c953-dfe1-d2085297bdf3@gmail.com>
Date:   Wed, 1 Sep 2021 21:48:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ef7ccff8-700b-79c2-9a82-199b9ed3d95b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/21 9:32 PM, Eric Dumazet wrote:

> 
> I think you missed netem case, in particular
> skb_orphan_partial() which I already pointed out.
> 
> You can setup a stack of virtual devices (tunnels),
> with a qdisc on them, before ip6_xmit() is finally called...
> 
> Socket might have been closed already.
> 
> To test your patch, you could force a skb_orphan_partial() at the beginning
> of skb_expand_head() (extending code coverage)
> 

To clarify :

It is ok to 'downgrade' an skb->destructor having a ref on sk->sk_wmem_alloc to
something owning a ref on sk->refcnt.

But the opposite operation (ref on sk->sk_refcnt -->  ref on sk->sk_wmem_alloc) is not safe.

