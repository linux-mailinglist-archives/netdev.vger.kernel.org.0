Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080E26861BE
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 09:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjBAIdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 03:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjBAIdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 03:33:41 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16175E5;
        Wed,  1 Feb 2023 00:33:39 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 28DFB24000D;
        Wed,  1 Feb 2023 08:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675240418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+TwIBzQlTlsvHwX2axmKcqN48NoRvr8/6w8iELtG+Mw=;
        b=IPDX1/NGSdhPXvVTU9NKWXtDwTssz6XefD6k1CtYtFBBOecmkfZZElk9PZDWUv9+oiWx6P
        HVE5Hj+UyUoK/LEXWu0rrbX4HcDC2bshcEK31ksWpmMFAs8jHR0XmyryjxRIuTsm8h7Val
        ANOxbia9MkqfZrFp59CT1newgvmqWcOQLGoUImh1v7WeVgC446/SLejA5LuHi5QFyErv+s
        w64zCMfZj5fB/oY+3NJ4bXyPf73CZ1CUOQlraOx62qFIcyKF5eUNRl81SfsHGyCydg6Ldt
        dlLVCc7hQcjLHVPLB7j3ucW+tBAqTO/cbUNRo560pog8cdUPOStQmXN9NTAW4Q==
Date:   Wed, 1 Feb 2023 09:33:32 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [v2] at86rf230: convert to gpio descriptors
Message-ID: <20230201093332.15b0ff9a@xps-13>
In-Reply-To: <CAKdAkRSuDJgdsSQqy9Cc_eUYuOfFsLmBJ8Rd93uQhY6HV8nN4w@mail.gmail.com>
References: <20230126162323.2986682-1-arnd@kernel.org>
        <CAKdAkRQT_Jk5yBeMZqh=M1JscVLFieZTQjLGOGxy8nHh8SnD3A@mail.gmail.com>
        <CAKdAkRSuDJgdsSQqy9Cc_eUYuOfFsLmBJ8Rd93uQhY6HV8nN4w@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

dmitry.torokhov@gmail.com wrote on Tue, 31 Jan 2023 16:50:07 -0800:

> On Tue, Jan 31, 2023 at 3:52 PM Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > Hi Arnd,
> >
> > On Thu, Jan 26, 2023 at 8:32 AM Arnd Bergmann <arnd@kernel.org> wrote: =
=20
> > >
> > >         /* Reset */
> > > -       if (gpio_is_valid(rstn)) {
> > > +       if (rstn) {
> > >                 udelay(1);
> > > -               gpio_set_value_cansleep(rstn, 0);
> > > +               gpiod_set_value_cansleep(rstn, 0);
> > >                 udelay(1);
> > > -               gpio_set_value_cansleep(rstn, 1);
> > > +               gpiod_set_value_cansleep(rstn, 1); =20
> >
> > For gpiod conversions, if we are not willing to chase whether existing
> > DTSes specify polarities
> > properly and create workarounds in case they are wrong, we should use
> > gpiod_set_raw_value*()
> > (my preference would be to do the work and not use "raw" variants).
> >
> > In this particular case, arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> > defines reset line as active low,
> > so you are leaving the device in reset state.

You mean the semantics of gpio_set_value() gpiod_set_value() are
different? Looking at your patch it looks like gpio_set_value() asserts
a physical line state (high or low) while gpiod_set_value() would
actually try to assert a logical state (enabled or disabled) with the
meaning of those being possibly inverted thanks to the DT polarities.
Am I getting this right?

> > Please review your other conversion patches. =20
>=20
> We also can not change the names of requested GPIOs from "reset-gpio"
> to "rstn-gpios" and expect
> this to work.

Yep, missed that indeed.

>=20
> Stefan, please consider reverting this and applying a couple of
> patches I will send out shortly.

If my above understanding is right, then, yeah, the current
patches need to be fixed.

Thanks,
Miqu=C3=A8l
