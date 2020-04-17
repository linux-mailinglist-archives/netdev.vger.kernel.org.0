Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4542B1AE88A
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgDQXOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgDQXOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 19:14:23 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF54C061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 16:14:23 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a9so1896693ybc.8
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 16:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kl4sKIGpTch0wUD3xMnGE+IhezIk5HUZGA7spdAWkMI=;
        b=DRbOaaiTgpkQb5vkczK5t1uQr9MJ8XfSo2jX8GL739vHp9dqiZHqlRuxBOiuhaGgez
         5t2/hjx+GTluljxRmtycFcXo0nJZGRk5008a+BvNgbpPuuoXBDlI5ZWdr2uDWFNNOlD2
         diOmXtlsX/HThO0HQ65snDritIM5S/zB5qukghxdpx/Bu1ycIIVSIGHVqDqJGKSW1zqL
         t1MwOjp4e00SYzMJ2klJ30AZ5rdCwY16IV6YjIBeeUtbcRFhz1i286E8QY7LEhvkJIYm
         VQmjTOAJq9SLVcCYx3ECWqhILekWBGxPe/eFrd4dyHCi2f2FGuDp1lC1bZO1OVhHyPe+
         xvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kl4sKIGpTch0wUD3xMnGE+IhezIk5HUZGA7spdAWkMI=;
        b=qwVckoeDk10VS49gjiLZe1CFCLXpsWJk4eCd1sTtVeifnK2WJq05taFaFfgjOvV5U+
         OOOVARj98rFB8woTd5ZzXHBP0p9KQJlkq4AjAnpPm8QWbhVTfSrQ8SplOOZUKQDq4d0r
         U37lQI3IBAHJcx396ZabAYb6daBDAXy2e/ek95k3l58pNA7Wd/0dTiosM+Cmogg1qqrL
         +HZwOetdYnBlUYmLuW9v21OBtuG8s7UVGgg6gUmcyGc72ucTMdxbFmnhkoE2BZoqZMHX
         WE51Az53yTCcEEDYP72OdPcvAAO13yS8OCXCga17oCDuwWOhLpOdIRuxhpmpWimEH+as
         7SCQ==
X-Gm-Message-State: AGi0PuYECgoIFDeyr7+FmX8u2YuwL1sEYuv40O5wW3/V2nkOImWu88kY
        sCUipBp7t/wbazrguA83s/XpQlGDoJi+l48MvLMLeQ==
X-Google-Smtp-Source: APiQypLOE9U/wxaliO5qhs36jTys1i1tJ0Bq0u07lxnN/eX+P5gMHBsDecE5SVVTmZV/o8WLDnrywfuv7d4v/N7gZ+U=
X-Received: by 2002:a25:71d5:: with SMTP id m204mr2199552ybc.101.1587165261915;
 Fri, 17 Apr 2020 16:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200415164652.68245-1-edumazet@google.com> <761fa4422e5576b087c8e6d26a9046126f5dff2f.camel@mellanox.com>
 <CANn89i+Vs63kwJZXXHTvhnNgDLPsPmXzJ99pSD5GimXd5Qt0EA@mail.gmail.com> <05bc2889c7ee8be8e33dcf635b85c237927317e9.camel@mellanox.com>
In-Reply-To: <05bc2889c7ee8be8e33dcf635b85c237927317e9.camel@mellanox.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Apr 2020 16:14:07 -0700
Message-ID: <CANn89i+TZYsMojXinu7toMMUCzWvg5_yvqeX8V1tY1hd8fD-NQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net/mlx4_en: avoid indirect call in TX completion
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemb@google.com" <willemb@google.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 4:02 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Fri, 2020-04-17 at 05:09 -0700, Eric Dumazet wrote:
> > On Thu, Apr 16, 2020 at 8:55 PM Saeed Mahameed <saeedm@mellanox.com>
> > wrote:
> > > On Wed, 2020-04-15 at 09:46 -0700, Eric Dumazet wrote:
> > > > Commit 9ecc2d86171a ("net/mlx4_en: add xdp forwarding and data
> > > > write
> > > > support")
> > > > brought another indirect call in fast path.
> > > >
> > > > Use INDIRECT_CALL_2() helper to avoid the cost of the indirect
> > > > call
> > > > when/if CONFIG_RETPOLINE=y
> > > >
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > Cc: Tariq Toukan <tariqt@mellanox.com>
> > > > Cc: Willem de Bruijn <willemb@google.com>
> > > > ---
> > >
> > > Hi Eric, I believe net-next is still closed.
> > >
> > > But FWIW,
> > >
> > > Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> > >
> >
> > Well, this can be pushed to net then, since this is a trivial patch
> > that helps performance.
> >
> > With this COVID-19 thing, we need more capacity from the serving
> > fleet
> > (Youtube and all..)
> > distributed all over the world and using a high number of CX-3 NIC.
> >
> > Thanks.
> >
>
> I don't mind, either net or net-next is fine by me, up to Dave,
>
> although we are missing the Fixes Tag ..
>
> Fixes: 9ecc2d86171a ("net/mlx4_en: add xdp forwarding and data write
> support")

I chose not adding this tag, because at the time of this commit,
we had not yet the INDIRECT_CALL() infrastructure.

I want to avoid requests from stable teams about backporting too many patches :)
