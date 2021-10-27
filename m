Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B6543C3D2
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbhJ0H0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhJ0H0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:26:32 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087FEC061570;
        Wed, 27 Oct 2021 00:24:08 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id d21-20020a9d4f15000000b0054e677e0ac5so2309125otl.11;
        Wed, 27 Oct 2021 00:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xKkULtnAHN3BBD5eD7FP0nepKRFCwYme0ivxKFWmaaU=;
        b=XNaKnmQagjRfG5cgMridzeZ4v5R5AxQrpQ8i5/VMhJTrrAXrbHMbhaONcS0e20OgXs
         h5PrGxm4Az6DNf/a08+abbFqrakpSf8MQqxzmTqAGNtdM45WuUrQJlrqzdkv/OWrH5rO
         avoDU1Pri4enX0EuEOwQBO7ulKqHHKI9vpKLSpWNrOMNF3aDoJzsJ7uGjKtsjGkhGyua
         s7IqrerU6nkRtdVo35laiFXsyYaNjTBLwIwUUJu62U/kr4tE4O0t6jOH5UgDREyOLFHo
         iIcy7J8VxmqnkDOG9uhkRdInf9dYGsQX13z3r5noirKfgj0kWUSAFTqUT9gzr+zSu7OB
         cWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xKkULtnAHN3BBD5eD7FP0nepKRFCwYme0ivxKFWmaaU=;
        b=j/O0PHNAh6sGvMfEhr61psE4eVC0qUnyqEPulubnnwu0splsWGCTsBk7NbsB82EPpU
         Zpe1HDXNBKAMHULHmnOl+YEcq9GYkH0SIy+3nnu2muN1loy1A06U3bawkeVxNvELFypM
         ImlAvSkQZaapqN9Ep8p9XpCs7V6XBM/sTL8F4Rw72vuVIgaqZ8k3cc/+NSeTwP1cdA7x
         s+h/acugBCe4yTLLipqXj4px54m8vigxX6WKXVkbKyxJX6W0WNsX6qy7Jc0AKOEIOvbE
         KH0DDgl/zSKdj4idyMkfEkJNAjja/KWczLbnc7UKpp4sQLu5wZCKdp00AMb8XhzmYNLw
         9L3w==
X-Gm-Message-State: AOAM533WcWObO2YZrpyUKEB6R6vAaxkej+s7qcE2FassFAlPli/cOhSI
        FnD6K9BVAw6CJ42U9HxoDMQejeyemqqrPmUE/0o=
X-Google-Smtp-Source: ABdhPJyrVh1dzaEk6XgDI0KK5bnNhVijDoVP6tfQFZuI0HnKcrKVdWMYuuM17vNogv/nmH6yYylPCZpYzi+wSh+S+tE=
X-Received: by 2002:a05:6830:2647:: with SMTP id f7mr23211066otu.124.1635319447341;
 Wed, 27 Oct 2021 00:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <20211026131859.59114-1-kerneljasonxing@gmail.com>
In-Reply-To: <20211026131859.59114-1-kerneljasonxing@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 27 Oct 2021 15:23:31 +0800
Message-ID: <CAL+tcoC487AF=HAiNVhKO6kA0yhjT+hmp5DQSdaGBnJEtGgqPA@mail.gmail.com>
Subject: Re: [PATCH net] net: gro: set the last skb->next to NULL when it get merged
To:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        alobakin@pm.me, jonathan.lemon@gmail.com,
        Willem de Bruijn <willemb@google.com>, pabeni@redhat.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Xing <xingwanli@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 9:19 PM <kerneljasonxing@gmail.com> wrote:
>
> From: Jason Xing <xingwanli@kuaishou.com>
>
> Setting the @next of the last skb to NULL to prevent the panic in future
> when someone does something to the last of the gro list but its @next is
> invalid.
>
> For example, without the fix (commit: ece23711dd95), a panic could happen
> with the clsact loaded when skb is redirected and then validated in
> validate_xmit_skb_list() which could access the error addr of the @next
> of the last skb. Thus, "general protection fault" would appear after that.
>
> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> ---
>  net/core/skbuff.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 2170bea..7b248f1 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4396,6 +4396,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>                 skb_shinfo(p)->frag_list = skb;
>         else
>                 NAPI_GRO_CB(p)->last->next = skb;
> +       skb->next = NULL;
>         NAPI_GRO_CB(p)->last = skb;

Besides, I'm a little bit confused that this operation inserts the
newest skb into the tail of the flow, so the tail of flow is the
newest, head oldest. The patch (commit: 600adc18) introduces the flush
of the oldest when the flow is full to lower the latency, but actually
it fetches the tail of the flow. Do I get something wrong here? I feel
it is really odd.

Thanks,
Jason

>         __skb_header_release(skb);
>         lp = p;
> --
> 1.8.3.1
>
