Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D0456BDE2
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbiGHQAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbiGHP74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:59:56 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB636D57F
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 08:59:54 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-31d27fd3d94so13502667b3.7
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 08:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4NendIC621xj3iQYizGxpn258Ho855dwI2nHoue+ZYE=;
        b=rS6f/sHValfYK3dmNXOYu5OYaivgTd+soZUla++v2y3ctyJO0MHozQnm8likmnAubW
         jrnns+2yiVuvps/i3LIiPj5nKhuftgiBidQlqO+SEGmy8NgktJy4H0WpUMqDKQhrzaDC
         VhuwOVn2t8Gs6b8wuxnhh8tgMWTDuAGULsBLCfv8ydjsPXLe/C1nthBbG3Y1ePFisPok
         0488uCQKudqM1PDjDjS47fRosEyj3GoLq5ZD/q3YPiKqDzMdCnRNZq6v/6RVaoiYiRFt
         gL75agVF0IAycaA85ZWJ1x7gdAd+FQOwUHA17ZkbD0hQ61GH74CxjLTB7puL2o2G1Kve
         UNQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NendIC621xj3iQYizGxpn258Ho855dwI2nHoue+ZYE=;
        b=6kc2Of0MI7NEMXL8RyqnolvHtmilGAiv2hYbau3VhNsiqyGvtaswj0cg7lsLzuLGd5
         8Aoh6nlooZ6tB6AuBYJXfU5xih3z/2dFPYf4+z5ov0RqC8DOuVzvJSbYkjSjXBKWb2bp
         U4to1fMe1astzIB3sz1AVNy8Fwoy53b9ep731YKEfFyPlSoGTn/yv0unH8PxUpUUUo02
         pSgTSNMe79NwWTdI739sqDM9lxQZ/zOoQoOnxCN3pWmL0lgKkonAqJLm423S89IEK7h4
         rRJN8aKKJMoKhily0oyJ+u0bMFJdl3brQrcoJ3b9escYFugvRqr3f13Z/3zmZPBrHcuj
         iSZg==
X-Gm-Message-State: AJIora/U1q2kiBO9E+GDDKkUIIxcgecNBpxEB5IJTfKQ15YFwifQ3E6D
        g+ATKjthDl9XNKYxt5KTiZJ70QmNrlE+QYzjP81S7A==
X-Google-Smtp-Source: AGRyM1uQ6I08lw91qBfU7T0gsI+hb6R0BM6xRQ4gU8Vc2NzG+zWBNoD0OButdYSj2THnEFS7pmcYHb3KMcQ1B4NpMCg=
X-Received: by 2002:a81:7996:0:b0:31c:96d1:746 with SMTP id
 u144-20020a817996000000b0031c96d10746mr4800074ywc.467.1657295993339; Fri, 08
 Jul 2022 08:59:53 -0700 (PDT)
MIME-Version: 1.0
References: <OSZP286MB14047FAFB44F13D76137DFFA95829@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
In-Reply-To: <OSZP286MB14047FAFB44F13D76137DFFA95829@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jul 2022 17:59:42 +0200
Message-ID: <CANn89iKB_kQ=VKO39H4SDhPrE+-cF5FWD_O8qe5RmxJMZ7vwHg@mail.gmail.com>
Subject: Re: [PATCH net] pktgen: Fix the inaccurate bps calculation
To:     gfree.wind@outlook.com
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Gao Feng <gfree.wind@gmail.com>
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

On Fri, Jul 8, 2022 at 5:14 PM <gfree.wind@outlook.com> wrote:
>
> From: Gao Feng <gfree.wind@gmail.com>
>
> The prior codes use 1000000 as divisor to convert to the Mbps. But it isn't
> accurate, because the NIC uses 1024*1024 from bps to Mbps. The result of
> the codes is 1.05 times as the real value, even it may cause the result is
> more than the nic's physical rate.


1Mbit = 1,000,000 bits per second.

https://en.wikipedia.org/wiki/Megabit

Current code is right IMO.

>
> Signed-off-by: Gao Feng <gfree.wind@gmail.com>
> ---
>  net/core/pktgen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> index 84b62cd7bc57..e5cd3da63035 100644
> --- a/net/core/pktgen.c
> +++ b/net/core/pktgen.c
> @@ -3305,7 +3305,7 @@ static void show_results(struct pktgen_dev *pkt_dev, int nr_frags)
>         }
>
>         mbps = bps;
> -       do_div(mbps, 1000000);
> +       do_div(mbps, 1024 * 1024);
>         p += sprintf(p, "  %llupps %lluMb/sec (%llubps) errors: %llu",
>                      (unsigned long long)pps,
>                      (unsigned long long)mbps,
> --
> 2.20.1
>
