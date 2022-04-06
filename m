Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55E54F6775
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238707AbiDFRY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbiDFRWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:22:41 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D09219B061
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 08:21:04 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2eb543fe73eso30137517b3.5
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 08:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LbJCav1uXtuWUlqAT0eaH5pFXmexaiSMtFMXOTvqsT8=;
        b=ByRxYKIwpZQLewXdKX1anrRAmKxrBrGkMj7XLyDbgoK+Y0xvXw58dvGt8A6vwmk9CJ
         CjIk0MYvqiiL4LsjeAcegwjDquO53XgeXxJBPaPUhCKz5HsUQHeQ+hxCqejD3jlJLczh
         wjkMQaHtNmUcCcmgEo7akFjhRjhKxhNE85530/rM708xbqqGkg0feRxAdBE8JQlSOpa3
         +PEYL4cE/cmX9jZVCrpkZLOwIsHkqQkUTpVrxuEouA7rkZvsPlDYLpE4e+oBQ+DAuS3V
         yvT4qbGUp1Hm6ftQevdhkK4WZoD8CbpyrSJih+WcX6M/3mBkLwN9BhCCq6HOIPzUa687
         o/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LbJCav1uXtuWUlqAT0eaH5pFXmexaiSMtFMXOTvqsT8=;
        b=Vo4QhxPs3ViKG43IzhflHDGkAAJBbLYoxG1muPyK8xCdyNTQbw4eAW8RToqR3IAiAD
         +intteZO9WyUu8zRgEydeoJex/srZGXsb1hWxiTkCaZ1QoXESMBTqDMVCmPf+xahft82
         dXi3Q6rmgmC8tCt5xE8jJS+9cXyZX3o+D5kLjFjyHna+83KT6ZVAms6eBYNWVsgzXrf3
         L0/gGBQP5dKjJuPI7h3nlREJnGOlonHUH2ZeH82TVWMdgWy5Sld7yAlHBhjrRwupf2bl
         24/iYNZ97MkPTh0II4H6A0/QrVImop/k2CEIA1Bnz+d2avgebrbsruzQV6RGaHeveCvG
         Ygog==
X-Gm-Message-State: AOAM531Y7TOLYEg5Ioj4MRyy/OA1+n3uGCp7wbxWU/R+3wYKmQs6X0L6
        7aRb9DXM5NmT7meAlFeSR/eDZkbxfHjgAZ7GwapBXA==
X-Google-Smtp-Source: ABdhPJyaI+vM3OMm6ethO2BcVjTKD9b4X931WQ14y4uGk0UZ2RoA7Wa9w/eD4g4f279OXF1HAE+PEfYnTKqTFc4INY4=
X-Received: by 2002:a81:84:0:b0:2eb:4932:f34e with SMTP id 126-20020a810084000000b002eb4932f34emr7444015ywa.278.1649258463342;
 Wed, 06 Apr 2022 08:21:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220406114807.1803-1-lianglixue@greatwall.com.cn>
In-Reply-To: <20220406114807.1803-1-lianglixue@greatwall.com.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 6 Apr 2022 08:20:52 -0700
Message-ID: <CANn89iK+GSrShunMPA5g12O36CofeUso1C9Ce3daFowkntScPg@mail.gmail.com>
Subject: Re: [PATCH] af_packet: fix efficiency issues in packet_read_pending
To:     lianglixue <lixue.liang5086@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, rsanger@wand.net.nz,
        Yajun Deng <yajun.deng@linux.dev>,
        jiapeng.chong@linux.alibaba.com, netdev <netdev@vger.kernel.org>,
        lianglixue <lianglixue@greatwall.com.cn>
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

On Wed, Apr 6, 2022 at 4:49 AM lianglixue <lixue.liang5086@gmail.com> wrote:
>
> In packet_read_pengding, even if the pending_refcnt of the first CPU
> is not 0, the pending_refcnt of all CPUs will be traversed,
> and the long delay of cross-cpu access in NUMA significantly reduces
> the performance of packet sending; especially in tpacket_destruct_skb.
>
> When pending_refcnt is not 0, it returns without counting the number of
> all pending packets, which significantly reduces the traversal time.
>

Can you describe the use case ?

You are changing the slow path.

Perhaps you do not use the interface in the most efficient way.

Your patch is wrong, pending_refcnt increments and decrements can
happen on different cpus.



> Signed-off-by: lianglixue <lianglixue@greatwall.com.cn>
> ---
>  net/packet/af_packet.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index c39c09899fd0..c04f49e44a33 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1210,17 +1210,18 @@ static void packet_dec_pending(struct packet_ring_buffer *rb)
>
>  static unsigned int packet_read_pending(const struct packet_ring_buffer *rb)
>  {
> -       unsigned int refcnt = 0;
>         int cpu;
>
>         /* We don't use pending refcount in rx_ring. */
>         if (rb->pending_refcnt == NULL)
>                 return 0;
>
> -       for_each_possible_cpu(cpu)
> -               refcnt += *per_cpu_ptr(rb->pending_refcnt, cpu);
> +       for_each_possible_cpu(cpu) {
> +               if (*per_cpu_ptr(rb->pending_refcnt, cpu) != 0)
> +                       return 1;
> +       }
>
> -       return refcnt;
> +       return 0;
>  }
>
>  static int packet_alloc_pending(struct packet_sock *po)
> --
> 2.27.0
>
