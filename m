Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4C24BFC26
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 16:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiBVPPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 10:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiBVPPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 10:15:17 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE8213394A
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:14:51 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id v186so41861072ybg.1
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jN84IyhQ+LgdWRqtd7lUvVay/DUmHfKHp5mv+NF+bno=;
        b=hWf49D2cc1xAa4d+bgbY+Oga7rh+MUwZ7eEUe/hiaKp64GiYTWgwiJVu6AePuaj4Tl
         9sZeQT55+rHqoQbXylR1cTJYfbWe6Ce6ql8clWK0gNW5zF9Kno1OJYv6jB81j2wKRxSQ
         HcsdS1gpuKnEd3/loFc3F4loVj0EUeryHwNPzHBMjD2l8IFg8Bn6lKfO1NMmliwTq8ou
         R/1iJoF/McQufw313XFio22O3Mk4wDHOu4tsBeMlcuKray4bT7F9KIlV2GNWKDFSpwQu
         Yo26ubZd5rQwjNuQZMKGj3c5QlRiosQb7INSeeAZWMMshrypdAiGDDuV+o+8LGTMK78w
         FlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jN84IyhQ+LgdWRqtd7lUvVay/DUmHfKHp5mv+NF+bno=;
        b=IxBBjMh9+2U60uK+gkFrPHCROgWiGqNHuPxlURiXnCJw1PxGNPHZYSEpKfsSnNCfix
         bJLH5sPZ3rGbuxAkHuBnLqyCJQYYPUOyQ+47cWrYFNmsqrw5WZYogJe5cXBX6dGBCL+c
         unMHr7O2edz/JcBoOWJUNhR66K9WJNda3cdjPupIjvUIrbkqqMAOfIIM96LmypWtjmLw
         yzgKUU5grwdNtwy1h7qs76THMfDOG2fzbLhtYeG8XZ2hzgeBeKatNykUJp1R132/uxnj
         TZ7d17Oadr99mXI/rLjYb7gp83KW7N5m69H6dF9Wy/wAXnvsLdXoEAamJRatKDnAh3LV
         cm2w==
X-Gm-Message-State: AOAM530QtHEdjvR4gmJK+9yS4ugiJjpTfY+4Vlev6LhjmgPA+thhEGph
        uq5WZKUmUD0HPobiKZY2mkZiRuNdMOVM8fmpQ3g6ZA==
X-Google-Smtp-Source: ABdhPJzCQX/ZTn+euSlhGiTqwhninqZpnHfPL8hOUkqp+hxxA9ki5u9bVgy5r9OEI/1A6NJMQ887ufAIeXBhqY0rWp8=
X-Received: by 2002:a25:9108:0:b0:61e:329:700 with SMTP id v8-20020a259108000000b0061e03290700mr22861242ybl.369.1645542891248;
 Tue, 22 Feb 2022 07:14:51 -0800 (PST)
MIME-Version: 1.0
References: <20220221184631.252308-1-alvin@pqrs.dk> <20220221184631.252308-3-alvin@pqrs.dk>
 <CACRpkdaFgPfv3ybV8HZh7_WaL3AJ6PkUk8Op1D7O3frvpsxNWQ@mail.gmail.com> <871qzviwhp.fsf@bang-olufsen.dk>
In-Reply-To: <871qzviwhp.fsf@bang-olufsen.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 22 Feb 2022 16:14:39 +0100
Message-ID: <CACRpkdatdECPy29Ef1FPBKR==8ECZKN4iTbVQ_-CzQRbMuVf9A@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 1:19 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> w=
rote:
> > On Mon, Feb 21, 2022 at 7:46 PM Alvin =C5=A0ipraga <alvin@pqrs.dk> wrot=
e:

> > What I worry about is whether we need to do a similar patch to
> > rtl8366rb_phy_read() and rtl8366rb_phy_write() in
> > rtl8366rb.c?
>
> Unfortunately I do not have the hardware to test rtl8366rb.c, so I can
> only speculate. But I gave some hints in the commit message which might
> help in checking whether or not it is an issue on that hardware as
> well. The code for rtl8366rb_phy_read() looks similar, but since this is
> a quirk of the hardware design, it could be that it is not
> necessary. The only way is to test.

I can test it.

> If you or somebody else can confirm that it is an issue for RTL8366RB as
> well, I will happily send a patch to the list for testing. You can for
> example try spamming PHY register reads with phytool while also reading
> off switch registers via regmap debugfs. See also the discussion in [1].
>
> [1] https://lore.kernel.org/netdev/878rukib4f.fsf@bang-olufsen.dk/

If you have time to write a patch I'd love testing it!

Yours,
Linus Walleij
