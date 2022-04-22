Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F216D50C2DE
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiDVWRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiDVWP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:15:56 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C746431D433
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:06:52 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2f7c424c66cso6321347b3.1
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cD3R8slEWMDSGe90xYS9hNLNeTH/HZQPgKab/B2ytDk=;
        b=tZQCS8sz3pCoI57PtUtAqQJEJnFrhfHQagdlQ2pm1jC+/E7v+xI89uN4BWAlZdRxRY
         oFS4t0r2YO6cuKyNN/tCM4udz6b6mF93Tfuw1FW327NgxVPMfgFyyTcBs73/dxpNO9ax
         te88FJTd+ikCaZc4N/p2o0KJub/DINpNMcfDJM+qKnmmjLvz+EoeVkhiaqJJHWeblImr
         U9+HiHFXbGbk4+Rc9J9wusTS4F9Qp97U+yQ1N9GaUkoYCO32XeLk1v1FgWoBnoAPcbYH
         0iVlSgt/3XCZHS/TQmfjpDxmWHunkCjcSltWkcSEngr3EznBQCslwHgyp83FDEi1GT0y
         2BbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cD3R8slEWMDSGe90xYS9hNLNeTH/HZQPgKab/B2ytDk=;
        b=cMqEgtX23awx8qUXM6xhPaG7IwGJghvtgI7p/Q+fJ0+py+n046qMic+qb7QGYjVbqS
         Bwo0oivc8s2JcbqPNU4r9pxV7P1f6kdFZ5nt4hQqjCaYgfEAwfgKrq05/gc+wVwMdcuz
         V+gg0iaapOKbTWQMvpk2rhMoqnDn6wZiOyMyU6YnJrWoyn+L+0hwRhNA5MR7BdEjzVYX
         MFMh4tn+sbfHKtk22cgxh4fJND01/Xr7OnQSTUNORkpu2QhLWPDdbYDrvKx6Qf3p53/5
         yI/Ue2Eh2fcVIGZuzO0FfWl37dx1Xp7RKCw41q0GQwNCuXFNocM1Hw1UJHPUgZgXUPyi
         KMYw==
X-Gm-Message-State: AOAM533jiKgdqb5mri7SLLKFxKg9fgiHqXHUzBP53rZZBKXnW5bq1ZDU
        e6E5/cZKcdHu2Um1tbZ/ilzXv8i4ys/isdd0Vd8zrOK47kAWsQ==
X-Google-Smtp-Source: ABdhPJzMMTzrRt/kvxLCocOgfY0mjb/wTw+gsErD8Nh8k/ldnRRiNSsVTk/9vGchG3wnGWRflWuHwa06pDOTsryziJk=
X-Received: by 2002:a81:753:0:b0:2eb:ebe9:ff4f with SMTP id
 80-20020a810753000000b002ebebe9ff4fmr6486884ywh.255.1650661611721; Fri, 22
 Apr 2022 14:06:51 -0700 (PDT)
MIME-Version: 1.0
References: <1650422081-22153-1-git-send-email-yangpc@wangsu.com> <20220422133712.17eebbcb@kernel.org>
In-Reply-To: <20220422133712.17eebbcb@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Apr 2022 14:06:40 -0700
Message-ID: <CANn89iKz+vZ5=3UjbK6ZeWK6RJ+Q5grmTK8Rx+hbhzEMY=g6GA@mail.gmail.com>
Subject: Re: [PATCH net v3] tcp: ensure to use the most recently sent skb when
 filling the rate sample
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pengcheng Yang <yangpc@wangsu.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
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

On Fri, Apr 22, 2022 at 1:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 20 Apr 2022 10:34:41 +0800 Pengcheng Yang wrote:
> > If an ACK (s)acks multiple skbs, we favor the information
> > from the most recently sent skb by choosing the skb with
> > the highest prior_delivered count. But in the interval
> > between receiving ACKs, we send multiple skbs with the same
> > prior_delivered, because the tp->delivered only changes
> > when we receive an ACK.
> >
> > We used RACK's solution, copying tcp_rack_sent_after() as
> > tcp_skb_sent_after() helper to determine "which packet was
> > sent last?". Later, we will use tcp_skb_sent_after() instead
> > in RACK.
> >
> > Fixes: b9f64820fb22 ("tcp: track data delivery rate for a TCP connection")
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > Cc: Paolo Abeni <pabeni@redhat.com>
>
> Somehow this patch got marked as archived in patchwork. Reviving it now.
>
> Eric, Neal, ack?

Oops, right, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
