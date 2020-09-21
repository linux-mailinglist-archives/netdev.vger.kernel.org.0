Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF74271B49
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 09:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgIUHTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 03:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgIUHTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 03:19:32 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE200C0613CE
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 00:19:32 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y74so14285549iof.12
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 00:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J74hei80adNTzhYNjM9XWAuJbKr+AfEajEupZTz7dsQ=;
        b=FM/cABQ7w1uG4yzBJwkCQ17ro5QtkQMVwytS964BkBwlodtZr9Vg/RPLfMOyejCt3o
         hnkip9jXnfMty6j6tFPfUF0CDq/+ZUtaWIx/iSU7Nr63YiN0KX6DcAQs23fh53f5dljP
         BbmSiM6FgMO1x4osWYkMkz1nyENLJ9PwaiAjSh/tgENreIoPUQ+i77aUgVnYkI4wHrOl
         n8XArYiUba3QjM7gpyoApqt6VVfBP4cznn8+0WZArsQ52IARyTV5y335IKe5rDoRd+mW
         /fjvTrOTtFohfAqBr0dfrKpPZ9ma/S5a0DOkco/BrZlDhDQo6PshQf4Vsdcqjr2n45+o
         kpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J74hei80adNTzhYNjM9XWAuJbKr+AfEajEupZTz7dsQ=;
        b=MjImZ+n0AUpd5FloQpsgDkkTl60K638HK7O8ebzAXfCbg+HI+azXi5/lrSzXvde8rR
         jKLOPAcK4bjd0gkSNeAekJu48W+B4dX7zcLePPRBJZZvM5p/rsjkzielHSAxYRHQ9uHW
         BdupCgN2H7IefWErVHfPJku8tIv5/Io1QJICjFg/jaC19f28UQOOtegZFtfZKm5E26Qn
         2cEqaIoOTgsIUL2Q5hTvHOV2u9pmugAkLEel2EYe504omY5TJturxU+jrs0G/gpD/CxR
         uCQjecCbnao/bv+jB9QDi83FEJnqca1MPpM958Eiv19Lghf/fv/N/BnMEeGcxRAD6lUB
         yivg==
X-Gm-Message-State: AOAM531RUmg3uDR3NXPykiNRBfC2TKgtoA5v8IhzZYrbdYeo8BbEKXxM
        bjVeaxZYVK0awB+cw5z6JfdmL4jCXvEnEOXHKARyJg==
X-Google-Smtp-Source: ABdhPJwK5o0hDK1CN3lr6887VDZIbNEa8h6lPnHPNmCoBjAbL7g/9RrFRE+3acMu/Wq7dXv5JNs6cTlB0giFDFCocUw=
X-Received: by 2002:a05:6638:1381:: with SMTP id w1mr39780355jad.34.1600672771685;
 Mon, 21 Sep 2020 00:19:31 -0700 (PDT)
MIME-Version: 1.0
References: <1600653893-206277-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1600653893-206277-1-git-send-email-linyunsheng@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Sep 2020 09:19:20 +0200
Message-ID: <CANn89iLHH=CRzz5tavy_KEg0mhgXkhD9DBfh9bhcqSkcZ2xaaA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: use in_softirq() to indicate the NAPI
 context in napi_consume_skb()
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linmiaohe <linmiaohe@huawei.com>, martin.varghese@nokia.com,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>, kyk.segfault@gmail.com,
        Saeed Mahameed <saeed@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 4:08 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> When napi_consume_skb() is called in the tx desc cleaning process,
> it is usually in the softirq context(BH disabled, or are processing
> softirqs), but it may also be in the task context, such as in the
> netpoll or loopback selftest process.
>
> Currently napi_consume_skb() uses non-zero budget to indicate the
> NAPI context, the driver writer may provide the wrong budget when
> tx desc cleaning function is reused for both NAPI and non-NAPI
> context, see [1].
>
> So this patch uses in_softirq() to indicate the NAPI context, which
> doesn't necessarily mean in NAPI context, but it shouldn't care if
> NAPI context or not as long as it runs in softirq context or with BH
> disabled, then _kfree_skb_defer() will push the skb to the particular
> cpu' napi_alloc_cache atomically.
>
> [1] https://lkml.org/lkml/2020/9/15/38
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> note that budget parameter is not removed in this patch because it
> involves many driver changes, we can remove it in separate patch if
> this patch is accepted.
> ---
>  net/core/skbuff.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index e077447..03d0d28 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -895,8 +895,10 @@ void __kfree_skb_defer(struct sk_buff *skb)
>
>  void napi_consume_skb(struct sk_buff *skb, int budget)
>  {
> -       /* Zero budget indicate non-NAPI context called us, like netpoll */
> -       if (unlikely(!budget)) {
> +       /* called by non-softirq context, which usually means non-NAPI
> +        * context, like netpoll.
> +        */
> +       if (unlikely(!in_softirq())) {
>                 dev_consume_skb_any(skb);
>                 return;
>         }
> --


I do not think we should add this kind of fuzzy logic, just because
_one_ driver author made a mistake.

Add a disable_bh() in the driver slow path, and accept the _existing_
semantic, the one that was understood by dozens.
