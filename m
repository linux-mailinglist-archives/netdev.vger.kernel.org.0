Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2E74D30D9
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiCIOOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiCIOOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:14:53 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2E35C342
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 06:13:53 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g3so3065155edu.1
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 06:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1IxllUWaN7M8mx21dfIKX1VrykAWot/sHa98wBQT+A=;
        b=L2bBXpPVmc82ygCZ7z8gnJsvj2t4AfL/jqUl4OvN1XQk2L6+2wlK8D6LIBkvqUE8P4
         RmzjV+XkULYlr5raJtBvhSAbJEdlKBa2wHWNRiE3YuqLC8ZBY3TrrsAvcOGPSkbHllse
         lILxQ0Es5W/RJgYmOTubM43ttbv93+1Gw4+jNKSDz2FnVyu1zul3IHTu15JT/ulvGkQU
         yUiAmZTS7mjiFv41hbFJIe1O6nZm7/xF2aHRNGHxk7Fiu9aosyIF5PoJ7qkvMFrrM+a4
         tA0gnOB66+z5WfL4gbnyL+PcAAtXX+hs2sIdRmpGtgue3PzzBrqcRcLVPFukgrKQp7l3
         5DvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A1IxllUWaN7M8mx21dfIKX1VrykAWot/sHa98wBQT+A=;
        b=Rcou+M+EHM0Hh+ESJ50mRyuBlCSIV0wRUt8tYcfkuqzoCUMK3PaM68eM0w3EechoI7
         en7zCjv8g1NOt0/jNgzvXLQo9f3YLpUUOlTm5nw8aOXMHNcPdQGT46HsAmywtWKjSOAS
         aebcOL53DZSDUbCfnK5b0yZnwsz7fCZJGUWRdKDV34/UKaKNTmx2iB+j949V7jpRaEPo
         Z+wm1Crf35eD5FZiXAt4xRbtlFHhkS5JS7blVfAimoFPkvoaHDrs7ykr4n1egDovnQ+e
         /nFwOPtz3mlo9hmi2hoBAZ8rKdJCJxYgTSRfMRvmRl55uGtXYPgdeJdTKJyOS5LYkBh0
         ontA==
X-Gm-Message-State: AOAM532f7+QsrDiwCy55bF6voRsRI7QyUc3JMkCKtT6NhDkDciB0TXrs
        DIm1puaJJYagoahBFKAnx7pzsoc0K9rrxYMI/tnaCA==
X-Google-Smtp-Source: ABdhPJySrQ6B+L5HnD8/slntL7k8ts+U73zWZkhM1HNH/f46jETe4YG7D6nRIk9NQIhO+k4c93d6ZGAKiX5t9c6+V1o=
X-Received: by 2002:a05:6402:6da:b0:3fd:cacb:f4b2 with SMTP id
 n26-20020a05640206da00b003fdcacbf4b2mr21291908edy.332.1646835232001; Wed, 09
 Mar 2022 06:13:52 -0800 (PST)
MIME-Version: 1.0
References: <20220309054706.2857266-1-eric.dumazet@gmail.com>
In-Reply-To: <20220309054706.2857266-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Wed, 9 Mar 2022 09:13:15 -0500
Message-ID: <CACSApvZ1wyP6vRFujZOxwF1277OwHmLsxa6Hi-gFt9xzKnuCwA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: autocork: take MSG_EOR hint into consideration
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 9, 2022 at 12:47 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> tcp_should_autocork() is evaluating if it makes senses
> to not immediately send current skb, hoping that
> user space will add more payload on it by the
> time TCP stack reacts to upcoming TX completions.
>
> If current skb got MSG_EOR mark, then we know
> that no further data will be added, it is therefore
> futile to wait.
>
> SOF_TIMESTAMPING_TX_ACK will become a bit more accurate,
> if prior packets are still in qdisc/device queues.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Willem de Bruijn <willemb@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thanks for catching this!

> ---
>  net/ipv4/tcp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 33f20134e3f19c1cd8a4046a2f88533693a9a912..b6a03a121e7694e3e8cc5b4f47b7954a341c966e 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -688,7 +688,8 @@ static bool tcp_should_autocork(struct sock *sk, struct sk_buff *skb,
>         return skb->len < size_goal &&
>                sock_net(sk)->ipv4.sysctl_tcp_autocorking &&
>                !tcp_rtx_queue_empty(sk) &&
> -              refcount_read(&sk->sk_wmem_alloc) > skb->truesize;
> +              refcount_read(&sk->sk_wmem_alloc) > skb->truesize &&
> +              tcp_skb_can_collapse_to(skb);
>  }
>
>  void tcp_push(struct sock *sk, int flags, int mss_now,
> --
> 2.35.1.616.g0bdcbb4464-goog
>
