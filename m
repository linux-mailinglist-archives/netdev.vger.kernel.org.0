Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF11514E81
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378042AbiD2O6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378039AbiD2O6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:58:51 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6152637BEA
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 07:55:33 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id j6so6078148qkp.9
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 07:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l3s19TyCwicCVLzG4Xw5t+DqX5DZg1MXRL5pueawjIQ=;
        b=mP6m0KFs/oXj+gW91EnuR9W10/jjdrLcZTHzzyBKPUSCPP474er+KpJXjOrGNaxMcN
         HWqNFOshhJ2rkkmhmWb6Dprq2cKBeW+clqHfEHOPntIUZMe6TJHzrp0Uys5BHuDEHYfS
         RNz2J7njC29ozEwYBdddDmLkot22pGsAb93wb8azAIT7wLCgbgsVSTgHNBx/dfH+WCDN
         2h8wgnfNw3FGYMyfD37j3bLwyOu/CQsgbm7GemmtmepGwwJAY5ABo/CRl4DD/78CRmSJ
         Q5g11BsN2yxtWBvgA9mFMiTV+Sthz4bZHNvCyFIvhVORAp3K30Ni/hZwBHt/uSw87TTd
         Gc2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l3s19TyCwicCVLzG4Xw5t+DqX5DZg1MXRL5pueawjIQ=;
        b=AijIMtQ6CrUMrkFBZFmBZBBtKBBmYdyVyC7WYMMTW90PW7ONIDxi05BG1KhkbjsZ5H
         RLPhc5b/tb7Bt7agjX5m4rfQ7j4AkAAyYSQ51ljYNeFseOkphdOFujxSa2McjWkMsOTD
         zXJR7WQ/Ur5m0WKXlqGXVI1mEY4NYc6xllcA6DAlii1bRX9XWgFHKGg9PEGu3wWodWvm
         WrIc7Te5wgHi04cOeXGJ0+nKqRSwiod6RNZk8F8qekfSh6365OlIHHv+XQ/n5r664hSN
         7nF7zL9/VAN/v09sc10KASY7aFADRxzDkPqi6KKWHZAbJC73BMGuiRQirGDKXuKQbj+J
         NH6A==
X-Gm-Message-State: AOAM533F1ElZLY08TJNpPRIBoG6q7AaRlJUFXoekaEtwlfgLt1mqDV5o
        VSVlKeDEEFM1nx/C9u7bB6WaK1FdSQpa/kJPpBnDiA==
X-Google-Smtp-Source: ABdhPJzqAUD+zQYbROumJPRxTJ9dUX5wdev+GYt+TxIxQ5wLZh7eMGtC48ys/mv0SgeKu6DTv+0DpVsel1a7Ajb8b1w=
X-Received: by 2002:a37:956:0:b0:69f:90a0:b1de with SMTP id
 83-20020a370956000000b0069f90a0b1demr8075421qkj.259.1651244132049; Fri, 29
 Apr 2022 07:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <1651228376-10737-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1651228376-10737-1-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 29 Apr 2022 10:55:16 -0400
Message-ID: <CADVnQynZDunGWXp4Oe4gfbhBBqpB2HyoWs21Z6dh7CFwW-o0Fw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: use tcp_skb_sent_after() instead in RACK
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 6:33 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> This patch doesn't change any functionality.
>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---
>  net/ipv4/tcp_recovery.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
> index fd113f6..48f30e7 100644
> --- a/net/ipv4/tcp_recovery.c
> +++ b/net/ipv4/tcp_recovery.c
> @@ -2,11 +2,6 @@
>  #include <linux/tcp.h>
>  #include <net/tcp.h>
>
> -static bool tcp_rack_sent_after(u64 t1, u64 t2, u32 seq1, u32 seq2)
> -{
> -       return t1 > t2 || (t1 == t2 && after(seq1, seq2));
> -}
> -
>  static u32 tcp_rack_reo_wnd(const struct sock *sk)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
> @@ -77,9 +72,9 @@ static void tcp_rack_detect_loss(struct sock *sk, u32 *reo_timeout)
>                     !(scb->sacked & TCPCB_SACKED_RETRANS))
>                         continue;
>
> -               if (!tcp_rack_sent_after(tp->rack.mstamp,
> -                                        tcp_skb_timestamp_us(skb),
> -                                        tp->rack.end_seq, scb->end_seq))
> +               if (!tcp_skb_sent_after(tp->rack.mstamp,
> +                                       tcp_skb_timestamp_us(skb),
> +                                       tp->rack.end_seq, scb->end_seq))
>                         break;
>
>                 /* A packet is lost if it has not been s/acked beyond
> @@ -140,8 +135,8 @@ void tcp_rack_advance(struct tcp_sock *tp, u8 sacked, u32 end_seq,
>         }
>         tp->rack.advanced = 1;
>         tp->rack.rtt_us = rtt_us;
> -       if (tcp_rack_sent_after(xmit_time, tp->rack.mstamp,
> -                               end_seq, tp->rack.end_seq)) {
> +       if (tcp_skb_sent_after(xmit_time, tp->rack.mstamp,
> +                              end_seq, tp->rack.end_seq)) {
>                 tp->rack.mstamp = xmit_time;
>                 tp->rack.end_seq = end_seq;
>         }
> --

Thanks! The patch looks good to me, and passes all our team's packetdrill tests.

Acked-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>

thanks,
neal
