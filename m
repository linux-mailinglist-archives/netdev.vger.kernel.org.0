Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526ED3FE70B
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 03:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhIBBO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 21:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhIBBOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 21:14:25 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A80C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 18:13:27 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id k65so529472yba.13
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 18:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OUK3StupIW28boR/oWh7uoyRcEavf5zyV9ONiTAaoeg=;
        b=osK2Vmt97XpiH/eEracpZkXg4qyNZQAMPpbClix/HE5scC98vCYa6zt5/s6xFLCT0h
         R0UWka/sVf/Hjf1hQeBqZJ3WJlYQBICRqSYCp81EyT0NLhb9HJCdyiGneKVUbhaV6WV5
         Ar2u8GnQ4a86L/s2gS2dQ5gNZDb4PuME5x2MdI4TS2hkO/E1d587BFuoCtLQGDVJuESw
         EC5O34Bsrc0P3N+AwRFVdXe0mY/FwYlHJks9fu5aGtGGz41uX11U9HYCUgIQswCh7SFv
         fZKx/5PxODtOAb6rNQN2ME/HMGOdc89NpxxM2pz9KT8Ef4WVu04iXR10Fc7kSyAg7NDy
         +9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OUK3StupIW28boR/oWh7uoyRcEavf5zyV9ONiTAaoeg=;
        b=Cq4NkzvbYewJBLnF04LeKAb2rxx7LuwXsuOGVuHYFDsMmqHfyKEyI631QZjhhQhoRK
         aDnmEWtBraBm7bP/a33GPjDaMDN5hil2iIPXRR8OLE0sSnf87z3j2s2Ny3KsN/fNBCyX
         6/oZOGQU1YxUvIVRg+PLfvpC073ABEV5mvVe9/fSv7KGpd5QH0eAx/DRBiUz4o8am4Xj
         rcHYR5eoVSNzrNKAg5IpiLzRRYghVabyEBq9XoRThSKwfQsv8rfi6YrpuctOmvCBNXx4
         hScQiMPG+gPuQio5FnbcIigAA3tQmZM+6z0wNo1RxvdmNLAAPEtmsGwFrlGlJiWfMG+C
         Fzfg==
X-Gm-Message-State: AOAM532kB6KWo1ec85GFXSsU6Ge0puEz/uAxQDtAjf3S3XX+EoLPslkq
        aBx9Sr9mw8NN+R+iqDLrlK6H1hxvN7CxLabpIN9LB5wnQNB1Yg==
X-Google-Smtp-Source: ABdhPJycS2T9davgSiaJCYBUa8o5DSNA+iJOcj9v7NpE1EvmUZG/Su6A56sRgwngMB3/IblvltuTqJs7+6aVGU3UPis=
X-Received: by 2002:a25:55d6:: with SMTP id j205mr977345ybb.395.1630545206395;
 Wed, 01 Sep 2021 18:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <1630492744-60396-1-git-send-email-linyunsheng@huawei.com> <ba7a0854-6841-2ebc-c329-4c13f1a997df@huawei.com>
In-Reply-To: <ba7a0854-6841-2ebc-c329-4c13f1a997df@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Sep 2021 18:13:14 -0700
Message-ID: <CANn89i+X_K2A1kepmLh1ySC_UE=+ov=Cya2mtW7R0LT68kyb2w@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: add tcp_tx_skb_cache_key checking in sk_stream_alloc_skb()
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 5:47 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/9/1 18:39, Yunsheng Lin wrote:
> > Since tcp_tx_skb_cache is disabled by default in:
> > commit 0b7d7f6b2208 ("tcp: add tcp_tx_skb_cache sysctl")
> >
> > Add tcp_tx_skb_cache_key checking in sk_stream_alloc_skb() to
> > avoid possible branch-misses.
> >
> > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> > ---
> > Also, the sk->sk_tx_skb_cache may be both changed by allocation
> > and freeing side, I assume there may be some implicit protection
> > here too, such as the NAPI protection for rx?
>
> Hi, Eric
>    Is there any implicit protection for sk->sk_tx_skb_cache?
> As my understanding, sk_stream_alloc_skb() seems to be protected
> by lock_sock(), and the sk_wmem_free_skb() seems to be mostly
> happening in NAPI polling for TCP(when ack packet is received)
> without lock_sock(), so it seems there is no protection here?
>

Please look again.
This is protected by socket lock of course.
Otherwise sk_mem_uncharge() would be very broken, sk->sk_forward_alloc
is not an atomic field.

TCP stack has no direct relation  with NAPI.
It can run over loopback interface, no NAPI there.
