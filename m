Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54F34A8C38
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353699AbiBCTI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353692AbiBCTI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:08:28 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FD4C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:08:28 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id m6so11855808ybc.9
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 11:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HhQVk/sLxRXOEI9evcllHDm7paO+jN/OPdWBwIZ+7D8=;
        b=JyRKa4t7QmXvozkwhTcCxOVonNzLorj0WDkJlsRJ1ayHqvqlAQsuqnF6DvR5iTa8Mx
         vHdMLmYgi4U4PhdAGqKJuSW8kl0LswhY71yA/Bu4ExbMaiEC2gaNhO18ZwP5BeENXdma
         +wbN099OV5O5la3JhAStxlwR03vyEffNGI1HkYEflzVZPnI5Rc6kVGFYniJk1tNlRpfz
         xwllW2qHuscQO+YRwV//GCwXbd0d54pmeHlRbJTbUYtSznZPVldSFgGRoiHiWZNQic0J
         AtU79cgTlxCVLYmhx0THL9flDBP6lQYWfhIlD+h7Ungvio1IVpaWKUoMQGnltjMPZEyx
         TZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HhQVk/sLxRXOEI9evcllHDm7paO+jN/OPdWBwIZ+7D8=;
        b=y70xZSGxxT4Jx6WXCITZQhVjjBrSlGQ4JcaykCNoaatR45f0HNPDyBsmBK0X7VRO+2
         /gS3UAPPsxw8lJILZpCwp6AZ1OYK7GYld0xcjDnJztfryUp4hveTU0tcPUZQQAI+9XLa
         qJaofqEEd5nIOksWvEbt7LjxHp8Fbn7O5C3kAaQ3RpjadS55ZIn9ZirE8X5oRO8q7+FD
         Gfnq3bGa8OgxKBGnbieC+atP+rJG6XKCfTxLDp++0L74mGvrccG1RyYAEV07qe92KMiy
         SpOqa2jIZI/lOhA0o+oBL9/3NAwmAZtdUc9YDoeCmp7abmXy8t8zis/oUeaUeC8DGVRj
         aSDQ==
X-Gm-Message-State: AOAM5321gkkRN5htGT8VrFu/WPbuqFdtyqYOGBDI0meSM+TJuCb5cG9A
        1swzRYKR7iYa+k9vQe2mkeKktHYFmNqfj+wFjTDtHg==
X-Google-Smtp-Source: ABdhPJw35hai09aXsHhp1tY3X5aKFrNc8ff8Ls3W6TwbuFTRsIjpS6Pbcahkv1PAQrBEsigfFsPCu2N8r2G85g9W9aw=
X-Received: by 2002:a25:d9c2:: with SMTP id q185mr46244648ybg.293.1643915306969;
 Thu, 03 Feb 2022 11:08:26 -0800 (PST)
MIME-Version: 1.0
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
In-Reply-To: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 11:08:15 -0800
Message-ID: <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed after
 scheduling NAPI
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 11:06 AM Yannick Vignon
<yannick.vignon@oss.nxp.com> wrote:
>
> From: Yannick Vignon <yannick.vignon@nxp.com>
>
> If NAPI was not scheduled from interrupt or softirq,
> __raise_softirq_irqoff would mark the softirq pending, but not
> wake up ksoftirqd. With force threaded IRQs, this is
> compensated by the fact that the interrupt handlers are
> protected inside a local_bh_disable()/local_bh_enable()
> section, and bh_enable will call do_softirq if needed. With
> normal threaded IRQs however, this is no longer the case
> (unless the interrupt handler itself calls local_bh_enable()),
> whic results in a pending softirq not being handled, and the
> following message being printed out from tick-sched.c:
> "NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #%02x!!!\n"
>
> Call raise_softirq_irqoff instead to make sure ksoftirqd is
> woken up in such a case, ensuring __napi_schedule, etc behave
> normally in more situations than just from an interrupt,
> softirq or from within a bh_disable/bh_enable section.
>

This is buggy. NAPI is called from the right context.

Can you provide a stack trace or something, so that the buggy driver
can be fixed ?

> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
> ---
>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1baab07820f6..f93b3173454c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4239,7 +4239,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>         }
>
>         list_add_tail(&napi->poll_list, &sd->poll_list);
> -       __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> +       raise_softirq_irqoff(NET_RX_SOFTIRQ);
>  }
>
>  #ifdef CONFIG_RPS
> --
> 2.25.1
>
