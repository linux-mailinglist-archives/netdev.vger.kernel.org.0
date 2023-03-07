Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358186AEF04
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjCGSTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjCGSTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:19:17 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590FD9CBED
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 10:13:39 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id v101so12327148ybi.2
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 10:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678212818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sH8Wy2Ph761evbKn3y8LG62Tu+KFGePC7gyj4o8USOA=;
        b=UP+9D9GXzLCgcmXQGGP3q3C7u1PkefkqLS6Z1ClEa+/CqKo0BvvfXz/JK/Q5wudRSn
         1yp2x3C8D6SoTMFYgu48Iiw0jbJTYQ+FdXJI5zrU2mZouLp25QtUpORoSQxRMiLFiS3W
         oqykigITON7KiL+ujyvz4/10HWi1gjPYtlHzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678212818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sH8Wy2Ph761evbKn3y8LG62Tu+KFGePC7gyj4o8USOA=;
        b=yepj1LBihHePzoUsrbj9OmeaDRmUbsr7uJZi9dbI7Nos19qEjacxOGsL2guxH0+jVp
         lD9bJoR1pFccNZXPYGWnuSJcLOyMFwdPfTiviNDePnzcrjcn5ziL33j2wqUMMJgc22+0
         Nc4/PKQns5wTS6B3KtMgfAk4aJJB5GwjqhYzgEQCvqqlhuJpAtbHsB5Vm2Y5JgK0iE05
         EOK83I2IkkC4bnF4Ltx5xoYJDwLtnKCZbTQJxUJLHQRpUrBLwuj4TKwtWdadTfqFI/a3
         AfpLXJKxTdV4k52afsvaIPl42ARl7oV18rvf3g01lvkiFycrtaI4TO9x3c/eR3I4BxNH
         E4Eg==
X-Gm-Message-State: AO0yUKXV5sUwLMCLJl7vRo99HrfPCnXVAhaCrHHqSsdjRlkZ76DSL3vr
        zTLSqyEEI3H7/QNjYHPO5MYzCNTT5yCyWL5kBo2JexH/431MS4ptwynEJg==
X-Google-Smtp-Source: AK7set+Aj6jA4kMXw9p7vsPELm43cnWFvS3/a2HCzpZ8bHXDixnTNPk0vbZEYb6n4LPrlpMnjWEsZHLzSPRMqZ5bTx8=
X-Received: by 2002:a25:fe04:0:b0:b1a:64ba:9c9b with SMTP id
 k4-20020a25fe04000000b00b1a64ba9c9bmr1170204ybe.1.1678212818267; Tue, 07 Mar
 2023 10:13:38 -0800 (PST)
MIME-Version: 1.0
References: <20230307005028.2065800-1-grundler@chromium.org>
 <84094771-7f98-0d8d-fe79-7c22e15a602d@gmail.com> <CANEJEGvM_xLrSSjrgKLh_xP+BrFFT+afDQhG8BOdgHPf7eR4gQ@mail.gmail.com>
 <20230307102931.GA25631@wunner.de>
In-Reply-To: <20230307102931.GA25631@wunner.de>
From:   Grant Grundler <grundler@chromium.org>
Date:   Tue, 7 Mar 2023 10:13:26 -0800
Message-ID: <CANEJEGv44GeY=qWiVTJx6tkL-fxs=7vT8uzGm9nPsGirwVBGVQ@mail.gmail.com>
Subject: Re: [PATCH] net: asix: fix modprobe "sysfs: cannot create duplicate filename"
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Grant Grundler <grundler@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Anton Lundin <glance@acc.umu.se>,
        Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 2:29=E2=80=AFAM Lukas Wunner <lukas@wunner.de> wrote=
:
>
> On Mon, Mar 06, 2023 at 10:10:09PM -0800, Grant Grundler wrote:
> > On Mon, Mar 6, 2023 at 7:46???PM Florian Fainelli <f.fainelli@gmail.com=
> wrote:
> > > On 3/6/2023 4:50 PM, Grant Grundler wrote:
> > > > +     priv->phydev =3D mdiobus_get_phy(priv->mdio, priv->phy_addr);
> > > > +     if (priv->phydev)
> > > > +             return 0;
> > >
> > > This was in ax88772_init_phy() before, why is this being moved here n=
ow?
> >
> > Because other drivers I looked at (e.g. tg3 and r8169) do all the mdiob=
us_*
> > calls in one function and I wanted to have some "symmetry"
> > with ax88772_release_mdio() function I added below.
>
> I'd suggest moving this cleanup to a separate commit so that you keep
> the fix itself as small as possible and thus minimize the potential of
> introducing regressions in stable kernels that will receive the fix.

Ok - will do.

> Also, per convention please use the if-clause to catch the error case,
> not the success case.  It doesn't matter if you need two or three more
> lines, readability is more important IMO.

Sure. No problem. The code I wrote seemed easier to read but I'm
familiar with the convention and have no objection to that.

I'll add the Fixes: tag as well (thanks for confirming Oleksij!)

cheers,
grant

>
> Thanks,
>
> Lukas
