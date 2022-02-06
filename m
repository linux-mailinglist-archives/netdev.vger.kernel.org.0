Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D88F4AAFEE
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 15:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbiBFOZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 09:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiBFOZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 09:25:36 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C83BC06173B
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 06:25:35 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id 124so32467268ybw.6
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 06:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ROcWyeanlDCXIhtW9/zIuFZCmrGTU94//EL0HGyKnKw=;
        b=JiKbFBjI2L2J0kVk1oNwGVbiIEfVR179fx6Y9kuoWeS5qOqI+SmaC9rDGRCuXGYtE7
         DHZzmRCeUSHWQtmgzF4iHKWN6Y6kVFbqJX1jWF45zEbdZ0fVC977lleVxDqfDKZbnbyU
         JKAC+XPJiEZJIAUmBZLN3d/zO0PKkz02vspisASHgjcRanybZ+SjxSsJ6ghztt4YBEmW
         Fs5hiUgG+wjEnE8WRp4Hz5aScafxQ7V7BBtecOuxLYDUTNCOfL2Y/QS+0He61oIVghvV
         qgTXoz9F4qkna1PcKL1mDKN/yiimqAQN28m1AJ0cBuw7OotcvDK38bC2EuEEYuK85KwO
         qUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ROcWyeanlDCXIhtW9/zIuFZCmrGTU94//EL0HGyKnKw=;
        b=yTNJI4g3t2i5A1tD3gVr+TYgKc1lzAzCPPwfaLRnXcBWmjdYTzuNzcH99LIOiWUyja
         d1JMpHCXLyy17DBeMJ6zXu6szkxN2NLxj02tl4q6c4kNcRT9Hetg3PdcR3R8nZiF1ETW
         kO0aLIoO9Ieh8fWlzkhKcIK42BO5qx6qEkogDLLUs/pib8HcQ2km9U+LI+qHquMcb40w
         md+rnE4tQZtlBfSjj1R0pWKbWcZnJwhEcN66pwEIFB0zRVZmo353eiBB3TITac4hifq7
         K6E7oX667JpG4Fl/tfrhszu5vZJB/jy/MY5DyLiDvTF3ksK7EKvDm4OR+LOCxD97oVnL
         5o7g==
X-Gm-Message-State: AOAM5314NCuRQqf2vp+BpWM3W3+DjnGz+ay+egH/sYQnH+4OnIUs9Qvy
        Y0jkKOH8q3IemXBll8ToitNOcUrVoMwfvlgejUKgSg==
X-Google-Smtp-Source: ABdhPJyS13ZwP7nPfzXJ1iFAUxtBUiAqP8Mu9/UE8ImL/jNTwr5OQeu8U/CbE525cT698Fa84i1x34FftwXLZZZ72MA=
X-Received: by 2002:a81:3593:: with SMTP id c141mr6132545ywa.73.1644157534221;
 Sun, 06 Feb 2022 06:25:34 -0800 (PST)
MIME-Version: 1.0
References: <20220206050516.23178-1-eric.dumazet@gmail.com>
In-Reply-To: <20220206050516.23178-1-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 6 Feb 2022 06:25:22 -0800
Message-ID: <CANn89i+su4aEk8HYZwEWyub80WMAq61hYrOzvfHV6OpQVhu7Gw@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: fix ref_tracker issue in smc_pnet_add()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
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

On Sat, Feb 5, 2022 at 9:05 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>

>
> diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
> index 291f1484a1b74c0a793ab3c4f3ef90804d1f9932..fb6331d97185a5db9b4539e7f081e9fa469bc44b 100644
> --- a/net/smc/smc_pnet.c
> +++ b/net/smc/smc_pnet.c
> @@ -368,9 +368,6 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
>         new_pe->type = SMC_PNET_ETH;
>         memcpy(new_pe->pnet_name, pnet_name, SMC_MAX_PNETID_LEN);
>         strncpy(new_pe->eth_name, eth_name, IFNAMSIZ);
> -       new_pe->ndev = ndev;
> -       if (ndev)
> -               netdev_tracker_alloc(ndev, &new_pe->dev_tracker, GFP_KERNEL);
>         rc = -EEXIST;
>         new_netdev = true;
>         write_lock(&pnettable->lock);
> @@ -382,6 +379,11 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
>                 }
>         }
>         if (new_netdev) {
> +               if (ndev) {
> +                       new_pe->ndev = ndev;
> +                       netdev_tracker_alloc(ndev, &new_pe->dev_tracker,
> +                                            GFP_KERNEL);

Oh well, this needs to become GFP_ATOMIC, we are under a write_lock() section.

I will send a fix :/

> +               }
>                 list_add_tail(&new_pe->list, &pnettable->pnetlist);
>                 write_unlock(&pnettable->lock);
>         } else {
> --
> 2.35.0.263.gb82422642f-goog
>
