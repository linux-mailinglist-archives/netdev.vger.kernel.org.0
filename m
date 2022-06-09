Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33939544FBB
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 16:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238851AbiFIOqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 10:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiFIOqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 10:46:46 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0029102C
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 07:46:44 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id n197so10789718qke.1
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 07:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VA2EfqmEA2p8c5TMGylAEodZTEkXQtFAyXYElSZue0E=;
        b=DKhU4ZeU5h7BCCCQYXYOFo2nmVEws0v/9s/AVQzEYnMmo79MMKPmfvgsKvNZO+6pmn
         njpSDxFdTlSxibTlW3QBUvNgEewHIdnzitzU0zzjWWSvB+giHnRg9OnbyJ/C1La0JCLn
         +ysIfEZLKfth9C1V9L6I8In1ZZTV+t8Sj7lFYfjW/algrB70t9FKr2NCGuEQs6Y3ZuXu
         SR23hW2hm3SU7V2ynWDHjLtACrafjL2R25/ib2p6yHph4IegqSqhieh/ijiJilCXxpw8
         r1c4jp8+W9O4BePtg+DEZV7QuzeKOvzc2Be7lZlbMO6sMTcO9Xl5wPnZcEI++/Ys49We
         lRjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VA2EfqmEA2p8c5TMGylAEodZTEkXQtFAyXYElSZue0E=;
        b=LQkrDZk5Yqo8Z+A0L5G6jbuUadAuLnXuWDjtMgJuQm59eFf1IFw6l6buKfe3MDamjS
         zE5RM8df6FkL8h9jB2myBwriEIx7nUVUGxEej3G6FbRnj3PT442t6uP7TaZuGGxH+Q4L
         LsnnMznTVKCbfKRnVofD7rt2bUs3wBB7DY2voo4nIZvU6+OkOmCk/gNXNb1q5Z+fW2Ln
         0rhQC0NG93eZ56ifXQ8p/xMo0VcLVoKUH/AP6uWliTevAnCNAPiMLQW0T2JKCLySlZzX
         FWyd3q7snVfMkzerum35SpWnpuZq7ZTvyxkGTKFeVOra+eEQjP2/HeI4D0kNPU/jQgsZ
         ZU7A==
X-Gm-Message-State: AOAM530UuzhCIHcYzR5/x3qP62BQx03Yoni3rKZBgHbeKUQpBhuyOldT
        UdtRGElsyX0p/w70Qk9LwSKauYgLyScOs3FnsQjK2A==
X-Google-Smtp-Source: ABdhPJxUirnnA5YIkqoCh45fLgcmni6x3OsEE/pL9CCRSoLr8hf8nAKXCoMh+745QymifB9nJqmZqFi7IXOJXi4RSGU=
X-Received: by 2002:a05:620a:1aa5:b0:6a6:c208:fb94 with SMTP id
 bl37-20020a05620a1aa500b006a6c208fb94mr13887653qkb.434.1654786003478; Thu, 09
 Jun 2022 07:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com> <20220609063412.2205738-5-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-5-eric.dumazet@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 9 Jun 2022 10:46:26 -0400
Message-ID: <CADVnQynuQjbi67or7E_6JRy3SDznyp+9dT-hGbnAuqOSVJ+PUA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: implement per-cpu reserves for memory_allocated
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
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

/


On Thu, Jun 9, 2022 at 2:34 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> We plan keeping sk->sk_forward_alloc as small as possible
> in future patches.
>
> This means we are going to call sk_memory_allocated_add()
> and sk_memory_allocated_sub() more often.
>
> Implement a per-cpu cache of +1/-1 MB, to reduce number
> of changes to sk->sk_prot->memory_allocated, which
> would otherwise be cause of false sharing.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/sock.h | 38 +++++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 825f8cbf791f02d798f17dd4f7a2659cebb0e98a..59040fee74e7de8d63fbf719f46e172906c134bb 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1397,22 +1397,48 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
>         return !!*sk->sk_prot->memory_pressure;
>  }
>
> +static inline long
> +proto_memory_allocated(const struct proto *prot)
> +{
> +       return max(0L, atomic_long_read(prot->memory_allocated));
> +}
> +
>  static inline long
>  sk_memory_allocated(const struct sock *sk)
>  {
> -       return atomic_long_read(sk->sk_prot->memory_allocated);
> +       return proto_memory_allocated(sk->sk_prot);
>  }
>
> +/* 1 MB per cpu, in page units */
> +#define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
> +
>  static inline long
>  sk_memory_allocated_add(struct sock *sk, int amt)
>  {
> -       return atomic_long_add_return(amt, sk->sk_prot->memory_allocated);
> +       int local_reserve;
> +
> +       preempt_disable();
> +       local_reserve = __this_cpu_add_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
> +       if (local_reserve >= SK_MEMORY_PCPU_RESERVE) {
> +               __this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
> +               atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
> +       }
> +       preempt_enable();
> +       return sk_memory_allocated(sk);
>  }
>
>  static inline void
>  sk_memory_allocated_sub(struct sock *sk, int amt)
>  {
> -       atomic_long_sub(amt, sk->sk_prot->memory_allocated);
> +       int local_reserve;
> +
> +       preempt_disable();
> +       local_reserve = __this_cpu_sub_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
> +       if (local_reserve <= -SK_MEMORY_PCPU_RESERVE) {
> +               __this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
> +               atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);

I would have thought these last two lines would be:

               __this_cpu_add(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
               atomic_long_sub(local_reserve, sk->sk_prot->memory_allocated);

Otherwise I don't see how sk->sk_prot->memory_allocated) ever
decreases in these sk_memory_allocated_add/sk_memory_allocated_sub
functions?

That is, is there a copy-and-paste/typo issue in these two lines? Or
is my understanding backwards? (In which case I apologize for the
noise!)

thanks,
neal





> +       }
> +       preempt_enable();
>  }
>
>  #define SK_ALLOC_PERCPU_COUNTER_BATCH 16
> @@ -1441,12 +1467,6 @@ proto_sockets_allocated_sum_positive(struct proto *prot)
>         return percpu_counter_sum_positive(prot->sockets_allocated);
>  }
>
> -static inline long
> -proto_memory_allocated(struct proto *prot)
> -{
> -       return atomic_long_read(prot->memory_allocated);
> -}
> -
>  static inline bool
>  proto_memory_pressure(struct proto *prot)
>  {
> --
> 2.36.1.255.ge46751e96f-goog
>
