Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1803FA164
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 00:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhH0WIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 18:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbhH0WIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 18:08:01 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A38C0613D9
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 15:07:11 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id q21so13898191ljj.6
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 15:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J1gUDdbXfLZQpW8+uzYCzKrHt4z7fUbpEHpLEh39n0k=;
        b=cPJpkzESORon1J7DZsXS+x0HfFUxEhUBlymkGrVP1vP/KnD3XkF/wSMn4Juhiq0LaV
         clxLhjJca3YMk/QoW74bsWwKFKF+TIaZeX9jHb+895y62/c4QrNGBGEmRfcC/QszVUqa
         03P4Vr5P8rlKs/XZR3v0ZCEoNv24qQNbaLmVOPhiM3xHmMtoF1VfppstS+wVRZywn5DF
         m0A6wo5aA3t22sl1sc3u+gQptxjJ+kBxU5TvdXN54zkaAhga56NMJta+4S4fqpHTMP8f
         QDmFIVspsSp4mwJgjgXrNcwOY5tz1twUpNzv/0msqU7HR2GW5zDmXe0TNpObGFHJU1li
         v2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J1gUDdbXfLZQpW8+uzYCzKrHt4z7fUbpEHpLEh39n0k=;
        b=U/Jc3i0d1SihlTbeEHl2GHpoFD85ERBEyrJFjwYeSFjFyihv6H0ksqpZtrZWfJqfIu
         htfsKAe8hVpGWcFoedL5iU8O4XjiA2nRcopDMGaMkibiuzJyCp60Q9rVtfZFJ4Va4IMb
         q9vWNY9N5cDY0Wj837vsiUojZoNw+kL2+Z2mSTL2U+BuCu8MHmgGQbWFHvuIOLXqCyzD
         hlSkWkGnzOH5PHXbmtKTVWLogzn0i9Qq9iu1JGZkWJM3NpZnlz7WDh2fa7/H6a3twDmM
         7DmoRUTfBupGAwuN/sQGCL0zvHqIAP4n5Yutqc9aLhkXXTR1Js1zHL1+fg6EqPN00kbr
         O2wg==
X-Gm-Message-State: AOAM531gQ1PBOJduYAyBWH1aNXpt2+ZOaE6mZIM+ORleBQtvtDLTZWFJ
        Spa0b0XpRAn12w9H8QBAxnHcsTMckBwqJrZX5zfZ+w==
X-Google-Smtp-Source: ABdhPJxnOT+HvC9sFmVTbh+a5YPsytU3QCe1h24AMto3pAWQUC0hVyPRy+77bydlOPd3Lns0bs1oiZXw65gdbw60jwQ=
X-Received: by 2002:a2e:9d88:: with SMTP id c8mr9360420ljj.467.1630102030256;
 Fri, 27 Aug 2021 15:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210822193145.1312668-1-alvin@pqrs.dk> <20210822193145.1312668-2-alvin@pqrs.dk>
 <YSLEZmuWlD5kUOlx@lunn.ch> <cb38f340-a410-26a4-43be-5f549c980ff3@bang-olufsen.dk>
 <YSLazK4TbG5wjHbu@lunn.ch>
In-Reply-To: <YSLazK4TbG5wjHbu@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 28 Aug 2021 00:06:59 +0200
Message-ID: <CACRpkdbUMSJxv+Gmbu2rpsWRMJyTy=ftQqhRuF_4FGb0CV+hqw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free bug
 on module unload
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 1:16 AM Andrew Lunn <andrew@lunn.ch> wrote:

> > No, there isn't. I neglected to mention in the rtl8365mb patch that I
> > reworked the IRQ setup (compared with rtl8366rb) so that it could be
> > torn down in a neat way. So you will see that the new driver does it
> > properly, but I did not touch rtl8366rb because I am not using it. I am
> > happy to do the same to rtl8366rb but I don't think I should make it
> > part of this series. What do you think?
>
> Lets see if Linus has time. He can probably model the change based on
> what you have done here.

I have limited bandwidth as I am effectively on parental leave, so
I can't do much of writing code, but I can certainly test a patch or
two.

Yours,
Linus Walleij
