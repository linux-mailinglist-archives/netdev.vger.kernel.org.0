Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7A50EF59
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 05:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240279AbiDZDrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 23:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiDZDq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 23:46:57 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313413CFF5
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 20:43:51 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id m128so12720261ybm.5
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 20:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pw9XaY4gtkOrBsspWIgzKqUa4c0Gs0NN9cewAyeRT7U=;
        b=QqPY0jjbokV7X5xDjTwGHnRUOrRbomJ3Oswqvulsm3Kfva0KBi5dBdrCCTz3KVJFdI
         xF6611/TC8rRuKuc5oZp6HnUlLSKTLmE39ikgRhCd7UcdbTxk5W8Y1cdLwDT4z7AXI46
         bWnBywi05i+QVz4hijZQKCI8QJVe60YQCy6yP44jZOOatS2UX717IdTXU61Ht9NPXqvu
         OybI0xU2rMEcZ+3Vhl7hEoNjfqxawiA11ane7FXTh4PFYvojZd9vEWXrijmHKhVXHl4U
         szpvW6Te/Zply4MnJWu3C+qpjwC3ebeOLinAbYSxJjNkJe6539keFH+mKYBxA/dCxX9e
         y6zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pw9XaY4gtkOrBsspWIgzKqUa4c0Gs0NN9cewAyeRT7U=;
        b=7JnqFZIidA19KJy2pN3pxV8RFd/59tP7htlm9h/Spb0P52oooMPwzg6tD8Ovkb5xKd
         QKQp0fE4i0R+dO399EwUu3Gi9qmXHMHJ1SahXJen2kcBfqjkcLZvFr/KEwOuOZ/IHWS1
         v0/In2ue7c2C+OhaJHL5O1z5LW4caSy8wcJIcuHgvSVKOMLlw7FHNGzCKWZl4DnvCh3A
         dyAe7gVHpuydNdyCyOui/Lchtma7AIh/nIvA15KIARYRIkwSwhXOdGHSdG6jsn8MYezr
         j0ZA/HSyxnTiUmpGXtYUg2KYkVTSvoaalp5P6LtbVMg712wx1gUiKnzYwGIaAB7XkQZi
         otcA==
X-Gm-Message-State: AOAM530QqjED45WdCe8kz5HjCybYur/xRAcGvGqnvmpvTlbR/jRk1lSi
        8tw9GeF42lKaEyLH4GLaLOGus1KP5MSPuTjSChgJXA==
X-Google-Smtp-Source: ABdhPJxMho1+tp5v323CP4f7hAg1pyNR31sSvA8BdWru2l9otsnm0SQfjoWexcwE3KK4iOND787GM0du7Pyap5wEbFg=
X-Received: by 2002:a25:6157:0:b0:645:8d0e:f782 with SMTP id
 v84-20020a256157000000b006458d0ef782mr18210702ybb.36.1650944630221; Mon, 25
 Apr 2022 20:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <YmbO0pxgtKpCw4SY@linutronix.de>
In-Reply-To: <YmbO0pxgtKpCw4SY@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Apr 2022 20:43:39 -0700
Message-ID: <CANn89iKkSZ5HR=dmn57Zr4Xs6nH7PNJr+wOBZaXLu+3Lum659w@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: Use this_cpu_inc() to increment net->core_stats
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Apr 25, 2022 at 9:39 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> The macro dev_core_stats_##FIELD##_inc() disables preemption and invokes
> netdev_core_stats_alloc() to return a per-CPU pointer.
> netdev_core_stats_alloc() will allocate memory on its first invocation
> which breaks on PREEMPT_RT because it requires non-atomic context for
> memory allocation.
>
> This can be avoided by enabling preemption in netdev_core_stats_alloc()
> assuming the caller always disables preemption.
>
> Use unsigned long as type for the counter. Use this_cpu_inc() to
> increment the counter. Use a plain read of the counter.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v1=E2=80=A6v2:
>         - Add missing __percpu annotation as noticed by Jakub + robot
>         - Use READ_ONCE() in dev_get_stats() to avoid possible split
>           reads, noticed by Eric.
>

SGTM, thanks.

Note this will cause a merge conflict in net-next

Reviewed-by: Eric Dumazet <edumazet@google.com>
