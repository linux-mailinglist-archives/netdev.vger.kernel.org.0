Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355D5544DC7
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 15:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343664AbiFINef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 09:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239509AbiFINed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 09:34:33 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D636951587
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 06:34:31 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v19so31221110edd.4
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 06:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DOb71mn+QYArh/cdowC+InUEmTqbWq/lHu7UNtPrqNU=;
        b=qumRIfXw6GMuPB3NVrOzMSf32/fsx4Fscx2AfZ6eL8RWStgcpMx58TbmH/r9fGhSDN
         DRceaCxEfLttGWC+XBEE/AJdivKSLehvSOqzFFtIg9yC3BnVf7JC46hOfea7gAG7SaPm
         YpRhxwoUMEkZzuL9XX0gfgf1vNUFw8QR4apHbI4XlnByTBTo4Op0STiW/IkZiQYThW9T
         c/OcSwutIX0/LfUbFl/t29lPyg6o/GEyMfMo6oMaF1zxlckWk7GG8TdCI27LMKKmgeHS
         alVgAiDK7Pmi+/GRBBQdpPs/c/xGX+YTdY6E3Zx5vGvjzye6u/Ibtd67VigPLM9wHMZv
         B7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DOb71mn+QYArh/cdowC+InUEmTqbWq/lHu7UNtPrqNU=;
        b=5pjajFYDHiLoKnr4J4Ww6yjTZhUSgrlj0O8Ggm7g/pbI9dHP7fbNf+2DeK0BvC/r/j
         1tttbafDunPsn/68E3VBluvlquTDL+lyKwYwT1dkMc0w/0avMFiET0qrTtZALyEv6jdW
         Kspki1Ql0EuZax1D14ltQtNtC5HxZZp8CWrivid/mmdPuVgx1EoVggv2Xgz/5k4yQbE/
         AbOkAGenUoe1cI5rvj4izcuDjM/aIZqk5rXXmACD3S3OgCeV/EdX4IBUoOowb5B5bqw4
         B0UVhDm9aeGd938WIIjuU/wzJvgUxYrqZWh+nQPg58jRzKcp3VGIYNoQyCwRNQjEAhLf
         U3sA==
X-Gm-Message-State: AOAM5328bZKWwBQfxSzR/Dq4kdONkgMZ9YvWLeyei57iCRYyfFfePZqn
        ON/xjifZ0WkFbV9Mx/GrZmTTMeJ+28K2CXQd9uJttg==
X-Google-Smtp-Source: ABdhPJz4pxPh/QpYhqQWroVCqjD8qkP+zTAHQjK0xJk01qU38QxLEzkTYdQj0CSNIvDxSBY8ZnaK/mY8EqSOXgGEQl4=
X-Received: by 2002:a05:6402:2682:b0:42e:1c85:7ddc with SMTP id
 w2-20020a056402268200b0042e1c857ddcmr41217043edd.143.1654781670075; Thu, 09
 Jun 2022 06:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 9 Jun 2022 09:33:53 -0400
Message-ID: <CACSApvamXCUBJ_aCumkj5abTwnBCpHij2Gwx514-NyMNqt7Khw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: reduce tcp_memory_allocated inflation
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

On Thu, Jun 9, 2022 at 2:34 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Hosts with a lot of sockets tend to hit so called TCP memory pressure,
> leading to very bad TCP performance and/or OOM.
>
> The problem is that some TCP sockets can hold up to 2MB of 'forward
> allocations' in their per-socket cache (sk->sk_forward_alloc),
> and there is no mechanism to make them relinquish their share
> under mem pressure.
> Only under some potentially rare events their share is reclaimed,
> one socket at a time.
>
> In this series, I implemented a per-cpu cache instead of a per-socket one.
>
> Each CPU has a +1/-1 MB (256 pages on x86) forward alloc cache, in order
> to not dirty tcp_memory_allocated shared cache line too often.
>
> We keep sk->sk_forward_alloc values as small as possible, to meet
> memcg page granularity constraint.
>
> Note that memcg already has a per-cpu cache, although MEMCG_CHARGE_BATCH
> is defined to 32 pages, which seems a bit small.
>
> Note that while this cover letter mentions TCP, this work is generic
> and supports TCP, UDP, DECNET, SCTP.
>
> Eric Dumazet (7):
>   Revert "net: set SK_MEM_QUANTUM to 4096"
>   net: remove SK_MEM_QUANTUM and SK_MEM_QUANTUM_SHIFT
>   net: add per_cpu_fw_alloc field to struct proto
>   net: implement per-cpu reserves for memory_allocated
>   net: fix sk_wmem_schedule() and sk_rmem_schedule() errors
>   net: keep sk->sk_forward_alloc as small as possible
>   net: unexport __sk_mem_{raise|reduce}_allocated

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Very nice work! Thank you for scaling up TCP again!

>  include/net/sock.h           | 100 +++++++++++++++--------------------
>  include/net/tcp.h            |   2 +
>  include/net/udp.h            |   1 +
>  net/core/datagram.c          |   3 --
>  net/core/sock.c              |  22 ++++----
>  net/decnet/af_decnet.c       |   4 ++
>  net/ipv4/tcp.c               |  13 ++---
>  net/ipv4/tcp_input.c         |   6 +--
>  net/ipv4/tcp_ipv4.c          |   3 ++
>  net/ipv4/tcp_output.c        |   2 +-
>  net/ipv4/tcp_timer.c         |  19 ++-----
>  net/ipv4/udp.c               |  14 +++--
>  net/ipv4/udplite.c           |   3 ++
>  net/ipv6/tcp_ipv6.c          |   3 ++
>  net/ipv6/udp.c               |   3 ++
>  net/ipv6/udplite.c           |   3 ++
>  net/iucv/af_iucv.c           |   2 -
>  net/mptcp/protocol.c         |  13 +++--
>  net/sctp/protocol.c          |   4 +-
>  net/sctp/sm_statefuns.c      |   2 -
>  net/sctp/socket.c            |  12 +++--
>  net/sctp/stream_interleave.c |   2 -
>  net/sctp/ulpqueue.c          |   4 --
>  23 files changed, 114 insertions(+), 126 deletions(-)
>
> --
> 2.36.1.255.ge46751e96f-goog
>
