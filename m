Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EF64B7B7A
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 00:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241468AbiBOX5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 18:57:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234732AbiBOX5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 18:57:13 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8543BC9A06
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 15:57:01 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id l125so1014430ybl.4
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 15:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/NP6Z6/hlYOrhNgIGOS33+EhMJ6LQtX+3TEJ8bLSnPQ=;
        b=Nsj4v5aH8kFldsGUydi/EFcquGGMyCk+5nrFQHS0YeLUeqPN1yZLlanRtYtxJgXK+p
         3Upf2mWOiERKeIje/VBsdHXZaQ/6DkaISDR4S+XaZ7Rt/JBHZPpNc0WlCSWqeSY7qfSf
         yhZwrcHlnKQYOsU9nFGxwHi4jLbaBpFL5jzM4fBJtNGGFczztxZvfzIsOE9cgaTJcPtj
         LHEZ8GHXVNAYNI2ud5ztBMRBMLtMVXNcWx1sxa+q2yQUis/0M8aEDwft2tizI07+4i2x
         SxpZ4foQo1+6pJCpn0fAiD+vcgs36rhtSpASBKTMSASVy8mZ5Djc3cFGVvw1RKbd7L25
         SoQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/NP6Z6/hlYOrhNgIGOS33+EhMJ6LQtX+3TEJ8bLSnPQ=;
        b=aDUoJV7pIogfWfkQladH2TE1fzGPtKEyOq4IbeQ/CnaTXlo7csWRilofH4tWloPl0/
         ZODJpfjDng/fKC72VYaxO8MxnpoPglZh0va/fkq8vKH+mXL8Bk0aU25hO5RGFB4WaOe4
         T3tgJRKK3CgY2meoAV4Q3Jad8S+av0iw5ALd5oE+4gDuqcivlVQGRjRIUER5YxJzV/Iy
         ieF6vA5ZK90pXmJ1evpQkjyG+Cx+2sAvG3mpoEf6cMdf9vnEqrHl9jBuaSyB3qIA4jgP
         lynWQhm0JD2lcy9TwRIz0OhMy3F98Hewyqs3Z8cGj0yK7VFHw+VJQNql8o9iH4eb7G41
         gFgQ==
X-Gm-Message-State: AOAM530xE1G/8xYBB8HuNSbKtA9IFkp09Ahwb6oc5lHufezELir16fAp
        ksC7TDrOlTWM5qjog6nOzFpvKhYeM+FRILrkhB2sTw==
X-Google-Smtp-Source: ABdhPJyQctpvdGqO8cF4/tMKkDKnuT53rSbMw9fDUn7ldjgyIFUtcFR3GEGGkC0+a1al0u0TV5m3EF53WVHQW16AAms=
X-Received: by 2002:a0d:dd48:0:b0:2d2:58cb:d6f5 with SMTP id
 g69-20020a0ddd48000000b002d258cbd6f5mr192387ywe.47.1644969420425; Tue, 15 Feb
 2022 15:57:00 -0800 (PST)
MIME-Version: 1.0
References: <20220215225310.3679266-1-kuba@kernel.org>
In-Reply-To: <20220215225310.3679266-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Feb 2022 15:56:48 -0800
Message-ID: <CANn89iJfLfpYWnvUUkda2-zXEdJkCu4ziaDN7wQyeEDA4t-pPg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: transition netdev reg state earlier in run_todo
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Xin Long <lucien.xin@gmail.com>
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

On Tue, Feb 15, 2022 at 2:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> In prep for unregistering netdevs out of order move the netdev
> state validation and change outside of the loop.
>
> While at it modernize this code and use WARN() instead of
> pr_err() + dump_stack().
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
