Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CDB545222
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 18:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244601AbiFIQix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 12:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244063AbiFIQiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 12:38:51 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00230105
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 09:38:50 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n18so20672611plg.5
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 09:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tzH4KO5Xmg79pH8VBcjCTysNpRFoMHI2d8K5dxrOVGU=;
        b=Ju2lMFNneLcQNnoj0DK0djALCL6fpRlvOUx7NaKoyVLxLvm6teiu2k6wUQyu33/+71
         SdCx8FoxmYA9rjeWRh62k/rjdcqceNS0FcTs+cOz0ACist2h3/7i/+6yW/0zrQXUtbwF
         0Q3+0f8/LJijqOfAqpUkqJZ+ht0EXklJiE8s8anF5qkqFs7F3urzR4MDTK7I7wd58GDL
         gDlO1aIbZzPM1KXFKH+h7TzRICYclWZSwDv29vXO6eGENLuM51fpdoyuTr1mFnZTPWTb
         /pIFiX6t7qVqG9tH9B3LQZsBfg3RfGXZ8uAwOxoAr086HBsb+fw2FzsXv5Ck5RnlEzB/
         IY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tzH4KO5Xmg79pH8VBcjCTysNpRFoMHI2d8K5dxrOVGU=;
        b=v8leVDaqVTYfCQqPqi3cqzNKgOv9dyn7ngRpd9mMhBNuxRQjmzWjmL2y+fhKLDFOl2
         var76EsBvvCg3552avr+yHswIOOhIAvKF3x6aOaaaYCK39PkbF0tNvtvp0/A1cUqfEm6
         wKPdCNGEgQjBGLHaAyNV6l0hYa5de46qSHkzjRkZtQjc2aPbG6VZ7N5+nrCAXKj8lMs5
         vjfNEH3EVnwTa0aajSFAVk+dw1YnxdF7nYEmXXgLFXnGazeRaSiPy/a/zZ6G89uIpogp
         xBgoF9ieKXQ1XNERAA0v5+EVleIW5q/N2ebdIfvH+Z7XaYlmpwHZqjHfLMakZrZneq6r
         AzPw==
X-Gm-Message-State: AOAM5321j7ZAJAR6gLcJdYHAetthUY48xiZMsVg6XtMawQOIqTpKaFhs
        Y2wzA8MgU4WfnRb97RCo5kvbz53AVeFwXj7jz+fOFQ==
X-Google-Smtp-Source: ABdhPJy7OQkgfqLRBmSyDMR2qY/iTJOsWRFjkgmOoBrv0z5RbdUk5RoXwAuoruNSfkQTMgh2kRxGdXD5XOqPCFqrTtg=
X-Received: by 2002:a17:903:2cb:b0:14f:4fb6:2fb0 with SMTP id
 s11-20020a17090302cb00b0014f4fb62fb0mr39694775plk.172.1654792730302; Thu, 09
 Jun 2022 09:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com> <20220609063412.2205738-7-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-7-eric.dumazet@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 9 Jun 2022 09:38:38 -0700
Message-ID: <CALvZod7hMHkfk+ivUrRHP7ej2Mx7nFQcOSMx00bYq=8qsE=y3w@mail.gmail.com>
Subject: Re: [PATCH net-next 6/7] net: keep sk->sk_forward_alloc as small as possible
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
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

On Wed, Jun 8, 2022 at 11:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Currently, tcp_memory_allocated can hit tcp_mem[] limits quite fast.
>
> Each TCP socket can forward allocate up to 2 MB of memory, even after
> flow became less active.
>
> 10,000 sockets can have reserved 20 GB of memory,
> and we have no shrinker in place to reclaim that.
>
> Instead of trying to reclaim the extra allocations in some places,
> just keep sk->sk_forward_alloc values as small as possible.
>
> This should not impact performance too much now we have per-cpu
> reserves: Changes to tcp_memory_allocated should not be too frequent.
>
> For sockets not using SO_RESERVE_MEM:
>  - idle sockets (no packets in tx/rx queues) have zero forward alloc.
>  - non idle sockets have a forward alloc smaller than one page.
>
> Note:
>
>  - Removal of SK_RECLAIM_CHUNK and SK_RECLAIM_THRESHOLD
>    is left to MPTCP maintainers as a follow up.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

This is a nice cleanup.

Reviewed-by: Shakeel Butt <shakeelb@google.com>
