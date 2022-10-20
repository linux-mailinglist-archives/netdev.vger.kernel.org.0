Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A52606887
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiJTS5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJTS5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:57:32 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE111AAE4E
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:57:30 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-36855db808fso2537417b3.4
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1dotx5za5+WUFbxC7pIwSwaYG47EmrXHTKObMsWXZ0c=;
        b=khQJ+vjH1owIufukRwFksx2uXQnbPkQ/lOtXNyAekdq1VIcQ+FGEIMJ/v1SDZPd6yB
         wB+izwYI3MWjcJj8fHRHXv9/ZFq9lK3XvaolVG0FV8kBnBscmog7OkuisOkckuku+Ldl
         WE6i6cp7xkWNSQwVwjyz8QgpuNt+VJ2Wuaf1T9g6BbfE9tt9b4cXcEoze7vsGuZlRAsk
         sShz1aTfeYVgqcR4gOGcO0ILDqRJ5Cq/CYHy4xOtA8DlAMl2qd2tJRi32Lc61uqSXYQf
         raTsThYBdzfb0eyZ7r8YPWM//GzLkgBmCiqmxM6Au3bBQS7fw7wuVVnqZf6hcdoIsvVd
         tqrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1dotx5za5+WUFbxC7pIwSwaYG47EmrXHTKObMsWXZ0c=;
        b=7jC2MgYylHdWd7Z6tTW7sBFvV1LAZnyRsiDaU1ct2DbglHPaTgKEhVGmjfEZ75CXU9
         jf2thYkN6UP6wEHrnBPKHVG1IEnZy7b5w1ZpJ8pxtK5zJtE1dji8K0NXGmhlWbzSfrt3
         h30LVv14aMK4/vt9OrizPedS67826g6eSnxQ+zrnYQ7Uy8RTqh6uAC60LmvTxTFYGPi4
         1nxo3o8lSwVi4lOaTV2oh6Oankg9MeInJMDfhv00PyyAUOXe4vxSura5maLkjJM+ZceV
         RDS3QNPtbLaWGXQaWt18l2Z4cMmZu+Bc0v7TbbL74r5jIEPAhv5UvdPfHF8TeFEgptDS
         Wcgg==
X-Gm-Message-State: ACrzQf1XSCigLXuc2L0vBZxJEEsDkrg9LC5OMnifEhXVOnFrEdLl70y2
        l5+CVvKMPYeIbIDWoA0R4rFVJ8g7PZeg0mf2o4jkRw==
X-Google-Smtp-Source: AMsMyM6FLi/jq/Bvv35cQ+hVnQBz+FqbYCxIpxWCC5nEiMJMHmJdngHd4Npzi/buY9RWAbjNGClKRNud23IoNp6oOJA=
X-Received: by 2002:a81:1c07:0:b0:358:6e7d:5118 with SMTP id
 c7-20020a811c07000000b003586e7d5118mr13443176ywc.255.1666292249238; Thu, 20
 Oct 2022 11:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20221020182242.503107-1-kamaljit.singh1@wdc.com> <20221020182242.503107-3-kamaljit.singh1@wdc.com>
In-Reply-To: <20221020182242.503107-3-kamaljit.singh1@wdc.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Oct 2022 11:57:18 -0700
Message-ID: <CANn89iLZZAA6N5wzzP_ZR2u-shHLxknobxt+5CixA92rv7udcw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] tcp: Ignore OOO handling for TCP ACKs
To:     Kamaljit Singh <kamaljit.singh1@wdc.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Niklas.Cassel@wdc.com, Damien.LeMoal@wdc.com
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

On Thu, Oct 20, 2022 at 11:22 AM Kamaljit Singh <kamaljit.singh1@wdc.com> wrote:
>
> Even with the TCP window fix to tcp_acceptable_seq(), occasional
> out-of-order host ACKs were still seen under heavy write workloads thus
> Impacting performance.  By removing the OoO optionality for ACKs in
> __tcp_transmit_skb() that issue seems to be fixed as well.

This is highly suspect/bogus.

 Please give which driver is used here.

>
> Signed-off-by: Kamaljit Singh <kamaljit.singh1@wdc.com>
> ---
>  net/ipv4/tcp_output.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 322e061edb72..1cd77493f32c 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1307,7 +1307,10 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
>          * TODO: Ideally, in-flight pure ACK packets should not matter here.
>          * One way to get this would be to set skb->truesize = 2 on them.
>          */
> -       skb->ooo_okay = sk_wmem_alloc_get(sk) < SKB_TRUESIZE(1);
> +       if (likely(tcb->tcp_flags & TCPHDR_ACK))
> +               skb->ooo_okay = 0;
> +       else
> +               skb->ooo_okay = sk_wmem_alloc_get(sk) < SKB_TRUESIZE(1);
>

This is absolutely wrong and would impact performance quite a lot.

You are basically removing all possibilities for ackets of a TCP flow
to be directed to a new queue, say if use thread has migrated to
another cpu.

After 3WHS, all packets get ACK set.
