Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6854B13B0
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244539AbiBJQ51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:57:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244450AbiBJQ50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:57:26 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD03104
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:57:27 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id p19so17269100ybc.6
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LzombJHfUaPY76B25DWEwD4zN/2+cpMugOK4+oRxx4s=;
        b=Ma1Ny/CQLT9HVSmpavyVelVoPLe0YAsclRDFXwv/8e6TGUEr7yseDC/Twq4HWKIyxF
         aX8ZEUFb8W8YTUeqwa7gEt0PcjimuGRFEcElD//GknAssyLo9AZJ6uqNCiOXuelU8wLS
         F6tewGXk2+zV9/StUwHrgqPW1Xw7N0MmpxMPRrUWC4n+cSrd8HXFyoAsQOAJ9q2UICig
         LyVk+wenlabxhvayL1LH4JUUaIEPXNtYOySLdEup1fUCYmFKMdtMzc39oJ5PACBI7kEx
         YFs+mcCml6O7FCZ2VYqDIftupvZqpJQEfegRgOwmWoXY43/TQ8Wa7DwYwoYs3fJ8Uj1f
         5Qgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LzombJHfUaPY76B25DWEwD4zN/2+cpMugOK4+oRxx4s=;
        b=RUxBXsvjx0eAL39IzhuKJ936p85rMf+EksS5heoC6fiRQCEO8WcR9M7XeBehskoUhg
         x93iUWz+fTTckh0rtfu6GR5b+Jq+hofcZR7Vxljz9QBY4dSMHBJGum/PRwSGArwwgw4t
         d9YzjFfPkzZdv/H1/i8XIQJx+xTl5E2gHMOH68BiRWY3ETGn3XplWjB/tUigCEGq+8hQ
         DToqX17VLoHY0vl7LoDE4oWtdoGf0x/phQxQiYBLEh+cxFR09X5TUkPNqnKcgOlIWfyA
         xKH6MYFUskYJqsqK8F92E8tRxLJwC2GD3Oe++qdDAQztksK7kLZPEF7TP7iwTRJg79Tx
         t36g==
X-Gm-Message-State: AOAM5322CM+zru+qrtd7kmFM9FBZdOD69aqiTHF/3MbYV14wUpArKKST
        AwoDO3ic5/+hJrVmx6h1Y2MhMh0FGq6XYSqwXo50Og==
X-Google-Smtp-Source: ABdhPJzHk0q53Nu+3WRHfU8m7ClASRJfWhAetIVmZmusv/PuqX6gjXBYwDdt6rVqggIc6gTMGO3ezcmjg9ITNI5p/1A=
X-Received: by 2002:a81:8742:: with SMTP id x63mr8006680ywf.112.1644512246560;
 Thu, 10 Feb 2022 08:57:26 -0800 (PST)
MIME-Version: 1.0
References: <20220208232822.3432213-1-eric.dumazet@gmail.com> <18d9bd16-a5f9-b4b3-d92c-4057240ad89f@gmail.com>
In-Reply-To: <18d9bd16-a5f9-b4b3-d92c-4057240ad89f@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Feb 2022 08:57:15 -0800
Message-ID: <CANn89iLFhSr6PQwSTixVitgaRQi3=xtLm3dCUY2d5nOyxMDQng@mail.gmail.com>
Subject: Re: [PATCH net] veth: fix races around rq->rx_notify_masked
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
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

On Wed, Feb 9, 2022 at 4:36 AM Toshiaki Makita
<toshiaki.makita1@gmail.com> wrote:
>
> On 2022/02/09 8:28, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
>
> Thank you for handling this case.
>
> > veth being NETIF_F_LLTX enabled, we need to be more careful
> > whenever we read/write rq->rx_notify_masked.
> >
> > BUG: KCSAN: data-race in veth_xmit / veth_xmit
> >
> > w
> > value changed: 0x00 -> 0x01
>
> I'm not familiar with KCSAN.
> Does this mean rx_notify_masked value is changed while another CPU is reading it?
>

Yes.

> If so, I'm not sure there is a problem with that.

This is a problem if not annotated properly.

> At least we could call napi_schedule() twice, but that just causes one extra napi
> poll due to NAPIF_STATE_MISSED, and it happens very rarely?
>
> Toshiaki Makita

The issue might be more problematic, a compiler might play bad games,
look for load and store tearing.
