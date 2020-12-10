Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65492D5820
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 11:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731841AbgLJKUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 05:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbgLJKUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 05:20:36 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075A4C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 02:19:50 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id z5so4906684iob.11
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 02:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I7cheIkDEebliEnqleliGM65RmyLAKIHcPYFYba+v48=;
        b=kqRXushoFGjCoC3WlNBHCOqHTNHk2ZJmXoEOI7gIaq6FMfFUuCMO31ttku/zyXBEaB
         5FZjPBMtIBucOIJXNvUN5cS0pjtWdOjqMmOO4ddDlirOqlBAwPYrbXLporW8lbq4R/gE
         NcZe9LG5LiahywfcmMqoJwbcmq7mypE8+/LZ4A4IibAD3rb0jbskEtVI1U7O2FpowfNl
         K43VQH0lAl3M4Q4HyIJtXP8aK6LXtNs5FTMVPTmhSonN4IKBNKuBY4SFCfXVaFqH5PrD
         kPf7MXvaaO37W20FXVx7izW68jq81PRwRc9R5QqDrzfDZv8ZFXW+RPgkg+FmdP6moR9D
         YhhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I7cheIkDEebliEnqleliGM65RmyLAKIHcPYFYba+v48=;
        b=WzeN9/Egu+ZN6uAJxcip8+WegNfjUJoJuvsn905oPntl9AJRF/k6HSX4Xb1/7SJDyp
         wdJ9nlplRHgZ5xpFFxmyOw9stSVNT7AQ9MYUW+fiAnVliD9RZoa3ZG70XnP2ROyTo6Mg
         n53NdtoeuwU5NLY1s5bn4hhuQhe4U6T6LJfh3JFfXAk4ddOQXP8U2r2e9m9c5cN/MD+A
         JT2KIxFJc82zU7PnLz+w6M6DqIKR9nrZsdSx6Ungb0VD/aqvb2tiUSJzK+LDotCDpO2C
         ip7dawNZlZWxYnEilyR7bFQG98ulfFa8YH6i5YhG6jZI4zFYAcX8Zwa7bat9z594qL1l
         8KCA==
X-Gm-Message-State: AOAM532wcvs0UJIi6hmTrkOV9ZeYxxa4GVVVlqASUIb+/i8kJydK2Egb
        Wpl+UnXBdRm+SMIIg6RPoYtVUGP88LMUWAAwoj2fsg==
X-Google-Smtp-Source: ABdhPJw1NBwZYJbQunI5QZ6uWeX/CNfx0OulhPPNAe5MkJHW44D7RHdm/OGjHMWUMBEDUDgVBOn1JsiUKC+IkVK4ZgM=
X-Received: by 2002:a6b:d61a:: with SMTP id w26mr7839769ioa.117.1607595588821;
 Thu, 10 Dec 2020 02:19:48 -0800 (PST)
MIME-Version: 1.0
References: <1607592918-14356-1-git-send-email-yejune.deng@gmail.com>
In-Reply-To: <1607592918-14356-1-git-send-email-yejune.deng@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Dec 2020 11:19:36 +0100
Message-ID: <CANn89iKW4cLMssB2zi8kvikddVHMXfQLDr9Gkg768Ou3H5VwiA@mail.gmail.com>
Subject: Re: [PATCH] net: core: fix msleep() is not accurate
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 10:35 AM Yejune Deng <yejune.deng@gmail.com> wrote:
>
> See Documentation/timers/timers-howto.rst, msleep() is not
> for (1ms - 20ms), There is a more advanced API is used.
>
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/core/dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d33099f..6e83ee03 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6726,9 +6726,9 @@ void napi_disable(struct napi_struct *n)
>         set_bit(NAPI_STATE_DISABLE, &n->state);
>
>         while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
> -               msleep(1);
> +               fsleep(1000);
>         while (test_and_set_bit(NAPI_STATE_NPSVC, &n->state))
> -               msleep(1);
> +               fsleep(1000);
>

I would prefer explicit usleep_range().

fsleep() is not common in the kernel, I had to go to its definition.

I would argue that we should  use usleep_range(10, 200)  to have an
opportunity to spend less time in napi_disable() in some cases.
