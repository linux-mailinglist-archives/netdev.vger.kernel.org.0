Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC7964EC09
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 14:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiLPNXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 08:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiLPNXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 08:23:17 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F058643C
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 05:23:16 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id b16so2388786yba.0
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 05:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h4lhpZBDo1R4CNTkFbNY8L+27rp7sf0rog1QxVqfRr4=;
        b=RIlC2eoA2ZlH2f8/rtXN6202169FQr72BqkelZERocqzF8PcJwLf4RLODvcjCpLA5C
         mLFMIsPiV9B/Z8fUqyy3uRLzZ11aAgz5aRQPuOC+Lmn/HeIyNxLvz/4sf1q97axX5L8y
         Za+r+EwjgXiQ/cTq87b3kdJR63YcTPjIEvIF8bgrZRybmOY3ytfdxq39mxlgT6jaHgUw
         HLVTQTsemjaczGQ382BPN1vXXvIckKPuIqhs9HUkfsEkJNX/VHCTFMr0oRmfyh9czY8p
         /sID6t/ChaLuon3rROrShwAOK3fVNzSIsMNELrqCnzfcwV/WjVuVRICY1BCzWPRvX5L5
         6g9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h4lhpZBDo1R4CNTkFbNY8L+27rp7sf0rog1QxVqfRr4=;
        b=7jzSQN5LMT9yGaA1cN7KRsgTTG+qCH9X2ZEpg8ofwqEGD7Es/QzaUDDj+JE3PUMCLM
         f9gqFmoqMkRrbqI947O1KG6OeANthOeue5UiupK9++WSBpl9rgpjqcQcW/oiZYWU2r1s
         ouxeXx9agLPy9JDkRX8HqdUevGLO9dRHW8hdUk28Pm9iXNcMthyEdyO9cdqR7jtoXOR2
         OVr6U9yCVle17Co+8CfXu+L7vJdZjo6RCsj051l4qzjBFKP6LTorvzUbBSWgD1q0gCuT
         qt6X4vti6YWKFGNfC+7cFqrb7O45VN+Ds/iP/ChetOj18TfPwOvPmfsOpYDflNCjrZly
         qhBw==
X-Gm-Message-State: ANoB5pmLpL2+nLva3FMWkhmgXcBS8kpVUeGOZ95XT7vVgpXkHIyS1Vek
        ELCCGlnJFvNA36ZG46bffaMu0ZodlnwCK7nm4jCftg==
X-Google-Smtp-Source: AA0mqf63QWotY30HaPT/RMsddSTyxGqjfljkcv67paSXUUBWMCBSK7qDv+Lwa4HXK234cN76RjXe97GVTXBVanhO0wc=
X-Received: by 2002:a25:d4f:0:b0:703:8a9c:fd with SMTP id 76-20020a250d4f000000b007038a9c00fdmr13746714ybn.231.1671196995339;
 Fri, 16 Dec 2022 05:23:15 -0800 (PST)
MIME-Version: 1.0
References: <20221216124731.122459-1-marex@denx.de>
In-Reply-To: <20221216124731.122459-1-marex@denx.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 16 Dec 2022 14:23:04 +0100
Message-ID: <CANn89i+08T_1pDZ-FWikarVq=5q4MVAx=+mRkSqeinfb10OdOg@mail.gmail.com>
Subject: Re: [PATCH] net: ks8851: Drop IRQ threading
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Geoff Levand <geoff@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@nvidia.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Dec 16, 2022 at 1:47 PM Marek Vasut <marex@denx.de> wrote:
>
> Request non-threaded IRQ in the KSZ8851 driver, this fixes the following warning:
> "
> NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!

This changelog is a bit terse.

Why can other drivers use request_threaded_irq(), but not this one ?


> "
>
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Petr Machata <petrm@nvidia.com>
> Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
> To: netdev@vger.kernel.org
> ---
>  drivers/net/ethernet/micrel/ks8851_common.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
> index cfbc900d4aeb9..1eba4ba0b95cf 100644
> --- a/drivers/net/ethernet/micrel/ks8851_common.c
> +++ b/drivers/net/ethernet/micrel/ks8851_common.c
> @@ -443,9 +443,7 @@ static int ks8851_net_open(struct net_device *dev)
>         unsigned long flags;
>         int ret;
>
> -       ret = request_threaded_irq(dev->irq, NULL, ks8851_irq,
> -                                  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> -                                  dev->name, ks);
> +       ret = request_irq(dev->irq, ks8851_irq, IRQF_TRIGGER_LOW, dev->name, ks);
>         if (ret < 0) {
>                 netdev_err(dev, "failed to get irq\n");
>                 return ret;
> --
> 2.35.1
>
