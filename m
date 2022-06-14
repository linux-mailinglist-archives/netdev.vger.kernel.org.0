Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F4554B7DB
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344328AbiFNRlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbiFNRlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:41:18 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAA72F668
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:41:17 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x62so12666322ede.10
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wPJFf9Cp6BUiKe7xlomnn648HWk9AdEvajhdW6pwyvM=;
        b=pBR9coEBEEA2GMkrHQv9ufnwIqWKmFTa1DPlYdIUlXFOPawKD/l6cAAGuGk9a76z2s
         7FlinRTLEjzEmIiKdSQFcGfrYvwiuNZ8zDA+csg/bCbm0bJglHNrzKCb0nbG3rtgH72I
         uB7QuBsSqYfo338tEN0J4lF8NowwH1Ac2K1m1wzL/2pHdpXnoiM6JlLTVWLkVyLwoxJ7
         uWcr/+a61GI9aZk6fMewLcxrd8ZtK9AiP5k9dS+uN4nP/1cJ8UhKhnx2AhmbtAMzep1j
         iw1glYaoQfrCIuHWHKc7p7BhSJ7aJLACZa00EKJyNMeJdXlVCXgByhjns0JmR/gdoedz
         d6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wPJFf9Cp6BUiKe7xlomnn648HWk9AdEvajhdW6pwyvM=;
        b=qZDfCBl9A0ruE2jVglaYIQTVVxDYmRbRmzY7ULQSceQ8gCXRhH4WBiD2MXoM/644e/
         KL9YSZx33nIjsRHgRztMmaHb8P1BlVfXuWD1qcLk7ovngHLA0Ky+A7mzAqyhRtVY4oT1
         +5i5tVOdg1fdFP21T/WptW4xTNSnKEITUMFscidoB4o/yMd809X5speE1HN8awTfqH/m
         UnvvnBBQnGZEajrxZrS+EBDXWSIUTsaohRv8bj0bGIslBudEwrvrN6fksmgeU9kygDeo
         XnWPmBG+JTyufVeL+YaCh5WuQ/UoUNdSkBJMF3jYULP1PTq1YRxJWpPhmbq6339gjXzj
         GwgA==
X-Gm-Message-State: AOAM532XGkvkkhqKRGMyktMlQ213LndeT6WAcYkHnTjOfqNxkl46+97E
        1KHgE6WmsXpET/YWA6RyWE6GhseNkwuTwlisVzjiNg==
X-Google-Smtp-Source: ABdhPJyrVvOwCj4NGUL3epVueMTSRBp9ZdxUMBY4zcbFlwgUZ5Xr8gq4TBIDF3H8nfo2hkda6ocuxNR5tsiO30UUVts=
X-Received: by 2002:a05:6402:750:b0:42d:a765:8637 with SMTP id
 p16-20020a056402075000b0042da7658637mr7283350edy.342.1655228475824; Tue, 14
 Jun 2022 10:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220614171734.1103875-1-eric.dumazet@gmail.com> <20220614171734.1103875-2-eric.dumazet@gmail.com>
In-Reply-To: <20220614171734.1103875-2-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 14 Jun 2022 13:40:39 -0400
Message-ID: <CACSApvYMCum+4HWeB0rBgh2QJuOFcW=9f0ib_MHF11Tu3168Qw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/2] tcp: fix over estimation in sk_forced_mem_schedule()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
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

On Tue, Jun 14, 2022 at 1:17 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> sk_forced_mem_schedule() has a bug similar to ones fixed
> in commit 7c80b038d23e ("net: fix sk_wmem_schedule() and
> sk_rmem_schedule() errors")
>
> While this bug has little chance to trigger in old kernels,
> we need to fix it before the following patch.
>
> Fixes: d83769a580f1 ("tcp: fix possible deadlock in tcp_send_fin()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  net/ipv4/tcp_output.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 8ab98e1aca6797a51eaaf8886680d2001a616948..18c913a2347a984ae8cf2793bb8991e59e5e94ab 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3362,11 +3362,12 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
>   */
>  void sk_forced_mem_schedule(struct sock *sk, int size)
>  {
> -       int amt;
> +       int delta, amt;
>
> -       if (size <= sk->sk_forward_alloc)
> +       delta = size - sk->sk_forward_alloc;
> +       if (delta <= 0)
>                 return;
> -       amt = sk_mem_pages(size);
> +       amt = sk_mem_pages(delta);
>         sk->sk_forward_alloc += amt << PAGE_SHIFT;
>         sk_memory_allocated_add(sk, amt);
>
> --
> 2.36.1.476.g0c4daa206d-goog
>
