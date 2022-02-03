Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DDA4A8866
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiBCQMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352136AbiBCQLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:11:55 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5ABC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:11:55 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 124so9802345ybw.6
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2c9zkis+6mjPEUK4jpV3Nd/fV3ZkhoV3T1Sk9fa/itg=;
        b=HVdkDXFC1v1yEf6nQDIdZpARd3kCqcuNh/Nzud6NxoWx6lHydV6Z7n0dt54DjWqVat
         kGHeXlxacQpCL1/X3BcsWdvrj0NRj6PrVrH0QQEbrpj4zm2VcFgKYo6R4dDHNLrqbwjq
         HfV/VjgJDZRZZWJX1j4MmRhG1npfIfpFIrRGM/r/QAw4JThzeBu6KBibeDr0RM0uiYVh
         JK/Eu9S8upX1q6WhUl3OQeZ6dUoTmN5BJzccUe6NZK/7DfkHOSXTVSAFxUKHmUgryWjN
         33GyryJAvckAzinsmc9qFGHNldRuEr5zn2FGX+pWJTORqyjF4CRJszd6JZIsLHITT6VQ
         ysmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2c9zkis+6mjPEUK4jpV3Nd/fV3ZkhoV3T1Sk9fa/itg=;
        b=HPy4C4TnK5tIjOolNuvyS7bAA0c7/R2wdUZA857BEKLwOZ2R93Bts4+Z53tB97d3eU
         JNXkk2uVqAGJuhfBEssGBNBgxVCqhWwaX8WoHYf+DpCxavnCtox0cKxX59AYVbuZWcDf
         G6fWGg3iRbwx73K7p5V8QFcMCoGZlHDXun9N7HoDtqWY46TS07iF+Z3KkjBBO6i8bVJX
         JJrojTMwt6+qdXH4MLGWZEubHxsOUfAn4QVCjhEQpWMG00+yHbq+ytZGaqJRB39wwYsT
         5fJkG4yEtWrdD9sKDKPPlp+TYL8sNTAq5L6LRNkAxw4tSZ7BNNyykdMkjyy/R/qblKjc
         5Jlw==
X-Gm-Message-State: AOAM5333uw2otC/Yfyy2XFvRvKtzIahGajgLUl6t8s4sTz81Cchsi9sj
        0SLWeUW2ZwvUzplOajmMNI2acirCZhD18TizNc7cVQ==
X-Google-Smtp-Source: ABdhPJwocRAw9bvLDyZByFn+bVH/BqVA1/zKQUp8t5LiBh/ibCwiLTL085m8JoFtP3AyYwU7s+0nZfANv4K01M6+yhY=
X-Received: by 2002:a81:3a4f:: with SMTP id h76mr5182028ywa.543.1643904714255;
 Thu, 03 Feb 2022 08:11:54 -0800 (PST)
MIME-Version: 1.0
References: <cover.1643902526.git.pabeni@redhat.com> <550566fedb425275bb9d351a565a0220f67d498b.1643902527.git.pabeni@redhat.com>
In-Reply-To: <550566fedb425275bb9d351a565a0220f67d498b.1643902527.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 08:11:43 -0800
Message-ID: <CANn89iLvee2jqB7R7qap9i-_johkbKofHE4ARct18jM_DwdaZg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: gro: register gso and gro offload on
 separate lists
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 7:48 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> So that we know each element in gro_list has valid gro callbacks
> (and the same for gso). This allows dropping a bunch of conditional
> in fastpath.
>
> Before:
> objdump -t net/core/gro.o | grep " F .text"
> 0000000000000bb0 l     F .text  000000000000033c dev_gro_receive
>
> After:
> 0000000000000bb0 l     F .text  0000000000000325 dev_gro_receive
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/linux/netdevice.h |  3 +-
>  net/core/gro.c            | 90 +++++++++++++++++++++++----------------
>  2 files changed, 56 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 3213c7227b59..406cb457d788 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2564,7 +2564,8 @@ struct packet_offload {
>         __be16                   type;  /* This is really htons(ether_type). */
>         u16                      priority;
>         struct offload_callbacks callbacks;
> -       struct list_head         list;
> +       struct list_head         gro_list;
> +       struct list_head         gso_list;
>  };
>

On the other hand, this makes this object bigger, increasing the risk
of spanning cache lines.

It would be nice to group all struct packet_offload together in the
same section to increase data locality.

I played in the past with a similar idea, but splitting struct
packet_offload in two structures, one for GRO, one for GSO.
(Note that GSO is hardly ever use with modern NIC)

But the gains were really marginal.
