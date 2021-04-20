Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FC4365435
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhDTIfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 04:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhDTIfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 04:35:01 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2455EC061763
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:34:30 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p3so21399949ybk.0
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CIbDsjSlYNB39lAkXiBh+yh6lGzuFfE+K2GAXvRSiyI=;
        b=UagKz1Qmdu7Q2jsw/lr+lek9ORY3WucgUMgJTMbmlQ2U0hscD+E4At1sbrujKdRowD
         7X3trQLGkBQm2N1wrZnxzZvdp6NbB4Ox/984N8iDCwFYV1nL7ZjkMFT1GIPCoiQnzB2d
         uJk5/6mVWzJHMjDW72KFUaJ0B+ZoQFuIcJbfidbR1x9QqTe5AHXogeUhZ4Y+KG0OdU+K
         PhYQ7QqVcH6G8SfLM9vRvjUc/Q9X5cjuIf5xav//VhU1YzPGMMFOwOrIl02TZ786Kdqe
         QPPU3xBMhotzf7RhfN/AMqz1JwhJJ0SZmCcpo/GXj24abZ9gSRgcXiSp78h91/loFVjl
         Dpzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CIbDsjSlYNB39lAkXiBh+yh6lGzuFfE+K2GAXvRSiyI=;
        b=BgSj4BG4EwB5bMa/dIULYT1kdLZPz7iRATsdyVsEdaEYRzm9TpYdij2B5Zzilyx7Zl
         vj0gU0oWPNGPoGwD0lSJrj0v/aa53KVuf9sgEpdsNaiX/Yof76OCFCRVL+3cDQrxqvII
         P9UgSFA98Lb36B+LlIKBq2CXMaU8jEfrphkgv/2h1aH24H9e6Qysn7aWXgE+COuPthTP
         bMSAI3+V/jfPtC0pZ09gA58voM5B7jkibsQv9itAPWlCaRRDec+DodLWmq30TQJCdG0u
         z2CdqS+IQpLm+sbKVPOPXnV+ewraWg5a+yrfJeySxrmQn7YxllMxervYrxZGaqjbLNU8
         KZjw==
X-Gm-Message-State: AOAM531lrHCdoUqoFIVCXeLHk5CqGNdhRs7YcUeOXHZXwrhb60PVVLvU
        b84hfgm9INYvgxY9gSUaWii6+Ex2oyJu/pj8+WK2mQ==
X-Google-Smtp-Source: ABdhPJyfIpao9HMJFv/llAEFc3oqElsajPNf7GfYDz0tkJQWODL4BNlANI60ZRFNj43qwv4kk+DN8u5uVwrD70ZjjRg=
X-Received: by 2002:a25:7650:: with SMTP id r77mr24388590ybc.446.1618907669051;
 Tue, 20 Apr 2021 01:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210420075406.64105-1-acelan.kao@canonical.com>
In-Reply-To: <20210420075406.64105-1-acelan.kao@canonical.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 20 Apr 2021 10:34:17 +0200
Message-ID: <CANn89iJLSmtBNoDo8QJ6a0MzsHjdLB0Pf=cs9e4g8Y6-KuFiMQ@mail.gmail.com>
Subject: Re: [PATCH] net: called rtnl_unlock() before runpm resumes devices
To:     AceLan Kao <acelan.kao@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 9:54 AM AceLan Kao <acelan.kao@canonical.com> wrote:
>
> From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
>
> The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
> __dev_open() it calls pm_runtime_resume() to resume devices, and in
> some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
> again. That leads to a recursive lock.
>
> It should leave the devices' resume function to decide if they need to
> call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
> pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().
>
>

Hi Acelan

When was the bugg added ?
Please add a Fixes: tag

By doing so, you give more chances for reviewers to understand why the
fix is not risky,
and help stable teams work.

Thanks.

> Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> ---
>  net/core/dev.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1f79b9aa9a3f..427cbc80d1e5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1537,8 +1537,11 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
>
>         if (!netif_device_present(dev)) {
>                 /* may be detached because parent is runtime-suspended */
> -               if (dev->dev.parent)
> +               if (dev->dev.parent) {
> +                       rtnl_unlock();
>                         pm_runtime_resume(dev->dev.parent);
> +                       rtnl_lock();
> +               }
>                 if (!netif_device_present(dev))
>                         return -ENODEV;
>         }
> --
> 2.25.1
>
