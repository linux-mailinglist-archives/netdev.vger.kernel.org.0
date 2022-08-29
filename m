Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E645A5766
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 01:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiH2XEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 19:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiH2XEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 19:04:04 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5C37FF83
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 16:04:03 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3321c2a8d4cso232918497b3.5
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 16:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VgKmaJrTCTlRH6lbCtDIfR3bgLAZ/TV2yC0AJYMaHsQ=;
        b=HoHxOLd0xZFHarEsuMxuKC0evFLwjIFFz3n1TMPlbAi/qWnCAq46T6y86KAJzuoDzv
         byHkKIdsXqpCY6HrWdG0cMGPDasd3ZC/wfWtgavwgs/mJTv6HjVkKlvrHXoO5YgYrEVA
         CsXs1d2NohDl7aufaA+bqyT66cSfnYVzKlq7zSQiEMtymudNIEbBnSPiAiLwLPzIGvJJ
         lH4kyYiULFam6uh5z4HPUPTlXDBX9U+EadTJ0W1+vRSMEDTR3qjc7Me4p6bBKreSeZWR
         dAmRDGKaQKQJmpzv5/8V9GegeerQ8Sv2syWHo0Wd8KpNqedJiH8xZ3UwFt2SUM1x7lJM
         QPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VgKmaJrTCTlRH6lbCtDIfR3bgLAZ/TV2yC0AJYMaHsQ=;
        b=xT3nxCslmvSvG6YOR5gTTL6X/eLfHtwjRS1fX3+rrTCXwqkxh5o3JLxOg8lhG4/NBA
         5mvCtn+/HuAhbu1SZPqI6WKXCR5FiFnULpRL2B0YwQmYmae3NKaMBbB+lLHtIPkyapIL
         Sp0n/OPR0WW6T+e/LAdGoPKmMaX8xpp776T/IJpxKKOIzv3SPdD9iX9T6gOoEzOzQs+x
         G0cGIebOnA73IqXsDJWhD5yzpxKvbcj7E+Xt/7g9GrmxwY7LF2mvxOfIm9qi5/aZLvbe
         Bore1GJkQkHIgNlXHZ/txaEf5SuJbdWrM1bjBNPIQiSjqydpDrXycL7ISgiqjjMyM34T
         sp5Q==
X-Gm-Message-State: ACgBeo1qlO1J7Sh5BnrFs+g8l594R9fwh1y1/sGLzXub4dQfOJBz22Td
        v8OhIKrgo+rY5G5XEEx1fJyn2pkEeAcU7jicviKocQAvR/Y=
X-Google-Smtp-Source: AA6agR5OslaNJ/n/paBZ8htQZt1nBz4CEh9ttoio/BHxfsZSJO1aQCMUCQ+lG5z8MG5Gnm659MsKcH6NwK97EVfhqDw=
X-Received: by 2002:a0d:dd12:0:b0:340:cba4:e0d3 with SMTP id
 g18-20020a0ddd12000000b00340cba4e0d3mr9000299ywe.278.1661814241740; Mon, 29
 Aug 2022 16:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220829161920.99409-1-kuniyu@amazon.com> <20220829161920.99409-4-kuniyu@amazon.com>
In-Reply-To: <20220829161920.99409-4-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Aug 2022 16:03:50 -0700
Message-ID: <CANn89iL0FpMHZ0YETN8DaO1Tj+P2kA1FBrH+8D4or9M9beqRug@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/5] tcp: Access &tcp_hashinfo via net.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>
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

On Mon, Aug 29, 2022 at 9:20 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> We will soon introduce an optional per-netns ehash.
>
> This means we cannot use tcp_hashinfo directly in most places.
>
> Instead, access it via net->ipv4.tcp_death_row->hashinfo.
>
> The access will be valid only while initialising tcp_hashinfo
> itself and creating/destroying each netns.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  5 +-
>  .../net/ethernet/netronome/nfp/crypto/tls.c   |  5 +-

I would probably omit changes in these two drivers, they look pure noise to me.

It is unfortunate enough that some drivers go deep in TCP stack, no need
to make your patches intrusive.
